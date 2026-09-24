import { Hammer } from 'lucide-react'

/** 아직 만들지 않은 앱의 빈 화면 */
export default function ComingSoon() {
  return (
    <div className="coming-soon">
      <Hammer size={36} strokeWidth={1.6} aria-hidden />
      <p>준비 중</p>
    </div>
  )
}
