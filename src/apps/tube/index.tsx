import { useState } from 'react'
import { CircleCheck, Library, Play } from 'lucide-react'
import { director } from '../../engine/director'
import { useGame } from '../../engine/store'
import type { ChoiceOption } from '../../engine/store'
import { VIDEOS, isVideoId } from '../../story/videos'
import type { VideoId } from '../../story/videos'
import { formatDay } from '../../state/gameClock'
import { storyAsset } from '../../state/assets'
import { useImageLoaded } from '../../components/useImage'
import { ChoicePrompt, ExtraChoices, splitOptions, useAppChoice } from '../../components/appChoice'
import { useAppHeader } from '../../phone/appHeader'
import './tube.css'

type Tab = 'home' | 'library'

/** 섬네일: tube_cg_{id}_01 이미지가 없으면 제목으로 만든 섬네일 */
export function TubeThumb({ id }: { id: VideoId }) {
  const video = VIDEOS[id]
  const src = storyAsset(`tube_cg_${id}_01`)
  const loaded = useImageLoaded(src)
  return (
    <span className="tube-thumb" style={{ background: video.tint }}>
      {loaded ? (
        <img src={src} alt="" draggable={false} />
      ) : (
        <span className="tube-thumb__text">{video.title.split(' — ')[0]}</span>
      )}
      <span className="tube-thumb__length">{video.length}</span>
    </span>
  )
}

function VideoCard({ id, onPick, done }: { id: VideoId; onPick: () => void; done?: boolean }) {
  const video = VIDEOS[id]
  return (
    <button type="button" className="tube-card" onClick={onPick}>
      <TubeThumb id={id} />
      <span className="tube-card__meta">
        <span className="tube-card__avatar" aria-hidden>
          {video.channel.slice(0, 1)}
        </span>
        <span className="tube-card__text">
          <span className="tube-card__title">{video.title}</span>
          <span className="tube-card__sub">
            {video.channel} · {video.views} · {video.ago}
          </span>
          {done && (
            <span className="tube-card__done">
              <CircleCheck size={14} aria-hidden /> 본 영상
            </span>
          )}
        </span>
      </span>
    </button>
  )
}

/** 튜브: 밤마다 고른 수리 영상을 보고(# watch:), 본 영상의 핵심 정리가 보관함에 남는다 */
export default function TubeApp() {
  const choice = useAppChoice('tube')
  const watched = useGame((s) => s.journal.videos)
  const [tab, setTab] = useState<Tab>('home')
  const [open, setOpen] = useState<VideoId | null>(null)
  const { main, extra } = splitOptions(choice)
  const picks = main.filter((o): o is ChoiceOption & { ref: VideoId } => !!o.ref && isVideoId(o.ref))
  const seen = new Set(watched.map((v) => v.id))

  if (open) return <VideoDetail id={open} onBack={() => setOpen(null)} />

  const recent = [...watched].reverse().filter((v) => isVideoId(v.id))

  return (
    <div className="tube">
      <div className="tube__tabs" role="tablist">
        <button type="button" role="tab" aria-selected={tab === 'home'} className="tube__tab" onClick={() => setTab('home')}>
          <Play size={16} aria-hidden /> 추천
        </button>
        <button type="button" role="tab" aria-selected={tab === 'library'} className="tube__tab" onClick={() => setTab('library')}>
          <Library size={16} aria-hidden /> 보관함 {watched.length > 0 && <span className="tube__count">{watched.length}</span>}
        </button>
      </div>

      {tab === 'home' ? (
        <>
          {choice ? (
            <section className="tube__section tube__section--pick">
              <ChoicePrompt choice={choice} app="tube" />
              {picks.map((o) => (
                <VideoCard key={o.index} id={o.ref} done={seen.has(o.ref)} onPick={() => director.choose(o.index)} />
              ))}
              <ExtraChoices options={extra} />
            </section>
          ) : (
            <p className="tube__empty">
              추천 영상은 할 일이 생기면 올라옵니다.
              <br />
              밤에 <b>수리 공부하기</b>를 고르면 여기서 영상을 고릅니다.
            </p>
          )}
          {recent.length > 0 && (
            <section className="tube__section">
              <h2 className="tube__heading">다시 보기</h2>
              {recent.slice(0, 3).map((v) => (
                <VideoCard key={v.id} id={v.id as VideoId} done onPick={() => setOpen(v.id as VideoId)} />
              ))}
            </section>
          )}
        </>
      ) : recent.length === 0 ? (
        <p className="tube__empty">아직 본 영상이 없습니다.</p>
      ) : (
        <ul className="tube__library">
          {recent.map((v) => {
            const video = VIDEOS[v.id as VideoId]
            return (
              <li key={v.id}>
                <button type="button" className="tube-row" onClick={() => setOpen(v.id as VideoId)}>
                  <TubeThumb id={v.id as VideoId} />
                  <span className="tube-row__text">
                    <span className="tube-row__title">{video.title}</span>
                    <span className="tube-row__sub">
                      {video.channel} · {formatDay(v.day).replace(/ \S+요일$/, '')} {v.time}에 봄
                    </span>
                  </span>
                </button>
              </li>
            )
          })}
        </ul>
      )}
    </div>
  )
}

/** 본 영상의 핵심 정리 */
function VideoDetail({ id, onBack }: { id: VideoId; onBack: () => void }) {
  const video = VIDEOS[id]
  const when = useGame((s) => s.journal.videos.find((v) => v.id === id))
  useAppHeader({ title: '보관함', onBack })
  return (
    <article className="tube-detail">
      <TubeThumb id={id} />
      <h2 className="tube-detail__title">{video.title}</h2>
      <p className="tube-detail__sub">
        {video.channel} · {video.views}
        {when ? ` · ${formatDay(when.day)} ${when.time}에 봄` : ''}
      </p>
      <h3 className="tube-detail__heading">핵심 정리</h3>
      <ol className="tube-detail__points">
        {video.points.map((p) => (
          <li key={p}>{p}</li>
        ))}
      </ol>
    </article>
  )
}
