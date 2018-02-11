local L = BigWigs:NewBossLocale("Argus the Unmaker", "zhCN")
if not L then return end
if L then
	L.combinedBurstAndBomb = "合并灵魂爆发和灵魂炸弹"
	L.combinedBurstAndBomb_desc = "|cff71d5ff灵魂炸弹|r总是与|cff71d5ff灵魂爆发|r一起使用。启用此选项将此两条消息合并为一条。"

	L.custom_off_always_show_combined = "总是显示合并灵魂爆发和灵魂炸弹信息"
	L.custom_off_always_show_combined_desc = "当你受到|cff71d5ff灵魂炸弹|r或|cff71d5ff灵魂爆发|r时合并信息不会被显示。启用此选项将总是显示合并信息，即使你受到影响。|cff33ff99对团队领袖有用处。|r"

	L.fear_help = "萨格拉斯的恐惧"
	L.fear_help_desc = "当你受到|cff71d5ff萨格拉斯的恐惧|r和|cff71d5ff灵魂凋零|r/|cff71d5ff灵魂爆发|r/|cff71d5ff灵魂炸弹|r/|cff71d5ff萨格拉斯的判决|r影响时发出特殊喊话。"

	L[257931] = "恐惧" -- short for Sargeras' Fear
	L[248396] = "凋零" -- short for Soulblight
	L[251570] = "炸弹" -- short for Soulbomb
	L[250669] = "爆发" -- short for Soulburst
	L[257966] = "裁决" -- short for Sentence of Sargeras

	L.stage2_early = "让大海的怒涛洗刷这腐蚀吧！"
	L.stage3_early = "没有希望。只有痛苦。痛苦！"

	L.gifts = "恩赐：%s（天空），%s（海洋）"
	L.burst = "|T1778229:15:15:0:0:64:64:4:60:4:60|t爆发：%s" -- short for Soulburst
	L.bomb = "|T1778228:15:15:0:0:64:64:4:60:4:60|t炸弹：%s" -- short for Soulbomb

	L.sky_say = "{rt5} 爆击/精通" -- short for Critical Strike/Mastery (stats)
	L.sea_say = "{rt6} 急速/全能" -- short for Haste/Versatility (stats)

	L.bomb_explosions = "炸弹爆炸"
	L.bomb_explosions_desc = "显示灵魂爆发和灵魂炸弹爆炸计时条。"
end

L = BigWigs:NewBossLocale("Aggramar", "zhCN")
if L then
	L.wave_cleared = "已清理%d波！" -- Wave 1 Cleared!

	L.track_ember = "泰沙拉克的余烬追踪器"
	L.track_ember_desc = "显示每个泰沙拉克的余烬死亡信息。"

	L.custom_off_ember_marker_desc = "使用 {rt1}{rt2}{rt3}{rt4}{rt5} 标记泰沙拉克的余烬，需要权限。\n|cff33ff99史诗：将只会标记当前一波能量大于45的增援。|r"
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "zhCN")
if L then
	L.torment_of_the_titans_desc = "破坏魔会迫使泰坦之魂使用他们的技能对抗玩家。"

	L.timeLeft = "%.1f秒" -- s = seconds
	L.torment = "痛苦：%s"
	L.nextTorment = "下次痛苦：|cffffffff%s|r"
	L.tormentHeal = "治疗/伤害" -- something like Heal/DoT (max 10 characters)
	L.tormentLightning = "闪电" -- short for "Chain Lightning" (or similar, max 10 characters)
	L.tormentArmy = "军团" -- short for "Spectral Army of Norgannon" (or similar, max 10 characters)
	L.tormentFlames = "火焰" -- short for "Flames of Khaz'goroth" (or similar, max 10 characters)
end

L = BigWigs:NewBossLocale("Eonar the Life-Binder", "zhCN")
if L then
	L.warp_in_desc = "显示每一波计时条信息，连同每波中的任一特殊增援。"

	L.top_lane = "上"
	L.mid_lane = "中"
	L.bot_lane = "下"

	L.purifier = "净化者" -- Fel-Powered Purifier
	L.destructor = "毁灭者" -- Fel-Infused Destructor
	L.obfuscator = "干扰器" -- Fel-Charged Obfuscator
	L.bats = "邪能蝙蝠"
end

L = BigWigs:NewBossLocale("Portal Keeper Hasabel", "zhCN")
if L then
	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "哈萨贝尔下次会随机释放非冷却技能。当此选项开启，这些技能条将保留在屏幕上。"
	L.custom_on_filter_platforms = "过滤外侧平台警报和计时条"
	L.custom_on_filter_platforms_desc = "当你不是上台分组时移除不必要的信息和计时条。这将只显示中央平台：枢纽的警报和计时条。"
	L.worldExplosion_desc = "显示崩塌的世界爆炸计时条。"
	L.platform_active = "%s激活！" -- Platform: Xoroth Active!
	L.add_killed = "%s已击杀！"
end

L = BigWigs:NewBossLocale("Kin'garoth", "zhCN")
if L then
	L.empowered = "（强化）%s" -- (E) Ruiner
	L.gains = "高戈奈斯获得%s" -- Kin'garoth gains Empowered Ruiner
end

L = BigWigs:NewBossLocale("Antoran High Command", "zhCN")
if L then
	L.felshieldActivated = "%s已激活邪能护盾"
	L.felshieldUp = "邪能护盾"
end

L = BigWigs:NewBossLocale("Gorothi Worldbreaker", "zhCN")
if L then
	L.cannon_ability_desc = "显示加洛西灭世者背后两门火炮的信息和计时条。"

	L.missileImpact = "歼灭撞击"
	L.missileImpact_desc = "显示歼灭飞弹着陆计时条。"

	L.decimationImpact = "屠戮撞击"
	L.decimationImpact_desc = "显示屠戮飞弹着陆计时条。"
end

L = BigWigs:NewBossLocale("Antorus Trash", "zhCN")
if L then
	-- [[ Before Garothi Worldbreaker ]] --
	--L.felguard = "Antoran Felguard"

	-- [[ After Garothi Worldbreaker ]] --
	--L.flameweaver = "Flameweaver"

	-- [[ Before Antoran High Command ]] --
	--L.ravager = "Bladesworn Ravager"
	--L.deconix = "Imperator Deconix"
	--L.clobex = "Clobex"

	-- [[ Before Portal Keeper Hasabel ]] --
	--L.stalker = "Hungering Stalker"

	-- [[ Before Varimathras / Coven of Shivarra ]] --
	--L.tarneth = "Tarneth"
	--L.priestess = "Priestess of Delirium"

	-- [[ Before Aggramar ]] --
	--L.aedis = "Dark Keeper Aedis"
end
