import { useEffect, useState } from 'react'
import { BookOpen, ChevronRight, Circle, CircleCheck } from 'lucide-react'
import { director } from '../../engine/director'
import { markPageRead, useGame } from '../../engine/store'
import type { Note } from '../../engine/store'
import { formatDay } from '../../state/gameClock'
import { useAppHeader } from '../../phone/appHeader'
import './notes.css'

type Tab = 'notes' | 'todos' | 'notebook'

/**
 * 메모: 주인공의 속마음, 보내지 못한 말, 할 일, 김 사장님 수첩(첫 쪽이 생기면 열림).
 * 수첩 쪽은 열어 봐야 "읽은 것"이 된다. 대본은 read("쪽 제목")으로 확인해 수리 장면의 선택지를 바꾼다
 */
export default function NotesApp() {
  const notes = useGame((s) => s.journal.notes)
  const todos = useGame((s) => s.journal.todos)
  const [tab, setTab] = useState<Tab>('notes')
  const [open, setOpen] = useState<Note | null>(null)

  const pages = notes.filter((n) => n.kind === 'page')
  const mine = notes.filter((n) => n.kind !== 'page')
  const tabs: { id: Tab; label: string }[] = [
    { id: 'notes', label: '메모' },
    { id: 'todos', label: '할 일' },
    ...(pages.length > 0 ? [{ id: 'notebook' as const, label: '사장님 수첩' }] : []),
  ]

  if (open) return <NoteDetail note={open} onBack={() => setOpen(null)} />

  return (
    <div className="notes">
      <div className="segmented notes__tabs" role="tablist">
        {tabs.map((t) => (
          <button
            key={t.id}
            type="button"
            role="tab"
            aria-selected={tab === t.id}
            aria-checked={tab === t.id}
            className="segmented__item"
            onClick={() => setTab(t.id)}
          >
            {t.label}
          </button>
        ))}
      </div>

      {tab === 'todos' ? (
        todos.length === 0 ? (
          <p className="notes__empty">할 일이 없습니다</p>
        ) : (
          <ul className="notes__list">
            {todos.map((t) => (
              <li key={t.id} className={`notes__todo${t.done ? ' is-done' : ''}`}>
                {t.done ? <CircleCheck size={22} aria-label="완료" /> : <Circle size={22} aria-label="할 일" />}
                <span>{t.text}</span>
              </li>
            ))}
          </ul>
        )
      ) : (
        <NoteList notes={tab === 'notebook' ? pages : [...mine].reverse()} onOpen={setOpen} notebook={tab === 'notebook'} />
      )}
    </div>
  )
}

function NoteList({ notes, onOpen, notebook }: { notes: Note[]; onOpen: (n: Note) => void; notebook: boolean }) {
  const readPages = useGame((s) => s.journal.readPages)
  if (notes.length === 0) return <p className="notes__empty">메모가 없습니다</p>
  return (
    <ul className="notes__list">
      {notebook && <li className="notes__notebook-hint">김용수 사장님이 30년 동안 쓴 의뢰 수첩. 고치러 가기 전에 펼쳐 보자.</li>}
      {notes.map((n) => (
        <li key={`${n.kind}-${n.title}`}>
          <button type="button" className="notes__row" onClick={() => onOpen(n)}>
            {notebook && <BookOpen size={20} className="notes__icon" aria-hidden />}
            {notebook && !readPages.includes(n.title) && <span className="notes__unread" aria-label="아직 안 읽음" />}
            <span className="notes__row-main">
              <span className="notes__row-title">
                {n.kind === 'unsent' ? `보내지 못한 말 · ${n.title}` : n.title}
              </span>
              <span className="notes__row-preview">{n.body[n.body.length - 1]}</span>
            </span>
            <ChevronRight size={18} className="notes__chevron" aria-hidden />
          </button>
        </li>
      ))}
    </ul>
  )
}

function NoteDetail({ note, onBack }: { note: Note; onBack: () => void }) {
  // 열어 둔 사이에 내용이 늘었을 수 있으니 최신 것을 찾는다
  const latest = useGame((s) => s.journal.notes.find((n) => n.kind === note.kind && n.title === note.title)) ?? note
  useAppHeader({ title: latest.kind === 'page' ? '사장님 수첩' : '메모', onBack })
  // 수첩 쪽을 열면 읽은 것으로 남긴다 (대본의 read())
  useEffect(() => {
    if (note.kind !== 'page') return
    markPageRead(note.title)
    director.persist()
  }, [note.kind, note.title])
  return (
    <article className={`note-detail${latest.kind === 'page' ? ' note-detail--page' : ''}`}>
      <p className="note-detail__date">{formatDay(latest.day)} {latest.time}</p>
      <h2 className="note-detail__title">{latest.kind === 'unsent' ? `보내지 못한 말 · ${latest.title}` : latest.title}</h2>
      {latest.body.map((line, i) => (
        <p key={i} className="note-detail__line">
          {line}
        </p>
      ))}
    </article>
  )
}
