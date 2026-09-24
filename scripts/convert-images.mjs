// raw/ 에 넣은 원본 이미지(PNG·JPG)를 게임용 WebP로 바꿔 public/assets/ 아래에 넣는다.
// 빌드(npm run build)와 개발 서버(npm run dev) 전에 자동으로 실행된다. 바뀐 파일만 다시 만든다.
//
// 폴더는 파일명 규칙(docs/07_아트_파이프라인.md)으로 정한다 — src/state/assets.ts의 assetFolder와 같은 규칙:
//   bg_*            → backgrounds/  (1080 폭 이하, WebP 80)
//   *_ref_* *_face_* → characters/
//   *_pfp_*         → ui/           (512×512 정사각형)
//   그 외(scene·selfie·call·cg) → cg/
import { mkdirSync, readdirSync, statSync, existsSync } from 'node:fs'
import { extname, basename, join } from 'node:path'
import sharp from 'sharp'

const RAW = 'raw'
const OUT = 'public/assets'
const NAME_RULE = /^[a-z0-9]+(_[a-z0-9]+)+$/
const SOURCE_EXT = new Set(['.png', '.jpg', '.jpeg', '.webp'])

export function assetFolder(name) {
  const [who, kind] = name.split('_')
  if (who === 'bg') return 'backgrounds'
  if (kind === 'ref' || kind === 'face') return 'characters'
  if (kind === 'pfp') return 'ui'
  return 'cg'
}

if (!existsSync(RAW)) process.exit(0)

let made = 0
let skipped = 0
const problems = []
for (const file of readdirSync(RAW)) {
  const ext = extname(file).toLowerCase()
  if (!SOURCE_EXT.has(ext)) continue
  const name = basename(file, extname(file))
  if (!NAME_RULE.test(name)) {
    problems.push(`${file}: 파일명은 영문 소문자·숫자·밑줄만 (예: seoha_face_smile_01)`)
    continue
  }
  const folder = assetFolder(name)
  const src = join(RAW, file)
  const dest = join(OUT, folder, `${name}.webp`)
  if (existsSync(dest) && statSync(dest).mtimeMs >= statSync(src).mtimeMs) {
    skipped++
    continue
  }
  mkdirSync(join(OUT, folder), { recursive: true })
  const image = sharp(src).rotate()
  if (folder === 'ui') image.resize(512, 512, { fit: 'cover' })
  else image.resize({ width: 1080, withoutEnlargement: true })
  await image.webp({ quality: 80 }).toFile(dest)
  made++
}
console.log(`[images] 변환 ${made}개, 그대로 ${skipped}개`)
for (const p of problems) console.warn(`[images] 건너뜀 — ${p}`)
