import type { ComponentType } from 'react'
import { CalendarDays, Images, MessageCircle, Phone, Settings, StickyNote } from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import type { Profile } from '../state/storage'
import MessengerApp from './messenger'
import CallApp from './call'
import PhotosApp from './photos'
import CalendarApp from './calendar'
import NotesApp from './notes'
import SettingsApp from './settings'

export type AppId = 'messenger' | 'call' | 'photos' | 'calendar' | 'notes' | 'settings'

/** 모든 앱이 받는 공통 props */
export interface AppProps {
  profile: Profile
  onRename: (name: string) => void
  onReset: () => void
}

export interface AppDef {
  id: AppId
  name: string
  Icon: LucideIcon
  color: string
  /** 홈 아이콘 배지 (M1은 더미) */
  badge?: number
  Component: ComponentType<AppProps>
}

export const APPS: AppDef[] = [
  { id: 'messenger', name: '메신저', Icon: MessageCircle, color: 'var(--app-messenger)', badge: 3, Component: MessengerApp },
  { id: 'call', name: '전화', Icon: Phone, color: 'var(--app-call)', Component: CallApp },
  { id: 'photos', name: '사진', Icon: Images, color: 'var(--app-photos)', Component: PhotosApp },
  { id: 'calendar', name: '캘린더', Icon: CalendarDays, color: 'var(--app-calendar)', Component: CalendarApp },
  { id: 'notes', name: '메모', Icon: StickyNote, color: 'var(--app-notes)', Component: NotesApp },
  { id: 'settings', name: '설정', Icon: Settings, color: 'var(--app-settings)', Component: SettingsApp },
]

export function getApp(id: AppId): AppDef {
  return APPS.find((app) => app.id === id)!
}
