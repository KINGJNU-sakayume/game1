// 연출 엔진: ink 대본을 한 줄씩 읽어 태그대로 메시지·입력 중 표시·추천 답장을 보여준다.
// 문법은 docs/05_스크립트_문법.md 참조.
import { Story } from 'inkjs'
import storyData from '../../story/main.ink'
import {
  DEFAULT_READ_DELAY,
  HEROINES,
  PEOPLE,
  READ_DELAY,
  ROOMS,
  affectionStage,
  isHeroine,
  isRoomId,
  isSenderId,
} from '../story/cast'
import type { HeroineId, PersonId, RoomId, SenderId } from '../story/cast'
import { load, loadSettings, save } from '../state/storage'
import { EMPTY_JOURNAL, hasUnreadMine, markRead, pushMessage, savePhoto, setStage, store, syncMessageIds, updateJournal } from './store'
import type { CallRecord, ChoiceOption, Note, PendingChoice, Stats } from './store'
import { loadResume, rewindTo, saveDay, saveResume } from './save'
import type { Snapshot } from './save'

const SPEED = { slow: 1.6, normal: 1, fast: 0.5 } as const

class Cancelled extends Error {}

type Tags = Record<string, string>

/** "room: dangol" → { room: 'dangol' }, "big" → { big: '' } */
export function parseTags(tags: string[] | null): Tags {
  const out: Tags = {}
  for (const raw of tags ?? []) {
    const i = raw.indexOf(':')
    const key = (i < 0 ? raw : raw.slice(0, i)).trim().toLowerCase()
    if (key) out[key] = i < 0 ? '' : raw.slice(i + 1).trim()
  }
  return out
}

function warn(message: string) {
  if (import.meta.env.DEV) console.warn(`[대본] ${message}`)
}

/** 메시지 길이에 따른 기본 입력 시간 (초) */
function autoTypingSeconds(text: string) {
  return Math.min(3, Math.max(0.8, 0.5 + text.length * 0.06))
}

let story: Story | null = null
let generation = 0
let currentRoom: RoomId = 'dangol'
/** 괄호 없이 쓴 선택지는 ink가 선택한 글을 한 줄로 다시 출력한다. 그 줄은 건너뛴다 */
let lastChosen: string | null = null
let pendingResolve: ((option: ChoiceOption) => void) | null = null
let pendingKind: PendingChoice['kind'] = 'reply'
/** 흐름도에 남길, 지금 떠 있는 선택지의 장소 */
let pendingContext = ''
let pendingOptions: ChoiceOption[] = []
let summaryResolve: (() => void) | null = null
/** # ask: 로 정한 다음 menu 선택지의 제목 */
let pendingAsk: string | null = null
let cleanupChoice: (() => void) | null = null
/** 대면·통화 대사에서 탭을 기다리는 중 */
let advanceResolve: (() => void) | null = null
let nextLineId = 1
let nextCallId = 1
let fxKey = 0

function sleep(seconds: number, gen: number, scaled = true): Promise<void> {
  const factor = scaled ? SPEED[loadSettings().textSpeed] : 1
  return new Promise((resolve, reject) => {
    window.setTimeout(() => (gen === generation ? resolve() : reject(new Cancelled())), seconds * factor * 1000)
  })
}

function readNumber(name: string): number {
  try {
    const value = story?.variablesState.$(name)
    return typeof value === 'number' ? value : 0
  } catch {
    return 0
  }
}

/** ink 변수 → 화면 상태 */
function syncStats() {
  const aff = {} as Record<HeroineId, number>
  for (const id of HEROINES) aff[id] = Math.min(100, Math.max(0, readNumber(`aff_${id}`)))
  const next: Stats = { aff, skill: readNumber('skill') }
  const prev = store.get().stats
  if (prev.skill !== next.skill || HEROINES.some((id) => prev.aff[id] !== next.aff[id])) store.set({ stats: next })
}

