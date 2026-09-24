import { useState } from 'react'
import type { FormEvent } from 'react'
import { DEFAULT_NAME } from '../state/storage'

interface Props {
  onComplete: (name: string) => void
}

/** 새 폰을 처음 켰을 때의 설정 화면 */
export default function SetupScreen({ onComplete }: Props) {
  const [step, setStep] = useState<'hello' | 'name'>('hello')
  const [name, setName] = useState(DEFAULT_NAME)
  const trimmed = name.trim()

  function submit(e: FormEvent) {
    e.preventDefault()
    if (trimmed) onComplete(trimmed)
  }

  if (step === 'hello') {
    return (
      <div className="screen setup">
        <div className="setup__body setup__center">
          <h1 className="setup__hello">안녕하세요</h1>
          <p className="setup__desc">새 휴대폰을 설정합니다</p>
        </div>
        <div className="setup__footer">
          <button type="button" className="btn-primary" onClick={() => setStep('name')}>
            시작하기
          </button>
        </div>
      </div>
    )
  }

  return (
    <form className="screen setup" onSubmit={submit}>
      <div className="setup__body" key="name">
        <h1 className="setup__title">이름을 알려주세요</h1>
        <p className="setup__desc">이 휴대폰에서 사용할 이름입니다.</p>
        <input
          className="text-input"
          value={name}
          onChange={(e) => setName(e.target.value)}
          maxLength={10}
          autoComplete="off"
          enterKeyHint="done"
          aria-label="이름"
        />
      </div>
      <div className="setup__footer">
        <button type="submit" className="btn-primary" disabled={!trimmed}>
          설정 완료
        </button>
      </div>
    </form>
  )
}
