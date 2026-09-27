// 튜브 앱의 영상 목록. 대본의 선택지 `# watch:`와 영상 재생 `# play:`에 쓰는 id가 여기 정의된다.
// points는 보관함의 "핵심 정리"로 남아 플레이어가 수리 전에 다시 볼 수 있다.
// 이 파일은 import 없이 둔다 (scripts/playtest.ts가 그대로 읽는다).

export interface Video {
  title: string
  channel: string
  /** 영상 속 목소리. 재생 화면 자막의 이름표 */
  host: string
  length: string
  views: string
  ago: string
  points: string[]
  /** 섬네일 색 (이미지가 없을 때 만드는 섬네일) */
  tint: string
}

const VIDEO_LIST = {
  starter: {
    title: '형광등이 깜빡일 때 — 점등관만 바꾸면 됩니다',
    channel: '오반장 수리교실',
    host: '오반장',
    length: '5:02',
    views: '조회수 23만회',
    ago: '3년 전',
    points: [
      '끝이 까맣게 그을렸으면 형광등보다 점등관을 먼저 의심한다',
      '형광등 옆 작은 원통(점등관)을 반 바퀴 돌려서 빼고, 새것을 돌려 끼운다',
      '스위치는 꼭 끄고. 형광등을 비틀어 빼면 먼지부터 쏟아진다',
    ],
    tint: '#3d6fb6',
  },
  gasket: {
    title: '냉장고 문 고무 다시 붙이기 — 드라이기 하나로',
    channel: '오반장 수리교실',
    host: '오반장',
    length: '7:40',
    views: '조회수 15만회',
    ago: '2년 전',
    points: [
      '늘어진 고무는 드라이기 따뜻한 바람으로 데우면 모양이 돌아온다',
      '데운 뒤 문을 닫고 5분. 테이프는 임시방편일 뿐',
      '찢어졌으면 교체. 모델명은 문 안쪽 스티커에',
    ],
    tint: '#4f8a7a',
  },
  boiler: {
    title: '보일러에서 쇠 긁는 소리가 날 때 (순환펌프 공기 빼기)',
    channel: '오반장 수리교실',
    host: '오반장',
    length: '9:12',
    views: '조회수 31만회',
    ago: '2년 전',
    points: [
      '쇠 긁는 소리는 배관에 공기가 찬 경우가 많다',
      '순환펌프 옆 작은 꼭지를 반 바퀴만 연다. 쉭 소리 뒤에 물이 나오면 바로 잠근다',
      '물 받을 통 필수. 꼭지를 끝까지 풀면 물바다',
    ],
    tint: '#b5563b',
  },
  hinge: {
    title: '뚜껑이 자꾸 뜰 때 — 경첩 핀 교체',
    channel: '오반장 수리교실',
    host: '오반장',
    length: '4:55',
    views: '조회수 4.2만회',
    ago: '1년 전',
    points: [
      '경첩 핀이 빠지거나 휘면 뚜껑이 뜬다',
      '못으로 대충 끼우면 또 빠진다. 규격 맞는 핀으로',
      '핀 끝을 망치로 톡톡 쳐서 벌려 두면 안 빠진다',
    ],
    tint: '#8a6d3b',
  },
  grinder: {
    title: '그라인더가 윙 소리만 날 때 — 날(버) 청소',
    channel: '홈카페 연구소',
    host: '홈카페 연구소',
    length: '8:03',
    views: '조회수 6.7만회',
    ago: '8개월 전',
    points: [
      '원두가 날에 끼면 모터만 헛돈다. 전원부터 뽑는다',
      '호퍼(원두통)를 빼고 윗날을 돌려서 분리',
      '솔로 가루와 기름때를 털고 전용 세척 알갱이를 한 번 갈아 준다',
    ],
    tint: '#6b4a36',
  },
  chair: {
    title: '의자가 자꾸 내려갈 때 — 5천 원으로 고치기',
    channel: '자취생 생존 공구',
    host: '생존 공구',
    length: '6:44',
    views: '조회수 52만회',
    ago: '3년 전',
    points: [
      '가스 실린더가 새면 앉을 때마다 천천히 내려간다',
      '원하는 높이에서 실린더 둘레에 PVC 파이프를 잘라 끼운다',
      '호스 클램프로 조이면 끝. 대신 높이 조절은 포기',
    ],
    tint: '#5b5f97',
  },
  lights: {
    title: '줄 전구가 안 켜질 때 — 플러그 속 퓨즈',
    channel: '오반장 수리교실',
    host: '오반장',
    length: '5:31',
    views: '조회수 3.3만회',
    ago: '1년 전',
    points: [
      '줄 전구 플러그 안에는 손톱만 한 퓨즈가 숨어 있다',
      '플러그 옆 작은 뚜껑을 밀어 열고 퓨즈를 바꾼다',
      '여분 퓨즈는 보통 포장 상자나 플러그 안에 하나 더',
    ],
    tint: '#c28a2c',
  },
  timing: {
    title: '썸 탈 때 답장은 몇 분 뒤에? 연애 고수의 대답',
    channel: '연애 상담소 제이',
    host: '제이',
    length: '11:11',
    views: '조회수 204만회',
    ago: '5년 전',
    points: [
      '바로 답하면 없어 보인다? 사람마다 다르다',
      '결론: 상대의 속도에 맞출 것. 늦게 읽는 사람에게는 기다려 주기',
      '댓글 1위: 이거 볼 시간에 답장이나 하세요',
    ],
    tint: '#c0567a',
  },
  breaker: {
    title: '비만 오면 차단기가 내려갈 때',
    channel: '오반장 수리교실',
    host: '오반장',
    length: '10:05',
    views: '조회수 18만회',
    ago: '2년 전',
    points: [
      '습기가 차면 누전 차단기가 먼저 떨어진다',
      '차단기를 전부 내리고 하나씩 올려서 범인을 찾는다',
      '젖은 콘센트는 말린 뒤에. 억지로 올리지 말 것',
    ],
    tint: '#2f5d8a',
  },
  roaster: {
    title: '소형 로스터 살리기 ① 히터와 벨트',
    channel: '커피 볶는 목요일',
    host: '목요일',
    length: '14:20',
    views: '조회수 1.2만회',
    ago: '2년 전',
    points: [
      '안 데워지면 히터 선이 끊겼는지부터 본다',
      '드럼이 안 돌면 벨트가 늘어난 것. 같은 규격으로 교체',
      '온도 센서는 맨 마지막에',
    ],
    tint: '#7a3f2a',
  },
  roaster2: {
    title: '소형 로스터 살리기 ② 온도 센서',
    channel: '커피 볶는 목요일',
    host: '목요일',
    length: '11:47',
    views: '조회수 8천회',
    ago: '2년 전',
    points: [
      '온도 센서는 드럼 옆의 가는 금속 막대',
      '끝이 그을렸으면 닦고, 선이 헐거우면 다시 조인다',
      '첫 배치는 버린다 생각하고 볶는다',
    ],
    tint: '#8c5a2b',
  },
  doorlock: {
    title: '도어락이 방전됐을 때 여는 법 (9V 건전지)',
    channel: '자취생 생존 공구',
    host: '생존 공구',
    length: '3:58',
    views: '조회수 88만회',
    ago: '4년 전',
    points: [
      '도어락 아래쪽에 금속 접점 두 개가 있다',
      '9V 건전지를 거기 대고 있으면 비상 전원이 들어온다',
      '그 상태로 비밀번호. 들어가면 건전지부터 교체',
    ],
    tint: '#4a5a6a',
  },
  lantern: {
    title: '정전 됐을 때 물병 랜턴 만들기',
    channel: '자취생 생존 공구',
    host: '생존 공구',
    length: '2:41',
    views: '조회수 120만회',
    ago: '2년 전',
    points: [
      '휴대폰 손전등을 위로 향하게 켠다',
      '물 채운 페트병을 올리면 방 전체가 은은하게 밝아진다',
      '우유를 한 방울 넣으면 빛이 더 부드러워진다',
    ],
    tint: '#2d6f8f',
  },
  incubator: {
    title: '보온기·온열 매트가 안 켜질 때 — 온도조절기 접점',
    channel: '오반장 수리교실',
    host: '오반장',
    length: '8:26',
    views: '조회수 2.1만회',
    ago: '1년 전',
    points: [
      '온도조절기 접점이 그을리면 전원이 안 들어온다',
      '전원을 뽑고 뚜껑을 열어 고운 사포로 살살',
      '접점 간격은 종이 한 장. 너무 벌리면 다시 안 붙는다',
    ],
    tint: '#9a4f6a',
  },
  bolt: {
    title: '녹슨 볼트 푸는 법 — 힘이 아니라 기다림',
    channel: '오반장 수리교실',
    host: '오반장',
    length: '7:09',
    views: '조회수 9.4만회',
    ago: '2년 전',
    points: [
      '방청 윤활제를 뿌리고 10분 기다린다',
      '망치로 볼트 머리를 톡톡. 녹이 깨지는 소리가 난다',
      '힘으로 돌리면 머리가 뭉개진다. 조금씩, 여러 번',
    ],
    tint: '#6f6a5a',
  },
  jeju: {
    title: '[1화] 삼십 년 된 라디오',
    channel: '제주 만물수선',
    host: '제주 만물수선',
    length: '12:30',
    views: '조회수 41회',
    ago: '3일 전',
    points: [
      '라디오는 먼지부터 턴다',
      '잡음은 볼륨 손잡이 안쪽. 접점 세정제 한 번',
      '고치는 건 기술이 아니라 끈기여',
    ],
    tint: '#3f6b4f',
  },
} satisfies Record<string, Video>

export type VideoId = keyof typeof VIDEO_LIST

export const VIDEOS: Record<VideoId, Video> = VIDEO_LIST

export function isVideoId(id: string): id is VideoId {
  return id in VIDEOS
}
