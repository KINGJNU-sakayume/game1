// 등장인물과 대화방 목록. 대본의 `# from:` · `# room:` 태그에 쓰는 id가 여기 정의된다.

export type PersonId = 'seoha' | 'ian' | 'daon' | 'boss' | 'halmeoni' | 'choi' | 'guard'
export type RoomId = 'seoha' | 'ian' | 'daon' | 'boss' | 'dangol'
/** 메시지 보낸 사람: 등장인물, 주인공(me), 시스템 안내(system) */
export type SenderId = PersonId | 'me' | 'system'

export interface Person {
  name: string
  /** 아바타 대체 색 (tokens.css 변수) */
  color: string
  /** 기본 프로필 사진 파일명 (public/assets/ui/*.webp, 확장자 없이). 없으면 이니셜 아바타 */
  pfp?: string
}

export const PEOPLE: Record<PersonId, Person> = {
  seoha: { name: '윤서하', color: 'var(--person-seoha)', pfp: 'seoha_pfp_stage1_01' },
  ian: { name: '채이안', color: 'var(--person-ian)', pfp: 'ian_pfp_stage1_01' },
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
