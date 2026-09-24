import type { ReactNode, Ref } from 'react'
import { Smartphone } from 'lucide-react'

interface Props {
  ref?: Ref<HTMLDivElement>
  children: ReactNode
}

/** 게임 루트. 폰에서는 전체화면, 넓은 화면에서는 가운데 폰 프레임. */
export default function PhoneFrame({ ref, children }: Props) {
  return (
    <div className="phone-stage">
      <div className="phone" ref={ref}>
        {children}
      </div>
      <div className="rotate-overlay" role="alert">
        <Smartphone size={48} strokeWidth={1.6} aria-hidden />
        <p>세로로 돌려주세요</p>
      </div>
    </div>
  )
}
