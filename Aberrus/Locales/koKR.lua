local L = BigWigs:NewBossLocale("Kazzara, the Hellforged", "koKR")
if not L then return end
if L then
	L.dread_rift = "공포의 균열(바닥 장뿌웡) " -- Singular Dread Rift
end

L = BigWigs:NewBossLocale("The Amalgamation Chamber", "koKR")
if L then
	--L.custom_on_fade_out_bars = "Fade out stage 1 bars"
	--L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the boss that is out of range in stage 1."

	L.coalescing_void = "응결되는 공허(도망쳐)"
	L.shadow_convergence = "어둠의 합일(폭탄 나가)"
	L.molten_eruption = "타오르는 폭발(바닥 들어가)"
	L.swirling_flame = "소용돌이치는 화염(피해)"
	L.gloom_conflagration = "암울한 겁화(같이맞고 도망)"
	L.blistering_twilight = "맹렬한 황혼(폭탄 + 회오리)"
	L.convergent_eruption = "융합 분출(밟고 나오기)"
	L.shadowflame_burst = "정면 브레스"

	L.shadow_and_flame = "어둠과 불길(디버프)"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "koKR")
if L then
	--L.rending_charge_single = "First Charge"
	L.massive_slam = "정면 브레스(피해욧)"
	L.unstable_essence_new = "불안정한 정수(추가)"
	--L.custom_on_unstable_essence_high = "High Stacks Unstable Essence Say Messages"
	--L.custom_on_unstable_essence_high_desc = "Say messages with the amount of stacks for your Unstable Essence debuff when they are high enough."
	L.volatile_spew = "불안정한 분출(바닥 피하기)"
	L.volatile_eruption = "격렬한 분출(광역 데미지)"
	L.temporal_anomaly = "시간변칙(몸으로 막기)"
	L.temporal_anomaly_knocked = "시간변칙 끝"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "koKR")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	L.zaqali_aide_north_emote_trigger = "입구반대쪽 자리" -- Commanders ascend the northern battlement!
	L.zaqali_aide_south_emote_trigger = "입구쪽 자리" -- Commanders ascend the southern battlement!

	L.north = "입구반대쪽"
	L.south = "입구쪽"
	L.both = "양쪽"

	L.zaqali_aide_message = "%s 기어올라오는중 %s" -- Big Adds Climbing North
	L.add_bartext = "%s: %s (%d)"
	L.boss_returns = "보스 등장: 입구반대"

	L.molten_barrier = "보호막"
	L.catastrophic_slam = "재앙적인 격돌(문 막기)"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "koKR")
if L then
	L.doom_flames = "파멸의 불꽃 (바닥 밟기)"
	L.shadowlave_blast = "정면 브레스"
	L.charged_smash = "충만한 강타(같이 맞기)"
	L.energy_gained = "Energy Gained: %d"

	-- Mythic
	L.unleash_shadowflame = "암흑불길 방출(폭탄구슬)"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "koKR")
if L then
	L.tactical_destruction = "전술적파괴(용가리브레스)"
	L.bombs_soaked = "폭탄 처리" -- Bombs Soaked (2/4)
	L.unstable_embers = "불안정한 불씨(산개)"
	L.unstable_ember = "불안정한 불씨(산개)"
end

L = BigWigs:NewBossLocale("Magmorax", "koKR")
if L then
	L.energy_gained = "보스피 흡수 (-17s)" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

	-- Mythic
	L.explosive_magma = "폭발성 용암"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "koKR")
if L then
	L.custom_on_repeating_sunder_reality = "Repeating Sunder Reality Warning"
	L.custom_on_repeating_sunder_reality_desc = "Repeat a message during the Ebon Destruction cast until you get inside a portal."

	L.twisted_earth = "뒤틀린 대지(벽생성)"
	L.echoing_fissure = "메아리치는 균열(바닥조심)"
	L.rushing_darkness = "몰아치는 어둠(넉백-벽부심)"

	L.umbral_annihilation = "암영말살(광역데미지)"
	L.sunder_reality = "현실분리(파란포탈)"
	L.ebon_destruction = "칠흑의 파괴(파란바닥위로)"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "koKR")
if L then
	L.claws = "발톱(탱 디버프)" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	L.claws_debuff = "탱 폭탄"
	L.emptiness_between_stars = "Emptiness"
	L.void_slash = "전방 브레스"

	L.boss_immune = "보스무적"
	L.ebon_might = "쫄무적"
end
