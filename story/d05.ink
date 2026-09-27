// D5 — 3월 13일 금요일 (맑음)
// 한강공원 봄밤 장터. 전구, 세 부스, 발전기 정전 속 셋과 동시 조우, 끝까지 함께 있을 사람. 밤: 루트 결정.
// 문법: docs/05_스크립트_문법.md

// ── D5에서 생기는 플래그 ──
VAR f_d5_on_time = false     // 장터 준비(4시)에 늦지 않았다 — 다온 핵심 플래그의 두 번째 기회
VAR f_d5_lights = false      // 전구를 스스로 고쳤다 (영상·수첩)
VAR d5_first = 0             // 장터에서 먼저 간 부스: 1 서하 / 2 이안 / 3 다온
VAR d5_with = 0              // 끝까지 함께 있었던 사람: 1 서하 / 2 이안 / 3 다온


// ════════════════════════════════
// 아침
// ════════════════════════════════
=== d05_morning ===
# day: 5
# time: 07:50
# note: 3월 13일
맑음. 최고 16도. 봄밤이라는 말이 어울리는 날씨라고 일기예보가 말했다.
{f_d4_slept && aff_ian >= 12: -> ian_sorry}
-> chat

= ian_sorry
# room: ian
어제 자는 거 알면서 걸었어요 ㅋㅋ 미안!!
그냥 얼굴 보고 잘 자라고 하려던 거였어요
* [다음엔 받을게요]
    ~ raise(aff_ian, 2)
    ㅋㅋㅋ 약속!!
* [무슨 일 있었어요?]
    ~ raise(aff_ian, 1)
    아뇨 아뇨 ㅋㅋ 그냥 새벽이라서요
    새벽엔 다들 조금씩 이상해지잖아요
- -> chat

