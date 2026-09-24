// 등장인물과 대화방 목록. 대본의 `# from:` · `# room:` 태그에 쓰는 id가 여기 정의된다.

export type HeroineId = 'seoha' | 'ian' | 'daon'
export type PersonId = HeroineId | 'boss' | 'halmeoni' | 'choi' | 'guard'
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
}

export const PEOPLE: Record<PersonId, Person> = {
  seoha: { name: '윤서하', color: 'var(--person-seoha)' },
  ian: { name: '채이안', color: 'var(--person-ian)' },
  daon: { name: '김다온', color: 'var(--person-daon)' },
  boss: { name: '김용수 사장님', color: 'var(--person-boss)' },
  halmeoni: { name: '박 할머니', color: 'var(--person-halmeoni)' },
  choi: { name: '최 사장', color: 'var(--person-choi)' },
  guard: { name: '경비 아저씨', color: 'var(--person-guard)' },
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
