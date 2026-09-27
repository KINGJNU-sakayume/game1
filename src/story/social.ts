// 스냅(SNS) 계정. 대본의 `# post:` 줄에 붙인 `# from:` 인물이 이 계정으로 글을 올린다.
// 이 파일은 타입 말고는 import 없이 둔다 (scripts/playtest.ts가 그대로 읽는다).
import type { PersonId } from './cast'

export interface SnapAccount {
  name: string
  handle: string
  bio: string
}

export const SNAP_ACCOUNTS: Partial<Record<PersonId, SnapAccount>> = {
  seoha: { name: '카페 오후세시', handle: 'ohusesi.cafe', bio: '망원동 골목 1인 카페 · 10:00–21:00 · 월 휴무' },
  ian: { name: '이안 그림일기', handle: 'ian.draws', bio: '일러스트 · 외주 문의 DM · 밤에 그림' },
  dubu: { name: '망원24 두부', handle: 'dubu_mw24', bio: '망원 24시 동물의료센터에 사는 고양이 · 관리: 병원 식구들' },
  choi: { name: '망원정육', handle: 'mangwon_meat', bio: '망원시장 한가운데 · 오늘의 특가는 사장 마음' },
}

/** 계정이 없는 인물이 글을 올려도 화면이 깨지지 않게 */
export function snapAccount(id: PersonId, fallbackName: string): SnapAccount {
  return SNAP_ACCOUNTS[id] ?? { name: fallbackName, handle: id, bio: '' }
}
