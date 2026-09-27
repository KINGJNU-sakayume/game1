import { useState } from 'react'
import { useGame } from '../../engine/store'
import type { Plan } from '../../engine/store'
import { formatDay } from '../../state/gameClock'
import { weatherOf } from '../../story/weather'
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

/** 같은 날 같은 시각에 잡힌 약속 (취소한 것 빼고) */
function conflicts(plans: Plan[]): Set<string> {
  const out = new Set<string>()
  const live = plans.filter((p) => !p.cancelled)
  for (const a of live) for (const b of live) if (a.id !== b.id && a.day === b.day && a.time === b.time) out.add(a.id)
  return out
}

/** 캘린더: 약속(# plan:)과 하루 일정(# event:). 겹친 약속은 표시되고, 취소한 약속은 줄이 그어진 채 남는다 */
export default function CalendarApp() {
  const today = useGame((s) => s.clock.day)
  const now = useGame((s) => s.clock.time)
  const plans = useGame((s) => s.journal.plans)
  const events = useGame((s) => s.journal.events)
  const [selected, setSelected] = useState(Math.min(today, GAME_DAYS))

  const cells: (number | null)[] = [...Array(FIRST_WEEKDAY).fill(null), ...Array.from({ length: MONTH_DAYS }, (_, i) => i + 1)]
  const dayPlans = plans.filter((p) => p.day === selected).sort((a, b) => a.time.localeCompare(b.time))
  const dayEvents = events.filter((e) => e.day === selected)
  const clash = conflicts(plans)
  const isPast = (day: number, time: string) => day < today || (day === today && time < now)
  const weather = weatherOf(selected)

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
          const hasPlan = plans.some((p) => p.day === day && !p.cancelled)
          const hasEvent = events.some((e) => e.day === day)
          const classes = [
            'calendar__date',
            inGame ? '' : 'is-outside',
            day === today ? 'is-today' : '',
            day === selected ? 'is-selected' : '',
            hasEvent ? 'has-event' : '',
          ].join(' ')
          return (
            <button
              key={date}
              type="button"
              className={classes}
              disabled={!inGame}
              onClick={() => setSelected(day)}
              aria-label={`3월 ${date}일${hasPlan ? ', 약속 있음' : ''}${hasEvent ? ', 일정 있음' : ''}`}
            >
              {date}
              {(hasPlan || hasEvent) && <span className="calendar__dot" />}
            </button>
          )
        })}
      </div>

      <section className="calendar__agenda">
        <h3 className="calendar__agenda-title">
          {formatDay(selected)}
          {selected >= today && (
            <span className="calendar__weather">
              {weather.sky} {weather.temp}°
            </span>
          )}
        </h3>
        {dayEvents.length > 0 && (
          <ul className="calendar__events">
            {dayEvents.map((e) => (
              <li key={e.id} className="calendar__event">
                {e.title}
              </li>
            ))}
          </ul>
        )}
        {dayPlans.length === 0 ? (
          dayEvents.length === 0 && <p className="calendar__empty">약속이 없습니다</p>
        ) : (
          <ul className="calendar__plans">
            {dayPlans.map((p) => (
              <li
                key={p.id}
                className={[
                  'calendar__plan',
                  isPast(p.day, p.time) ? 'is-past' : '',
                  p.cancelled ? 'is-cancelled' : '',
                  clash.has(p.id) ? 'is-clash' : '',
                ].join(' ')}
              >
                <span className="calendar__plan-time">{p.time}</span>
                <span className="calendar__plan-title">{p.title}</span>
                {p.cancelled ? (
                  <span className="calendar__tag">취소</span>
                ) : clash.has(p.id) ? (
                  <span className="calendar__tag calendar__tag--clash">겹침</span>
                ) : null}
              </li>
            ))}
          </ul>
        )}
      </section>
    </div>
  )
}
