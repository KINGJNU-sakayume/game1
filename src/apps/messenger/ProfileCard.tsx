import { X } from 'lucide-react'
import Avatar from '../../components/Avatar'
import { PEOPLE } from '../../story/cast'
import type { PersonId } from '../../story/cast'
import { useSignal } from '../../story/useSignal'

interface Props {
  id: PersonId
  onClose: () => void
}

/** 프로필 보기: 큰 프로필 사진과 상태 메시지 */
export default function ProfileCard({ id, onClose }: Props) {
  const { status } = useSignal(id)
  return (
    <div className="profile-card" role="dialog" aria-label={`${PEOPLE[id].name} 프로필`} onClick={onClose}>
      <button type="button" className="photo-viewer__close" aria-label="닫기">
        <X size={26} />
      </button>
      <div className="profile-card__body">
        <Avatar id={id} size={120} />
        <p className="profile-card__name">{PEOPLE[id].name}</p>
        <p className="profile-card__status">{status}</p>
      </div>
    </div>
  )
}
