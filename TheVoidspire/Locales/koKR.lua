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
	L.executes_mythic = "선고 + 피하기"
	L.execution_sentence = "선고" -- Short for Execution Sentence
	L.judgement_red = "심판 [빨]" -- R for the Red icon.
	L.aura_of_devotion = "헌오" -- Short for Aura of Devotion
	L.judgement_blue = "심판 [파]" -- B for the Blue icon.
	L.aura_of_peace = "바닥" -- Short for Aura of Peace
	L.tyrs_wrath_mythic = "보호막 + 선고"
	L.divine_toll_mythic = "피하기 + 보호막"
	L.zealous_spirit = "영혼" -- Short for Zealous Spirit

	L.empowered_searing_radiance = "강화된 이글거리는 광휘"
	L.empowered_searing_radiance_desc = "강화된 이글거리는 광휘 타이머 표시"

	L.empowered_avengers_shield = "강화된 응징의 방패"
	L.empowered_avengers_shield_desc = "강화된 응징의 방패 타이머 표시"

	L.empowered_divine_storm = "강화된 천상의 폭풍"
	L.empowered_divine_storm_desc = "강화된 천상의 폭풍 타이머 표시"
	L.tornadoes = "토네이도" -- The renamed empowered Divine Storm

	L.empowered = "[강화] %s" -- Empowered version of an ability, [E] Avengers Shield
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
