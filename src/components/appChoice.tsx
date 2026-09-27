import { Sparkles } from 'lucide-react'
import { director } from '../engine/director'
import { useGame } from '../engine/store'
import type { ChoiceOption, PendingChoice } from '../engine/store'
import { APP_CHOICE_PROMPTS } from '../apps/ids'
import type { AppId } from '../apps/ids'
import './components.css'

/** 이 앱 안에서 골라야 하는 선택지 (없으면 null) */
export function useAppChoice(app: AppId): PendingChoice | null {
  return useGame((s) => (s.choice?.kind === 'app' && s.choice.app === app ? s.choice : null))
}

/** 앱 선택지 중 이 앱의 대상이 있는 것 / 없는 보조 선택 ("오늘은 안 보기" 같은) */
export function splitOptions(choice: PendingChoice | null): { main: ChoiceOption[]; extra: ChoiceOption[] } {
  const options = choice?.options ?? []
  return { main: options.filter((o) => o.app !== null), extra: options.filter((o) => o.app === null) }
}

/** 앱 위쪽에 뜨는 "이야기가 기다리는 선택" 안내 */
export function ChoicePrompt({ choice, app }: { choice: PendingChoice; app: AppId }) {
  return (
    <p className="app-choice__prompt" role="status">
      <Sparkles size={16} aria-hidden />
      {choice.title ?? APP_CHOICE_PROMPTS[app]}
    </p>
  )
}

/** 보조 선택 버튼들 */
export function ExtraChoices({ options }: { options: ChoiceOption[] }) {
  if (options.length === 0) return null
  return (
    <div className="app-choice__extra">
      {options.map((o) => (
        <button key={o.index} type="button" className="app-choice__extra-btn" onClick={() => director.choose(o.index)}>
          {o.label}
        </button>
      ))}
    </div>
  )
}

/** 앱이 따로 그리지 않는 선택지를 카드로 (설정 앱의 번호 변경 등) */
export function ChoiceCard({ choice, app }: { choice: PendingChoice; app: AppId }) {
  return (
    <section className="app-choice__card" aria-label="고를 것">
      <ChoicePrompt choice={choice} app={app} />
      <div className="app-choice__card-list">
        {choice.options.map((o) => (
          <button
            key={o.index}
            type="button"
            className={`app-choice__card-btn${o.app ? ' is-main' : ''}`}
            onClick={() => director.choose(o.index)}
          >
            {o.label}
          </button>
        ))}
      </div>
    </section>
  )
}
