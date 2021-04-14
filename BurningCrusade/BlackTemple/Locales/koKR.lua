local L = BigWigs:NewBossLocale("High Warlord Naj'entus", "koKR")
if not L then return end
if L then
	L.start_trigger = "여군주 바쉬의 이름으로 사형에 처하노라!"
end

L = BigWigs:NewBossLocale("Supremus", "koKR")
if L then
	L.normal_phase_trigger =  "궁극의 심연이 분노하여 땅을 내리찍습니다!"
	L.kite_phase_trigger = "땅이 갈라져서 열리기 시작합니다!"
	L.normal_phase = "보통 단계"
	L.kite_phase = "유도 단계"
	L.next_phase = "다음 단계"
end

L = BigWigs:NewBossLocale("Shade of Akama", "koKR")
if L then
	L.wipe_trigger = "아직은! 안돼!"
	L.defender = "수호병" -- Ashtongue Defender
	L.sorcerer = "사술사" -- Ashtongue Sorcerer
	L.adds_right = "몹 추가 (오른쪽)"
	L.adds_left = "몹 추가 (왼쪽)"

	L.engaged = "아카마의 망령 전투 시작"
end

L = BigWigs:NewBossLocale("Reliquary of Souls", "koKR")
if L then
	L.zero_mana = "마나 0"
	L.zero_mana_desc = "욕망의 정수가 모두의 최대 마나를 0으로 감소시키기 까지의 시간을 표시합니다."
	L.desire_start = "욕망의 정수 - 160초 후 마나 0"

	L[-15665] = "1단계: 고뇌의 정수"
	L[-15673] = "2단계: 욕망의 정수"
	L[-15681] = "3단계: 격노의 정수"
end

L = BigWigs:NewBossLocale("The Illidari Council", "koKR")
if L then
	L.veras = "베라스: %s"
	L.malande = "말란데: %s"
	L.gathios = "가디오스: %s"
	L.zerevor = "제레보르: %s"

	L.circle_heal_message = "치유됨! - 다음은 약 20초 후"
	L.circle_fail_message = "%s 시전 방해! - 다음은 약 12초 후"

	L.magical_immunity = "마법 공격에 면역!"
	L.physical_immunity = "물리 공격에 면역!"

	L[-15704] = "파괴자 가디오스"
	L[-15716] = "베라스 다크섀도"
	L[-15726] = "여군주 말란데"
	L[-15720] = "고위 황천술사 제레보르"
end

L = BigWigs:NewBossLocale("Illidan Stormrage", "koKR")
if L then
	L.barrage_bar = "집중포화"
	L.warmup_trigger = "아카마, 너의 불충은 그리 놀랍지도 않구나. 너희 흉측한 형제들을 벌써 오래전에 없애버렸어야 했는데..."

	L[-15735] = "1단계: 너흰 아직 준비가 안 됐다"
	L[-15740] = "2단계: 아지노스의 불꽃"
	L[-15751] = "3단계: 내면의 악마"
	L[-15757] = "4단계: 기나긴 사냥"
end
