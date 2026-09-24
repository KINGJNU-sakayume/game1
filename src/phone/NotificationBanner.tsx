import { useEffect, useRef, useState } from 'react'
import type { PointerEvent } from 'react'
import Avatar from '../components/Avatar'
import { store, useGame } from '../engine/store'
import { ROOMS } from '../story/cast'
import type { RoomId } from '../story/cast'

const SHOW_MS = 3500
/** 이만큼 위로 밀면 숨긴다 (px) */
const DISMISS_DISTANCE = 30
const TAP_SLOP = 8

interface Props {
  onOpen: (room: RoomId, rect: DOMRect) => void
}

/** 새 메시지 알림 배너 (홈·앱 화면 위). 누르면 그 방으로, 위로 밀면 숨김 */
export default function NotificationBanner({ onOpen }: Props) {
  const banner = useGame((s) => s.banner)
  const [drag, setDrag] = useState(0)
  const [leaving, setLeaving] = useState(false)
  const start = useRef<{ y: number; id: number } | null>(null)

  // 새 알림이 오면 끌던 상태를 초기화
  useEffect(() => {
    setDrag(0)
    setLeaving(false)
  }, [banner?.id])

  // 저절로 사라지기 (끄는 중에는 멈춤)
  useEffect(() => {
    if (!banner || drag !== 0 || leaving) return
    const timer = window.setTimeout(() => {
      if (store.get().banner?.id === banner.id) store.set({ banner: null })
    }, SHOW_MS)
    return () => window.clearTimeout(timer)
  }, [banner, drag, leaving])

  if (!banner) return null
  const room = ROOMS[banner.room]
  const sender = banner.from === 'me' || banner.from === 'system' ? null : banner.from

  function dismiss(id: number) {
    setLeaving(true)
    // 위로 빠져나가는 애니메이션 뒤에 지운다
    window.setTimeout(() => {
      if (store.get().banner?.id === id) store.set({ banner: null })
    }, 200)
  }

  function onPointerDown(e: PointerEvent<HTMLButtonElement>) {
    start.current = { y: e.clientY, id: banner!.id }
    e.currentTarget.setPointerCapture(e.pointerId)
  }

  function onPointerMove(e: PointerEvent<HTMLButtonElement>) {
    if (!start.current) return
    const dy = e.clientY - start.current.y
    // 위로는 손가락을 따라가고, 아래로는 조금만 늘어난다
    setDrag(dy < 0 ? dy : Math.min(dy * 0.2, 12))
  }

  function onPointerUp(e: PointerEvent<HTMLButtonElement>) {
    const s = start.current
    start.current = null
    if (!s) return
    const dy = e.clientY - s.y
    if (dy < -DISMISS_DISTANCE) {
      dismiss(s.id)
    } else if (Math.abs(dy) < TAP_SLOP) {
      store.set({ banner: null })
      onOpen(banner!.room, e.currentTarget.getBoundingClientRect())
    } else {
      setDrag(0)
    }
  }

  const style = leaving
    ? { transform: 'translateY(-140%)', opacity: 0, transition: 'transform 200ms ease-in, opacity 200ms ease-in' }
    : drag !== 0
      ? { transform: `translateY(${drag}px)`, opacity: Math.max(0.3, 1 + drag / 120), transition: 'none' }
      : { transition: 'transform 200ms var(--ease-app), opacity 200ms' }

  return (
    <button
      key={banner.id}
      type="button"
      className="banner"
      style={style}
      onPointerDown={onPointerDown}
      onPointerMove={onPointerMove}
      onPointerUp={onPointerUp}
      onClick={(e) => {
        // 키보드(Enter·Space)로 누른 경우. 터치·마우스는 onPointerUp에서 처리
        if (e.detail !== 0) return
        store.set({ banner: null })
        onOpen(banner.room, e.currentTarget.getBoundingClientRect())
      }}
      onPointerCancel={() => {
        start.current = null
        setDrag(0)
      }}
      aria-label={`${room.name}: ${banner.text}. 누르면 열기, 위로 밀면 숨기기`}
    >
      {sender && <Avatar id={sender} size={38} />}
      <span className="banner__main">
        <span className="banner__title">{room.name}</span>
        <span className="banner__text">{banner.text}</span>
      </span>
      <span className="banner__grabber" aria-hidden />
    </button>
  )
}
