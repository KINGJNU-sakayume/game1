// 윤서하 루트 — D5 밤 ~ D13 (엔딩은 endings.ink)
// 갈등(D8): 건물주가 재계약 조건으로 월세를 40% 올린다. 설렘(D9): 비 오는 밤 정전, 촛불.
// D10 사장님 전화, D11 위기(본사 제안), D12 고백(춘분), D13 재계약 · 판정.
// 굿엔딩 열쇠: 망원살이에서 받은 낡은 로스터를 살린다 + D11에 도망치지 않는다 + 호감 75.

VAR f_seoha_roaster = false   // D7 망원살이 나눔으로 로스터를 받아 왔다
VAR f_seoha_secret = false    // 로스터를 고칠 때까지 비밀로 하기로 했다
VAR f_seoha_truth = false     // 퇴사한 이유를 솔직히 말했다
VAR f_seoha_hand = false      // D9 촛불 아래에서 손을 잡았다
VAR f_seoha_advice = false    // 사장님의 말(건물주 사모님)을 서하에게 전했다
VAR f_seoha_stay = false      // D11 위기에서 도망치지 않았다
VAR f_seoha_roasted = false   // 로스터를 살렸다
VAR f_seoha_confess = false   // D12 마음을 말했다
VAR f_seoha_saved = false     // D13 재계약이 됐다


=== seoha_d05_night ===
# time: 22:40 # at: home
# room: seoha
{d5_with == 1: 오늘 수레 밀어 줘서 고마워요. 주차장은 결국 반대쪽이었네요 :)|오늘 장터에서 전구 고치는 거 봤어요. 멀리서요.}
마감하고 부스 정리하고 나니까 이 시간이에요.
# typing: 2.5
이상하죠. 가게 문 닫고 나면 늘 조용한데, 오늘은 귀가 아직 시끄러워요 :)
* [오늘 봄 메뉴 맛있었어요]
    ~ raise(aff_seoha, 2)
    칭찬은 몇 번을 들어도 좋네요 :)
* [서하 씨 부스가 제일 예뻤어요]
    ~ raise(aff_seoha, 3)
    …가게 칭찬이 제일 좋아요. 저 칭찬하는 거보다요.
    아 이건 비밀이었는데 :)
* [오늘 고생 많았어요]
    ~ raise(aff_seoha, 2)
    고생은요. 오늘은 재밌었어요. 진짜로요.
- # note: 3월 13일
장터가 끝났다. 옷에서 커피 냄새가 난다.
# dayend
-> seoha_d06


// ════════════════════════════════
// D6 — 3월 14일 토요일: 주말 알바
// ════════════════════════════════
=== seoha_d06 ===
# day: 6
# time: 08:30
# note: 3월 14일
구름 조금. 토요일이다. 회사 다닐 땐 토요일이 제일 짧았다.
# room: seoha
좋은 아침이에요.
염치없는 부탁 하나 해도 돼요?
# typing: 2
주말엔 손님이 너무 많아서요. 오늘 하루만 가게 좀 도와줄 수 있어요?
설거지랑 서빙이요. 수고비는… 커피 무제한 :)
* [갈게요 # draft: 갈게요 ㅎㅎ]
    ~ raise(aff_seoha, 2)
    살았다 :)
    # note: 3월 14일
    "ㅎㅎ"를 쳤다가 지웠다. 버릇이다. 지우고 나니 너무 딱딱해 보여서 한참 쳐다봤다.
* [커피 말고 그냥 갈게요 # say: 수고비는 괜찮아요. 그냥 갈게요.]
    ~ raise(aff_seoha, 3)
    …그럼 제가 더 미안한데요.
    점심은 제가 살게요. 이건 협상 불가예요 :)
* [시급 주시면 갈게요 ㅎㅎ]
    ~ raise(aff_seoha, 1)
    ㅎㅎ 최저시급에 커피 무제한 추가요. 협상 끝.
- # plan: seoha_parttime, 6, 10:00, 오후세시 주말 알바
# memo: seoha
부탁할 때 "염치없는"을 붙인다. 부탁을 잘 못 하는 사람이다.
-> work

= work
# time: 10:00
# scene: bg_cafe_day_01 # at: cafe, 주말 알바
토요일 열 시. 문을 열자마자 손님 셋이 따라 들어온다.
# cut: seoha_scene_apron_01 # from: seoha
이거 매요. 제 여분 앞치마예요.
갈색 캔버스 앞치마. 그녀 것과 똑같다. 끈을 등 뒤로 돌리다가 헤맨다.
# from: seoha
…이리 와 봐요.
그녀가 등 뒤에서 끈을 묶는다. 매듭이 단단하다. 은팔찌가 한 번 등에 닿는다.
(설거지를 하러 온 건데, 설거지보다 이게 더 어렵다.)
# cut: bg_cafe_day_01
점심이 지나자 우유 스팀을 배운다. 첫날 내가 고친 그 노즐이다.
# cut: mc_cg_pitcher_01 # from: seoha
피처를 조금 기울이고요. 소리 들어 봐요. 치익— 말고 쓰읍— 소리.
세 번째 잔에서 처음으로 하트를 그린다. 하트라기보다는 감자에 가깝다.
# from: seoha
ㅎㅎ 감자다. 귀엽다. 손님한테 나가도 돼요, 이건.
창가 자리의 할머니 손님이 감자 라떼를 받아 들고 나를 한참 본다.
# as: 할머니 손님
사장님, 남편분이에요?
# cut: seoha_face_surprised_01
그녀가 들고 있던 피처를 떨어뜨릴 뻔한다.
* [아 네 네… 아니 아니요! # say: 아 네 네… 아니, 아니요! 알바생이에요!]
    ~ raise(aff_seoha, 2)
    # cut: seoha_face_smile_01 # from: seoha
    풉. 아 네 네가 뭐예요 ㅎㅎ
    (당황하면 나오는 버릇을 이 사람 앞에서 들켰다.)
* [알바생이에요]
    ~ raise(aff_seoha, 1)
    # from: seoha
    네, 오늘 하루 빌린 알바생이에요 :)
