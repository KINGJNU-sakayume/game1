// public/assets 아래 파일 경로. 배포 경로(/game1/)가 바뀌어도 동작하도록 BASE_URL 기준으로 만든다.

export function asset(path: string): string {
  return `${import.meta.env.BASE_URL}assets/${path}`
}

/** 홈 화면 배경. 파일이 없으면 CSS 그라데이션이 그대로 보인다. */
export const WALLPAPER_SRC = asset('backgrounds/bg_wallpaper_01.webp')
