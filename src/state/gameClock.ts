// 게임 내 시각. M1은 고정값을 반환한다. (게임 시간은 행동 기반으로 흐르며 M3에서 상태와 연결)

export interface GameTime {
  dateLabel: string
  timeLabel: string
}

export function getGameTime(): GameTime {
  return { dateLabel: '3월 9일 월요일', timeLabel: '08:12' }
}
