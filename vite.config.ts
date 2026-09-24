import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import { VitePWA } from 'vite-plugin-pwa'
import ink from './scripts/vitePluginInk.ts'

const BASE = '/game1/'

export default defineConfig({
  base: BASE,
  plugins: [
    react(),
    ink(),
    VitePWA({
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
        runtimeCaching: [
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
