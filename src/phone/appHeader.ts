import { createContext, useContext, useEffect } from 'react'

export interface HeaderOverride {
  title: string
  subtitle?: string
  /** 헤더 뒤로 버튼 동작 (앱 안에서 이전 화면으로) */
  onBack: () => void
}

export const AppHeaderContext = createContext<(header: HeaderOverride | null) => void>(() => {})

/** 앱 안의 하위 화면에서 공통 헤더의 제목과 뒤로 버튼을 바꾼다 */
export function useAppHeader(header: HeaderOverride | null) {
  const setHeader = useContext(AppHeaderContext)
  const title = header?.title
  const subtitle = header?.subtitle
  const onBack = header?.onBack
  useEffect(() => {
    setHeader(title !== undefined && onBack ? { title, subtitle, onBack } : null)
    return () => setHeader(null)
  }, [setHeader, title, subtitle, onBack])
}
