import { useMemo } from 'react'
import { Lock } from 'lucide-react'
import { director } from '../engine/director'
import { useGame } from '../engine/store'
import { formatDay } from '../state/gameClock'
import { load } from '../state/storage'
import './daySummary.css'

/** 하루 결산 흐름도: 그날 도달한 선택과 잠긴 선택 */
export default function DaySummary() {
  const summary = useGame((s) => s.summary)
  const history = useGame((s) => s.journal.history)
  const seen = useMemo(() => new Set(load<string[]>('seen', [])), [summary])

  if (!summary) return null
  const records = history.filter((r) => r.day === summary.day)

  return (
    <div className="summary" role="dialog" aria-label="하루 결산">
      <header className="summary__head">
        <p className="summary__eyebrow">하루 결산</p>
        <h2 className="summary__title">{formatDay(summary.day)}</h2>
      </header>

      <ol className="flow">
        {records.length === 0 && <li className="flow__empty">오늘은 고른 것이 없습니다</li>}
        {records.map((r, i) => (
          <li key={i} className="flow__node" style={{ animationDelay: `${i * 120}ms` }}>
            <p className="flow__context">
              <span className="flow__time">{r.time}</span> {r.context}
            </p>
            <div className="flow__branches">
              {r.options.map((label, j) => {
                const chosen = j === r.chosen
                const known = chosen || seen.has(`${r.day}|${r.context}|${label}`)
                return (
                  <span
                    key={j}
                    className={`flow__branch${chosen ? ' is-chosen' : known ? ' is-known' : ' is-locked'}`}
                    aria-label={chosen ? `고른 선택: ${label}` : known ? `다른 회차에 고른 선택: ${label}` : '잠긴 선택'}
                  >
                    {known ? label : (
                      <>
                        <Lock size={13} aria-hidden /> ???
                      </>
                    )}
                  </span>
                )
              })}
            </div>
          </li>
        ))}
      </ol>

      <footer className="summary__foot">
        <p className="summary__note">날짜 선택(설정)으로 이 날을 다시 하면 잠긴 선택을 열 수 있습니다.</p>
        <button type="button" className="btn-primary summary__next" onClick={() => director.closeSummary()}>
          다음 날로
        </button>
      </footer>
    </div>
  )
}
