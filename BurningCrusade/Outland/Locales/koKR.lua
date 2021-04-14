local L = BigWigs:NewBossLocale("Doomwalker", "koKR")
if not L then return end
if L then
	L.name = "파멸의 절단기"

	L.engage_trigger = "접근 금지. 너희는 제거될 것이다."
	L.engage_message = "파멸의 절단기 전투 개시, 약 30초 이내 지진!"

	L.overrun_desc = "파멸의 절단기의 괴멸 사용 가능 시 경고합니다."

	L.earthquake_desc = "파멸의 절단기의 지진 사용 가능 시 경고합니다."
end

L = BigWigs:NewBossLocale("Doom Lord Kazzak", "koKR")
if L then
	L.name = "파멸의 군주 카자크"

	L.engage_trigger1 = "불타는 군단이 온 세상을 지배하리라!"
	L.engage_trigger2 = "필멸의 종족은 모두 멸망하리라!"

	L.enrage_warning1 = "%s 전투 개시 - 50-60초 후 격노"
	L.enrage_warning2 = "잠시 후 격노!"
	L.enrage_message = "10초간 격노!"
	L.enrage_finished = "격노 종료 - 다음은 50-60초 후"
	L.enrage_bar = "~격노"
	L.enraged_bar = "<격노>"
end

L = BigWigs:NewBossLocale("Gruul the Dragonkiller", "koKR")
if L then
	L.engage_trigger = "와서... 죽어라."
	L.engage_message = "%s 전투 개시!"

	L.grow = "성장"
	L.grow_desc = "그룰의 성장에 대한 카운트와 경고입니다."
	L.grow_message = "성장: (%d)"
	L.grow_bar = "(%d) 성장"

	L.grasp = "손아귀"
	L.grasp_desc = "손아귀 경고와 타이머입니다."
	L.grasp_message = "땅 울리기 - 약 10초 이내 산산조각!"
	L.grasp_warning = "잠시 후 땅 울리기"

	L.silence_message = "광역 침묵"
	L.silence_warning = "잠시 후 광역 침묵!"
	L.silence_bar = "~침묵 대기시간"
end

L = BigWigs:NewBossLocale("High King Maulgar", "koKR")
if L then
	L.engage_trigger = "그론이 아웃랜드의 진정한 강자다!"

	L.heal_message = "블라인드아이 치유 시전!"
	L.heal_bar = "치유"

	L.shield_message = "블라인드아이 보호막!"

	L.spellshield_message = "크로쉬 주문 보호막!"

	L.summon_message = "지옥사냥개 소환!"
	L.summon_bar = "~지옥사냥개 대기시간"

	L.whirlwind_message = "마울가르 - 15초간 소용돌이!"
	L.whirlwind_warning = "마울가르 전투 개시 - 약 60초 후 소용돌이!"

	L.mage = "크로쉬 파이어핸드 (마법사)"
	L.warlock = "소환사 올름 (흑마법사)"
	L.priest = "현자 블라인드아이 (사제)"
end

L = BigWigs:NewBossLocale("Magtheridon", "koKR")
if L then
	L.escape = "탈출"
	L.escape_desc = "마그테리돈 속박 해제까지 카운트다운합니다."
	L.escape_trigger1 = "%%s의 속박이 약해지기 시작합니다"
	L.escape_trigger2 = "내가... 풀려났도다!"
	L.escape_warning1 = "%s 전투 개시 - 2분 이내 속박 해제!"
	L.escape_warning2 = "속박 해제 1분 전!"
	L.escape_warning3 = "속박 해제 30초 전!"
	L.escape_warning4 = "속박 해제 10초 전!"
	L.escape_warning5 = "속박 해제 3초 전!"
	L.escape_bar = "풀려남..."
	L.escape_message = "%s 풀려남!"

	L.abyssal = "불타는 심연"
	L.abyssal_desc = "불타는 심연 생성 시 경고합니다."
	L.abyssal_message = "불타는 심연 생성 (%d)"

	L.heal = "치유"
	L.heal_desc = "지옥불 역술사 치유 시전 시 경고합니다."
	L.heal_message = "치유 시전!"

	L.banish = "추방"
	L.banish_desc = "마그테리돈 추방 시 알립니다."
	L.banish_message = "약 10초 동안 추방됨"
	L.banish_over_message = "추방 종료!"
	L.banish_bar = "<추방됨>"

	L.exhaust_desc = "정신 방출에 걸린 플레이어에 대한 타이머 바입니다."
	L.exhaust_bar = "[%s] 정신 방출"

	L.debris_trigger = "그렇게 쉽게 당할 내가 아니다! 이 감옥의 벽이 흔들리고... 무너지리라!"
	L.debris_message = "30% - 잠시 후 파편!"
end

