import { useGame } from '../engine/store'
import { PEOPLE, STAGE_SIGNALS, affectionStage, isHeroine } from './cast'
import type { SenderId } from './cast'

/** 지금 호감 단계의 프로필 사진·상태 메시지 */
export function useSignal(id: SenderId): { pfp: string | null; status: string } {
  const affection = useGame((s) => (isHeroine(id) ? s.stats.aff[id] : 0))
  if (isHeroine(id)) return STAGE_SIGNALS[id][affectionStage(affection) - 1]
  if (id === 'me' || id === 'system') return { pfp: null, status: '' }
  return { pfp: PEOPLE[id].pfp ?? null, status: PEOPLE[id].status ?? '' }
}
