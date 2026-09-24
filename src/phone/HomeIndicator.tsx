import { useSwipeUp } from './useSwipeUp'

interface Props {
  onSwipeUp: () => void
}

/** 앱 하단의 홈 인디케이터. 위로 스와이프하면 홈으로. */
export default function HomeIndicator({ onSwipeUp }: Props) {
  const swipe = useSwipeUp({ onSwipeUp })
  return (
    <div className="home-indicator" {...swipe} role="button" aria-label="홈으로 (위로 스와이프)">
      <div className="home-indicator__bar" />
    </div>
  )
}