* [서하 씨가 대답하게 두기 # act]
    ~ raise(aff_seoha, 2)
    # cut: seoha_face_shy_01 # from: seoha
    …오늘 하루 빌린 사람이에요.
    (빌린 사람. 그 말이 이상하게 오래 남는다.)
- # time: 15:00
# cut: seoha_face_smile_01 # from: seoha
세 시다. 우리 쉬어요.
오후 세시. 손님이 딱 끊긴다. 그녀가 창가 자리에 커피 두 잔을 내려놓는다.
# from: seoha
가게 이름이 왜 오후세시인지 알아요?
# from: seoha
오후 세시가 제일 좋아하는 시간이라서요. 점심은 지나고, 저녁은 아직이고. 아무것도 안 해도 되는 시간.
# from: seoha
프랜차이즈 점장 할 때는 그런 시간이 없었어요. 그래서 제 가게 이름으로 만들어 버렸어요.
* [저도 지금 그런 시간이에요 # say: 저도 지금 그런 시간인 것 같아요. 회사는 끝났고, 다음은 아직이고.]
    ~ raise(aff_seoha, 3)
    # cut: seoha_face_surprised_01 # from: seoha
    …그럼 지금 둘 다 오후 세시네요.
* [좋은 이름이에요]
    ~ raise(aff_seoha, 1)
    # from: seoha
    그쵸? 손님들은 3시에만 여는 줄 알아요 ㅎㅎ
- # from: seoha
언젠가는 원두도 직접 볶고 싶어요. 제 가게 원두로 봄 메뉴를 만드는 게 꿈이에요.
# from: seoha
근데 로스터는 너무 비싸서요. 꿈은 공짜라 다행이죠 :)
# scene: end
# memo: seoha
오후 세시가 제일 좋아하는 시간이라서 가게 이름이 오후세시. 원두를 직접 볶는 게 꿈. 로스터가 너무 비싸다.
-> snap

= snap
# time: 17:30
# post: seoha_p3 # from: seoha # photo: mc_cg_pitcher_01
주말엔 든든한 (?) 알바생이 있어요 :) 오늘의 라떼아트는 감자입니다
# comment: seoha_p3 # from: ian
헐 이 손 누구 손인지 알 것 같다 ㅋㅋㅋ
# comment: seoha_p3 # from: halmeoni
잘생긴 손
# ask: 오후세시 게시물
* [좋아요 # like: seoha_p3]
    ~ raise(aff_seoha, 1)
* [댓글: (?)는 왜 붙어요 # comment: seoha_p3 # say: (?)는 왜 붙어요 ㅋㅋ]
    ~ raise(aff_seoha, 3)
    # comment: seoha_p3 # from: seoha
    라떼아트가 아직 감자라서요 :)
* [넘기기]
- -> night_msg

= night_msg
# time: 21:40
# room: seoha
오늘 진짜 고마웠어요.
주말 매출 최고 기록이에요. 감자 라떼가 세 잔이나 나갔어요 :)
# typing: 3
그리고… 다음 주에 건물주 사모님이 오신대요.
재계약 얘기요. 삼 년 됐거든요.
좀 무섭네요 :)
* [무서우면 무섭다고 해도 돼요]
    ~ raise(aff_seoha, 3)
    # wait: 3
    …네. 무서워요.
    말하고 나니까 조금 덜 무섭네요. 이상하다.
* [같이 있어 줄까요?]
    ~ raise(aff_seoha, 2)
    아니에요, 그건 제가 해야 하는 거예요.
    그래도 그렇게 말해 줘서 고마워요.
* [잘 될 거예요]
    …그럴까요 :)
- # typing: 2
아 그리고 부탁 하나만 더요. 염치없는 거 두 번째.
첫날 찍은 기계 사진 있잖아요. 김 뿜는 거.
그거 보내 줄 수 있어요? 프사 하고 싶어서요.
* [사진 보내기 # attach: seoha_cg_machine_fixed_01]
    ~ raise(aff_seoha, 3)
    이거다 :)
    그날 기계가 살아났으니까요. 가게도 같이요.
* [왜 그 사진이에요?]
    ~ raise(aff_seoha, 1)
    그날 기계가 살아났으니까요. 가게도 같이요.
    * * [사진 보내기 # attach: seoha_cg_machine_fixed_01]
        ~ raise(aff_seoha, 2)
        고마워요 :)
- # memo: seoha
첫날 내가 찍은 기계 사진을 달라고 했다. "기계가 살아난 날, 가게도 같이."
-> night