/** 상대가 주인공 메시지를 읽기까지 걸리는 시간 (초) */
function readDelay(from: SenderId): number {
  if (!isHeroine(from)) return DEFAULT_READ_DELAY
  return READ_DELAY[from][affectionStage(store.get().stats.aff[from]) - 1]
}

function snapshot(): Snapshot {
  const s = store.get()
  return {
    stage: s.stage && !s.stage.ending ? s.stage : null,
    calls: s.calls,
    journal: s.journal,
    version: 1,
    day: s.clock.day,
    ink: story!.state.ToJson(),
    messageCount: s.messages.length,
    clock: s.clock,
    unread: s.unread,
    room: currentRoom,
    savedAt: Date.now(),
  }
}

function isPerson(id: string): id is PersonId {
  return isSenderId(id) && id !== 'me' && id !== 'system'
}

/** 대면·통화 중 탭을 기다린다 */
function waitAdvance(gen: number): Promise<void> {
  return new Promise((resolve, reject) => {
    advanceResolve = () => (gen === generation ? resolve() : reject(new Cancelled()))
  })
}

async function startScene(image: string | null, gen: number) {
  const stage = store.get().stage
  if (stage?.kind === 'scene' && !stage.ending) {
    setStage({ image, black: false, fx: null })
    return
  }
  // 폰 화면이 꺼지듯 어두워진 뒤 컷이 나타난다 (연출 시간은 텍스트 속도와 무관)
  store.set({
    banner: null,
    stage: { kind: 'scene', image, black: false, fx: null, line: null, call: null, ending: false },
  })
  await sleep(1.0, gen, false)
}

async function endStage(gen: number) {
  if (!store.get().stage) return
  setStage({ ending: true, line: null })
  await sleep(0.6, gen, false)
  store.set({ stage: null })
}

function connectCall() {
  const call = store.get().stage?.call
  if (call) setStage({ call: { ...call, state: 'connected', startedAt: Date.now() } })
}

function recordCall(kind: CallRecord['kind']) {
  const s = store.get()
  const call = s.stage?.call
  if (!call) return
  const seconds = call.startedAt ? Math.round((Date.now() - call.startedAt) / 1000) : 0
  const record: CallRecord = { id: nextCallId++, who: call.who, video: call.video, kind, day: s.clock.day, time: s.clock.time, seconds }
  store.set({ calls: [...s.calls, record] })
}

async function startCall(who: PersonId, video: boolean, outgoing: boolean, gen: number) {
  store.set({
    banner: null,
    stage: {
      kind: 'call',
      image: null,
      black: false,
      fx: null,
      line: null,
      call: { who, video, outgoing, state: outgoing ? 'connecting' : 'ringing', startedAt: null },
      ending: false,
    },
  })
  if (outgoing) {
    await sleep(1.8, gen, false)
    connectCall()
  }
}

/** 대면·통화 무대의 연출 태그 */
async function handleStageTags(tags: Tags, gen: number) {
  if (tags.scene !== undefined) {
    if (tags.scene === 'end') await endStage(gen)
    else await startScene(tags.scene || null, gen)
  }
  if (tags.call !== undefined) {
    if (tags.call === 'end') {
      const call = store.get().stage?.call
      if (call) {
        recordCall(call.outgoing ? 'outgoing' : 'incoming')
        await endStage(gen)
      }
    } else if (isPerson(tags.call)) {
      await startCall(tags.call, tags.video !== undefined, tags.outgoing !== undefined, gen)
    } else warn(`알 수 없는 call: ${tags.call}`)
  }
  if (!store.get().stage) return
  if (tags.cut !== undefined) setStage({ image: tags.cut || null, black: false, fx: null })
  if (tags.fx !== undefined) {
    if (tags.fx === 'zoom' || tags.fx === 'shake') setStage({ fx: { type: tags.fx, key: ++fxKey } })
    else warn(`알 수 없는 fx: ${tags.fx}`)
  }
  if (tags.fade !== undefined) {
    setStage({ black: true })
    await sleep(1.2, gen, false)
  }
}

