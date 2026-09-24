import { PEOPLE } from '../story/cast'
import type { SenderId } from '../story/cast'
import { asset } from '../state/assets'
import { useImageLoaded } from './useImage'
import './components.css'

interface Props {
  id: SenderId
  size?: number
}

/** 프로필 사진. 파일이 없으면 이름 첫 글자 아바타 */
export default function Avatar({ id, size = 40 }: Props) {
  const person = id === 'me' || id === 'system' ? null : PEOPLE[id]
  const src = person?.pfp ? asset(`ui/${person.pfp}.webp`) : null
  const loaded = useImageLoaded(src)
  const style = { width: size, height: size, fontSize: size * 0.42, background: person?.color }

  return (
    <span className="avatar" style={style} aria-hidden>
      {loaded && src ? <img src={src} alt="" draggable={false} /> : (person?.name.slice(0, 1) ?? '')}
    </span>
  )
}
