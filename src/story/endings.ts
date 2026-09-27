// 엔딩 7개. 대본의 `# ending: id`가 이 id를 쓰고, 본 엔딩은 설정 앱 "엔딩 기록"에 남는다.
// 이 파일은 타입 말고는 import 없이 둔다.
import type { HeroineId } from './cast'

export interface EndingDef {
  id: string
  who: HeroineId | null
  /** 굿 / 노멀 / 번호 반납 */
  kind: string
  title: string
}

export const ENDINGS: EndingDef[] = [
  { id: 'seoha_good', who: 'seoha', kind: '굿 엔딩', title: '오후 세시의 사람' },
  { id: 'seoha_normal', who: 'seoha', kind: '노멀 엔딩', title: '마지막 잔' },
  { id: 'ian_good', who: 'ian', kind: '굿 엔딩', title: '윗집 사람' },
  { id: 'ian_normal', who: 'ian', kind: '노멀 엔딩', title: '형광등을 갈아 주세요' },
  { id: 'daon_good', who: 'daon', kind: '굿 엔딩', title: '만물수선 김씨, 두 번째' },
  { id: 'daon_normal', who: 'daon', kind: '노멀 엔딩', title: '밥은.' },
  { id: 'alone', who: null, kind: '번호 반납', title: '지금 거신 번호는' },
]

export function findEnding(id: string): EndingDef | undefined {
  return ENDINGS.find((e) => e.id === id)
}
