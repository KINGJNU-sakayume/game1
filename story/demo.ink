// ⚠ 엔진 시험용 임시 대본 (M2~). 실제 스토리가 아니다.
// 태그와 연출이 제대로 동작하는지 확인하기 위한 것으로, D1 대본을 쓰면 main.ink에서 교체한다.
// 대사는 02_캐릭터_바이블.md의 말투 예시를 빌려 왔다.

=== demo_start ===
# day: 1
# time: 08:10
# room: dangol
# from: system
{player_name}님이 초대되었습니다.
# from: choi
김 사장님 번호 살아있네? 누구세요~
# from: halmeoni # big
반가워요
# from: guard # time: 08:12
201호 총각 아닌가
# wait: 2
-> seoha_first

=== seoha_first ===
# room: seoha # time: 08:14
안녕하세요, 카페 오후세시입니다.
사장님 이번 주 방문 가능하실까요?
* [사실 저 사장님이 아니라서요 # draft: 네 물론이죠! 언제 갈까요? # keep]
    ~ raise(aff_seoha, 15)
    # typing: 2.5
    아… 번호가 바뀐 거군요.
    그래도 혹시 기계 좀 보실 줄 아세요? :)
    -> seoha_ask
* [네, 오늘 가능해요]
    ~ raise(aff_seoha, 5)
    잘됐다. 스팀 노즐이 안 나와서요.
    -> seoha_ask
* [나중에 답하기 # act]
    # wait: 1
    -> two_rooms

= seoha_ask
* [한번 볼게요]
    감사해요. 오후에 들러 주세요 :)
* [잘 모르는데… 솔직히 # say: 솔직히 잘은 모르는데, 한번 볼게요]
    ~ raise(aff_seoha, 15)
    솔직하게 말해줘서 오히려 좋네요 :)
- # plan: seoha_machine, 2, 14:00, 에스프레소 머신 수리 · 카페 오후세시
# todo: machine, 에스프레소 머신 스팀 노즐 고치는 법 찾아보기
-> two_rooms

=== two_rooms ===
# time: 21:40
# room: ian
안녕하세요!! 윗집인데요
혹시 수리 사장님 맞으세요? 형광등이 깜빡깜빡 🥲
# room: daon # time: 21:41
김용수 사장님 번호 쓰시는 분 맞죠.
* [ian # open: ian]
    -> ian_first
* [daon # open: daon]
    -> daon_first

=== ian_first ===
# room: ian
사진 보내드릴게요
# photo: ian_selfie_desk_01
형광등 사진
* [ㅋㅋ 내일 가볼게요]
    ~ raise(aff_ian, 10)
    ㅋㅋㅋㅋㅋ 아니 진짜요?? 천재?
* [깜빡이는 것만 봐선 잘 모르겠네요]
    아 그쵸 ㅋㅋ 🥲
- # room: daon
그 번호 왜 쓰세요.
-> demo_end

=== daon_first ===
# room: daon
그 번호 왜 쓰세요.
* [통신사에서 받은 번호예요]
    ~ raise(aff_daon, 5)
    그렇군요.
* [사장님 손님들 연락이 계속 와서요]
    할아버지 손님들이요.
- # room: ian # typing: 0.8
저기요?? 😢
-> demo_end

=== demo_end ===
# room: dangol # from: system # wait: 1
첫째 날 시험 대본이 끝났습니다.
# note: 3월 9일
번호 하나 바꿨을 뿐인데 하루가 이렇게 길 줄은 몰랐다.
# note: 3월 9일
내일은 에스프레소 머신. 유튜브부터 보자.
# dayend
-> demo_day2

// 둘째 날: 날짜 저장(체크포인트)과 호감 단계 변화 확인용
=== demo_day2 ===
# day: 2 # time: 09:05 # room: seoha
{aff_seoha >= 25: 어제 정말 감사했어요. 커피 한 잔 빚진 걸로 할게요 :)|좋은 아침이에요.}
* [별말씀을요]
    오늘도 좋은 하루 보내요 :)
* [커피는 제가 살게요]
    ~ raise(aff_seoha, 5)
    그럼 오늘 오후에 들러요 :)
- -> demo_scene

// 대면 장면: 폰이 꺼지듯 어두워지고 1인칭 컷 + 대사창 (M4)
=== demo_scene ===
# time: 14:00 # scene: bg_cafe_day_01
카페 오후세시. 문을 열자 커피 냄새가 먼저 온다.
# cut: seoha_scene_machine_01 # from: seoha # gallery: mc_cg_tools_01
오셨어요? 이거예요, 스팀이 하나도 안 나와요.
(유튜브에서 본 거랑 모양이 다르다.)
* [아는 척 도전하기]
    ~ raise(aff_seoha, -5)
    # fx: shake
    푸슉— 뜨거운 김이 사방으로 튄다.
    # from: seoha
    괜찮아요?!
* [솔직하게 모른다고 하기 # say: 솔직히 이 모델은 처음 봐요. 같이 설명서 찾아봐도 될까요?]
    ~ raise(aff_seoha, 10)
    # fx: zoom # from: seoha
    …그런 말 하는 사람 처음 봐요.
- # fade # done: machine
그날 오후는 생각보다 길었다.
# scene: end
-> demo_call

// 영상통화: 받기 / 거절이 선택 (M4)
=== demo_call ===
# time: 23:40 # wait: 1.5
# call: ian # video
* [받기 # answer]
    # cut: ian_call_night_01
    앗 받았다 ㅋㅋ 안 자고 있었죠?
    형광등 진짜 고마워서요. 얼굴 보고 말하고 싶었어요.
    * * [나도 얼굴 보니까 좋네요]
        ~ raise(aff_ian, 10)
        헉 ㅋㅋㅋ 잘 자요!!
    * * [내일 또 깜빡이면 불러요]
        네 ㅋㅋ 그럼 잘 자요
    - - # call: end
* [거절 # decline]
    ~ raise(aff_ian, -5)
    # room: ian # typing: 1
    앗 자는구나 🥲
- # room: ian
{saved("ian_selfie_desk_01"): 아 근데 어제 사진 저장했어요? ㅋㅋ|어제 사진 봤어요? ㅋㅋ}
# page: 에스프레소 머신 (오후세시)
스팀 노즐 막히면 우유 찌꺼기부터. 바늘로 살살.
# page: 에스프레소 머신 (오후세시)
사장님이 기계 무서워함. 천천히 설명해 줄 것.
# dayend
# room: dangol # from: system
엔진 시험 대본이 끝났습니다.
-> END
