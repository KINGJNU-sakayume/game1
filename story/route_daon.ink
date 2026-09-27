// 김다온 루트 — D5 밤 ~ D13 (엔딩은 endings.ink)
// 갈등(D8): 할아버지 가게 자리가 철거된다. 30년 된 손글씨 간판. 설렘(D10 새벽): 병원 앞 편의점 컵라면.
// D7 보온기, D10 사장님 전화(할아버지와 다온을 잇기), D11 위기(대전 병원 제안), D12 간판 떼는 날·9시 정각 고백.
// 굿엔딩 열쇠: D11에 간판을 맡겠다고 하기 + D12 간판을 떼어 오기 + 호감 75.

VAR daon_regular = 0          // D6 다온과 같이 챙긴 단골 일 (개수)
VAR f_daon_bob = false        // "밥은."에 답했다
VAR f_daon_incubator = false  // D7 보온기를 살렸다
VAR f_daon_open = false       // D8 할아버지에게 서운한 거냐고 물었다
VAR f_daon_dawn = false       // D10 새벽 퇴근길에 갔다
VAR f_daon_page = false       // D10 수첩의 "다온이" 쪽을 보여 줬다
VAR f_daon_grandpa = false    // D10 사장님에게 다온에게 직접 전화하라고 했다
VAR f_daon_stay = false       // D11 간판을 맡겠다고 했다 (도망치지 않음)
VAR f_daon_help = false       // D11 망원살이에 도움 요청 글을 올렸다
VAR f_daon_sign = false       // D12 간판을 떼어 왔다
VAR f_daon_ontime = false     // D12 9시 정각
VAR f_daon_confess = false    // D12 마음을 말했다


