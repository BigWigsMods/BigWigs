local L = BigWigs:NewBossLocale("Vorasius", "zhCN")
if not L then return end
if L then
	L.shadowclaw_slam = "重击" --“影爪重击”简称
end

L = BigWigs:NewBossLocale("Fallen-King Salhadaar", "zhCN")
if L then
	L.fractured_projection = "镜像" -- 打断？
end

L = BigWigs:NewBossLocale("Vaelgor & Ezzorak", "zhCN")
if L then
	L.grappling_maw = "抓钩之颚" -- 直接使用技能名称
end

L = BigWigs:NewBossLocale("Lightblinded Vanguard", "zhCN")
if L then
	L.aura_of_wrath = "愤怒光环"
	L.execution_sentence = "处决宣判"
	L.executes_mythic = "处决 + 躲避"
	L.judgement_red = "审判 [红]" -- 红色图标
	L.aura_of_devotion = "虔诚光环"
	L.judgement_blue = "审判 [蓝]" -- 蓝色图标
	L.aura_of_peace = "平心光环"
	L.tyrs_wrath_mythic = "吸收盾 + 处决"
	L.divine_toll_mythic = "躲避 + 吸收盾"
	L.zealous_spirit = "狂热之魂" -- “狂热之魂”全称合适

	L.empowered_searing_radiance = "强化灼热光辉"
	L.empowered_searing_radiance_desc = "显示强化灼热光辉的计时器"

	L.empowered_avengers_shield = "强化复仇者之盾"
	L.empowered_avengers_shield_desc = "显示强化复仇者之盾的计时器"

	L.empowered_divine_storm = "强化神圣风暴"
	L.empowered_divine_storm_desc = "显示强化神圣风暴的计时器"
	L.tornadoes = "旋风" -- The renamed empowered Divine Storm

	L.empowered = "[强] %s" -- Empowered version of an ability, [E] Avengers Shield
end

L = BigWigs:NewBossLocale("Crown of the Cosmos", "zhCN")
if L then
	L.silverstrike_arrow = "箭矢"
	L.grasp_of_emptiness = "方尖碑"
	L.interrupting_tremor = "干扰震荡"
	L.ravenous_abyss = "躲避"
	L.silverstrike_barrage = "弹幕"  -- 银锋弹幕射击
	L.cosmic_barrier = "屏障"
	L.rangers_captains_mark = "箭矢"
	L.voidstalker_sting = "钉刺"  -- 虚空追猎者钉刺
	L.aspect_of_the_end = "拉断"  -- 终末守护
	L.devouring_cosmos = "换场地"
end
