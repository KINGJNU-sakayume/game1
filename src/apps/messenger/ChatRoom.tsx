import { Fragment, useEffect, useLayoutEffect, useMemo, useRef, useState } from 'react'
import { Send, X } from 'lucide-react'
import Avatar from '../../components/Avatar'
import StoryImage from '../../components/StoryImage'
import { director } from '../../engine/director'
import { setViewingRoom, useGame } from '../../engine/store'
import type { ChatMessage } from '../../engine/store'
import { PEOPLE, ROOMS } from '../../story/cast'
import type { RoomId, SenderId } from '../../story/cast'
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
  const logRef = useRef<HTMLDivElement>(null)

  const messages = useMemo(() => allMessages.filter((m) => m.room === room), [allMessages, room])
  const replies = choice?.kind === 'reply' && choice.room === room && composing === null ? choice.options : null

  useAppHeader({ title: info.name, subtitle: info.group ? `${info.members.length + 1}명` : undefined, onBack })

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
              <MessageRow message={m} group={info.group} runStart={runStart} runEnd={runEnd} onPhoto={setViewing} />
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

      {viewing?.photo && (
        <div className="photo-viewer" role="dialog" aria-label="사진 보기" onClick={() => setViewing(null)}>
          <button type="button" className="photo-viewer__close" aria-label="닫기">
            <X size={26} />
          </button>
          <StoryImage folder="cg" name={viewing.photo} alt={viewing.text} className="photo-viewer__image" />
        </div>
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
}

function MessageRow({ message: m, group, runStart, runEnd, onPhoto }: RowProps) {
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
  const time = runEnd ? <span className="msg__time">{m.time}</span> : null

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
      {runStart ? <Avatar id={m.from} size={36} /> : <span className="msg__avatar-space" />}
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
