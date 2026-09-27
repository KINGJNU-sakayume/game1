// D4 — 3월 12일 목요일 (맑음)
// 서하·이안 의뢰가 동시에 온다 — 첫 양자택일(캘린더 "겹침" → 지도). 단골방 신경전. 저녁: 떡솥 또는 약속. 새벽: 첫 영상통화.
// 문법: docs/05_스크립트_문법.md

// ── D4에서 생기는 플래그 ──
VAR d4_pick = 0               // 두 시에 간 곳: 1 오후세시 / 2 301호 / 3 둘 다
VAR f_d4_both = false         // 둘 다 된다고 했다 (거절을 못 하는 병)
VAR f_d4_promise_ian = false  // 이안에게 저녁에 의자를 봐 주기로 했다
VAR f_d4_grinder = false      // 그라인더를 고쳤다
VAR f_d4_chair = false        // 의자를 고쳤다
VAR f_d4_tteok = false        // 떡솥 뚜껑을 고쳤다
VAR f_d4_slept = false        // 일찍 자서 새벽 영상통화를 못 받았다
VAR f_ian_why = false         // 이안에게 왜 뒷모습만 그리는지 물었다
VAR menu_name = 0             // 서하의 봄 메뉴 이름: 1 오후세시의 봄 / 2 딸기가 먼저 온 오후 / 3 그냥 딸기 라떼


// ════════════════════════════════
// 아침 — 동시 도착
// ════════════════════════════════
=== d04_morning ===
# day: 4
# time: 08:50
# note: 3월 12일
맑음. 8시 50분, 알림 두 개가 동시에 떴다.
# room: seoha
좋은 아침이에요.
혹시 오늘 시간 괜찮으세요?
그라인더가 원두를 못 갈아요. 윙 소리만 나고요.
오늘은 기계가 저를 싫어하는 날인가 봐요 :)
# room: ian
저 살려 주세요 ㅋㅋㅋㅋ
의자가 자꾸 내려가요
앉아서 그리다 보면 책상이 점점 높아짐
지금 턱이 책상에 닿음 🫠
* [윤서하 # open: seoha]
    -> seoha_first
* [채이안 # open: ian]
    -> ian_first

= seoha_first
~ raise(aff_seoha, 2)
# room: seoha
어, 바로 보셨네요 :)
두 시쯤 가능할까요? 점심 손님 빠지고 나서요.
# room: ian # wait: 1.5
저기요?? 👀
두 시에 올 수 있어요?? 두 시에 일어날 거라서 ㅋㅋ
-> clash

= ian_first
~ raise(aff_ian, 2)
# room: ian
헉 바로 읽었다 ㅋㅋ
두 시에 올 수 있어요?? 두 시에 일어날 거라서 ㅋㅋ
# room: seoha # wait: 1.5
두 시쯤 가능할까요? 점심 손님 빠지고 나서요.
-> clash

= clash
# plan: seoha_grinder, 4, 14:00, 그라인더 · 카페 오후세시
# plan: ian_chair, 4, 14:00, 의자 · 해든빌라 301호
# note: 3월 12일
캘린더에 두 시가 두 개 생겼다. 빨간 글씨로 "겹침".
# ask: 두 시, 어디로 갈까?
* [카페 오후세시 (그라인더) # go: cafe]
    ~ d4_pick = 1
    -> decline_ian
* [해든빌라 301호 (의자) # go: home]
    ~ d4_pick = 2
    -> decline_seoha
* [둘 다 가 보기 (무리)]
    ~ d4_pick = 3
    ~ f_d4_both = true
    -> both

= decline_ian
# room: ian
* [저녁에 봐 드릴게요 # say: 두 시엔 카페 약속이 먼저라서요ㅠ 대신 저녁에 봐 드려도 돼요?]
    ~ raise(aff_ian, 1)
    ~ f_d4_promise_ian = true
    헐 서운 ㅋㅋㅋ
    알았어요!! 저녁 약속!! 그때까지 서서 그림 ㅋㅋ
    # plan: ian_chair, 4, 19:00, 의자 · 해든빌라 301호
* [오늘은 바빠서요 # say: 오늘은 좀 바빠서요.]
    ~ raise(aff_ian, -2)
    넹…
    # unplan: ian_chair
    # note: 3월 12일
    이안 씨가 말줄임표를 쓰는 건 처음 봤다.
- # room: seoha
네, 그럼 두 시에 봬요 :)
-> d04_noon

= decline_seoha
# room: seoha
* [솔직하게 말하기 # say: 두 시엔 윗집 약속이 먼저 잡혀서요. 죄송해요.]
    ~ raise(aff_seoha, 3)
    # wait: 3
    솔직하게 말해 줘서 고마워요 :)
    오늘은 핸드드립만 팔아야겠네요. 그것도 나쁘지 않아요.
* [대충 둘러대기 # say: 오늘은 일이 좀 있어서요.]
    # wait: 3
    네, 괜찮아요.
    # note: 3월 12일
    서하 씨의 "괜찮아요"에 :)가 없었다.
- # unplan: seoha_grinder
# room: ian
대박 ㅋㅋㅋ 두 시에 기다릴게요!!
-> d04_noon

= both
# room: seoha
# from: me
두 시에 갈게요!
네, 기다릴게요 :)
# room: ian
# from: me
두 시… 반쯤 갈게요!
ㅋㅋ 오케이!! 두 시 반!!
# plan: ian_chair, 4, 14:30, 의자 · 해든빌라 301호
# note: 3월 12일
둘 다 된다고 해 버렸다. 거절을 못 하는 병은 퇴사로 낫지 않는다.
-> d04_noon


// ════════════════════════════════
// 점심 — 단골방 신경전
// ════════════════════════════════
=== d04_noon ===
# time: 12:30
# room: dangol
# from: choi
오늘 두 시에 총각 어디 감? 우리 가게 저울도 좀 봐 줘야 되는데 ㅋㅋ
{d4_pick == 1: -> cafe_side}
{d4_pick == 2: -> ian_side}
-> both_side

= cafe_side
# from: seoha
오늘 두 시엔 저희 가게 오시기로 했어요 :)
# from: ian
저는 {f_d4_promise_ian: 저녁으로 밀렸어요 ㅋㅋㅋ 서하 언니한테 졌다|오늘 차였어요 ㅋㅋㅋ 서하 언니한테 졌다}
-> rivalry

= ian_side
# from: ian
오늘 두 시엔 저희 집 오시기로 했어요!! ㅋㅋㅋ
# from: seoha
저는 다음으로 밀렸어요 :) 이안 씨 의자가 더 급하죠.
-> rivalry

= both_side
# from: seoha
두 시엔 저희 가게 오시기로 했는데요 :)
# from: ian
??? 저도 두 시 반에 오시기로 했는데요??
# from: choi
ㅋㅋㅋㅋㅋㅋ 총각 몸이 두 개임?
-> rivalry

