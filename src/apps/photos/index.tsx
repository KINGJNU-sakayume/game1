import { useState } from 'react'
import StoryImage from '../../components/StoryImage'
import PhotoViewer from '../../components/PhotoViewer'
import { useGame } from '../../engine/store'
import type { SavedPhoto } from '../../engine/store'
import { formatDay } from '../../state/gameClock'
import './photos.css'

/** 사진첩: 저장한 사진과 주인공이 찍은 사진만 남는다 */
export default function PhotosApp() {
  const photos = useGame((s) => s.journal.photos)
  const [viewing, setViewing] = useState<SavedPhoto | null>(null)

  if (photos.length === 0) return <div className="coming-soon">저장한 사진이 없습니다</div>

  // 날짜별로 묶어 최근 날짜가 위로
  const days = [...new Set(photos.map((p) => p.day))].sort((a, b) => b - a)

  return (
    <div className="photos">
      {days.map((day) => (
        <section key={day}>
          <h2 className="photos__day">{formatDay(day)}</h2>
          <div className="photos__grid">
            {photos
              .filter((p) => p.day === day)
              .map((p) => (
                <button key={p.name} type="button" className="photos__item" onClick={() => setViewing(p)} aria-label={p.name}>
                  <StoryImage name={p.name} alt="" />
                </button>
              ))}
          </div>
        </section>
      ))}
      {viewing && <PhotoViewer name={viewing.name} alt="" onClose={() => setViewing(null)} />}
    </div>
  )
}
