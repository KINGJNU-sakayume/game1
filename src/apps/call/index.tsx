import { PhoneIncoming, PhoneMissed, PhoneOutgoing, Video } from 'lucide-react'
import Avatar from '../../components/Avatar'
import { useGame } from '../../engine/store'
import type { CallRecord } from '../../engine/store'
import { PEOPLE } from '../../story/cast'
import { formatDay } from '../../state/gameClock'
import './call.css'

const KIND_LABEL: Record<CallRecord['kind'], string> = {
  incoming: '받은 통화',
  outgoing: '건 통화',
  declined: '거절한 통화',
}

function duration(seconds: number) {
  if (seconds < 60) return `${seconds}초`
  return `${Math.floor(seconds / 60)}분 ${seconds % 60}초`
}

/** 최근 통화 목록 */
export default function CallApp() {
  const calls = useGame((s) => s.calls)

  if (calls.length === 0) return <div className="coming-soon">최근 통화가 없습니다</div>

  return (
    <ul className="call-log">
      {[...calls].reverse().map((c) => {
        const Icon = c.kind === 'declined' ? PhoneMissed : c.kind === 'outgoing' ? PhoneOutgoing : PhoneIncoming
        return (
          <li key={c.id} className={`call-log__row${c.kind === 'declined' ? ' is-missed' : ''}`}>
            <Avatar id={c.who} size={44} />
            <span className="call-log__main">
              <span className="call-log__name">{PEOPLE[c.who].name}</span>
              <span className="call-log__kind">
                {c.video ? <Video size={14} aria-hidden /> : <Icon size={14} aria-hidden />}
                {c.video ? '영상통화 · ' : ''}
                {KIND_LABEL[c.kind]}
                {c.seconds > 0 ? ` · ${duration(c.seconds)}` : ''}
              </span>
            </span>
            <span className="call-log__when">
              <span>{c.time}</span>
              <span>{formatDay(c.day).replace(/ \S+요일$/, '')}</span>
            </span>
          </li>
        )
      })}
    </ul>
  )
}
