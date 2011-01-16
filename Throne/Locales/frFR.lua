local L = BigWigs:NewBossLocale("Al'Akir", "frFR")
if L then
	L.phase3_yell = "Assez ! Je ne serais pas contenu plus longtemps !" -- à vérifier

	L.phase = "Changement de phase"
	L.phase_desc = "Prévient quand la rencontre entre dans une nouvelle phase."

	L.feedback_message = "%dx Réaction"
end

local L = BigWigs:NewBossLocale("Conclave of Wind", "frFR")
if L then
	L.gather_strength = "%s rassemble ses forces"

	L.storm_shield = GetSpellInfo(95865)
	L.storm_shield_desc = "Bouclier d'absorption"

	L.full_power = "Puissance maximale"
	L.full_power_desc = "Prévient quand les boss atteignent leur puissance maximale et commence à incanter les techniques spéciales."
	L.gather_strength_emote = "%s commence à puiser la force des seigneurs du Vent encore présents !"  -- à vérifier

	L.wind_chill = "%sx Frisson du vent sur vous !"
end
