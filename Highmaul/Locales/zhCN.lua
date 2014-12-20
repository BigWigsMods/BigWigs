local L = BigWigs:NewBossLocale("Kargath Bladefist", "zhCN")
if not L then return end
if L then
	L.blade_dance_bar = "刃舞"

	L.arena_sweeper_desc = "获取被锁链投掷后击飞出竞技场平台计时器。"
end

L = BigWigs:NewBossLocale("The Butcher", "zhCN")
if L then
	L.adds_multiple = "增援 >%d<波"
end

L = BigWigs:NewBossLocale("Tectus", "zhCN")
if L then
	L.earthwarper_trigger1 = "Yjj'rmr……Xzzolos……"
	L.earthwarper_trigger2 = "对，泰克图斯。臣服于……主人的……意志吧……"
	L.earthwarper_trigger3 = "你不明白！我们不能停下……！"
	--L.berserker_trigger1 = "MASTER!" -- MASTER! I COME FOR YOU!
	L.berserker_trigger2 = "卡拉克……黑暗在低语……有个声音！"
	--L.berserker_trigger3 = "Graaagh!" --Graaagh! KAHL...  AHK... RAAHHHH!

	L.tectus = "泰克图斯"
	L.shard = "碎片"
	L.motes = "微粒"

	L.custom_off_barrage_marker = "晶化弹幕标记"
	L.custom_off_barrage_marker_desc = "使用 {rt1}{rt2}{rt3}{rt4}{rt5} 标记晶化弹幕目标，需要权限。"

	L.adds_desc = "新的增援进入战斗计时器。"
end

L = BigWigs:NewBossLocale("Brackenspore", "zhCN")
if L then
	L.mythic_ability = "特殊技能"
	L.mythic_ability_desc = "当下一潮汐之唤或爆炸蘑菇到来时显示计时器。"

	L.creeping_moss_boss_heal = "苔藓>治疗< 首领"
	L.creeping_moss_add_heal = "苔藓>治疗< 大型增援"
end

L = BigWigs:NewBossLocale("Twin Ogron", "zhCN")
if L then
	L.volatility_self_desc = "当你受到奥能动荡减益时选项。"

	L.custom_off_volatility_marker = "奥能动荡标记"
	L.custom_off_volatility_marker_desc = "使用 {rt1}{rt2}{rt3}{rt4} 标记奥能动荡目标，需要权限。"
end

L = BigWigs:NewBossLocale("Ko'ragh", "zhCN")
if L then
	L.fire_bar = "全体爆炸！"
	L.overwhelming_energy_bar = "溢流能量攻击 (%d)"
	--L.overwhelming_energy_mc_bar = "MC balls hit (%d)"

	L.custom_off_fel_marker = "魔能散射：邪能标记"
	L.custom_off_fel_marker_desc = "使用 {rt1}{rt2}{rt3} 标记魔能散射：邪能，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r"
end

L = BigWigs:NewBossLocale("Imperator Mar'gok", "zhCN")
if L then
	L.phase4_trigger = "你根本不了解你所染指的力量，马尔高克。"

	L.branded_say = "%s (%d) %d码"
	L.add_death_soon = "即将 奥术畸兽！"
	L.slow_fixate = "减速+锁定"

	L.custom_off_fixate_marker = "锁定标记"
	L.custom_off_fixate_marker_desc = "使用 {rt1}{rt2} 标记高里亚战争法师的锁定目标，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r"

	L.custom_off_branded_marker = "烙印标记"
	L.custom_off_branded_marker_desc = "使用 {rt3}{rt4} 标记烙印目标，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r"	
end