/** "a, b, c" → ['a', 'b', 'c'] (ink 태그 안에는 | 를 쓸 수 없어 쉼표로 나눈다) */
function splitArgs(value: string): string[] {
  return value.split(',').map((part) => part.trim())
}

function appendNote(kind: Note['kind'], title: string, text: string) {
  const { day, time } = store.get().clock
  updateJournal((j) => {
    const i = j.notes.findIndex((n) => n.kind === kind && n.title === title)
    if (i < 0) return { notes: [...j.notes, { kind, title, body: [text], day, time }] }
    const notes = [...j.notes]
    notes[i] = { ...notes[i], body: [...notes[i].body, text] }
    return { notes }
  })
}

/** 사진첩·캘린더·메모 태그. 이 줄이 메모로 쓰였으면 true (메신저·무대에 나오지 않음) */
function handleJournalTags(text: string, tags: Tags): boolean {
  if (tags.gallery) savePhoto(tags.gallery, null)
  if (tags.plan !== undefined) {
    const [id, dayText, time, ...rest] = splitArgs(tags.plan)
    const day = Number.parseInt(dayText, 10)
    if (id && day > 0 && /^\d{1,2}:\d{2}$/.test(time ?? '')) {
      const plan = { id, day, time: time.padStart(5, '0'), title: rest.join(', ') || id }
      updateJournal((j) => ({ plans: [...j.plans.filter((p) => p.id !== id), plan] }))
    } else warn(`잘못된 plan: ${tags.plan} (형식: id, 날짜, HH:MM, 제목)`)
  }
  if (tags.unplan) updateJournal((j) => ({ plans: j.plans.filter((p) => p.id !== tags.unplan) }))
  if (tags.todo !== undefined) {
    const [id, ...rest] = splitArgs(tags.todo)
    const todoText = rest.join(', ') || text
    if (id && todoText) updateJournal((j) => ({ todos: [...j.todos.filter((t) => t.id !== id), { id, text: todoText, done: false }] }))
    else warn(`잘못된 todo: ${tags.todo} (형식: id, 내용)`)
  }
  if (tags.done) updateJournal((j) => ({ todos: j.todos.map((t) => (t.id === tags.done ? { ...t, done: true } : t)) }))
  if (text && tags.note !== undefined) {
    appendNote('note', tags.note || '메모', text)
    return true
  }
  if (text && tags.page !== undefined) {
    appendNote('page', tags.page || '수첩', text)
    return true
  }
  return false
}

/** 하루 결산 화면을 띄우고 닫을 때까지 기다린다 */
function showSummary(gen: number): Promise<void> {
  store.set({ summary: { day: store.get().clock.day }, banner: null })
  return new Promise((resolve, reject) => {
    summaryResolve = () => (gen === generation ? resolve() : reject(new Cancelled()))
  })
}

/** 대면·통화 중 대사 한 줄: 탭하면 넘어간다 */
async function stageLine(text: string, tags: Tags, gen: number) {
  const stage = store.get().stage!
  if (stage.call?.state === 'ringing') {
    warn('받기/거절 선택지 없이 통화 대사가 나와 자동으로 연결합니다')
    connectCall()
  }
  let speaker: SenderId | null = stage.kind === 'call' ? stage.call!.who : null
  if (tags.from !== undefined) {
    if (isSenderId(tags.from)) speaker = tags.from === 'system' ? null : tags.from
    else warn(`알 수 없는 from: ${tags.from}`)
  }
  setStage({ line: { id: nextLineId++, speaker, text } })
  // 바로 뒤에 선택지가 오면 탭을 기다리지 않고 선택지를 함께 보여준다
  if (!story!.canContinue && story!.currentChoices.length > 0) return
  await waitAdvance(gen)
}

