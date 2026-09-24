// D1 — 3월 9일 월요일
// 새 번호 개통 첫날. 단골방 의뢰 폭탄, 윤서하 첫 만남, 단골방 합류.
// 문법: docs/05_스크립트_문법.md

// ── D1에서 생기는 플래그 ──
VAR f_seoha_key = false       // 서하에게 솔직했다 (D1 또는 D4). 서하 루트 핵심 플래그
VAR f_d1_pretended = false    // 아침에 사장님인 척 답했다
VAR f_d1_lied = false         // 카페에서 "사장님 조카"라고 거짓말했다 → D3 다온 대면에서 들통
VAR f_d1_bluffed = false      // 수리에서 아는 척했다
VAR f_d1_left_dangol = false  // 단골방을 나갔다가 박 할머니에게 다시 초대됐다


// ════════════════════════════════
// 아침
// ════════════════════════════════
=== d01_morning ===
# day: 1
# time: 07:52
# room: dangol
# from: choi
사장님~ 정육점 냉장고 문 고무 또 떨어졌어요 ㅠㅠ
# from: choi
이번엔 테이프로도 안 됨
# from: halmeoni # big
사장님 계세요
# from: guard # time: 07:58
사장님 해든빌라 보일러에서 또 소리 남
# from: guard
쇠 긁는 소리
# from: halmeoni # time: 08:01
떡솥 뚜껑이 안 닫혀요
# from: choi # time: 08:03
사장님 요즘 왜 답이 없으셔 ㅋㅋ 설마 여행?
# note: 3월 9일
개통하고 한 시간. 들어간 적도 없는 단톡방에서 알림이 스물세 개 왔다.
# note: 3월 9일
방 이름은 "만물수선 단골방". 나는 만물은커녕 아무것도 수선할 줄 모른다.
* [저기요, 저 사장님 아니에요 # draft: 누구세요? # keep]
    # from: choi # typing: 1.5
    ㅋㅋㅋㅋ 사장님 장난 치지 마셔
    # from: guard
    사장님 번호 맞는데
    # from: halmeoni # big
    사장님 사랑해요
    -> d01_seoha_msg
* [읽고 넘기기 # act]
    # from: choi # wait: 2
    읽었네 ㅋㅋ 사장님 읽씹 하시네
    # from: halmeoni # big
    기다릴게요
    -> d01_seoha_msg


=== d01_seoha_msg ===
# time: 08:14
# room: seoha
안녕하세요, 카페 오후세시입니다.
사장님 이번 주 방문 가능하실까요?
# typing: 2
에스프레소 머신 스팀이 하나도 안 나와서요. 오늘 오후면 더 좋고요.
-> ask

= ask
* [사실 저 사장님이 아니라서요 # draft: 네 물론이죠! 몇 시쯤 갈까요?]
    ~ raise(aff_seoha, 5)
    # wait: 4
    아…
    번호가 바뀐 거군요. 아침부터 죄송해요.
    -> offer
* [네, 오늘 오후에 갈게요]
    ~ f_d1_pretended = true
    다행이다.
    -> time
* [나중에 답하기 # act]
    # time: 10:40 # wait: 2
    혹시 바쁘시면 다음 주도 괜찮아요 :)
    -> ask

= offer
# typing: 2.5
그래도 혹시… 기계 좀 보실 줄 아세요?
오늘 오후 장사를 이거 없이 하려니 막막해서요.
* [잘은 모르지만 볼게요 # say: 솔직히 잘은 몰라요. 그래도 한번 볼게요.]
    ~ raise(aff_seoha, 4)
    솔직하게 말해줘서 오히려 좋네요 :)
* [그 정도는 금방이죠 # draft: 저 기계는 하나도 몰라요]
    ~ f_d1_bluffed = true
    와, 다행이다.
- -> time

= time
# typing: 1.5
오후 두 시쯤 괜찮으세요? 점심 손님 빠지고 나서요.
* [두 시 좋아요]
    네, 그럼 두 시에 봬요 :)
* [지금 바로 갈 수도 있어요]
    ~ raise(aff_seoha, 2)
    아 지금은 손님이 좀 있어서요 ㅎㅎ
    두 시에 봬요 :)
- # plan: seoha_machine, 1, 14:00, 에스프레소 머신 · 카페 오후세시
# todo: machine, 에스프레소 머신 스팀 노즐 고치는 법 찾아보기
-> d01_day


// ════════════════════════════════
// 낮
// ════════════════════════════════
=== d01_day ===
# time: 11:20
# room: dangol
# from: guard
사장님 보일러는 내일 와도 됨
# from: choi
사장님 냉장고는 오늘이요 ㅠ 고기 상함
# note: 3월 9일
유튜브에 "스팀 안 나옴"을 쳤다. 영상마다 기계 모양이 다 다르다.
# time: 13:41
# room: seoha
오시는 길 설명드릴게요!
망원시장 쪽 편의점에서 왼쪽으로 꺾으시면…
# typing: 3
아 아니다 오른쪽이요. 오른쪽.
빨간 벽돌 건물 1층이에요 :)
# note: 3월 9일
카페 사장님은 길을 설명하다 방향을 한 번 바꿨다. 오른쪽이 맞기를.
-> d01_scene


// ── 대면: 카페 오후세시 ──
=== d01_scene ===
# time: 14:02
# scene: bg_mangwon_alley_day_01
편의점에서 오른쪽. 빨간 벽돌. 1층 유리문 위에 작게 "오후세시".
(두 시 이 분. 첫 출근 날처럼 긴장된다.)
# cut: bg_cafe_day_01
문을 열자 커피 냄새가 먼저 온다. 손님은 창가에 한 명뿐이다.
{f_d1_pretended: -> reveal | -> greet}

= reveal
# cut: seoha_face_surprised_01 # from: seoha
어서 오세요, 사장님… 어?
# from: seoha
사장님 아니시죠?
(김용수 사장님은 일흔두 살이라고 했다. 나는 스물여덟이다.)
* [번호만 물려받았어요 # say: 죄송해요. 사실 번호만 새로 받은 사람이에요.]
    ~ raise(aff_seoha, 3)
    # cut: seoha_face_pout_01 # from: seoha
    …아침에 말하지 그랬어요.
    # from: seoha
    그래도 와 줬으니까. 들어와요.
* [사장님 조카예요 # say: 사장님이… 삼촌이에요. 조카요.]
    ~ raise(aff_seoha, -5)
    ~ f_d1_lied = true
    # from: seoha
    아 그래요? 사장님이 조카 얘기는 한 번도 안 하셨는데.
    (들킬 거짓말을 해 버렸다.)
- -> repair

= greet
# cut: seoha_face_smile_01 # from: seoha
오셨어요? 금방 찾으셨네요.
# from: seoha
오른쪽 맞았죠? 다행이다.
-> repair

= repair
# cut: seoha_scene_machine_01 # from: seoha
이거예요. 스팀이 하나도 안 나와요.
은색 기계 옆에 가늘고 긴 관이 붙어 있다. 끝이 하얗게 말라붙어 있다.
(유튜브에서 본 거랑 모양이 다르다.)
# from: seoha
사장님은 늘 뭘 뚝딱 하시던데…
* [아는 척 도전하기 # say: 이런 건 보통, 여기를 이렇게…]
    ~ raise(aff_seoha, -5)
    ~ f_d1_bluffed = true
    # fx: shake
    레버를 끝까지 젖히자 푸슉— 뜨거운 김이 엉뚱한 쪽으로 터진다.
    # from: seoha
    괜찮아요?! 찬물! 찬물에 손 대요, 빨리.
    싱크대에 손을 대고 서 있다. 허세의 대가는 찬물이다.
    * * [사실 처음 봐요 # say: …죄송해요. 사실 이 기계 처음 봐요.]
        ~ raise(aff_seoha, 6)
        ~ f_seoha_key = true
        # fx: zoom # cut: seoha_face_smile_01 # from: seoha
        풉.
        # from: seoha
        그걸 이제 말해요? 같이 봐요. 설명서 어디 있을 거예요.
    * * [원래 한 번 뿜어 줘야 해요 # say: 원래 이렇게 한 번 뿜어 줘야 뚫려요.]
        ~ raise(aff_seoha, -3)
        # from: seoha
        …그래요?
        (그렇지 않다.)
        # from: seoha
        일단 설명서부터 찾아볼게요.
    - - -> fix
* [솔직하게 모른다고 하기 # say: 솔직히 이 기계는 처음 봐요. 같이 설명서 찾아봐도 될까요?]
    ~ raise(aff_seoha, 10)
    ~ f_seoha_key = true
    # fx: zoom # cut: seoha_face_surprised_01 # from: seoha
    …그런 말 하는 사람 처음 봐요.
    # from: seoha
    잠깐만요. 설명서 어디 있을 거예요.
    -> fix

= fix
# cut: bg_cafe_day_01
카운터 밑 서랍에서 이탈리아어와 영어가 섞인 설명서가 나온다. 제일 친절한 건 그림이다.
# from: seoha
여기요. 우유 찌꺼기가 굳으면 막힌대요.
# cut: mc_cg_needle_01
그녀가 내민 바늘로 노즐 구멍을 살살 쑤신다. 한 번, 두 번.
# fx: zoom
치이익— 이번에는 김이 곧게 나온다.
# cut: seoha_face_smile_01 # from: seoha
됐다! 와, 진짜 됐어요.
(고친 건 바늘이었지만, 기분은 내가 고친 것 같다.)
# gallery: seoha_cg_machine_fixed_01 # done: machine
기념으로 김을 뿜는 기계를 한 장 찍는다.
# from: seoha
얼마 드리면 돼요?
* [바늘이 다 했어요 # say: 괜찮아요. 바늘이 다 했어요.]
    ~ raise(aff_seoha, 3)
    # from: seoha
    그럼 커피라도. 이건 거절하면 안 돼요.
* [커피 한 잔이면 돼요 # say: 수리비는 커피 한 잔으로 할게요.]
    # from: seoha
    그 정도야 얼마든지요.
- # cut: seoha_scene_latte_01
방금 살아난 스팀으로 우유를 데운다. 그녀가 잔 위에서 손목을 몇 번 흔들자 하트가 생긴다.
왼쪽 손목에서 얇은 은팔찌가 반짝인다.
{f_d1_lied: -> nephew | -> number}

= nephew
# from: seoha
삼촌분은 요즘 어디 계세요? 갑자기 연락이 안 되셔서 다들 걱정했어요.
* [제주에 계세요 # say: 제주에… 계신 걸로 알아요.]
    (거짓말은 하나를 하면 둘이 필요하다.)
- -> number

= number
# from: seoha
그 번호, 그대로 쓰실 거예요?
* [모르겠어요 # say: 모르겠어요. 다들 사장님을 찾아서.]
    # from: seoha
    그렇죠. 이 동네 사람들한테 그 번호는 좀 특별하거든요.
* [일단은요]
    # from: seoha
    다행이다.
- # from: seoha
그럼 기계가 또 말썽이면, 이 번호로 연락할게요.
# scene: end
-> d01_evening


// ════════════════════════════════
// 저녁
// ════════════════════════════════
=== d01_evening ===
# time: 18:40
# room: dangol
# from: halmeoni # big
사장님 아니래요
# from: choi
??? 할머니 무슨 소리야
# from: halmeoni
오후세시에 젊은 총각이 와서 기계 고치고 갔어요. 떡집에서 다 보여요
# from: choi
ㅋㅋㅋㅋㅋ 그럼 누구야
# from: seoha # time: 18:44
사장님 아니세요. 번호를 새로 받으신 분이에요.
# from: seoha
그래도 스팀 고쳐 주셨어요 :)
# from: ian # time: 18:45
헐 ㅋㅋㅋㅋ 그럼 여태 사장님한테 보낸 거 이분이 다 본 거예요??
# from: guard
보일러는 누가 고치나
# from: guard
다온이는 알고 있나 몰라
* [인사하기 # say: 안녕하세요. 번호를 새로 받은 사람이에요. 사장님은 아니지만… 반갑습니다.]
    # from: choi # typing: 1
    ㅋㅋ 반가워요 총각
    # from: choi
    그럼 냉장고는?
    * * [냉장고는 못 고쳐요 # say: 냉장고는… 제가 못 고칠 것 같아요. 죄송해요.]
        # from: choi
        ㅋㅋㅋ 솔직하네 알았어요
    * * [한번 알아볼게요]
        # from: choi
        오 믿어요 총각
        # todo: choi_fridge, 정육점 냉장고 문 고무
    - - # from: halmeoni # big
    환영해요
* [조용히 방 나가기 # act]
    ~ f_d1_left_dangol = true
    # from: system # wait: 2
    {player_name}님이 나갔습니다.
    # from: ian # wait: 1.5
    ㅋㅋㅋㅋㅋ 나갔다
    # from: system # wait: 3
    박 할머니님이 {player_name}님을 초대했습니다.
    # from: halmeoni # big
    나가지 마요
    # from: choi
    ㅋㅋㅋㅋㅋㅋㅋ
- -> d01_seoha_night


=== d01_seoha_night ===
# time: 21:18
# room: seoha
오늘 마감하고 이제 폰 봐요.
스팀 살아나서 오후 장사 무사히 했어요. 라떼만 스무 잔 넘게 나갔어요.
# photo: seoha_cg_latteart_01
오늘 마지막 잔
{f_seoha_key: 그리고 처음 봤다고 말해 준 거요. 사실 좀 웃겼어요. 좋은 쪽으로요 :)|사장님 대신 와 주셔서 감사해요 :)}
{f_d1_lied: 삼촌께도 안부 전해 주세요.}
* [오늘 즐거웠어요 # draft: 다음에 커피 마시러 가도 돼요? # keep]
    ~ raise(aff_seoha, 3)
    저도요 :)
* [스팀 또 막히면 연락 주세요]
    ~ raise(aff_seoha, 3)
    네, 이 번호로 :)
* [나중에 답하기 # act]
    ~ raise(aff_seoha, -2)
- -> d01_night


// ════════════════════════════════
// 밤
// ════════════════════════════════
=== d01_night ===
# time: 22:05
# note: 3월 9일
{f_d1_left_dangol: 단톡방에서 나가려다 할머니에게 붙잡혔다. 망원동은 번호 하나도 쉽게 놓아주지 않는다.|단톡방에 인사를 했다. 냉장고와 보일러와 떡솥이 줄을 서 있다.}
* [유튜브로 수리 공부하기 # act]
    ~ study()
    # note: 공부 기록
    냉장고 문 고무 교체 영상을 세 개 봤다. 최 사장님 냉장고가 자꾸 떠오른다.
* [카페 사장님께 먼저 연락하기 # act]
    -> contact
* [일찍 자기 # act]
    # note: 3월 9일
    알림을 끄고 누웠다. 꺼진 화면 위로 계속 무언가가 뜨는 것 같다.
- -> close

= contact
# time: 22:20
# room: seoha
# from: me
스팀은 괜찮죠?
~ raise(aff_seoha, 3)
# typing: 2.5
네 ㅎㅎ 방금 청소까지 다 했어요.
기계한테 안부 물어봐 준 사람은 처음이네요 :)
-> close

= close
# todo: boiler, 해든빌라 보일러 소리 (경비 아저씨)
# note: 3월 9일
번호 하나 바꿨을 뿐인데 하루가 이렇게 길 줄은 몰랐다.
# dayend
-> d02_morning
