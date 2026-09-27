import { useState } from 'react'
import StoryImage from '../../components/StoryImage'
import PhotoViewer from '../../components/PhotoViewer'
import { useGame } from '../../engine/store'
import type { SavedPhoto } from '../../engine/store'
import { formatDay } from '../../state/gameClock'
import './photos.css'

type Album = 'all' | 'received' | 'mine'

const ALBUMS: { id: Album; label: string }[] = [
  { id: 'all', label: '모든 사진' },
  { id: 'received', label: '받은 사진' },
  { id: 'mine', label: '내가 찍은 사진' },
]

/**
 * 사진첩: 저장한 사진과 주인공이 찍은 사진만 남는다.
 * 여기 있는 사진만 대화방에서 "사진 보내기"(# attach:)로 보낼 수 있다.
 */
export default function PhotosApp() {
  const photos = useGame((s) => s.journal.photos)
  const [album, setAlbum] = useState<Album>('all')
  const [viewing, setViewing] = useState<SavedPhoto | null>(null)

  if (photos.length === 0) {
    return (
      <div className="coming-soon photos__empty">
        <p>저장한 사진이 없습니다</p>
        <p className="photos__hint">받은 사진은 크게 본 뒤 “사진첩에 저장”을 눌러야 남습니다.</p>
      </div>
    )
  }

  const shown = photos.filter((p) => album === 'all' || (album === 'mine' ? p.from === null : p.from !== null))
  // 날짜별로 묶어 최근 날짜가 위로
  const days = [...new Set(shown.map((p) => p.day))].sort((a, b) => b - a)

  return (
    <div className="photos">
      <div className="segmented photos__albums" role="tablist">
        {ALBUMS.map((a) => (
          <button
            key={a.id}
            type="button"
            role="tab"
            aria-selected={album === a.id}
            aria-checked={album === a.id}
            className="segmented__item"
            onClick={() => setAlbum(a.id)}
          >
            {a.label}
          </button>
        ))}
      </div>
      {days.length === 0 && <p className="photos__none">이 앨범은 비어 있습니다</p>}
      {days.map((day) => (
        <section key={day}>
          <h2 className="photos__day">{formatDay(day)}</h2>
          <div className="photos__grid">
            {shown
              .filter((p) => p.day === day)
              .map((p) => (
                <button key={p.name} type="button" className="photos__item" onClick={() => setViewing(p)} aria-label={p.name}>
                  <StoryImage name={p.name} alt="" />
                </button>
              ))}
          </div>
        </section>
      ))}
      <p className="photos__hint photos__hint--foot">사진첩의 사진은 대화방에서 보낼 수 있습니다.</p>
      {viewing && <PhotoViewer name={viewing.name} alt="" info={viewing} onClose={() => setViewing(null)} />}
    </div>
  )
}
