import { Check, Download, X } from 'lucide-react'
import StoryImage from './StoryImage'
import { savePhoto, useGame } from '../engine/store'
import type { SenderId } from '../story/cast'
import './components.css'

interface Props {
  name: string
  alt: string
  /** 받은 사진이면 보낸 사람. 있으면 "사진첩에 저장" 버튼을 보여준다 */
  from?: SenderId | null
  onClose: () => void
}

/** 사진 크게 보기. 받은 사진은 여기서 사진첩에 저장할 수 있다 (저장한 사진만 사진첩에 남는다) */
export default function PhotoViewer({ name, alt, from, onClose }: Props) {
  const saved = useGame((s) => s.journal.photos.some((p) => p.name === name))

  return (
    <div className="photo-viewer" role="dialog" aria-label="사진 보기" onClick={onClose}>
      <button type="button" className="photo-viewer__close" aria-label="닫기">
        <X size={26} />
      </button>
      <StoryImage name={name} alt={alt} className="photo-viewer__image" />
      {from !== undefined && (
        <button
          type="button"
          className="photo-viewer__save"
          disabled={saved}
          onClick={(e) => {
            e.stopPropagation()
            savePhoto(name, from)
          }}
        >
          {saved ? <Check size={20} aria-hidden /> : <Download size={20} aria-hidden />}
          {saved ? '사진첩에 저장됨' : '사진첩에 저장'}
        </button>
      )}
    </div>
  )
}
