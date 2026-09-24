import { useRef } from 'react'
import type { PointerEvent } from 'react'

const SWIPE_DISTANCE = 40
const TAP_SLOP = 10

interface Options {
  onSwipeUp: () => void
  /** 거의 움직이지 않고 뗐을 때 */
  onTap?: () => void
}

/** 위로 스와이프(또는 탭)를 감지하는 포인터 핸들러 묶음 */
export function useSwipeUp({ onSwipeUp, onTap }: Options) {
  const start = useRef<{ x: number; y: number } | null>(null)

  return {
    onPointerDown(e: PointerEvent<HTMLElement>) {
      start.current = { x: e.clientX, y: e.clientY }
      // 손가락·마우스가 요소 밖으로 나가도 pointerup을 받도록
      try {
        e.currentTarget.setPointerCapture(e.pointerId)
      } catch {
        // 캡처 불가 환경은 무시
      }
    },
    onPointerUp(e: PointerEvent<HTMLElement>) {
      const s = start.current
      start.current = null
      if (!s) return
      const dx = e.clientX - s.x
      const dy = e.clientY - s.y
      if (dy < -SWIPE_DISTANCE && Math.abs(dy) > Math.abs(dx)) onSwipeUp()
      else if (onTap && Math.hypot(dx, dy) < TAP_SLOP) onTap()
    },
    onPointerCancel() {
      start.current = null
    },
  }
}
