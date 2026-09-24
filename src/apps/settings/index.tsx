import { useState } from 'react'
import type { FormEvent } from 'react'
import type { AppProps } from '../registry'
import { loadSettings, saveSettings } from '../../state/storage'
import { listDays } from '../../engine/save'
import { formatDay } from '../../state/gameClock'
import type { TextSpeed } from '../../state/storage'

const SPEEDS: { value: TextSpeed; label: string }[] = [
  { value: 'slow', label: '느림' },
  { value: 'normal', label: '보통' },
  { value: 'fast', label: '빠름' },
]

type Confirm = { kind: 'reset' } | { kind: 'rewind'; day: number }

export default function SettingsApp({ profile, onRename, onReset, onRewind }: AppProps) {
  const [settings, setSettings] = useState(loadSettings)
  const [name, setName] = useState(profile.name)
  const [renamed, setRenamed] = useState(false)
  const [confirming, setConfirming] = useState<Confirm | null>(null)
  const [days] = useState(listDays)
  const trimmed = name.trim()

  function changeSpeed(textSpeed: TextSpeed) {
    const next = { ...settings, textSpeed }
    setSettings(next)
    saveSettings(next)
  }

  function rename(e: FormEvent) {
    e.preventDefault()
    if (!trimmed || trimmed === profile.name) return
    onRename(trimmed)
    setName(trimmed)
    setRenamed(true)
  }

  return (
    <div className="settings">
      <section className="settings__section">
        <h2 className="settings__label" id="speed-label">
          텍스트 속도
        </h2>
        <div className="segmented" role="radiogroup" aria-labelledby="speed-label">
          {SPEEDS.map(({ value, label }) => (
            <button
              key={value}
              type="button"
              role="radio"
              aria-checked={settings.textSpeed === value}
              className="segmented__item"
              onClick={() => changeSpeed(value)}
            >
              {label}
            </button>
          ))}
        </div>
      </section>

      <section className="settings__section">
        <h2 className="settings__label">이름</h2>
        <form className="settings__card settings__row" onSubmit={rename}>
          <input
            className="text-input"
            value={name}
            onChange={(e) => {
              setName(e.target.value)
              setRenamed(false)
            }}
            maxLength={10}
            autoComplete="off"
            enterKeyHint="done"
            aria-label="이름"
          />
          <button type="submit" className="btn-secondary" disabled={!trimmed || trimmed === profile.name}>
            저장
          </button>
        </form>
        <p className="settings__note" aria-live="polite">
          {renamed ? '이름을 바꿨습니다.' : ''}
        </p>
      </section>

      <section className="settings__section">
        <h2 className="settings__label">날짜 선택</h2>
        {days.length === 0 ? (
          <p className="settings__note">아직 지난 날짜가 없습니다.</p>
        ) : (
          <div className="settings__list">
            {days.map((d) => (
              <button
                key={d.day}
                type="button"
                className="settings__list-item"
                onClick={() => setConfirming({ kind: 'rewind', day: d.day })}
              >
                <span>{formatDay(d.day)}</span>
                <span className="settings__list-meta">D{d.day}</span>
              </button>
            ))}
          </div>
        )}
        <p className="settings__note">고른 날짜의 시작부터 다시 합니다. 게임은 자동 저장됩니다.</p>
      </section>

      <section className="settings__section">
        <h2 className="settings__label">데이터</h2>
        <button type="button" className="btn-danger" onClick={() => setConfirming({ kind: 'reset' })}>
          데이터 초기화
        </button>
      </section>

      {confirming && (
        <div className="modal-scrim" onClick={() => setConfirming(null)}>
          <div
            className="modal"
            role="alertdialog"
            aria-modal="true"
            aria-labelledby="reset-title"
            aria-describedby="reset-text"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="modal__body">
              <h3 className="modal__title" id="reset-title">
                {confirming.kind === 'reset' ? '데이터를 초기화할까요?' : `${formatDay(confirming.day)}부터 다시 할까요?`}
              </h3>
              <p className="modal__text" id="reset-text">
                {confirming.kind === 'reset'
                  ? '이름과 설정, 진행 상황이 모두 지워지고 처음부터 시작합니다.'
                  : '그날 이후의 진행은 사라집니다.'}
              </p>
            </div>
            <div className="modal__actions">
              <button type="button" onClick={() => setConfirming(null)}>
                취소
              </button>
              {confirming.kind === 'reset' ? (
                <button type="button" className="modal__confirm" onClick={onReset}>
                  초기화
                </button>
              ) : (
                <button type="button" className="modal__confirm" onClick={() => onRewind(confirming.day)}>
                  다시 하기
                </button>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
