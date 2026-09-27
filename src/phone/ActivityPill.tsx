import { ChevronRight, MessageCircle } from 'lucide-react'
import { useGame } from '../engine/store'
import type { PendingChoice } from '../engine/store'
import { ROOMS } from '../story/cast'
import type { RoomId } from '../story/cast'
import { getApp } from '../apps/registry'
import { APP_CHOICE_PROMPTS } from '../apps/ids'
import type { AppId } from '../apps/ids'

interface Props {
  /** 지금 열려 있는 앱 (그 앱이 선택을 기다리는 앱이면 알약을 숨긴다) */
  openApp: AppId | null
  onOpen: (app: AppId, rect: DOMRect) => void
  onOpenRoom: (room: RoomId, rect: DOMRect) => void
  /** home: 홈 화면 안의 카드 / inline: 다른 앱의 헤더 바로 아래 (본문을 가리지 않고 밀어 낸다) */
  variant: 'home' | 'inline'
}

interface PillInfo {
  app: AppId
  room: RoomId | null
  title: string
  text: string
}

/** 이야기가 기다리는 선택이 어디에 있는지 (메뉴 시트·무대 선택은 화면에 바로 뜨므로 없음) */
export function pendingPlace(choice: PendingChoice | null): PillInfo | null {
  if (!choice) return null
  if (choice.kind === 'app' && choice.app) {
    return { app: choice.app, room: null, title: getApp(choice.app).name, text: choice.title ?? APP_CHOICE_PROMPTS[choice.app] }
  }
  if (choice.kind === 'reply' && choice.room) {
    return { app: 'messenger', room: choice.room, title: ROOMS[choice.room].name, text: '답장을 기다리고 있어요' }
  }
  if (choice.kind === 'open') {
    return { app: 'messenger', room: null, title: '메신저', text: '먼저 열 대화방을 골라 주세요' }
  }
  return null
}

/**
 * 이야기가 기다리는 선택이 다른 곳에 있다는 알림 (다이내믹 아일랜드의 실시간 현황처럼).
 * 누르면 그 앱(또는 대화방)이 열린다. 이야기는 거기서 고를 때까지 기다린다
 */
export default function ActivityPill({ openApp, onOpen, onOpenRoom, variant }: Props) {
  const choice = useGame((s) => s.choice)
  const covered = useGame((s) => s.stage !== null || s.summary !== null || s.finale !== null)
  const viewingRoom = useGame((s) => s.viewingRoom)
  const place = pendingPlace(choice)
  if (!place || covered) return null
  // 그 앱을 보고 있으면 숨긴다. 메신저는 대화 목록(주황 점)이나 그 방을 보고 있을 때만 숨긴다
  if (openApp === place.app && (place.app !== 'messenger' || viewingRoom === null || viewingRoom === place.room)) return null
  const app = getApp(place.app)

  return (
    <button
      type="button"
      className={`activity-pill activity-pill--${variant}`}
      onClick={(e) => {
        const rect = e.currentTarget.getBoundingClientRect()
        if (place.room) onOpenRoom(place.room, rect)
        else onOpen(app.id, rect)
      }}
      aria-label={`${place.title}: ${place.text}. 누르면 열기`}
    >
      <span className="activity-pill__icon" style={{ background: app.color, color: app.fg }}>
        {place.room ? <MessageCircle size={18} fill="currentColor" aria-hidden /> : <app.Icon size={18} strokeWidth={2} aria-hidden />}
      </span>
      <span className="activity-pill__text">
        <span className="activity-pill__app">{place.title}</span>
        <span className="activity-pill__prompt">{place.text}</span>
      </span>
      <ChevronRight size={18} className="activity-pill__go" aria-hidden />
    </button>
  )
}
