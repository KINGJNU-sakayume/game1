// 날짜별 날씨 (홈 화면 위젯 · 잠금화면). 대본의 사건과 맞춰 둔다: D5 봄밤 장터(맑음), D9 비와 강풍(정전), D12 춘분.
// 이 파일은 import 없이 둔다.

export interface Weather {
  sky: string
  temp: number
}

const WEATHER: Record<number, Weather> = {
  1: { sky: '맑음', temp: 11 },
  2: { sky: '맑음', temp: 13 },
  3: { sky: '흐림', temp: 10 },
  4: { sky: '맑음', temp: 14 },
  5: { sky: '맑음', temp: 16 },
  6: { sky: '구름 조금', temp: 15 },
  7: { sky: '맑음', temp: 15 },
  8: { sky: '흐림', temp: 12 },
  9: { sky: '비', temp: 9 },
  10: { sky: '갬', temp: 13 },
  11: { sky: '흐림', temp: 12 },
  12: { sky: '맑음', temp: 16 },
  13: { sky: '맑음', temp: 17 },
  14: { sky: '맑음', temp: 18 },
}

export function weatherOf(day: number): Weather {
  return WEATHER[day] ?? { sky: '맑음', temp: 18 }
}
