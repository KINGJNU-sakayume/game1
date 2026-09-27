// 게임 내 날짜와 시각. 시간은 실시간이 아니라 대본의 `# day:` · `# time:` 태그로 흐른다.
import { useGame } from '../engine/store'

const WEEKDAYS = ['일', '월', '화', '수', '목', '금', '토']
/** D1 = 2026년 3월 9일 월요일. 엔딩 에필로그는 날짜를 건너뛰므로(D42 = 4월 19일) 실제 달력으로 계산한다 */
const START = new Date(2026, 2, 9)

export interface GameTime {
  dateLabel: string
  timeLabel: string
}

export function formatDay(day: number): string {
  const d = new Date(START)
  d.setDate(START.getDate() + day - 1)
  return `${d.getMonth() + 1}월 ${d.getDate()}일 ${WEEKDAYS[d.getDay()]}요일`
}

export function useGameTime(): GameTime {
  const day = useGame((s) => s.clock.day)
  const time = useGame((s) => s.clock.time)
  return { dateLabel: formatDay(day), timeLabel: time }
}
