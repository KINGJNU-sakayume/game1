// D3 — 3월 11일 수요일 (흐림)
// 첫 지도 선택(단골 의뢰 하나 고르기), 이안의 부탁과 8시 정각 사이, 동물병원 앞 김다온 대면, 사장님 수첩.
// 문법: docs/05_스크립트_문법.md

// ── D3에서 생기는 플래그 ──
VAR f_d3_boiler = false      // 경비 아저씨 보일러를 고쳤다
VAR f_d3_fridge = false      // 최 사장 냉장고 문 고무를 고쳤다
VAR f_d3_cafe = false        // 커피 빚을 받으러 오후세시에 갔다
VAR f_d3_late = false        // 이안의 부탁을 들어주다 8시에 늦었다
VAR f_daon_time = false      // 다온과의 첫 약속에 늦지 않았다
VAR f_daon_liar = false      // 다온 앞에서 끝까지 거짓말했다 (조카 → 먼 친척 → 또)
VAR f_daon_key = false       // 다온 루트 핵심: 시간을 지켰고 거짓말하지 않았다 (D5에 한 번 더 기회)
VAR f_d3_number = 0          // 다온에게 번호를 어떻게 하겠다고 했나 (1 모르겠다·모른 척 못 함 / 2 바꾸겠다 / 3 다온이 원하면)


// ════════════════════════════════
// 아침
// ════════════════════════════════
=== d03_morning ===
# day: 3
# time: 07:30
# note: 3월 11일
흐림. 알람보다 먼저 단톡방이 나를 깨운다.
{f_d2_slept && not f_d2_doodle_replied: -> doodle | -> d03_chat}

