// 채이안 루트 — D5 밤 ~ D13 (엔딩은 endings.ink)
// 갈등(D8): 외주 전면 수정 + 전시 공모 원고가 막힌다. 설렘(D10): 정전된 옥상, 태블릿 불빛.
// D9 새벽 도어락과 라면, D10 사장님 전화(수첩 속 옛 그림), D11 위기(포기하고 본가로), D12 공모 마감·고백.
// 굿엔딩 열쇠: D7 잠수를 조용히 기다리기 + D11 문 앞에서 도망치지 않기 + 얼굴 이야기(D8 또는 옛 그림) + 호감 75.

VAR f_ian_hands = false       // D6 손 모델을 했다
VAR f_ian_watch = false       // 시계 이야기를 솔직히 했다
VAR f_ian_wait = false        // D7 잠수를 조용히 기다렸다 (문고리 간식)
VAR f_ian_pester = false      // D7 재촉했다
VAR f_ian_insight = false     // D8 "이안 씨 그림엔 얼굴이 없다"고 말했다
VAR f_ian_ramen = false       // D9 새벽 라면
VAR f_ian_drawing = false     // D10 사장님 수첩 속 옛 그림을 전했다
VAR f_ian_rooftop = false     // D10 옥상에서 같이 그렸다
VAR f_ian_stay = false        // D11 문 앞에서 도망치지 않았다
VAR f_ian_submit = false      // D12 공모에 냈다
VAR f_ian_confess = false     // D12 마음을 말했다


