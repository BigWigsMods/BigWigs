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
	L.aura_of_wrath = "愤怒" -- “愤怒光环”简称
	L.execution_sentence = "处决" -- “处决宣判”简称
	--L.executes_mythic = "Executes + Dodge"
	L.judgement_red = "审判 [红]" -- 红色图标
	L.aura_of_devotion = "虔诚" -- “虔诚光环”简称
	L.judgement_blue = "审判 [蓝]" -- 蓝色图标
	L.aura_of_peace = "平心" -- “平心光环”简称
	--L.tyrs_wrath_mythic = "Absorbs + Executes"
	--L.divine_toll_mythic = "Dodge + Absorbs"
	L.zealous_spirit = "狂热之魂" -- “狂热之魂”全称合适

	--L.empowered_searing_radiance = "Empowered Searing Radiance"
	--L.empowered_searing_radiance_desc = "Show the timer for the empowered Searing Radiance"

	--L.empowered_avengers_shield = "Empowered Avenger's Shield"
	--L.empowered_avengers_shield_desc = "Show the timer for the empowered Avenger's Shield"

	--L.empowered_divine_storm = "Empowered Divine Storm"
	--L.empowered_divine_storm_desc = "Show the timer for the empowered Divine Storm"
	--L.tornadoes = "Tornadoes" -- The renamed empowered Divine Storm

	--L.empowered = "[E] %s" -- Empowered version of an ability, [E] Avengers Shield
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
