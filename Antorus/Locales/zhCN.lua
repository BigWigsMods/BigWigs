local L = BigWigs:NewBossLocale("Argus the Unmaker", "zhCN")
if not L then return end
if L then
	--L.stage2_early = "Let the fury of the sea wash away this corruption!"
	--L.stage3_early = "No hope. Just pain. Only pain!"
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "zhCN")
if L then
	L.torment_of_the_titans_desc = "破坏魔会迫使泰坦之魂使用他们的技能对抗玩家。"
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
	L.custom_on_filter_platforms = "过滤外侧平台警报和计时条"
	L.custom_on_filter_platforms_desc = "当你不是上台分组时移除不必要的信息和计时条。这将只显示中央平台：枢纽的警报和计时条。"
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
	L.missileImpact_desc = "显示歼灭飞弹着陆计时条。"
end
