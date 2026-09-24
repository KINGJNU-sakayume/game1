import { MessageCircle } from 'lucide-react'
import { useGame } from '../engine/store'
import { ROOMS } from '../story/cast'
import type { RoomId } from '../story/cast'
import { useGameTime } from '../state/gameClock'
import { useSwipeUp } from './useSwipeUp'

interface Props {
  onUnlock: () => void
  onOpenRoom: (room: RoomId, rect: DOMRect) => void
}

export default function LockScreen({ onUnlock, onOpenRoom }: Props) {
  const { dateLabel, timeLabel } = useGameTime()
  const unread = useGame((s) => s.unread)
  const swipe = useSwipeUp({ onSwipeUp: onUnlock, onTap: onUnlock })
  const rooms = (Object.keys(unread) as RoomId[]).filter((room) => (unread[room] ?? 0) > 0)

  return (
    <div className="screen lock" {...swipe}>
      <div className="lock__date">{dateLabel}</div>
      <div className="lock__time">{timeLabel}</div>

      <div className="lock__notifications">
        {rooms.map((room) => (
          <button
            key={room}
            type="button"
            className="notification"
            // 잠금화면 전체의 스와이프 처리가 탭을 가로채지 않게
            onPointerDown={(e) => e.stopPropagation()}
            onPointerUp={(e) => e.stopPropagation()}
            onClick={(e) => onOpenRoom(room, e.currentTarget.getBoundingClientRect())}
          >
            <span className="notification__icon">
              <MessageCircle size={22} fill="currentColor" aria-hidden />
            </span>
            <span className="notification__body">
              <span className="notification__title">{ROOMS[room].name}</span>
              <span className="notification__text">새 메시지 {unread[room]}개</span>
            </span>
          </button>
        ))}
      </div>

      <div className="lock__hint">위로 밀어서 열기</div>
    </div>
  )
}
