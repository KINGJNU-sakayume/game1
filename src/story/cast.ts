// 등장인물과 대화방 목록. 대본의 `# from:` · `# room:` · `# call:` 태그에 쓰는 id가 여기 정의된다.
// 이 파일은 import 없이 둔다 (scripts/playtest.ts가 그대로 읽는다).

export type HeroineId = 'seoha' | 'ian' | 'daon'
export type PersonId = HeroineId | 'boss' | 'halmeoni' | 'choi' | 'guard' | 'dubu' | 'banjang'
export type RoomId = 'seoha' | 'ian' | 'daon' | 'boss' | 'dangol'
/** 메시지 보낸 사람: 등장인물, 주인공(me), 시스템 안내(system) */
export type SenderId = PersonId | 'me' | 'system'

export interface Person {
  name: string
  /** 아바타 대체 색 (tokens.css 변수) */
  color: string
  /** 프로필 사진 파일명 (public/assets/ui/*.webp, 확장자 없이). 없으면 이니셜 아바타 */
  pfp?: string
  /** 상태 메시지 */
  status?: string
  /** 전화번호 (가상). 연락처와 모르는 번호 수신 화면에 나온다 */
  number?: string
  /** 연락처 앱에 나오는 한 줄 소개 (처음 알게 된 모습) */
  role?: string
}

/** 주인공이 새로 받은 번호 = 김 사장님이 30년 쓰던 번호. 끝자리는 가게를 연 해 */
export const MY_NUMBER = '010-6230-1996'

export const PEOPLE: Record<PersonId, Person> = {
  seoha: { name: '윤서하', color: 'var(--person-seoha)', number: '010-4715-0303', role: '카페 오후세시 사장' },
  ian: { name: '채이안', color: 'var(--person-ian)', number: '010-3012-0301', role: '해든빌라 301호 · 윗집' },
  daon: { name: '김다온', color: 'var(--person-daon)', number: '010-2424-0502', role: '망원 24시 동물의료센터 수의사' },
  boss: { name: '김용수 사장님', color: 'var(--person-boss)', number: '064-752-1996', role: '만물수선 김씨 · 이 번호의 전 주인' },
  halmeoni: { name: '박 할머니', color: 'var(--person-halmeoni)', number: '010-3321-1949', role: '망원시장 박씨네 떡집' },
  choi: { name: '최 사장', color: 'var(--person-choi)', number: '010-5288-9292', role: '망원시장 망원정육' },
  guard: { name: '경비 아저씨', color: 'var(--person-guard)', number: '02-335-0201', role: '해든빌라 관리실' },
  dubu: { name: '두부', color: 'var(--person-dubu)', role: '동물의료센터에 사는 치즈 고양이' },
  banjang: { name: '오반장', color: 'var(--person-banjang)', role: '튜브 「오반장 수리교실」' },
}

export interface Room {
  name: string
  /** 1:1 방이면 상대 한 명, 단톡방이면 주인공을 뺀 멤버 전원 */
  members: PersonId[]
  group: boolean
}

export const ROOMS: Record<RoomId, Room> = {
  seoha: { name: '윤서하', members: ['seoha'], group: false },
  ian: { name: '채이안', members: ['ian'], group: false },
  daon: { name: '김다온', members: ['daon'], group: false },
  boss: { name: '김용수 사장님', members: ['boss'], group: false },
  dangol: {
    name: '만물수선 단골방',
    members: ['seoha', 'ian', 'daon', 'halmeoni', 'choi', 'guard'],
    group: true,
  },
}

export function isRoomId(id: string): id is RoomId {
  return id in ROOMS
}

export function isSenderId(id: string): id is SenderId {
  return id === 'me' || id === 'system' || id in PEOPLE
}

export function isPersonId(id: string): id is PersonId {
  return id in PEOPLE
}

// ───────── 호감 신호 (02_캐릭터_바이블.md) ─────────

export const HEROINES: HeroineId[] = ['seoha', 'ian', 'daon']

export function isHeroine(id: string): id is HeroineId {
  return (HEROINES as string[]).includes(id)
}

/** 호감 0~100 → 단계 1~4 */
export function affectionStage(affection: number): 1 | 2 | 3 | 4 {
  if (affection >= 75) return 4
  if (affection >= 50) return 3
  if (affection >= 25) return 2
  return 1
}

interface StageSignal {
  /** 프로필 사진 파일명. null이면 기본 프로필(이니셜) */
  pfp: string | null
  status: string
}

/** 단계별 프로필 사진·상태 메시지 (index 0 = 1단계) */
export const STAGE_SIGNALS: Record<HeroineId, StageSignal[]> = {
  seoha: [
    { pfp: 'seoha_pfp_stage1_01', status: '영업 10:00–21:00 · 월 휴무' },
    { pfp: 'seoha_pfp_stage2_01', status: '봄 메뉴 준비 중' },
    { pfp: 'seoha_pfp_stage3_01', status: '기계는 무섭다' },
    { pfp: 'seoha_pfp_stage4_01', status: '' },
  ],
  ian: [
    { pfp: 'ian_pfp_stage1_01', status: '마감 D-9' },
    { pfp: 'ian_pfp_stage2_01', status: '형광등 부활' },
    { pfp: 'ian_pfp_stage3_01', status: '밤이 짧다' },
    { pfp: 'ian_pfp_stage4_01', status: '' },
  ],
  daon: [
    { pfp: null, status: '' },
    { pfp: 'daon_pfp_stage2_01', status: '당직' },
    { pfp: 'daon_pfp_stage3_01', status: '수첩 반납 요망' },
    { pfp: 'daon_pfp_stage4_01', status: '' },
  ],
}

/**
 * 주인공 메시지를 읽기까지 걸리는 시간(초, 단계별). 텍스트 속도 설정이 곱해진다.
 * 서하: 영업 중엔 늦다 / 이안: 매우 빠르다 / 다온: 느리고 짧다
 */
export const READ_DELAY: Record<HeroineId, [number, number, number, number]> = {
  seoha: [5, 3.5, 2, 1],
  ian: [1.2, 0.8, 0.5, 0.3],
  daon: [7, 5, 3, 1.5],
}
export const DEFAULT_READ_DELAY = 1.5