=== ian_d05_night ===
# time: 23:10 # at: home
# room: ian
오늘 진짜 재밌었다 ㅋㅋㅋ
{d5_with == 2: 벤치에서 가만히 있어 줘서 고마워요. 오 분이라고 했는데 이십 분 있었던 거 알아요? ㅋㅋ|정전됐을 때 발전기 앞에 서 있던 거 그렸어요 ㅋㅋ}
# photo: ian_cg_festival_sketch_01
장터 스케치
# typing: 1
어때요 어때요
* [발전기 앞 그림자가 좋아요 # say: 손전등 세 개가 비추니까 그림자가 세 개네요. 이거 좋아요.]
    ~ raise(aff_ian, 4)
    ~ f_ian_eye = true
    헐
    그거 알아본 사람 처음이에요
    그림자 세 개 그리느라 손목 나갈 뻔 ㅋㅋㅋ
* [잘 그렸어요]
    ~ raise(aff_ian, -1)
    ㅋㅋ 감사합니다
* [저 저렇게 당황했어요?]
    ~ raise(aff_ian, 2)
    ㅋㅋㅋㅋ 실물은 더 당황했어요
- # note: 3월 13일
장터가 끝났다. 윗집에서 오늘은 의자 끄는 소리가 신나게 난다.
# dayend
-> ian_d06


// ════════════════════════════════
// D6 — 3월 14일 토요일: 손 모델
// ════════════════════════════════
=== ian_d06 ===
# day: 6
# time: 11:20
# note: 3월 14일
구름 조금. 토요일. 윗집은 아직 조용하다. 자고 있을 시간이다.
# post: ian_p4 # from: ian # photo: ian_cg_festival_sketch_01
봄밤 장터. 전구를 고치는 사람과 손전등 세 개
# comment: ian_p4 # from: seoha
저 여기 있네요 :)
# comment: ian_p4 # from: choi
나는 왜 뒷모습만 있어 ㅋㅋ
# ask: 이안 그림일기 게시물
* [좋아요 # like: ian_p4]
    ~ raise(aff_ian, 1)
* [댓글: 손전등 셋, 그림자 셋 # comment: ian_p4 # say: 손전등 셋, 그림자 셋. 제목까지 좋네요]
    ~ raise(aff_ian, 3)
    # comment: ian_p4 # from: ian
    제목 칭찬은 처음 받아 봄 ㅋㅋㅋ
* [넘기기]
- # time: 14:00
# room: ian
부탁이 있어요 ㅋㅋ
손 모델 해 줄 수 있어요??
# typing: 1.5
외주 원고에 남자 손이 나오는데 제 손은 너무 쪼끄매서 참고가 안 돼요 ㅠ
공구 든 손!! 딱 그거!!
* [좋아요]
    ~ raise(aff_ian, 2)
    대박 ㅋㅋ 세 시에 올라와요!!
* [공구 드는 손은 자신 있어요 # say: 공구 드는 손은 자신 있어요 ㅎㅎ]
    ~ raise(aff_ian, 3)
    ㅋㅋㅋㅋㅋ 드는 건 자신 있고 고치는 건?
    아 농담 농담!! 세 시!!
* [손만요?]
    ~ raise(aff_ian, 2)
    ㅋㅋㅋ 일단은 손만!
- # plan: ian_hands, 6, 15:00, 손 모델 · 301호
-> hands

= hands
# time: 15:00
# scene: bg_ian_room_day_01 # at: home, 손 모델
301호. 책상 위에 드라이버, 몽키스패너, 줄자가 가지런히 놓여 있다. 오늘 산 것 같다.
# cut: ian_scene_draw_01 # from: ian
드라이버 쥐어 봐요. 아니 그렇게 말고, 나사 돌리기 직전처럼.
그녀가 내 손가락을 하나씩 옮긴다. 손끝이 차갑다. 안경 너머로 내 손만 본다.
# from: ian
검지 조금만 더… 아 좋다. 움직이지 마요.
사각사각. 태블릿 펜 소리. 10분 동안 나는 드라이버를 쥔 채 굳어 있다.
# cut: ian_face_neutral_01 # from: ian
시계 예쁘다. 선물 받은 거예요?
* [첫 월급으로 샀어요 # say: 입사하고 첫 월급으로 산 거예요. 회사는 그만뒀는데, 시계는 못 버렸어요.]
    ~ raise(aff_ian, 3)
    ~ f_ian_watch = true
    # cut: ian_face_shy_01 # from: ian
    …그 얘기 그림에 넣어도 돼요? 시계는 안 버린 사람.
* [그냥 산 거예요]
    # from: ian
    그렇구나. 가죽 줄이 손목에 잘 맞아요.
- # cut: ian_face_smile_01 # from: ian
다 했다!! 모델료는 라면이에요. 제가 끓이는 거 아니고 제가 사는 거.
# from: ian
아 그리고 참고용으로 사진 한 장만 찍을게요.
찰칵. 드라이버를 쥔 내 손이 그녀의 폰에 남는다.
# from: ian
엄마가 이거 보면 또 놀러 다니는 줄 알겠다 ㅋㅋ 프리랜서 삼 년 차인데 엄마는 아직도 제가 노는 줄 알아요.
# from: ian
전주 내려오래요. 교대 가래요. 지금이라도.
(웃으면서 말한다. 벽의 그림들은 오늘도 모두 뒤를 보고 있다.)
~ f_ian_hands = true
# scene: end
# memo: ian
본가는 전주. 엄마는 교대에 가라고 한다. 프리랜서 3년 차.
# time: 17:40
# room: ian
# photo: ian_cg_hands_ref_01
오늘의 손 (참고용)
기념으로 드려요 ㅋㅋ 모델 본인 소장용
# note: 3월 14일
내 손 사진이 왔다. 사진첩에 넣어 둘지 말지는 내 마음이다.
-> night

= night
# time: 22:30 # at: home
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {not k_doorlock} [도어락이 방전됐을 때 여는 법 # watch: doorlock]
        -> video_doorlock ->
    * * {not k_lantern} [정전 됐을 때 물병 랜턴 만들기 # watch: lantern]
        -> video_lantern ->
    * * {not k_timing} [썸 탈 때 답장은 몇 분 뒤에? # watch: timing]
        -> video_timing ->
    * * [그만 보기]
    - - -> late
* [이안 씨에게 연락하기 # act]
    # room: ian
    # from: me
    손은 잘 나왔어요?
    ~ raise(aff_ian, 2)
    완전요!! 클라이언트가 손 좋대요 ㅋㅋㅋ
    제 손 아니고 그쪽 손인데 제가 칭찬받음
    -> late
* [일찍 자기 # act]
    -> late

= late
# time: 03:12
# room: ian
자요?
안 자면 이거 봐 줘요
# photo: ian_cg_hands_drawing_01
오늘 그린 손
{aff_ian >= 50: 모델이 좋아서 잘 나왔어요. 아 이 말은 취소 안 할래요}
* [시계줄이 똑같아요 # say: 시계줄 버클까지 똑같아요. 제 손인데 제 손보다 멋있어요.]
    ~ raise(aff_ian, 4)
    ~ f_ian_eye = true
    ㅋㅋㅋ 버클 보라고 그린 거 맞음
    제 그림 볼 때 꼭 작은 데를 봐요 그쪽은
* [아침에 볼게요 # act]
    ~ raise(aff_ian, -1)
    # wait: 3
    자는구나 🥲 굿나잇
- # dayend
-> ian_d07


// ════════════════════════════════
// D7 — 3월 15일 일요일: 잠수
// ════════════════════════════════
=== ian_d07 ===
# day: 7
# time: 10:00
# note: 3월 15일
맑음. 윗집 소식이 끊겼다. 어젯밤 "굿나잇" 이후로 아무것도 없다.
# room: ian
# from: me
좋은 아침이에요. 손 그림 잘 넘겼어요?
# note: 3월 15일
보낸 메시지 옆의 "1"이 사라지지 않는다. 한 시간이 지나도.
# time: 12:30
# room: dangol
# from: choi
301호 아가씨 요즘 안 보이네
# from: guard
불은 밤새 켜져 있어
# from: seoha
이안 씨 마감이래요. 어제 커피 사 가면서 좀비 같았어요 :)
# from: halmeoni # big
밥 먹어요
# town: t_light3, 동네생활, 해든빌라 1층
해든빌라 3층 밤새 불 켜진 집 ㅋㅋ 누구예요
# townreply: t_light3, 망원 산책러
그림 그리는 분이래요~ 새벽 세 시에도 불 켜져 있음
# time: 13:00
# ask: 윗집이 조용하다
* [한 번 더 연락해 보기 # act]
    ~ f_ian_pester = true
    ~ raise(aff_ian, -4)
    # room: ian
    # from: me
    괜찮아요? 답장 좀 해 줘요.
    # from: me
    밥은 먹었어요?
    # note: 3월 15일
    "1"이 두 개가 됐다. 세 개가 됐다. 사라지지 않는다.
* [기다리기 # act]
    ~ raise(aff_ian, 1)
    # note: 3월 15일
    기다리기로 했다. 연애 상담 영상의 댓글처럼, 볼 시간에 다른 걸 하기로 했다.
* [문고리에 간식 걸어 두기 # act]
    ~ f_ian_wait = true
    ~ raise(aff_ian, 4)
    # note: 3월 15일
    컵라면 두 개, 초코바, 비타민 음료. 봉지째 301호 문고리에 걸었다. 포스트잇 한 장. "마감 파이팅. 답장 안 해도 됨. — 201"
    # gallery: mc_cg_doorknob_01
- -> night

= night
# time: 22:10 # at: home
# note: 3월 15일
천장 너머에서 의자 소리가 난다. 살아는 있다.
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {not k_doorlock} [도어락이 방전됐을 때 여는 법 # watch: doorlock]
        -> video_doorlock ->
    * * {not k_lantern} [정전 됐을 때 물병 랜턴 만들기 # watch: lantern]
        -> video_lantern ->
    * * [그만 보기]
    - - -> close
* [다른 사람에게 연락하기 # act]
    # ask: 누구에게 연락할까?
    * * [윤서하에게 메시지 # text: seoha]
        # room: seoha
        # from: me
        이안 씨 커피 사 갔어요?
        # wait: 2
        네, 샷 세 개 넣어 갔어요 :) 마감 때는 늘 그래요.
        걱정되죠? 이안 씨는 마감 끝나면 제일 먼저 연락하는 사람한테 연락해요. 기다려 봐요 :)
    * * [김다온에게 메시지 # text: daon]
        # room: daon
        # from: me
        밤샘하는 사람한테 뭐가 좋아요?
        # wait: 12
        물이요.
        그리고 억지로라도 자게 두는 거요.
    * * [그만두기]
    - - -> close
* [일찍 자기 # act]
    -> close

= close
# dayend
-> ian_d08


// ════════════════════════════════
// D8 — 3월 16일 월요일: 전부 다시
// ════════════════════════════════
=== ian_d08 ===
# day: 8
# time: 04:10
# room: ian
{
- f_ian_wait:
    헉 문고리에 이거 뭐예요 ㅠㅠㅠ
    라면이랑 초코바 ㅋㅋㅋ
    답장 안 해도 됨 이라니
    이러면 답장 더 하고 싶잖아요 ㅠㅠ
    ~ raise(aff_ian, 2)
- f_ian_pester:
    …연락 많이 했네요 ㅋㅋ
    미안해요 마감이라서 폰을 뒤집어 놨었어요
- else:
    살아났습니다 ㅋㅋㅋ
}
# typing: 1
마감 하나 끝냈어요!!
이제 잘 거예요 안녕히 주무세요 아 지금 아침인가
# note: 3월 16일
흐림. 새벽 4시 10분에 윗집이 살아났다.
# time: 11:00
# town: t_contest, 모집, 갤러리 틈
[모집] 망원 골목 작은 전시 공모
# town: t_contest
주제: 우리 동네 사람. 동네에 사는 작가의 작품 한 점을 3주 동안 걸어 드립니다.
# town: t_contest
마감: 3월 20일(금) 자정. 이메일 접수.
# pin: gallery
# event: contest, 12, 망원 골목 전시 공모 마감 (자정)
# time: 15:10
# room: ian
클라이언트가 전부 다시 하래요 ㅋㅋㅋㅋ
처음부터요
그 손도 ㅋㅋ
# typing: 2
공모전은… 모르겠다 ㅋㅋ
주제가 우리 동네 사람이래요. 저 사람 앞모습 못 그리는 거 알잖아요
* [괜찮아요? # say: 괜찮아요?]
    ~ raise(aff_ian, 1)
    ㅋㅋ 안 괜찮은데 괜찮아요
* [저녁 먹을래요?]
    ~ raise(aff_ian, 2)
    …좋아요. 저 오늘 첫 끼예요
- -> visit

= visit
# time: 21:00
# scene: bg_mc_room_night_01 # at: home, 201호
똑똑. 201호 문 앞에 캔맥주 두 개를 든 이안이 서 있다. 후드 모자를 푹 쓰고.
# cut: ian_face_smile_01 # from: ian
잠깐 들어가도 돼요? 위에 있으면 숨 막혀서.
내 방은 엉망이다. 바닥에 공구함과 신문지. {f_ian_hands: 그녀가 공구함을 보고 웃는다. "손 모델 소품이다."|그녀가 공구함을 보고 "진짜 수리하는 사람 방이다" 하고 웃는다.}
캔을 딴다. 그녀가 벽에 등을 대고 앉는다.
# cut: ian_face_neutral_01 # from: ian
저 그림 그만둘까 봐요 ㅋㅋ
(ㅋㅋ를 소리 내서 말하는 사람은 처음 본다. 소리 내서 말하니까 전혀 웃기지 않다.)
* [예쁜 그림 많잖아요]
    ~ raise(aff_ian, -4)
    # from: ian
    …예쁜 그림이요. 그쵸 ㅋㅋ
    (그녀가 맥주를 한 모금 마신다. 대화가 거기서 끝난다.)
    -> after
* [그만두고 싶은 거 아니잖아요]
    ~ raise(aff_ian, 4)
    # cut: ian_face_surprised_01 # from: ian
    …어떻게 알아요.
    # from: me
    그만두고 싶은 사람은 그만둔다고 말 안 하고 그냥 그만둬요. 제가 그랬거든요.
    # from: ian
    ㅋㅋ… 그렇네. 퇴사 선배네.
    -> after
* [이안 씨 그림엔 얼굴이 없어요 # say: 이안 씨 그림에는 얼굴이 없어요. 장터 그림도, 벽에 붙은 그림도, 다 뒷모습이에요.]
    -> insight

= insight
~ f_ian_insight = true
~ raise(aff_ian, 5)
# cut: ian_face_surprised_01 # from: ian
…
# from: me
얼굴을 못 그리는 게 아니라, 안 보여 주는 것 같아요. 그림 속 사람 얼굴 말고. 이안 씨 얼굴을요.
# fx: zoom # cut: ian_face_shy_01
그녀가 후드 모자를 더 깊게 눌러쓴다. 한참 동안 아무 말도 없다.
# from: ian
…아 뭐야. 들켰다.
# from: ian
얼굴 그리면 그 사람이 날 어떻게 보는지 그려지잖아요. 그걸 보는 게 무서웠어요. 별로라고 보는 얼굴이 나올까 봐.
# from: ian
그래서 다 뒤돌려 세웠어요. 뒷모습은 날 안 보니까.
-> after

= after
# cut: ian_face_smile_01 # from: ian
맥주 다 마셨다. 올라갈게요. 수정 원고 해야죠 ㅋㅋ
문을 나서다가 그녀가 돌아본다. 뒷모습이 아니라, 얼굴로.
# from: ian
오늘 고마워요. 들켜서 좋았어요. 이상하게.
# scene: end
# time: 23:40
# post: ian_p5 # from: ian
요즘 그림이 안 그려진다 ㅋㅋ
# time: 23:45
# unpost: ian_p5
# note: 3월 16일
{f_ian_insight: 이안 씨 스냅에 "요즘 그림이 안 그려진다"는 글이 올라왔다가 5분 만에 지워졌다. 들켜서 좋았다는 말은, 아마 진심이었을 거다.|이안 씨 스냅에 글이 올라왔다가 5분 만에 지워졌다. "요즘 그림이 안 그려진다."}
# memo: ian
얼굴을 그리면 그 사람이 날 어떻게 보는지 그려질까 봐 무섭다고 했다. 그래서 그림 속 사람들을 다 뒤돌려 세웠다.
-> night

= night
# time: 23:50 # at: home
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {not k_doorlock} [도어락이 방전됐을 때 여는 법 # watch: doorlock]
        -> video_doorlock ->
    * * {not k_lantern} [정전 됐을 때 물병 랜턴 만들기 # watch: lantern]
        -> video_lantern ->
    * * [그만 보기]
    - - -> close
* [일찍 자기 # act]
    -> close

= close
# dayend
-> ian_d09


// ════════════════════════════════
// D9 — 3월 17일 화요일 (비): 새벽 세 시의 도어락
// ════════════════════════════════
=== ian_d09 ===
# day: 9
# time: 13:20
# note: 3월 17일
비. 윗집은 수정 원고 중이다. 오늘은 짧은 메시지만 온다.
# room: ian
수정 30%
비 오니까 그림도 축축해요 ㅋㅋ
# time: 19:40
# room: ian
수정 60%
배고파서 편의점 갈까 말까 고민만 두 시간째
# town: t_outage, 공지, 망원1동 주민센터
[안내] 3월 18일(수) 23:00~01:00 해든빌라 일대 변압기 교체로 정전됩니다
# town: t_outage
엘리베이터·도어락 등 전기 사용 기기에 유의해 주세요.
# note: 3월 17일
망원살이에 정전 공지가 떴다. 내일 밤 11시부터 두 시간. 해든빌라 일대.
# time: 22:00 # at: home
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {not k_doorlock} [도어락이 방전됐을 때 여는 법 # watch: doorlock]
        -> video_doorlock ->
    * * {not k_lantern} [정전 됐을 때 물병 랜턴 만들기 # watch: lantern]
        -> video_lantern ->
    * * [그만 보기]
    - - -> doorlock
* [늦게까지 깨어 있기 # act]
    # note: 3월 17일
    빗소리를 들으며 누워 있다. 윗집 의자 소리가 가끔 난다.
    -> doorlock
* [일찍 자기 # act]
    -> doorlock

= doorlock
# time: 03:05 # wait: 1.5
# call: ian
* [받기 # answer]
    …자요? 미안해요 ㅠㅠ
    저 문이 안 열려요.
    편의점 다녀왔는데 도어락이 먹통이에요. 비밀번호 눌러도 아무 소리도 안 나요.
    비 와서 다 젖었어요 ㅋㅋㅋ ㅠ
    # from: me
    지금 올라갈게요.
    ~ raise(aff_ian, 2)
    # call: end
* [거절 # decline]
    ~ raise(aff_ian, -2)
    # room: ian
    앗 자는구나 ㅠㅠ
    저 문이 안 열려서요… 괜찮아요 계단에 앉아 있을게요 ㅋㅋ
    # note: 3월 17일
    새벽 세 시. 문이 안 열린다는 메시지를 보고 누워 있을 수가 없다.
- -> stairs

= stairs
# time: 03:12
# scene: bg_villa_hall_night_01 # at: home, 새벽 세 시
3층 계단참. 형광등 아래에, 후드가 흠뻑 젖은 이안이 편의점 봉지를 끌어안고 쪼그려 앉아 있다.
# cut: ian_face_pout_01 # from: ian
왔다… 새벽 세 시에 불러서 미안해요.
{ k_doorlock:
    (도어락 아래 금속 동그라미 두 개. 9V 네모난 건전지. 생존 공구의 목소리.)
    # from: me
    잠깐만요. 편의점 금방 다녀올게요.
    24시 편의점에서 네모난 건전지를 사 온다. 도어락 아래 접점에 대고, 그녀에게 비밀번호를 누르라고 한다.
    # fx: zoom
    삑— 띠리릭. 문이 열린다.
    # cut: ian_face_surprised_01 # from: ian
    …천재?? 새벽 세 시에 천재 소리 들어도 돼요??
    ~ raise(aff_ian, 3)
    # from: ian
    …라면 먹고 갈래요? ㅋㅋㅋ
    # cut: ian_face_shy_01 # from: ian
    아 이상한 뜻 아니고!! 진짜 라면!! 편의점에서 사 왔어요 두 개!!
    -> ramen_301
- else:
    도어락 버튼을 눌러 본다. 아무 반응이 없다. 배터리 뚜껑은 문 안쪽에 있다.
    # from: me
    …못 열겠어요. 모르겠어요.
    # from: ian
    ㅋㅋ 그쵸. 열쇠 아저씨 아침 9시에 온대요.
    # from: me
    그럼 그때까지 우리 집에 있어요. 젖었잖아요.
    # cut: ian_face_surprised_01 # from: ian
    …그래도 돼요?
    -> ramen_201
}

= ramen_301
# time: 03:30
# cut: ian_scene_ramen_01
301호. 책상 위 태블릿을 밀어내고 냄비째 라면을 놓는다. 그녀가 젓가락 하나를 건네준다.
-> ramen_talk

= ramen_201
# time: 03:30
# cut: ian_scene_ramen_01
201호. 그녀에게 내 후드 집업을 빌려준다. 회색. 소매가 그녀 손을 다 덮는다. 냄비째 라면을 놓는다.
-> ramen_talk

= ramen_talk
# from: ian
기념 사진. 새벽 라면은 사진으로 남겨야 해요 ㅋㅋ
찰칵. 냄비 두 개가 그녀의 폰에 남는다.
~ f_ian_ramen = true
# from: ian
엄마가 오늘도 전화했어요. 언제 내려오냐고.
# from: ian
저 원래 이래요. 힘들면 숨어요. 마감이라고 폰 뒤집어 놓고, 그림 뒤에 숨고. 이번엔 전주에 숨을까 봐요 ㅋㅋ
* [숨는 거지 도망치는 건 아니에요 # say: 숨는 거지, 도망치는 건 아니잖아요. 숨으면 찾으러 가면 되니까.]
    ~ raise(aff_ian, 4)
    # cut: ian_face_shy_01 # from: ian
    …찾으러 올 거예요?
    # from: me
    새벽 세 시에도 왔잖아요.
* [전주 가고 싶어요?]
    ~ raise(aff_ian, 2)
    # from: ian
    …모르겠어요. 가고 싶은 건 아닌데, 여기 있을 이유를 모르겠어요.
* [가만히 듣기 # act]
    ~ raise(aff_ian, 3)
    대답하지 않는다. 그녀가 라면 국물을 한 숟갈 뜬다. 그리고 한참 뒤에 말한다.
    # from: ian
    …안 물어봐 줘서 고마워요. 다들 왜 그러냐고 물어요.
- 라면이 식는다. 그녀의 말이 점점 느려진다.
# cut: ian_face_neutral_01
어느 순간 어깨가 무거워진다. 그녀가 내 어깨에 기대 잠들어 있다. 안경이 비뚤어졌다.
(안경을 벗겨 주려다 그만둔다. 손을 대면 깰 것 같아서.)
# fade
빗소리. 형광등 소리. 새벽이 조금씩 파래진다.
# scene: end
# dayend
-> ian_d10


// ════════════════════════════════
// D10 — 3월 18일 수요일 (갬): 옛 그림, 그리고 옥상
// ════════════════════════════════
=== ian_d10 ===
# day: 10
# time: 09:40
# room: ian
어제… 제가 먼저 잠든 거죠? ㅋㅋㅋㅋ
어깨 괜찮아요?? 진짜 미안해요
# photo: ian_cg_ramen_01
새벽 라면 기념
# typing: 1
프사 이걸로 바꿀까 봐요 ㅋㅋ
* [잘 나왔네요]
    ~ raise(aff_ian, 1)
    ㅋㅋ 라면이 잘생김
* [어깨는 괜찮아요 # say: 어깨는 괜찮아요. 코 고는 소리도 괜찮았어요 ㅎㅎ]
    ~ raise(aff_ian, 3)
    헐 ㅋㅋㅋㅋ 거짓말 거짓말 저 안 골아요
    …골았어요?
- {not k_jeju: -> jeju_again | -> call}

= jeju_again
# time: 11:00 # at: home
-> jeju_offer ->
-> call

= call
# time: 14:00 # wait: 1.5
# call: boss # unknown
* [받기 # answer]
    -> boss_call_open ->
    301호 아가씨는 요새도 불 켜 놓고 자나?
    # from: me
    …요즘 그림이 잘 안 된대요. 공모전도 포기할까 하고요.
    …그 아가씨가 나 그려 준 그림이 있어.
    형광등 고쳐 줬더니 다음 날 문 앞에 붙여 놨더라고. 내 얼굴을. 허허, 나보다 잘생기게.
    그거 수첩에 끼워 뒀을 겨. 맨 뒤에. 한번 찾아봐.
    -> boss_call_close ->
* [거절 # decline]
    # voicemail: boss
    …여보세요. 만물수선 번호 쓰는 사람인가. 김용수여. 이 번호 전 주인.
    # voicemail: boss
    바쁜가 보네. 하나만 전해 줘. 301호 아가씨가 나 그려 준 그림이 있어. 형광등 고쳐 준 다음 날 문에 붙여 놨더라고.
    # voicemail: boss
    그거 수첩 맨 뒤에 끼워 뒀어. 그 아가씨 보여 줘. 고치는 건 기술이 아니라 끈기여.
    # note: 3월 18일
    064로 시작하는 모르는 번호. 음성사서함에 긴 메시지가 남았다.
- -> find

= find
# time: 14:40
# note: 3월 18일
수첩 맨 뒤. 뒤표지 안쪽에 접힌 종이가 끼워져 있다. 펼치자 연필 그림이 나온다.
# gallery: ian_cg_old_drawing_01
안경 쓴 노인의 얼굴. 웃고 있다. 구석에 작은 글씨. "형광등 고쳐 주셔서 감사합니다 — 301호"
# note: 3월 18일
앞모습이다. 얼굴이다. 이안 씨가 그린.
# room: ian
* [그림 사진 보내기 # attach: ian_cg_old_drawing_01]
    ~ f_ian_drawing = true
    ~ raise(aff_ian, 5)
    # wait: 4
    …
    이거 어디서 났어요?
    # typing: 3
    제가 2년 전에 그린 거예요. 사장님이 형광등 고쳐 주셔서. 문에 붙여 놓고 도망갔는데.
    버리신 줄 알았어요.
    # typing: 2.5
    …저 얼굴 그렸었네요. 그때는.
    # from: me
    사장님이 2년 동안 수첩에 끼워 두셨대요. 맨 뒤에.
    # typing: 2
    ㅠㅠㅠㅠㅠ 아 진짜
    왜 이렇게 울리는 날이지 오늘
* [나중에 보여 주기 # act]
    # note: 3월 18일
    지금 보내면 그녀가 울 것 같았다. 아니, 내가 뭐라고. 폰을 내려놓았다.
- -> blackout

= blackout
# time: 22:50
# room: ian
오늘 11시 정전인 거 알죠??
옥상 갈래요?
정전되면 별 보일 것 같아요 ㅋㅋ 태블릿 들고 갈게요
* [갈게요]
    ~ raise(aff_ian, 2)
    ㅋㅋ 11시에 옥상 문 앞!!
* [위험하지 않아요?]
    ~ raise(aff_ian, 1)
    난간 있어요 ㅋㅋ 그리고 수리 담당이 있잖아요
- -> rooftop

= rooftop
# time: 23:00
# scene: bg_villa_rooftop_night_01 # at: home, 옥상
열한 시 정각. 동네 전체의 불이 한꺼번에 꺼진다. 옥상 문을 밀고 나가자, 멀리 한강 건너 불빛만 남는다.
# cut: ian_scene_rooftop_01 # from: ian
와… 망원동에 별이 있었네.
{ k_lantern:
    휴대폰 손전등을 위로 켜고, 물 채운 페트병을 올린다. 병 전체가 전등처럼 은은하게 빛난다.
    # cut: ian_face_surprised_01 # from: ian
    이거 뭐예요?? 예쁘다. 천재?
    # from: me
    생존 공구에서 배웠어요.
    # from: ian
    ㅋㅋㅋ 채널 이름이 생존 공구예요? 오늘부터 구독함
    ~ raise(aff_ian, 3)
}
# cut: ian_scene_rooftop_01
그녀가 태블릿을 켠다. 화면 불빛이 그녀 얼굴을 아래에서 비춘다.
# from: ian
같이 그려요. 그쪽도 하나 그려요. 저 그려 봐요.
태블릿을 받아 든다. 그녀를 그린다. 동그란 얼굴에 점 두 개, 선 하나. 헤드폰은 귀마개처럼 됐다.
# cut: ian_face_smile_01 # from: ian
ㅋㅋㅋㅋㅋ 이거 저예요? 천재… 아니 이건 천재 아님 ㅋㅋㅋㅋ
# from: ian
근데 웃고 있네. 저 웃고 있어요, 여기서.
{f_ian_drawing: -> old_face}
-> draw_two

= old_face
# from: ian
아까 그 그림요. 사장님 얼굴.
# from: ian
그때 저 사장님이 절 어떻게 보는지 하나도 안 무서웠어요. 좋은 사람인 게 너무 확실해서.
# from: ian
…지금도 좀 그래요. 그쪽 볼 때.
-> draw_two

= draw_two
그녀가 새 캔버스를 연다. 옥상 난간에 나란히 앉은 두 사람. 뒷모습이다. 머리 위에 별이 몇 개.
# from: ian
이건 같이 그린 거예요. 별은 그쪽이 찍어요.
그녀가 내 손가락을 잡아 화면 위에 대 준다. 톡, 톡. 별이 두 개 생긴다.
* [손을 놓지 않는다 # act]
    ~ raise(aff_ian, 4)
    ~ f_ian_rooftop = true
    별을 다 찍고 나서도 손을 놓지 않는다. 그녀도 놓지 않는다. 태블릿 불빛이 꺼질 때까지.
    # from: ian
    …손 모델 계약에 이런 조항은 없었는데 ㅋㅋ
* [별을 하나 더 찍는다 # act]
    ~ raise(aff_ian, 2)
    ~ f_ian_rooftop = true
    톡. 세 번째 별. 그녀가 웃는다.
    # from: ian
    욕심쟁이.
- # fade
새벽 한 시. 동네에 불이 돌아온다. 우리는 조금 더 앉아 있었다. 불이 돌아온 게 아쉬워서.
# scene: end
# dayend
-> ian_d11


// ════════════════════════════════
// D11 — 3월 19일 목요일 (흐림): 도망
// ════════════════════════════════
=== ian_d11 ===
# day: 11
# time: 12:10
# note: 3월 19일
흐림. 이안 씨 스냅 계정 소개글이 바뀌었다. "잠시 쉽니다."
# time: 15:00
# room: ian
저 공모 안 낼래요 ㅋㅋ
외주 끝나면 전주 좀 내려가 있으려고요. 엄마가 오래요.
# typing: 2
어차피 안 될 거였어요.
어제 옥상은 좋았어요. 진짜로. 그래서 더 못 하겠어요 ㅋㅋ
# typing: 1.5
좋은 거 망칠까 봐요
# note: 3월 19일
"좋은 거 망칠까 봐요." 이안 씨는 무서우면 ㅋㅋ를 붙인다. 오늘 메시지엔 전부 붙어 있다.
# ask: 어떻게 할까?
* [알았어요, 푹 쉬고 와요 # act]
    # room: ian
    # from: me
    알았어요. 푹 쉬고 와요.
    # wait: 3
    ㅋㅋ 네
    고마워요 이해해 줘서
    # note: 3월 19일
    이해한다고 했다. 이해하는 척을 했다. 그녀가 숨을 때, 나는 찾으러 가지 않았다.
    -> night_alone
* [그래도 내 봐요! # act]
    ~ raise(aff_ian, -3)
    ~ f_ian_pester = true
    # room: ian
    # from: me
    그래도 내 봐요! 아직 하루 남았잖아요. 이안 씨 그림 좋아요!
    # wait: 8
    …
    마감 중엔 재촉하지 말아 줘요
    미안해요
    -> night_alone
* [지금 올라갈게요 # act]
    ~ f_ian_stay = true
    -> door

= door
# time: 15:20
# scene: bg_villa_hall_01 # at: home, 301호 문 앞
301호 문 앞. 두 번 두드린다. 대답이 없다. 안에서 의자 끄는 소리가 멈춘다.
# from: ian
…왜 왔어요. 문 안 열 거예요.
# from: me
안 열어도 돼요. 여기 있을게요.
계단에 앉는다. 문 너머에서도 누군가 문에 등을 대고 앉는 소리가 난다. 우리 사이에 문 한 장.
* [그 그림은 누가 봐야 해요 # say: 기다릴게요. 근데 옥상에서 같이 그린 그림, 그건 누가 봐야 해요. 저만 보기엔 아까워요.]
    ~ raise(aff_ian, 4)
    # from: ian
    …그건 둘이 뒷모습이잖아요 ㅋㅋ
    # from: me
    그러니까 하나 더 그려요. 이번엔 앞모습으로. 이안 씨 얼굴.
* {f_ian_drawing} [사장님 얘기 # say: 사장님이 이안 씨가 그린 얼굴을 2년 동안 수첩에 끼워 두셨어요. 버리지 않고요. 누군가는 그렇게 이안 씨 그림을 보고 있어요.]
    ~ raise(aff_ian, 5)
    # from: ian
    …반칙이에요 그거.
    (문 너머에서 코를 훌쩍이는 소리가 난다.)
* [문 열어 줘요]
    ~ raise(aff_ian, -1)
    # from: ian
    …싫어요. 지금 얼굴 엉망이에요.
    # from: me
    그럼 엉망인 얼굴 보러 왔어요.
    # from: ian
    ㅋ… 진짜 싫다 이 사람.
- 한참 뒤. 딸깍. 문이 열린다.
# cut: ian_face_pout_01 # from: ian
…왜 안 가요.
눈이 빨갛다. 안경을 안 썼다. 처음으로 그녀의 얼굴을 이렇게 정면에서 본다.
# from: me
안 가요.
# cut: ian_face_shy_01 # from: ian
…하루 남았네요. 그려 볼게요.
# from: ian
대신 옆에 있어 줘요. 말은 걸지 말고. 그냥 있어 줘요.
# scene: end
-> drawing_night

= drawing_night
# time: 22:30
# scene: bg_ian_room_night_01 # at: home, 301호
그녀는 그리고, 나는 방 구석에서 사장님 수첩을 읽는다. 펜 소리와 종이 넘기는 소리만 난다.
# from: ian
아… 참고용 손 사진 폴더를 어제 홧김에 지웠어요 ㅋㅋ 그 사진 혹시 있어요?
# scene: end
# room: ian
혹시 있으면 여기로 보내 줘요 ㅋㅋ 옆에 있는데 문자하는 거 웃기지만
* {saved("ian_cg_hands_ref_01")} [손 사진 보내기 # attach: ian_cg_hands_ref_01]
    ~ raise(aff_ian, 3)
    헐 저장해 놨었어요?? ㅋㅋㅋ
    모델 본인 소장용이라더니 진짜 소장했네
* [없어요, 직접 해 줄게요 # say: 없어요. 대신 제 손 여기 있어요.]
    ~ raise(aff_ian, 1)
    ㅋㅋ 그럼 30분만 드라이버 쥐고 있어요
- # note: 3월 19일
새벽까지 301호에 있었다. 그녀는 한 번도 뒤를 돌아보지 않고 그렸다. 이번엔 그게 좋았다.
# dayend
-> ian_d12

= night_alone
# time: 23:30 # at: home
# note: 3월 19일
천장이 조용하다. 의자 소리가 나지 않는다. 짐을 싸는 소리가 가끔 난다.
# dayend
-> ian_d12


// ════════════════════════════════
// D12 — 3월 20일 금요일 (맑음, 춘분): 윗집 사람
// ════════════════════════════════
=== ian_d12 ===
# day: 12
# time: 11:00
# note: 3월 20일
맑음. 춘분. 공모 마감일. 자정까지.
{f_ian_stay: -> progress | -> leaving}

= progress
# room: ian
30% ㅋㅋ
# time: 15:00
# room: ian
60%
배고파요 🫠
# ask: 뭘 사다 줄까?
* [오후세시 아이스 바닐라 라떼, 샷 추가 # act]
    ~ raise(aff_ian, 3)
    # room: ian # time: 15:40
    헐 제 주문 외웠어요??
    샷 추가까지?? 천재 아니고 이건 스토커 ㅋㅋㅋ 아 농담!! 고마워요!!
* [떡집 가래떡 # act]
    ~ raise(aff_ian, 2)
    # room: ian # time: 15:40
    할머니 떡이다 ㅋㅋ 할머니가 "그림쟁이 아가씨 주라"고 두 줄 더 줬대요?? ㅠㅠ
* [편의점 샌드위치 # act]
    ~ raise(aff_ian, 1)
    # room: ian # time: 15:40
    고마워요!! 문고리에 걸어 줘요 ㅋㅋ
- # time: 20:30
# room: ian
90%
얼굴 그리는 중이에요
# typing: 2
생각보다 안 무서워요
-> call

= call
# time: 23:10
# room: ian
{aff_ian >= 75: 전화 말고 영통 해도 돼요? 얼굴 보고 말하고 싶어서|영상통화 해도 돼요? 보여 줄 게 있어요}
# wait: 1
# call: ian # video
* [받기 # answer]
    # cut: ian_call_drawing_01
    짠.
    # narr
    (화면 속에 그림이 있다. 옥상 난간에 앉은 여자가 이쪽을 내려다보며 웃고 있다. 목에 흰 헤드폰. 동그란 안경.)
    제목은 "윗집 사람"이에요.
    아랫집 사람 시점에서 그렸어요. 제 얼굴을요. 처음으로.
    그쪽이 날 이렇게 보는 것 같았어요. 옥상에서. 그래서 안 무서웠어요.
    * * [그 얼굴 맞아요 # say: 맞아요. 제가 본 얼굴이 딱 그거예요.]
        ~ raise(aff_ian, 4)
        …ㅋㅋ 다행이다. 틀렸으면 다시 그려야 했는데.
    * * [웃는 게 제일 좋아요 # say: 웃고 있는 게 제일 좋아요. 옥상에서 제 그림 보고 웃던 얼굴이에요.]
        ~ raise(aff_ian, 4)
        그 감자 그림 ㅋㅋㅋ 그거 보고 웃은 거 맞아요
    - - 11시 58분. 낼게요. 보내기 버튼 같이 봐 줘요.
    # narr
    (화면 너머에서 그녀가 마우스를 누른다. "접수되었습니다.")
    ~ f_ian_submit = f_ian_stay && (f_ian_insight || f_ian_drawing)
    냈다. 냈어요!! ㅋㅋㅋㅋ
    …잠깐만요. 끊지 말고. 아니 끊어요. 내려갈게요.
    # call: end
    -> door201
* [거절 # decline]
    ~ raise(aff_ian, -3)
    # room: ian
    앗… 자요?
    # time: 23:58
    냈어요 ㅋㅋ 혼자서 누름
    ~ f_ian_submit = f_ian_stay && (f_ian_insight || f_ian_drawing)
    -> night

= door201
# time: 00:05
# scene: bg_mc_room_night_01 # at: home, 201호 문 앞
똑똑. 문을 열자 그녀가 서 있다. 안경을 쓰고, 헤드폰을 목에 걸고. 뛰어 내려왔는지 숨이 차다.
# cut: ian_face_shy_01 # from: ian
영통 말고. 얼굴 보고 말하려고 내려왔어요.
# from: ian
그림 그리면서 알았어요. 그림 속 제가 누굴 보고 웃는지.
* [좋아해요 # say: 이안 씨, 좋아해요.]
    ~ f_ian_confess = true
    ~ raise(aff_ian, 5)
* [그 그림 속 사람이 좋아요 # say: 그 그림 속 사람, 제가 좋아하는 사람이에요.]
    ~ f_ian_confess = true
    ~ raise(aff_ian, 5)
* [축하해요 # say: 공모 낸 거, 축하해요.]
    # from: ian
    …ㅋㅋ 고마워요.
    (그녀가 뭔가 더 말하려다 멈춘다. 그리고 웃는다. 뒤돌아 계단을 올라간다. 뒷모습이다.)
    # scene: end
    -> night
- { aff_ian >= 70:
    # cut: ian_face_smile_01 # from: ian
    …저도요. 먼저 말하려고 뛰어 내려왔는데, 졌네.
    그녀가 한 발 다가온다. 그리고 내 품에 얼굴을 묻는다. 헤드폰이 우리 사이에서 달그락거린다.
    그녀가 고개를 든다. 까치발을 든다. 짧게, 그리고 한 번 더.
- else:
    # cut: ian_face_surprised_01 # from: ian
    …고마워요. 진짜로.
    # from: ian
    근데 저 조금만 생각할래요. 오늘은 그림 낸 것만으로 심장이 터질 것 같아서 ㅋㅋ
}
# fade
새벽. 계단참의 형광등이 곧게 켜져 있다. 더는 떨리지 않는다.
# scene: end
-> night

= leaving
# time: 14:00
# post: ian_p6 # from: ian # photo: ian_cg_box_01
외주 마감 완료. 잠시 쉬러 갑니다
# note: 3월 20일
이안 씨는 공모 대신 짐을 쌌다. 스냅에 박스 사진이 올라왔다.
-> night

= night
# dayend
-> ian_d13


// ════════════════════════════════
// D13 — 3월 21일 토요일 (맑음): 기절, 그리고 판정
// ════════════════════════════════
=== ian_d13 ===
# day: 13
# time: 14:30
# room: ian
{f_ian_submit: 잠수 아니고 기절이었어요 ㅋㅋㅋ 방금 일어남|오늘 오후에 전주 내려가요 ㅋㅋ 인사하려고요}
{f_ian_submit: 어제 일 꿈 아니죠??|이것저것 고마웠어요 진짜로}
* {f_ian_submit} [꿈 아니에요]
    ~ raise(aff_ian, 2)
    ㅋㅋㅋㅋ 다행이다
    저녁에 시장 가요. 할머니 떡볶이. 제가 살게요 모델료
* {not f_ian_submit} [잘 다녀와요]
    ~ raise(aff_ian, 1)
    네 ㅋㅋ 형광등 잘 지켜 줘요
- {f_ian_submit: -> market | -> judge}

= market
# time: 19:00
# scene: bg_market_evening_01 # at: market, 저녁
망원시장. 떡집 앞 좌판에 나란히 앉아 떡볶이를 먹는다.
# from: halmeoni
어머, 둘이 같이 왔네? 그림쟁이 아가씨랑 만물수선 총각이.
# from: ian
할머니 쉿!! ㅋㅋㅋ
# from: choi
ㅋㅋㅋ 둘이 사귀지? 사귀네. 얼굴에 다 쓰여 있네.
그녀가 고개를 숙이고 떡볶이만 먹는다. 귀가 빨갛다. 이번엔 얼굴을 숨기지 않는다.
# scene: end
-> judge

= judge
# time: 23:40 # at: home
# note: 3월 21일
{f_ian_submit: 공모 결과는 한 달 뒤에 나온다고 했다. 그녀는 벌써 다음 그림을 그리고 있다. 앞모습으로.|윗집이 비었다. 형광등은 켜져 있지 않다.}
# dayend
{ aff_ian >= 75 && f_ian_stay && f_ian_submit && f_ian_key:
    -> ending_ian_good
- else:
    -> ending_ian_normal
}
