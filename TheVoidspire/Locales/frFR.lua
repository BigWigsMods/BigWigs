local L = BigWigs:NewBossLocale("Vorasius", "frFR")
if not L then return end
if L then
	L.shadowclaw_slam = "Coups"
end

L = BigWigs:NewBossLocale("Fallen-King Salhadaar", "frFR")
if L then
	L.fractured_projection = "Interruptions"
end

L = BigWigs:NewBossLocale("Vaelgor & Ezzorak", "frFR")
if L then
	L.grappling_maw = "Tank Grip"
end

L = BigWigs:NewBossLocale("Lightblinded Vanguard", "frFR")
if L then
	L.aura_of_wrath = "Colère" -- Short for Aura of Wrath
	L.execution_sentence = "Exécution" -- Short for Execution Sentence
	L.executes_mythic = "Exécution + Esquive"
	L.judgement_red = "Jugement [R]" -- R for the Red icon.
	L.aura_of_devotion = "Dévotion" -- Short for Aura of Devotion
	L.judgement_blue = "Jugement [B]" -- B for the Blue icon.
	L.aura_of_peace = "Paix" -- Short for Aura of Peace
	L.tyrs_wrath_mythic = "Absorption + Exécution"
	L.divine_toll_mythic = "Esquive + Absorption"
	L.zealous_spirit = "Esprit" -- Short for Zealous Spirit

	L.empowered_searing_radiance = "Radiance ardente renforcée"
	L.empowered_searing_radiance_desc = "Affiche le chrono de la radiance ardente renforcée"

	L.empowered_avengers_shield = "Bouclier du vengeur renforcé"
	L.empowered_avengers_shield_desc = "Affiche le chrono du bouclier du vengeur renforcé"

	L.empowered_divine_storm = "Tempête divine renforcée"
	L.empowered_divine_storm_desc = "Affiche le chrono de la tempête divine renforcée"
	L.tornadoes = "Tornades" -- The renamed empowered Divine Storm

	L.empowered = "[R] %s" -- Empowered version of an ability, [E] Avengers Shield
end

L = BigWigs:NewBossLocale("Crown of the Cosmos", "frFR")
if L then
	L.silverstrike_arrow = "Flèche"
	L.grasp_of_emptiness = "Obélisques"
	L.interrupting_tremor = "Interruption"
	L.ravenous_abyss = "Sortir"
	L.silverstrike_barrage = "Lignes"
	L.cosmic_barrier = "Barrière"
	L.rangers_captains_mark = "Flèches"
	L.voidstalker_sting = "Piqûre"
	L.aspect_of_the_end = "Liens"
	L.devouring_cosmos = "Prochaine plateforme"
end
