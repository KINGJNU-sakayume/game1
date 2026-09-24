// 게임 시스템 변수와 도우미 함수. 엔진이 이 변수 이름을 읽는다 (docs/04_시스템_명세.md).
// 이름을 바꾸면 src/engine/director.ts도 함께 고쳐야 한다.

VAR player_name = "도현"

// 호감 (0~100). 화면에 숫자로 보이지 않는다. 단계: 1(0~24) 2(25~49) 3(50~74) 4(75~)
VAR aff_seoha = 0
VAR aff_ian = 0
VAR aff_daon = 0

// 수리 실력 (0~3). 밤에 유튜브로 공부하면 +1
VAR skill = 0

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