function resolveSender(tag: string | undefined, room: RoomId): SenderId {
  if (tag !== undefined) {
    if (isSenderId(tag)) return tag
    warn(`알 수 없는 from: ${tag}`)
  }
  const info = ROOMS[room]
  if (!info.group) return info.members[0]
  warn(`단톡방(${room}) 메시지에 # from: 이 없습니다`)
  return 'system'
}

/** 한 줄을 처리한다. 날짜가 바뀌었으면 true */
async function handleLine(text: string, tags: Tags, gen: number): Promise<boolean> {
  // 하루 결산은 같은 줄의 # day: 보다 먼저 (태그만 있는 줄은 다음 날 첫 줄에 붙기 때문)
  if (tags.dayend !== undefined) await showSummary(gen)
  let newDay = false
  if (tags.day !== undefined) {
    const day = Number.parseInt(tags.day, 10)
    if (day > 0) {
      // 처음 시작한 대본의 첫 날짜도 시작 지점으로 남긴다
      newDay = day !== store.get().clock.day || store.get().messages.length === 0
      store.set((s) => ({ clock: { ...s.clock, day } }))
    } else warn(`잘못된 day: ${tags.day}`)
  }
  if (tags.time !== undefined) {
    if (/^\d{1,2}:\d{2}$/.test(tags.time)) store.set((s) => ({ clock: { ...s.clock, time: tags.time.padStart(5, '0') } }))
    else warn(`잘못된 time: ${tags.time}`)
  }
  if (tags.room !== undefined) {
    if (isRoomId(tags.room)) currentRoom = tags.room
    else warn(`알 수 없는 room: ${tags.room}`)
  }
  if (tags.wait !== undefined) await sleep(Number.parseFloat(tags.wait) || 0, gen)
  await handleStageTags(tags, gen)
  const consumed = handleJournalTags(text, tags)
  if (tags.ask) pendingAsk = tags.ask

  if (!text || consumed) return newDay
  if (lastChosen !== null && text === lastChosen && tags.from === undefined) {
    lastChosen = null
    return newDay
  }
  lastChosen = null

  const stage = store.get().stage
  if (stage && !stage.ending) {
    await stageLine(text, tags, gen)
    return newDay
  }

  const room = currentRoom
  const from = resolveSender(tags.from, room)
  if (from === 'me' || from === 'system') {
    await sleep(0.35, gen)
  } else {
    // 1:1 방에서 상대가 답하기 전에 주인공 메시지를 읽는다 (답장 속도 = 호감 신호).
    // # wait: 가 있으면 그 시간을 읽는 시간으로 본다
    if (!ROOMS[room].group && hasUnreadMine(room)) {
      if (tags.wait === undefined) await sleep(readDelay(from), gen)
      markRead(room)
    }
    store.set((s) => ({ typing: { ...s.typing, [room]: from } }))
    const seconds = tags.typing !== undefined ? Number.parseFloat(tags.typing) || 0 : autoTypingSeconds(text)
    try {
      await sleep(seconds, gen)
    } finally {
      if (gen === generation) store.set((s) => ({ typing: { ...s.typing, [room]: undefined } }))
    }
  }

  pushMessage({
    room,
    from,
    text,
    ...(tags.photo ? { photo: tags.photo } : {}),
    ...(tags.big !== undefined ? { big: true } : {}),
  })
  return newDay
}