= doodle
# note: 3월 11일
자는 동안 윗집에서 낙서가 왔다. 스냅에도 같은 그림이 올라와 있다. "수리 기사님 (허락 안 받음)".
# room: ian
* [공구함 든 사람, 설마 저예요? # say: 이제 봤어요 ㅋㅋ 공구함 든 사람 설마 저예요?]
    ~ raise(aff_ian, 5)
    ~ f_ian_eye = true
* [잘 그리시네요 # say: 이제 봤어요. 잘 그리시네요.]
    ~ raise(aff_ian, -1)
* [형광등 표정이 웃겨요 # say: 형광등이 웃고 있어요 ㅋㅋ 어제 그 형광등 맞죠?]
    ~ raise(aff_ian, 3)
- ~ f_d2_doodle_replied = true
# note: 3월 11일
답장을 보냈다. 윗집은 이 시간에 자고 있을 거다. "1"이 한참 안 사라진다.
-> d03_chat


=== d03_chat ===
# time: 08:10
# room: dangol
# from: guard
총각 보일러 오늘 되나
# from: choi
냉장고 고무 테이프 또 떨어짐 ㅋㅋ 고기는 무사함
# from: halmeoni # big
떡솥
# from: choi
할머니 떡솥은 줄 서요 ㅋㅋ 내가 먼저임
# from: guard
내가 먼저 말했는데
# from: choi
아저씨 보일러는 내일 와도 된다면서요 ㅋㅋㅋ
# note: 3월 11일
의뢰가 줄을 섰다. 몸은 하나다. 오늘 낮에 하나쯤은 해치울 수 있을 것 같다.
# time: 08:40
# town: t_sign, 동네생활, 망원 산책러
시장 끝 만물수선 자리 지나가는데
# town: t_sign
셔터는 내려져 있고 간판만 그대로네요. 30년 된 손글씨 간판… 이거 없어지면 좀 슬플 듯
# townreply: t_sign, 떡집 단골
김 사장님 번호는 요즘 어떤 총각이 받았다던데요 ㅋㅋ
# townreply: t_sign, 망원토박이
그 총각이 수리도 한대요? 우리 집 라디오 어떡하냐
# pin: shop
# note: 3월 11일
동네 게시판에 내 얘기가 올라왔다. "그 총각". 지도에 핀이 하나 늘었다. 만물수선 자리.
-> d03_where


// ════════════════════════════════
// 낮 — 첫 지도 선택
// ════════════════════════════════
=== d03_where ===
# time: 10:30
# ask: 오늘 낮, 어디부터 갈까?
* [해든빌라 보일러실 (경비 아저씨) # go: home]
    -> d03_boiler
* [망원시장 정육점 (최 사장) # go: market]
    -> d03_fridge
* {aff_seoha >= 15} [카페 오후세시 (커피 빚) # go: cafe]
    -> d03_cafe
* [오늘은 집에서 쉬기]
    -> d03_rest


// ── 보일러실: 경비 아저씨 ──
=== d03_boiler ===
# time: 11:00
# scene: bg_villa_boiler_01 # at: home, 보일러 소음
해든빌라 지하 보일러실. 곰팡이 냄새와 쇳소리가 같이 난다. 끼익. 끼익.
# from: guard
여기. 밤마다 이래.
경비 아저씨는 팔짱을 끼고 문 앞에 선다. 말이 짧은 사람은 기다리는 것도 짧을 것 같다.
{k_boiler: -> knows | -> guess}

= knows
(쇠 긁는 소리. 공기가 찬 것. 오반장님 목소리가 머릿속에서 재생된다.)
순환펌프 옆 작은 꼭지. 양동이를 대고 반 바퀴만 돌린다.
# fx: zoom
쉭— 바람 빠지는 소리 뒤에 물이 톡 떨어진다. 바로 잠근다.
끼익 소리가 멎는다. 보일러가 낮게, 고르게 웅웅거린다.
# from: guard
…됐네.
# from: guard
사장님은 이거 하는 데 십 분 걸렸어.
(나는 이십 분 걸렸다. 그래도 됐다.)
~ f_d3_boiler = true
-> done

= guess
* [아는 척 도전하기 # say: 이건 보통… 이 밸브를 돌리면…]
    # fx: shake
    눈에 띄는 밸브를 힘껏 돌리자 배관 이음새에서 물줄기가 뿜어져 나온다.
    # from: guard
    내 이럴 줄 알았어.
    아저씨가 익숙한 손놀림으로 메인 밸브를 잠근다. 나는 젖은 운동화로 서 있다.
    # from: guard
    모르면 모른다고 해. 사장님도 그랬어.
    * * [사실 몰라요 # say: …사실 하나도 몰라요. 죄송해요.]
        # from: guard
        진작 그러지.
        # from: guard
        보일러 회사 부를게. 총각은 걸레나 가져와.
    - - -> done
* [모르겠다고 하기 # say: 솔직히 모르겠어요. 보일러 문에 붙은 설명서부터 같이 볼까요?]
    # from: guard
    …그래.
    보일러 문 안쪽에 누렇게 바랜 설명서가 붙어 있다. "소음 발생 시: 에어 빼기."
    그림 속 화살표가 가리키는 작은 꼭지를 둘이 한참 쳐다본다.
    # from: guard
    사장님이 저거 만지는 거 봤어. 통 받치고.
    양동이를 대고 조심조심 돌린다. 쉭— 물이 나오자마자 아저씨가 "잠가!" 하고 외친다.
    # fx: zoom
    끼익 소리가 멎는다.
    ~ f_d3_boiler = true
    -> done

= done
{f_d3_boiler: 아저씨가 관리실에서 캔 커피를 하나 꺼내 내민다. 차갑다.|아저씨가 보일러 회사에 전화를 건다. 통화 대기음이 길다.}
# scene: end
# done: boiler
# memo: guard
해든빌라 경비 아저씨. 말이 짧다. 내가 뭘 망치면 제일 먼저 본다.
-> d03_afternoon


// ── 망원시장: 최 사장 냉장고 ──
=== d03_fridge ===
# time: 11:10
# scene: bg_market_day_01 # at: market, 정육점 냉장고
망원시장 한가운데. 망원정육 간판 아래에서 최 사장님이 두 팔을 벌린다.
# from: choi
오 총각! 실물 처음 보네 ㅋㅋ 생각보다 멀쩡하게 생겼네.
쇼케이스 냉장고 문짝에 투명 테이프가 세 겹으로 붙어 있다. 고무가 축 늘어져 문이 떠 있다.
{k_gasket: -> knows | -> guess}

= knows
(테이프는 진통제. 드라이기로 데우고 5분. 오반장님의 말.)
# from: me
혹시 드라이기 있어요?
# from: choi
정육점에 드라이기가 왜 있어 ㅋㅋ 아 잠깐, 떡집 할머니!
맞은편 떡집에서 박 할머니가 머리에 쓰는 드라이기를 들고 종종걸음으로 온다.
따뜻한 바람을 고무에 골고루 쏘이고, 문을 닫고, 5분을 기다린다. 최 사장님이 그 5분을 못 참고 세 번 문을 열려고 한다.
# fx: zoom
5분 뒤. 문이 쩍 하고 달라붙는다.
# from: choi
오오오 총각 천재네! 테이프 떼도 되지? 뗀다?
~ f_d3_fridge = true
-> done

= guess
* [아는 척 도전하기 # say: 이건 보통 테이프를 더 세게…]
    # fx: shake
    테이프를 한 겹 더 붙였다. 최 사장님이 문을 닫자마자 테이프째로 고무가 스르르 흘러내린다.
    # from: choi
    ㅋㅋㅋㅋㅋ 총각 이거 내가 어제 한 거랑 똑같잖아
    # from: choi
    됐어 됐어, 오늘은 고기나 좀 가져가.
    -> done
* [모르겠다고 하기 # say: 솔직히 처음 보는 거예요. 고무 파는 데가 있을까요?]
    # from: choi
    ㅋㅋ 솔직하네. 시장 끝에 대성철물. 사장님이 맨날 거기서 사 갔어.
    # pin: hardware
    대성철물 할아버지는 냉장고 모델명을 듣더니 선반 맨 아래에서 고무를 꺼낸다. "김 사장이 늘 사 가던 거."
    낑낑대며 한 시간. 새 고무를 끼운 문이 쩍 하고 달라붙는다.
    # from: choi
    오 붙었다! 총각 근성 있네 ㅋㅋ
    ~ f_d3_fridge = true
    -> done

= done
# from: choi
자, 이거. 수리비 대신 목살 한 근.
검은 봉지가 손에 쥐여진다. 맞은편에서 박 할머니가 손짓한다. 가래떡 두 줄이 기다리고 있다.
# from: halmeoni
총각, 떡솥은 내일이나 모레 와요. 급한 거 아니야. 아니 급해.
# scene: end
# done: choi_fridge
# memo: choi
망원정육 최 사장님. 목소리가 크고 성격이 급하다. 5분을 못 기다린다.
-> d03_afternoon


// ── 오후세시: 커피 빚 ──
=== d03_cafe ===
~ f_d3_cafe = true
# time: 11:30
# scene: bg_cafe_day_01 # at: cafe, 커피 한 잔
점심 전의 오후세시는 조용하다. 원두 가는 소리만 가끔 난다.
# cut: seoha_face_smile_01 # from: seoha
오셨네요. 빚 갚을게요. 뭐 마실래요?
* [라떼요 # say: 라떼요. 스팀 잘 되나 보게요.]
    ~ raise(aff_seoha, 2)
    # from: seoha
    검사하러 온 거예요? ㅎㅎ 네, 검사받을게요.
* [추천해 주세요]
    ~ raise(aff_seoha, 3)
    # from: seoha
    그럼 제가 제일 좋아하는 걸로요. 사람들은 잘 안 시키는 거.
- 그녀가 잔을 내려놓고 맞은편에 앉는다. 영업 중에 앉는 건 처음 보는 것 같다.
# from: seoha
근데 원래는 무슨 일 하셨어요? 평일 낮에 시간이 되시네요.
* [광고 회사 다녔어요 # say: 광고 회사 다니다가, 2주 전에 그만뒀어요.]
    ~ raise(aff_seoha, 3)
    # from: seoha
    아. 그래서 말을 잘하시는구나.
    # from: me
    말만 잘했죠. 할 줄 모르는 것도 할 수 있다고 하는 게 일이었어요.
    # cut: seoha_face_surprised_01 # from: seoha
    …그래서 첫날 그렇게 솔직했던 거예요?
    {f_seoha_key: (그녀가 웃는다. 첫날 그 말이 이 사람한테는 오래 남은 모양이다.)|(첫날 나는 솔직하지 않았다. 대답할 말이 없다.)}
* [그냥 쉬는 중이에요 # say: 그냥… 쉬는 중이에요.]
    # from: seoha
    쉬는 것도 일이죠. 저도 가게 열기 전엔 몰랐어요.
- # from: seoha
저도 가게 열기 전엔 프랜차이즈 점장이었어요. 6년.
# from: seoha
매일 본사 매뉴얼대로 커피를 만들다가, 어느 날 제 커피가 만들고 싶어졌어요.
그녀의 시선이 계산대 옆 서류 봉투에 잠깐 머문다. 봉투에는 "임대차 계약 만료 안내"라고 찍혀 있다. 그녀가 봉투를 서랍에 넣는다.
# cut: seoha_face_smile_01 # from: seoha
언젠가는 원두도 직접 볶고 싶어요. 로스터는 너무 비싸서 꿈만 꾸지만요 :)
* [꿈은 공짜니까요]
    ~ raise(aff_seoha, 1)
    # from: seoha
    맞아요. 제일 싼 게 꿈이에요 ㅎㅎ
* [볶은 원두 나오면 제일 먼저 마실게요]
    ~ raise(aff_seoha, 3)
    # from: seoha
    예약 받았습니다. 1번 손님.
- # scene: end
# memo: seoha
전에 프랜차이즈 점장이었다. 6년. 언젠가 원두를 직접 볶고 싶어 한다. 계산대 옆에 "임대차 계약 만료 안내" 봉투.
-> d03_afternoon


// ── 집에서 쉬기 ──
=== d03_rest ===
# time: 11:00 # at: home
# note: 3월 11일
오늘은 아무 데도 안 가기로 했다. 단톡방에 미안해서 알림을 잠깐 껐다.
# ask: 집에서 뭐 할까?
* [튜브 보기 # act]
    -> tube
* [그냥 누워 있기 # act]
    # note: 3월 11일
    천장을 봤다. 윗집에서 의자 끄는 소리가 안 난다. 자고 있나 보다.
    -> ian_wakes

= tube
# ask: 낮에 볼 영상
* {not k_boiler} [보일러에서 쇠 긁는 소리 # watch: boiler]
    -> video_boiler ->
* {not k_gasket} [냉장고 문 고무 다시 붙이기 # watch: gasket]
    -> video_gasket ->
* {not k_hinge} [뚜껑이 자꾸 뜰 때 — 경첩 핀 # watch: hinge]
    -> video_hinge ->
* [그라인더가 윙 소리만 날 때 (알고리즘 추천) # watch: grinder]
    -> video_grinder ->
- -> ian_wakes

= ian_wakes
# time: 13:05
# room: ian
헉 이제 일어남 ㅋㅋㅋ
{d03_morning.doodle: 아침 답장 봤어요 ㅋㅋ {f_ian_eye: 설마가 맞음!!|감사!!}}
어? 오늘 집에 있어요? 아래층 조용하던데
# typing: 1.2
저 궁금한 거 있어요
원래 수리하는 사람 아니죠?? 뭐 하는 사람이에요?
* [백수예요 # say: 지금은… 백수예요 ㅎㅎ]
    ~ raise(aff_ian, 3)
    ㅋㅋㅋㅋㅋ 당당해서 좋다
    저도 프리랜서라 반쯤 백수예요. 백수 연대
* [광고 회사 다녔어요 # say: 광고 회사 다니다가 얼마 전에 그만뒀어요.]
    ~ raise(aff_ian, 2)
    헐 광고?? 그럼 그림 쪽이랑 가깝네
    저 광고 외주도 해 봤는데 수정 스무 번 받고 울었어요 ㅋㅋㅋ
- # typing: 1.5
오늘 저녁에 뭐 해요??
* [8시에 약속 있어요]
    헐 데이트? 👀
    * * [아니에요, 수첩 받으러요 # say: 데이트 아니고요 ㅋㅋ 사장님 손녀분한테 수첩 받으러 가요.]
        ~ raise(aff_ian, 1)
        아 다온 씨?? 그 말 짧은 분 ㅋㅋ
        저 그분 무서워요… 근데 고양이한테는 엄청 다정함
    * * [비밀이에요]
        ~ raise(aff_ian, 2)
        오오 비밀 ㅋㅋㅋ 알겠어요 안 물어볼게요
        (라고 해 놓고 이모지 세 개를 더 보낸다. 👀👀👀)
* [아직 몰라요]
    ~ raise(aff_ian, 1)
    그럼 이따 심심하면 연락해요 ㅋㅋ
- -> d03_afternoon


// ════════════════════════════════
// 오후
// ════════════════════════════════
=== d03_afternoon ===
# time: 16:20
# room: dangol
{f_d3_boiler: -> boiler_news}
{f_d3_fridge: -> fridge_news}
-> after_news

= boiler_news
# from: guard
보일러 소리 안 남
# from: guard
총각이 했음
# from: choi
오 ㅋㅋ 총각 보일러도 함?
{f_d3_fridge: -> fridge_news | -> after_news}

= fridge_news
# from: choi
냉장고 문 붙었습니다 여러분 ㅋㅋㅋ 테이프 은퇴
# from: halmeoni # big
최고
-> after_news

= after_news
{f_d3_boiler || f_d3_fridge: -> daon_notice | -> ian_awake}

= daon_notice
# from: daon # time: 16:31
할아버지 단골이에요. 제대로 해 주셔서 고맙습니다.
~ raise(aff_daon, 3)
# from: choi
헐 다온이가 단톡방에 말을 했다
# from: halmeoni # big
다온이 안녕
# note: 3월 11일
{f_d3_boiler: 보일러|냉장고} 하나 고쳤을 뿐인데, 말 짧은 사람이 "고맙습니다"를 썼다. 마침표까지 찍어서.
-> ian_awake

= ian_awake
{d03_rest: -> daon_call}
# time: 16:50
# room: ian
헉 이제 일어남 ㅋㅋㅋ 오늘 해가 떴어요?
{d03_morning.doodle: -> doodle_reply}
-> daon_call

= doodle_reply
{f_ian_eye: 아 그리고 아침 답장 봤어요!! 설마가 맞음 ㅋㅋ 뒷모습 제대로 그리는 중|아침 답장 봤어요 ㅋㅋ 감사!!}
-> daon_call

= daon_call
# time: 17:40 # wait: 1
# call: daon
* [받기 # answer]
    김다온입니다.
    오늘 8시 맞죠.
    # from: me
    네, 8시요.
    …네. 그럼.
    {f_d3_boiler: 보일러 소리 잡으셨다면서요. …이따 봬요.}
    # call: end
    ~ raise(aff_daon, 2)
    # memo: daon
    문자보다 전화를 먼저 건다. 통화는 30초를 안 넘긴다.
* [거절 # decline]
    # room: daon # wait: 2
    전화 안 받으시네요.
    8시입니다.
    ~ raise(aff_daon, -1)
- -> d03_evening


// ════════════════════════════════
// 저녁 — 5분만, 그리고 8시 정각
// ════════════════════════════════
=== d03_evening ===
# time: 19:32
# room: ian
저기요 저기요
지금 잠깐만 올라와 줄 수 있어요?? 😢
모니터가 갑자기 안 켜져요 ㅠㅠ 마감 파일 날아가면 저 죽어요
# typing: 0.8
5분이면 돼요!!
# note: 3월 11일
7시 32분. 동물병원까지는 걸어서 20분. 8시 정각이라고 했다.
* [약속 먼저 가야 해요 # say: 지금 약속 가야 해서요ㅠ 다녀와서 바로 볼게요!]
    ~ raise(aff_ian, 1)
    헉 맞다 8시!! 다녀와요 다녀와요
    저 전원 버튼 백 번 눌러 보고 있을게요 ㅋㅋ
    ~ f_d3_late = false
* [5분만 보고 갈게요]
    -> monitor
* [읽고 출발하기 # act]
    ~ raise(aff_ian, -2)
    # wait: 3
    앗 바쁘구나 🥲
- -> d03_hospital

= monitor
# time: 19:36
# scene: ian_scene_monitor_01 # at: home, 모니터
3층. 모니터 앞에 이안이 쪼그려 앉아 있다. 화면이 까맣다.
책상 뒤로 손을 넣어 보니 케이블 하나가 반쯤 빠져 있다. 꾹 누른다.
# fx: zoom
화면이 켜진다. 그리다 만 새벽의 창가가 그대로 있다.
# cut: ian_face_smile_01 # from: ian
살았다!! 천재?? 진짜 천재??
# from: ian
의자 끌다가 발로 찼나 봐요 ㅋㅋㅋ 고마워요 진짜로
~ raise(aff_ian, 5)
시계를 본다. 7시 49분. 5분은 한참 전에 지났다.
# scene: end
~ f_d3_late = true
-> d03_hospital


// ── 대면: 동물병원 앞 ──
=== d03_hospital ===
{f_d3_late: -> late | -> ontime}

= ontime
# time: 19:58
# scene: bg_hospital_ext_01 # at: hospital, 사장님 수첩
7시 58분. 병원 유리문 너머로 흰 불빛이 보도까지 쏟아진다.
8시 정각에 문이 열린다.
# cut: daon_face_neutral_01 # from: daon
8시 정각이네요.
높게 묶은 검은 머리. 일자 눈썹. 왼쪽 눈 밑의 작은 점. 네이비색 수술복 위에 흰 가운.
(눈높이가 나랑 거의 같다.)
# from: daon
…좋네요.
~ f_daon_time = true
~ raise(aff_daon, 6)
-> talk

= late
# time: 20:07
# scene: bg_hospital_ext_01 # at: hospital, 사장님 수첩
8시 7분. 뛰어왔는데도 7분이다.
유리문 앞에 흰 가운을 입은 사람이 팔짱을 끼고 서 있다.
# cut: daon_face_pout_01 # from: daon
7분 늦으셨어요.
높게 묶은 검은 머리. 일자 눈썹. 왼쪽 눈 밑의 작은 점. 표정은 없는데 눈썹 한쪽이 올라가 있다.
* [변명하기 # say: 윗집 모니터가 갑자기 고장 나서…]
    ~ raise(aff_daon, -3)
    # from: daon
    그건 제 사정이 아니잖아요.
* [사과하기 # say: 죄송합니다. 제 잘못이에요.]
    ~ raise(aff_daon, -1)
    # from: daon
    …네. 다음부턴 그러지 마세요.
- -> talk

= talk
# from: daon
김다온입니다. 여기 수의사예요.
{f_d2_lied_again: -> liar | -> ask}

= liar
# cut: daon_face_neutral_01 # from: daon
먼 친척이라면서요.
# from: daon
엄마한테 물어봤어요. 할아버지 형제분들 다 돌아가셨대요. 먼 친척도 없대요.
* [거짓말이었어요 # say: …거짓말이었어요. 처음엔 당황해서, 그다음엔 들킬까 봐 또. 죄송합니다.]
    ~ raise(aff_daon, 3)
    # from: daon
    …
    # from: daon
    두 번 한 거짓말은 한 번 사과로 안 지워져요.
    # from: daon
    그래도 세 번째는 안 하셨네요.
* [진짜 친척이에요 # say: 진짜예요. 아주 먼… 친척이요.]
    ~ raise(aff_daon, -8)
    ~ f_daon_liar = true
    # cut: daon_face_pout_01 # from: daon
    그래요.
    (그녀는 더 묻지 않는다. 그게 더 무섭다.)
- -> ask

= ask
# from: daon
하나만 물어볼게요. 그 번호, 계속 쓸 거예요?
* [모른 척 못 하겠어요 # say: 모르겠어요. 근데 그 번호로 연락 오는 사람들은… 모른 척 못 하겠어요.]
    ~ raise(aff_daon, 6)
    ~ f_d3_number = 1
    # cut: daon_face_surprised_01 # from: daon
    …
    # from: daon
    할아버지도 그랬어요. 전화 오면 다 받았어요. 밥 먹다가도.
* [바꾸려고요 # say: 바꾸려고요. 제 번호도 아닌 것 같아서.]
    ~ raise(aff_daon, -2)
    ~ f_d3_number = 2
    # from: daon
    …그러세요.
    (그렇게 말하면서 그녀는 손에 든 것을 아주 조금 더 꽉 쥔다.)
* [다온 씨가 원하면 바꿀게요]
    ~ f_d3_number = 3
    # from: daon
    제가 뭘 원하는지는 왜 물어요.
    # from: daon
    번호 주인은 그쪽이잖아요.
- # cut: daon_scene_notebook_01 # from: daon
이거요.
그녀가 낡은 수첩을 내민다. 표지가 닳아서 글씨가 거의 지워졌다. 모서리마다 기름 자국.
# from: daon
할아버지 수첩이에요. 삼십 년 치. 단골들 기계 고친 기록.
# from: daon
원본이에요. 잃어버리면 안 돼요.
-> notebook

= notebook
# page: 첫 장
만물수선 김씨. 1996년부터.
# page: 첫 장
고치는 건 기술이 아니라 끈기여.
# page: 오후세시 (에스프레소 머신)
스팀 막히면 우유 찌꺼기. 바늘로 살살.
# page: 오후세시 (에스프레소 머신)
사장님이 기계를 무서워함. 천천히 설명해 줄 것.
# page: 오후세시 (에스프레소 머신)
차단기 2번 칸이 약함. 비 오면 내려감. 놀라지 않게 미리 말해 둘 것.
# page: 해든빌라 (보일러)
쇠 긁는 소리는 공기. 순환펌프 옆 꼭지 반 바퀴. 통 필수.
# page: 해든빌라 (보일러)
경비 양반은 말이 짧아도 고마운 사람.
# page: 해든빌라 301호 (형광등)
형광등 점등관. 여분 관리실에 맡겨 둠.
# page: 해든빌라 301호 (형광등)
아가씨가 밤새 불을 켜 둠. 그림 그리는 사람. 불 좀 끄고 자라고 할 것.
# page: 떡집 (떡솥 뚜껑)
뚜껑 경첩 핀 빠짐. 못으로 대충 끼우면 또 빠짐.
# page: 떡집 (떡솥 뚜껑)
핀은 대성철물 3번 서랍. 끝을 톡톡 쳐서 벌려 둘 것.
# page: 떡집 (떡솥 뚜껑)
할머니가 떡 주시면 받을 것. 안 받으면 서운해하심.
# page: 정육점 (냉장고)
문 고무 늘어짐. 드라이기로 데워서 모양 잡기. 안 되면 대성철물에서 교체.
# page: 정육점 (냉장고)
최 사장 성격 급함. 5분만 기다리라고 할 것.
# page: 봄밤 장터 (전구)
해마다 3월. 줄 전구 플러그 속 퓨즈. 여분 퓨즈는 관리실 서랍, 작년 상자 안.
# page: 동물의료센터
보온기 온도조절기 접점. 일 년에 한 번 고운 사포.
# page: 동물의료센터
두부 캣타워 나사 자주 풀림.
# page: 다온이
다온이 밥 거르지 말라고 할 것. 말이 짧아도 속은 여린 애.
# page: 다온이
5월 2일 생일. 미역국.
# page: 마지막 장
3월 1일. 번호를 없앴다.
# page: 마지막 장
삼십 년 동안 이 번호로 전화 온 사람들한테 미안하다. 누가 이 수첩을 보면, 그 사람들 전화 좀 받아 줘.
수첩을 넘기다 한 페이지에서 손이 멈춘다. "다온이"라는 제목이 보인다.
(눈앞의 사람과 같은 이름이다. 지금 읽는 건 아닌 것 같아서, 수첩을 덮는다.)
# from: daon
할아버지 글씨 못 알아보겠으면 물어보세요. 저도 다는 못 읽어요.
# from: daon
…다 읽어 본 적은 없어요.
-> dubu

= dubu
유리문이 스르르 열리더니 치즈색 고양이 한 마리가 걸어 나온다. 당당하게, 병원 주인처럼.
# cut: daon_scene_cat_01
그녀가 바로 쪼그려 앉는다. 고양이 턱을 긁는 손끝이 아까 수첩을 쥐던 손이랑 다른 사람 같다.
# from: daon
두부. 병원 고양이예요. 아무한테나 안 와요.
두부가 내 운동화 냄새를 맡더니, 발등에 턱을 한 번 비비고 간다.
# from: daon
…아무한테나 안 오는데.
* [고양이 이름이 귀엽네요]
    ~ raise(aff_daon, 2)
    # from: daon
    제가 지었어요. 처음 왔을 때 두부처럼 하얗고 말랑해서.
    # from: daon
    지금은 치즈 두부예요.
* [웃으니까 좋네요 # say: 웃으시니까 좋네요.]
    ~ raise(aff_daon, 3)
    # cut: daon_face_shy_01 # from: daon
    안 웃었어요.
    (귀가 조금 빨갛다.)
* [가만히 보기 # act]
    ~ raise(aff_daon, 4)
    나는 아무 말도 하지 않는다. 이런 표정은 말을 걸면 사라질 것 같아서.
    두부가 그녀의 무릎에 머리를 두 번 박고 병원 안으로 들어간다.
- # cut: daon_face_neutral_01 # from: daon
근무 중엔 연락 안 돼요. 급하면 전화하세요. 문자는 잘 안 봐요.
# from: daon
수첩, 제대로 보세요.
그녀는 인사도 없이 유리문 안으로 들어간다. 흰 불빛 속에서 포니테일이 한 번 흔들린다.
# scene: end
~ f_daon_key = f_daon_time && not f_daon_liar
# memo: daon
근무 중엔 연락이 안 된다. 급하면 전화. 문자는 잘 안 본다고 했다.
# memo: daon
병원 고양이 두부 앞에서는 다른 사람이 된다.
# post: dubu_p1 # from: dubu # photo: dubu_cg_door_01
오늘도 병원 문 앞 순찰 완료 🐾 모르는 운동화 냄새 발견
# todo: notebook_read, 사장님 수첩 읽어 보기 (메모 앱 → 사장님 수첩)
# done: notebook
-> d03_night


// ════════════════════════════════
// 밤
// ════════════════════════════════
=== d03_night ===
# time: 21:10 # at: home
# note: 3월 11일
사장님 수첩을 받았다. 글씨가 삐뚤빼뚤하다. 삼십 년 동안 한 사람이 동네를 고친 기록이다.
{f_d3_late: -> ian_after}
-> menu

= ian_after
# note: 3월 11일
7분 늦었다. 모니터는 5분이면 됐는데, 나는 그 5분이 무엇을 밀어내는지 몰랐다.
# room: ian
약속 잘 다녀왔어요?? 저 때문에 늦은 거 아니죠 ㅠㅠ
* [조금 늦었어요 # say: 조금 늦었어요 ㅎㅎ 괜찮아요.]
    ~ raise(aff_ian, 1)
    헉 미안해요 ㅠㅠㅠ 다음엔 제가 알아서 케이블 꽂을게요
* [괜찮아요 # say: 아뇨, 딱 맞게 갔어요!]
    ~ raise(aff_ian, 1)
    다행이다 ㅋㅋ
    (거짓말은 하나를 하면 둘이 필요하다. 이건 작은 거라고, 스스로에게 말한다.)
- -> menu

= menu
# ask: 오늘 밤 뭐 하지?
* [튜브로 수리 공부하기 # act]
    -> tube
* [누군가에게 먼저 연락하기 # act]
    -> contact
* [사장님 수첩 읽기 # act]
    -> read_book
* [일찍 자기 # act]
    # note: 3월 11일
    수첩을 머리맡에 두고 잤다. 기름 냄새가 조금 난다.
    -> late

= read_book
~ f_book_read = true
# note: 3월 11일
수첩을 처음부터 끝까지 넘겼다. 마지막 장에서 오래 멈췄다. "그 사람들 전화 좀 받아 줘."
# note: 3월 11일
"다온이" 쪽은 넘기지 않았다. 주인이 아직 안 읽은 편지 같아서.
# note: 3월 11일
메모 앱의 "사장님 수첩" 탭에 다 옮겨 적었다. 고치러 가기 전에 다시 펼쳐 볼 것.
# done: notebook_read
~ raise(aff_daon, 1)
-> late

= tube
# ask: 오늘 밤 볼 영상
* {not k_hinge} [뚜껑이 자꾸 뜰 때 — 경첩 핀 # watch: hinge]
    -> video_hinge ->
* {not k_gasket && not f_d3_fridge} [냉장고 문 고무 다시 붙이기 # watch: gasket]
    -> video_gasket ->
* {not k_boiler && not f_d3_boiler} [보일러에서 쇠 긁는 소리 # watch: boiler]
    -> video_boiler ->
* {not k_grinder} [그라인더가 윙 소리만 날 때 # watch: grinder]
    -> video_grinder ->
* {not k_chair} [의자가 자꾸 내려갈 때 # watch: chair]
    -> video_chair ->
- -> late

= contact
# ask: 누구에게 연락할까?
* [윤서하에게 메시지 # text: seoha]
    # time: 21:40
    # room: seoha
    # from: me
    {f_d3_cafe: 오늘 커피 잘 마셨어요. 추천 메뉴가 제일 맛있었어요.|오늘도 기계들 말 잘 들었어요?}
    ~ raise(aff_seoha, 3)
    # wait: 2
    {f_d3_cafe: 1번 손님이 칭찬해 주니까 좋네요 :)|오늘은 다들 착했어요. 그라인더만 좀 수상해요 :)}
    마감하고 나면 가게가 너무 조용해서, 이런 메시지 오면 반가워요.
* [윤서하에게 전화 # dial: seoha]
    # time: 21:40
    # call: seoha # outgoing
    {aff_seoha >= 25: 어, 전화했네요. 마감하고 있었어요.|여보세요? 네, 오후세시… 아 아니다, 제 번호로 거신 거죠.}
    # from: me
    그냥 안부 전화요.
    ~ raise(aff_seoha, 1)
    안부 전화는 원래 명절에나 하는 거 아니에요? ㅎㅎ
    …그래도 고마워요. 목소리 들으니까 좀 덜 조용하네요.
    # call: end
* [채이안에게 메시지 # text: ian]
    # time: 21:40
    # room: ian
    # from: me
    모니터 괜찮아요?
    ~ raise(aff_ian, 3)
    넹!! 멀쩡 ㅋㅋㅋ
    케이블에 테이프 붙였어요 발로 못 차게
    # typing: 0.8
    근데 이 시간에 연락 오니까 신기하다
    나만 깨어 있는 줄 알았는데
* [채이안에게 전화 # dial: ian]
    # time: 21:40
    # call: ian # outgoing
    헐 전화 ㅋㅋㅋ 저 지금 그리는 중!
    잠깐 스피커로 해 둘게요. 말 걸어 줘요, 혼자 그리면 졸려요.
    ~ raise(aff_ian, 4)
    # narr
    (그 뒤로 20분 동안, 수화기 너머에서 펜 소리와 이안의 혼잣말이 번갈아 들린다.)
    # call: end
* [김다온에게 메시지 # text: daon]
    # time: 21:40
    # room: daon
    # from: me
    수첩 잘 받았어요. 잘 볼게요.
    # wait: 14
    네.
    ~ raise(aff_daon, 1)
* [김다온에게 전화 # dial: daon]
    # time: 21:40
    # call: daon # outgoing # noanswer
    # narr
    (신호가 간다. 가고, 또 간다. 받지 않는다. 근무 중이라고 했다.)
    # call: end
    # time: 23:40 # wait: 2
    # call: daon
    * * [받기 # answer]
        전화하셨네요. 쉬는 시간이에요.
        무슨 일이에요.
        # from: me
        수첩 잘 받았다고요. 그 말 하려고요.
        …그걸 전화로요.
        # narr
        (잠깐 조용하다. 끊긴 줄 알았다.)
        …네. 알겠어요. 들어가 볼게요.
        ~ raise(aff_daon, 4)
        # call: end
        # memo: daon
        근무 중에 건 전화는 쉬는 시간에 꼭 다시 건다.
    * * [거절 # decline]
        # room: daon
        전화하셨길래요.
        ~ raise(aff_daon, -1)
    - - -> late
- -> late

= late
# time: 23:55
{f_daon_key: -> daon_note | -> close}

= daon_note
# room: daon
수첩 첫 장은 할아버지 좌우명이에요.
한 번은 읽어 보세요.
-> close

= close
# note: 3월 11일
고치는 건 기술이 아니라 끈기여. 수첩 첫 장. 삐뚤빼뚤한 글씨.
# dayend
-> d04_morning
