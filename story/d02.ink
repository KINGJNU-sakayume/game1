// D2 — 3월 10일 화요일
// 윗집 형광등 — 채이안 첫 만남. 저녁: 김다온의 첫 메시지 "그 번호 왜 쓰세요."
// 문법: docs/05_스크립트_문법.md

// ── D2에서 생기는 플래그 ──
VAR f_ian_eye = false          // 이안의 그림에 구체적인 감상을 말했다 (D2 모니터 앞 또는 밤 낙서)
VAR f_d2_confessed = false     // D1 "조카" 거짓말을 다온에게 털어놓았다
VAR f_d2_lied_again = false    // 다온 앞에서 거짓말을 한 번 더 했다
VAR f_d2_daon_honest = false   // 다온에게 번호 사정과 실력을 솔직히 말했다
VAR f_d2_slept = false         // 밤에 일찍 자서 이안의 새벽 메시지를 못 봤다 → D3 아침에 이어짐
VAR f_d2_doodle_replied = false // 이안의 낙서에 답했다 (밤 또는 D3 아침)


// ════════════════════════════════
// 아침
// ════════════════════════════════
=== d02_morning ===
# day: 2
# time: 07:41
# room: ian
안녕하세요!! 윗집인데요
어제 단톡방에서 번호 받으셨다는 분 맞죠?? ㅋㅋ
# typing: 2
형광등이 깜빡깜빡 🥲
밤새 마감하는데 머리까지 깜빡거리는 것 같아요
# photo: ian_cg_light_01
깜빡이는 형광등 사진
# note: 3월 10일
윗집 사람이 아침 7시 41분에 연락했다. 자고 일어난 게 아니라, 아직 안 잔 것 같다.
* [이따 봐 드릴게요]
    ~ raise(aff_ian, 3)
    헉 감사해요!!
