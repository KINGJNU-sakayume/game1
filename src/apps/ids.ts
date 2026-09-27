// 앱 id와 이름. 대본의 앱 선택 태그(# watch: · # go: …)와 알림 배너가 이 id로 앱을 가리킨다.
// 앱 화면(컴포넌트)은 registry.ts에서 붙인다. 여기는 엔진도 쓰므로 가볍게 둔다.

export type AppId =
  | 'messenger'
  | 'call'
  | 'photos'
  | 'calendar'
  | 'notes'
  | 'tube'
  | 'map'
  | 'snap'
  | 'town'
  | 'settings'

export const APP_NAMES: Record<AppId, string> = {
  messenger: '메신저',
  call: '전화',
  photos: '사진',
  calendar: '캘린더',
  notes: '메모',
  tube: '튜브',
  map: '지도',
  snap: '스냅',
  town: '망원살이',
  settings: '설정',
}

/** 앱 안에서 고르는 선택지가 떴을 때 알림 알약에 보이는 기본 문구 (# ask: 가 있으면 그 문구) */
export const APP_CHOICE_PROMPTS: Record<AppId, string> = {
  messenger: '답장할 방을 골라 주세요',
  call: '누구에게 연락할지 골라 주세요',
  photos: '사진을 골라 주세요',
  calendar: '일정을 골라 주세요',
  notes: '메모를 골라 주세요',
  tube: '볼 영상을 골라 주세요',
  map: '갈 곳을 골라 주세요',
  snap: '게시물에 반응해 주세요',
  town: '동네 글에 답해 주세요',
  settings: '설정을 확인해 주세요',
}
