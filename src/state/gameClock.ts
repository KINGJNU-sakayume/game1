// 게임 내 날짜와 시각. 시간은 실시간이 아니라 대본의 `# day:` · `# time:` 태그로 흐른다.
import { useGame } from '../engine/store'

const WEEKDAYS = ['일', '월', '화', '수', '목', '금', '토']
/** D1 = 3월 9일 월요일 */
const START = { month: 3, date: 9, weekday: 1 }

export interface GameTime {
  dateLabel: string
  timeLabel: string
}

export function formatDay(day: number): string {
  const date = START.date + day - 1
  const weekday = WEEKDAYS[(START.weekday + day - 1) % 7]
  return `${START.month}월 ${date}일 ${weekday}요일`
}

export function useGameTime(): GameTime {
  const day = useGame((s) => s.clock.day)
  const time = useGame((s) => s.clock.time)
  return { dateLabel: formatDay(day), timeLabel: time }
}
