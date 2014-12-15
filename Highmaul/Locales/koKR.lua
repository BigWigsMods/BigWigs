local L = BigWigs:NewBossLocale("Kargath Bladefist", "koKR")
if not L then return end
if L then
	L.blade_dance_bar = "칼춤 도는 중"

	--L.arena_sweeper_desc = "Timer for getting knocked out of the stadium stands after you've been Chain Hurled."
end

L = BigWigs:NewBossLocale("The Butcher", "koKR")
if L then
	L.adds_multiple = "%d번째 쫄"
end

L = BigWigs:NewBossLocale("Tectus", "koKR")
if L then
	L.earthwarper_trigger1 = "이즈므르..." -- Yjj'rmr... Xzzolos...
	L.earthwarper_trigger2 = "그래, 텍터스..." -- Yes, Tectus. Bend to... our master's... will....
	L.earthwarper_trigger3 = "안 돼! 이럴 순 없어!" -- You do not understand! This one must not....
	L.berserker_trigger1 = "주인님! 제가 갑니다!" -- MASTER! I COME FOR YOU!
	L.berserker_trigger2 = "크랄아크..." --Kral'ach.... The darkness speaks.... A VOICE!
	L.berserker_trigger3 = "그아악!" --Graaagh! KAHL...  AHK... RAAHHHH!

	L.tectus = "텍터스"
	L.shard = "조각"
	L.motes = "자갈"

	L.custom_off_barrage_marker = "수정 포화 징표 설정"
	L.custom_off_barrage_marker_desc = "수정 포화의 대상을 {rt1}{rt2}{rt3}{rt4}{rt5}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."

	L.adds_desc = "다음 쫄이 언제 전투에 참여하는 지를 확인하기 위한 타이머입니다." 
end

L = BigWigs:NewBossLocale("Brackenspore", "koKR")
if L then
	--L.mythic_ability = "Special Ability"
	--L.mythic_ability_desc = "Show a timer bar for the next Call of the Tides or Exploding Fungus arriving."

	L.creeping_moss_boss_heal = "보스 아래에 덩굴 이끼가 있습니다 (치유 중)"
	--L.creeping_moss_add_heal = "Moss under BIG ADD (healing)"
end

L = BigWigs:NewBossLocale("Twin Ogron", "koKR")
if L then
	--L.volatility_self_desc = "Options for when the Arcane Volatility debuff is on you."

	L.custom_off_volatility_marker = "불안정한 비전 징표 설정"
	L.custom_off_volatility_marker_desc = "불안정한 징표의 대상을 {rt1}{rt2}{rt3}{rt4}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
end

L = BigWigs:NewBossLocale("Ko'ragh", "koKR")
if L then
	L.fire_bar = "모두 폭발합니다!"
	--L.overwhelming_energy_bar = "Balls hit (%d)"

	--L.custom_off_fel_marker = "Expel Magic: Fel Marker"
	--L.custom_off_fel_marker_desc = "Mark Expel Magic: Fel targets with {rt1}{rt2}{rt3}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
end

L = BigWigs:NewBossLocale("Imperator Mar'gok", "koKR")
if L then
	--L.branded_say = "%s (%d) %dy"

	L.custom_off_fixate_marker = "시선집중 징표 설정"
	L.custom_off_fixate_marker_desc = "고리안 전투마법사의 시선 집중의 대상을 {rt1}{rt2}의 징표로 설정합니다.\n|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r"

	--L.custom_off_branded_marker = "Branded Marker"
	--L.custom_off_branded_marker_desc = "Mark Branded targets with {rt3}{rt4}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"	
end