function askChoice(): Promise<ChoiceOption> {
  const options: ChoiceOption[] = story!.currentChoices.map((choice) => {
    const t = parseTags(choice.tags)
    const openRoom = t.open !== undefined && isRoomId(t.open) ? t.open : null
    if (t.open !== undefined && !openRoom) warn(`알 수 없는 open: ${t.open}`)
    return {
      index: choice.index,
      label: choice.text.trim(),
      say: t.say || null,
      draft: t.draft || null,
      act: t.act !== undefined,
      openRoom,
      answer: t.answer !== undefined,
      decline: t.decline !== undefined,
      keep: t.keep !== undefined,
    }
  })
  const stage = store.get().stage
  const kind: PendingChoice['kind'] =
    stage?.call?.state === 'ringing' && options.some((o) => o.answer || o.decline)
      ? 'call'
      : stage
        ? 'stage'
        : options.every((o) => o.openRoom)
          ? 'open'
          : options.every((o) => o.act)
            ? 'menu'
            : 'reply'
  const title = kind === 'menu' ? (pendingAsk ?? '무엇을 할까?') : undefined
  pendingAsk = null
  pendingKind = kind
  pendingOptions = options
  const who = stage?.call ? PEOPLE[stage.call.who].name : ''
  const contexts: Record<PendingChoice['kind'], string> = {
    reply: ROOMS[currentRoom].name,
    menu: title ?? '',
    open: '먼저 연 대화방',
    call: `${who} 전화`,
    stage: stage?.kind === 'call' ? `${who} 통화` : '대면',
  }
  pendingContext = contexts[kind]
  // 선택지 앞은 다시 불러와도 똑같이 이어지는 지점이므로 여기서 이어하기 저장
  saveResume(snapshot(), store.get().messages)

  return new Promise((resolve) => {
    pendingResolve = resolve
    store.set({ choice: { kind, room: kind === 'reply' ? currentRoom : null, options, title } })
    if (kind === 'open') {
      // 먼저 연 방이 곧 선택이다
      const check = () => {
        const viewing = store.get().viewingRoom
        const picked = options.find((o) => o.openRoom === viewing)
        if (picked) director.choose(picked.index)
      }
      cleanupChoice = store.subscribe(check)
      check()
    }
  })
}

async function typeInto(room: RoomId, text: string, gen: number) {
  const chars = Array.from(text)
  const step = Math.min(0.05, 1.2 / Math.max(chars.length, 1))
  for (let i = 1; i <= chars.length; i++) {
    store.set({ composing: { room, text: chars.slice(0, i).join('') } })
    await sleep(step, gen)
  }
}

async function eraseFrom(room: RoomId, text: string, gen: number) {
  const chars = Array.from(text)
  const step = Math.min(0.03, 0.6 / Math.max(chars.length, 1))
  for (let i = chars.length - 1; i >= 0; i--) {
    store.set({ composing: { room, text: chars.slice(0, i).join('') } })
    await sleep(step, gen)
  }
}

async function sendChoice(option: ChoiceOption, room: RoomId, gen: number) {
  if (option.act || option.openRoom) return
  const text = option.say ?? option.label
  try {
    if (option.draft) {
      await typeInto(room, option.draft, gen)
      await sleep(0.8, gen)
      await eraseFrom(room, option.draft, gen)
      if (option.keep) appendNote('unsent', ROOMS[room].name, option.draft)
      await sleep(0.4, gen)
    }
    await typeInto(room, text, gen)
    await sleep(0.25, gen)
  } finally {
    if (gen === generation) store.set({ composing: null })
  }
  pushMessage({ room, from: 'me', text })
}

/** 대면·통화 중 고른 선택지 처리 */
async function stageChoice(option: ChoiceOption, gen: number) {
  if (option.answer) {
    connectCall()
  } else if (option.decline) {
    recordCall('declined')
    await endStage(gen)
  } else if (option.say && !option.act) {
    // 버튼 글과 다른 말을 할 때만 주인공 대사로 보여준다
    setStage({ line: { id: nextLineId++, speaker: 'me', text: option.say } })
    await waitAdvance(gen)
  }
}

/** 흐름도용 선택 기록 + 지금까지 한 번이라도 고른 선택 (날짜 선택으로 되돌려도 남는다) */
function recordChoice(option: ChoiceOption, options: ChoiceOption[]) {
  const { day, time } = store.get().clock
  const labels = options.map((o) => (o.openRoom ? ROOMS[o.openRoom].name : o.label))
  const chosen = options.indexOf(option)
  updateJournal((j) => ({ history: [...j.history, { day, time, context: pendingContext, options: labels, chosen }] }))
  const key = `${day}|${pendingContext}|${labels[chosen]}`
  const seen = load<string[]>('seen', [])
  if (!seen.includes(key)) save('seen', [...seen, key])
}

