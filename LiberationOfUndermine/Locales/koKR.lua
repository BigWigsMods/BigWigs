local L = BigWigs:NewBossLocale("Vexie and the Geargrinders", "koKR")
if not L then return end
if L then
    L.plating_removed = "남은 방호 장갑 %d 개"
	L.exhaust_fumes = "전체 데미지"
end

L = BigWigs:NewBossLocale("Cauldron of Carnage", "koKR")
if L then
	L.custom_on_fade_out_bars = "바 투명도 감소"
	L.custom_on_fade_out_bars_desc = "거리가 닿지 않는 보스 관련 바의 투명도를 낮춥니다."

	L.bomb_explosion = "폭탄 폭발"
	L.bomb_explosion_desc = "폭탄이 폭파되기까지의 타이머 표시."
end

L = BigWigs:NewBossLocale("Rik Reverb", "koKR")
if L then
	L.amplification = "증폭기 소환"
	L.echoing_chant = "메아리"
	L.faulty_zap = "감전"
	L.sparkblast_ignition = "배럴 소환"
end

L = BigWigs:NewBossLocale("Stix Bunkjunker", "koKR")
if L then
	L.ball_size_medium = "중형 구체!"
	L.ball_size_large = "대형 구체!"
	L.rolled_on_you = "%s 에게 치임" -- PlayerX rolled over you
	L.rolled_from_you = "%s 를 치고감" -- (you) Rolled over PlayerX
	L.garbage_dump_message = "보스에게 %s 피해를 입힘"

	L.electromagnetic_sorting = "분류" -- Short for Electromagnetic Sorting
	L.muffled_doomsplosion = "폭탄 처리됨"
	L.incinerator = "소각"
	L.landing = "착륙" -- Landing down from the sky
end

L = BigWigs:NewBossLocale("Sprocketmonger Lockenstock", "koKR")
if L then
	L.foot_blasters = "지뢰"
	L.screw_up = "드릴"
	L.sonic_ba_boom = "공대 피해"
	L.polarization_generator = "극성 바뀜!"

	L.polarization_soon = "%s 초 후 극성바뀜"
end

L = BigWigs:NewBossLocale("The One-Armed Bandit", "koKR")
if L then
	L.rewards = "경품" -- Fabulous Prizes
	L.rewards_desc = "두개의 토큰이 정해지면, \"환상적인 경품\" 이 나옵니다. \n어떤 경품이 나왔는지 메시지로 알려줍니다.\n정보박스로 어떤 경품이 아직 남았는지 보여줍니다."
	L.rewards_icon = "inv_111_vendingmachine_blackwater"
	L.deposit_time = "토큰 주입 마무리" -- Timer that indicates how long you have left to deposit the tokens.

	L.pay_line = "칩 소환"
	--L.shock = "Shock"
	--L.flame = "Flame"
	L.coin = "칩"
end

L = BigWigs:NewBossLocale("Mug'Zee, Heads of Security", "koKR")
if L then
	--L.earthshaker_gaol = "감옥"
	L.frostshatter_boots = "냉기 장화" -- Short for Frostshatter Boots
	L.frostshatter_spear = "냉기 창" -- Short for Frostshatter Spears
	L.stormfury_finger_gun = "지건" -- Short for Stormfury Finger Gun
	L.molten_gold_knuckles = "탱커 전방기"
	L.unstable_crawler_mines = "지뢰"
	L.goblin_guided_rocket = "로켓"
	L.double_whammy_shot = "탱 가로막기"
end

L = BigWigs:NewBossLocale("Chrome King Gallywix", "koKR")
if L then
	L.scatterblast_canisters = "브레스 같이맞기"
	L.fused_canisters = "용기 같이맞기"
	L.tick_tock_canisters = "바닥밟기"

	L.duds = "불발탄" -- Short for 1500-Pound "Dud"
	L.all_duds_detontated = "모든 불발탄 해체완료!"
	L.duds_remaining = "불발탄 %d 개 남음" -- 1 Bomb Remaning, 2 Bombs Remaining.. etc
	L.duds_soak = "불발탄 바닥밟기 (%d 개 남음)"
end
