import { director } from '../engine/director'
import { useGame } from '../engine/store'

/** 메시지가 아닌 행동을 고르는 시트 (밤의 할 일 등). 어느 화면에 있든 아래에서 올라온다 */
export default function MenuSheet() {
  const choice = useGame((s) => (s.choice?.kind === 'menu' ? s.choice : null))
  if (!choice) return null

  return (
    <div className="menu-scrim">
      <div className="menu-sheet" role="dialog" aria-label={choice.title}>
        <p className="menu-sheet__title">{choice.title}</p>
        {choice.options.map((o) => (
          <button key={o.index} type="button" className="menu-sheet__item" onClick={() => director.choose(o.index)}>
            {o.label}
          </button>
        ))}
      </div>
    </div>
  )
}