= chat
# time: 08:00
# room: dangol
# from: halmeoni # big
오늘 봄밤 장터
# from: choi
한강 봄밤 장터! 정육점 꼬치 부스 나감 ㅋㅋ 총각 불 좀 봐 줘
# from: guard
발전기는 관리실 거 빌려줌. 총각이 들고 가
# from: seoha
오후세시도 커피 부스 나가요 :) 다들 오세요.
# from: ian
저 마감 탈출해서 스케치하러 감!!
# from: daon
병원 입양 캠페인 부스 있습니다. 두부도 옵니다.
# from: choi
헐 다온이가 먼저 말을 걸었다
# from: halmeoni # big
두부 보러 갈게요
* [저도 갈게요 # say: 저도 갈게요! 준비는 몇 시예요?]
    # from: choi
    네 시! 발전기 들고 와 총각 ㅋㅋ
* [읽고 넘기기 # act]
    # from: choi
    총각 읽었지? 네 시다 ㅋㅋ
- # plan: festival_setup, 5, 16:00, 장터 준비 · 한강공원 (발전기 들고)
# event: festival, 5, 망원 봄밤 장터 17:00~22:00
# pin: river
# town: t_fest, 공지, 망원1동 주민센터
[안내] 망원 봄밤 장터 — 3월 13일(금) 17시~22시, 한강공원 망원지구
# town: t_fest
먹거리 · 작은 공연 · 유기동물 입양 캠페인. 우천 시 취소합니다.
# townreply: t_fest, 망원토박이
작년엔 만물수선 사장님이 전구 다 달아 주셨는데 올해는 누가 하나
# townreply: t_fest, 떡집 단골
그 번호 받은 총각이 한다던데요 ㅋㅋ
# time: 09:30
# post: dubu_p2 # from: dubu # photo: dubu_cg_festival_01
두부 오늘 한강 나들이 🐾 입양 캠페인 부스에서 만나요
-> noon


// ── 낮: 준비 ──
= noon
# time: 11:40
# room: seoha
부스에서 쓸 전기가 걱정이에요.
커피 머신이 전기를 많이 먹거든요. 발전기가 버틸까요? :)
# room: ian # time: 11:52
저 오늘 사람 그리러 가요!!
뒷모습 말고 ㅋㅋ
아마도…
{aff_daon >= 20: -> daon_ping | -> free}

= daon_ping
# room: daon # time: 12:30
부스 설치 네 시예요.
늦지 마세요.
-> free

= free
# time: 13:00 # at: home
# note: 3월 13일
네 시까지 세 시간. 뭘 하지.
# ask: 네 시까지 뭐 할까?
* {not k_lights} [튜브 보기 # act]
    -> tube
* [사장님 수첩 펼쳐 보기 # act]
    ~ f_book_read = true
    # note: 3월 13일
    수첩에 "봄밤 장터 (전구)"라는 쪽이 있다. 해마다 3월. 줄 전구 플러그 속 퓨즈. 여분은 관리실 서랍, 작년 상자 안.
    # note: 3월 13일
    관리실에 들러 경비 아저씨한테 작년 상자를 받았다. 상자 속에 손톱만 한 퓨즈가 두 개 굴러다닌다.
    -> setup_call
* [낮잠 자기 # act]
    # note: 3월 13일
    잤다. 개운하다. 이런 게 쉬는 거였지.
    -> setup_call

= tube
# ask: 낮에 볼 영상
* [줄 전구가 안 켜질 때 — 플러그 속 퓨즈 # watch: lights]
    -> video_lights ->
* [그만 보기]
- -> setup_call

= setup_call
# time: 15:38 # wait: 1
# call: choi
* [받기 # answer]
    총각! 오는 길에 숯 한 포대만 사다 줘! 시장 입구 철물점에 있어!
    # narr
    (3시 38분. 숯을 사서 가면 4시는 넘는다. 발전기도 들어야 한다.)
    * * [숯 사서 가기 # say: 네 네, 사 갈게요!]
        ~ f_d5_on_time = false
        좋아 좋아! 역시 총각!
        # call: end
        -> d05_setup_late
    * * [지금은 어려워요 # say: 지금 발전기 들고 가는 중이라서요. 숯은 가서 같이 사러 가요!]
        ~ f_d5_on_time = true
        ㅋㅋ 알았어 알았어. 네 시에 봐!
        # call: end
        -> d05_setup
* [거절 # decline]
    ~ f_d5_on_time = true
    # room: dangol
    # from: choi
    총각 전화 안 받네 ㅋㅋ 숯은 내가 사 갈게
    -> d05_setup


// ════════════════════════════════
// 오후 — 장터 준비
// ════════════════════════════════
=== d05_setup_late ===
# time: 16:14
# scene: bg_festival_setup_01 # at: river, 봄밤 장터 준비
4시 14분. 숯 포대와 발전기를 양손에 들고 강변을 뛴다.
입양 캠페인 천막 아래에서 김다온이 시계를 본다. 그리고 나를 본다. 아무 말도 하지 않는다.
~ raise(aff_daon, -2)
# from: choi
오 숯! 총각 최고!
-> d05_setup.lights

=== d05_setup ===
# time: 15:58
# scene: bg_festival_setup_01 # at: river, 봄밤 장터 준비
3시 58분. 강바람이 세다. 천막들이 반쯤 서 있다.
입양 캠페인 천막 아래에서 김다온이 시계를 본다. 그리고 나를 본다.
# cut: daon_face_neutral_01 # from: daon
네 시 전이네요.
~ raise(aff_daon, 4)
-> lights

= lights
# cut: bg_festival_setup_01
최 사장님의 꼬치 부스, 박 할머니의 떡 좌판, 오후세시의 커피 부스. 천막마다 줄 전구가 걸려 있다.
발전기를 돌리고 스위치를 올린다. 전구가 하나도 켜지지 않는다.
모두가 나를 본다.
# from: choi
만물수선 총각! 출동!
{k_lights || read("봄밤 장터 (전구)") || f_book_read: -> known | -> unknown}

= known
(전구를 돌리지 말 것. 플러그 속 퓨즈.)
플러그 옆 작은 뚜껑을 밀어 연다. 까맣게 탄 퓨즈가 보인다.
{f_book_read: 관리실 작년 상자에서 가져온 퓨즈를 끼운다.|포장 상자를 뒤지자 정말로 여분 퓨즈가 들어 있다.}
# fx: zoom
강변을 따라 전구가 한꺼번에 켜진다. 누가 먼저랄 것도 없이 박수가 터진다.
~ f_d5_lights = true
~ raise(aff_daon, 3)
# cut: daon_face_surprised_01 # from: daon
…할아버지가 매년 이거 했어요.
# from: daon
플러그 안에 퓨즈 있는 거, 할아버지 말고 아는 사람 처음 봐요.
-> lit

= unknown
* [전구를 하나씩 돌려 보기 # say: 전구가 헐거운 것 같은데요. 하나씩 돌려 볼게요.]
    ~ raise(aff_daon, -2)
    # fx: shake
    삼십 분 동안 전구 쉰 개를 돌렸다. 하나도 켜지지 않는다. 손끝이 까맣다.
    # cut: daon_face_pout_01 # from: daon
    만지지 마세요. 전구가 문제가 아니에요.
* [모르겠다고 하기 # say: 죄송해요 여러분, 전구는 처음이에요. 어디부터 봐야 할지 모르겠어요.]
    ~ raise(aff_daon, 3)
    # from: choi
    ㅋㅋ 총각 솔직하네
    # cut: daon_face_neutral_01 # from: daon
    …그렇게 말하는 거, 할아버지랑 똑같네요.
- 그녀가 가운 주머니에서 작은 봉투를 꺼낸다. 손톱만 한 퓨즈 두 개.
# from: daon
플러그 안에 퓨즈 있어요. 할아버지가 매년 이거 했어요. 작년에 옆에서 봤어요.
# from: daon
혹시 몰라서 챙겨 왔어요.
그녀가 알려 주는 대로 플러그 뚜껑을 열고 퓨즈를 바꾼다.
# fx: zoom
강변을 따라 전구가 한꺼번에 켜진다. 박수가 터진다. 그녀는 박수 치지 않고 천막으로 돌아간다.
-> lit

= lit
# from: halmeoni
잘했어요! 만물수선 이 대 사장!
# from: guard
작년보다 빨랐어
# scene: end
~ f_daon_key = (f_daon_time || f_d5_on_time) && not f_daon_liar
# done: festival_setup
-> d05_festival


// ════════════════════════════════
// 저녁 — 봄밤 장터
// ════════════════════════════════
=== d05_festival ===
# time: 18:30
# pin: fest_coffee, fest_bench, fest_adopt
# note: 3월 13일
해가 지자 강변이 주황색으로 물든다. 지도에 장터의 핀이 세 개 떴다. 커피 부스, 강변 벤치, 입양 캠페인.
# ask: 장터, 어디부터 갈까?
* [오후세시 커피 부스 # go: fest_coffee]
    ~ d5_first = 1
    -> coffee
* [강변 벤치 (스케치하는 사람) # go: fest_bench]
    ~ d5_first = 2
    -> bench
* [입양 캠페인 부스 # go: fest_adopt]
    ~ d5_first = 3
    -> adopt

= coffee
# scene: bg_festival_night_01 # at: fest_coffee, 봄밤 장터
커피 부스 앞에 줄이 길다. 앞치마를 두른 윤서하가 혼자 주문을 받고, 커피를 내리고, 거스름돈을 센다.
# cut: seoha_face_surprised_01 # from: seoha
어, 오셨어요? 아 잠깐만요, 아이스 두 잔이요? 네!
(도와 달라는 말을 못 하는 얼굴이다.)
* [주문 받기 # say: 제가 주문 받을게요. 서하 씨는 커피만 내려요.]
    ~ raise(aff_seoha, 4)
    # cut: seoha_face_smile_01 # from: seoha
    …구원자다.
    한 시간 동안 주문을 받는다. 광고 회사에서 배운 것 중에 쓸모 있는 게 하나 있었다. 사람 앞에서 웃는 법.
* [줄 서서 기다리기 # act]
    ~ raise(aff_seoha, 1)
    20분을 기다려 내 차례가 온다. 그녀가 내 얼굴을 보고 웃는다. 줄 서서 기다린 게 웃긴 모양이다.
- # cut: seoha_scene_booth_01 # from: seoha
이거 봄 메뉴 시험작이에요.{menu_name == 1: 이름은 "오후세시의 봄".}{menu_name == 2: 이름은 "딸기가 먼저 온 오후".}{menu_name == 3: 이름은 그냥 딸기 라떼.} 제일 먼저 드려요.
딸기 향이 먼저 오고 커피가 나중에 온다.
# from: seoha
이 동네에서 오래 장사하고 싶어요.
# from: seoha
…할 수 있으면요.
* [무슨 일 있어요? # say: 할 수 있으면요, 라는 말이 걸리네요. 무슨 일 있어요?]
    ~ raise(aff_seoha, 4)
    # cut: seoha_face_pout_01 # from: seoha
    아뇨. 그냥… 봄이라서요 :)
    (계산대 옆 서랍에 넣던 봉투가 생각난다. "임대차 계약 만료 안내".)
* [할 수 있어요]
    ~ raise(aff_seoha, 2)
    # from: seoha
    그렇게 쉽게 말해 주니까 좋네요 ㅎㅎ
* [제가 단골 할게요]
    ~ raise(aff_seoha, 3)
    # from: seoha
    단골 예약까지. 오늘 장사 잘됐네요 :)
- # scene: end
-> blackout

= bench
# scene: bg_festival_night_01 # at: fest_bench, 봄밤 장터
강변 벤치에 흰 헤드폰을 목에 건 사람이 스케치북을 무릎에 올려놓고 앉아 있다. 채이안.
# cut: ian_scene_sketch_01 # from: ian
오 왔다 ㅋㅋ 앉아요 앉아요. 모델 필요했어요.
스케치북에는 장터 사람들이 가득하다. 꼬치를 굽는 최 사장님의 등, 떡을 써는 박 할머니의 등, 줄 선 사람들의 등.
# from: ian
오늘은 앞모습 그려 보려고 했는데… 못 하겠어요 ㅋㅋ
# cut: ian_face_neutral_01 # from: ian
사람 얼굴은 잘 안 그려요. 무서워서.
* [안 그려도 돼요 # say: 안 그려도 돼요. 뒷모습도 이안 씨 그림이잖아요.]
    ~ raise(aff_ian, 3)
    # cut: ian_face_shy_01 # from: ian
    …그 말은 처음 들어 봐요. 다들 얼굴 좀 그려 보라고 하는데.
* [뭐가 무서운데요? # say: 뭐가 무서운데요?]
    ~ raise(aff_ian, 4)
    # from: ian
    얼굴을 그리면요, 그 사람이 날 어떻게 보는지가 같이 그려져요.
    # from: ian
    그걸 보는 게 무서워요. 날 별로라고 보는 얼굴을 제 손으로 그리게 될까 봐.
* [제 얼굴은 더 무섭죠 # say: 제 얼굴은 더 무서우니까 안 그리는 게 나아요 ㅎㅎ]
    ~ raise(aff_ian, 2)
    # cut: ian_face_smile_01 # from: ian
    ㅋㅋㅋㅋㅋ 그건 인정
- # from: ian
그래도 오늘은 하나 그렸어요.
그녀가 스케치북을 넘긴다. 강을 보고 나란히 앉은 두 사람의 뒷모습. 한 사람 목에 헤드폰이 걸려 있다.
(뒷모습인데, 이상하게 앞모습보다 많은 게 보인다.)
# scene: end
-> blackout

= adopt
# scene: bg_festival_night_01 # at: fest_adopt, 봄밤 장터
입양 캠페인 천막. 케이지 안에서 새끼 고양이 세 마리가 잠들어 있고, 두부는 천막 기둥에 등을 대고 손님을 구경한다.
# cut: daon_scene_booth_01 # from: daon
왔어요.
김다온이 초등학생 하나에게 고양이 안는 법을 가르쳐 주고 있다. 목소리가 처음 듣는 높이다.
# from: daon
머리 말고 엉덩이를 받쳐 줘. 그렇지. 잘하네.
아이가 가고 나자, 그녀의 목소리가 원래 높이로 돌아온다.
# cut: daon_face_neutral_01 # from: daon
할아버지 가게 자리, 곧 없어진대요. 건물 새로 짓는다고.
* [간판은요? # say: 간판은요? 그 손글씨 간판.]
    ~ raise(aff_daon, 4)
    # cut: daon_face_surprised_01 # from: daon
    …간판 얘기를 먼저 하는 사람은 처음이에요.
    # from: daon
    모르겠어요. 같이 뜯기겠죠.
* [아쉽겠어요]
    ~ raise(aff_daon, 2)
    # from: daon
    …할아버지는 아무렇지 않대요. 제주 좋대요.
* [가만히 있기 # act]
    ~ raise(aff_daon, 3)
    나는 대답하지 않고 두부의 턱을 긁는다. 두부가 눈을 감는다.
    # from: daon
    …두부가 그쪽 좋아하네요.
- # scene: end
-> blackout


// ── 정전, 그리고 세 사람 ──
= blackout
# time: 20:10
# scene: bg_festival_dark_01 # at: river, 봄밤 장터 정전
펑, 하는 소리와 함께 강변의 전구가 한꺼번에 꺼진다. 음악도 멎는다.
# fx: shake
사방에서 "어어?" 하는 소리. 발전기가 멈췄다.
어둠 속에서 휴대폰 손전등 세 개가 세 방향에서 동시에 나를 비춘다.
# from: seoha
죄송해요! 커피 머신이랑 같이 돌려서 그런가 봐요!
# from: ian
우와 정전이다 ㅋㅋㅋ 그림 같아
# from: daon
발전기 차단기 내려갔을 거예요. 빨간 스위치.
# from: guard
총각! 빨간 거 올려!
빨간 스위치를 올린다. 발전기가 콜록거리다가 다시 돈다.
# cut: bg_festival_night_01
# fx: zoom
전구가 다시 켜진다. 그리고 나는 알게 된다.
윤서하, 채이안, 김다온. 세 사람이 발전기를 가운데 두고 나를 둘러싸고 서 있다는 걸.
(아무도 먼저 말하지 않는다. 강바람 소리만 난다.)
# from: choi
ㅋㅋㅋㅋㅋ 삼파전이네
# from: halmeoni
최 사장 조용히 해요
# from: seoha
…불 비춰 드리려고 했어요 :)
# from: ian
저는 그리려고 했는데 ㅋㅋㅋ
# from: daon
저는 차단기 알려 주려고요.
* [서하 씨, 고마워요 # say: 서하 씨, 불 비춰 줘서 고마워요.]
    ~ raise(aff_seoha, 3)
    # from: seoha
    …천만에요 :)
* [이안 씨, 고마워요 # say: 이안 씨, 그림으로 남겨 줘서 고마워요 ㅎㅎ]
    ~ raise(aff_ian, 3)
    # from: ian
    ㅋㅋㅋ 벌써 다 그렸어요 이거
* [다온 씨, 고마워요 # say: 다온 씨, 알려 줘서 고마워요.]
    ~ raise(aff_daon, 3)
    # from: daon
    …네.
- 세 사람이 각자 부스로 돌아간다. 그런데 셋 다 한 번씩, 뒤를 돌아본다.
# scene: end
-> last


// ── 끝까지 ──
= last
# time: 21:40
# note: 3월 13일
장터가 끝나 간다. 천막이 하나둘 접힌다.
# ask: 오늘 밤, 끝까지 누구와 있을까?
* [서하 씨의 부스 정리를 돕는다 # act]
    ~ d5_with = 1
    ~ raise(aff_seoha, 7)
    -> with_seoha
* [이안 씨가 있는 벤치로 간다 # act]
    ~ d5_with = 2
    ~ raise(aff_ian, 7)
    -> with_ian
* [다온 씨와 두부를 병원까지 데려다준다 # act]
    ~ d5_with = 3
    ~ raise(aff_daon, 7)
    -> with_daon

= with_seoha
# scene: bg_hanriver_night_01 # at: river, 봄밤 장터 뒤
커피 머신을 수레에 싣고 주차장까지 간다. 그녀가 앞장선다. 그리고 두 번 길을 잘못 든다.
# cut: seoha_face_pout_01 # from: seoha
…주차장이 원래 이쪽 아니었어요?
# from: me
반대쪽이에요.
# cut: seoha_face_smile_01 # from: seoha
ㅎㅎ 오늘도 오른쪽이 왼쪽이었네.
수레를 밀며 강변을 걷는다. 그녀의 은팔찌가 가로등 불빛에 한 번씩 반짝인다.
# from: seoha
오늘 고마웠어요. 이상하다. 사장님한테는 이런 말 한 번도 안 했는데.
# from: seoha
기계 고쳐 주는 사람한테가 아니라, 옆에 있어 준 사람한테 하는 말이라서 그런가 봐요.
# scene: end
-> d05_route

= with_ian
# scene: bg_hanriver_night_01 # at: fest_bench, 봄밤 장터 뒤
벤치에 나란히 앉는다. 강 건너 불빛이 물 위에서 흔들린다.
# cut: ian_scene_sketch_01 # from: ian
가만히 있어 봐요. 딱 오 분만.
그녀가 연필을 움직인다. 나는 강을 본다. 그녀는 나를 본다. 아마도.
# from: ian
…다 그렸다.
스케치북에는 강을 보는 남자의 옆얼굴이, 반쯤 그려져 있다. 눈 있는 자리까지 가다가 선이 멈춰 있다.
# cut: ian_face_shy_01 # from: ian
여기까지가 제 한계예요 ㅋㅋ 오늘은.
# from: ian
근데 오늘은이라고 했으니까, 내일은 모르는 거예요.
# scene: end
-> d05_route

= with_daon
# scene: bg_hospital_ext_night_01 # at: hospital, 두부 데려다주기
이동장 안의 두부가 한 번씩 우는 소리를 낸다. 강변에서 병원까지 20분. 그녀가 이동장을 들고, 나는 새끼 고양이 케이지를 든다.
# cut: daon_face_neutral_01 # from: daon
…오늘 전구, 고마웠어요.
# from: daon
할아버지 없는 첫 장터였어요. 불이 안 켜지면 어떡하나 했어요.
병원 앞 흰 불빛 아래에서 그녀가 걸음을 멈춘다.
# cut: daon_face_smile_01 # from: daon
불 켜졌을 때, 할아버지 생각 났어요.
(웃은 건 아니다. 웃음이 되기 직전에서 멈춘 얼굴이다.)
# scene: end
-> d05_route


// ════════════════════════════════
// 밤 — 루트 결정 (03_분기_지도.md 3장)
// ════════════════════════════════
=== d05_route ===
# time: 22:40 # at: home
~ temp s = aff_seoha
~ temp i = aff_ian
~ temp d = aff_daon
// 자격: 호감 35 이상 + 핵심 플래그. 자격이 없으면 -1
{ not (s >= 35 && f_seoha_key):
    ~ s = -1
}
{ not (i >= 35 && f_ian_key):
    ~ i = -1
}
{ not (d >= 35 && f_daon_key):
    ~ d = -1
}
// 오늘 밤 끝까지 함께 있던 사람에게 +10 (자격이 있을 때만).
// 한 사람에게 마음을 정하지 못한 플레이어는 이 선택으로 루트가 정해진다. 한 사람에게 집중했다면 거의 바뀌지 않는다
{ d5_with == 1 && s >= 0:
    ~ s = s + 10
}
{ d5_with == 2 && i >= 0:
    ~ i = i + 10
}
{ d5_with == 3 && d >= 0:
    ~ d = d + 10
}
{
- s < 0 && i < 0 && d < 0:
    -> alone_d05_night
- s >= i && s >= d:
    -> seoha_d05_night
- i >= d:
    -> ian_d05_night
- else:
    -> daon_d05_night
}
