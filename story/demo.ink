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
* [사실 저 사장님이 아니라서요 # draft: 네 물론이죠! 언제 갈까요?]
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
- -> two_rooms

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
- # room: dangol # from: system # wait: 1
엔진 시험 대본이 끝났습니다.
-> END
