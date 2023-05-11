local L = BigWigs:NewBossLocale("Kazzara, the Hellforged", "zhCN")
if not L then return end
if L then
	L.dread_rift = "裂隙" -- Singular Dread Rift
end

L = BigWigs:NewBossLocale("The Amalgamation Chamber", "zhCN")
if L then
	L.custom_on_fade_out_bars = "淡出第一阶段计时器"
	L.custom_on_fade_out_bars_desc = "第一阶段时，淡出首领计时器。"

	L.coalescing_void = "远离"
	L.shadow_convergence = "宝珠"
	L.molten_eruption = "接圈"
	L.swirling_flame = "旋风"
	L.gloom_conflagration = "陨石 + 远离"
	L.blistering_twilight = "炸弹 + 旋风"
	L.convergent_eruption = "接圈 + 宝珠"
	L.shadowflame_burst = "冲击波"

	L.shadow_and_flame = "暗焰易伤"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "zhCN")
if L then
	L.rending_charge_single = "第一个冲锋"
	L.massive_slam = "冲击波"
	L.unstable_essence_new = "新炸弹"
	L.custom_on_unstable_essence_high = "不稳定的精华：高层数喊话"
	L.custom_on_unstable_essence_high_desc = "当你身上的不稳定的精华层数过高时，持续喊话通报你的层数。"
	L.volatile_spew = "躲球"
	L.volatile_eruption = "剧烈爆发"
	L.temporal_anomaly = "治疗宝珠"
	L.temporal_anomaly_knocked = "治疗宝珠被踢走了"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "zhCN")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	--L.zaqali_aide_north_emote_trigger = "northern battlement" -- |TInterface\\ICONS\\Ability_Hunter_KillCommand.blp:20|t Commanders ascend the northern battlement!
	--L.zaqali_aide_south_emote_trigger = "southern battlement" -- |TInterface\\ICONS\\Ability_Hunter_KillCommand.blp:20|t Commanders ascend the southern battlement!

	--L.north = "North"
	--L.south = "South"
	--L.both = "Both"

	--L.zaqali_aide_message = "%s Climbing %s" -- Big Adds Climbing North
	L.add_bartext = "%s：%s（%d）"
	--L.boss_returns = "Boss Lands: North"

	L.molten_barrier = "屏障"
	--L.catastrophic_slam = "Door Slam"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "zhCN")
if L then
	L.doom_flames = "接圈"
	L.shadowlave_blast = "冲击波"
	L.charged_smash = "分摊"
	L.energy_gained = "获得能量: %d"

	-- Mythic
	-- L.unleash_shadowflame = "暗焰宝珠"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "zhCN")
if L then
	L.tactical_destruction = "喷火"
	L.bombs_soaked = "炸弹拆除" -- Bombs Soaked (2/4)
	L.unstable_embers = "灰烬"
	L.unstable_ember = "灰烬"
end

L = BigWigs:NewBossLocale("Magmorax", "zhCN")
if L then
	L.energy_gained = "获得能量，狂暴时限缩短17秒" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

	-- Mythic
	L.explosive_magma = "岩浆分摊"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "zhCN")
if L then
	L.custom_on_repeating_sunder_reality = "重复警告：隔绝现实"
	L.custom_on_repeating_shattered_reality_desc = "在黑檀摧残的过程中重复信息，直到进入传送门为止。"

	L.twisted_earth = "土墙"
	L.echoing_fissure = "裂隙"
	L.rushing_darkness = "毁墙线"

	L.umbral_annihilation = "歼灭"
	L.sunder_reality = "传送门"
	L.ebon_destruction = "大爆炸"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "zhCN")
if L then
	--L.claws = "Tank Debuff" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	--L.claws_debuff = "Tank Explodes"
	--L.emptiness_between_stars = "Emptiness"
	--L.embrace_of_nothingness = "Black Hole"
	--L.void_slash = "Tank Frontal"
end
