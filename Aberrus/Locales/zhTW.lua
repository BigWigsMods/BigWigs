local L = BigWigs:NewBossLocale("Kazzara, the Hellforged", "zhTW")
if not L then return end
if L then
	L.dread_rift = "裂隙" -- Singular Dread Rift
end

L = BigWigs:NewBossLocale("The Amalgamation Chamber", "zhTW")
if L then
	L.custom_on_fade_out_bars = "淡出第一階段計時器"
	L.custom_on_fade_out_bars_desc = "第一階段時，淡出遠處首領的計時器。"

	L.coalescing_void = "跑遠"
	L.shadow_convergence = "寶珠"
	L.molten_eruption = "接圈"
	L.swirling_flame = "旋風"
	L.gloom_conflagration = "隕石 + 跑遠"
	L.blistering_twilight = "炸彈 + 旋風"
	L.convergent_eruption = "接圈 + 寶珠"
	L.shadowflame_burst = "衝擊波"

	L.shadow_and_flame = "暗焰易傷"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "zhTW")
if L then
	L.rending_charge_single = "第一個衝鋒"
	L.massive_slam = "衝擊波"
	L.unstable_essence_new = "新炸彈"
	L.custom_on_unstable_essence_high = "不穩定的精華：高層數喊話"
	L.custom_on_unstable_essence_high_desc = "當你身上的不穩定的精華層數疊高後，持續喊話播報你的層數。"
	L.volatile_spew = "躲球"
	L.volatile_eruption = "爆發"
	L.temporal_anomaly = "治療珠"
	L.temporal_anomaly_knocked = "治療珠被踢走了"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "zhTW")
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

L = BigWigs:NewBossLocale("Rashok, the Elder", "zhTW")
if L then
	L.doom_flames = "接圈"
	L.shadowlave_blast = "衝擊波"
	L.charged_smash = "分攤"
	L.energy_gained = "獲得能量：%d"

	-- Mythic
	L.unleash_shadowflame = "暗焰寶珠"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "zhTW")
if L then
	L.tactical_destruction = "噴火"
	L.bombs_soaked = "炸彈拆除" -- Bombs Soaked (2/4)
	L.unstable_embers = "餘燼"
	L.unstable_ember = "餘燼"
end

L = BigWigs:NewBossLocale("Magmorax", "zhTW")
if L then
	L.energy_gained = "獲得能量，狂暴時限縮短 17 秒" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

	-- Mythic
	L.explosive_magma = "大圈分攤"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "zhTW")
if L then
	--L.custom_on_repeating_sunder_reality = "Repeating Sunder Reality Warning"
	--L.custom_on_repeating_shattered_reality_desc = "Repeat a message during the Ebon Destruction cast until you get inside a portal."

	--L.twisted_earth = "Walls"
	--L.echoing_fissure = "Fissure"
	--L.rushing_darkness = "直線擊退"

	--L.umbral_annihilation = "Annihilation"
	--L.sunder_reality = "Portals"
	--L.ebon_destruction = "Big Bang"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "zhTW")
if L then
	--L.claws = "Tank Debuff" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	--L.claws_debuff = "Tank Explodes"
	--L.emptiness_between_stars = "Emptiness"
	--L.embrace_of_nothingness = "Black Hole"
	--L.void_slash = "Tank Frontal"
end
