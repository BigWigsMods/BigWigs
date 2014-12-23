local L = BigWigs:NewBossLocale("Kargath Bladefist", "koKR")
if not L then return end
if L then
	L.blade_dance_bar = "칼춤 도는 중"

	L.arena_sweeper_desc = "사슬 던지기로 인하여 관중석으로 내동댕이쳐진 이후 관중들에 의하여 쫓겨나기까지의 시간을 표시"
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
	L.mythic_ability = "특수 기술"
	L.mythic_ability_desc = "다음 해일의 부름이나 곰팡이 폭발이 오기 까지의 시간을 표시해주는 바를 표시합니다."

	L.creeping_moss_boss_heal = "보스 아래에 덩굴 이끼가 있습니다 (치유 중)"
	L.creeping_moss_add_heal = "큰 쫄 아래에 덩굴 이끼가 있습니다 (healing)"
end

L = BigWigs:NewBossLocale("Twin Ogron", "koKR")
if L then
	L.volatility_self_desc = "당신에게 불안정한 비전 디버프가 걸려있을 때의 옵션Options for when the Arcane Volatility debuff is on you."

	L.custom_off_volatility_marker = "불안정한 비전 징표 설정"
	L.custom_off_volatility_marker_desc = "불안정한 징표의 대상을 {rt1}{rt2}{rt3}{rt4}의 징표로 설정합니다. 공격대장이거나 권한이 필요합니다."
end

L = BigWigs:NewBossLocale("Ko'ragh", "koKR")
if L then
	L.fire_bar = "모두 폭발합니다!"
	L.overwhelming_energy_bar = "구체가 떨어짐 (%d)"
	L.dominating_power_bar = "정신 지배 구체가 떨어짐 (%d)"

	L.custom_off_fel_marker = "마법 방출: 악마 징표 설정"
	L.custom_off_fel_marker_desc = "마법 방출: 악마의 대상을 {rt1}{rt2}{rt3}의 징표로 설정합니다.\n|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r"
end

L = BigWigs:NewBossLocale("Imperator Mar'gok", "koKR")
if L then
	L.phase4_trigger = "마르고크, 넌 그 힘에 대해 아무것도 모른다."

	L.branded_say = "%s (%d) %d미터"
	L.add_death_soon = "쫄이 곧 죽습니다!"
	--L.slow_fixate = "Slow+Fixate"

	L.custom_off_fixate_marker = "시선집중 징표 설정"
	L.custom_off_fixate_marker_desc = "고리안 전투마법사의 시선 집중의 대상을 {rt1}{rt2}의 징표로 설정합니다.\n|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r"

	L.custom_off_branded_marker = "낙인 징표 설정"
	L.custom_off_branded_marker_desc = "낙인의 대상을 {rt3}{rt4}의 징표로 설정합니다.\n|cFFFF0000징표 설정에서 문제가 발생하는 것을 막기 위해 공격대에서 오직 1명만 이 옵션을 활성화해야 합니다.|r"	
end

