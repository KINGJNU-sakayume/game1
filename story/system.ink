// 게임 시스템 변수와 도우미 함수. 엔진이 이 변수 이름을 읽는다 (docs/04_시스템_명세.md).
// 이름을 바꾸면 src/engine/director.ts도 함께 고쳐야 한다.

VAR player_name = "도현"

// 호감 (0~100). 화면에 숫자로 보이지 않는다. 단계: 1(0~24) 2(25~49) 3(50~74) 4(75~)
VAR aff_seoha = 0
VAR aff_ian = 0
VAR aff_daon = 0

// 수리 실력 (0~3). 튜브 영상을 볼 때마다 +1
VAR skill = 0

// 튜브 영상으로 배운 것 (story/videos.ink가 켠다). 수리 장면은 이 지식으로 선택지가 바뀐다
VAR k_starter = false     // 형광등 점등관
VAR k_gasket = false      // 냉장고 문 고무
VAR k_boiler = false      // 보일러 공기 빼기
VAR k_hinge = false       // 경첩 핀
VAR k_grinder = false     // 그라인더 날 청소
VAR k_chair = false       // 의자 가스 실린더
VAR k_lights = false      // 줄 전구 퓨즈
VAR k_breaker = false     // 차단기
VAR k_roaster = false     // 로스터 ① 히터·벨트
VAR k_roaster2 = false    // 로스터 ② 온도 센서
VAR k_doorlock = false    // 도어락 9V
VAR k_lantern = false     // 물병 랜턴
VAR k_incubator = false   // 보온기 온도조절기
VAR k_bolt = false        // 녹슨 볼트
VAR k_jeju = false        // 제주 만물수선 (김 사장님의 영상)
VAR roaster_step = 0      // 서하 루트: 로스터 수리 진척 (0~3)
VAR f_book_read = false   // 밤에 사장님 수첩을 통째로 읽었다 (read()와 같은 효과)

// 호감을 올리거나 내린다. 0~100을 넘지 않는다.  예: ~ raise(aff_seoha, 5)  /  ~ raise(aff_ian, -3)
=== function raise(ref affection, amount) ===
~ affection = MIN(MAX(affection + amount, 0), 100)

// 수리 실력 +1 (최대 3)
=== function study() ===
~ skill = MIN(skill + 1, 3)

// 받은 사진을 사진첩에 저장했는지 (엔진이 대답한다).  예: {saved("ian_selfie_desk_01"): 저장했네요?}
EXTERNAL saved(photo)
=== function saved(photo) ===
~ return false

// 사장님 수첩의 그 쪽을 플레이어가 메모 앱에서 열어 봤는지 (엔진이 대답한다).  예: {read("떡집 (떡솥 뚜껑)"): 수첩에서 본 대로…}
EXTERNAL read(page)
=== function read(page) ===
~ return false
