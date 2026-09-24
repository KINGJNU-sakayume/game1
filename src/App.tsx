import { useCallback, useEffect, useRef, useState } from 'react'
import PhoneFrame from './phone/PhoneFrame'
import SetupScreen from './phone/SetupScreen'
import LockScreen from './phone/LockScreen'
import HomeScreen from './phone/HomeScreen'
import AppShell from './phone/AppShell'
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

  function updateProfile(next: Profile) {
    saveProfile(next)
    setProfile(next)
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

  function close() {
    setOpenApp((app) => (app && !app.closing ? { ...app, closing: true } : app))
  }

  const handleClosed = useCallback(() => setOpenApp(null), [])

  function reset() {
    clearAll()
    setOpenApp(null)
    setProfile(null)
    setScreen('setup')
  }

  let content
  if (!profile || screen === 'setup') {
    content = <SetupScreen onComplete={completeSetup} />
  } else if (screen === 'lock') {
    content = <LockScreen onUnlock={() => setScreen('home')} />
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
            />
          </AppShell>
        )}
      </>
    )
  }

  return <PhoneFrame ref={phoneRef}>{content}</PhoneFrame>
}
