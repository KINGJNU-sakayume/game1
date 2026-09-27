import { useMemo, useState } from 'react'
import { MessageCircle, Phone, PhoneIncoming, PhoneMissed, PhoneOutgoing, Video, Voicemail as VoicemailIcon } from 'lucide-react'
import Avatar from '../../components/Avatar'
import { director } from '../../engine/director'
import { callerName, updateJournal, useGame } from '../../engine/store'
import type { CallRecord, ChoiceOption, Voicemail } from '../../engine/store'
import { PEOPLE, isPersonId } from '../../story/cast'
import type { PersonId } from '../../story/cast'
import { useSignal } from '../../story/useSignal'
import { formatDay } from '../../state/gameClock'
import { ChoicePrompt, ExtraChoices, splitOptions, useAppChoice } from '../../components/appChoice'
import { useAppHeader } from '../../phone/appHeader'
import './call.css'

type Tab = 'recent' | 'contacts' | 'voicemail'

/** useGame이 매번 새 배열을 돌려주지 않게 */
const NO_MEMO: string[] = []

const KIND_LABEL: Record<CallRecord['kind'], string> = {
  incoming: '받은 통화',
  outgoing: '건 통화',
  declined: '거절한 통화',
  missed: '부재중 전화',
  noanswer: '건 통화 · 받지 않음',
}

function duration(seconds: number) {
  if (seconds < 60) return `${seconds}초`
  return `${Math.floor(seconds / 60)}분 ${seconds % 60}초`
}

function shortDay(day: number) {
  return formatDay(day).replace(/ \S+요일$/, '')
}

/** 연락처에 오를 사람: 메시지·전화·음성 메시지가 오간 사람 (번호가 있는 사람만) */
function useContacts(extra: PersonId[]): PersonId[] {
  const messages = useGame((s) => s.messages)
  const calls = useGame((s) => s.calls)
  const voicemails = useGame((s) => s.journal.voicemails)
  const memos = useGame((s) => s.journal.memos)
  return useMemo(() => {
    const order: PersonId[] = []
    const add = (id: string) => {
      if (isPersonId(id) && PEOPLE[id].number && !order.includes(id)) order.push(id)
    }
    for (const m of messages) add(m.from)
    for (const c of calls) if (!c.unknown) add(c.who)
    for (const v of voicemails) if (!v.unknown) add(v.who)
    for (const id of Object.keys(memos)) add(id)
    for (const id of extra) add(id)
    return order
  }, [messages, calls, voicemails, memos, extra])
}

const ACTIONS: { action: ChoiceOption['action']; label: string; Icon: typeof Phone }[] = [
  { action: 'text', label: '메시지', Icon: MessageCircle },
  { action: 'dial', label: '전화', Icon: Phone },
  { action: 'video', label: '영상통화', Icon: Video },
]

/** 전화: 최근 기록 · 연락처 · 음성사서함. "누구에게 어떻게 연락할까"(# text: · # dial: · # facetime:)를 여기서 고른다 */
export default function CallApp() {
  const choice = useAppChoice('call')
  const calls = useGame((s) => s.calls)
  const voicemails = useGame((s) => s.journal.voicemails)
  const [tab, setTab] = useState<Tab>(() => (choice ? 'contacts' : 'recent'))
  const [open, setOpen] = useState<PersonId | null>(null)
  const { main, extra } = splitOptions(choice)
  const picked = useMemo(() => main.map((o) => o.ref).filter((r): r is PersonId => !!r && isPersonId(r)), [main])
  const contacts = useContacts(picked)
  const unheard = voicemails.filter((v) => !v.heard).length
  const shownTab = choice ? 'contacts' : tab

  if (open) return <ContactDetail id={open} picks={main.filter((o) => o.ref === open)} onBack={() => setOpen(null)} />

  return (
    <div className="phone-app">
      <div className="segmented phone-app__tabs" role="tablist">
        {(
          [
            ['recent', '최근 기록'],
            ['contacts', '연락처'],
            ['voicemail', unheard ? `음성사서함 ${unheard}` : '음성사서함'],
          ] as const
        ).map(([id, label]) => (
          <button
            key={id}
            type="button"
            role="tab"
            aria-selected={shownTab === id}
            aria-checked={shownTab === id}
            className="segmented__item"
            onClick={() => setTab(id)}
            disabled={!!choice && id !== 'contacts'}
          >
            {label}
          </button>
        ))}
      </div>

      {shownTab === 'recent' && <RecentList calls={calls} />}

      {shownTab === 'contacts' && (
        <>
          {choice && (
            <div className="phone-app__prompt">
              <ChoicePrompt choice={choice} app="call" />
            </div>
          )}
          {contacts.length === 0 ? (
            <p className="coming-soon phone-app__empty">연락처가 없습니다</p>
          ) : (
            <ul className="contact-list">
              {contacts.map((id) => (
                <ContactRow key={id} id={id} picks={main.filter((o) => o.ref === id)} onOpen={() => setOpen(id)} />
              ))}
            </ul>
          )}
          {choice && <ExtraChoices options={extra} />}
        </>
      )}

      {shownTab === 'voicemail' && <VoicemailList voicemails={voicemails} />}
    </div>
  )
}