=== daon_d05_night ===
# time: 22:40 # at: home # wait: 1
# call: daon
* [받기 # answer]
    집에 잘 들어갔어요.
    # narr
    (질문이 아니다. 확인이다.)
    …오늘 전구. 고마웠어요. 두 번 말하는 거예요.
    { d5_with == 3:
        두부 데려다줘서도요. 두부가 이동장에서 한 번도 안 울었어요. 원래 울어요.
    }
    # from: me
    다온 씨도 오늘 고생했어요.
    …네. 끊을게요. 주무세요.
    ~ raise(aff_daon, 2)
    # call: end
* [거절 # decline]
    ~ raise(aff_daon, -1)
    # room: daon
    전화 안 받네요.
    고마웠다고요. 전구.
- # note: 3월 13일
장터가 끝났다. 전화로 고맙다는 말을 두 번 들었다. 둘 다 마침표로 끝났다.
# dayend
-> daon_d06


// ════════════════════════════════
// D6 — 3월 14일 토요일: 단골 순회
// ════════════════════════════════
=== daon_d06 ===
# day: 6
# time: 08:10
# note: 3월 14일
구름 조금. 토요일 아침에 마침표가 왔다.
# room: daon
오늘 오프예요.
할아버지 단골들, 남은 거 있어요.
* [남은 거 정리해서 보내기 # say: 잠깐만요, 정리해 볼게요.]
    ~ raise(aff_daon, 1)
    # from: me
    {f_d3_boiler && f_d3_fridge && f_d4_tteok: 다 했어요. 남은 거 없어요.|{not f_d3_boiler: 경비 아저씨 보일러. }{not f_d3_fridge: 최 사장님 냉장고. }{not f_d4_tteok: 떡집 솥뚜껑. }이렇게 남았어요.}
- { f_d3_boiler && f_d3_fridge && f_d4_tteok:
    # wait: 4
    …다 했어요?
    그럼 두부 캣타워요. 수첩에 있었죠. 나사 자주 풀린다고.
    ~ raise(aff_daon, 3)
- else:
    # wait: 4
    오늘 남은 거 하세요.
    저도 갈게요.
}
# plan: daon_round, 6, 11:00, 단골 순회 · 다온 씨와
# time: 10:50
-> round

= round
# ask: 어디부터 갈까?
* {not f_d3_boiler} [해든빌라 보일러실 (경비 아저씨) # go: home]
    -> boiler
* {not f_d3_fridge} [망원시장 정육점 (최 사장) # go: market]
    -> fridge
* {not f_d4_tteok} [박씨네 떡집 (떡솥 뚜껑) # go: market]
    -> tteok
* [동물의료센터 (두부 캣타워) # go: hospital]
    -> cattower

= boiler
# scene: bg_villa_boiler_01 # at: home, 보일러 (다온 씨와)
보일러실. 경비 아저씨가 팔짱을 끼고, 김다온도 팔짱을 끼고 있다. 두 사람이 나란히 서 있으니 감독관이 둘이다.
{ k_boiler || read("해든빌라 (보일러)") || f_book_read:
    순환펌프 옆 꼭지, 반 바퀴, 양동이. 쉭— 물이 톡. 잠근다. 끼익 소리가 멎는다.
    # cut: daon_face_surprised_01 # from: daon
    …할아버지랑 순서가 똑같네요.
    ~ raise(aff_daon, 4)
- else:
    # cut: daon_face_neutral_01 # from: daon
    수첩 몇 쪽이에요. 해든빌라 보일러.
    수첩을 펼친다. "쇠 긁는 소리는 공기. 순환펌프 옆 꼭지 반 바퀴. 통 필수." 그녀가 손가락으로 줄을 짚어 준다.
    쉭— 물이 톡. 잠근다. 소리가 멎는다.
    # from: daon
    수첩은 들고만 다니는 게 아니에요.
    ~ raise(aff_daon, 2)
}
~ daon_regular = daon_regular + 1
~ f_d3_boiler = true
# from: guard
다온이 많이 컸네.
# from: daon
삼십 년 전부터 컸어요, 아저씨.
# scene: end
-> after_round

= fridge
# scene: bg_market_day_01 # at: market, 냉장고 (다온 씨와)
망원정육. 최 사장님이 다온 씨를 보자마자 목소리가 두 배가 된다.
# from: choi
다온이 왔네! 총각이랑 같이? 오 ㅋㅋㅋ
# cut: daon_face_pout_01 # from: daon
일하러 왔어요.
{ k_gasket || read("정육점 (냉장고)") || f_book_read:
    드라이기, 따뜻한 바람, 문 닫고 5분. 최 사장님이 문을 열려고 할 때마다 다온 씨가 문을 손으로 막는다.
    # from: daon
    5분이에요. 할아버지가 늘 그랬잖아요.
    ~ raise(aff_daon, 4)
- else:
    # from: daon
    드라이기로 데우는 거예요. 수첩 정육점 쪽에 있어요.
    그녀가 떡집에서 드라이기를 빌려 온다. 나는 바람을 쏘이고, 그녀는 시계를 본다. 5분.
    ~ raise(aff_daon, 2)
}
# fx: zoom
문이 쩍 붙는다.
~ daon_regular = daon_regular + 1
~ f_d3_fridge = true
# scene: end
-> after_round

= tteok
# scene: bg_market_day_01 # at: market, 떡솥 (다온 씨와)
박씨네 떡집. 할머니가 다온 씨를 보자마자 가래떡부터 쥐여 준다.
# from: halmeoni
다온아, 밥은 먹고 다니니? 얼굴이 반쪽이야.
# cut: daon_face_shy_01 # from: daon
먹어요, 할머니.
(할머니 앞에서는 목소리가 반 톤 높다.)
{ k_hinge || read("떡집 (떡솥 뚜껑)") || f_book_read:
    대성철물 3번 서랍. 규격 핀. 끝을 톡톡.
    # fx: zoom
    뚜껑이 딱 맞게 내려앉는다.
    # from: daon
    …3번 서랍은 할아버지랑 대성 할아버지밖에 모르는데.
    ~ raise(aff_daon, 4)
- else:
    # from: daon
    3번 서랍이요. 대성철물. 어릴 때 할아버지 따라가서 많이 열어 봤어요.
    그녀를 따라 철물점에 간다. 3번 서랍을 여는 그녀의 손이 익숙하다.
    # fx: zoom
    핀을 끼우고 톡톡. 뚜껑이 내려앉는다.
    ~ raise(aff_daon, 2)
}
~ daon_regular = daon_regular + 1
~ f_d4_tteok = true
# from: halmeoni
다온이 남자 친구야?
# cut: daon_face_pout_01 # from: daon
아니에요.
# from: halmeoni
호호, 아니긴. 귀가 빨간데.
# scene: end
-> after_round

= cattower
# scene: bg_hospital_int_day_01 # at: hospital, 두부 캣타워
동물병원 로비. 오프라더니 그녀는 가운을 입고 있다. 두부가 캣타워 꼭대기에서 우리를 내려다본다.
# from: daon
2층 판이 흔들려요. 두부가 올라갈 때마다.
수첩 그대로다. "두부 캣타워 나사 자주 풀림." 육각렌치로 나사 네 개를 조인다. 두부가 감독처럼 지켜본다.
# fx: zoom
판이 더는 흔들리지 않는다. 두부가 뛰어오른다. 멀쩡하다.
# cut: daon_face_smile_01 # from: daon
…두부 오늘 기분 좋네.
(웃은 건 두부 때문이다. 아마도.)
~ raise(aff_daon, 3)
~ daon_regular = daon_regular + 1
# scene: end
-> after_round

= after_round
{ daon_regular < 2:
    # time: 13:30
    # room: daon
    하나 더 해요. 오늘 오프라서 시간 있어요.
    -> round
}
# time: 16:00
# room: dangol
# from: halmeoni # big
다온이 남자 친구
# from: choi
ㅋㅋㅋㅋㅋ 할머니 그거 확정이에요?
# from: daon
아니에요.
# from: guard
다온이 귀 빨개짐
# note: 3월 14일
다온 씨와 단골들을 돌았다. 다온 씨는 수첩을 거의 외우고 있었다. 다 읽은 적은 없다고 했는데.
-> evening

= evening
# time: 20:40
# room: daon
{aff_daon >= 50: 밥은.|저녁 드셨어요.}
* [먹었어요, 다온 씨는요? # say: 먹었어요. 다온 씨는요?]
    ~ raise(aff_daon, 3)
    ~ f_daon_bob = true
    # wait: 5
    먹었어요.
    할머니가 준 가래떡.
* [아직이요]
    ~ raise(aff_daon, 2)
    ~ f_daon_bob = true
    # wait: 4
    드세요.
    편의점 도시락이라도요.
* {aff_daon >= 50} ["밥은."이 무슨 뜻이에요?]
    ~ raise(aff_daon, 1)
    # wait: 6
    먹었냐는 뜻이요.
    할아버지가 맨날 그렇게 물었어요. 전화 받자마자. 밥은.
- # memo: daon
"밥은."은 밥 먹었냐는 뜻이다. 할아버지가 늘 그렇게 물었다고 했다.
# time: 22:00 # at: home
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {not k_incubator} [보온기·온열 매트가 안 켜질 때 # watch: incubator]
        -> video_incubator ->
    * * {not k_bolt} [녹슨 볼트 푸는 법 # watch: bolt]
        -> video_bolt ->
    * * {not k_timing} [썸 탈 때 답장은 몇 분 뒤에? # watch: timing]
        -> video_timing ->
    * * [그만 보기]
    - - -> close
* [다온 씨에게 전화하기 # act]
    # call: daon # outgoing
    …무슨 일이에요.
    # from: me
    오늘 고마웠다고요. 수첩, 다온 씨가 더 잘 알던데요.
    ~ raise(aff_daon, 3)
    …어릴 때 가게에서 살았어요. 학교 끝나면 할아버지 가게로 갔어요. 집보다 가게가 좋아서.
    # narr
    (그녀가 자기 얘기를 한 건 처음이다. 3분 12초짜리 통화.)
    # call: end
    -> close
* [일찍 자기 # act]
    -> close

= close
# dayend
-> daon_d07


// ════════════════════════════════
// D7 — 3월 15일 일요일: 보온기
// ════════════════════════════════
=== daon_d07 ===
# day: 7
# time: 10:30
# note: 3월 15일
맑음. 다온 씨는 오늘부터 야간 근무라고 했다. 저녁 9시부터 아침 7시.
# post: dubu_p3 # from: dubu # photo: dubu_cg_kittens_01
오늘 새 식구 셋이 왔어요 🐾 구조된 아기 고양이들. 두부 선배가 지켜보는 중
# comment: dubu_p3 # from: halmeoni
아이고 이뻐라
# ask: 망원24 두부 게시물
* [좋아요 # like: dubu_p3]
    ~ raise(aff_daon, 1)
* [댓글: 두부 선배 든든하네요 # comment: dubu_p3 # say: 두부 선배 든든하네요]
    ~ raise(aff_daon, 2)
* [넘기기]
- # time: 22:00 # at: home
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {not k_incubator} [보온기·온열 매트가 안 켜질 때 # watch: incubator]
        -> video_incubator ->
    * * {not k_bolt} [녹슨 볼트 푸는 법 # watch: bolt]
        -> video_bolt ->
    * * [그만 보기]
    - - -> emergency
* [사장님 수첩 다시 보기 # act]
    ~ f_book_read = true
    # note: 3월 15일
    수첩을 넘겼다. 동물의료센터 쪽. "보온기 온도조절기 접점. 일 년에 한 번 고운 사포."
    -> emergency
* [일찍 자기 # act]
    -> emergency

= emergency
# time: 22:40 # wait: 1
# call: daon
* [받기 # answer]
    보온기가 안 켜져요.
    오늘 들어온 새끼 고양이 셋. 체온이 떨어지고 있어요.
    수리 기사는 월요일에 온대요.
    # narr
    (그녀의 목소리가 처음으로 빠르다.)
    …와 줄 수 있어요?
    # from: me
    지금 갈게요.
    # call: end
* [거절 # decline]
    ~ raise(aff_daon, -2)
    # room: daon
    보온기가 안 켜져요. 새끼 고양이 셋 체온이 떨어져요.
    와 줄 수 있으면 와 주세요.
    # note: 3월 15일
    전화를 못 받았다. 메시지를 보자마자 뛰었다.
- -> hospital

= hospital
# time: 22:58
# scene: bg_hospital_int_night_01 # at: hospital, 보온기
야간의 동물병원. 형광등이 하얗다. 처치실 구석에 투명한 보온기가 있고, 그 안에 주먹만 한 고양이 셋이 붙어 있다.
# cut: daon_scene_incubator_01 # from: daon
전원은 들어와요. 근데 안 데워져요.
그녀가 수건으로 새끼들을 감싸 안고 있다. 두부가 처치실 문턱에 앉아 지켜본다.
{ k_incubator || read("동물의료센터") || f_book_read:
    -> knows
- else:
    -> guess
}

= knows
(온도조절기 접점. 고운 사포. 간격은 종이 한 장. 수첩과 오반장님이 같은 말을 했다.)
# from: me
전원 뽑을게요. 온도조절기 접점이 그을렸을 거예요.
뚜껑을 연다. 작은 쇠붙이 두 개가 까맣게 탔다. 사포로 살살 문지른다. 종이 한 장만큼 간격을 맞춘다.
# fx: zoom
전원. 딸깍. 이 분 뒤, 보온기 안의 온도계 바늘이 천천히 오른다.
그녀가 새끼들을 하나씩 보온기에 넣는다. 셋이 서로에게 파고든다.
~ f_daon_incubator = true
~ raise(aff_daon, 5)
# cut: daon_face_surprised_01 # from: daon
…할아버지 수첩에 있었어요?
# from: me
네. 일 년에 한 번 사포.
# from: daon
할아버지가 매년 봄에 와서 했어요. 올해는 안 와서, 몰랐어요.
-> night_floor

= guess
* [아는 척 뜯어 보기 # say: 이런 건 보통… 여기 선이 빠진 걸 거예요.]
    ~ raise(aff_daon, -5)
    # fx: shake
    이것저것 뜯어 본다. 20분. 오히려 전원 표시등까지 꺼진다.
    # cut: daon_face_pout_01 # from: daon
    모르면 모른다고 했어야죠. 20분 날렸어요.
    # from: daon
    …됐어요. 다른 방법 해요.
* [모른다고 하기 # say: 솔직히 모르겠어요. 대신 뭐든 할게요. 뭐부터 해요?]
    ~ raise(aff_daon, 3)
    # cut: daon_face_neutral_01 # from: daon
    …그럼 물 끓여요. 페트병에 담아서. 수건으로 싸고.
- 뜨거운 물을 담은 페트병을 수건으로 감싸 새끼들 옆에 놓는다. 내 후드 집업도 벗어서 덮는다. 체온계 숫자가 조금씩 오른다.
# from: daon
이렇게 아침까지 버티면 돼요.
-> night_floor

= night_floor
# time: 02:10
# cut: bg_hospital_int_night_01
새벽 두 시. 처치실 바닥에 나란히 앉아 있다. 두부가 내 무릎에 올라와 자리를 잡는다.
# cut: daon_face_neutral_01 # from: daon
두부가 무릎에 올라가는 사람, 할아버지 말고 처음이에요.
# from: daon
고마워요
(마침표가 없다.)
* [마침표가 없네요 # say: 방금 고마워요 뒤에 마침표가 없었어요.]
    ~ raise(aff_daon, 2)
    # cut: daon_face_shy_01 # from: daon
    …말할 때는 원래 마침표 없어요.
    (귀가 빨갛다.)
* [가만히 있기 # act]
    ~ raise(aff_daon, 3)
    대답 대신 두부의 등을 쓰다듬는다. 그녀가 벽에 머리를 기댄다. 눈을 감는다. 삼 분쯤.
- # scene: end
{f_daon_incubator: -> post | -> close}

= post
# time: 09:10
# post: dubu_p4 # from: dubu # photo: dubu_cg_kittens_02
새로 온 아기들 무사히 따뜻하게 🐾 밤중에 보온기 고쳐 주신 분 감사합니다 (두부가 무릎에서 잠)
-> close

= close
# dayend
-> daon_d08


// ════════════════════════════════
// D8 — 3월 16일 월요일: 철거 공지
// ════════════════════════════════
=== daon_d08 ===
# day: 8
# time: 10:00
# note: 3월 16일
흐림. 망원살이에 공지가 떴다.
# town: t_demolish, 공지, 망원1동 주민센터
[공지] 망원동 시장 끝 일대 건축물 철거 및 신축 공사 안내
# town: t_demolish
공사 기간: 3월 23일(월)부터. 인근 주민께서는 통행에 유의해 주시기 바랍니다.
# townreply: t_demolish, 망원토박이
만물수선 자리네요…
# townreply: t_demolish, 떡집 단골
우리 집 라디오 저기서 고쳤는데. 전기밥솥도
# townreply: t_demolish, 망원 산책러
간판은 어떻게 되는 거예요? 그 손글씨 간판
# pin: shop
# event: demolish, 15, 만물수선 자리 철거 (3월 23일)
# time: 13:00
# room: daon
철거 공지 봤어요.
# typing: 2
간판도 23일에 같이 뜯긴대요.
엄마는 그냥 버리래요. 둘 데도 없다고.
* [간판, 보러 갈래요?]
    ~ raise(aff_daon, 3)
    # wait: 5
    …퇴근하고요. 7시 반.
* [아쉽네요]
    ~ raise(aff_daon, 1)
    # wait: 6
    네.
    # note: 3월 16일
    "네." 한 글자에 마침표. 이 사람의 "네."는 여러 가지다. 오늘 건 무겁다.
    # room: daon # time: 18:40
    7시 반에 가게 앞에 갈 거예요. 혼자 가기 싫어서요.
* [제가 보관할까요? # say: 간판, 제가 보관하면 안 돼요?]
    ~ raise(aff_daon, 2)
    # wait: 5
    …어디에요. 그 방에요?
    간판이 방보다 길어요.
    # typing: 1.5
    …그래도 한번 보러 와요. 7시 반.
- # plan: daon_sign, 8, 19:30, 간판 보러 · 만물수선 자리
-> sign

= sign
# time: 19:30
# scene: bg_shop_site_night_01 # at: shop, 간판
시장 끝. 내려진 셔터 위에 나무 간판이 걸려 있다. 흰 바탕에 검은 페인트, 손으로 쓴 네 글자. "만물수선".
# cut: daon_scene_sign_01 # from: daon
할아버지가 직접 썼어요. 페인트로.
그녀가 간판을 올려다본다. 가로등 불빛에 포니테일 그림자가 셔터에 길게 붙는다.
# from: daon
할아버지는 떠나면 끝이에요. 가게도, 번호도.
# from: daon
번호 없앨 때, 저한테 말도 안 했어요. 그날 저 당직이었어요. 아침에 퇴근하니까 냉장고에 쪽지 하나. "밥 먹어라." 그게 다예요.
* [할아버지한테 서운한 거죠? # say: 다온 씨는 할아버지한테 서운한 거죠?]
    ~ raise(aff_daon, 5)
    ~ f_daon_open = true
    # cut: daon_face_pout_01 # from: daon
    …서운하면 뭐요.
    # from: daon
    …서운해요. 번호 없애면서 그 번호로 연락 오는 사람들은 저한테 부탁하고 가셨어요.
    # cut: daon_face_neutral_01 # from: daon
    저는요. 저는 누가 챙겨요.
    (처음으로 마침표가 떨린다.)
* [번호를 받아서 미안해요]
    ~ raise(aff_daon, 1)
    # from: daon
    사과할 일은 아니에요. 번호는 번호니까.
    # from: daon
    …그쪽이 받은 게 차라리 다행이라고 생각한 적도 있어요. 가끔.
* [가만히 간판 보기 # act]
    ~ raise(aff_daon, 2)
    나도 간판을 올려다본다. "수" 자의 획 하나가 삐쳐 올라가 있다. 급하게 쓴 것 같다.
    # from: daon
    "수" 자, 제가 붓 쳐서 저렇게 됐어요. 일곱 살 때. 할아버지가 그냥 뒀어요.
- # scene: end
# memo: daon
할아버지가 번호를 없앤 날, 다온 씨는 당직이었다. 냉장고의 쪽지 "밥 먹어라"가 전부였다.
# memo: daon
간판의 "수" 자 삐친 획은 일곱 살 다온 씨의 붓 자국.
# time: 22:00 # at: home
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {not k_bolt} [녹슨 볼트 푸는 법 # watch: bolt]
        -> video_bolt ->
    * * {not k_incubator} [보온기·온열 매트가 안 켜질 때 # watch: incubator]
        -> video_incubator ->
    * * [그만 보기]
    - - -> close
* [다온 씨에게 전화하기 # act]
    # call: daon # outgoing
    근무 중… 아니다, 오늘은 오프예요.
    # from: me
    아까 간판, 사진 찍어 둘 걸 그랬어요.
    …내일 또 가면 되죠.
    ~ raise(aff_daon, 2)
    # call: end
    -> close
* [일찍 자기 # act]
    -> close

= close
# dayend
-> daon_d09


// ════════════════════════════════
// D9 — 3월 17일 화요일 (비): 야간 근무 전
// ════════════════════════════════
=== daon_d09 ===
# day: 9
# time: 14:00
# note: 3월 17일
비. 다온 씨는 오늘도 야간이다. 밤 9시부터.
# room: daon
오늘 밤 9시부터 근무예요.
비 와서 응급 많을 거예요.
* [저녁 가져갈게요 # say: 근무 들어가기 전에 저녁 가져갈게요. 8시 50분.]
    ~ raise(aff_daon, 2)
    # wait: 5
    …네.
    50분이요.
    # plan: daon_dinner, 9, 20:50, 저녁 전해 주기 · 동물병원 앞
    -> dinner
* [고생해요]
    # wait: 6
    네.
    -> rainy_night

= dinner
# time: 20:50
# scene: bg_hospital_ext_night_01 # at: hospital, 저녁 전해 주기
8시 50분. 병원 유리문 앞. 우산 두 개와 김밥 두 줄.
# cut: daon_face_neutral_01 # from: daon
50분 정각이네요.
~ raise(aff_daon, 2)
# from: daon
…밥은.
# from: me
먹었어요.
# cut: daon_face_pout_01 # from: daon
거짓말. 두 줄 샀잖아요.
처마 밑에 나란히 서서 김밥을 먹는다. 빗소리가 크다. 8분.
# from: daon
새벽 여섯 시 반에 끝나요.
(그 말을 하고 그녀는 김밥 포장지를 접는다. 아주 반듯하게.)
* [그때 올게요]
    ~ raise(aff_daon, 3)
    ~ f_daon_dawn = true
    # from: daon
    …오라고 한 거 아니에요.
    # from: daon
    …컵라면은 제가 살게요.
* [푹 쉬어요 # say: 끝나면 푹 쉬어요.]
    ~ raise(aff_daon, 1)
    # from: daon
    …네.
- # scene: end
-> rainy_night

= rainy_night
# time: 22:30 # at: home
# note: 3월 17일
빗소리가 창문을 두드린다. 병원은 밤새 불이 켜져 있을 거다.
-> jeju_offer ->
# dayend
-> daon_d10


// ════════════════════════════════
// D10 — 3월 18일 수요일 (갬): 새벽 컵라면, 사장님의 전화
// ════════════════════════════════
=== daon_d10 ===
# day: 10
{f_daon_dawn: -> dawn | -> morning}

= dawn
# time: 06:30
# scene: bg_cvs_dawn_01 # at: hospital, 새벽 컵라면
새벽 여섯 시 반. 비가 그쳤다. 병원 앞 편의점 파라솔 아래.
# cut: daon_scene_ramen_01 # from: daon
왔네요.
수술복 위에 검은 바람막이. 포니테일이 조금 흐트러졌다. 그녀가 컵라면 두 개에 물을 붓는다.
# from: daon
밤새 세 마리요. 교통사고 하나, 이물질 삼킨 거 하나, 그리고 그냥 외로워서 온 할머니네 강아지 하나.
# from: daon
마지막 애가 제일 오래 걸렸어요. 할머니가 안 가셔서.
컵라면 뚜껑을 연다. 김이 올라온다. 그녀가 첫 젓가락을 들다가 멈춘다.
# from: daon
할아버지가 제 자전거 고쳐 줬어요. 인형 팔도 붙여 주고. 뭐든 고쳐 줬어요.
# from: daon
그래서 수의사 했어요. 저는 살아 있는 걸 고치고 싶었어요.
* [수첩 "다온이" 쪽 보여 주기 # act]
    -> page
* [그래서 할아버지를 닮았구나 # say: 그래서 다온 씨가 할아버지를 닮았구나.]
    ~ raise(aff_daon, 3)
    # cut: daon_face_surprised_01 # from: daon
    …어디가요.
    # from: me
    고치는 사람이잖아요. 둘 다.
    -> dawn_end

= page
~ f_daon_page = true
~ raise(aff_daon, 6)
가방에서 수첩을 꺼낸다. "다온이"라고 쓰인 쪽을 펼쳐 그녀 앞에 놓는다.
# cut: daon_face_neutral_01
"다온이 밥 거르지 말라고 할 것. 말이 짧아도 속은 여린 애."
"5월 2일 생일. 미역국."
그녀가 오래 본다. 컵라면이 불어 간다.
# from: me
받은 날 봤는데, 다온 씨가 먼저 봐야 할 것 같아서 안 읽었어요. 제목만.
# cut: daon_face_shy_01 # from: daon
…할아버지 글씨 진짜 못생겼다.
그녀가 고개를 숙인다. 어깨가 한 번 떨린다. 그리고 웃는다. 처음 보는 얼굴로.
# cut: daon_face_smile_01 # from: daon
미역국은 제가 끓여 먹어요. 할아버지보다 잘 끓여요.
-> dawn_end

= dawn_end
# from: daon
라면 불었어요. 먹어요.
동이 튼다. 편의점 유리창이 주황색으로 물든다. 그녀가 불은 라면을 끝까지 먹는다.
# scene: end
# memo: daon
처음으로 웃는 얼굴을 봤다. 새벽 여섯 시 반, 병원 앞 편의점.
-> morning

= morning
# time: 10:30
{not k_jeju: -> jeju_again | -> jeju_share}

= jeju_again
# at: home
-> jeju_offer ->
-> jeju_share

= jeju_share
{not k_jeju: -> call}
# room: daon
* [영상 보내기 # say: 다온 씨, 이 영상… 할아버지 아니에요? 튜브에 "제주 만물수선"이라고.]
    ~ raise(aff_daon, 2)
    # wait: 8
    …
    할아버지 목소리네요.
    엄마가 올렸나 봐요. 라디오 소리도 똑같아요. 가게에 있던 거.
* [말하지 않기 # act]
    # note: 3월 18일
    영상을 보내지 않았다. 그녀가 아침까지 일했으니까. 지금은 자야 하니까.
- -> call

= call
# time: 15:00 # wait: 1.5
# call: boss # unknown
* [받기 # answer]
    -> boss_call_open ->
    …근데 말이여. 우리 다온이는 밥은 먹고 다니나?
    # from: me
    …다온 씨가 많이 서운해해요. 번호 없애신 날, 말도 없이 가셨다고요.
    …
    …걔가 나한테 화났지.
    * * [직접 전화해 주세요 # say: 다온 씨한테 직접 전화해 주세요. 다온 씨, 문자보다 전화가 편하대요.]
        ~ f_daon_grandpa = true
        ~ raise(aff_daon, 3)
        …내가 먼저 하면, 받을까.
        # from: me
        받을 거예요. 근무 중이면 쉬는 시간에 꼭 다시 걸어요. 그런 사람이에요.
        …허허. 나 닮았네.
    * * [잘 지내요 # say: 잘 지내요. 걱정 마세요.]
        ~ raise(aff_daon, -3)
        그려. 다행이네.
        # narr
        (거짓말이다. 사장님도 알았을 거다. 목소리가 그랬다.)
    - - 그리고 그 간판 말이여.
    다온이 주고. 아니면 자네가 써. 만물수선, 자네가 해도 되고.
    # from: me
    …제가요?
    못 고치면 못 고친다고 하는 사람이 제일 잘 고쳐. 삼십 년 해 보니까 그려.
    -> boss_call_close ->
* [거절 # decline]
    # voicemail: boss
    …여보세요. 만물수선 번호 쓰는 사람인가. 김용수여. 이 번호 전 주인.
    # voicemail: boss
    바쁜가 보네. …우리 다온이 밥은 먹고 다니나. 걔가 나한테 화났을 겨. 말도 없이 왔으니까.
    # voicemail: boss
    간판은 다온이 주고. 아니면 자네가 써. 만물수선, 자네가 해도 되고.
    # voicemail: boss
    고치는 건 기술이 아니라 끈기여. 그 번호, 잘 부탁혀.
    # note: 3월 18일
    064. 제주. 음성사서함에 사장님 목소리가 남았다. 다온 씨 이름이 두 번 나온다.
- -> evening

= evening
{f_daon_grandpa: -> reunion | -> quiet}

= reunion
# time: 21:30
# room: daon
할아버지한테 전화 왔어요.
# typing: 3
한 시간 통화했어요. 할아버지가 먼저 미안하다고 했어요. 처음이에요.
# typing: 2
그쪽이 전화하라고 했다면서요.
고마워요
~ raise(aff_daon, 5)
# note: 3월 18일
"고마워요" 뒤에 마침표가 없다. 메시지에서는 처음이다.
-> night

= quiet
# time: 21:30
# room: daon
오늘 할아버지 목소리 들었어요. 튜브로.
…전화는 못 하겠어요. 아직.
-> night

= night
# time: 22:10 # at: home
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    # ask: 오늘 밤 볼 영상
    * * {not k_bolt} [녹슨 볼트 푸는 법 # watch: bolt]
        -> video_bolt ->
    * * [그만 보기]
    - - -> close
* [일찍 자기 # act]
    -> close

= close
# dayend
-> daon_d11


// ════════════════════════════════
// D11 — 3월 19일 목요일 (흐림): 대전
// ════════════════════════════════
=== daon_d11 ===
# day: 11
# time: 13:00
# note: 3월 19일
흐림.
# room: daon
대전에 있는 병원에서 오라고 했어요. 다음 달부터.
# typing: 2.5
할아버지 가시고 나서 지원했었어요. 여기 있으면 자꾸 생각나서요.
# typing: 2
가게도 없어지고, 번호도 남의 거고.
여기 있을 이유가 없네요.
# typing: 1.5
번호 쓰시는 분이 신경 쓸 일은 아니에요.
# note: 3월 19일
"번호 쓰시는 분." 처음 만났을 때 그녀가 나를 부르던 말이다.
# ask: 어떻게 할까?
* [알겠어요 # act]
    # room: daon
    # from: me
    알겠어요. 다온 씨가 정할 일이죠.
    # wait: 8
    네.
    # note: 3월 19일
    "네." 마침표. 그걸로 끝이었다. 나는 신경 쓸 자격이 없는 사람처럼 굴었다. 그게 편했다.
    -> alone_night
* [대전 좋은 곳이에요 # act]
    ~ raise(aff_daon, -2)
    # room: daon
    # from: me
    대전 좋은 곳이에요. 성심당도 있고요.
    # wait: 10
    …네.
    -> alone_night
* [전화한다 # act]
    ~ f_daon_stay = true
    -> call

= call
# time: 13:10
# call: daon # outgoing
…왜 전화해요.
# from: me
신경 쓰여서요. 번호 쓰는 사람이 신경 쓸 일 맞아요.
…
# from: me
간판, 제가 맡을게요. 떼서 보관할게요. 방보다 길면 방을 치우죠.
# from: me
그리고… 다온 씨가 여기 있을 이유, 제가 하나 만들면 안 돼요?
# narr
(수화기 너머가 조용하다. 끊긴 줄 알았다. 숨소리가 들린다.)
…무슨 뜻이에요.
# from: me
만물수선, 제가 해 볼게요. 못 고치면 못 고친다고 하면서요. 그럼 다온 씨 할아버지 번호로 오는 전화, 계속 받을 수 있잖아요.
…
…간판 떼는 거, 혼자 못 해요. 무거워요.
# from: me
혼자 안 해요.
…금요일 오후 두 시. 저 오프예요.
~ raise(aff_daon, 6)
# call: end
# plan: sign_day, 12, 14:00, 간판 떼는 날 · 만물수선 자리
-> help

= help
# time: 15:00
# ask: 간판 떼는 날, 도움을 구할까?
* [망원살이에 도움 요청 글 올리기 # act]
    ~ f_daon_help = true
    # town: t_sign_help, 부탁해요, 나
    [부탁해요] 3월 20일(금) 오후 2시, 만물수선 간판 떼는 날 도와주실 분
    # town: t_sign_help
    시장 끝 만물수선 자리 간판을 떼서 보관하려고 합니다. 사다리 있으신 분, 힘 좀 쓰시는 분, 그냥 보러 오실 분 모두 환영해요.
    # townreply: t_sign_help, 망원정육 최사장
    사다리 있음 ㅋㅋ 총각 나 간다
    # townreply: t_sign_help, 해든빌라 관리실
    공구 가져감
    # townreply: t_sign_help, 망원토박이
    그 간판 우리 동네 거예요. 갈게요
    # townreply: t_sign_help, 떡집 단골
    할머니가 떡 해 가신대요
    # note: 3월 19일
    망원살이에 처음으로 글을 올렸다. 한 시간 만에 댓글이 열두 개.
* [단골방에만 말하기 # act]
    # room: dangol
    # from: me
    금요일 오후 두 시에 만물수선 간판 떼려고요. 도와주실 분 계세요?
    # from: choi
    사다리 있음 ㅋㅋ
    # from: guard
    공구 가져감
- -> night

= alone_night
# time: 23:00 # at: home
# note: 3월 19일
간판은 월요일에 철거된다. 대전은 다음 달이다. 나는 아무것도 하지 않기로 했다.
-> night

= night
# time: 23:10 # at: home
{f_daon_stay && not k_bolt: -> bolt_night}
# dayend
-> daon_d12

= bolt_night
# note: 3월 19일
간판 볼트가 삼십 년 동안 녹슬었을 거다. 튜브를 연다.
# ask: 오늘 밤 볼 영상
* [녹슨 볼트 푸는 법 — 힘이 아니라 기다림 # watch: bolt]
    -> video_bolt ->
* [그만 보기]
- # dayend
-> daon_d12


// ════════════════════════════════
// D12 — 3월 20일 금요일 (맑음, 춘분): 간판, 그리고 9시
// ════════════════════════════════
=== daon_d12 ===
# day: 12
# time: 10:00
# note: 3월 20일
맑음. 춘분.
{f_daon_stay: -> sign_day | -> sign_alone}

= sign_day
# time: 14:00
# scene: bg_shop_site_day_01 # at: shop, 간판 떼는 날
오후 두 시. 만물수선 자리 앞에 사람이 모여 있다.
최 사장님의 사다리, 경비 아저씨의 공구함, 박 할머니의 떡 상자. {f_daon_help: 망원살이를 보고 온 모르는 얼굴들도 여럿이다.}
커피 캐리어를 든 윤서하, 스케치북을 든 채이안도 있다. 서하 씨는 커피를 돌리고, 이안 씨는 간판을 그린다.
# cut: daon_scene_sign_01 # from: daon
왔어요. 두 시 정각.
사다리에 오른다. 간판 네 귀퉁이의 볼트가 삼십 년 치 녹으로 덮여 있다.
{ k_bolt:
    -> bolt_known
- else:
    -> bolt_hard
}

= bolt_known
(힘이 아니라 기다림. 윤활제, 10분, 톡톡, 조금씩.)
방청제를 뿌린다. 사다리 위에서 10분을 기다린다. 밑에서 최 사장님이 "뭐 해 총각!" 하고 외친다.
# from: me
기다리는 거예요!
망치로 볼트 머리를 톡톡. 사각, 녹이 깨지는 소리. 조금씩, 여러 번.
# fx: zoom
하나, 둘, 셋, 넷. 볼트가 풀린다.
~ raise(aff_daon, 4)
-> sign_down

= bolt_hard
힘껏 돌린다. 꿈쩍도 안 한다. 한 시간이 지난다. 손바닥이 벗겨진다.
# from: choi
힘으로 하지 마 총각! 머리 뭉개져!
# from: guard
사장님은 기름 뿌리고 담배 한 대 피우고 했어.
# from: daon
…할아버지는 기다렸어요. 끈기여, 하면서.
기름을 뿌리고 기다린다. 다시 돌린다. 조금씩. 두 시간 만에, 네 번째 볼트가 풀린다.
~ raise(aff_daon, 2)
-> sign_down

= sign_down
# cut: bg_shop_site_day_01
"하나, 둘, 셋!" 여럿이 받쳐 든 간판이 천천히 내려온다. 박수가 터진다. 박 할머니가 운다.
# cut: daon_scene_sign_01
땅에 내려온 간판 앞에 그녀가 쪼그려 앉는다. "수" 자의 삐친 획을 손끝으로 쓸어 본다.
# from: daon
…할아버지 글씨예요.
~ f_daon_sign = true
# gallery: daon_cg_sign_01
간판 앞에 선 그녀를 한 장 찍는다. 얼굴은 안 나오게, 간판과 운동화만.
# scene: end
# room: daon # time: 17:20
* [사진 보내기 # attach: daon_cg_sign_01]
    ~ raise(aff_daon, 2)
    # wait: 4
    …이거 프사 해도 돼요.
    아니 할게요. 물어본 거 아니에요.
- -> nine

= sign_alone
# time: 14:00
# town: t_demolish
철거 전 가림막 설치 완료. 간판은 폐기 예정입니다.
# note: 3월 20일
망원살이 공지에 한 줄이 붙었다. "간판은 폐기 예정."
# room: daon # time: 17:00
간판 오늘 떼 갔대요. 철거 업체가.
괜찮아요.
-> nine

= nine
# time: 18:30
# room: daon
{aff_daon >= 75: 🙂|오늘 9시에 끝나요.}
{aff_daon >= 75: 오늘 퇴근 9시. 기다리든가.}
# note: 3월 20일
{aff_daon >= 75: 처음 보는 이모티콘이다. 그 사람이 쓴.|9시에 끝난다는 메시지. 오라는 말은 없다. 오지 말라는 말도 없다.}
# time: 20:40 # wait: 1
# call: choi
* [받기 # answer]
    총각! 간판 어디 둘 거야? 지금 잠깐 와서 자리 좀 봐 줘!
    * * [지금은 안 돼요 # say: 지금은 안 돼요. 9시 약속이 있어요. 내일 갈게요!]
        ~ f_daon_ontime = true
        ㅋㅋ 약속? 다온이지? 알았어 알았어!
    * * [잠깐만 갈게요 # say: 네 네, 잠깐만 갈게요!]
        ~ f_daon_ontime = false
        역시 총각!
    - - # call: end
* [거절 # decline]
    ~ f_daon_ontime = true
- -> hospital_nine

= hospital_nine
{f_daon_ontime: -> ontime | -> late}

= ontime
# time: 20:58
# scene: bg_hospital_ext_night_01 # at: hospital, 9시
8시 58분. 병원 앞 흰 불빛. 9시 정각에 유리문이 열린다.
# cut: daon_face_neutral_01 # from: daon
9시 정각.
~ raise(aff_daon, 3)
-> confess

= late
# time: 21:07
# scene: bg_hospital_ext_night_01 # at: hospital, 9시
9시 7분. 최 사장님 가게에서 뛰어왔다. 그녀가 유리문 앞에 서 있다. 팔짱을 끼고.
# cut: daon_face_pout_01 # from: daon
7분.
# from: daon
…오늘은 봐줄게요. 간판 뗀 사람이니까.
-> confess

= confess
# cut: daon_face_neutral_01
그녀가 가운을 벗어 팔에 건다. 흰 불빛 아래에서, 그녀가 먼저 입을 연다.
{ aff_daon >= 70:
    # from: daon
    할 말 있어요. 돌려 말하는 거 못 해요.
    # cut: daon_face_shy_01 # from: daon
    좋아해요. 그 번호 말고. 당신이.
- else:
    # from: daon
    오늘 고마웠어요. 간판도, 할머니도, 전부.
    # from: daon
    …할 말이 더 있는데, 아직 모르겠어요.
}
* [저도요 # say: 저도요. 다온 씨가 좋아요. 번호 말고, 다온 씨가.]
    ~ f_daon_confess = true
    ~ raise(aff_daon, 5)
* [밥은 먹었어요? # say: …밥은.]
    ~ f_daon_confess = true
    ~ raise(aff_daon, 5)
    # cut: daon_face_smile_01 # from: daon
    …그걸 지금 물어요?
    # from: me
    그게 제일 중요하다면서요. 할아버지가.
* [고마워요 # say: 고마워요. 오늘 와 줘서.]
    # from: daon
    …네.
    (그녀가 뭔가 기다리는 얼굴을 한다. 나는 끝내 말하지 못한다.)
    # scene: end
    -> night
- { aff_daon >= 70:
    # cut: daon_face_smile_01 # from: daon
    …확인.
    그녀가 한 발 다가온다. 키가 거의 같아서, 고개를 들 필요가 없다. 입술이 닿는다. 아주 짧게. 그리고 그녀가 떨어진다.
    # from: daon
    확인했어요. 밥은 내일 먹어요. 같이.
- else:
    # cut: daon_face_surprised_01 # from: daon
    …
    # from: daon
    대답은 대전 병원에 먼저 해야 해요. 그다음에요.
}
# fade
병원 앞 흰 불빛. 두부가 유리문 안쪽에서 우리를 지켜본다.
# scene: end
-> night

= night
# dayend
-> daon_d13


// ════════════════════════════════
// D13 — 3월 21일 토요일 (맑음): 대답, 그리고 판정
// ════════════════════════════════
=== daon_d13 ===
# day: 13
# time: 11:00
# room: daon
{ aff_daon >= 75 && f_daon_stay:
    대전 병원에 연락했어요.
    안 간다고요.
    # typing: 2
    여기 있을 이유가 생겨서요.
    ~ raise(aff_daon, 2)
- else:
    대전 병원에 연락했어요.
    다음 달부터 가요.
    # typing: 2
    …좋은 병원이에요.
}
{f_daon_sign: -> workbench | -> judge}

= workbench
# time: 15:00
# scene: bg_villa_front_01 # at: home, 만물수선 작업대
해든빌라 앞. 경비 아저씨가 관리실 옆 빈자리를 내준다. "주말에만 해. 시끄럽게 하지 말고."
최 사장님이 버리는 진열대를 가져온다. 그 위에 간판을 올린다. 만물수선. "수" 자의 삐친 획.
# from: guard
사장님 가게 같네.
# scene: end
# town: t_bench, 동네생활, 해든빌라 관리실
해든빌라 앞에 만물수선 생겼습니다 (주말만)
# town: t_bench
그 번호 그대로임. 못 고치면 못 고친다고 한답니다
# townreply: t_bench, 망원토박이
헐 라디오 들고 갑니다!!!
# townreply: t_bench, 떡집 단골
간판 그대로네요ㅠㅠ 반가워라
-> judge

= judge
# time: 23:30 # at: home
# note: 3월 21일
{f_daon_sign: 간판이 해든빌라 앞에 걸렸다. 삐친 "수" 자가 가로등 아래에서 웃는 것 같다.|간판은 없다. 번호는 남았다.}
# dayend
{ aff_daon >= 75 && f_daon_stay && f_daon_sign:
    -> ending_daon_good
- else:
    -> ending_daon_normal
}
