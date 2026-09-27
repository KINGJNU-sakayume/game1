import type { ReactNode } from 'react'
import { MessageCircle } from 'lucide-react'
import { appBadge, useGame } from '../engine/store'
import { ROOMS } from '../story/cast'
import type { RoomId } from '../story/cast'
import { getApp } from '../apps/registry'
import type { AppId } from '../apps/ids'
import { pendingPlace } from './ActivityPill'
import { useGameTime } from '../state/gameClock'
import { useSwipeUp } from './useSwipeUp'

interface Props {
  onUnlock: () => void
  onOpenRoom: (room: RoomId, rect: DOMRect) => void
  onOpenApp: (app: AppId, rect: DOMRect) => void
}

/** 앱별 알림 문구 (메신저 말고) */
const APP_NOTICE: Partial<Record<AppId, (n: number) => string>> = {
  call: (n) => `부재중 전화·음성 메시지 ${n}개`,
  snap: (n) => `새 게시물 ${n}개`,
  town: (n) => `동네 새 글 ${n}개`,
}

function Notice({ icon, title, text, onOpen }: { icon: ReactNode; title: string; text: string; onOpen: (rect: DOMRect) => void }) {
  return (
    <button
      type="button"
      className="notification"
      // 잠금화면 전체의 스와이프 처리가 탭을 가로채지 않게
      onPointerDown={(e) => e.stopPropagation()}
      onPointerUp={(e) => e.stopPropagation()}
      onClick={(e) => onOpen(e.currentTarget.getBoundingClientRect())}
    >
      {icon}
      <span className="notification__body">
        <span className="notification__title">{title}</span>
        <span className="notification__text">{text}</span>
      </span>
    </button>
  )
}

export default function LockScreen({ onUnlock, onOpenRoom, onOpenApp }: Props) {
  const { dateLabel, timeLabel } = useGameTime()
  const unread = useGame((s) => s.unread)
  const choice = useGame((s) => s.choice)
  const place = pendingPlace(choice)
  // useGame은 매번 같은 값을 돌려줘야 하므로 앱마다 따로 읽는다
  const callBadge = useGame((s) => appBadge(s, 'call'))
  const snapBadge = useGame((s) => appBadge(s, 'snap'))
  const townBadge = useGame((s) => appBadge(s, 'town'))
  const badges: [AppId, number][] = [
    ['call', callBadge],
    ['snap', snapBadge],
    ['town', townBadge],
  ]
  const swipe = useSwipeUp({ onSwipeUp: onUnlock, onTap: onUnlock })
  const rooms = (Object.keys(unread) as RoomId[]).filter((room) => (unread[room] ?? 0) > 0)

  function appIcon(app: AppId) {
    const def = getApp(app)
    return (
      <span className="notification__icon" style={{ background: def.color, color: def.fg }}>
        <def.Icon size={20} aria-hidden />
      </span>
    )
  }

  return (
    <div className="screen lock" {...swipe}>
      <div className="lock__date">{dateLabel}</div>
      <div className="lock__time">{timeLabel}</div>

      <div className="lock__notifications">
        {place && (
          <Notice
            icon={appIcon(place.app)}
            title={place.title}
            text={place.text}
            onOpen={(rect) => (place.room ? onOpenRoom(place.room, rect) : onOpenApp(place.app, rect))}
          />
        )}
        {rooms.map((room) => (
          <Notice
            key={room}
            icon={
              <span className="notification__icon">
                <MessageCircle size={22} fill="currentColor" aria-hidden />
              </span>
            }
            title={ROOMS[room].name}
            text={`새 메시지 ${unread[room]}개`}
            onOpen={(rect) => onOpenRoom(room, rect)}
          />
        ))}
        {badges
          .filter(([, n]) => n > 0)
          .map(([app, n]) => (
            <Notice
              key={app}
              icon={appIcon(app)}
              title={getApp(app).name}
              text={APP_NOTICE[app]!(n)}
              onOpen={(rect) => onOpenApp(app, rect)}
            />
          ))}
      </div>

      <div className="lock__hint">위로 밀어서 열기</div>
    </div>
  )
}
