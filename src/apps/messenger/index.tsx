import { useEffect, useState } from 'react'
import { store, useGame } from '../../engine/store'
import type { RoomId } from '../../story/cast'
import ChatList from './ChatList'
import ChatRoom from './ChatRoom'
import './messenger.css'

export default function MessengerApp() {
  const [room, setRoom] = useState<RoomId | null>(() => store.get().requestedRoom)
  const requested = useGame((s) => s.requestedRoom)

  // 알림을 눌러 들어온 경우 그 방으로
  useEffect(() => {
    if (!requested) return
    setRoom(requested)
    store.set({ requestedRoom: null })
  }, [requested])

  return room ? <ChatRoom room={room} onBack={() => setRoom(null)} /> : <ChatList onOpen={setRoom} />
}
