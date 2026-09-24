// story/*.ink 파일을 import하면 빌드 시점에 inkjs 컴파일러로 JSON을 만들어 준다.
// 문법 오류가 있으면 빌드가 실패하므로 배포 전에 대본 오류를 잡을 수 있다.
import { readFileSync } from 'node:fs'
import { dirname, resolve } from 'node:path'
import type { Plugin } from 'vite'
import { Compiler, CompilerOptions } from 'inkjs/full'

export default function inkPlugin(): Plugin {
  return {
    name: 'ink',
    transform(source, id) {
      if (!id.endsWith('.ink')) return null
      const dir = dirname(id)
      const included: string[] = []
      const errors: string[] = []
      const warnings: string[] = []
      const fileHandler = {
        ResolveInkFilename: (name: string) => resolve(dir, name),
        LoadInkFileContents: (path: string) => {
          included.push(path)
          return readFileSync(path, 'utf8')
        },
      }
      const compiler = new Compiler(
        source,
        new CompilerOptions(id, [], false, (message, type) => {
          // ErrorType: 0 Author(TODO 등), 1 Warning, 2 Error
          if (type === 2) errors.push(message)
          else warnings.push(message)
        }, fileHandler),
      )
      let json: string
      try {
        json = compiler.Compile().ToJson() ?? ''
      } catch (error) {
        this.error(`ink 컴파일 실패 (${id})\n${[...errors, String(error)].join('\n')}`)
      }
      if (errors.length) this.error(`ink 컴파일 오류 (${id})\n${errors.join('\n')}`)
      for (const warning of warnings) this.warn(warning)
      for (const path of included) this.addWatchFile(path)
      return { code: `export default ${json}`, map: null }
    },
  }
}
