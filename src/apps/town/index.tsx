import { useState } from 'react'
import { ChevronRight, MapPin, MessageSquare } from 'lucide-react'
import { director } from '../../engine/director'
import { useGame } from '../../engine/store'
import type { ChoiceOption, TownPost } from '../../engine/store'
import { formatDay } from '../../state/gameClock'
import { ChoicePrompt, ExtraChoices, splitOptions, useAppChoice } from '../../components/appChoice'
import { useAppHeader } from '../../phone/appHeader'
import './town.css'

function when(post: TownPost, today: number) {
  return post.day === today ? post.time : formatDay(post.day).replace(/ \S+요일$/, '')
}

/** 망원살이: 동네 소식·나눔·부탁. 나눔을 받거나 부탁에 답하는 선택(# town:)이 여기서 나온다 */
export default function TownApp() {
  const posts = useGame((s) => s.journal.town)
  const today = useGame((s) => s.clock.day)
  const choice = useAppChoice('town')
  const [open, setOpen] = useState<string | null>(null)
  const { main, extra } = splitOptions(choice)
  const targetId = main.find((o) => o.ref)?.ref ?? null
  const target = posts.find((p) => p.id === targetId) ?? null

  const openPost = open ? posts.find((p) => p.id === open) : null
  if (openPost) {
    return (
      <TownDetail
        post={openPost}
        picks={openPost.id === targetId ? main : null}
        extra={openPost.id === targetId ? extra : []}
        onBack={() => setOpen(null)}
      />
    )
  }

  const list = [...posts].reverse().filter((p) => p.id !== targetId)

  return (
    <div className="town">
      <p className="town__place">
        <MapPin size={15} aria-hidden /> 망원동 · 이웃 {128 + posts.length * 3}명이 보고 있어요
      </p>

      {choice && (
        <section className="town__waiting">
          <ChoicePrompt choice={choice} app="town" />
          {target ? (
            <PostRow post={target} today={today} onOpen={() => setOpen(target.id)} highlight />
          ) : (
            <div className="town__picks">
              {main.map((o) => (
                <button key={o.index} type="button" className="town-pick" onClick={() => director.choose(o.index)}>
                  {o.say ?? o.label}
                </button>
              ))}
            </div>
          )}
          {target && <ExtraChoices options={extra} />}
        </section>
      )}

      {list.length === 0 && !target ? (
        <p className="town__empty">아직 올라온 글이 없습니다</p>
      ) : (
        <ul className="town__list">
          {list.map((p) => (
            <li key={p.id}>
              <PostRow post={p} today={today} onOpen={() => setOpen(p.id)} />
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}

function PostRow({ post, today, onOpen, highlight }: { post: TownPost; today: number; onOpen: () => void; highlight?: boolean }) {
  return (
    <button type="button" className={`town-row${highlight ? ' is-target' : ''}`} onClick={onOpen}>
      <span className="town-row__main">
        <span className="town-chip">{post.category}</span>
        <span className="town-row__title">{post.title}</span>
        <span className="town-row__sub">
          {post.author} · {when(post, today)}
          {post.comments.length > 0 && (
            <span className="town-row__comments">
              <MessageSquare size={13} aria-hidden /> {post.comments.length}
            </span>
          )}
        </span>
      </span>
      <ChevronRight size={18} className="town-row__chevron" aria-hidden />
    </button>
  )
}

interface DetailProps {
  post: TownPost
  picks: ChoiceOption[] | null
  extra: ChoiceOption[]
  onBack: () => void
}

function TownDetail({ post, picks, extra, onBack }: DetailProps) {
  useAppHeader({ title: '망원살이', onBack })
  return (
    <article className="town-detail">
      <span className="town-chip">{post.category}</span>
      <h2 className="town-detail__title">{post.title}</h2>
      <p className="town-detail__meta">
        {post.author} · {formatDay(post.day)} {post.time}
      </p>
      {post.body.map((line, i) => (
        <p key={i} className="town-detail__body">
          {line}
        </p>
      ))}

      <h3 className="town-detail__heading">댓글 {post.comments.length}</h3>
      {post.comments.length === 0 ? (
        <p className="town-detail__none">첫 댓글을 기다리는 중</p>
      ) : (
        <ul className="town-detail__comments">
          {post.comments.map((c, i) => (
            <li key={i} className={c.mine ? 'is-mine' : ''}>
              <span className="town-detail__author">{c.author}</span>
              <span>{c.text}</span>
            </li>
          ))}
        </ul>
      )}

      {picks && (
        <div className="town__picks">
          {picks.map((o) => (
            <button key={o.index} type="button" className="town-pick" onClick={() => director.choose(o.index)}>
              <span className="town-pick__label">댓글</span>
              {o.say ?? o.label}
            </button>
          ))}
          <ExtraChoices options={extra} />
        </div>
      )}
    </article>
  )
}
