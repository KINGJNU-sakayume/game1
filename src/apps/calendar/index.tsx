import { useState } from 'react'
import { useGame } from '../../engine/store'
import { formatDay } from '../../state/gameClock'
import './calendar.css'

/** 3월 달력. 게임 기간(3월 9일~22일, D1~D14) */
const MONTH_DAYS = 31
const FIRST_WEEKDAY = 0 // 2026년 3월 1일은 일요일
const GAME_START_DATE = 9
const GAME_DAYS = 14
const WEEKDAYS = ['일', '월', '화', '수', '목', '금', '토']

function dayOf(date: number) {
  return date - GAME_START_DATE + 1
}

export default function CalendarApp() {
  const today = useGame((s) => s.clock.day)
  const now = useGame((s) => s.clock.time)
  const plans = useGame((s) => s.journal.plans)
  const [selected, setSelected] = useState(today)

  const cells: (number | null)[] = [...Array(FIRST_WEEKDAY).fill(null), ...Array.from({ length: MONTH_DAYS }, (_, i) => i + 1)]
  const dayPlans = plans.filter((p) => p.day === selected).sort((a, b) => a.time.localeCompare(b.time))
  const isPast = (day: number, time: string) => day < today || (day === today && time < now)

  return (
    <div className="calendar">
      <h2 className="calendar__month">3월</h2>
      <div className="calendar__grid" role="grid">
        {WEEKDAYS.map((w) => (
          <span key={w} className="calendar__weekday">
            {w}
          </span>
        ))}
        {cells.map((date, i) => {
          if (date === null) return <span key={`e${i}`} />
          const day = dayOf(date)
          const inGame = day >= 1 && day <= GAME_DAYS
          const hasPlan = plans.some((p) => p.day === day)
          const classes = [
            'calendar__date',
            inGame ? '' : 'is-outside',
            day === today ? 'is-today' : '',
            day === selected ? 'is-selected' : '',
          ].join(' ')
          return (
            <button
              key={date}
              type="button"
              className={classes}
              disabled={!inGame}
              onClick={() => setSelected(day)}
              aria-label={`3월 ${date}일${hasPlan ? ', 약속 있음' : ''}`}
            >
              {date}
              {hasPlan && <span className="calendar__dot" />}
            </button>
          )
        })}
      </div>

      <section className="calendar__agenda">
        <h3 className="calendar__agenda-title">{formatDay(selected)}</h3>
        {dayPlans.length === 0 ? (
          <p className="calendar__empty">약속이 없습니다</p>
        ) : (
          <ul className="calendar__plans">
            {dayPlans.map((p) => (
              <li key={p.id} className={`calendar__plan${isPast(p.day, p.time) ? ' is-past' : ''}`}>
                <span className="calendar__plan-time">{p.time}</span>
                <span className="calendar__plan-title">{p.title}</span>
              </li>
            ))}
          </ul>
        )}
      </section>
    </div>
  )
}
