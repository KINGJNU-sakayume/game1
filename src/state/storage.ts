// localStorage 래퍼. 모든 키에 `jgbn_` 접두사를 붙이고, 접근 실패(사생활 보호 모드, 용량 초과 등)는 조용히 무시한다.

const PREFIX = 'jgbn_'

function getStore(): Storage | null {
  try {
    return window.localStorage
  } catch {
    return null
  }
}

export function load<T>(key: string, fallback: T): T {
  try {
    const raw = getStore()?.getItem(PREFIX + key)
    return raw == null ? fallback : (JSON.parse(raw) as T)
  } catch {
    return fallback
  }
}

export function save(key: string, value: unknown): void {
  try {
    getStore()?.setItem(PREFIX + key, JSON.stringify(value))
  } catch {
    // 저장 실패는 무시한다
  }
}

export function remove(key: string): void {
  try {
    getStore()?.removeItem(PREFIX + key)
  } catch {
    // 무시
  }
}

/** `jgbn_` 접두사가 붙은 키만 전부 삭제한다. */
export function clearAll(): void {
  try {
    const store = getStore()
    if (!store) return
    const keys: string[] = []
    for (let i = 0; i < store.length; i++) {
      const key = store.key(i)
      if (key?.startsWith(PREFIX)) keys.push(key)
    }
    keys.forEach((key) => store.removeItem(key))
  } catch {
    // 무시
  }
}

// ───────── 프로필 ─────────

export interface Profile {
  name: string
}

export const DEFAULT_NAME = '도현'

export function loadProfile(): Profile | null {
  const profile = load<Profile | null>('profile', null)
  return profile && typeof profile.name === 'string' && profile.name.trim() ? profile : null
}

export function saveProfile(profile: Profile): void {
  save('profile', profile)
}

// ───────── 설정 ─────────

export type TextSpeed = 'slow' | 'normal' | 'fast'

export interface Settings {
  textSpeed: TextSpeed
}

const DEFAULT_SETTINGS: Settings = { textSpeed: 'normal' }

export function loadSettings(): Settings {
  return { ...DEFAULT_SETTINGS, ...load<Partial<Settings>>('settings', {}) }
}

export function saveSettings(settings: Settings): void {
  save('settings', settings)
}
