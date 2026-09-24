// 게임 진행 상태 저장소. React 밖(연출 엔진)에서도 쓰기 때문에 외부 저장소 + useSyncExternalStore로 만든다.
import { useSyncExternalStore } from 'react'
import { ROOMS } from '../story/cast'
import type { HeroineId, PersonId, RoomId, SenderId } from '../story/cast'

export interface ChatMessage {
  id: number
  room: RoomId
  from: SenderId
  text: string
  /** 사진 메시지 (public/assets/cg/*.webp, 확장자 없이) */
  photo?: string
  /** 큰 글씨 스티커처럼 표시 */
  big?: boolean
  /** 주인공 메시지를 상대가 읽었는지 (1:1 방) */
  read?: boolean
  day: number
  time: string
}

export interface ChoiceOption {
  index: number
  /** 추천 답장 버튼에 보이는 글 */
  label: string
  /** 실제로 보낼 말. 없으면 label을 보낸다 */
  say: string | null
  /** 썼다 지우는 말 */
  draft: string | null
  /** 메시지를 보내지 않는 행동 (나중에 답하기 등) */
  act: boolean
  /** 이 방을 먼저 열면 선택되는 선택지 */
  openRoom: RoomId | null
  /** 전화 수신 화면의 받기 / 거절 */
  answer: boolean
  decline: boolean
  /** 썼다 지운 말을 메모 앱 "보내지 못한 말"에 남긴다 */
  keep: boolean
}

export interface PendingChoice {
  /**
   * reply: 방 안의 추천 답장 / open: 어느 방을 먼저 여느냐 / stage: 대면·통화 중 선택 / call: 받기·거절
   * menu: 메시지가 아닌 행동만 있는 선택 (밤의 할 일 등) — 화면 아래 시트로
   */
  kind: 'reply' | 'open' | 'stage' | 'call' | 'menu'
  room: RoomId | null
  options: ChoiceOption[]
  /** menu 시트 제목 */
  title?: string
}

/** 대면 장면·통화 화면에 한 줄씩 나오는 대사 */
export interface StageLine {
  id: number
  /** null이면 서술(주인공의 1인칭 서술·독백) */
  speaker: SenderId | null
  text: string
}

export interface CallInfo {
  who: PersonId
  video: boolean
  outgoing: boolean
  state: 'ringing' | 'connecting' | 'connected'
  /** 연결된 시각 (Date.now) */
  startedAt: number | null
}

/** 폰 화면 위를 덮는 무대: 대면 장면 또는 통화 */
export interface Stage {
  kind: 'scene' | 'call'
  /** 풀스크린 컷 이미지 (cg/ 또는 bg_로 시작하면 backgrounds/) */
  image: string | null
  /** 암전 */
  black: boolean
  fx: { type: 'zoom' | 'shake'; key: number } | null
  line: StageLine | null
  call: CallInfo | null
  /** 끝나는 전환 중 */
  ending: boolean
}

export interface CallRecord {
  id: number
  who: PersonId
  video: boolean
  kind: 'incoming' | 'outgoing' | 'declined'
  day: number
  time: string
  seconds: number
}

export interface Banner {
  id: number
  room: RoomId
  from: SenderId
  text: string
}

export interface Stats {
  /** 호감 0~100 (ink 변수 aff_*) */
  aff: Record<HeroineId, number>
  /** 수리 실력 0~3 (ink 변수 skill) */
  skill: number
}

export interface SavedPhoto {
  name: string
  /** 받은 사진이면 보낸 사람, 주인공이 찍은 사진이면 없음 */
  from: SenderId | null
  day: number
  time: string
}

export interface Plan {
  id: string
  day: number
  time: string
  title: string
}

export interface Note {
  /** note: 주인공 메모 / page: 김 사장님 수첩 / unsent: 보내지 못한 말 */
  kind: 'note' | 'page' | 'unsent'
  title: string
  body: string[]
  day: number
  time: string
}

export interface Todo {
  id: string
  text: string
  done: boolean
}

/** 하루 결산 흐름도에 쓰는 선택 기록 */
export interface ChoiceRecord {
  day: number
  time: string
  /** 어디서 고른 선택인지 (방 이름, 대면, 전화 …) */
  context: string
  options: string[]
  chosen: number
}

/** 대본이 만드는 기록: 사진첩·캘린더·메모·흐름도. 저장본에 함께 들어간다 */
export interface Journal {
  photos: SavedPhoto[]
  plans: Plan[]
  notes: Note[]
  todos: Todo[]
  history: ChoiceRecord[]
}

export const EMPTY_JOURNAL: Journal = { photos: [], plans: [], notes: [], todos: [], history: [] }

