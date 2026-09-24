// 연출 엔진: ink 대본을 한 줄씩 읽어 태그대로 메시지·입력 중 표시·추천 답장을 보여준다.
// 문법은 docs/05_스크립트_문법.md 참조.
import { Story } from 'inkjs'
import storyData from '../../story/main.ink'
import {
  DEFAULT_READ_DELAY,
  HEROINES,
  READ_DELAY,
  ROOMS,
  affectionStage,
  isHeroine,
  isRoomId,
  isSenderId,
} from '../story/cast'
import type { HeroineId, RoomId, SenderId } from '../story/cast'
import { loadSettings } from '../state/storage'
import { hasUnreadMine, markRead, pushMessage, store, syncMessageIds } from './store'
import type { ChoiceOption, Stats } from './store'
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
let cleanupChoice: (() => void) | null = null

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

  if (!text) return newDay
  if (lastChosen !== null && text === lastChosen && tags.from === undefined) {
    lastChosen = null
    return newDay
  }
  lastChosen = null

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
    }
  })
  const kind = options.every((o) => o.openRoom) ? 'open' : 'reply'
  // 선택지 앞은 다시 불러와도 똑같이 이어지는 지점이므로 여기서 이어하기 저장
  saveResume(snapshot(), store.get().messages)

  return new Promise((resolve) => {
    pendingResolve = resolve
    store.set({ choice: { kind, room: kind === 'open' ? null : currentRoom, options } })
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
      await sleep(0.4, gen)
    }
    await typeInto(room, text, gen)
    await sleep(0.25, gen)
  } finally {
    if (gen === generation) store.set({ composing: null })
  }
  pushMessage({ room, from: 'me', text })
}

async function run(gen: number) {
  try {
    while (gen === generation && story) {
      if (story.canContinue) {
        const text = (story.Continue() ?? '').trim()
        syncStats()
        const newDay = await handleLine(text, parseTags(story.currentTags), gen)
        if (newDay && gen === generation) saveDay(snapshot(), store.get().messages)
      } else if (story.currentChoices.length > 0) {
        const room = currentRoom
        const option = await askChoice()
        if (gen !== generation) return
        await sendChoice(option, room, gen)
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
    const saved = loadResume()
    if (saved) {
      try {
        story.state.LoadJson(saved.snapshot.ink)
        currentRoom = saved.snapshot.room
        syncMessageIds(saved.messages)
        store.set({ messages: saved.messages, clock: saved.snapshot.clock, unread: saved.snapshot.unread })
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
    pendingResolve = null
    cleanupChoice?.()
    cleanupChoice = null
    store.reset()
  },
}
