// public/assets 아래 파일 경로. 배포 경로(/game1/)가 바뀌어도 동작하도록 BASE_URL 기준으로 만든다.

export type AssetFolder = 'cg' | 'characters' | 'backgrounds' | 'ui'

export function asset(path: string): string {
  return `${import.meta.env.BASE_URL}assets/${path}`
}

/**
 * 파일명 규칙(docs/07_아트_파이프라인.md)으로 폴더를 정한다.
 * scripts/convert-images.mjs의 assetFolder와 같은 규칙이어야 한다.
 */
export function assetFolder(name: string): AssetFolder {
  const [who, kind] = name.split('_')
  if (who === 'bg') return 'backgrounds'
  if (kind === 'ref' || kind === 'face') return 'characters'
  if (kind === 'pfp') return 'ui'
  return 'cg'
}

/** 대본에서 이름으로 부르는 이미지의 주소 (확장자 없이 이름만) */
export function storyAsset(name: string): string {
  return asset(`${assetFolder(name)}/${name}.webp`)
}

/** 홈 화면 배경. 파일이 없으면 CSS 그라데이션이 그대로 보인다. */
export const WALLPAPER_SRC = storyAsset('bg_wallpaper_01')
