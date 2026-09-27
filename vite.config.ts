import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { VitePWA } from 'vite-plugin-pwa'
import ink from './scripts/vitePluginInk.ts'

// PR 미리보기: GitHub Actions가 PREVIEW_PR=번호로 빌드해 /game1/pr-preview/pr-번호/ 에 함께 올린다 (.github/workflows/deploy.yml)
const PREVIEW_PR = process.env.PREVIEW_PR?.match(/^\d+$/)?.[0] ?? null
const BASE = PREVIEW_PR ? `/game1/pr-preview/pr-${PREVIEW_PR}/` : '/game1/'

export default defineConfig({
  base: BASE,
  plugins: [
    react(),
    ink(),
    VitePWA({
      // 미리보기는 본 게임과 같은 주소(origin)를 쓰므로 서비스 워커를 만들지 않는다 (본 게임의 캐시와 섞이지 않게)
      disable: PREVIEW_PR !== null,
      registerType: 'autoUpdate',
      includeManifestIcons: false, // globPatterns가 이미 icons/*.png를 포함
      manifest: {
        name: '지금 거신 번호는',
        short_name: '지금 거신 번호',
        lang: 'ko',
        display: 'standalone',
        orientation: 'portrait',
        start_url: BASE,
        scope: BASE,
        theme_color: '#101418',
        background_color: '#101418',
        icons: [
          { src: 'icons/icon-192.png', sizes: '192x192', type: 'image/png' },
          { src: 'icons/icon-512.png', sizes: '512x512', type: 'image/png' },
          { src: 'icons/icon-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' },
        ],
      },
      workbox: {
        globPatterns: ['**/*.{js,css,html,png,svg,webp,woff2}'],
        // 본 게임의 서비스 워커가 PR 미리보기 주소를 가로채 본 게임 화면을 보여 주지 않게
        navigateFallbackDenylist: [/\/pr-preview\//],
        // 대본 이미지는 많아지므로 처음에 전부 받지 않고, 한 번 본 것만 저장한다
        globIgnores: ['assets/{cg,characters,backgrounds,ui}/**'],
        runtimeCaching: [
          {
            urlPattern: ({ url }) => /\/assets\/(cg|characters|backgrounds|ui)\//.test(url.pathname),
            handler: 'CacheFirst',
            options: {
              cacheName: 'story-images',
              expiration: { maxEntries: 400, maxAgeSeconds: 60 * 60 * 24 * 60 },
              cacheableResponse: { statuses: [200] },
            },
          },
          {
            urlPattern: ({ url }) => url.origin === 'https://cdn.jsdelivr.net',
            handler: 'CacheFirst',
            options: {
              cacheName: 'cdn-fonts',
              expiration: { maxEntries: 200, maxAgeSeconds: 60 * 60 * 24 * 365 },
              cacheableResponse: { statuses: [0, 200] },
            },
          },
        ],
      },
    }),
  ],
})
