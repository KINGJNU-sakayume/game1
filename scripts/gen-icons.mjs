// 임시 앱 아이콘 생성기 (의존성 없음). 단색 배경 + 흰색 수화기.
// 실행: npm run icons → public/icons/*.png
import { deflateSync } from 'node:zlib'
import { mkdirSync, writeFileSync } from 'node:fs'

const BG = [0xf2, 0x68, 0x5c]
const FG = [0xff, 0xff, 0xff]
const SS = 4 // 슈퍼샘플링
const TILT = (-30 * Math.PI) / 180

function capsule(px, py, ax, ay, bx, by, r) {
  const dx = bx - ax, dy = by - ay
  const t = Math.max(0, Math.min(1, ((px - ax) * dx + (py - ay) * dy) / (dx * dx + dy * dy)))
  return Math.hypot(px - ax - dx * t, py - ay - dy * t) - r
}

// 수화기 모양 SDF (0..1 정규화 좌표, 음수면 안쪽)
function handset(x, y) {
  // 가운데 기준 회전
  const cx = 0.5, cy = 0.5
  const c = Math.cos(TILT), s = Math.sin(TILT)
  const lx = (x - cx) * c - (y - cy) * s
  const ly = (x - cx) * s + (y - cy) * c
  // 손잡이: 완만한 위쪽 아치
  const ax = 0, ay = 0.33, r = 0.42, thick = 0.1
  const a0 = (-132 * Math.PI) / 180, a1 = (-48 * Math.PI) / 180
  const ang = Math.atan2(ly - ay, lx - ax)
  let d = ang >= a0 && ang <= a1 ? Math.abs(Math.hypot(lx - ax, ly - ay) - r) - thick / 2 : 1
  // 송·수화부: 아치 양 끝에서 안쪽(손잡이에 수직)으로 뻗은 캡슐
  for (const a of [a0, a1]) {
    const ex = ax + r * Math.cos(a), ey = ay + r * Math.sin(a)
    d = Math.min(d, capsule(lx, ly, ex, ey, ex - Math.cos(a) * 0.1, ey - Math.sin(a) * 0.1, 0.085))
  }
  return d
}

function crc32(buf) {
  let c, crc = 0xffffffff
  for (let n = 0; n < buf.length; n++) {
    c = (crc ^ buf[n]) & 0xff
    for (let k = 0; k < 8; k++) c = c & 1 ? 0xedb88320 ^ (c >>> 1) : c >>> 1
    crc = (crc >>> 8) ^ c
  }
  return (crc ^ 0xffffffff) >>> 0
}

function chunk(type, data) {
  const len = Buffer.alloc(4)
  len.writeUInt32BE(data.length)
  const td = Buffer.concat([Buffer.from(type, 'ascii'), data])
  const crc = Buffer.alloc(4)
  crc.writeUInt32BE(crc32(td))
  return Buffer.concat([len, td, crc])
}

function png(size) {
  const raw = Buffer.alloc(size * (size * 3 + 1))
  for (let y = 0; y < size; y++) {
    const row = y * (size * 3 + 1)
    raw[row] = 0
    for (let x = 0; x < size; x++) {
      let hit = 0
      for (let sy = 0; sy < SS; sy++)
        for (let sx = 0; sx < SS; sx++)
          if (handset((x + (sx + 0.5) / SS) / size, (y + (sy + 0.5) / SS) / size) < 0) hit++
      const k = hit / (SS * SS)
      for (let i = 0; i < 3; i++) raw[row + 1 + x * 3 + i] = Math.round(BG[i] * (1 - k) + FG[i] * k)
    }
  }
  const ihdr = Buffer.alloc(13)
  ihdr.writeUInt32BE(size, 0)
  ihdr.writeUInt32BE(size, 4)
  ihdr[8] = 8 // bit depth
  ihdr[9] = 2 // RGB
  return Buffer.concat([
    Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]),
    chunk('IHDR', ihdr),
    chunk('IDAT', deflateSync(raw, { level: 9 })),
    chunk('IEND', Buffer.alloc(0)),
  ])
}

const out = new URL('../public/icons/', import.meta.url)
mkdirSync(out, { recursive: true })
for (const [name, size] of [['icon-192.png', 192], ['icon-512.png', 512], ['apple-touch-icon.png', 180]]) {
  writeFileSync(new URL(name, out), png(size))
  console.log('wrote', name)
}
