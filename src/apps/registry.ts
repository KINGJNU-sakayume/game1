import type { ComponentType } from 'react'
import {
  Aperture,
  CalendarDays,
  HouseHeart,
  Images,
  MapPinned,
  MessageCircle,
  Phone,
  Settings,
  SquarePlay,
  StickyNote,
} from 'lucide-react'
import type { LucideIcon } from 'lucide-react'
import type { Profile } from '../state/storage'
import { APP_NAMES } from './ids'
import type { AppId } from './ids'
import MessengerApp from './messenger'
import CallApp from './call'
import PhotosApp from './photos'
import CalendarApp from './calendar'
import NotesApp from './notes'
import TubeApp from './tube'
import MapApp from './map'
import SnapApp from './snap'
import TownApp from './town'
import SettingsApp from './settings'

export type { AppId } from './ids'

/** 모든 앱이 받는 공통 props */
export interface AppProps {
  profile: Profile
  onRename: (name: string) => void
  onReset: () => void
  /** 그 날짜의 시작 지점부터 다시 */
  onRewind: (day: number) => void
}

export interface AppDef {
  id: AppId
  name: string
  Icon: LucideIcon
  /** 아이콘 타일 배경 (tokens.css 변수) */
  color: string
  /** 아이콘 색. 없으면 흰색 */
  fg?: string
  /** 홈 화면 아래 독에 둔다 */
  dock?: boolean
  /** 이 앱이 이야기에서 맡는 일 (06_UI_연출_명세.md 5장) */
  role: string
  Component: ComponentType<AppProps>
}

const app = (def: Omit<AppDef, 'name'>): AppDef => ({ ...def, name: APP_NAMES[def.id] })

export const APPS: AppDef[] = [
  app({ id: 'messenger', Icon: MessageCircle, color: 'var(--app-messenger)', dock: true, role: '대화', Component: MessengerApp }),
  app({ id: 'call', Icon: Phone, color: 'var(--app-call)', dock: true, role: '목소리 · 연락처 · 음성사서함', Component: CallApp }),
  app({ id: 'tube', Icon: SquarePlay, color: 'var(--app-tube)', fg: 'var(--app-tube-fg)', dock: true, role: '수리 배우기', Component: TubeApp }),
  app({ id: 'map', Icon: MapPinned, color: 'var(--app-map)', dock: true, role: '갈 곳 고르기', Component: MapApp }),
  app({ id: 'photos', Icon: Images, color: 'var(--app-photos)', fg: 'var(--app-photos-fg)', role: '찍고 저장하고 보내기', Component: PhotosApp }),
  app({ id: 'calendar', Icon: CalendarDays, color: 'var(--app-calendar-tile)', fg: 'var(--app-calendar)', role: '약속과 마감', Component: CalendarApp }),
  app({ id: 'notes', Icon: StickyNote, color: 'var(--app-notes)', role: '속마음 · 할 일 · 사장님 수첩', Component: NotesApp }),
  app({ id: 'snap', Icon: Aperture, color: 'var(--app-snap)', role: '그 사람의 보이는 얼굴', Component: SnapApp }),
  app({ id: 'town', Icon: HouseHeart, color: 'var(--app-town)', role: '동네 소식 · 나눔 · 부탁', Component: TownApp }),
  app({ id: 'settings', Icon: Settings, color: 'var(--app-settings)', role: '나와 이 번호', Component: SettingsApp }),
]

export function getApp(id: AppId): AppDef {
  return APPS.find((a) => a.id === id)!
}