= night
# time: 22:20 # at: home
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {not k_breaker} [비만 오면 차단기가 내려갈 때 # watch: breaker]
        -> video_breaker ->
    * * {not k_grinder} [그라인더가 윙 소리만 날 때 # watch: grinder]
        -> video_grinder ->
    * * [썸 탈 때 답장은 몇 분 뒤에? # watch: timing]
        -> video_timing ->
    * * [그만 보기]
    - - -> close
* [서하 씨에게 한 번 더 연락하기 # act]
    # room: seoha
    # from: me
    오늘 앞치마 매 준 거, 고마웠어요.
    ~ raise(aff_seoha, 2)
    # wait: 2
    ㅎㅎ 그게 제일 고마웠어요?
    …저도 좀 떨렸어요. 남의 앞치마 매 준 거 처음이라서요 :)
    -> close
* [일찍 자기 # act]
    # note: 3월 14일
    발바닥이 아프다. 서 있는 일이 이렇게 힘든 줄 몰랐다. 그 사람은 삼 년을 서 있었다.
    -> close

= close
# dayend
-> seoha_d07


// ════════════════════════════════
// D7 — 3월 15일 일요일: 로스터, 그리고 길치
// ════════════════════════════════
=== seoha_d07 ===
# day: 7
# time: 09:10
# note: 3월 15일
맑음. 망원살이 알림이 왔다.
# town: t_roaster, 나눔, 카페 두 번째 봄
[나눔] 소형 커피 로스터 (고장) 가져가실 분
# town: t_roaster
3년 했던 가게를 정리합니다. 로스터는 작년부터 안 켜져요.
# town: t_roaster
고칠 수 있는 분이 가져가 주시면 좋겠어요. 오늘 오후 5시까지 가게 앞에 둘게요.
# townreply: t_roaster, 망원 커피러버
헐 두 번째 봄 문 닫아요?ㅠㅠ
# townreply: t_roaster, 카페 두 번째 봄
네… 월세가 너무 올라서요. 그동안 감사했어요.
# pin: spring
# note: 3월 15일
{d03_cafe: "로스터는 너무 비싸서 꿈만 꾸지만요." 서하 씨가 두 번 한 말이다.|"로스터는 너무 비싸서요. 꿈은 공짜라 다행이죠." 어제 서하 씨가 한 말이다.}
# ask: 망원살이 나눔 글
* [댓글: 제가 가져가도 될까요? # town: t_roaster # say: 제가 가져가도 될까요? 고쳐 보고 싶어요.]
    ~ f_seoha_roaster = true
    # townreply: t_roaster, 카페 두 번째 봄
    네! 4시쯤 오세요. 무거워요 ㅎㅎ
    # plan: roaster_pickup, 7, 16:00, 로스터 가지러 · 카페 두 번째 봄
* [그냥 넘기기]
    # note: 3월 15일
    고장 난 로스터. 내가 고칠 수 있을 리가 없다. 화면을 껐다.
- -> lost

= lost
# time: 13:30 # wait: 1
# call: seoha
* [받기 # answer]
    …저기요. 저 지금 어디 있는지 모르겠어요 :)
    # from: me
    네?
    딸기 도매로 사러 나왔는데요, 골목을 몇 번 돌았더니 여기가 어딘지 모르겠어요.
    딸기 3킬로 들고 있어요. 팔이 떨어질 것 같아요 :)
    # from: me
    주변에 뭐 보여요?
    음… 은행나무요. 그리고 빨간 우체통. 땅 밑에서 기차 소리가 나요.
    # narr
    (땅 밑에서 기차 소리. 은행나무. 우체통. 지도 앱을 연다.)
    # call: end
    -> find
* [거절 # decline]
    # room: seoha
    # wait: 2
    바쁘구나 :)
    저 길을 잃었는데요, 괜찮아요. 딸기랑 같이 헤매는 중이에요.
    은행나무랑 빨간 우체통 있고, 땅 밑에서 기차 소리가 나요.
    ~ raise(aff_seoha, -1)
    -> find

= find
# ask: 서하 씨는 어디에 있을까?
* [망원역 # go: station]
    -> found_right
* [망원시장 # go: market]
    -> found_wrong
* [골목 편의점 # go: cvs]
    -> found_wrong

= found_right
# time: 13:50
# scene: bg_station_day_01 # at: station, 서하 씨 찾기
망원역 1번 출구. 은행나무 아래 빨간 우체통 옆에, 딸기 상자를 끌어안은 사람이 서 있다.
# cut: seoha_scene_strawberry_01 # from: seoha
…어떻게 찾았어요?
# from: me
땅 밑에서 기차 소리 난다면서요.
# cut: seoha_face_smile_01 # from: seoha
천재다. 이안 씨가 맨날 그러던데, 진짜네.
~ raise(aff_seoha, 4)
-> walk_back

= found_wrong
# time: 14:20
# scene: bg_mangwon_alley_day_01 # at: station, 서하 씨 찾기
시장 쪽을 한참 헤맸다. 은행나무가 너무 많다. 다시 전화를 걸어서야 깨닫는다. 땅 밑의 기차는 지하철이다.
# cut: seoha_scene_strawberry_01 # from: seoha
ㅎㅎ 둘 다 길치네요.
망원역 1번 출구 앞, 딸기 상자를 끌어안은 사람이 웃고 있다.
~ raise(aff_seoha, 2)
-> walk_back

= walk_back
그녀 손에서 상자를 받아 든다. 딸기 냄새가 확 올라온다.
돌아가는 길, 그녀가 내 후드 소매 끝을 살짝 쥔다.
# from: seoha
또 길 잃을까 봐서요. …핑계예요.
* [계속 잡고 있어요]
    ~ raise(aff_seoha, 3)
    # cut: seoha_face_shy_01 # from: seoha
    …네.
    가게까지 가는 동안 그녀는 소매를 놓지 않는다. 한 번도 길을 잘못 들지 않는다. 내가 앞장섰으니까.
* [농담으로 넘기기 # say: 소매 늘어나요 ㅎㅎ]
    ~ raise(aff_seoha, 1)
    # from: seoha
    ㅎㅎ 알았어요, 놓을게요.
    (놓았다. 놓고 나니 조금 아쉽다.)
- # scene: end
# memo: seoha
확실한 길치. 땅 밑에서 기차 소리가 난다는 식으로 길을 설명한다.
{f_seoha_roaster: -> pickup | -> sunday_night}

= pickup
# time: 16:00
# scene: bg_spring_cafe_01 # at: spring, 로스터 나눔
합정 쪽 끝. 셔터가 반쯤 내려간 카페 "두 번째 봄". 가게 앞에 검은 쇳덩이 하나가 놓여 있다.
사장님은 사십 대쯤 된 여자다. 앞치마를 벗어 개고 있다.
# as: 두 번째 봄 사장
가져가시는 분이에요? 무거워요. 조심하세요.
# as: 두 번째 봄 사장
3년 버텼어요. 월세가… 두 번 오르니까 못 버티겠더라고요.
# as: 두 번째 봄 사장
이거 켜지면 사진 한 장만 보내 주세요. 그럼 좀 덜 억울할 것 같아요.
# cut: mc_cg_roaster_01
로스터를 끌어안는다. 차갑고 무겁다. 드럼 안에서 오래된 원두 껍질이 달그락거린다.
(3년 버틴 가게의 기계. 오후세시도 3년이다.)
# scene: end
# gallery: mc_cg_roaster_01
# todo: roaster, 로스터 살리기 (히터 → 벨트 → 온도 센서)
# note: 3월 15일
로스터를 방에 들였다. 방이 반으로 줄었다.
# ask: 로스터 얘기, 서하 씨한테 할까?
* [바로 말하기 # act]
    # room: seoha # time: 18:20
    # from: me
    서하 씨, 오늘 로스터가 생겼어요. 고장 난 거지만요.
    # photo: mc_cg_roaster_01
    # from: me
    두 번째 봄 사장님이 나눔 하셨어요
    ~ raise(aff_seoha, 3)
    # wait: 5
    …네?
    이거 저 주려고요?
    # typing: 3
    못 고쳐도 돼요. 진짜로요. 가져온 것만으로도, 저 지금 좀 울 것 같아요 :)
* [고칠 때까지 비밀로 하기 # act]
    ~ f_seoha_secret = true
    # note: 3월 15일
    말하지 않기로 했다. 고치지 못하면, 그 사람은 꿈을 한 번 더 잃는 거니까.
- -> sunday_night

= sunday_night
# time: 21:30
# post: seoha_p4 # from: seoha # photo: seoha_cg_strawberry_01
봄 메뉴 준비 중 🍓 딸기 3kg를 들고 길을 잃었다가 구조됐습니다
# time: 22:10 # at: home
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {f_seoha_roaster && not k_roaster} [소형 로스터 살리기 ① 히터와 벨트 # watch: roaster]
        -> video_roaster ->
    * * {not k_breaker} [비만 오면 차단기가 내려갈 때 # watch: breaker]
        -> video_breaker ->
    * * {not k_timing} [썸 탈 때 답장은 몇 분 뒤에? # watch: timing]
        -> video_timing ->
    * * [그만 보기]
    - - -> close
* [서하 씨에게 연락하기 # act]
    # room: seoha
    # from: me
    딸기는 무사해요?
    ~ raise(aff_seoha, 2)
    네 ㅎㅎ 한 알도 안 떨어뜨렸어요. 구조대 덕분에요.
    오늘 소매 잡은 거요. 핑계였던 거 알죠? :)
    -> close
* [일찍 자기 # act]
    -> close

= close
# dayend
-> seoha_d08


// ════════════════════════════════
// D8 — 3월 16일 월요일 (휴무): 월세
// ════════════════════════════════
=== seoha_d08 ===
# day: 8
# time: 10:00
# note: 3월 16일
흐림. 월요일은 오후세시 휴무다. 오늘은 아침 메시지가 없다. 요즘은 매일 왔는데.
# town: t_rumor, 동네생활, 망원 커피러버
오후세시 문 닫는다는 얘기 들으신 분?
# town: t_rumor
어제 건물주분이랑 사장님이 오래 얘기하시던데… 월세 엄청 올렸다는 소문이
# townreply: t_rumor, 떡집 단골
두 번째 봄도 그렇게 닫았잖아요ㅠ
# townreply: t_rumor, 망원토박이
오후세시까지 없어지면 이 골목 진짜 쓸쓸해짐
# time: 13:50
# room: seoha
오늘 건물주 사모님 만났어요.
# typing: 2
월세를 40% 올리시겠대요.
# typing: 2.5
지금 계산기 두드리고 있어요 :)
* [지금 갈게요]
    ~ raise(aff_seoha, 3)
    # wait: 3
    …네.
    문 잠겨 있어요. 두 번 두드려요.
    -> closed_cafe
* [괜찮아요?]
    ~ raise(aff_seoha, 1)
    # wait: 4
    괜찮아요 :)
    # note: 3월 16일
    ":)"가 붙어 있다. 오늘은 그게 웃는 얼굴로 안 보인다. 가 보기로 했다.
    -> closed_cafe
* [제가 건물주한테 얘기해 볼까요?]
    ~ raise(aff_seoha, -3)
    # wait: 5
    …고마운데요, 그건 아니에요.
    그건 제 가게 일이에요.
    # note: 3월 16일
    할 수 없는 일을 할 수 있다고 했다. 회사에서 삼 년 동안 하던 말투가 그대로 나왔다.
    -> closed_cafe

= closed_cafe
# time: 14:30
# scene: bg_cafe_closed_day_01 # at: cafe, 휴무일
문을 두 번 두드린다. 블라인드가 내려진 오후세시. 의자들이 테이블 위에 거꾸로 올라가 있다.
# cut: seoha_scene_calculator_01 # from: seoha
들어와요. 의자 하나 내릴게요.
카운터 위에 계산기, 영수증 뭉치, 은행 앱이 켜진 휴대폰. 그녀의 은팔찌가 계산기 옆에 풀려 있다.
# from: seoha
보증금은 그대로, 월세만 40%. 대출이 아직 남았고요.
# from: seoha
계산해 보니까 딸기 라떼를 하루에 백팔십 잔 팔아야 해요. 저 혼자서요 :)
(웃으면서 말한다. 그래서 더 아프다.)
* [월세는 제가 못 고쳐요 # say: 월세는 제가 못 고쳐요. 근데 계산은 같이 할 수 있어요.]
    ~ raise(aff_seoha, 5)
    # cut: seoha_face_surprised_01 # from: seoha
    …
    # from: seoha
    처음이에요. 괜찮을 거라고 안 하는 사람.
    # from: seoha
    다들 괜찮을 거래요. 그 말 들을 때마다 제가 안 괜찮은 게 제 잘못 같았어요.
* [제가 어떻게든 해 볼게요]
    ~ raise(aff_seoha, -3)
    # from: seoha
    …그 말, 광고 회사에서 많이 했죠?
    # narr
    (정곡이다.)
* [영수증 같이 정리하기 # act]
    ~ raise(aff_seoha, 3)
    아무 말 없이 영수증을 날짜순으로 정리한다. 그녀가 한참 보다가, 계산기를 내 쪽으로 민다.
    # from: seoha
    …그럼 더하기 담당 해요.
- 두 시간 동안 숫자를 더하고 뺀다. 결론은 같다. 이대로는 안 된다.
{f_seoha_truth: -> after_numbers}
# from: seoha
근데 왜 그만뒀어요? 회사요. 말 잘하는 사람이었다면서요.
* [솔직하게 말하기 # say: "할 수 있습니다"만 삼 년 했어요. 못 하는 것도요. 어느 날 회의실에서 그 말이 목에 걸려서 안 나왔어요.]
    ~ raise(aff_seoha, 4)
    ~ f_seoha_truth = true
    # cut: seoha_face_neutral_01 # from: seoha
    …그래서 첫날 처음 봤다고 한 거구나.
    # from: seoha
    그 말 한마디에 제가 왜 그렇게 웃었는지 이제 알겠어요. 저도 삼 년 동안 괜찮다고만 했거든요.
* [그냥 지쳐서요]
    # from: seoha
    그렇죠. 다들 그냥 지치죠.
- -> after_numbers

= after_numbers
# cut: seoha_face_pout_01 # from: seoha
여기까지인가 봐요.
그녀가 은팔찌를 다시 찬다. 딸깍, 작은 소리가 난다.
# scene: end
# event: rent_answer, 13, 재계약 답변 (오후세시)
# memo: seoha
건물주가 월세를 40% 올린다고 했다. 답변은 토요일(21일)까지. 괜찮을 거라는 말을 싫어한다.
-> night

= night
# time: 20:30
# post: seoha_p5 # from: seoha # photo: seoha_cg_empty_cafe_01
3년.
# ask: 오후세시 게시물
* [좋아요 # like: seoha_p5]
    ~ raise(aff_seoha, 1)
* [댓글: 오후 세시에 또 올게요 # comment: seoha_p5 # say: 오후 세시에 또 올게요.]
    ~ raise(aff_seoha, 3)
* [넘기기]
- # time: 22:10
# room: seoha
오늘 고마웠어요.
# typing: 3
사실 가게 접으면 뭐 할지 생각해 봤는데요.
아무것도 생각이 안 나요. 여기 말고는.
* [같이 생각해 봐요]
    ~ raise(aff_seoha, 4)
    …같이요?
    네. 같이 하면 조금 덜 무섭겠네요 :)
* [여기를 지켜요 # say: 여기 말고는 없으면, 여기를 지켜요.]
    ~ raise(aff_seoha, 3)
    …쉽게 말한다 :)
    # typing: 2
    근데 그 쉬운 말이 오늘은 필요했어요.
* [뭐든 할 수 있어요]
    ~ raise(aff_seoha, 1)
    ㅎㅎ 고마워요.
- # ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {f_seoha_roaster && not k_roaster} [소형 로스터 살리기 ① 히터와 벨트 # watch: roaster]
        -> video_roaster ->
    * * {f_seoha_roaster && k_roaster && not k_roaster2} [소형 로스터 살리기 ② 온도 센서 # watch: roaster2]
        -> video_roaster2 ->
    * * {not k_breaker} [비만 오면 차단기가 내려갈 때 # watch: breaker]
        -> video_breaker ->
    * * [그만 보기]
    - - -> close
* {f_seoha_roaster} [로스터 뜯어 보기 # act]
    # note: 3월 16일
    로스터 뚜껑을 열었다. 먼지와 원두 껍질. 히터 선 하나가 까맣게 끊어져 있다. 뭘 모르는지는 알겠다. 그게 어디냐.
    -> close
* [일찍 자기 # act]
    -> close

= close
# dayend
-> seoha_d09


// ════════════════════════════════
// D9 — 3월 17일 화요일 (비): 정전, 촛불
// ════════════════════════════════
=== seoha_d09 ===
# day: 9
# time: 09:40
# note: 3월 17일
비. 저녁부터 강풍 예보. 창문이 덜컹거린다.
# room: seoha
좋은 아침이에요.
어제는 제가 좀 이상했죠 :)
오늘은 문 열어요. 비 오는 날은 손님이 적은데, 오는 손님은 오래 있어요.
{aff_seoha >= 50: 혹시 지금 바빠요? 아 아니다, 바쁘겠지. 그냥 비 온다고요 :)}
* [비 오는 날 커피 좋죠]
    ~ raise(aff_seoha, 1)
    그쵸? 오늘은 핸드드립 하는 날이에요.
* [오늘 가게 갈게요]
    ~ raise(aff_seoha, 2)
    ㅎㅎ 알바생 출근이요?
    오늘은 손님으로 와요. 비 오는 날은 손님이 귀하거든요.
- {f_seoha_roaster: -> roaster_day | -> storm}

= roaster_day
# time: 13:00
# scene: bg_mc_room_day_01 # at: home, 로스터 수리
방바닥에 신문지를 깔고 로스터를 눕힌다. 비 소리가 배경 음악이다.
{ roaster_step >= 1:
    영상에서 본 대로 테스터기를 댄다. 끊긴 히터 선을 찾아 새 선을 잇는다. 벨트는 늘어나 있다. 대성철물에 전화해 같은 규격을 주문한다.
    # fx: zoom
    전원을 넣자 히터가 붉게 달아오른다. 드럼은 아직 안 돈다. 반은 살았다.
- else:
    나사를 풀고, 다시 조이고, 사진을 찍고, 다시 푼다. 무엇이 고장인지 모르는 채로 한 시간.
    (모르는 걸 모른다고 하는 건 배웠다. 모르는 걸 아는 걸로 만드는 건 아직이다.)
}
# scene: end
-> storm

= storm
# time: 19:40
# room: seoha
비가 너무 와서 일찍 닫았어요.
# typing: 2
그리고 정전 됐어요 :)
# typing: 2.5
가게 안이 깜깜해요. 촛불 켰어요. 무서운 건 아니고요 :)
* [지금 갈게요]
    ~ raise(aff_seoha, 3)
    …빗길 조심해서 와요.
* [차단기 내려간 거 아니에요?]
    ~ raise(aff_seoha, 1)
    차단기가… 어디 있는지 몰라요 :)
    # note: 3월 17일
    차단기가 어디 있는지 모른다고 했다. 우산을 챙겼다.
- -> candle

= candle
# time: 20:05
# scene: bg_cafe_night_01 # at: cafe, 정전
골목의 가로등은 멀쩡하다. 오후세시만 깜깜하다.
유리문 너머로 작은 불빛 두 개가 흔들린다.
# cut: seoha_scene_candle_01 # from: seoha
왔어요? 젖었네. 이리 와요, 수건.
창가 테이블에 촛불 두 개. 창문에 빗줄기가 흘러내린다. 그녀가 수건으로 내 머리를 툭툭 턴다.
{ k_breaker || read("오후세시 (에스프레소 머신)") || f_book_read:
    -> breaker_known
- else:
    -> breaker_unknown
}

= breaker_known
(골목은 멀쩡하고 이 가게만 꺼졌다. 비 오면 내려가는 차단기 2번 칸. 사장님 수첩에 적혀 있던 그대로다.)
# from: me
차단기 어디 있는지 알 것 같아요. 2번 칸이요.
# cut: seoha_face_surprised_01 # from: seoha
…그걸 어떻게 알아요?
# from: me
사장님 수첩에 있었어요. "비 오면 내려감. 놀라지 않게 미리 말해 둘 것."
# from: seoha
…사장님은 그런 것까지 적어 두셨구나.
~ raise(aff_seoha, 2)
창고 안쪽 벽의 회색 상자. 2번 스위치가 내려가 있다.
* [바로 올린다]
    # fx: zoom
    딸깍. 가게 안 전등이 한꺼번에 켜진다. 촛불이 갑자기 초라해진다.
    # from: seoha
    아… 벌써요?
    (그녀가 웃는다. 조금 아쉬운 얼굴로.)
    # from: seoha
    …다시 끌까요? ㅎㅎ 농담이에요.
    그녀가 전등을 끈다. 농담이 아니었다.
* [조금 이따가 올린다 # say: …조금만 이따가 올려도 될까요.]
    ~ raise(aff_seoha, 3)
    # cut: seoha_face_shy_01 # from: seoha
    …네. 저도 그 말 하려고 했어요.
- -> talk

= breaker_unknown
# from: seoha
차단기가 어디 있는지 모르겠어요. 삼 년 동안 한 번도 안 열어 봤어요 :)
둘이 휴대폰 손전등을 들고 창고를 뒤진다. 못 찾는다. 결국 비가 그치면 찾기로 한다.
# from: seoha
그럼 그동안은, 촛불이요.
-> talk

= talk
# cut: seoha_scene_candle_01
창가에 마주 앉는다. 촛불이 그녀 얼굴 아래쪽을 비춘다.
# from: seoha
프랜차이즈 점장일 때요. 하루에 백 명을 만나도 대화는 한 번도 안 할 때가 있었어요.
# from: seoha
여기 와서도 비슷해요. 손님은 많은데, 가게 문 닫고 나면 제 말을 들을 사람이 없어요.
# from: seoha
그래서 마감하고 폰 보는 시간이 좋았어요. 요즘은. 누가 답장을 해 주니까.
* [저도 그 시간이 좋았어요 # say: 저도 그 시간 기다렸어요. 서하 씨 긴 메시지 오는 시간.]
    ~ raise(aff_seoha, 3)
    # cut: seoha_face_shy_01 # from: seoha
    …길게 쓰는 거 알고 있었어요? 부끄럽네.
* [제 얘기도 해도 돼요? # say: 저도 무서운 거 하나 말해도 돼요?]
    ~ raise(aff_seoha, 3)
    # from: seoha
    그럼요.
    # from: me
    회사를 그만뒀는데, 다음이 없어요. 하고 싶은 게 없는 게 아니라, 해도 되는 게 뭔지 모르겠어요.
    # from: seoha
    …오후 세시네요. 아까 말한 거.
    # from: seoha
    그 시간에 뭘 해야 하는지 모르는 사람이 제일 오래 앉아 있다 가요. 저는 그 손님들이 제일 좋아요.
- 촛불 하나가 흔들린다. 둘이 동시에 손을 뻗어 바람을 막는다. 손등이 닿는다.
* [손을 잡는다 # act]
    ~ raise(aff_seoha, 4)
    ~ f_seoha_hand = true
    그녀의 손이 차갑다. 잠깐 굳었다가, 손가락이 천천히 풀린다. 은팔찌가 내 손목에 닿는다.
    # from: seoha
    …손 따뜻하다.
* [손을 뺀다 # act]
    # from: seoha
    ㅎㅎ 뜨거웠어요?
    (뜨거웠던 건 촛불이 아니었다.)
- # fade
빗소리만 남는다. 촛불이 짧아질 때까지 우리는 창가에 앉아 있었다.
# scene: end
-> night

= night
# time: 23:30 # at: home
# note: 3월 17일
{f_seoha_hand: 손을 잡았다. 아니, 잡혔다. 어느 쪽이었는지 모르겠다.|촛불이 다 탈 때까지 이야기했다. 손은 잡지 못했다.}
-> jeju_offer ->
# dayend
-> seoha_d10


// ════════════════════════════════
// D10 — 3월 18일 수요일 (갬): 사장님의 전화
// ════════════════════════════════
=== seoha_d10 ===
# day: 10
# time: 08:10
# room: seoha
어제… 고마웠어요.
촛불이 다 탔어요 :)
{f_seoha_hand: 손이 아직 따뜻한 것 같아요. 이런 말 해도 되나 모르겠지만요.}
* [저도요]
    ~ raise(aff_seoha, 2)
    …네 :)
* [오늘은 전기 잘 들어와요?]
    ~ raise(aff_seoha, 1)
    네 ㅎㅎ 오늘은 기계들이 다 착해요.
- {not k_jeju: -> jeju_again | -> call}

= jeju_again
# time: 10:30 # at: home
-> jeju_offer ->
-> call

= call
# time: 14:30 # wait: 1.5
# call: boss # unknown
* [받기 # answer]
    -> boss_call_open ->
    그래서, 오후세시 사장은 잘 있는가.
    # from: me
    …월세가 많이 오른대요. 가게를 접을지도 모르겠대요.
    …그렇구먼.
    그 집 사장, 처음 가게 열 때 기계 앞에서 울었어. 무서워서. 그래서 내가 천천히 알려 줬지.
    그 건물 사모님은 나랑 삼십 년 알았어. 말은 세도 정이 있는 사람이여.
    서하 사장한테 겁먹지 말고 가서 사정을 말하라 혀. 숫자만 말고. 그 가게가 뭔지를.
    { f_seoha_roaster:
        # from: me
        그리고… 제가 고장 난 로스터를 하나 얻었어요.
        로스터? 허허. 그건 히터 아니면 벨트여. 온도 센서는 맨 마지막에 봐. 센서 틀리면 원두 다 태워.
        ~ roaster_step = MIN(roaster_step + 1, 3)
        # narr
        (히터, 벨트, 그리고 센서. 튜브의 목요일 아저씨와 똑같은 순서다.)
    }
    -> boss_call_close ->
    -> after_call
* [거절 # decline]
    # voicemail: boss # unknown
    …여보세요. 만물수선 번호 쓰는 사람인가. 김용수여. 이 번호 전 주인.
    # voicemail: boss # unknown
    바쁜가 보네. 오후세시 사장 소식 들었어. 그 건물 사모님, 나랑 삼십 년 알았어. 말은 세도 정이 있는 사람이여.
    # voicemail: boss # unknown
    서하 사장한테 겁먹지 말고 가서 사정을 말하라고 혀. 숫자만 말고, 그 가게가 뭔지를.
    { f_seoha_roaster:
        # voicemail: boss # unknown
        로스터 얻었다며. 히터 아니면 벨트여. 센서는 맨 마지막.
        ~ roaster_step = MIN(roaster_step + 1, 3)
    }
    # voicemail: boss # unknown
    고치는 건 기술이 아니라 끈기여. 그 번호, 잘 부탁혀.
    # note: 3월 18일
    모르는 번호, 064. 제주 지역번호다. 음성사서함에 긴 메시지가 남았다.
    -> after_call

= after_call
# time: 16:20
# room: seoha
* [사장님 말 전하기 # say: 서하 씨, 방금 김 사장님이 전화하셨어요. 제주에서요.]
    ~ f_seoha_advice = true
    ~ raise(aff_seoha, 2)
    # wait: 2
    사장님이요?? 진짜요?
    뭐라고 하셨어요?
    * * [건물주 사모님 얘기 # say: 건물주 사모님이랑 삼십 년 아신 사이래요. 겁먹지 말고 가서 사정을 말하래요. 숫자 말고, 이 가게가 뭔지를.]
        ~ raise(aff_seoha, 3)
        # typing: 3
        …
        사장님은 끝까지 사장님이네요.
        처음 가게 열 때 제가 기계 앞에서 울었거든요. 그때도 천천히 말하라고 하셨어요.
        …한번 제대로 말해 볼게요. 숫자 말고.
* [나중에 말하기 # act]
    # note: 3월 18일
    사장님 말을 전하지 못했다. 전해도 될지, 내가 뭔데 전하나 싶어서.
- -> night

= night
# time: 22:00 # at: home
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {f_seoha_roaster && not k_roaster} [소형 로스터 살리기 ① 히터와 벨트 # watch: roaster]
        -> video_roaster ->
    * * {f_seoha_roaster && not k_roaster2} [소형 로스터 살리기 ② 온도 센서 # watch: roaster2]
        -> video_roaster2 ->
    * * {not k_breaker} [비만 오면 차단기가 내려갈 때 # watch: breaker]
        -> video_breaker ->
    * * [그만 보기]
    - - -> close
* [서하 씨에게 연락하기 # act]
    # room: seoha
    # from: me
    오늘은 마감 잘 했어요?
    ~ raise(aff_seoha, 2)
    네 :)
    # typing: 3
    요즘 마감하고 나면 제일 먼저 이 방을 열어요. 오늘은 제가 먼저 보내려고 했는데, 졌네요.
    -> close
* [일찍 자기 # act]
    -> close

= close
# dayend
-> seoha_d11


// ════════════════════════════════
// D11 — 3월 19일 목요일 (흐림): 위기
// ════════════════════════════════
=== seoha_d11 ===
# day: 11
# time: 11:20
# room: seoha
본사에서 연락 왔어요. 예전 프랜차이즈요.
# typing: 2.5
지역 매니저로 다시 오래요. 월급도 괜찮고, 월세 걱정도 없고요.
# typing: 1.5
…좋은 제안이죠? :)
# note: 3월 19일
흐림. 좋은 제안이냐고 물었다. 물음표 뒤에 :)가 붙어 있다.
* [좋은 제안이네요]
    # wait: 4
    그쵸.
    ~ raise(aff_seoha, -1)
* [서하 씨는 어때요? # say: 서하 씨는 그 제안이 좋아요?]
    ~ raise(aff_seoha, 2)
    # wait: 5
    …모르겠어요.
    좋은 게 뭔지 모르겠어요. 요즘.
- # time: 13:10
# post: seoha_p6 # from: seoha # photo: seoha_cg_notice_01
[안내] 오후세시는 3월 31일까지 영업합니다. 그동안
# time: 13:20
# unpost: seoha_p6
# note: 3월 19일
스냅에 오후세시 공지가 올라왔다. "3월 31일까지 영업합니다." 문장이 끝나기도 전에 올라온 글은, 10분 뒤에 지워졌다.
# time: 15:00
# room: seoha
{player_name} 씨는 어떻게 생각해요?
# typing: 2
…아니다. 이건 제가 정해야죠.
신경 쓰지 마요 :)
# note: 3월 19일
오후 세시. 그 사람이 제일 좋아하는 시간에, 신경 쓰지 말라는 메시지가 왔다.
# ask: 어떻게 할까?
* [서하 씨가 정한 거면 응원할게요 # act]
    # room: seoha
    # from: me
    서하 씨가 정한 거면 응원할게요.
    # wait: 6
    고마워요 :)
    # note: 3월 19일
    응원한다고 했다. 좋은 말이다. 그런데 보내고 나니 도망친 것 같다. 내 마음은 한 줄도 안 썼으니까.
    -> night_alone
* [가게로 간다 # act]
    ~ f_seoha_stay = true
    -> go
* [읽고 넘기기 # act]
    ~ raise(aff_seoha, -3)
    # note: 3월 19일
    답하지 않았다. 내가 뭐라고 할 자리가 아닌 것 같았다. 그렇게 생각하기로 했다.
    -> night_alone

= go
# time: 21:05
# scene: bg_cafe_night_01 # at: cafe, 마감 뒤
마감 뒤의 오후세시. 불은 켜져 있고, 그녀는 카운터 안쪽 바닥에 앉아 있다.
# cut: seoha_face_surprised_01 # from: seoha
…왜 왔어요. 신경 쓰지 말라니까.
# from: me
신경 쓰여서 왔어요.
그녀 옆에 앉는다. 카운터 밑은 좁다. 어깨가 닿는다.
* [솔직하게 말한다 # say: 가게 접지 마요. 제가 뭘 할 수 있는지는 모르겠어요. 월세도 못 고치고요. 근데 오후세시가 없어지는 건 싫어요. 서하 씨가 여기 없는 것도요.]
    ~ raise(aff_seoha, 6)
    # cut: seoha_face_pout_01 # from: seoha
    …
    # from: seoha
    왜 그렇게 말해요.
    # from: seoha
    그렇게 말하면, 도망갈 데가 없어지잖아요.
    그녀가 무릎에 이마를 댄다. 은팔찌가 떨린다. 나는 아무 말도 하지 않는다. 할 말은 다 했다.
    # cut: seoha_face_shy_01 # from: seoha
    …사모님한테 가 볼게요. 토요일에. 숫자 말고, 이 가게가 뭔지 말하러.
    # from: seoha
    같이 가 줄 거죠? 옆에만 있어 주면 돼요.
* [서하 씨 편할 대로 해요 # say: 서하 씨 편할 대로 해요. 어느 쪽이든 괜찮아요.]
    ~ f_seoha_stay = false
    # from: seoha
    …어느 쪽이든 괜찮구나.
    # from: seoha
    고마워요. 와 줘서 :)
    (:)가 붙어 있다. 문을 나서고 나서야 알았다. 나는 여기까지 와서도 도망쳤다.
- # scene: end
{f_seoha_stay: -> roaster_night | -> night_alone}

= roaster_night
{f_seoha_roaster: -> roast | -> night_alone}

= roast
# time: 23:10
{ roaster_step >= 2:
    -> roast_success
- else:
    -> roast_fail
}

= roast_success
# scene: bg_cafe_night_01 # at: cafe, 로스터
{f_seoha_secret: 집에 뛰어가서 로스터를 안고 돌아온다. 그녀가 눈을 동그랗게 뜬다.|집에 뛰어가서 로스터를 안고 돌아온다. 사진으로만 보던 그 쇳덩이다.}
{f_seoha_secret: -> reveal}
-> fix

= reveal
# cut: seoha_face_surprised_01 # from: seoha
…이게 뭐예요?
# from: me
두 번째 봄에서 나눔 받은 로스터예요. 고치고 나서 말하려고 했는데, 오늘 고치려고요.
# from: seoha
…
~ raise(aff_seoha, 3)
# from: seoha
사람이 이렇게 몰래 좋은 짓을 해도 돼요?
-> fix

= fix
# cut: mc_cg_roaster_01
히터 선은 이미 이었다. 새 벨트를 끼운다. 드럼이 천천히 돈다.
마지막으로 온도 센서. 드럼 옆의 가는 금속 막대. 끝의 그을음을 닦고 헐거운 선을 조인다.
(히터, 벨트, 센서. 목요일 아저씨와 사장님이 똑같은 순서로 말했다.)
# fx: zoom
전원. 드럼이 돌고, 온도계 바늘이 천천히 올라간다.
# cut: seoha_scene_roast_01 # from: seoha
첫 배치는 버린다 생각하고요.
그녀가 생두를 붓는다. 이십 분 뒤, 첫 배치는 정말로 버린다. 새까맣다. 둘이 동시에 웃는다.
두 번째 배치. 원두가 타닥, 타닥 튀는 소리. 가게 안에 처음 맡아 보는 냄새가 가득 찬다.
# from: seoha
…이게 우리 가게 원두예요.
# from: seoha
{f_seoha_secret: 몰래 가져와서, 몰래 고치고, 이제 와서 우리 가게 원두라니. 반칙이에요 :)|못 고쳐도 된다고 했는데. 고쳐 버렸네요 :)}
~ f_seoha_roasted = true
~ raise(aff_seoha, 5)
# gallery: seoha_cg_roast_01
볶은 원두를 한 줌 쥐고 사진을 찍는다. 두 번째 봄 사장님께 보내야 한다.
# done: roaster
# scene: end
-> night_end

= roast_fail
# scene: bg_cafe_night_01 # at: cafe, 로스터
로스터를 가져와 전원을 넣는다. 히터는 달아오르는데 드럼이 돌지 않는다. 벨트를 만지다 손을 데인다.
# cut: seoha_face_pout_01 # from: seoha
괜찮아요. 오늘 안 돼도 괜찮아요. 가져와 준 걸로 충분해요.
(아직 모르는 게 있다. 영상 하나, 아니면 한 번의 끈기.)
# scene: end
# todo: roaster2, 로스터: 온도 센서까지 배우고 다시 해 보기
-> night_end

= night_alone
# time: 23:00 # at: home
# note: 3월 19일
불을 끄고 누웠다. 오후세시의 마지막 날이 3월 31일이라면, 남은 오후 세시는 열두 번이다.
-> night_end

= night_end
# dayend
-> seoha_d12


// ════════════════════════════════
// D12 — 3월 20일 금요일 (맑음, 춘분): 고백
// ════════════════════════════════
=== seoha_d12 ===
# day: 12
# time: 10:00
# note: 3월 20일
맑음. 춘분. 오늘부터 낮이 밤보다 길어진다고 뉴스가 말한다.
{f_seoha_stay: -> menu_post | -> quiet}

= menu_post
# post: seoha_p7 # from: seoha # photo: seoha_cg_strawberry_01
봄 메뉴 출시 D-2 🍓{menu_name == 1: 이름은 "오후세시의 봄"}{menu_name == 2: 이름은 "딸기가 먼저 온 오후"}{menu_name == 3: 이름은 그냥 딸기 라떼. 정직하게.}{menu_name == 0: 이름은 아직 고민 중}
# comment: seoha_p7 # from: ian
언니 1번은 저예요!!
# comment: seoha_p7 # from: choi
2번은 나 ㅋㅋ
-> invite

= quiet
# time: 11:00
# note: 3월 20일
오후세시 스냅은 조용하다. 어제 지운 공지 이후로 아무것도 올라오지 않았다.
-> invite

= invite
# time: 15:00
# room: seoha
{aff_seoha >= 75: 오늘 가게 일찍 닫을 건데.|오늘 가게 일찍 닫을 건데요.}
{aff_seoha >= 75: 올래?|오실래요? :)}
# note: 3월 20일
{aff_seoha >= 75: 처음으로 반말이다. 오후 세시에, 세 글자.|오후 세시에 온 메시지. 오늘은 일찍 닫는다고 했다.}
* {aff_seoha >= 75} [갈게]
    ~ raise(aff_seoha, 2)
    응. 강 쪽으로 와. 커피 들고 갈게.
* {aff_seoha < 75} [갈게요]
    ~ raise(aff_seoha, 2)
    네 :) 강 쪽에서 봬요. 커피는 제가 들고 갈게요.
* [무슨 일 있어요?]
    ~ raise(aff_seoha, 1)
    아무 일 없어요. 그냥 오늘은 노을 보고 싶어서요 :)
- # plan: seoha_sunset, 12, 18:40, 한강 노을 · 서하 씨
-> river

= river
# time: 18:40
# scene: bg_hanriver_dusk_01 # at: river, 춘분 노을
망원 한강공원. 강 건너 다리 불빛이 하나씩 켜지기 시작한다.
# cut: seoha_scene_river_01 # from: seoha
여기요.
벤치 위에 종이컵 두 개. 그녀가 사복을 입고 있다. 니트에 긴 치마. 앞치마가 없는 그녀는 처음이다.
# from: seoha
오늘 낮이랑 밤 길이가 같대요. 춘분이라서.
# from: seoha
오늘부터는 낮이 더 길어진대요. 그 말이 좋아서, 오늘 보자고 했어요.
노을이 강물 위로 번진다. 그녀가 컵을 두 손으로 감싼다.
# from: seoha
…나 요즘 오후 세시가 제일 좋아하는 시간이 아니에요.
# from: seoha
오후 세시에 누가 오나. 그 생각만 해서요.
* [좋아해요 # say: 서하 씨, 좋아해요.]
    ~ f_seoha_confess = true
    ~ raise(aff_seoha, 5)
* [저도 오후 세시가 좋아졌어요 # say: 저도 오후 세시가 좋아졌어요. 그 시간에 가면 서하 씨가 있어서요.]
    ~ f_seoha_confess = true
    ~ raise(aff_seoha, 5)
* [저도 그 가게 좋아해요]
    # cut: seoha_face_pout_01 # from: seoha
    …가게 말고요.
    그녀가 웃는다. 조금 서운한 얼굴로. 노을이 다 질 때까지 우리는 강만 본다.
    -> river_end
- { aff_seoha >= 70:
    # cut: seoha_face_shy_01 # from: seoha
    나도.
    # from: seoha
    …아 이거 반말로 하려고 한참 기다렸는데 ㅎㅎ
    그녀가 내 어깨에 머리를 기댄다. 종이컵 속 커피가 식어 간다. 아무도 마시지 않는다.
    그녀가 고개를 든다. 노을이 그녀 눈 속에 있다. 입술이 닿는다. 짧게, 커피 맛이 난다.
- else:
    # cut: seoha_face_surprised_01 # from: seoha
    …고마워요.
    # from: seoha
    조금만, 생각할 시간을 줄래요? 가게 일이 다 끝나면. 그때 제대로 대답하고 싶어요 :)
}
-> river_end

= river_end
# fade
강바람이 분다. 오늘부터 낮이 길어진다.
# scene: end
-> night

= night
# time: 22:30 # at: home
# room: seoha
{f_seoha_confess && aff_seoha >= 70: 오늘 집에 잘 들어갔어?|오늘 고마웠어요.}
{f_seoha_confess && aff_seoha >= 70: 나 지금 프사 바꿨어. 봐 봐.|노을 예뻤죠 :)}
* {f_seoha_confess && aff_seoha >= 70} [예쁘다 # say: 예쁘다. 노을도, 사진 고른 사람도.]
    ~ raise(aff_seoha, 2)
    내일 사모님 만나는 거, 옆에 있어 줘.
* {not (f_seoha_confess && aff_seoha >= 70)} [노을 예뻤어요]
    ~ raise(aff_seoha, 1)
    내일 사모님 만나요. 떨리네요 :)
- {f_seoha_stay && f_seoha_roaster && not f_seoha_roasted: -> roaster_study}
# dayend
-> seoha_d13

// 어젯밤 로스터가 돌지 않았다면, 재계약 전날 밤에 한 번 더 배울 수 있다 (D13 second_try)
= roaster_study
# time: 23:20
# note: 3월 20일
책상 위에 로스터가 있다. 어젯밤 돌지 않은 드럼. 내일은 재계약이고, 오후엔 시간이 난다.
# ask: 자기 전에
* [튜브로 로스터 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {not k_roaster} [소형 로스터 살리기 ① 히터와 벨트 # watch: roaster]
        -> video_roaster ->
    * * {not k_roaster2} [소형 로스터 살리기 ② 온도 센서 # watch: roaster2]
        -> video_roaster2 ->
    * * [그만 보기]
    - - { roaster_step >= 2:
            # note: 3월 20일
            히터, 벨트, 센서. 이제 순서가 머릿속에 있다. 내일 오후 세시에 한 번 더 열어 본다.
        - else:
            # note: 3월 20일
            아직 한 군데가 남았다. 영상만으로는 안 되는 곳.
        }
* [오늘은 그냥 자기 # act]
    # note: 3월 20일
    로스터에 천을 덮었다. 내일은 서하 씨 옆에만 있으면 된다.
- # dayend
-> seoha_d13


// ════════════════════════════════
// D13 — 3월 21일 토요일 (맑음): 재계약, 그리고 판정
// ════════════════════════════════
=== seoha_d13 ===
# day: 13
# time: 10:30
# note: 3월 21일
맑음. 재계약 답변을 하는 날이다.
{ f_seoha_stay:
    -> meeting
- else:
    -> closing
}

= meeting
# time: 11:00
# scene: bg_cafe_day_01 # at: cafe, 재계약
건물주 사모님은 일흔쯤 된 여자다. 카운터에 앉아 가게를 둘러본다. 나는 창가 자리에 앉아 있다. 옆에만 있어 달라고 했으니까.
# from: seoha
사모님. 숫자는 저도 알아요. 그래서 숫자 말고 말씀드릴게요.
# from: seoha
삼 년 전에 이 가게 처음 열 때, 저 저 기계 앞에서 울었어요. 무서워서요.
# from: seoha
만물수선 사장님이 천천히 알려 주셨어요. 그 기계를 이번엔, 저 사람이 고쳐 줬어요.
{ f_seoha_roasted:
    # from: seoha
    그리고 이 원두요. 버려진 로스터를 살려서, 처음 볶았어요. 이 가게에서만 나는 냄새예요.
}
{ f_seoha_advice || aff_seoha >= 75:
    ~ f_seoha_saved = true
    # as: 건물주 사모님
    …김 사장이 고쳐 준 가게라.
    # as: 건물주 사모님
    그 영감 이 동네 떠날 때 나한테 뭐라고 했는지 알아요? 오후세시 사장 괴롭히지 말라고.
    # as: 건물주 사모님
    15%. 대신 2년 계약. 내 라디오 고장 나면 저 총각 보내요.
    # cut: seoha_face_surprised_01 # from: seoha
    …네?
    그녀가 나를 본다. 나는 고개를 끄덕인다. 라디오라면 제주의 누군가에게 배우면 된다.
- else:
    # as: 건물주 사모님
    사정은 알겠어요. 근데 나도 사정이 있어요.
    # as: 건물주 사모님
    40%가 어렵다면 30%. 그게 내가 할 수 있는 최선이에요.
    # cut: seoha_face_pout_01 # from: seoha
    …생각해 볼게요.
    (30%. 딸기 라떼 백오십 잔. 그녀의 얼굴에 답이 쓰여 있다.)
}
# scene: end
{ f_seoha_roaster && not f_seoha_roasted && roaster_step >= 2:
    -> second_try
}
-> evening

= second_try
# time: 15:00
# scene: bg_cafe_day_01 # at: cafe, 로스터 다시
오후 세시. 한 번 더 로스터를 연다. 온도 센서까지 배우고 왔다.
히터, 벨트, 센서. 이번엔 순서대로.
# fx: zoom
드럼이 돈다. 바늘이 오른다. 원두가 타닥타닥 튄다.
# cut: seoha_scene_roast_01 # from: seoha
…됐다. 됐어요!
~ f_seoha_roasted = true
~ raise(aff_seoha, 4)
# gallery: seoha_cg_roast_01
# done: roaster
# done: roaster2
# scene: end
-> evening

= closing
# time: 11:00
# room: seoha
사모님 만나고 왔어요.
30%까지는 깎아 주시겠대요. 그래도 안 되는 숫자예요 :)
# typing: 3
그래서 그냥, 본사 제안 받기로 했어요.
3월 31일까지만 할게요. 마지막 날엔 와 줄 거죠?
~ f_seoha_saved = false
-> evening

= evening
# time: 20:10
# room: dangol
# from: choi
오후세시 봄 메뉴 언제 나와? 나 예약함 ㅋㅋ
# from: halmeoni # big
나도
# from: ian
1번은 저라니까요!!
# from: seoha
{f_seoha_saved: 내일부터예요 :) 다들 오세요.|내일 한 번만 팔아요 :) 다들 오세요.}
# from: daon
두부 데리고는 못 가요.
# from: guard
나는 믹스커피
-> judge

= judge
# time: 23:30 # at: home
# note: 3월 21일
{f_seoha_saved: 오후세시는 2년 더 오후 세시다.|오후세시는 열흘 남았다.}
# dayend
{ aff_seoha >= 75 && f_seoha_saved && f_seoha_roasted:
    -> ending_seoha_good
- else:
    -> ending_seoha_normal
}