* [솔직히 형광등은 잘 몰라요 # say: 솔직히 형광등은 잘 모르는데… 그래도 봐 드릴게요]
    ~ raise(aff_ian, 3)
    ㅋㅋㅋㅋ 저보단 알겠죠 뭐
    저는 전구 끼우는 방향도 헷갈려요
* [지금 바로 올라갈까요?]
    ~ raise(aff_ian, 1)
    앗 지금은 제가 사람 꼴이 아니라서요 ㅋㅋㅋ
- # typing: 1.5
열한 시쯤 괜찮으세요? 씻고 사람 되어 있을게요
# plan: ian_light, 2, 11:00, 형광등 · 해든빌라 301호
# memo: ian
해든빌라 301호, 바로 윗집. 느낌표와 물음표를 두 개씩 쓴다. 아침 7시에 "아직 안 잔" 사람.
# room: dangol # from: guard # time: 08:20
201호 총각 해든빌라 사는 거 맞지?
# from: guard
그럼 301호 아가씨 형광등도 좀 봐 줘. 복도까지 깜빡거려
# from: guard
점등관 여분은 관리실에 있음. 사장님이 맡겨 둔 거
# from: choi
총각 인기 많네 ㅋㅋ 냉장고는 줄 서 있어요
# town: t_hall, 동네생활, 해든빌라 1층
해든빌라 3층 복도 불 누가 좀… 밤마다 공포 영화 찍어요
{f_d1_left_dangol: -> tease | -> d02_scene}

= tease
# from: halmeoni # big
오늘은 안 나가요?
-> d02_scene


// ════════════════════════════════
// 낮 — 대면: 해든빌라 301호
// ════════════════════════════════
=== d02_scene ===
# time: 11:02
# scene: bg_villa_hall_01 # at: home, 301호 형광등
초록색 페인트가 벗겨진 계단 난간. 3층까지 올라가는 동안 복도 형광등이 두 번 꺼졌다 켜진다.
(바로 윗집인데 올라와 본 건 처음이다.)
# cut: ian_scene_light_01 # from: ian
오셨다!! 들어오세요, 여기 이거예요.
동그란 뿔테 안경에 커다란 회색 후드티. 목에는 흰 헤드폰이 걸려 있다.
# from: ian
잠깐, 아래층이면… 201호?
# cut: ian_face_surprised_01 # from: ian
헐. 그럼 제 의자 끄는 소리 맨날 들리셨겠다.
* [네, 새벽마다요 # say: 네, 새벽마다 들려요 ㅎㅎ]
    ~ raise(aff_ian, 4)
    # cut: ian_face_smile_01 # from: ian
    으악 ㅋㅋㅋㅋ 죄송해요! 의자 다리에 양말 신길게요.
* [하나도 안 들렸어요 # say: 아뇨, 하나도 안 들렸어요.]
    # cut: ian_face_smile_01 # from: ian
    거짓말 ㅋㅋㅋ 표정에 다 쓰여 있어요.
- # cut: ian_scene_light_01
천장의 긴 형광등이 파르르 떨다가 꺼지고, 다시 켜진다. 끝부분이 까맣게 그을려 있다.
{k_starter: -> easy | -> hard}

= easy
(어젯밤 알고리즘이 틀어 준 영상이다. 끝이 그을리면 형광등이 아니라 점등관.)
옆에 붙은 작은 원통, 점등관을 반 바퀴 돌려서 뺀다. 관리실에서 받아 온 새것을 반 바퀴.
~ raise(aff_ian, 4)
# from: ian
어? 형광등 안 갈아요? 그 쪼끄만 거 하나로 끝이에요??
-> fixed

= hard
# from: ian
이거 형광등만 갈면 되는 거죠? 그쵸?
* [아는 척 도전하기 # say: 이건 보통 형광등을 통째로… 빼면…]
    ~ raise(aff_ian, -2)
    # fx: shake
    긴 형광등을 비틀자 한쪽 끝이 빠지며 먼지가 쏟아진다. 둘 다 동시에 재채기를 한다.
    # cut: ian_face_smile_01 # from: ian
    에취! ㅋㅋㅋㅋ 이거 백 퍼센트 모르시는 거죠?
    * * [네, 몰라요 # say: …네. 사실 몰라요.]
        ~ raise(aff_ian, 3)
        # from: ian
        ㅋㅋㅋ 그럼 같이 찾아봐요!
    - - -> together
* [같이 찾아봐요 # say: 솔직히 잘 몰라요. 같이 찾아볼래요?]
    ~ raise(aff_ian, 5)
    # cut: ian_face_smile_01 # from: ian
    오 좋아요! 저 검색 잘해요.
    -> together

= together
그녀가 휴대폰을 내민다. 튜브 영상 속 아저씨가 형광등 옆의 작은 원통을 가리킨다. 점등관이라고 한다.
# from: ian
어? 이거 경비 아저씨가 저번에 주고 가신 거랑 똑같은데?
서랍에서 똑같은 원통이 나온다. 반 바퀴 돌려서 빼고, 반 바퀴 돌려서 끼운다.
-> fixed

= fixed
# fx: zoom
딸깍. 형광등이 두어 번 망설이다가 곧게 켜진다. 더는 떨리지 않는다.
# cut: ian_face_smile_01 # from: ian
됐다!! 형광등 부활!
# done: ian_light
(방 안이 갑자기 환해지자, 벽에 붙은 그림들이 보인다.)
벽 가득한 그림 속 사람들은 하나같이 뒤를 돌아보고 있다. 얼굴이 있는 그림은 한 장도 없다.
# cut: ian_scene_monitor_01
책상 위 모니터에 그리다 만 그림이 떠 있다. 새벽의 창가, 식어 가는 커피 잔, 파란 빛이 들어오는 방.
# from: ian
아 그건 보지 마요 ㅋㅋ 마감 원고예요. 아직 엉망이에요.
* [창문 빛이 좋아요 # say: 창문으로 들어오는 빛 색이 좋아요. 진짜 새벽 같아요.]
    ~ raise(aff_ian, 7)
    ~ f_ian_eye = true
    # cut: ian_face_shy_01 # from: ian
    …그거 제가 제일 오래 붙잡고 있던 부분인데.
    # from: ian
    어떻게 알았어요?
* [예쁘네요]
    ~ raise(aff_ian, -3)
    # from: ian
    아 ㅋㅋ 감사해요.
    (대답이 반 박자 늦다. 뭔가 잘못 말한 것 같다.)
* [그림은 잘 모르지만 # say: 저는 그림을 잘 몰라서요. 근데 보고 있으니까 조용해지네요.]
    ~ raise(aff_ian, 5)
    # cut: ian_face_shy_01 # from: ian
    오… 그 말 좋다. 조용해진다.
- # cut: ian_face_smile_01 # from: ian
수리비는… 제가 요즘 좀 가난해서요 ㅋㅋ
# from: ian
대신 다음에 뒷모습 그려 드릴게요. 공구함 든 거로!
* [기대할게요]
    ~ raise(aff_ian, 2)
    # from: ian
    약속!
* [앞모습은요? # say: 왜 뒷모습이에요? 앞모습은요?]
    ~ raise(aff_ian, 2)
    # from: ian
    앞모습은… 더 친해지면요 ㅋㅋ
    (농담처럼 말했는데, 눈은 웃지 않는다.)
- # scene: end
# memo: ian
일러스트레이터. 목에 늘 흰 헤드폰. 벽에 붙은 그림 속 사람들은 전부 뒷모습이다.
-> d02_afternoon


// ════════════════════════════════
// 오후
// ════════════════════════════════
=== d02_afternoon ===
# time: 15:30 # at: home
# room: dangol
# from: ian
형광등 부활했습니다 여러분 ㅋㅋㅋㅋ
# from: ian
201호 분이 고쳐 주셨어요
# from: choi
나도 냉장고 부활 좀 ㅠㅠ
# from: halmeoni # big
잘했어요
# from: guard
복도 것도 이제 안 깜빡이네
# townreply: t_hall, 해든빌라 1층
오 오늘은 안 깜빡이네요?? 누가 고쳤지
# time: 15:42
# post: ian_p1 # from: ian # photo: ian_cg_light_01
형광등 부활 🎉 오늘부터 다시 밤샘 가능
# post: ian_p1
수리해 주신 분은 기사님이 아니라 아랫집 사람임 ㅋㅋ
{aff_seoha >= 15: -> seoha_ping | -> d02_evening}

= seoha_ping
# time: 16:10
# room: seoha
오늘 스팀 아주 멀쩡해요 :)
혹시 지나가시면 커피 한 잔 빚진 거 갚을게요.
* [다음에 꼭 갈게요]
    ~ raise(aff_seoha, 2)
    네, 기다릴게요 :)
* [오늘 저녁에 갈까요?]
    ~ raise(aff_seoha, 1)
    아 오늘은 원두 들어오는 날이라 일찍 닫아요 ㅠ
    (이모티콘은 :) 하나만 쓰는 줄 알았는데. 급하면 ㅠ도 쓰는구나.)
    다음에요 :)
- -> d02_evening


// ════════════════════════════════
// 저녁 — 김다온의 첫 메시지
// ════════════════════════════════
=== d02_evening ===
# time: 20:40
# room: daon
# wait: 2
김용수 사장님 번호 쓰시는 분 맞죠.
# typing: 1
그 번호 왜 쓰세요.
# note: 3월 10일
마침표가 찍힌 메시지가 두 개 왔다. 두 개 다 질문인데 물음표가 없다.
-> ask

= ask
* [통신사에서 받은 번호예요 # say: 개통할 때 통신사에서 받은 번호예요. 사장님 번호였던 건 어제 알았어요.]
    ~ raise(aff_daon, 4)
    ~ f_d2_daon_honest = true
    # wait: 5
    그렇군요.
* [제 번호니까 쓰죠 # draft: 누구신데요?]
    ~ raise(aff_daon, -3)
    # wait: 6
    그렇네요.
* [나중에 답하기 # act]
    ~ raise(aff_daon, -2)
    # time: 21:55 # wait: 3
    읽으셨네요.
    -> ask
- {f_d1_lied: -> lie | -> reveal}

= lie
# typing: 1.5
그리고.
할아버지 조카라고 하셨다던데.
# typing: 2
저희 할아버지 형제 없으세요.
* [거짓말이었어요, 죄송해요 # say: …거짓말이었어요. 카페에서 당황해서 그랬어요. 죄송합니다.]
    ~ raise(aff_daon, 5)
    ~ f_d2_confessed = true
    # wait: 6
    네.
    다음부턴 그러지 마세요.
* [먼 친척이에요 # say: 아… 먼 친척이에요. 아주 먼.]
    ~ raise(aff_daon, -10)
    ~ f_d2_lied_again = true
    # wait: 8
    그렇군요.
    (들킨 게 확실하다. 마침표 하나가 이렇게 무서울 줄은 몰랐다.)
- -> reveal

= reveal
# typing: 1.5
저 김용수 사장님 손녀예요.
할아버지가 부탁하셨어요. 그 번호로 연락 오는 사람들 좀 챙기라고.
# typing: 2
근데 번호가 남한테 넘어갔더라고요.
할아버지 수첩이 있어요. 단골들 기계 고친 기록.
드릴게요. 대신 받으시면 제대로 하세요.
* [제가 받아도 돼요? # say: 그걸 제가 받아도 돼요?]
    ~ raise(aff_daon, 2)
    # wait: 4
    저는 교대 근무라 다 못 챙겨요.
    할아버지도 아무한테나 주라고 하진 않으셨을 거고요.
* [저 수리할 줄 몰라요 # say: 솔직히 말하면 저 수리할 줄 몰라요.]
    ~ raise(aff_daon, 5)
    ~ f_d2_daon_honest = true
    # wait: 4
    알아요.
    형광등도 영상 보고 갈았다면서요. 단톡방에 다 나와요.
- # typing: 1.5
내일 저녁 8시. 망원 24시 동물의료센터 앞.
# pin: hospital
늦지 마세요.
* [네, 8시에 갈게요]
    ~ raise(aff_daon, 1)
    # wait: 3
    네.
* [혹시 7시 반은 안 될까요?]
    # wait: 3
    8시요.
- # plan: daon_notebook, 3, 20:00, 사장님 수첩 받기 · 동물의료센터 앞
# todo: notebook, 내일 8시 정각. 늦지 말 것
# memo: daon
김다온. 김 사장님의 손녀, 동물병원 수의사. 문장마다 마침표를 찍는다. 물음표도 마침표로 쓴다.
-> d02_night


// ════════════════════════════════
// 밤
// ════════════════════════════════
=== d02_night ===
# time: 22:30
# note: 3월 10일
하루에 두 사람. 한 명은 느낌표를 세 개씩 쓰고, 한 명은 마침표만 쓴다.
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    -> tube
* [누군가에게 먼저 연락하기 # act]
    -> contact
* [일찍 자기 # act]
    ~ f_d2_slept = true
    # note: 3월 10일
    알림을 끄고 누웠다. 윗집에서 오늘은 의자 끄는 소리가 조금 조용하다.
    -> late

= tube
# ask: 오늘 밤 볼 영상
* {not k_boiler} [보일러에서 쇠 긁는 소리 # watch: boiler]
    -> video_boiler ->
* {not k_gasket} [냉장고 문 고무 다시 붙이기 # watch: gasket]
    -> video_gasket ->
* [뚜껑이 자꾸 뜰 때 — 경첩 핀 # watch: hinge]
    -> video_hinge ->
* [의자가 자꾸 내려갈 때 (알고리즘 추천) # watch: chair]
    -> video_chair ->
    # note: 3월 10일
    알고리즘은 오늘도 내가 모르는 내일을 아는 것 같다.
- -> late

= contact
# ask: 누구에게 연락할까?
* [채이안에게 메시지 # text: ian]
    # time: 22:40
    # room: ian
    # from: me
    형광등은 아직 멀쩡하죠?
    ~ raise(aff_ian, 3)
    넹 ㅋㅋㅋ 너무 밝아서 눈부셔요
    덕분에 마감 속도 두 배!
    # typing: 0.8
    근데 먼저 연락 온 건 처음이다 ㅋㅋ
* [채이안에게 전화 # dial: ian]
    # time: 22:40
    # call: ian # outgoing
    헐 전화?? ㅋㅋㅋ 무슨 일이에요
    # from: me
    형광등 괜찮나 해서요.
    ~ raise(aff_ian, 3)
    괜찮아요 ㅋㅋ 너무 밝아서 그림이 다 틀려 보여요. 형광등이 너무 잘 나와도 문제네.
    근데 전화로 안부 묻는 사람 진짜 오랜만이다.
    # narr
    (수화기 너머로 태블릿 펜 긁는 소리가 들린다. 통화하면서도 그리는 모양이다.)
    # call: end
* [윤서하에게 메시지 # text: seoha]
    # time: 22:40
    # room: seoha
    # from: me
    오늘도 마감 잘 하셨어요?
    ~ raise(aff_seoha, 3)
    # wait: 3
    {aff_seoha >= 20: 네 ㅎㅎ 이 시간에 안부 묻는 사람이 또 생겼네요 :)|네, 오늘도 무사히 마감했어요 :)}
* [윤서하에게 전화 # dial: seoha]
    # time: 22:40
    # call: seoha # outgoing
    …여보세요? 어, 무슨 일 있어요?
    # from: me
    아뇨, 그냥… 마감 잘 하셨나 해서요.
    ~ raise(aff_seoha, 1)
    아. 아아, 네. 잘 했어요.
    # narr
    (당황한 목소리다. 이 시간의 전화는 보통 안 좋은 소식이니까.)
    전화는 좀 떨리네요. 다음엔 메시지로 해요 :)
    # call: end
    # memo: seoha
    전화는 떨린다고 했다. 밤에는 메시지가 낫다.
- -> late

= late
# time: 23:40
# post: ian_p2 # from: ian # photo: ian_cg_doodle_light_01
형광등 고친 기념 낙서
# post: ian_p2
수리 기사님 (허락 안 받음)
# time: 23:48
# room: ian
자요?
안 자면 이거 봐 줘요 ㅋㅋ
# photo: ian_cg_doodle_light_01
형광등 고친 기념 낙서
{f_d2_slept: -> close}
* [공구함 든 사람, 설마 저예요? # say: 형광등 표정이 살아 있어요 ㅋㅋ 공구함 든 사람은 설마 저예요?]
    ~ raise(aff_ian, 5)
    ~ f_ian_eye = true
    ~ f_d2_doodle_replied = true
    헉 들켰다 ㅋㅋㅋㅋ
    뒷모습은 제대로 그려 준다고 했잖아요. 이건 연습!
* [잘 그리시네요]
    ~ raise(aff_ian, -2)
    ~ f_d2_doodle_replied = true
    ㅋㅋ 감사해요
    # typing: 0.8
    잘 자요!
* [내일 볼게요 # act]
    ~ raise(aff_ian, -1)
    # wait: 4
    자나 보다 🥲
- -> close

= close
# note: 3월 10일
내일은 마침표 쪽이다. 8시 정각.
# dayend
-> d03_morning
