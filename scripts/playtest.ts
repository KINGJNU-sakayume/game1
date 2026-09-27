// 대본 점검 도구: story/main.ink를 컴파일하고, 태그를 검사하고, 여러 번 끝까지 플레이해 본다.
//   node scripts/playtest.ts                 무작위 + 히로인 집중 플레이 (기본 300회씩)
//   node scripts/playtest.ts --runs 2000     횟수
//   node scripts/playtest.ts --trace seoha   서하 집중 플레이 한 번의 선택 흐름을 출력
// 보고: 엔딩·루트 분포, 태그 경고(중복 제거), 한 번도 지나가지 않은 knot·stitch, 막다른 길.
// Node 22.6 이상 (TypeScript를 바로 실행). src/story의 데이터 파일을 그대로 읽는다.
import { readFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import { fileURLToPath } from 'node:url'
import { Compiler, CompilerOptions, Story } from 'inkjs/full'
import { PEOPLE, ROOMS } from '../src/story/cast.ts'
import { PLACES } from '../src/story/places.ts'
import { VIDEOS } from '../src/story/videos.ts'
import { ENDINGS } from '../src/story/endings.ts'

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..')
const storyDir = resolve(root, 'story')
const args = process.argv.slice(2)
const argValue = (name: string, fallback: string) => {
  const i = args.indexOf(name)
  return i >= 0 && args[i + 1] ? args[i + 1] : fallback
}
const RUNS = Number(argValue('--runs', '300'))
const TRACE = argValue('--trace', '')
const MAX_STEPS = 20000

// ───────── 컴파일 ─────────

function compile(): string {
  const errors: string[] = []
  const warnings: string[] = []
  const fileHandler = {
    ResolveInkFilename: (name: string) => resolve(storyDir, name),
    LoadInkFileContents: (path: string) => readFileSync(path, 'utf8'),
  }
  const mainPath = resolve(storyDir, 'main.ink')
  const compiler = new Compiler(
    readFileSync(mainPath, 'utf8'),
    new CompilerOptions(mainPath, [], false, (message: string, type: number) => {
      if (type === 2) errors.push(message)
      else warnings.push(message)
    }, fileHandler),
  )
  let json = ''
  try {
    json = compiler.Compile().ToJson() ?? ''
  } catch (error) {
    errors.push(String(error))
  }
  for (const w of warnings) console.warn(`[컴파일 경고] ${w}`)
  if (errors.length) {
    for (const e of errors) console.error(`[컴파일 오류] ${e}`)
    process.exit(1)
  }
  return json
}

// ───────── 태그 규칙 ─────────

const LINE_TAGS = new Set([
  'day', 'time', 'room', 'from', 'typing', 'photo', 'big', 'wait', 'scene', 'cut', 'fx', 'fade', 'call', 'video',
  'outgoing', 'unknown', 'noanswer', 'play', 'narr', 'as', 'gallery', 'plan', 'unplan', 'event', 'note', 'page', 'todo', 'done',
  'dayend', 'ask', 'at', 'pin', 'unpin', 'memo', 'voicemail', 'missed', 'post', 'comment', 'unpost', 'town',
  'townreply', 'ending',
])
const CHOICE_TAGS = new Set([
  'say', 'draft', 'act', 'open', 'answer', 'decline', 'keep', 'attach', 'watch', 'go', 'like', 'comment', 'town',
  'text', 'dial', 'facetime', 'in', 'ref',
])
const APP_OF: Record<string, string> = {
  watch: 'tube', go: 'map', like: 'snap', comment: 'snap', town: 'town', text: 'call', dial: 'call', facetime: 'call',
}
const IMAGE_NAME = /^[a-z0-9]+(_[a-z0-9]+)+$/
const endingIds = new Set(ENDINGS.map((e) => e.id))
const isPerson = (id: string) => id in PEOPLE
const isSender = (id: string) => id === 'me' || id === 'system' || isPerson(id)

type Tags = Record<string, string>

/** 엔진(director.ts)의 splitTagBatches와 같은 규칙: 같은 태그 이름이 다시 나오면 끊는다 */
function splitTagBatches(tags: string[] | null): string[][] {
  const batches: string[][] = [[]]
  let keys = new Set<string>()
  for (const raw of tags ?? []) {
    const i = raw.indexOf(':')
    const key = (i < 0 ? raw : raw.slice(0, i)).trim().toLowerCase()
    if (keys.has(key)) {
      batches.push([])
      keys = new Set()
    }
    keys.add(key)
    batches[batches.length - 1].push(raw)
  }
  return batches
}

function parseTags(tags: string[] | null): Tags {
  const out: Tags = {}
  for (const raw of tags ?? []) {
    const i = raw.indexOf(':')
    const key = (i < 0 ? raw : raw.slice(0, i)).trim().toLowerCase()
    if (key) out[key] = i < 0 ? '' : raw.slice(i + 1).trim()
  }
  return out
}

const warnings = new Map<string, number>()
function warn(message: string) {
  warnings.set(message, (warnings.get(message) ?? 0) + 1)
}

// ───────── 한 번 플레이 ─────────

interface SimState {
  photos: Set<string>
  pages: Set<string>
  read: Set<string>
  posts: Set<string>
  town: Set<string>
  day: number
  time: string
  /** 그날 밤 자정을 넘겼다 (시각 검사용) */
  afterMidnight: boolean
  room: string
  stage: string | null
  stageAt: string
  ending: string | null
  lines: number
  choices: number
}

type Policy = (story: Story, sim: SimState) => number

const compiled = compile()
const probe = new Story(compiled)
const knotNames = new Set<string>()
{
  const named = (probe.mainContentContainer as unknown as { namedContent: Map<string, { namedContent?: Map<string, unknown> }> }).namedContent
  // system.ink의 함수는 knot 목록에서 뺀다
  const functions = new Set(['raise', 'study', 'saved', 'read'])
  for (const [knot, container] of named) {
    if (knot.startsWith('global ') || functions.has(knot)) continue
    knotNames.add(knot)
    for (const stitch of container.namedContent?.keys() ?? []) knotNames.add(`${knot}.${stitch}`)
  }
}
const visited = new Map<string, number>()

function newStory(sim: SimState): Story {
  const story = new Story(compiled)
  story.BindExternalFunction('saved', (name: string) => sim.photos.has(name), true)
  story.BindExternalFunction('read', (title: string) => sim.read.has(title), true)
  return story
}

function freshSim(): SimState {
  return {
    photos: new Set(), pages: new Set(), read: new Set(), posts: new Set(), town: new Set(),
    day: 1, time: '00:00', afterMidnight: false, room: 'dangol', stageAt: '', stage: null, ending: null, lines: 0, choices: 0,
  }
}

function where(story: Story) {
  return story.state.currentPathString ?? '?'
}

/** 이제 읽을 곳(Continue 직전의 위치)을 기록한다 */
function markVisit(story: Story) {
  const path = story.state.currentPathString
  if (!path) return
  const parts = path.split('.')
  const knot = parts[0]
  if (knot) visited.set(knot, (visited.get(knot) ?? 0) + 1)
  if (parts[1] && !/^\d+$/.test(parts[1]) && parts[1] !== 'c-0') visited.set(`${knot}.${parts[1]}`, (visited.get(`${knot}.${parts[1]}`) ?? 0) + 1)
}

/** 한 줄의 태그를 검사하고 시뮬레이션 상태에 반영 */
function lineTags(text: string, t: Tags, sim: SimState, story: Story, check: boolean) {
  const at = where(story)
  for (const key of Object.keys(t)) if (check && !LINE_TAGS.has(key)) warn(`모르는 줄 태그 #${key} (${at})`)
  // 엔진과 같은 순서: 닫는 태그를 먼저 처리하고 하루 결산을 검사한다
  if (t.scene === 'end' || t.call === 'end' || t.play === 'end') sim.stage = null
  if (t.dayend !== undefined && sim.stage && check) warn(`${sim.stage}이 닫히지 않은 채 하루가 끝남 (연 곳: ${sim.stageAt})`)
  if (t.day !== undefined) {
    const day = Number(t.day)
    if (check && !(day >= 1)) warn(`잘못된 day: ${t.day} (${at})`)
    if (day !== sim.day) {
      sim.time = '00:00'
      sim.afterMidnight = false
    }
    sim.day = day
  }
  if (t.time !== undefined) {
    if (check && !/^\d{1,2}:\d{2}$/.test(t.time)) warn(`잘못된 time: ${t.time} (${at})`)
    const time = t.time.padStart(5, '0')
    // 밤 8시 이후에서 새벽 6시 전으로 가는 건 자정을 넘긴 것
    const pastMidnight = sim.time >= '20:00' && time < '06:00'
    if (check && time < sim.time && !pastMidnight && !sim.afterMidnight) warn(`시각이 거꾸로 감: D${sim.day} ${sim.time} → ${time} (${at})`)
    if (check && sim.afterMidnight && time < sim.time) warn(`시각이 거꾸로 감(자정 뒤): D${sim.day} ${sim.time} → ${time} (${at})`)
    if (pastMidnight) sim.afterMidnight = true
    sim.time = time
  }
  if (t.room !== undefined) {
    if (check && !(t.room in ROOMS)) warn(`모르는 room: ${t.room} (${at})`)
    sim.room = t.room
  }
  if (check && t.from !== undefined && !isSender(t.from)) warn(`모르는 from: ${t.from} (${at})`)
  for (const key of ['photo', 'scene', 'cut', 'gallery'] as const) {
    const v = t[key]
    if (v && v !== 'end' && check && !IMAGE_NAME.test(v)) warn(`이미지 이름 규칙 위반 #${key}: ${v} (${at})`)
  }
  if (t.gallery) sim.photos.add(t.gallery)
  if (t.scene !== undefined) {
    if (t.scene !== 'end' && !sim.stage) sim.stageAt = at
    sim.stage = t.scene === 'end' ? null : 'scene'
  }
  if (t.play !== undefined) {
    if (t.play !== 'end' && check && !(t.play in VIDEOS)) warn(`모르는 영상 #play: ${t.play} (${at})`)
    if (t.play !== 'end') sim.stageAt = at
    sim.stage = t.play === 'end' ? null : 'video'
  }
  if (t.call !== undefined) {
    if (t.call === 'end') sim.stage = null
    else {
      if (check && !isPerson(t.call)) warn(`모르는 call: ${t.call} (${at})`)
      sim.stage = 'call'
      sim.stageAt = at
    }
  }
  if (check && t.plan !== undefined) {
    const [id, day, time] = t.plan.split(',').map((s) => s.trim())
    if (!id || !(Number(day) > 0) || !/^\d{1,2}:\d{2}$/.test(time ?? '')) warn(`잘못된 plan: ${t.plan} (${at})`)
  }
  if (check && t.event !== undefined) {
    const [id, day] = t.event.split(',').map((s) => s.trim())
    if (!id || !(Number(day) > 0)) warn(`잘못된 event: ${t.event} (${at})`)
  }
  for (const key of ['at', 'pin'] as const) {
    if (t[key] === undefined) continue
    const places = key === 'at' ? [t[key].split(',')[0].trim()] : t[key].split(',').map((s) => s.trim())
    for (const p of places) if (check && !(p in PLACES)) warn(`모르는 장소 #${key}: ${p} (${at})`)
  }
  for (const key of ['memo', 'voicemail', 'missed'] as const) {
    if (t[key] !== undefined && check && !isPerson(t[key])) warn(`모르는 인물 #${key}: ${t[key]} (${at})`)
  }
  if (t.page !== undefined && text) sim.pages.add(t.page)
  if (t.post !== undefined && text) {
    if (!sim.posts.has(t.post) && check && (!t.from || !isPerson(t.from))) warn(`스냅 게시물에 # from: 인물이 없음: ${t.post} (${at})`)
    sim.posts.add(t.post)
  }
  if (t.comment !== undefined && text && check && !sim.posts.has(t.comment)) warn(`없는 스냅 게시물에 댓글: ${t.comment} (${at})`)
  if (t.town !== undefined && text) {
    const [id, cat, author] = t.town.split(',').map((s) => s.trim())
    if (!sim.town.has(id) && check && (!cat || !author)) warn(`망원살이 글을 처음 쓸 때는 분류·글쓴이가 필요: ${t.town} (${at})`)
    sim.town.add(id)
  }
  if (t.townreply !== undefined && text && check && !sim.town.has(t.townreply.split(',')[0].trim())) {
    warn(`없는 망원살이 글에 댓글: ${t.townreply} (${at})`)
  }
  if (t.ending !== undefined) {
    if (check && !endingIds.has(t.ending)) warn(`모르는 엔딩: ${t.ending} (${at})`)
    sim.ending = t.ending
  }
  // 대화방 줄 검사 (앱 기록으로 가는 줄·무대 대사 제외)
  const consumed = ['note', 'page', 'memo', 'voicemail', 'post', 'comment', 'town', 'townreply'].some((k) => t[k] !== undefined)
  if (text && !consumed && !sim.stage && check) {
    const group = (ROOMS as Record<string, { group: boolean }>)[sim.room]?.group
    if (group && t.from === undefined) warn(`단톡방 줄에 # from: 없음: "${text.slice(0, 20)}" (${at})`)
  }
}

function choiceTags(story: Story, sim: SimState, check: boolean) {
  const at = where(story)
  const apps = new Set<string>()
  story.currentChoices.forEach((choice) => {
    const t = parseTags(choice.tags)
    for (const key of Object.keys(t)) if (check && !CHOICE_TAGS.has(key)) warn(`모르는 선택지 태그 #${key} (${at})`)
    for (const [tag, app] of Object.entries(APP_OF)) {
      if (t[tag] === undefined) continue
      apps.add(app)
      const ref = t[tag]
      if (!check) continue
      if (tag === 'watch' && !(ref in VIDEOS)) warn(`모르는 영상 #watch: ${ref} (${at})`)
      if (tag === 'go' && !(ref in PLACES)) warn(`모르는 장소 #go: ${ref} (${at})`)
      if ((tag === 'like' || tag === 'comment') && !sim.posts.has(ref)) warn(`아직 없는 스냅 게시물 #${tag}: ${ref} (${at})`)
      if (tag === 'town' && !sim.town.has(ref)) warn(`아직 없는 망원살이 글 #town: ${ref} (${at})`)
      if (['text', 'dial', 'facetime'].includes(tag) && !isPerson(ref)) warn(`모르는 인물 #${tag}: ${ref} (${at})`)
    }
    if (t.in !== undefined) apps.add(t.in)
    if (check && t.attach && !sim.photos.has(t.attach)) warn(`사진첩에 없는 사진을 보내려 함 #attach: ${t.attach} (${at}) — {saved()} 조건을 붙일 것`)
    if (check && sim.stage && (Object.keys(APP_OF).some((k) => t[k] !== undefined) || t.in !== undefined)) {
      warn(`대면·통화·영상 중에는 앱 선택지를 쓸 수 없음 (${at})`)
    }
  })
  if (check && apps.size > 1) warn(`한 선택지 묶음에 앱이 여럿: ${[...apps].join(', ')} (${at})`)
}

interface RunResult {
  ending: string | null
  route: string | null
  vars: Record<string, number | boolean | string>
  atRoute: Record<string, number | boolean | string> | null
  lines: number
  choices: number
  stuck: string | null
  trace: string[]
}

const WATCH_VARS = [
  'aff_seoha', 'aff_ian', 'aff_daon', 'skill',
  'f_seoha_key', 'f_ian_key', 'f_daon_key',
]

function readVars(story: Story, names: string[]) {
  const out: Record<string, number | boolean | string> = {}
  for (const name of names) {
    try {
      out[name] = story.variablesState.$(name) as number
    } catch {
      // 없는 변수
    }
  }
  return out
}

function play(policy: Policy, options: { check: boolean; savePhotos: number; readPages: number; trace?: boolean }): RunResult {
  const sim = freshSim()
  const story = newStory(sim)
  let steps = 0
  let route: string | null = null
  let atRoute: RunResult['atRoute'] = null
  const trace: string[] = []
  while (steps++ < MAX_STEPS) {
    if (story.canContinue) {
      markVisit(story)
      const before = where(story)
      const text = (story.Continue() ?? '').trim()
      if (story.hasError) {
        warn(`실행 오류: ${story.currentErrors?.join(' / ')} (${where(story)})`)
        story.ResetErrors()
      }
      const batches = splitTagBatches(story.currentTags)
      for (const early of batches.slice(0, -1)) lineTags('', parseTags(early), sim, story, options.check)
      const t = parseTags(batches[batches.length - 1])
      lineTags(text, t, sim, story, options.check)
      // 받은 사진은 일정 확률로 저장, 수첩 쪽은 일정 확률로 읽음
      if (t.photo && t.post === undefined && Math.random() < options.savePhotos) sim.photos.add(t.photo)
      if (t.page && Math.random() < options.readPages) sim.read.add(t.page)
      if (text) sim.lines++
      if (!route && /^(seoha|ian|daon|alone)_d\d+/.test(before)) {
        route = before.split('_')[0]
        atRoute = readVars(story, WATCH_VARS)
      }
      if (!atRoute && (sim.day >= 6 || sim.ending)) atRoute = readVars(story, WATCH_VARS)
      if (options.trace && text && (t.from === undefined || t.from !== 'system')) trace.push(`  ${text.slice(0, 60)}`)
      continue
    }
    if (story.currentChoices.length > 0) {
      choiceTags(story, sim, options.check)
      // 앞으로 쓸 수 있는 수첩 쪽은 선택 전에 읽을 기회가 있다
      for (const page of sim.pages) if (Math.random() < options.readPages) sim.read.add(page)
      const index = policy(story, sim)
      if (options.trace) {
        const labels = story.currentChoices.map((c, i) => `${i === index ? '▶' : ' '} ${c.text.trim()}`)
        trace.push(`[D${sim.day} ${sim.time}] ${labels.join(' | ')}`)
      }
      // 거절하면 엔진이 통화 화면을 닫는다
      if (parseTags(story.currentChoices[index].tags).decline !== undefined) sim.stage = null
      story.ChooseChoiceIndex(index)
      sim.choices++
      continue
    }
    break
  }
  const stuck = steps >= MAX_STEPS ? `무한 반복 의심 (${where(story)})` : sim.ending ? null : `엔딩 없이 끝남 (D${sim.day} ${sim.time}, ${where(story)})`
  return {
    ending: sim.ending,
    route,
    vars: readVars(story, WATCH_VARS),
    atRoute,
    lines: sim.lines,
    choices: sim.choices,
    stuck,
    trace,
  }
}

// ───────── 정책 ─────────

const randomPolicy: Policy = (story) => Math.floor(Math.random() * story.currentChoices.length)

/** 그 히로인 호감이 가장 많이 오르는 선택 (앞을 몇 걸음 무작위로 굴려 본다). 'all'이면 세 사람 호감의 합 */
function focusPolicy(heroine: 'seoha' | 'ian' | 'daon' | 'all'): Policy {
  const heroines = heroine === 'all' ? ['seoha', 'ian', 'daon'] : [heroine]
  const score = (story: Story) => {
    let value = 0
    for (const h of heroines) value += Number(story.variablesState.$(`aff_${h}`) ?? 0)
    // 루트·엔딩 플래그도 조금 친다
    for (const name of story.variablesState['_globalVariables']?.keys?.() ?? []) {
      if (typeof name !== 'string' || story.variablesState.$(name) !== true) continue
      if (heroines.some((h) => name.startsWith(`f_${h}`))) value += 3
    }
    return value
  }
  return (story, sim) => {
    const n = story.currentChoices.length
    if (n === 1) return 0
    const saved = story.state.ToJson()
    const savedSim = { photos: new Set(sim.photos), read: new Set(sim.read) }
    const base = score(story)
    let best = 0
    let bestValue = -Infinity
    for (let i = 0; i < n; i++) {
      let total = 0
      const tries = 3
      for (let k = 0; k < tries; k++) {
        story.state.LoadJson(saved)
        story.ChooseChoiceIndex(i)
        // 다음 선택 두 개까지 무작위로 굴린다
        let depth = 0
        let guard = 0
        while (guard++ < 400) {
          if (story.canContinue) {
            story.Continue()
            continue
          }
          if (story.currentChoices.length > 0 && depth < 2) {
            story.ChooseChoiceIndex(Math.floor(Math.random() * story.currentChoices.length))
            depth++
            continue
          }
          break
        }
        total += score(story) - base
      }
      const value = total / tries + Math.random() * 0.01
      if (value > bestValue) {
        bestValue = value
        best = i
      }
    }
    story.state.LoadJson(saved)
    sim.photos = savedSim.photos
    sim.read = savedSim.read
    return best
  }
}

// ───────── 실행 ─────────

function summarize(name: string, results: RunResult[]) {
  const count = (key: (r: RunResult) => string) => {
    const map = new Map<string, number>()
    for (const r of results) map.set(key(r), (map.get(key(r)) ?? 0) + 1)
    return [...map.entries()].sort((a, b) => b[1] - a[1]).map(([k, v]) => `${k} ${((v / results.length) * 100).toFixed(1)}%`).join(', ')
  }
  const avg = (f: (r: RunResult) => number) => (results.reduce((s, r) => s + f(r), 0) / results.length).toFixed(0)
  console.log(`\n■ ${name} (${results.length}회)`)
  console.log(`  루트: ${count((r) => r.route ?? '(루트 전 종료)')}`)
  console.log(`  엔딩: ${count((r) => r.ending ?? '(없음)')}`)
  console.log(`  평균 대사 ${avg((r) => r.lines)}줄 · 선택 ${avg((r) => r.choices)}번 · 최대 대사 ${Math.max(...results.map((r) => r.lines))}줄`)
  const at = results.filter((r) => r.atRoute)
  if (at.length) {
    const mean = (v: string) => (at.reduce((s, r) => s + Number(r.atRoute![v] ?? 0), 0) / at.length).toFixed(1)
    console.log(`  루트 결정 때 평균 호감: 서하 ${mean('aff_seoha')} · 이안 ${mean('aff_ian')} · 다온 ${mean('aff_daon')} · 실력 ${mean('skill')}`)
  }
  const stuck = results.filter((r) => r.stuck)
  if (stuck.length) {
    const kinds = new Map<string, number>()
    for (const r of stuck) kinds.set(r.stuck!, (kinds.get(r.stuck!) ?? 0) + 1)
    for (const [k, v] of kinds) console.log(`  ⚠ ${k} ×${v}`)
  }
}

if (TRACE) {
  const policy = TRACE === 'random' ? randomPolicy : focusPolicy(TRACE as 'seoha' | 'ian' | 'daon' | 'all')
  const r = play(policy, { check: true, savePhotos: 1, readPages: 1, trace: true })
  console.log(r.trace.join('\n'))
  console.log(`\n엔딩: ${r.ending} · 루트: ${r.route} · ${JSON.stringify(r.vars)}`)
  process.exit(0)
}

const t0 = Date.now()
const random = Array.from({ length: RUNS }, () => play(randomPolicy, { check: true, savePhotos: 0.5, readPages: 0.03 }))
summarize('무작위 플레이', random)
{
  const runs = Math.max(20, Math.floor(RUNS / 5))
  const nice = Array.from({ length: runs }, () => play(focusPolicy('all'), { check: false, savePhotos: 0.7, readPages: 0.2 }))
  summarize('모두에게 친절한 플레이', nice)
}
for (const heroine of ['seoha', 'ian', 'daon'] as const) {
  const runs = Math.max(20, Math.floor(RUNS / 5))
  const focused = Array.from({ length: runs }, () => play(focusPolicy(heroine), { check: false, savePhotos: 1, readPages: 1 }))
  summarize(`${PEOPLE[heroine].name} 집중 플레이`, focused)
}

const unseen = [...knotNames].filter((k) => !visited.has(k)).sort()
console.log(`\n■ 한 번도 지나가지 않은 knot·stitch (${unseen.length}/${knotNames.size})`)
if (unseen.length) console.log('  ' + unseen.join(', '))

console.log(`\n■ 태그 경고 (${warnings.size}종)`)
for (const [message, n] of [...warnings.entries()].sort()) console.log(`  ${message}${n > 1 ? ` ×${n}` : ''}`)
console.log(`\n(${((Date.now() - t0) / 1000).toFixed(1)}초)`)
