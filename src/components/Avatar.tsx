import { UserRound } from 'lucide-react'
import { PEOPLE } from '../story/cast'
import type { SenderId } from '../story/cast'
import { useSignal } from '../story/useSignal'
import { storyAsset } from '../state/assets'
import { useImageLoaded } from './useImage'
import './components.css'

interface Props {
  id: SenderId
  size?: number
}

/** 프로필 사진 (호감 단계에 따라 바뀜). 파일이 없으면 이름 첫 글자 아바타, 모르는 번호는 사람 실루엣 */
export default function Avatar({ id, size = 40 }: Props) {
  const person = id === 'me' || id === 'system' ? null : PEOPLE[id]
  const { pfp } = useSignal(id)
  const src = pfp ? storyAsset(pfp) : null
  const loaded = useImageLoaded(src)
  const style = { width: size, height: size, fontSize: size * 0.42, background: person?.color }

  return (
    <span className="avatar" style={style} aria-hidden>
      {loaded && src ? (
        <img src={src} alt="" draggable={false} />
      ) : person ? (
        person.name.slice(0, 1)
      ) : (
        <UserRound className="avatar__unknown" size={size * 0.56} strokeWidth={1.6} />
      )}
    </span>
  )
}
