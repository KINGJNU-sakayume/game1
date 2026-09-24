import { useEffect } from 'react'
import Avatar from '../components/Avatar'
import { store, useGame } from '../engine/store'
import { ROOMS } from '../story/cast'
import type { RoomId } from '../story/cast'

const SHOW_MS = 3500

interface Props {
  onOpen: (room: RoomId, rect: DOMRect) => void
}

/** 새 메시지 알림 배너 (홈·앱 화면 위) */
export default function NotificationBanner({ onOpen }: Props) {
  const banner = useGame((s) => s.banner)

  useEffect(() => {
    if (!banner) return
    const timer = window.setTimeout(() => {
      if (store.get().banner?.id === banner.id) store.set({ banner: null })
    }, SHOW_MS)
    return () => window.clearTimeout(timer)
  }, [banner])

  if (!banner) return null
  const room = ROOMS[banner.room]
  const sender = banner.from === 'me' || banner.from === 'system' ? null : banner.from

  return (
    <button
      key={banner.id}
      type="button"
      className="banner"
      onClick={(e) => {
        store.set({ banner: null })
        onOpen(banner.room, e.currentTarget.getBoundingClientRect())
      }}
    >
      {sender && <Avatar id={sender} size={38} />}
      <span className="banner__main">
        <span className="banner__title">{room.name}</span>
        <span className="banner__text">{banner.text}</span>
      </span>
    </button>
  )
}