function RecentList({ calls }: { calls: CallRecord[] }) {
  if (calls.length === 0) return <p className="coming-soon phone-app__empty">최근 통화가 없습니다</p>
  return (
    <ul className="call-log">
      {[...calls].reverse().map((c) => {
        const missed = c.kind === 'declined' || c.kind === 'missed'
        const Icon = missed ? PhoneMissed : c.kind === 'outgoing' || c.kind === 'noanswer' ? PhoneOutgoing : PhoneIncoming
        return (
          <li key={c.id} className={`call-log__row${missed ? ' is-missed' : ''}`}>
            <Avatar id={c.unknown ? 'system' : c.who} size={44} />
            <span className="call-log__main">
              <span className="call-log__name">{callerName(c.who, c.unknown)}</span>
              <span className="call-log__kind">
                {c.video ? <Video size={14} aria-hidden /> : <Icon size={14} aria-hidden />}
                {c.video ? '영상통화 · ' : ''}
                {KIND_LABEL[c.kind]}
                {c.seconds > 0 ? ` · ${duration(c.seconds)}` : ''}
              </span>
            </span>
            <span className="call-log__when">
              <span>{c.time}</span>
              <span>{shortDay(c.day)}</span>
            </span>
          </li>
        )
      })}
    </ul>
  )
}

function PickButtons({ picks }: { picks: ChoiceOption[] }) {
  if (picks.length === 0) return null
  return (
    <span className="contact-picks">
      {ACTIONS.map(({ action, label, Icon }) => {
        const o = picks.find((p) => p.action === action)
        if (!o) return null
        return (
          <button
            key={action}
            type="button"
            className="contact-pick"
            onClick={(e) => {
              e.stopPropagation()
              director.choose(o.index)
            }}
            aria-label={o.label}
          >
            <Icon size={18} aria-hidden />
            <span>{label}</span>
          </button>
        )
      })}
    </span>
  )
}

function ContactRow({ id, picks, onOpen }: { id: PersonId; picks: ChoiceOption[]; onOpen: () => void }) {
  const { status } = useSignal(id)
  return (
    <li className={`contact-row${picks.length ? ' is-pick' : ''}`}>
      <button type="button" className="contact-row__main" onClick={onOpen}>
        <Avatar id={id} size={46} />
        <span className="contact-row__text">
          <span className="contact-row__name">{PEOPLE[id].name}</span>
          <span className="contact-row__sub">{status || PEOPLE[id].role}</span>
        </span>
      </button>
      <PickButtons picks={picks} />
    </li>
  )
}

function ContactDetail({ id, picks, onBack }: { id: PersonId; picks: ChoiceOption[]; onBack: () => void }) {
  const person = PEOPLE[id]
  const { status } = useSignal(id)
  const memo = useGame((s) => s.journal.memos[id] ?? NO_MEMO)
  useAppHeader({ title: '연락처', onBack })
  return (
    <article className="contact-detail">
      <Avatar id={id} size={108} />
      <h2 className="contact-detail__name">{person.name}</h2>
      {status && <p className="contact-detail__status">{status}</p>}
      <PickButtons picks={picks} />
      <dl className="contact-detail__card">
        <dt>휴대전화</dt>
        <dd>{person.number}</dd>
        <dt>처음 알게 된 모습</dt>
        <dd>{person.role}</dd>
      </dl>
      <section className="contact-detail__memo">
        <h3>메모</h3>
        {memo.length === 0 ? <p className="contact-detail__none">아직 아는 게 별로 없다.</p> : memo.map((line, i) => <p key={i}>{line}</p>)}
      </section>
    </article>
  )
}

function VoicemailList({ voicemails }: { voicemails: Voicemail[] }) {
  const [open, setOpen] = useState<number | null>(null)
  if (voicemails.length === 0) return <p className="coming-soon phone-app__empty">음성 메시지가 없습니다</p>

  function listen(v: Voicemail) {
    setOpen(open === v.id ? null : v.id)
    if (!v.heard) {
      updateJournal((j) => ({ voicemails: j.voicemails.map((x) => (x.id === v.id ? { ...x, heard: true } : x)) }))
      director.persist()
    }
  }

  return (
    <ul className="voicemail-list">
      {[...voicemails].reverse().map((v) => (
        <li key={v.id} className={`voicemail${v.heard ? '' : ' is-new'}`}>
          <button type="button" className="voicemail__head" onClick={() => listen(v)} aria-expanded={open === v.id}>
            <span className="voicemail__dot" aria-hidden />
            <span className="voicemail__main">
              <span className="voicemail__name">{callerName(v.who, v.unknown)}</span>
              <span className="voicemail__preview">{v.lines[0]}</span>
            </span>
            <span className="voicemail__when">
              <span>{v.time}</span>
              <span>{shortDay(v.day)}</span>
            </span>
          </button>
          {open === v.id && (
            <div className="voicemail__body">
              <p className="voicemail__wave" aria-hidden>
                <VoicemailIcon size={16} />
                {Array.from({ length: 28 }, (_, i) => (
                  <span key={i} style={{ height: `${6 + ((i * 37 + v.id * 11) % 18)}px` }} />
                ))}
              </p>
              <p className="voicemail__label">음성 메시지 받아쓰기</p>
              {v.lines.map((line, i) => (
                <p key={i} className="voicemail__line">
                  {line}
                </p>
              ))}
            </div>
          )}
        </li>
      ))}
    </ul>
  )
}
