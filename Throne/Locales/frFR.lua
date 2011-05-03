
local L = BigWigs:NewBossLocale("Al'Akir", "frFR")
if not L then return end
if L then
	L.stormling = "Tourmentin"
	L.stormling_desc = "Prévient quand un Tourmentin est invoqué."
	L.stormling_message = "Arrivée d'un Tourmentin !"
	L.stormling_bar = "Prochain Tourmentin"
	L.stormling_yell = "Tempêtes ! Je vous invoque à moi !" -- à vérifier

	L.acid_rain = "Pluie acide (%d)"

	L.phase3_yell = "Assez ! Je ne serai pas contenu plus longtemps !"

	L.phase = "Changement de phase"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."

	L.cloud_message = "Franklin serait fier !"
	L.feedback_message = "%dx Réaction"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "frFR")
if L then
	L.gather_strength = "%s rassemble ses forces"

	L.storm_shield = GetSpellInfo(95865)
	L.storm_shield_desc = "Bouclier d'absorption"

	L.full_power = "Puissance maximale"
	L.full_power_desc = "Prévient quand les boss atteignent leur puissance maximale et commence à incanter les techniques spéciales."
	L.gather_strength_emote = "%s commence à puiser la force des seigneurs du Vent encore présents !"  -- à vérifier

	L.wind_chill = "%sx Frisson du vent sur vous !"
end

