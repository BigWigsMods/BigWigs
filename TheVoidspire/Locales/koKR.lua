local L = BigWigs:NewBossLocale("Vorasius", "koKR")
if not L then return end
if L then
	L.shadowclaw_slam = "바닥"
end

L = BigWigs:NewBossLocale("Fallen-King Salhadaar", "koKR")
if L then
	L.fractured_projection = "차단"
end

L = BigWigs:NewBossLocale("Vaelgor & Ezzorak", "koKR")
if L then
	L.grappling_maw = "탱커 당김"
end

L = BigWigs:NewBossLocale("Lightblinded Vanguard", "koKR")
if L then
	L.aura_of_wrath = "진노" -- Short for Aura of Wrath
	--L.executes_mythic = "Executes + Dodge"
	L.execution_sentence = "선고" -- Short for Execution Sentence
	L.judgement_red = "심판 [빨]" -- R for the Red icon.
	L.aura_of_devotion = "헌오" -- Short for Aura of Devotion
	L.judgement_blue = "심판 [파]" -- B for the Blue icon.
	L.aura_of_peace = "바닥" -- Short for Aura of Peace
	--L.tyrs_wrath_mythic = "Absorbs + Executes"
	--L.divine_toll_mythic = "Dodge + Absorbs"
	L.zealous_spirit = "영혼" -- Short for Zealous Spirit

	--L.empowered_searing_radiance = "Empowered Searing Radiance"
	--L.empowered_searing_radiance_desc = "Show the timer for the empowered Searing Radiance"

	--L.empowered_avengers_shield = "Empowered Avenger's Shield"
	--L.empowered_avengers_shield_desc = "Show the timer for the empowered Avenger's Shield"

	--L.empowered_divine_storm = "Empowered Divine Storm"
	--L.empowered_divine_storm_desc = "Show the timer for the empowered Divine Storm"
	--L.tornadoes = "Tornadoes" -- The renamed empowered Divine Storm

	--L.empowered = "[E] %s" -- Empowered version of an ability, [E] Avengers Shield
end

L = BigWigs:NewBossLocale("Crown of the Cosmos", "koKR")
if L then
	L.silverstrike_arrow = "화살"
	L.grasp_of_emptiness = "방첨탑"
	L.interrupting_tremor = "차단"
	L.ravenous_abyss = "밖으로"
	L.silverstrike_barrage = "라인"
	L.cosmic_barrier = "보호막"
	L.rangers_captains_mark = "화살"
	L.voidstalker_sting = "독침"
	L.aspect_of_the_end = "사슬"
	L.devouring_cosmos = "단상 이동"
end