= rivalry
# from: choi
ㅋㅋㅋㅋ 총각 인기 폭발
# from: halmeoni # big
싸우지 마요
# from: guard
총각 몸은 하나임
# from: ian
아니 싸우는 거 아니에요 ㅋㅋㅋ 저 오후세시 단골인데요??
# from: ian
오후 세시에 일어나서 오후세시 감
# from: seoha
이안 씨는 아이스 바닐라 라떼, 샷 추가요 :)
# from: daon
할아버지는 먼저 연락 온 순서대로 했어요.
# from: choi
헐 다온이 오늘도 말함
# memo: ian
오후세시 단골. 오후 세시에 일어나서 오후세시에 간다. 아이스 바닐라 라떼 샷 추가.
* [순서대로 할게요 # say: 사장님처럼 순서대로 할게요. 오늘 못 가는 곳은 내일 꼭 갈게요.]
    ~ raise(aff_daon, 4)
    # from: choi
    ㅋㅋㅋ 사장님 다 됐네
    # from: halmeoni # big
    착하다
* [몸이 하나라서요 # say: 죄송해요, 제가 몸이 하나라서요 ㅎㅎ]
    # from: ian
    ㅋㅋㅋㅋㅋ 복제 가능?
    # from: seoha
    천천히 오세요 :)
* [읽고 넘기기 # act]
- {d4_pick == 2: -> d04_ian | -> d04_cafe}


// ════════════════════════════════
// 낮 — 오후세시: 그라인더
// ════════════════════════════════
=== d04_cafe ===
# time: 14:00
# scene: bg_cafe_day_01 # at: cafe, 그라인더
{f_d4_both: 두 시 정각. 몸은 카페에 있는데 마음은 벌써 두 시 반에 가 있다.|두 시. 점심 손님이 빠진 오후세시에는 원두 냄새만 남아 있다.}
# cut: seoha_face_pout_01 # from: seoha
이거예요. 들어 보세요.
스위치를 누르자 윙— 모터 소리만 요란하고 원두는 한 알도 안 내려온다.
# from: seoha
사장님은 이 소리가 나면 기계가 삐졌다고 했어요.
{k_grinder: -> knows | -> guess}

= knows
(전원, 호퍼, 윗날. 며칠 전에 본 영상인데 순서가 또렷하다.)
# from: me
전원부터 뽑을게요.
호퍼를 들어내고 윗날을 돌려 빼자, 날 사이에 원두 조각과 기름때가 끈적하게 뭉쳐 있다.
# cut: seoha_face_surprised_01 # from: seoha
와… 이게 다 저 안에 있었어요?
솔로 털고, 다시 조립하고, 스위치.
# fx: zoom
드르륵— 원두가 고운 가루가 되어 떨어진다.
~ raise(aff_seoha, 4)
~ f_d4_grinder = true
-> after

= guess
* [아는 척 도전하기 # say: 이건 보통 옆을 세게 한 번 치면…]
    ~ raise(aff_seoha, -4)
    # fx: shake
    기계 옆구리를 손바닥으로 탁 친다. 윙 소리가 더 커진다. 원두통이 달그락거린다.
    # cut: seoha_face_pout_01 # from: seoha
    …사장님은 그렇게 안 했는데요.
    * * [모르겠어요 # say: 죄송해요. 사실 그라인더는 처음 봐요.]
        {
        - not f_seoha_key:
            ~ raise(aff_seoha, 6)
        - else:
            ~ raise(aff_seoha, 3)
        }
        ~ f_seoha_key = true
        # cut: seoha_face_smile_01 # from: seoha
        또 처음이에요? ㅎㅎ 알았어요, 같이 봐요.
    - - -> together
* [솔직하게 말하기 # say: 솔직히 그라인더는 처음이에요. 같이 봐도 될까요?]
    { f_seoha_key:
        ~ raise(aff_seoha, 4)
        # cut: seoha_face_smile_01 # from: seoha
        이번에도 처음이에요? ㅎㅎ 좋아요. 같이 봐요.
    - else:
        ~ raise(aff_seoha, 8)
        # cut: seoha_face_surprised_01 # from: seoha
        …그렇게 말해 주니까 오히려 좋네요. 같이 봐요.
    }
    ~ f_seoha_key = true
    -> together

= together
그녀가 휴대폰으로 모델명을 검색한다. 튜브 영상 속 사람이 윗날을 돌려서 빼고 있다.
# from: seoha
이거 돌리면 빠지는 거였어요? 삼 년 동안 몰랐어요.
날 사이에 원두 조각이 끼어 있다. 둘이 머리를 맞대고 솔로 턴다. 그녀 머리카락에서 커피 냄새가 난다.
# fx: zoom
드르륵— 원두가 떨어진다. 둘이 동시에 "오" 한다.
~ f_d4_grinder = true
-> after

= after
{f_d4_both: -> rushed}
{d03_cafe: -> menu}
# from: seoha
그런데 원래는 무슨 일 하셨어요?
* [광고 회사 다녔어요 # say: 광고 회사 다니다가 얼마 전에 그만뒀어요.]
    ~ raise(aff_seoha, 2)
    # from: seoha
    어쩐지. 말을 잘하시더라.
    # from: me
    말만 잘했죠. 못 하는 것도 할 수 있다고 하는 게 일이었어요.
    # cut: seoha_face_surprised_01 # from: seoha
    …그래서 그렇게 솔직한 거예요? 그만두고 나서?
* [그냥 쉬는 중이에요]
    # from: seoha
    쉬는 것도 일이죠.
- -> menu

= menu
# cut: seoha_face_smile_01 # from: seoha
그럼 말 잘하는 사람한테 부탁 하나만 할게요.
# from: seoha
봄 메뉴로 딸기 라떼를 하려는데요, 그냥 딸기 라떼라고 하기엔 좀 아까워서요. 이름 좀 지어 줄래요?
* [오후세시의 봄]
    ~ menu_name = 1
    ~ raise(aff_seoha, 2)
    # from: seoha
    …좋다. 가게 이름이 들어가니까 우리 거 같아요.
* [딸기가 먼저 온 오후]
    ~ menu_name = 2
    ~ raise(aff_seoha, 2)
    # from: seoha
    시 같아요 ㅎㅎ 조금 길지만, 칠판에 쓰면 예쁘겠다.
* [그냥 딸기 라떼]
    ~ menu_name = 3
    ~ raise(aff_seoha, 1)
    # from: seoha
    ㅎㅎ 정직하네요. 그것도 좋아요. 그런 사람이 지은 이름이니까.
- # from: seoha
오늘 커피값은 받지 마세요. 아니, 제가 안 받을게요.
# scene: end
# done: seoha_grinder
# memo: seoha
봄 메뉴는 딸기 라떼. 이름을 지어 달라고 했다.
# time: 17:05
# post: seoha_p2 # from: seoha # photo: seoha_cg_strawberry_01
봄 메뉴 준비 중 🍓 이름은 아직 비밀
# comment: seoha_p2 # from: ian
언니 저 1번으로 마실래요!!
-> d04_after_repair

= rushed
그녀가 말을 꺼내려다 멈춘다. 내가 세 번째로 시계를 봤기 때문이다.
# from: seoha
…다음 약속 있으시구나. 가 보세요 :)
(:)가 붙어 있는데, 웃는 것 같지 않다.)
~ raise(aff_seoha, -2)
# scene: end
# done: seoha_grinder
-> d04_ian


// ════════════════════════════════
// 낮 — 301호: 의자
// ════════════════════════════════
=== d04_ian ===
{f_d4_both: -> late_arrival}
# time: 14:00
# scene: bg_ian_room_day_01 # at: home, 301호 의자
3층. 문을 열자 이안이 서서 그림을 그리고 있다. 의자는 바닥에 닿을 만큼 내려가 있다.
-> chair

= late_arrival
# time: 14:42
# scene: bg_ian_room_day_01 # at: home, 301호 의자
2시 42분. 두 시 반이라고 했다. 문을 열자 이안이 서서 그림을 그리고 있다.
# cut: ian_face_pout_01 # from: ian
ㅋㅋ 늦었다. 오후세시 들렀다 왔죠? 커피 냄새 나요.
~ raise(aff_ian, -2)
-> chair

= chair
# cut: ian_face_smile_01 # from: ian
보세요. 앉으면 스르르— 엘리베이터예요 ㅋㅋㅋ
{k_chair: -> knows | -> guess}

= knows
(오는 길에 대성철물에 들러 PVC 파이프를 잘라 왔다. 5천 원.)
# pin: hardware
의자를 높이 올리고, 실린더 둘레에 반으로 가른 파이프를 끼우고, 클램프로 꽉.
# cut: ian_face_surprised_01 # from: ian
헐. 안 내려가. 진짜 안 내려가!!
# from: ian
천재?? 이거 진짜 5천 원이에요??
~ raise(aff_ian, 3)
~ f_d4_chair = true
-> sketch

= guess
* [아는 척 도전하기 # say: 이건 보통 레버를 끝까지 당기면…]
    ~ raise(aff_ian, -2)
    # fx: shake
    레버를 당기자 의자가 쑥 솟구친다. 이안이 비명을 지르며 웃는다.
    # cut: ian_face_smile_01 # from: ian
    ㅋㅋㅋㅋㅋ 이번엔 너무 높아!! 발이 안 닿아요!!
    * * [사실 몰라요 # say: …사실 몰라요.]
        ~ raise(aff_ian, 3)
        # from: ian
        ㅋㅋㅋ 알아요. 같이 찾아요!
    - - -> together
* [같이 찾아봐요 # say: 솔직히 의자는 모르겠어요. 같이 찾아봐요.]
    ~ raise(aff_ian, 4)
    # from: ian
    오 좋아요! 이번에도 제가 검색 담당!
    -> together

= together
그녀가 찾은 영상의 제목은 "의자가 자꾸 내려갈 때 — 5천 원으로 고치기".
{ f_d4_both:
    시간이 없다. 파이프 대신 테이프를 칭칭 감는다.
    # fx: zoom
    일단은 안 내려간다. 일단은.
- else:
    # pin: hardware
    둘이 후드티 차림으로 대성철물까지 걸어가 파이프를 잘라 온다. 철물점 할아버지가 "둘이 뭐 만들어?" 하고 묻는다.
    # fx: zoom
    클램프를 조이자 의자가 제자리에 선다.
    ~ f_d4_chair = true
}
-> sketch

= sketch
# cut: ian_scene_monitor_01 # from: ian
아 맞다. 고치는 동안 그렸어요. 약속한 거.
# cut: ian_cg_back_sketch_01
태블릿 화면 속에, 의자 앞에 쪼그려 앉은 남자의 등이 있다. 회색 후드 집업. 손목의 검은 시계줄.
(내 등이 나보다 멋있다.)
# cut: ian_face_shy_01 # from: ian
어때요? 이번엔 연습 아니고 진짜.
* [시계줄까지 그렸네요 # say: 시계줄까지 그렸네요. 제 등이 저보다 멋있어요.]
    ~ raise(aff_ian, 4)
    ~ f_ian_eye = true
    # from: ian
    ㅋㅋㅋ 시계줄 보라고 그린 건데 알아봤다!
* [잘 그렸네요]
    ~ raise(aff_ian, -2)
    # from: ian
    ㅋㅋ 감사해요.
* [왜 뒷모습만 그려요? # say: 근데 왜 뒷모습만 그려요? 벽에 있는 그림들도 다 그렇던데.]
    ~ raise(aff_ian, 3)
    ~ f_ian_why = true
    # cut: ian_face_neutral_01 # from: ian
    …
    # from: ian
    앞모습은 어려워요. 사람 얼굴을 그리면, 그 사람이 날 어떻게 보는지까지 그려 버릴 것 같아서.
    # cut: ian_face_smile_01 # from: ian
    아 뭐래 ㅋㅋㅋ 그냥 얼굴을 못 그려요!
- # from: ian
저 공모전 하나 낼까 고민 중이에요. 망원 골목 작은 전시.
# from: ian
근데 낼 그림이 없어요. 다 뒷모습이라서 ㅋㅋ
# scene: end
{ f_d4_chair:
    # done: ian_chair
}
# memo: ian
망원 골목 전시 공모에 낼까 고민 중. 그림 속 사람들은 늘 뒷모습.
# time: 17:10
# post: ian_p3 # from: ian # photo: ian_cg_back_sketch_01
오늘의 모델: 아랫집 수리 담당 (허락 받음)
# ask: 이안 그림일기 게시물
* [좋아요 # like: ian_p3]
    ~ raise(aff_ian, 1)
* [댓글: 허락한 적 없는데요 # comment: ian_p3 # say: 허락한 적 없는데요 ㅋㅋ]
    ~ raise(aff_ian, 2)
    # comment: ian_p3 # from: ian
    지금 했잖아요 ㅋㅋㅋ
* [넘기기]
- -> d04_after_repair


=== d04_after_repair ===
{d4_pick == 1: -> ian_side}
{d4_pick == 2: -> seoha_side}
-> d04_evening

= ian_side
# time: 17:30
# post: ian_p3b # from: ian # photo: ian_cg_chair_01
오늘의 작업 환경: 의자 없음 {f_d4_promise_ian: (저녁에 구조대 옴)|(구조대 안 옴)}
-> d04_evening

= seoha_side
# time: 17:40
# room: seoha
오늘 핸드드립만 팔았는데요, 의외로 괜찮았어요.
천천히 내려 주는 커피가 좋다는 손님이 많았어요. 기계 탓만 할 게 아니었나 봐요 :)
-> d04_evening


// ════════════════════════════════
// 저녁
// ════════════════════════════════
=== d04_evening ===
# time: 18:30
# ask: 저녁엔 어디로 갈까?
* {f_d4_promise_ian} [해든빌라 301호 (약속한 의자) # go: home]
    -> ian_evening
* [박씨네 떡집 (떡솥 뚜껑) # go: market]
    -> tteok
* [집에서 쉬기]
    -> rest

= ian_evening
# time: 19:00
# scene: bg_ian_room_night_01 # at: home, 301호 의자 (약속)
7시 정각에 문을 두드린다. 이안이 서 있다. 진짜로 서서 그리고 있었다.
# cut: ian_face_surprised_01 # from: ian
헐 진짜 왔다 ㅋㅋㅋ 약속 지키는 사람이다!!
~ raise(aff_ian, 3)
{k_chair: 대성철물에서 잘라 온 파이프를 끼우고 클램프를 조인다. 의자가 제자리에 선다.|둘이 튜브를 보며 파이프를 끼운다. 한 번 실패하고, 두 번째에 선다.}
~ f_d4_chair = true
# done: ian_chair
# cut: ian_face_smile_01 # from: ian
앉아도 안 내려가!! 오늘부터 이 의자 이름은 "201호"예요.
# from: ian
…아 이상한 뜻 아니고 ㅋㅋㅋㅋ
# scene: end
-> d04_night

= tteok
# time: 18:40
# scene: bg_market_evening_01 # at: market, 떡솥 뚜껑
저녁 시장. 박씨네 떡집 안쪽에서 김이 자욱하게 올라온다.
# from: halmeoni
왔어요? 이거야, 이거. 뚜껑이 삐딱해.
커다란 떡솥 뚜껑이 한쪽으로 기울어 떠 있다. 경첩 가운데 핀이 반쯤 빠져 있다.
{k_hinge || read("떡집 (떡솥 뚜껑)") || f_book_read: -> knows | -> guess}

= knows
(경첩 핀. 못으로 대충 하면 또 빠짐. 핀은 대성철물 3번 서랍. 사장님 수첩과 오반장님의 말이 겹친다.)
대성철물 3번 서랍에 정말로 맞는 핀이 있다. 끼우고, 끝을 망치로 톡톡.
# pin: hardware
# fx: zoom
뚜껑이 소리 없이 내려앉는다. 딱 맞게.
# from: halmeoni
…사장님이랑 똑같이 하네.
할머니가 앞치마에 손을 닦으며 한참 뚜껑을 쓰다듬는다.
~ f_d4_tteok = true
-> rice_cake

= guess
* [못으로 끼우기 # say: 일단 이거라도 끼워 둘게요.]
    # fx: shake
    못을 끼우자 뚜껑이 닫힌다. 할머니가 박수를 치다가 멈춘다. 뚜껑을 여는 순간 못이 튕겨 나간다.
    # from: halmeoni
    아이고. 사장님도 옛날에 못 끼웠다가 혼났어요, 내한테.
    ~ raise(aff_daon, -1)
    -> rice_cake
* [모르겠다고 하기 # say: 솔직히 처음 보는 거예요. 사장님은 어떻게 하셨어요?]
    # from: halmeoni
    사장님은… 철물점 가서 무슨 서랍 어쩌고 했는데. 3번이었나.
    대성철물 할아버지가 3번 서랍을 열어 준다. 맞는 핀이 한 봉지 들어 있다.
    # pin: hardware
    핀을 끼우고, 한참을 헤맨 끝에 끝을 톡톡 쳐서 벌린다.
    # fx: zoom
    뚜껑이 제자리에 앉는다.
    ~ f_d4_tteok = true
    -> rice_cake

= rice_cake
# from: halmeoni
자, 가래떡. 따뜻할 때 먹어요.
할머니가 검은 봉지를 내민다. 봉지가 묵직하다.
* [감사히 받기]
    {read("떡집 (떡솥 뚜껑)") || f_book_read: (할머니가 떡 주시면 받을 것. 안 받으면 서운해하심. 수첩에 그렇게 적혀 있었다.)}
    # from: halmeoni
    그래그래. 사장님도 맨날 받아 갔어요.
* [사양하기 # say: 아니에요, 괜찮아요.]
    # from: halmeoni
    …사장님은 받았는데.
    할머니가 봉지를 도로 품에 안는다. 서운한 얼굴이다. 결국 두 줄을 주머니에 찔러 주신다.
- # scene: end
{ f_d4_tteok:
    # done: tteok
}
# room: dangol # time: 20:05
# from: halmeoni # big
떡솥 고쳤어요
# from: choi
오 ㅋㅋㅋ 총각 이제 사장님이네
{f_d4_tteok: -> daon_sees | -> d04_night}

= daon_sees
# from: daon # time: 20:20
할아버지 수첩 보셨네요.
~ raise(aff_daon, 5)
# from: halmeoni # big
다온이 최고
-> d04_night

= rest
# time: 19:00 # at: home
# note: 3월 12일
오늘은 쉬었다. 쉬는 것도 일이라고 누가 그랬다.
{f_d4_promise_ian: -> broken | -> d04_night}

= broken
# time: 19:40
# room: ian
저녁 약속…
# wait: 2
ㅋㅋ 아니에요 바쁘구나!! 괜찮아요
~ raise(aff_ian, -4)
# note: 3월 12일
저녁에 봐 주겠다고 했다. 이안 씨는 "괜찮아요"에 ㅋㅋ를 붙였다. 괜찮지 않을 때 붙이는 ㅋㅋ 같다.
-> d04_night


// ════════════════════════════════
// 밤
// ════════════════════════════════
=== d04_night ===
# time: 22:00 # at: home
# note: 3월 12일
{f_d4_both: 둘 다 된다고 했다가 둘 다 반만 고쳤다. 거절도 기술이다.|하루에 하나씩. 오늘은 그게 맞았다.}
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    -> tube
* [누군가에게 먼저 연락하기 # act]
    -> contact
* [일찍 자기 # act]
    ~ f_d4_slept = true
    # note: 3월 12일
    폰을 엎어 두고 잤다.
    -> video_call

= tube
# ask: 오늘 밤 볼 영상
* [줄 전구가 안 켜질 때 — 플러그 속 퓨즈 # watch: lights]
    -> video_lights ->
    # note: 3월 12일
    내일 한강에서 장터가 열린다고 했다. 전구 영상이 추천에 뜬 건 우연일까.
* [썸 탈 때 답장은 몇 분 뒤에? # watch: timing]
    -> video_timing ->
* {not k_hinge} [뚜껑이 자꾸 뜰 때 — 경첩 핀 # watch: hinge]
    -> video_hinge ->
* {not k_grinder} [그라인더가 윙 소리만 날 때 # watch: grinder]
    -> video_grinder ->
* {not k_chair} [의자가 자꾸 내려갈 때 # watch: chair]
    -> video_chair ->
- -> video_call

= contact
# ask: 누구에게 연락할까?
* [윤서하에게 메시지 # text: seoha]
    # time: 22:10
    # room: seoha
    # from: me
    {d4_pick == 2: 오늘 못 가서 죄송했어요. 핸드드립은 잘 팔렸어요?|오늘 그라인더는 얌전해요?}
    ~ raise(aff_seoha, 3)
    # wait: 2
    {d4_pick == 2: 네 ㅎㅎ 오늘 알았어요. 저는 기계 없이도 커피를 만들 줄 아는 사람이었어요.|네, 오늘은 삐지지 않았어요 :)}
    이렇게 밤에 오는 메시지가, 요즘 하루 중에 제일 좋아요.
    # typing: 2
    …아 이건 지울까 하다가 그냥 보내요 :)
* [윤서하에게 전화 # dial: seoha]
    # time: 22:10
    # call: seoha # outgoing
    여보세요? 아, 마감 청소하고 있었어요.
    # from: me
    오늘 고생하셨다고요.
    ~ raise(aff_seoha, 1)
    …전화로 들으니까 이상하게 쑥스럽네요. 메시지로 해 주세요, 그건 몇 번이고 다시 볼 수 있으니까 :)
    # call: end
* [채이안에게 메시지 # text: ian]
    # time: 22:10
    # room: ian
    # from: me
    {f_d4_chair: 의자는 잘 버티고 있어요?|의자 없이 그리는 거 힘들죠?}
    ~ raise(aff_ian, 3)
    {f_d4_chair: 넹!! 201호가 절 받쳐 주고 있어요 ㅋㅋㅋ|ㅋㅋㅋ 다리 아파요 🥲}
    # typing: 0.8
    이따 늦게까지 깨어 있어요?
* [채이안에게 전화 # dial: ian]
    # time: 22:10
    # call: ian # outgoing
    헐 ㅋㅋ 또 전화! 요즘 제 통화 기록 1등이에요.
    ~ raise(aff_ian, 3)
    # from: me
    그림은 잘 돼요?
    그림은 잘 안 되는데 기분은 좋아요. 이상하죠? ㅋㅋ
    # call: end
* [김다온에게 메시지 # text: daon]
    # time: 22:10
    # room: daon
    # from: me
    {f_d4_tteok: 떡솥 고쳤어요. 수첩 덕분이에요.|오늘 순서대로 못 했어요. 내일은 꼭 할게요.}
    # wait: 10
    {f_d4_tteok: 할머니가 좋아하셨겠네요.|네.}
    ~ raise(aff_daon, 1)
* [김다온에게 전화 # dial: daon]
    # time: 22:10
    # call: daon # outgoing
    오늘 오프예요. 무슨 일이에요.
    # from: me
    {f_d4_tteok: 떡솥 고쳤다고 말하고 싶어서요.|그냥… 오늘 어땠나 해서요.}
    ~ raise(aff_daon, 3)
    {f_d4_tteok: 알아요. 할머니가 단톡방에 글씨를 크게 쓰셨어요.|…오늘은 괜찮았어요.}
    # narr
    (그러고 나서 둘 다 말이 없다. 그런데 그녀가 먼저 끊지 않는다.)
    …내일 장터 와요? 병원 부스 있어요.
    # call: end
- -> video_call

= video_call
{aff_ian >= 12: -> ian_call | -> close}

= ian_call
{f_d4_slept: -> missed}
# time: 00:40 # wait: 1.5
# call: ian # video
* [받기 # answer]
    ~ f_ian_key = true
    ~ raise(aff_ian, 3)
    # cut: ian_call_night_01
    앗 받았다 ㅋㅋ 안 자고 있었죠?
    # narr
    (화면 속 이안 씨는 베개를 끌어안고 누워 있다. 안경은 벗었다. 조명이 하나뿐이다.)
    그냥… 자기 전에 얼굴 한번 보고 잘 자라고 하고 싶어서요 ㅋㅋ
    …이상한가? 이상하죠? ㅋㅋㅋ
    * * [안 이상해요]
        ~ raise(aff_ian, 2)
        …다행이다.
    * * [조금 이상해요 ㅎㅎ]
        ~ raise(aff_ian, 1)
        ㅋㅋㅋ 솔직해서 좋다
    - - 아까 공모전 얘기요. 낼 그림이 없다고 했잖아요.
    근데 사실 그리고 싶은 건 있어요. 못 그리는 거지.
    * * [뒷모습도 좋던데요 # say: 뒷모습 그림도 좋아요. 오늘 그린 제 등, 저보다 멋있었어요.]
        ~ raise(aff_ian, 3)
        ㅋㅋㅋ 그건 모델이 좋아서… 아 아니다 취소
    * * [그리고 싶은 게 뭔데요? # say: 그리고 싶은 게 뭔데요?]
        ~ raise(aff_ian, 3)
        …
        비밀 ㅋㅋ 그려지면 보여 줄게요.
    * * [졸려요 # say: 저 사실 좀 졸려요 ㅎㅎ]
        ~ raise(aff_ian, -2)
        앗 ㅋㅋ 미안해요!! 얼른 자요
    - - 잘 자요, 아랫집.
    # call: end
    # memo: ian
    밤 12시가 넘으면 전화를 건다. 얼굴 보고 잘 자라고 하는 사람.
* [거절 # decline]
    ~ raise(aff_ian, -3)
    # room: ian
    앗 자는구나 🥲
    미안해요 늦게 ㅋㅋ 잘 자요
- -> close

= missed
# time: 00:40
# missed: ian # video
# note: 3월 12일
자는 동안 부재중 영상통화가 한 통 와 있었다. 00:40, 채이안.
-> close

= close
# dayend
-> d05_morning
