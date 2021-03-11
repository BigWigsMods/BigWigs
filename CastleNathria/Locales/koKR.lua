local L = BigWigs:NewBossLocale("Shriekwing", "koKR")
if not L then return end
if L then
	L.pickup_lantern = "%s 이(가) 등불을 들었습니다!"
	L.dropped_lantern = " %s 이(가) 등불 떨어트림!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "koKR")
if L then
	L.killed = "%s 죽음"
end

L = BigWigs:NewBossLocale("Sun King's Salvation", "koKR")
if L then
	--L.shield_removed = "%s removed after %.1fs" -- "Shield removed after 1.1s" s = seconds
	--L.shield_remaining = "%s remaining: %s (%.1f%%)" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "koKR")
if L then
	L.miasma = "독기" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "반복적으로 독기 체력 외치기"
	L.custom_on_repeating_yell_miasma_desc = "독기에 걸렸을때 반복적으로 외침으로써 본인이 체력 75%미만일때 알림."

	L.custom_on_repeating_say_laser = "반복적으로 순간 방출 알리기"
	L.custom_on_repeating_say_laser_desc = "순간 방출 걸렸을때 반복적으로 말을 해서 혹시나 처음 메세지를 보지 못한 사람들에게 알리기."

	L.tempPrint = "독기에 걸렸을때 체력을 외침으로 알리는 기능을 추가했습니다. 전까진 위크오라를 썼다면. 위크오라를 지워서 두번 외치는일이 없도록 하는게 좋을수도 있습니다."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "koKR")
if L then
	L.tear = "균열" -- Short for Dimensional Tear
	L.spirits = "영혼" -- Short for Fleeting Spirits
	L.seeds = "씨앗" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "koKR")
if L then
	L.times = "%dx %s"

	L.level = "%s (Level |cffffff00%d|r)"
	L.full = "%s (|cffff0000FULL|r)"

	L.anima_adds = "농축된 령 쫄"
	L.anima_adds_desc = "농축된 령 쫄이 언제 생성되는 타이머 표시."

	L.custom_off_experimental = "실험적 기능 활성화"
	L.custom_off_experimental_desc = "이 기능들은 |cffff0000테스트되지 않았고|r 그렇기에 |cffff0000무분별하게 반복될수 있음|r."

	L.anima_tracking = "령 추적 |cffff0000(실험 중)|r"
	L.anima_tracking_desc = "메세지와 바로 령 용기에 있는 령 수치를 추적.|n|cffaaff00팁: 정보 박스나 바를 기호에 따라 비활성화해야 할 수도 있음."

	L.custom_on_stop_timers = "항상 능력 바 표시"
	L.custom_on_stop_timers_desc = "아직은 실험 단계"

	L.desires = "욕망"
	L.bottles = "병에 담긴 령"
	L.sins = "죄악"
end

L = BigWigs:NewBossLocale("The Council of Blood", "koKR")
if L then
	L.macabre_start_emote = "죽음의 무도를 위해 자신의 위치에 서야 합니다!" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	L.custom_on_repeating_dark_recital = "어둠의 무도회 지속적으로 표시"
	L.custom_on_repeating_dark_recital_desc = "지속적으로  {rt1}, {rt2}  로 표시를 해서 본인의 짝을 찾을수 있도록 표시."

	L.custom_off_select_boss_order = "보스 킬 순서 표시"
	L.custom_off_select_boss_order_desc = "보스를 잡을 순서를 {rt7} 로 표시. 부공대장 이상의 권한이 필요합니다."
	L.custom_off_select_boss_order_value1 = "니클라우스 -> 프리에다 -> 스타브로스"
	L.custom_off_select_boss_order_value2 = "프리에다 -> 니클라우스 -> 스타브로스"
	L.custom_off_select_boss_order_value3 = "스타브로스 -> 니클라우스 -> 프리에다"
	L.custom_off_select_boss_order_value4 = "니클라우스 -> 스타브로스 -> 프리에다"
	L.custom_off_select_boss_order_value5 = "프리에다 -> 스타브로스 -> 니클라우스"
	L.custom_off_select_boss_order_value6 = "스타브로스 -> 프리에다 -> 니클라우스"

	L.dance_assist = "춤 도우미"
	L.dance_assist_desc = "춤출때 방향 표시."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t 앞으로 |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t 오른쪽으로 |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t 밑으로 |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t 왼쪽으로 |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "앞으로" -- Prance Forward!
	L.dance_yell_right = "오른쪽으로" -- Shimmy right!
	L.dance_yell_down = "밑으로" -- Boogie down!
	L.dance_yell_left = "왼쪽으로" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "koKR")
