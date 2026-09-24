// 자동 저장 (docs/04_시스템_명세.md 5장)
// - resume: 선택지가 나올 때마다 덮어쓰는 이어하기 저장 1개
// - days:   날짜가 바뀔 때(# day:) 남기는 날짜별 시작 지점. 설정 앱의 "날짜 선택"에 쓴다
// 메시지 기록(log)은 앞부분이 공유되므로 한 번만 저장하고, 각 저장본은 메시지 개수만 기억한다.
import { load, remove, save } from '../state/storage'
import type { RoomId } from '../story/cast'
import type { ChatMessage, GameState } from './store'

const VERSION = 1

export interface Snapshot {
  version: number
  day: number
  /** ink 진행 상태 (story.state.ToJson()) */
  ink: string
  messageCount: number
  clock: GameState['clock']
  unread: GameState['unread']
  room: RoomId
  savedAt: number
}

type DaySaves = Record<string, Snapshot>

function isValid(snapshot: Snapshot | null): snapshot is Snapshot {
  return !!snapshot && snapshot.version === VERSION && typeof snapshot.ink === 'string'
}

export function saveResume(snapshot: Snapshot, messages: ChatMessage[]) {
  save('log', messages)
  save('resume', snapshot)
}

/** 날짜 시작 지점을 남긴다. 그 뒤 날짜의 저장본은 다른 갈래가 되었으므로 지운다 */
export function saveDay(snapshot: Snapshot, messages: ChatMessage[]) {
  const days = load<DaySaves>('days', {})
  for (const key of Object.keys(days)) if (Number(key) >= snapshot.day) delete days[key]
  days[snapshot.day] = snapshot
  save('days', days)
  saveResume(snapshot, messages)
}

export function loadResume(): { snapshot: Snapshot; messages: ChatMessage[] } | null {
  const snapshot = load<Snapshot | null>('resume', null)
  if (!isValid(snapshot)) return null
  const log = load<ChatMessage[]>('log', [])
  if (log.length < snapshot.messageCount) return null
  return { snapshot, messages: log.slice(0, snapshot.messageCount) }
}

/** 도달한 날짜 목록 (오름차순) */
export function listDays(): Snapshot[] {
  return Object.values(load<DaySaves>('days', {}))
    .filter(isValid)
    .sort((a, b) => a.day - b.day)
}

/** 그 날짜 시작 지점을 이어하기 저장으로 만든다. 이후 날짜 저장본은 지운다 */
export function rewindTo(day: number): boolean {
  const days = load<DaySaves>('days', {})
  const target = days[day]
  if (!isValid(target)) return false
  for (const key of Object.keys(days)) if (Number(key) > day) delete days[key]
  save('days', days)
  save('resume', target)
  return true
}

export function clearSaves() {
  remove('log')
  remove('resume')
  remove('days')
}
