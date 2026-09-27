import { useCallback, useEffect, useRef, useState } from 'react'
import PhoneFrame from './phone/PhoneFrame'
import SetupScreen from './phone/SetupScreen'
import LockScreen from './phone/LockScreen'
import HomeScreen from './phone/HomeScreen'
import AppShell from './phone/AppShell'
import NotificationBanner from './phone/NotificationBanner'
import ActivityPill from './phone/ActivityPill'
import Stage from './phone/Stage'
import DaySummary from './phone/DaySummary'
import EndingCard from './phone/EndingCard'
import MenuSheet from './phone/MenuSheet'
import { director } from './engine/director'
import { setViewingApp, store, useGame } from './engine/store'
import type { Banner } from './engine/store'
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

  const onStage = useGame((s) => s.stage !== null || s.summary !== null || s.finale !== null)

  // 화면 바깥 가장자리 색을 현재 화면에 맞춘다 (global.css의 html[data-screen])
  const edge = !profile ? 'setup' : onStage ? 'stage' : openApp ? 'app' : screen
  useEffect(() => {
    document.documentElement.dataset.screen = edge
  }, [edge])

  // 설정을 마치면 대본이 흐르기 시작한다 (잠금화면에서도 메시지가 도착한다)
  const playerName = profile?.name
  useEffect(() => {
    if (playerName) director.start(playerName)
  }, [playerName])

  // 열려 있는 앱을 엔진에 알린다 (그 앱의 알림은 띄우지 않고, 새 소식은 본 것으로)
  const viewing = screen === 'home' && openApp && !openApp.closing ? openApp.id : null
  useEffect(() => {
    setViewingApp(viewing)
  }, [viewing])

  function updateProfile(next: Profile) {
    saveProfile(next)
    setProfile(next)
    director.setPlayerName(next.name)
  }

  function completeSetup(name: string) {
    updateProfile({ name })
    setScreen('lock')
  }

  function open(id: AppId, rect: DOMRect) {
    const root = phoneRef.current?.getBoundingClientRect()
    const origin = root
      ? {
          x: rect.left + rect.width / 2 - root.left,
          y: rect.top + rect.height / 2 - root.top,
        }
      : { x: 0, y: 0 }
    setScreen('home')
    setOpenApp({ id, origin, closing: false })
  }

  /** 알림·알약을 눌러 앱으로 (이미 그 앱이 열려 있으면 그대로) */
  function openAppFrom(id: AppId, rect: DOMRect) {
    if (openApp?.id === id && !openApp.closing && screen === 'home') return
    open(id, rect)
  }

  /** 알림을 눌러 메신저의 해당 방으로 */
  function openRoom(room: RoomId, rect: DOMRect) {
    store.set({ requestedRoom: room })
    if (openApp?.id !== 'messenger' || openApp.closing || screen !== 'home') open('messenger', rect)
  }

  function openBanner(banner: Banner, rect: DOMRect) {
    if (banner.room) openRoom(banner.room, rect)
    else openAppFrom(banner.app, rect)
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
    content = <LockScreen onUnlock={() => setScreen('home')} onOpenRoom={openRoom} onOpenApp={openAppFrom} />
  } else {
    const app = openApp && getApp(openApp.id)
    content = (
      <>
        <HomeScreen onOpenApp={open} />
        {openApp && app && (
          <AppShell
            key={openApp.id}
            title={app.name}
            tone={app.id === 'tube' ? 'dark' : 'default'}
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
        {openApp && !openApp.closing && <ActivityPill variant="floating" openApp={openApp.id} onOpen={openAppFrom} />}
        <NotificationBanner onOpen={openBanner} />
      </>
    )
  }

  return (
    <PhoneFrame ref={phoneRef}>
      {content}
      {profile && screen !== 'setup' && <Stage />}
      {profile && screen !== 'setup' && <MenuSheet />}
      {profile && screen !== 'setup' && <DaySummary />}
      {profile && screen !== 'setup' && <EndingCard />}
    </PhoneFrame>
  )
}
