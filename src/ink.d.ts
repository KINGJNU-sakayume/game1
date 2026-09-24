declare module '*.ink' {
  /** inkjs 컴파일 결과 (Story 생성자에 그대로 넘긴다) */
  const story: Record<string, unknown>
  export default story
}
