import { useEffect } from 'react'
import type { AnimationEvent, ReactNode } from 'react'
import { ChevronLeft } from 'lucide-react'
import HomeIndicator from './HomeIndicator'

interface Props {
  title: string
  /** 확대·축소 기준점 (폰 루트 기준 px) */
  origin: { x: number; y: number }
  closing: boolean
  onClose: () => void
  onClosed: () => void
  children: ReactNode
}

const CLOSE_FALLBACK_MS = 400

/** 모든 앱의 공통 껍데기: 헤더 + 스크롤 본문 + 홈 인디케이터 */
export default function AppShell({ title, origin, closing, onClose, onClosed, children }: Props) {
  // animationend가 오지 않는 경우(탭 전환 등)에도 반드시 닫히게 한다
  useEffect(() => {
    if (!closing) return
    const timer = window.setTimeout(onClosed, CLOSE_FALLBACK_MS)
    return () => window.clearTimeout(timer)
  }, [closing, onClosed])

  function handleAnimationEnd(e: AnimationEvent<HTMLDivElement>) {
    if (closing && e.target === e.currentTarget) onClosed()
  }

  return (
    <div
      className={`app-shell ${closing ? 'is-closing' : 'is-opening'}`}
      style={{ transformOrigin: `${origin.x}px ${origin.y}px` }}
      onAnimationEnd={handleAnimationEnd}
      role="dialog"
      aria-label={title}
    >
      <header className="app-header">
        <button type="button" className="app-header__back" onClick={onClose} aria-label="홈으로">
          <ChevronLeft size={28} aria-hidden />
        </button>
        <h1 className="app-header__title">{title}</h1>
      </header>
      <main className="app-body">{children}</main>
      <HomeIndicator onSwipeUp={onClose} />
    </div>
  )
}
