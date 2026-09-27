import { useEffect, useRef, useState } from 'react'
import { Heart, MessageCircle } from 'lucide-react'
import Avatar from '../../components/Avatar'
import StoryImage from '../../components/StoryImage'
import { director } from '../../engine/director'
import { useGame } from '../../engine/store'
import type { ChoiceOption, SnapPost } from '../../engine/store'
import { PEOPLE } from '../../story/cast'
import type { PersonId } from '../../story/cast'
import { snapAccount } from '../../story/social'
import { formatDay } from '../../state/gameClock'
import { loadProfile } from '../../state/storage'
import { ChoicePrompt, ExtraChoices, splitOptions, useAppChoice } from '../../components/appChoice'
import './snap.css'

/** 게시물마다 정해진 좋아요 수 (같은 글이면 늘 같은 수) */
function baseLikes(id: string) {
  let hash = 7
  for (const ch of id) hash = (hash * 31 + ch.charCodeAt(0)) % 997
  return 9 + (hash % 140)
}

function commenterName(from: SnapPost['comments'][number]['from']) {
  if (from === 'me') return loadProfile()?.name ?? '나'
  if (from === 'system') return ''
  return snapAccount(from, PEOPLE[from].name).handle
}

interface PostProps {
  post: SnapPost
  picks: ChoiceOption[] | null
  extra: ChoiceOption[]
}

function Post({ post, picks, extra }: PostProps) {
  const account = snapAccount(post.from, PEOPLE[post.from].name)
  const likes = baseLikes(post.id) + (post.liked ? 1 : 0)
  const ref = useRef<HTMLElement>(null)
  const target = picks !== null

  // 반응을 기다리는 게시물로 스크롤
  useEffect(() => {
    if (target) ref.current?.scrollIntoView({ block: 'start', behavior: 'smooth' })
  }, [target])

  return (
    <article ref={ref} className={`snap-post${target ? ' is-target' : ''}`}>
      <header className="snap-post__head">
        <span className="snap-ring">
          <Avatar id={post.from} size={34} />
        </span>
        <span className="snap-post__who">
          <span className="snap-post__name">{account.handle}</span>
          <span className="snap-post__sub">{account.name}</span>
        </span>
      </header>
      {post.photo && (
        <div className="snap-post__photo">
          <StoryImage name={post.photo} alt={post.text} />
        </div>
      )}
      <div className="snap-post__actions" aria-hidden>
        <Heart size={24} className={post.liked ? 'is-liked' : ''} fill={post.liked ? 'currentColor' : 'none'} />
        <MessageCircle size={23} />
      </div>
      <p className="snap-post__likes">좋아요 {likes}개</p>
      <p className="snap-post__caption">
        <b>{account.handle}</b> {post.text}
      </p>
      {post.comments.length > 0 && (
        <ul className="snap-post__comments">
          {post.comments.map((c, i) => (
            <li key={i} className={c.from === 'me' ? 'is-mine' : ''}>
              <b>{commenterName(c.from)}</b> {c.text}
            </li>
          ))}
        </ul>
      )}
      <p className="snap-post__date">{formatDay(post.day).replace(/ \S+요일$/, '')}</p>

      {picks && (
        <div className="snap-post__picks">
          {picks.map((o) => (
            <button
              key={o.index}
              type="button"
              className={`snap-pick${o.action === 'like' ? ' snap-pick--like' : ''}`}
              onClick={() => director.choose(o.index)}
            >
              {o.action === 'like' && <Heart size={18} aria-hidden />}
              {o.action === 'comment' ? <span className="snap-pick__label">댓글</span> : null}
              {o.action === 'comment' ? (o.say ?? o.label) : o.label}
            </button>
          ))}
          <ExtraChoices options={extra} />
        </div>
      )}
    </article>
  )
}

/** 스냅: 세 사람과 동네의 "보이는 얼굴". 게시물에 좋아요·댓글을 다는 선택(# like: · # comment:)이 여기서 나온다 */
export default function SnapApp() {
  const posts = useGame((s) => s.journal.posts)
  const choice = useAppChoice('snap')
  const [filter, setFilter] = useState<PersonId | 'all'>('all')
  const { main, extra } = splitOptions(choice)
  const targetId = main.find((o) => o.ref)?.ref ?? null
  const visible = posts.filter((p) => !p.deleted)
  const accounts = [...new Set(visible.map((p) => p.from))]
  const feed = [...visible].reverse().filter((p) => filter === 'all' || p.from === filter || p.id === targetId)
  const orphan = choice && !visible.some((p) => p.id === targetId)

  return (
    <div className="snap">
      {accounts.length > 0 && (
        <div className="snap__stories" role="tablist" aria-label="계정">
          <button type="button" role="tab" aria-selected={filter === 'all'} className="snap-story" onClick={() => setFilter('all')}>
            <span className="snap-story__all">전체</span>
            <span className="snap-story__name">모두 보기</span>
          </button>
          {accounts.map((id) => (
            <button
              key={id}
              type="button"
              role="tab"
              aria-selected={filter === id}
              className="snap-story"
              onClick={() => setFilter(filter === id ? 'all' : id)}
            >
              <span className="snap-ring snap-ring--big">
                <Avatar id={id} size={54} />
              </span>
              <span className="snap-story__name">{snapAccount(id, PEOPLE[id].name).name}</span>
            </button>
          ))}
        </div>
      )}

      {choice && (
        <div className="snap__prompt">
          <ChoicePrompt choice={choice} app="snap" />
          {orphan && (
            <div className="snap-post__picks">
              {choice.options.map((o) => (
                <button key={o.index} type="button" className="snap-pick" onClick={() => director.choose(o.index)}>
                  {o.say ?? o.label}
                </button>
              ))}
            </div>
          )}
        </div>
      )}

      {feed.length === 0 ? (
        <p className="snap__empty">아직 게시물이 없습니다</p>
      ) : (
        feed.map((p) => (
          <Post key={p.id} post={p} picks={p.id === targetId ? main : null} extra={p.id === targetId ? extra : []} />
        ))
      )}
    </div>
  )
}
