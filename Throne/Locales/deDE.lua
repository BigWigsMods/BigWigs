local L = BigWigs:NewBossLocale("Al'Akir", "deDE")
if L then
	L.windburst = (GetSpellInfo(87770))

	L.phase3_yell = "Genug! Ich werde mich nicht länger zurückhalten!" -- check

	L.phase_change = "Phasenwechsel"
	L.phase_change_desc = "Warnt vor Phasenwechsel."
	L.phase_message = "Phase %d"

	L.feedback_message = "%dx Rückkopplung"

	L.you = "%s auf DIR!"
end

local L = BigWigs:NewBossLocale("Conclave of Wind", "deDE")
if L then
	L.gather_strength = "%s sammelt Stärke"

	L.full_power = "Volle Stärke"
	L.full_power_desc = "Warnt, wenn der Boss volle Stärke erreicht hat und seine Spezialfähigkeiten wirkt."
	L.gather_strength_emote = "%s beginnt von den verbliebenen Windlords Stärke zu beziehen!" -- check

	L.wind_chill = "%sx Windkühle auf DIR!"
end
