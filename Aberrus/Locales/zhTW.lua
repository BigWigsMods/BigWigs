local L = BigWigs:NewBossLocale("The Amalgamation Chamber", "zhTW")
if not L then return end
if L then
	L.custom_on_fade_out_bars = "淡出第一階段計時器"
	L.custom_on_fade_out_bars_desc = "第一階段時，淡出遠處首領的計時器。"

	L.coalescing_void = "跑遠"

	L.shadow_and_flame = "暗焰易傷"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "zhTW")
if L then
	L.rending_charge_single = "第一個衝鋒"
	L.unstable_essence_new = "新炸彈"
	L.custom_on_unstable_essence_high = "不穩定的精華：高層數喊話"
	L.custom_on_unstable_essence_high_desc = "當你身上的不穩定的精華層數疊高後，持續喊話播報你的層數。"
	L.volatile_spew = "躲球"
	L.volatile_eruption = "爆發"
	L.temporal_anomaly_knocked = "治療珠被踢走了"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "zhTW")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	L.zaqali_aide_north_emote_trigger = "北邊城垛" -- 指揮官爬上北邊城垛！
	L.zaqali_aide_south_emote_trigger = "南邊城垛" -- 指揮官爬上南邊城垛！

	L.both = "雙方"
	L.zaqali_aide_message = "%2$s：%1$s正在攀登" -- Big Adds Climbing North
	L.add_bartext = "%s：%s（%d）"
	L.boss_returns = "北方：首領落地" -- 跟L.zaqali_aide_message統一格式

	L.molten_barrier = "屏障"
	L.catastrophic_slam = "破門"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "zhTW")
if L then
	L.doom_flames = "接圈"
	L.charged_smash = "分攤"
	L.energy_gained = "獲得能量：%d"
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
	L.twisted_earth = "石牆"
	L.echoing_fissure = "迴響"
	L.rushing_darkness = "擊退破牆"

	L.umbral_annihilation = "滅殺"
	L.ebon_destruction = "大爆炸"

	L.wall_breaker = "破牆者（傳奇模式）"
	L.wall_breaker_desc = "在傳奇模式的第一階段中，指定一名中了奔竄黑暗的玩家為 {rt6}，負責破牆。"
	L.wall_breaker_message = "破牆者"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "zhTW")
if L then
	L.claws = "坦克減益" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	L.claws_debuff = "坦克爆炸"
	L.emptiness_between_stars = "空無"
	L.void_slash = "正面斬擊"

	L.ebon_might = "小怪免疫"
end

L = BigWigs:NewBossLocale("Aberrus, the Shadowed Crucible Trash", "zhTW")
if L then
	--L.edgelord = "Sundered Edgelord" -- NPC 198873
	--L.naturalist = "Sundered Naturalist" -- NPC 201746
	--L.siegemaster = "Sundered Siegemaster" -- NPC 198874
	--L.banner = "Banner" -- Short for "Sundered Flame Banner" NPC 205638
	--L.arcanist = "Sundered Arcanist" -- NPC 201736
	--L.chemist = "Sundered Chemist" -- NPC 205656
	--L.fluid = "Animation Fluid" -- NPC 203939
	L.slime = "冒泡軟泥怪" -- NPC 205651
	--L.goo = "Crawling Goo" -- NPC 205820
	--L.whisper = "Whisper in the Dark" -- NPC 203806
end
