import { MessageCircle } from 'lucide-react'
import { getGameTime } from '../state/gameClock'
import { useSwipeUp } from './useSwipeUp'

interface Props {
  onUnlock: () => void
}

export default function LockScreen({ onUnlock }: Props) {
  const { dateLabel, timeLabel } = getGameTime()
  const swipe = useSwipeUp({ onSwipeUp: onUnlock, onTap: onUnlock })

  return (
    <div className="screen lock" {...swipe}>
      <div className="lock__date">{dateLabel}</div>
      <div className="lock__time">{timeLabel}</div>

      <div className="lock__notifications">
        <div className="notification">
          <div className="notification__icon">
            <MessageCircle size={22} fill="currentColor" aria-hidden />
          </div>
          <div>
            <div className="notification__title">만물수선 단골방</div>
            <div className="notification__text">새 메시지 3개</div>
          </div>
        </div>
      </div>

      <div className="lock__hint">위로 밀어서 열기</div>
    </div>
  )
}
