
local L = BigWigs:NewBossLocale("Al'Akir", "deDE")
if not L then return end
if L then
	L.phase3_yell = "Genug! Ich werde mich nicht länger zurückhalten!" -- check

	L.phase = "Phasenwechsel"
	L.phase_desc = "Warnt vor Phasenwechsel."

	L.cloud_message = "Gewitter auf DIR!"
	L.feedback_message = "%dx Rückkopplung"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "deDE")
if L then
	L.gather_strength = "%s sammelt Stärke"

	L.storm_shield = "Sturmschild"
	L.storm_shield_desc = "Warnt, wenn Rohash Sturmschild wirkt."

	L.full_power = "Volle Stärke"
	L.full_power_desc = "Warnt, wenn die Bosse volle Stärke erreicht haben und ihre Spezialfähigkeiten wirken."
	L.gather_strength_emote = "%s beginnt von den verbliebenen Windlords Stärke zu beziehen!" -- check

	L.wind_chill = "%sx Windkühle auf DIR!"
end

