import { useMemo } from 'react'
import Avatar from '../../components/Avatar'
import { previewText, useGame } from '../../engine/store'
import type { ChatMessage } from '../../engine/store'
import { ROOMS } from '../../story/cast'
import type { RoomId } from '../../story/cast'

interface Props {
  onOpen: (room: RoomId) => void
}

export default function ChatList({ onOpen }: Props) {
  const messages = useGame((s) => s.messages)
  const unread = useGame((s) => s.unread)
  const choice = useGame((s) => s.choice)

  const rows = useMemo(() => {
    const last = new Map<RoomId, ChatMessage>()
    for (const m of messages) last.set(m.room, m)
    return [...last.values()].sort((a, b) => b.id - a.id)
  }, [messages])

  if (rows.length === 0) {
    return <div className="coming-soon">아직 대화가 없습니다</div>
  }

  return (
    <ul className="chat-list">
      {rows.map((last) => {
        const room = ROOMS[last.room]
        const count = unread[last.room] ?? 0
        const waiting =
          choice &&
          (choice.kind === 'reply' ? choice.room === last.room : choice.options.some((o) => o.openRoom === last.room))
        return (
          <li key={last.room}>
            <button type="button" className="chat-row" onClick={() => onOpen(last.room)}>
              {room.group ? <GroupAvatar room={last.room} /> : <Avatar id={room.members[0]} size={50} />}
              <span className="chat-row__main">
                <span className="chat-row__name">
                  {room.name}
                  {room.group && <span className="chat-row__count">{room.members.length + 1}</span>}
                </span>
                <span className="chat-row__preview">{previewText(last)}</span>
              </span>
              <span className="chat-row__meta">
                <span className="chat-row__time">{last.time}</span>
                {count > 0 ? (
                  <span className="badge badge--inline">{count}</span>
                ) : waiting ? (
                  <span className="chat-row__waiting" aria-label="답장 대기" />
                ) : null}
              </span>
            </button>
          </li>
        )
      })}
    </ul>
  )
}

function GroupAvatar({ room }: { room: RoomId }) {
  const members = ROOMS[room].members.slice(0, 4)
  return (
    <span className="group-avatar" aria-hidden>
      {members.map((id) => (
        <Avatar key={id} id={id} size={24} />
      ))}
    </span>
  )
}
