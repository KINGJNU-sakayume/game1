import { useEffect, useState } from 'react'
import type { CSSProperties } from 'react'
import { CloudRain, CloudSun, Sun } from 'lucide-react'
import { APPS } from '../apps/registry'
import type { AppDef, AppId } from '../apps/registry'
import { useGameTime } from '../state/gameClock'
import { appBadge, useGame } from '../engine/store'
import { WALLPAPER_SRC } from '../state/assets'
import { weatherOf } from '../story/weather'
import ActivityPill from './ActivityPill'

interface Props {
  onOpenApp: (id: AppId, iconRect: DOMRect) => void
}

/** 배경화면 파일이 실제로 있을 때만 true */
function useWallpaperAvailable(src: string) {
  const [ok, setOk] = useState(false)
  useEffect(() => {
    const img = new Image()
    img.onload = () => setOk(true)
    img.src = src
    return () => {
      img.onload = null
    }
  }, [src])
  return ok
}

function AppIcon({ app, onOpenApp }: { app: AppDef; onOpenApp: Props['onOpenApp'] }) {
  const badge = useGame((s) => appBadge(s, app.id))
  const waiting = useGame((s) => s.choice?.kind === 'app' && s.choice.app === app.id)
  const { id, name, Icon, color, fg } = app
  return (
    <li>
      <button
        type="button"
        className="app-icon"
        onClick={(e) => {
          const tile = e.currentTarget.querySelector('.app-icon__tile') ?? e.currentTarget
          onOpenApp(id, tile.getBoundingClientRect())
        }}
        aria-label={`${name}${badge ? `, 새 알림 ${badge}개` : ''}${waiting ? ', 고를 것이 있음' : ''}`}
      >
        <span className="app-icon__tile" style={{ background: color, color: fg }}>
          <Icon size={30} strokeWidth={1.9} aria-hidden />
          {badge ? <span className="badge">{badge}</span> : waiting ? <span className="app-icon__dot" /> : null}
        </span>
        <span className="app-icon__label">{name}</span>
      </button>
    </li>
  )
}

export default function HomeScreen({ onOpenApp }: Props) {
  const { dateLabel, timeLabel } = useGameTime()
  const day = useGame((s) => s.clock.day)
  const hasWallpaper = useWallpaperAvailable(WALLPAPER_SRC)
  const style = hasWallpaper ? ({ '--wallpaper-image': `url("${WALLPAPER_SRC}")` } as CSSProperties) : undefined
  const weather = weatherOf(day)
  const WeatherIcon = weather.sky === '비' ? CloudRain : weather.sky === '맑음' ? Sun : CloudSun

  return (
    <div className={`screen home${hasWallpaper ? ' home--image' : ''}`} style={style}>
      <section className="clock-widget" aria-label="현재 시각">
        <div className="clock-widget__date">{dateLabel}</div>
        <div className="clock-widget__time">{timeLabel}</div>
        <div className="clock-widget__weather">
          <WeatherIcon size={16} aria-hidden /> 망원동 {weather.sky} {weather.temp}°
        </div>
      </section>

      <ActivityPill variant="home" openApp={null} onOpen={onOpenApp} />

      <ul className="app-grid">
        {APPS.filter((a) => !a.dock).map((app) => (
          <AppIcon key={app.id} app={app} onOpenApp={onOpenApp} />
        ))}
      </ul>

      <div className="home__spacer" />

      <ul className="dock" aria-label="독">
        {APPS.filter((a) => a.dock).map((app) => (
          <AppIcon key={app.id} app={app} onOpenApp={onOpenApp} />
        ))}
      </ul>
    </div>
  )
}
