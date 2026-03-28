local L = BigWigs:NewBossLocale("Vorasius", "deDE")
if not L then return end
if L then
	L.shadowclaw_slam = "Hiebe"
end

L = BigWigs:NewBossLocale("Fallen-King Salhadaar", "deDE")
if L then
	L.fractured_projection = "Unterbrechungen"
end

L = BigWigs:NewBossLocale("Vaelgor & Ezzorak", "deDE")
if L then
	L.grappling_maw = "Tank Griff"
end

L = BigWigs:NewBossLocale("Lightblinded Vanguard", "deDE")
if L then
	L.aura_of_wrath = "Zorn" -- Short for Aura of Wrath
	L.execution_sentence = "Todesurteil" -- Short for Execution Sentence
	--L.executes_mythic = "Executes + Dodge"
	L.judgement_red = "Richturteil [R]" -- R for the Red icon.
	L.aura_of_devotion = "Hingabe" -- Short for Aura of Devotion
	L.judgement_blue = "Richturteil [B]" -- B for the Blue icon.
	L.aura_of_peace = "Frieden" -- Short for Aura of Peace
	--L.tyrs_wrath_mythic = "Absorbs + Executes"
	--L.divine_toll_mythic = "Dodge + Absorbs"
	L.zealous_spirit = "Geist" -- Short for Zealous Spirit

	--L.empowered_searing_radiance = "Empowered Searing Radiance"
	--L.empowered_searing_radiance_desc = "Show the timer for the empowered Searing Radiance"

	--L.empowered_avengers_shield = "Empowered Avenger's Shield"
	--L.empowered_avengers_shield_desc = "Show the timer for the empowered Avenger's Shield"

	--L.empowered_divine_storm = "Empowered Divine Storm"
	--L.empowered_divine_storm_desc = "Show the timer for the empowered Divine Storm"
	--L.tornadoes = "Tornadoes" -- The renamed empowered Divine Storm

	--L.empowered = "[E] %s" -- Empowered version of an ability, [E] Avengers Shield
end

L = BigWigs:NewBossLocale("Crown of the Cosmos", "deDE")
if L then
	L.silverstrike_arrow = "Pfeile"
	L.grasp_of_emptiness = "Obelisken"
	L.interrupting_tremor = "Unterbrechung"
	L.ravenous_abyss = "Herausbewegen"
	L.silverstrike_barrage = "Linien"
	L.cosmic_barrier = "Barriere"
	L.rangers_captains_mark = "Pfeile"
	L.voidstalker_sting = "Stiche"
	L.aspect_of_the_end = "Verbindungen"
	L.devouring_cosmos = "Nächste Plattform"
end
