import { useMemo } from 'react'
import { director } from '../engine/director'
import { useGame } from '../engine/store'
import { PEOPLE } from '../story/cast'
import { ENDINGS, findEnding } from '../story/endings'
import { load } from '../state/storage'
import './endingCard.css'

/** 엔딩 카드 (# ending:). 닫으면 폰 화면으로 돌아가고, 설정 앱의 날짜 선택으로 다른 갈래를 볼 수 있다 */
export default function EndingCard() {
  const finale = useGame((s) => s.finale)
  const seen = useMemo(() => new Set(load<string[]>('endings', [])), [finale])
  if (!finale) return null
  const ending = findEnding(finale.id)

  return (
    <div className="finale" role="dialog" aria-label="엔딩">
      <div className="finale__body">
        <p className="finale__eyebrow">ENDING</p>
        <p className="finale__who">
          {ending?.who ? PEOPLE[ending.who].name : '나'} · {ending?.kind ?? ''}
        </p>
        <h2 className="finale__title">{ending?.title ?? finale.id}</h2>
        <span className="finale__line" aria-hidden />
        <p className="finale__count">
          지금까지 본 엔딩 {ENDINGS.filter((e) => seen.has(e.id)).length} / {ENDINGS.length}
        </p>
      </div>
      <footer className="finale__foot">
        <p className="finale__note">설정 앱의 날짜 선택으로 그날부터 다시 걸어 볼 수 있습니다.</p>
        <button type="button" className="btn-primary finale__close" onClick={() => director.closeFinale()}>
          폰으로 돌아가기
        </button>
      </footer>
    </div>
  )
}
