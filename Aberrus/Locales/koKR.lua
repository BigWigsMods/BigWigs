local L = BigWigs:NewBossLocale("The Amalgamation Chamber", "koKR")
if not L then return end
if L then
	L.custom_on_fade_out_bars = "1페이즈 바 임시 비활성화"
	L.custom_on_fade_out_bars_desc = "1페이즈에서 거리에서 먼 보스들의 바를 임시로 비활성화."

	L.coalescing_void = "보스에서 이격"

	L.shadow_and_flame = "신화 디버프"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "koKR")
if L then
	L.rending_charge_single = "돌진 대상"
	L.unstable_essence_new = "정수 디버프"
	L.custom_on_unstable_essence_high = "불안정한 정수 고중첩 알리기"
	L.custom_on_unstable_essence_high_desc = "불안정한 정수 고중첩일때 일반창으로 중첩 알림."
	L.volatile_spew = "바닥 피하기"
	--L.volatile_eruption = "Eruption"
	L.temporal_anomaly_knocked = "구슬 쳐냄"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "koKR")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	L.zaqali_aide_north_emote_trigger = "북쪽 성루" -- 지휘관이 북쪽 성루를 타고 오릅니다!
	L.zaqali_aide_south_emote_trigger = "남쪽 성루" -- 지휘관이 남쪽 성루를 타고 오릅니다!!

	L.both = "양쪽"
	L.zaqali_aide_message = "%s 가 %s 으로 오르는중" -- Big Adds Climbing North
	L.add_bartext = "%s: %s (%d)"
	L.boss_returns = "넴드 착지: 북쪽"

	L.molten_barrier = "보호막"
	L.catastrophic_slam = "문으로 격돌"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "koKR")
if L then
	L.doom_flames = "바닥 밟기"
	L.charged_smash = "큰바닥 같이맞기"
	L.energy_gained = "기력 회복: %d"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "koKR")
if L then
	L.tactical_destruction = "조각상 브레스"
	L.bombs_soaked = "유산탄 처리" -- Bombs Soaked (2/4)
	L.unstable_embers = "불씨"
	L.unstable_ember = "불씨"
end

L = BigWigs:NewBossLocale("Magmorax", "koKR")
if L then
	L.energy_gained = "기력 회복 (-17s)" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

	-- Mythic
	L.explosive_magma = "폭발성 용암"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "koKR")
if L then
	L.twisted_earth = "벽 생성"
	L.echoing_fissure = "균열"
	L.rushing_darkness = "넉백 징표"

	L.umbral_annihilation = "암영 말살"
	L.ebon_destruction = "즉사 광역기"

	--L.wall_breaker = "Wall Breaker (Mythic)"
	--L.wall_breaker_desc = "A player targeted by Rushing Darkness will be chosen as the wall breaker. They will be marked ({rt6}) and send a message in say chat. This is restricted to Mythic difficulty on stage 1."
	--L.wall_breaker_message = "Wall Breaker"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "koKR")
if L then
	L.claws = "탱 인계" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	L.claws_debuff = "탱 디버프 만료"
	L.emptiness_between_stars = "공허 위상"
	L.void_slash = "탱커 전방기"

	L.ebon_might = "쫄 메즈 면역"
end

L = BigWigs:NewBossLocale("Aberrus, the Shadowed Crucible Trash", "koKR")
if L then
	L.edgelord = "분리된 칼날군주" -- NPC 198873
	L.naturalist = "분리된 자연의 탐구자" -- NPC 201746
	L.siegemaster = "분리된 공성전문가" -- NPC 198874
	L.banner = "깃발" -- Short for "Sundered Flame Banner" NPC 205638
	L.arcanist = "분리된 비전술사" -- NPC 201736
	L.chemist = "분리된 화학자" -- NPC 205656
	L.fluid = "살아 움직이는 액체" -- NPC 203939
	--L.slime = "Bubbling Slime" -- NPC 205651
	--L.goo = "Crawling Goo" -- NPC 205820
	L.whisper = "어둠 속의 속삭임" -- NPC 203806
end
