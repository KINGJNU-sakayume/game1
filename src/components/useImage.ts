import { useEffect, useState } from 'react'

/** 이미지가 실제로 로드되면 true. 파일이 없어도 화면이 깨지지 않게 대체 표시를 고르는 데 쓴다 */
export function useImageLoaded(src: string | null): boolean {
  const [loaded, setLoaded] = useState<string | null>(null)
  useEffect(() => {
    if (!src) return
    const img = new Image()
    img.onload = () => setLoaded(src)
    img.src = src
    return () => {
      img.onload = null
    }
  }, [src])
  return src !== null && loaded === src
}
