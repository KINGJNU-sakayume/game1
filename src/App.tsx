import { useCallback, useEffect, useRef, useState } from 'react'
import PhoneFrame from './phone/PhoneFrame'
import SetupScreen from './phone/SetupScreen'
import LockScreen from './phone/LockScreen'
import HomeScreen from './phone/HomeScreen'
import AppShell from './phone/AppShell'
import NotificationBanner from './phone/NotificationBanner'
import { director } from './engine/director'
import { store } from './engine/store'
import type { RoomId } from './story/cast'
import { getApp } from './apps/registry'
import type { AppId } from './apps/registry'
import { clearAll, loadProfile, saveProfile } from './state/storage'
import type { Profile } from './state/storage'

type Screen = 'setup' | 'lock' | 'home'

interface OpenApp {
  id: AppId
  origin: { x: number; y: number }
  closing: boolean
}

export default function App() {
  const [profile, setProfile] = useState<Profile | null>(loadProfile)
  const [screen, setScreen] = useState<Screen>(() => (profile ? 'lock' : 'setup'))
  const [openApp, setOpenApp] = useState<OpenApp | null>(null)
  const phoneRef = useRef<HTMLDivElement>(null)

  // 화면 바깥 가장자리 색을 현재 화면에 맞춘다 (global.css의 html[data-screen])
  const edge = !profile ? 'setup' : openApp ? 'app' : screen
  useEffect(() => {
    document.documentElement.dataset.screen = edge
  }, [edge])

  // 설정을 마치면 대본이 흐르기 시작한다 (잠금화면에서도 메시지가 도착한다)
  const playerName = profile?.name
  useEffect(() => {
    if (playerName) director.start(playerName)
  }, [playerName])

  function updateProfile(next: Profile) {
    saveProfile(next)
    setProfile(next)
    director.setPlayerName(next.name)
  }

  function completeSetup(name: string) {
    updateProfile({ name })
    setScreen('lock')
  }

  function open(id: AppId, iconRect: DOMRect) {
    const root = phoneRef.current?.getBoundingClientRect()
    const origin = root
      ? {
          x: iconRect.left + iconRect.width / 2 - root.left,
          y: iconRect.top + iconRect.height / 2 - root.top,
        }
      : { x: 0, y: 0 }
    setOpenApp({ id, origin, closing: false })
  }

  /** 알림을 눌러 메신저의 해당 방으로 */
  function openRoom(room: RoomId, rect: DOMRect) {
    store.set({ requestedRoom: room })
    setScreen('home')
    if (openApp?.id !== 'messenger' || openApp.closing) open('messenger', rect)
  }

  function close() {
    setOpenApp((app) => (app && !app.closing ? { ...app, closing: true } : app))
  }

  const handleClosed = useCallback(() => setOpenApp(null), [])

  function rewind(day: number) {
    if (profile && director.rewind(day, profile.name)) close()
  }

  function reset() {
    director.reset()
    clearAll()
    setOpenApp(null)
    setProfile(null)
    setScreen('setup')
  }

  let content
  if (!profile || screen === 'setup') {
    content = <SetupScreen onComplete={completeSetup} />
  } else if (screen === 'lock') {
    content = <LockScreen onUnlock={() => setScreen('home')} onOpenRoom={openRoom} />
  } else {
    const app = openApp && getApp(openApp.id)
    content = (
      <>
        <HomeScreen onOpenApp={open} />
        {openApp && app && (
          <AppShell
            key={openApp.id}
            title={app.name}
            origin={openApp.origin}
            closing={openApp.closing}
            onClose={close}
            onClosed={handleClosed}
          >
            <app.Component
              profile={profile}
              onRename={(name) => updateProfile({ ...profile, name })}
              onReset={reset}
              onRewind={rewind}
            />
          </AppShell>
        )}
        <NotificationBanner onOpen={openRoom} />
      </>
    )
  }

  return <PhoneFrame ref={phoneRef}>{content}</PhoneFrame>
}
