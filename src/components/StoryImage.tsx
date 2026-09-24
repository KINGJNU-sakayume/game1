import { ImageOff } from 'lucide-react'
import { storyAsset } from '../state/assets'
import { useImageLoaded } from './useImage'
import './components.css'

interface Props {
  /** 파일명 (확장자 없이). 폴더는 이름 규칙으로 정해진다 */
  name: string
  alt: string
  className?: string
}

/** 대본에서 이름으로 부르는 이미지. 파일이 아직 없으면 파일명이 적힌 자리표시를 보여준다 */
export default function StoryImage({ name, alt, className = '' }: Props) {
  const src = storyAsset(name)
  const loaded = useImageLoaded(src)

  if (loaded) return <img className={`story-image ${className}`} src={src} alt={alt} draggable={false} />
  return (
    <div className={`story-image story-image--placeholder ${className}`} role="img" aria-label={alt}>
      <ImageOff size={28} strokeWidth={1.6} aria-hidden />
      <span>{name}</span>
    </div>
  )
}
