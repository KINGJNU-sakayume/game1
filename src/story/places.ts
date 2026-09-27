// 지도 앱의 장소. 대본의 `# at:` · `# pin:` · 선택지 `# go:`에 쓰는 id가 여기 정의된다.
// x·y는 지도 앱 SVG(가로 360 × 세로 440) 위의 좌표. 실제 망원동을 단순하게 옮긴 그림이다.
// 이 파일은 import 없이 둔다 (scripts/playtest.ts가 그대로 읽는다).

export interface Place {
  name: string
  /** 이름 아래 한 줄 */
  sub: string
  x: number
  y: number
  /** 처음부터 지도에 보이는 곳 */
  known?: boolean
}

const PLACE_LIST = {
  home: { name: '해든빌라', sub: '201호 우리 집 · 301호 윗집 · 옥상', x: 68, y: 236, known: true },
  station: { name: '망원역', sub: '6호선', x: 238, y: 58, known: true },
  hospital: { name: '망원 24시 동물의료센터', sub: '밤에도 불이 켜진 곳 · 병원 앞 편의점', x: 84, y: 80 },
  cvs: { name: '골목 편의점', sub: '오후세시 가는 길. 여기서 오른쪽', x: 200, y: 152 },
  cafe: { name: '카페 오후세시', sub: '빨간 벽돌 건물 1층 · 월요일 휴무', x: 216, y: 184 },
  market: { name: '망원시장', sub: '박씨네 떡집 · 망원정육', x: 298, y: 126 },
  hardware: { name: '대성철물', sub: '시장 끝 철물점. 없는 게 없다', x: 320, y: 178 },
  shop: { name: '만물수선 자리', sub: '김 사장님 가게 터 · 간판만 남았다', x: 268, y: 218 },
  gallery: { name: '갤러리 틈', sub: '골목 안 작은 전시장', x: 140, y: 288 },
  spring: { name: '카페 두 번째 봄', sub: '합정 쪽 · 가게를 정리하는 중', x: 324, y: 306 },
  river: { name: '한강공원 망원지구', sub: '강바람이 센 곳', x: 96, y: 360 },
  fest_coffee: { name: '오후세시 커피 부스', sub: '봄밤 장터', x: 44, y: 350 },
  fest_bench: { name: '강변 벤치', sub: '봄밤 장터 · 스케치하는 사람', x: 128, y: 364 },
  fest_adopt: { name: '입양 캠페인 부스', sub: '봄밤 장터 · 망원24', x: 206, y: 374 },
} satisfies Record<string, Place>

export type PlaceId = keyof typeof PLACE_LIST

export const PLACES: Record<PlaceId, Place> = PLACE_LIST

export function isPlaceId(id: string): id is PlaceId {
  return id in PLACES
}