export interface GameState {
  clock: { day: number; time: string }
  journal: Journal
  /** 하루 결산 화면 */
  summary: { day: number } | null
  stats: Stats
  messages: ChatMessage[]
  unread: Partial<Record<RoomId, number>>
  /** 방별로 입력 중인 사람 */
  typing: Partial<Record<RoomId, SenderId>>
  choice: PendingChoice | null
  /** 주인공 입력창에 타이핑 중인 글 (썼다 지우기 연출) */
  composing: { room: RoomId; text: string } | null
  /** 지금 화면에 열려 있는 대화방 */
  viewingRoom: RoomId | null
  banner: Banner | null
  /** 알림을 눌러 열어야 할 방 */
  requestedRoom: RoomId | null
  stage: Stage | null
  calls: CallRecord[]
}

export const INITIAL_STATE: GameState = {
  clock: { day: 1, time: '08:12' },
  journal: EMPTY_JOURNAL,
  summary: null,
  stats: { aff: { seoha: 0, ian: 0, daon: 0 }, skill: 0 },
  messages: [],
  unread: {},
  typing: {},
  choice: null,
  composing: null,
  viewingRoom: null,
  banner: null,
  requestedRoom: null,
  stage: null,
  calls: [],
}

type Listener = () => void

let state: GameState = INITIAL_STATE
const listeners = new Set<Listener>()

export const store = {
  get(): GameState {
    return state
  },
  set(update: Partial<GameState> | ((s: GameState) => Partial<GameState>)) {
    const patch = typeof update === 'function' ? update(state) : update
    state = { ...state, ...patch }
    listeners.forEach((l) => l())
  },
  reset() {
    store.set(INITIAL_STATE)
  },
  subscribe(listener: Listener) {
    listeners.add(listener)
    return () => {
      listeners.delete(listener)
    }
  },
}

export function useGame<T>(select: (s: GameState) => T): T {
  return useSyncExternalStore(store.subscribe, () => select(state))
}

// ───────── 자주 쓰는 변경 ─────────

let nextMessageId = 1
let nextBannerId = 1

export function pushMessage(message: Omit<ChatMessage, 'id' | 'day' | 'time'>) {
  store.set((s) => {
    const full: ChatMessage = { ...message, id: nextMessageId++, day: s.clock.day, time: s.clock.time }
    if (message.from === 'me' && !ROOMS[message.room].group) full.read = false
    const seen = s.viewingRoom === message.room || message.from === 'me'
    const counts = !seen && message.from !== 'system'
    return {
      messages: [...s.messages, full],
      unread: !counts ? s.unread : { ...s.unread, [message.room]: (s.unread[message.room] ?? 0) + 1 },
      banner:
        seen || message.from === 'system'
          ? s.banner
          : { id: nextBannerId++, room: message.room, from: message.from, text: previewText(full) },
    }
  })
}

export function updateJournal(update: (j: Journal) => Partial<Journal>) {
  store.set((s) => ({ journal: { ...s.journal, ...update(s.journal) } }))
}

/** 사진첩에 저장 (이미 있으면 무시) */
export function savePhoto(name: string, from: SenderId | null) {
  updateJournal((j) =>
    j.photos.some((p) => p.name === name)
      ? {}
      : { photos: [...j.photos, { name, from, day: state.clock.day, time: state.clock.time }] },
  )
}

export function setStage(update: Partial<Stage> | null) {
  store.set((s) => ({ stage: update === null ? null : s.stage ? { ...s.stage, ...update } : null }))
}

/** 이 방에서 주인공이 보낸 안 읽힌 메시지가 있는지 */
export function hasUnreadMine(room: RoomId): boolean {
  return state.messages.some((m) => m.room === room && m.from === 'me' && m.read === false)
}

export function markRead(room: RoomId) {
  store.set((s) => ({
    messages: s.messages.map((m) => (m.room === room && m.from === 'me' && m.read === false ? { ...m, read: true } : m)),
  }))
}

/** 저장본을 불러올 때 메시지 id가 겹치지 않게 */
export function syncMessageIds(messages: ChatMessage[]) {
  nextMessageId = messages.reduce((max, m) => Math.max(max, m.id), 0) + 1
}

export function setViewingRoom(room: RoomId | null) {
  store.set((s) => ({
    viewingRoom: room,
    unread: room ? { ...s.unread, [room]: 0 } : s.unread,
    banner: room && s.banner?.room === room ? null : s.banner,
  }))
}

export function previewText(message: Pick<ChatMessage, 'text' | 'photo'>): string {
  if (message.photo) return message.text ? `사진: ${message.text}` : '사진을 보냈습니다.'
  return message.text
}

export function totalUnread(s: GameState): number {
  return Object.values(s.unread).reduce<number>((sum, n) => sum + (n ?? 0), 0)
}
