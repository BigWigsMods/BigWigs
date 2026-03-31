local L = BigWigs:NewBossLocale("Vorasius", "zhTW")
if not L then return end
if L then
	L.shadowclaw_slam = "猛擊"
end

L = BigWigs:NewBossLocale("Fallen-King Salhadaar", "zhTW")
if L then
	L.fractured_projection = "投影"
end

L = BigWigs:NewBossLocale("Vaelgor & Ezzorak", "zhTW")
if L then
	L.grappling_maw = "爪鉤之喉"
end

L = BigWigs:NewBossLocale("Lightblinded Vanguard", "zhTW")
if L then
	L.aura_of_wrath = "憤慨光環" -- Short for Aura of Wrath 不用縮寫
	L.execution_sentence = "死刑宣判" -- Short for Execution Sentence  不用縮寫，或者處決?
	L.executes_mythic = "死刑+躲開" -- 死刑宣判+神聖鳴響
	L.judgement_red = "紅色審判" -- R for the Red icon. 審判+裁決
	L.aura_of_devotion = "奉獻光環" -- Short for Aura of Devotion
	L.judgement_blue = "藍色審判" -- B for the Blue icon. 審判+盾猛
	L.aura_of_peace = "和平光環" -- Short for Aura of Peace
	L.tyrs_wrath_mythic = "吸收+死刑" -- 提爾之盾+死刑宣判，吸收盾/治療吸收盾太長了
	L.divine_toll_mythic = "躲開 + 吸收" -- 神聖鳴響+提爾之盾
	L.zealous_spirit = "狂熱" -- Short for Zealous Spirit

	L.empowered_searing_radiance = "強化熾熱烈光"
	L.empowered_searing_radiance_desc = "顯示強化熾熱烈光的計時條"

	L.empowered_avengers_shield = "強化神聖之盾"
	L.empowered_avengers_shield_desc = "顯示強化神聖之盾的計時條"

	L.empowered_divine_storm = "強化神性風暴"
	L.empowered_divine_storm_desc = "顯示強化神性風暴的計時條"
	L.tornadoes = "神聖暴風" -- The renamed empowered Divine Storm 手冊裡這麼叫

	L.empowered = "強化%s" -- Empowered version of an ability, [E] Avengers Shield
end

L = BigWigs:NewBossLocale("Crown of the Cosmos", "zhTW")
if L then
	L.silverstrike_arrow = "箭矢"
	L.grasp_of_emptiness = "方尖碑"
	L.interrupting_tremor = "震顫" --用法術名，或者斷法
	L.ravenous_abyss = "深淵" -- 貪婪深淵
	L.silverstrike_barrage = "箭雨"  -- 銀殤箭雨
	L.cosmic_barrier = "屏障"
	L.rangers_captains_mark = "箭頭" --遊俠隊長印記，是個箭頭
	L.voidstalker_sting = "釘刺" -- 虛無潛獵者釘刺
	L.aspect_of_the_end = "拉斷" -- 終結守護
	L.devouring_cosmos = "下個平台" -- 換場地/換平台/下個平台
end
