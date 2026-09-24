import { Fragment, useEffect, useLayoutEffect, useMemo, useRef, useState } from 'react'
import { Send } from 'lucide-react'
import Avatar from '../../components/Avatar'
import StoryImage from '../../components/StoryImage'
import PhotoViewer from '../../components/PhotoViewer'
import { director } from '../../engine/director'
import { setViewingRoom, useGame } from '../../engine/store'
import type { ChatMessage } from '../../engine/store'
import { PEOPLE, ROOMS } from '../../story/cast'
import type { PersonId, RoomId, SenderId } from '../../story/cast'
import { useSignal } from '../../story/useSignal'
import ProfileCard from './ProfileCard'
import { formatDay } from '../../state/gameClock'
import { useAppHeader } from '../../phone/appHeader'

interface Props {
  room: RoomId
  onBack: () => void
}

function senderName(id: SenderId) {
  return id === 'me' || id === 'system' ? '' : PEOPLE[id].name
}

export default function ChatRoom({ room, onBack }: Props) {
  const info = ROOMS[room]
  const allMessages = useGame((s) => s.messages)
  const typing = useGame((s) => s.typing[room])
  const choice = useGame((s) => s.choice)
  const composing = useGame((s) => (s.composing?.room === room ? s.composing.text : null))
  const [viewing, setViewing] = useState<ChatMessage | null>(null)
  const [profile, setProfile] = useState<PersonId | null>(null)
  const partner = info.group ? null : info.members[0]
  const { status } = useSignal(partner ?? 'system')
  const logRef = useRef<HTMLDivElement>(null)

  const messages = useMemo(() => allMessages.filter((m) => m.room === room), [allMessages, room])
  const replies = choice?.kind === 'reply' && choice.room === room && composing === null ? choice.options : null

  // 1:1 방은 상대의 상태 메시지를 헤더에 보여준다 (호감 신호)
  useAppHeader({ title: info.name, subtitle: info.group ? `${info.members.length + 1}명` : status || undefined, onBack })

  useEffect(() => {
    setViewingRoom(room)
    return () => setViewingRoom(null)
  }, [room])

  // 새 메시지·입력 중 표시·추천 답장이 생기면 맨 아래로
  useLayoutEffect(() => {
    const log = logRef.current
    if (log) log.scrollTop = log.scrollHeight
  }, [messages.length, typing, replies, composing])

  return (
    <div className="chat-room">
      <div className="chat-log" ref={logRef}>
        {messages.map((m, i) => {
          const prev = messages[i - 1]
          const next = messages[i + 1]
          const newDay = !prev || prev.day !== m.day
          const runStart = newDay || prev.from !== m.from || prev.from === 'system'
          const runEnd = !next || next.from !== m.from || next.time !== m.time || next.day !== m.day
          return (
            <Fragment key={m.id}>
              {newDay && <div className="chat-day">{formatDay(m.day)}</div>}
              <MessageRow
                message={m}
                group={info.group}
                runStart={runStart}
                runEnd={runEnd}
                onPhoto={setViewing}
                onProfile={setProfile}
              />
            </Fragment>
          )
        })}
        {typing && (
          <div className="msg msg--other msg--run-start">
            <Avatar id={typing} size={36} />
            <div className="msg__col">
              {info.group && <span className="msg__name">{senderName(typing)}</span>}
              <div className="bubble bubble--typing" aria-label={`${senderName(typing)} 입력 중`}>
                <span />
                <span />
                <span />
              </div>
            </div>
          </div>
        )}
      </div>

      <div className="composer">
        <div className={`composer__input${composing !== null ? ' is-typing' : ''}`}>
          {composing !== null ? (
            <>
              {composing}
              <span className="composer__caret" />
            </>
          ) : (
            <span className="composer__placeholder">메시지 보내기</span>
          )}
        </div>
        <span className="composer__send" aria-hidden>
          <Send size={20} />
        </span>
      </div>

      {replies && (
        <div className="replies" role="group" aria-label="추천 답장">
          <p className="replies__title">추천 답장</p>
          {replies.map((o) => (
            <button key={o.index} type="button" className="replies__item" onClick={() => director.choose(o.index)}>
              {o.label}
            </button>
          ))}
        </div>
      )}

      {profile && <ProfileCard id={profile} onClose={() => setProfile(null)} />}

      {viewing?.photo && (
        <PhotoViewer
          name={viewing.photo}
          alt={viewing.text}
          from={viewing.from === 'me' ? undefined : viewing.from}
          onClose={() => setViewing(null)}
        />
      )}
    </div>
  )
}

interface RowProps {
  message: ChatMessage
  group: boolean
  runStart: boolean
  runEnd: boolean
  onPhoto: (m: ChatMessage) => void
  onProfile: (id: PersonId) => void
}

function MessageRow({ message: m, group, runStart, runEnd, onPhoto, onProfile }: RowProps) {
  if (m.from === 'system') return <div className="chat-system">{m.text}</div>

  const mine = m.from === 'me'
  const body = m.photo ? (
    <button type="button" className="bubble bubble--photo" onClick={() => onPhoto(m)} aria-label={`사진: ${m.text}`}>
      <StoryImage folder="cg" name={m.photo} alt={m.text} />
    </button>
  ) : m.big ? (
    <div className="bubble bubble--big">{m.text}</div>
  ) : (
    <div className="bubble">{m.text}</div>
  )
  const unread = mine && m.read === false
  const time =
    runEnd || unread ? (
      <span className="msg__meta">
        {unread && <span className="msg__unread">1</span>}
        {runEnd && <span className="msg__time">{m.time}</span>}
      </span>
    ) : null

  if (mine) {
    return (
      <div className={`msg msg--me${runStart ? ' msg--run-start' : ''}`}>
        {time}
        {body}
      </div>
    )
  }
  return (
    <div className={`msg msg--other${runStart ? ' msg--run-start' : ''}`}>
      {runStart ? (
        <button
          type="button"
          className="msg__avatar-button"
          onClick={() => onProfile(m.from as PersonId)}
          aria-label={`${senderName(m.from)} 프로필`}
        >
          <Avatar id={m.from} size={36} />
        </button>
      ) : (
        <span className="msg__avatar-space" />
      )}
      <div className="msg__col">
        {runStart && group && <span className="msg__name">{senderName(m.from)}</span>}
        <div className="msg__line">
          {body}
          {time}
        </div>
      </div>
    </div>
  )
}
