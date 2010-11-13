local L = BigWigs:NewBossLocale("Al'Akir", "frFR")
if L then

end

local L = BigWigs:NewBossLocale("Conclave of Wind", "frFR")
if L then
	L.gather_strength = "%s rassemble ses forces"

	L.full_power = "Puissance maximale"
	L.full_power_desc = "Prévient quand les boss atteignent leur puissance maximale et commence à incanter les techniques spéciales."
	L.gather_strength_emote = "%s begins to gather strength from the remaining Wind Lords!"  -- récupérer transcription

	L.wind_chill = "Vous avez %s cumuls de Frisson du vent"
end