if L then
	L.stomp_shift = "발구르기 & 지진" -- Destructive Stomp + Seismic Shift

	L.fun_info = "데미지 표시"
	L.fun_info_desc = "파괴의 충격 중 얼마나 체력을 많이 뺐는가를 메세지로 표시."

	L.health_lost = "진흙주먹의 체력을 %.1f%% 만큼 깎았습니다!"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "koKR")
if L then
	L.first_blade = "첫번째 칼날"
	L.second_blade = "두번째 칼날"

	L.skirmishers = "척후병" -- Short for Stone Legion Skirmishers
	L.eruption = "분출" -- Short for Reverberating Eruption

	L.custom_on_stop_timers = "항상 능력 바 표시"
	L.custom_on_stop_timers_desc = "아직은 실험 단계"

	L.goliath_short = "거수"
	L.goliath_desc = "돌 군단 거수가 언제 나오는지 경고와 타이머 표시."

	L.commando_short = "특공대원"
	L.commando_desc = "돌 군단 특공대원이 잡혔을때 경고 표시."
end

L = BigWigs:NewBossLocale("Sire Denathrius", "koKR")
if L then
	--L.add_spawn = "Crimson Cabalists answer the call of Denathrius." -- [RAID_BOSS_EMOTE] Crimson Cabalists answer the call of Denathrius.#Sire Denathrius#4#true"

	L.infobox_stacks = "%d 중첩: %d 명" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "반복적으로 밤의 사냥꾼 외치기"
	L.custom_on_repeating_nighthunter_desc = "밤의 사냥꾼 능력을 {rt1} 나 {rt2} 나 {rt3} 로 반복적으로 표시해서 맞아줘야 하는 선 찾기 쉽게 하기."

	L.custom_on_repeating_impale = "반복적으로 꿰뚫기 말하기"
	L.custom_on_repeating_impale_desc = "꿰뚫기에 걸렸을때 '1' 이나 '22' 나 '333' 이나 '4444' 로 계속 말해서 어떤 순서로 맞는지 명확하게 하기."

	L.hymn_stacks = "나스리아의 찬가"
	L.hymn_stacks_desc = "현재 본인에게 있는 나스리아의 찬가 중첩 갯수 알림."

	L.ravage_target = "사악한 환영: 유린 방향 시전바"
	L.ravage_target_desc = "사악한 환영이 유린을 어디로 쓸지 결정할때까지의 시간을 표시해주는 시전바."
	L.ravage_targeted = "유린 방향 결정" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "거울 없음: %d" -- Player amount that does not have the Through the Mirror
	L.mirror = "거울: %d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "koKR")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "몰도바크"
	L.caramain = "카라메인"
	L.sindrel = "신드렐"
	L.hargitas = "하르지타스"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "덩치 큰 가르곤"
	L.hawkeye = "나스리아 명사수"
	L.overseer = "사육장 감독관"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "공포의 탐식자"
	L.rat = "비정상적인 크기의 쥐"
	L.miasma = "독기" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "디플리나"
	L.dragost = "드래고스트"
	L.kullan = "쿨란"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "사악한 골동품 수집가"
	L.conservator = "나스리아 정원지기"
	L.archivist = "나스리아 기록관"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "돌 군단 거수"
end
