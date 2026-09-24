import { useEffect, useState } from 'react'
import { Mic, Phone, PhoneOff, Video, Volume2 } from 'lucide-react'
import Avatar from '../components/Avatar'
import StoryImage from '../components/StoryImage'
import { director } from '../engine/director'
import { useGame } from '../engine/store'
import type { CallInfo, ChoiceOption, StageLine } from '../engine/store'
import { PEOPLE } from '../story/cast'
import { loadProfile, loadSettings } from '../state/storage'
import './stage.css'

/** 글자 수/초 */
const TYPE_SPEED = { slow: 18, normal: 32, fast: 70 } as const

/** 컷 이미지 (폴더는 파일명 규칙으로 정해진다) */
function StageImage({ name }: { name: string }) {
  return <StoryImage name={name} alt="" className="stage__img" />
}

/** 한 글자씩 나타나는 대사. 탭하면 바로 끝까지 */
function useTypewriter(line: StageLine | null) {
  const [shown, setShown] = useState({ id: -1, count: 0 })
  const total = line ? Array.from(line.text).length : 0
  const count = line && shown.id === line.id ? shown.count : 0

  useEffect(() => {
    if (!line) return
    const perSecond = TYPE_SPEED[loadSettings().textSpeed]
    const reduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches
    if (reduced) {
      setShown({ id: line.id, count: total })
      return
    }
    const started = performance.now()
    let frame = 0
    const tick = (now: number) => {
      const next = Math.min(total, Math.floor(((now - started) / 1000) * perSecond) + 1)
      setShown((s) => (s.id === line.id && s.count >= next ? s : { id: line.id, count: next }))
      if (next < total) frame = requestAnimationFrame(tick)
    }
    frame = requestAnimationFrame(tick)
    return () => cancelAnimationFrame(frame)
  }, [line, total])

  return {
    text: line ? Array.from(line.text).slice(0, count).join('') : '',
    done: !line || count >= total,
    finish: () => line && setShown({ id: line.id, count: total }),
  }
}

function speakerName(speaker: StageLine['speaker']) {
  if (!speaker || speaker === 'system') return null
  if (speaker === 'me') return loadProfile()?.name ?? '나'
  return PEOPLE[speaker].name
}

function Choices({ options }: { options: ChoiceOption[] }) {
  return (
    <div className="stage__choices" role="group" aria-label="선택지">
      {options.map((o) => (
        <button
          key={o.index}
          type="button"
          className="stage__choice"
          onClick={(e) => {
            e.stopPropagation()
            director.choose(o.index)
          }}
        >
          {o.label}
        </button>
      ))}
    </div>
  )
}

function useCallTimer(call: CallInfo | null) {
  const [now, setNow] = useState(() => Date.now())
  useEffect(() => {
    if (call?.state !== 'connected') return
    const timer = window.setInterval(() => setNow(Date.now()), 1000)
    return () => window.clearInterval(timer)
  }, [call?.state])
  if (!call || call.state !== 'connected' || !call.startedAt) return call?.state === 'connecting' ? '연결 중…' : ''
  const seconds = Math.max(0, Math.floor((now - call.startedAt) / 1000))
  return `${String(Math.floor(seconds / 60)).padStart(2, '0')}:${String(seconds % 60).padStart(2, '0')}`
}

/** 폰 화면을 덮는 대면 장면·통화 화면 */
export default function Stage() {
  const stage = useGame((s) => s.stage)
  const choice = useGame((s) => s.choice)
  const line = stage?.line ?? null
  const typer = useTypewriter(line)
  const timer = useCallTimer(stage?.call ?? null)

  if (!stage) return null
  const call = stage.call
  const stageChoices = choice?.kind === 'stage' && typer.done ? choice.options : null
  const callChoices = choice?.kind === 'call' ? choice.options : null
  const name = speakerName(line?.speaker ?? null)

  function onTap() {
    if (!line || stageChoices) return
    if (!typer.done) typer.finish()
    else director.advance()
  }

  const classes = ['stage', `stage--${stage.kind}`, call?.video ? 'stage--video' : '', stage.ending ? 'is-ending' : '']

  // 전화 수신 화면
  if (call?.state === 'ringing') {
    const answer = callChoices?.find((o) => o.answer)
    const decline = callChoices?.find((o) => o.decline)
    return (
      <div className={[...classes, 'stage--ringing'].join(' ')} role="dialog" aria-label="전화 수신">
        <div className="call-head">
          <Avatar id={call.who} size={96} />
          <p className="call-head__name">{PEOPLE[call.who].name}</p>
          <p className="call-head__sub">{call.video ? '영상통화' : '음성통화'}</p>
        </div>
        <div className="call-answer">
          {decline && (
            <button type="button" className="call-btn call-btn--decline" onClick={() => director.choose(decline.index)}>
              <span className="call-btn__icon">
                <PhoneOff size={30} />
              </span>
              {decline.label}
            </button>
          )}
          {answer && (
            <button type="button" className="call-btn call-btn--accept" onClick={() => director.choose(answer.index)}>
              <span className="call-btn__icon">
                {call.video ? <Video size={30} /> : <Phone size={30} />}
              </span>
              {answer.label}
            </button>
          )}
        </div>
      </div>
    )
  }

  return (
    <div className={classes.join(' ')} onClick={onTap} role="dialog" aria-label={stage.kind === 'call' ? '통화 중' : '장면'}>
      {/* 컷 이미지 (대면 장면, 영상통화) */}
      {stage.image && (stage.kind === 'scene' || call?.video) && (
        <div
          key={`${stage.image}-${stage.fx?.key ?? 0}`}
          className={`stage__cut${stage.fx ? ` fx-${stage.fx.type}` : ''}`}
        >
          <StageImage name={stage.image} />
        </div>
      )}
      <div className={`stage__black${stage.black ? ' is-on' : ''}`} />

      {call && (
        <div className="call-top">
          {!call.video && <Avatar id={call.who} size={112} />}
          <p className="call-head__name">{PEOPLE[call.who].name}</p>
          <p className="call-head__sub">{timer}</p>
        </div>
      )}
      {call?.video && <div className="call-pip" aria-hidden />}

      <div className="stage__bottom">
        {stageChoices && <Choices options={stageChoices} />}
        {line && (
          <div className={`dialogue${name ? '' : ' dialogue--narration'}${call ? ' dialogue--subtitle' : ''}`}>
            {name && <p className="dialogue__name">{name}</p>}
            <p className="dialogue__text">
              {typer.text}
              {typer.done && !stageChoices && <span className="dialogue__next" aria-hidden />}
            </p>
          </div>
        )}
        {call && (
          <div className="call-controls" aria-hidden>
            <span className="call-controls__btn">
              <Mic size={24} />
            </span>
            <span className="call-controls__btn call-controls__btn--end">
              <PhoneOff size={26} />
            </span>
            <span className="call-controls__btn">
              <Volume2 size={24} />
            </span>
          </div>
        )}
      </div>
    </div>
  )
}
