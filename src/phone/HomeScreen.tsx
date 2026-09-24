import { useEffect, useState } from 'react'
import type { CSSProperties } from 'react'
import { APPS } from '../apps/registry'
import type { AppId } from '../apps/registry'
import { getGameTime } from '../state/gameClock'
import { WALLPAPER_SRC } from '../state/assets'

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

export default function HomeScreen({ onOpenApp }: Props) {
  const { dateLabel, timeLabel } = getGameTime()
  const hasWallpaper = useWallpaperAvailable(WALLPAPER_SRC)
  const style = hasWallpaper
    ? ({ '--wallpaper-image': `url("${WALLPAPER_SRC}")` } as CSSProperties)
    : undefined

  return (
    <div className={`screen home${hasWallpaper ? ' home--image' : ''}`} style={style}>
      <section className="clock-widget" aria-label="현재 시각">
        <div className="clock-widget__date">{dateLabel}</div>
        <div className="clock-widget__time">{timeLabel}</div>
      </section>

      <ul className="app-grid">
        {APPS.map(({ id, name, Icon, color, badge }) => (
          <li key={id}>
            <button
              type="button"
              className="app-icon"
              onClick={(e) => {
                const tile = e.currentTarget.querySelector('.app-icon__tile') ?? e.currentTarget
                onOpenApp(id, tile.getBoundingClientRect())
              }}
              aria-label={badge ? `${name}, 새 알림 ${badge}개` : name}
            >
              <span className="app-icon__tile" style={{ background: color }}>
                <Icon size={30} strokeWidth={1.9} aria-hidden />
                {badge ? <span className="badge">{badge}</span> : null}
              </span>
              <span className="app-icon__label">{name}</span>
            </button>
          </li>
        ))}
      </ul>
    </div>
  )
}
