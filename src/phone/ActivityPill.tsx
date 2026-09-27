import { ChevronRight } from 'lucide-react'
import { useGame } from '../engine/store'
import { getApp } from '../apps/registry'
import { APP_CHOICE_PROMPTS } from '../apps/ids'
import type { AppId } from '../apps/ids'

interface Props {
  /** 지금 열려 있는 앱 (그 앱이 선택을 기다리는 앱이면 알약을 숨긴다) */
  openApp: AppId | null
  onOpen: (app: AppId, rect: DOMRect) => void
  /** home: 홈 화면 안의 카드 / floating: 다른 앱 위에 뜨는 알약 */
  variant: 'home' | 'floating'
}

/**
 * 앱 안에서 골라야 하는 선택지가 떴다는 알림 (다이내믹 아일랜드의 실시간 현황처럼).
 * 누르면 그 앱이 열린다. 이야기는 그 앱에서 고를 때까지 기다린다
 */
export default function ActivityPill({ openApp, onOpen, variant }: Props) {
  const choice = useGame((s) => (s.choice?.kind === 'app' ? s.choice : null))
  const covered = useGame((s) => s.stage !== null || s.summary !== null || s.finale !== null)
  if (!choice?.app || covered || openApp === choice.app) return null
  const app = getApp(choice.app)
  const text = choice.title ?? APP_CHOICE_PROMPTS[choice.app]

  return (
    <button
      type="button"
      className={`activity-pill activity-pill--${variant}`}
      onClick={(e) => onOpen(app.id, e.currentTarget.getBoundingClientRect())}
      aria-label={`${app.name}: ${text}. 누르면 열기`}
    >
      <span className="activity-pill__icon" style={{ background: app.color, color: app.fg }}>
        <app.Icon size={18} strokeWidth={2} aria-hidden />
      </span>
      <span className="activity-pill__text">
        <span className="activity-pill__app">{app.name}</span>
        <span className="activity-pill__prompt">{text}</span>
      </span>
      <ChevronRight size={18} className="activity-pill__go" aria-hidden />
    </button>
  )
}
