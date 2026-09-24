// 게임 진행 상태 저장소. React 밖(연출 엔진)에서도 쓰기 때문에 외부 저장소 + useSyncExternalStore로 만든다.
import { useSyncExternalStore } from 'react'
import type { RoomId, SenderId } from '../story/cast'

export interface ChatMessage {
  id: number
  room: RoomId
  from: SenderId
  text: string
  /** 사진 메시지 (public/assets/cg/*.webp, 확장자 없이) */
  photo?: string
  /** 큰 글씨 스티커처럼 표시 */
  big?: boolean
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
}

export interface PendingChoice {
  /** reply: 방 안의 추천 답장 / open: 어느 방을 먼저 여느냐 */
  kind: 'reply' | 'open'
  room: RoomId | null
  options: ChoiceOption[]
}

export interface Banner {
  id: number
  room: RoomId
  from: SenderId
  text: string
}

export interface GameState {
  clock: { day: number; time: string }
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
}

export const INITIAL_STATE: GameState = {
  clock: { day: 1, time: '08:12' },
  messages: [],
  unread: {},
  typing: {},
  choice: null,
  composing: null,
  viewingRoom: null,
  banner: null,
  requestedRoom: null,
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