async function run(gen: number) {
  try {
    while (gen === generation && story) {
      if (story.canContinue) {
        const text = (story.Continue() ?? '').trim()
        syncStats()
        const newDay = await handleLine(text, parseTags(story.currentTags), gen)
        // 줄이 끝난 지점은 다시 불러와도 똑같이 이어지므로 매 줄 이어하기 저장
        if (gen === generation) (newDay ? saveDay : saveResume)(snapshot(), store.get().messages)
      } else if (story.currentChoices.length > 0) {
        const room = currentRoom
        const option = await askChoice()
        if (gen !== generation) return
        recordChoice(option, pendingOptions)
        if (pendingKind === 'stage' || pendingKind === 'call') await stageChoice(option, gen)
        else await sendChoice(option, room, gen)
        story.ChooseChoiceIndex(option.index)
        lastChosen = option.label
        syncStats()
      } else {
        break // 대본 끝
      }
    }
  } catch (error) {
    if (!(error instanceof Cancelled)) console.error(error)
  }
}

export const director = {
  /** 이미 시작했으면 아무것도 하지 않는다 */
  start(playerName: string) {
    if (story) return
    story = new Story(storyData)
    story.BindExternalFunction('saved', (name: string) => store.get().journal.photos.some((p) => p.name === name), true)
    const saved = loadResume()
    if (saved) {
      try {
        story.state.LoadJson(saved.snapshot.ink)
        currentRoom = saved.snapshot.room
        syncMessageIds(saved.messages)
        store.set({
          journal: { ...EMPTY_JOURNAL, ...saved.snapshot.journal },
          messages: saved.messages,
          clock: saved.snapshot.clock,
          unread: saved.snapshot.unread,
          stage: saved.snapshot.stage ?? null,
          calls: saved.snapshot.calls ?? [],
        })
        nextCallId = (saved.snapshot.calls ?? []).reduce((max, c) => Math.max(max, c.id), 0) + 1
      } catch (error) {
        // 대본이 크게 바뀌어 저장본이 맞지 않으면 처음부터
        console.warn('저장본을 불러오지 못해 처음부터 시작합니다', error)
        story = new Story(storyData)
        store.reset()
      }
    }
    director.setPlayerName(playerName)
    syncStats()
    void run(++generation)
  },

  /** 그 날짜의 시작 지점부터 다시 */
  rewind(day: number, playerName: string): boolean {
    if (!rewindTo(day)) return false
    director.reset()
    director.start(playerName)
    return true
  },

  setPlayerName(name: string) {
    try {
      story?.variablesState.$('player_name', name)
    } catch {
      warn('main.ink에 VAR player_name 이 없습니다')
    }
  },

  /** 대면·통화 대사를 탭했을 때 */
  advance() {
    const resolve = advanceResolve
    advanceResolve = null
    resolve?.()
  },

  /** 하루 결산 화면을 닫았을 때 */
  closeSummary() {
    store.set({ summary: null })
    const resolve = summaryResolve
    summaryResolve = null
    resolve?.()
  },

  /** 추천 답장을 눌렀을 때 */
  choose(index: number) {
    const choice = store.get().choice
    const option = choice?.options.find((o) => o.index === index)
    if (!option || !pendingResolve) return
    const resolve = pendingResolve
    pendingResolve = null
    cleanupChoice?.()
    cleanupChoice = null
    store.set({ choice: null })
    resolve(option)
  },

  /** 진행 중인 대본을 멈추고 상태를 비운다 */
  reset() {
    generation++
    story = null
    currentRoom = 'dangol'
    lastChosen = null
    pendingAsk = null
    pendingResolve = null
    advanceResolve = null
    summaryResolve = null
    cleanupChoice?.()
    cleanupChoice = null
    store.reset()
  },
}
