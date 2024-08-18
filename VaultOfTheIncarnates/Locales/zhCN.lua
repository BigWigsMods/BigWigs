local L = BigWigs:NewBossLocale("Eranog", "zhCN")
if not L then return end
if L then
	L.custom_on_nameplate_fixate = "杀戮指令姓名板图标"
	L.custom_on_nameplate_fixate_desc = "杀戮指令标记你时在姓名板显示一个图标。\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates,Plater）。"

	L.molten_cleave = "正面顺劈"
	L.molten_spikes = "尖刺"
	L.collapsing_army = "烈焰军团"
	L.greater_flamerift = "大型增援"
	L.leaping_flames = "飞扑烈焰"
end

L = BigWigs:NewBossLocale("Terros", "zhCN")
if L then
	L.resonating_annihilation = "湮灭"
	L.awakened_earth = "石柱"
	L.shattering_impact = "猛击"
	L.concussive_slam = "坦克直线"
	L.infused_fallout = "爆尘"

	L.custom_on_repeating_fallout = "重复爆尘喊话"
	L.custom_on_repeating_fallout_desc = "以 {rt7} 持续喊话，方便你找人消除爆尘"
end

L = BigWigs:NewBossLocale("The Primal Council", "zhCN")
if L then
	L.primal_blizzard = "暴风雪" -- Primal Blizzard
	L.earthen_pillars = "岩石柱" -- Earthen Pillars
	L.meteor_axes = "团队分摊" -- Meteor Axes
	L.meteor_axe = "团队分摊" -- Singular
	L.meteor_axes_melee = "近战分摊"
	L.meteor_axes_ranged = "远程分摊"

	-- L.skipped_cast = "Skipped %s (%d)"
end

L = BigWigs:NewBossLocale("Sennarth, The Cold Breath", "zhCN")
if L then
	L.ascend = "上升"
	L.ascend_desc = "瑟娜尔丝开始向其冰冷巢穴的顶端攀登。"
	L.chilling_blast = "冰冷冲击"
	L.freezing_breath = "大怪吐息"
	L.webs = "蛛网"
	L.web = "蛛网"
	L.gossamer_burst = "拉人"
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "zhCN")
if L then
	L.raging_burst = "狂怒风暴"
	L.cyclone = "拉近"
	L.crosswinds = "纷乱之风"
end

L = BigWigs:NewBossLocale("Kurog Grimtotem", "zhCN")
if L then
	-- Types
	L.damage = "伤害技能"
	L.damage_desc = "在我们不知道首领是什么元素时，显示伤害技能的计时条（岩浆爆裂，酷寒，大地笼罩，闪电崩裂）。"
	L.damage_bartext = "[伤害] %s" -- {Spell} [Dmg]

	L.avoid = "躲避技能"
	L.avoid_desc = "在我们不知道首领是什么元素时，显示躲避技能的计时条（熔火破裂，冷冽洪流，基岩喷发，震撼爆裂）。"
	L.avoid_bartext = "[躲避] %s" -- {Spell} [Avoid]

	L.ultimate = "终极技能"
	L.ultimate_desc = "在我们不知道首领是什么元素时，显示终极技能的计时条（灼热屠戮，绝对零度，地层裂口，雷霆打击）"
	L.ultimate_bartext = "[终极] %s" -- {Spell} [Ult]

	L.add_bartext = "[增援] %s" -- "{Spell} [Add]"

	L.Fire = "烈焰"
	L.Frost = "冰霜"
	L.Earth = "大地" -- check
	L.Storm = "风暴"

	-- Fire
	L.molten_rupture = "熔岩"
	L.searing_carnage = "火焰跳舞"
	L.raging_inferno = "吸收岩浆池"

	-- Frost
	L.biting_chill = "刺骨寒意"
	L.absolute_zero_melee = "近战分摊"
	L.absolute_zero_ranged = "远程分摊"

	-- Earth
	L.erupting_bedrock = "地震跳舞"

	-- Storm
	L.lightning_crash = "闪电崩裂"

	-- General
	L.primal_attunement = "软狂暴"

	-- Stage 2
	L.violent_upheaval = "石柱"
end

L = BigWigs:NewBossLocale("Broodkeeper Diurna", "zhCN")
if L then
	L.eggs_remaining = "剩余 %d 个龙蛋!"
	L.broodkeepers_bond = "剩余龙蛋"
	L.greatstaff_of_the_broodkeeper = "巨杖"
	L.clutchwatchers_rage = "狂怒"
	L.rapid_incubation = "灌注龙蛋"
	L.broodkeepers_fury = "愤怒"
	L.frozen_shroud = "定身吸收盾"
	L.detonating_stoneslam = "坦克分摊"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "zhCN")
if L then
	L.lighting_devastation_trigger = "深吸" -- Raszageth takes a deep breath...

	-- Stage One: The Winds of Change
	L.volatile_current = "火花"
	L.thunderous_blast = "冲击"
	L.lightning_strikes = "打击"
	L.electric_scales = "团队伤害"
	L.electric_lash = "鞭笞"
	-- Stage Two: Surging Power
	-- L.absorb_text = "%s (%.0f%%)"
	L.stormsurge = "吸收护盾"
	L.stormcharged = "正或负电荷"
	L.positive = "正"
	L.negative = "负"
	L.focused_charge = "伤害增益"
	L.tempest_wing = "风暴之翼"
	L.fulminating_charge = "积雷"
	L.fulminating_charge_debuff = "积雷"
	-- Intermission: The Vault Falters
	L.ball_lightning = "闪电球"
	-- Stage Three: Storm Incarnate
	L.magnetic_charge = "积雷倒数"

	L.custom_on_repeating_stormcharged = "重复正和负"
	L.custom_on_repeating_stormcharged_desc = "使用图标{rt1}, {rt3} 重复显示正和负的信息，来帮助你找到正确的位置。"

	L.skipped_cast = "闪电吐息 %s (%d)"

	L.custom_off_raidleader_devastation = "闪电毁灭: 全局模式"
	L.custom_off_raidleader_devastation_desc = "在另一个台子上也显示闪电毁灭（吐息）"
	L.breath_other = "[对面] %s" -- Breath on opposite platform
end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "zhCN")
if L then

end
