
local L = BigWigs:NewBossLocale("Al'Akir", "esES")
if not L then return end
if L then
	L.stormling = "Tormentillas"
	L.stormling_desc = "Invoca Tormentillas."
	L.stormling_message = "\194\161Tormentilla inminente!"
	L.stormling_bar = "Siguiente Tormentilla"
	L.stormling_yell = "Storms! I summon you to my side!"

	L.acid_rain = "Lluvia \195\161cida (%d)"
	
	L.phase3_yell = "Enough! I will no longer be contained!"

	L.phase = "Cambio de fase"
	L.phase_desc = "Anuncia los cambios de fase."

	L.cloud_message = "\194\161Franklin estar\195\173a orgulloso!"
	L.feedback_message = "%dx Rebote"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "esES")
if L then
	L.gather_strength = "%s empieza a extraer fuerza"

	L.storm_shield = "Escudo de tormenta"
	L.storm_shield_desc = "Escudo de absorci\195\179n"

	L.full_power = "Poder M\195\161ximo"
	L.full_power_desc = "Avisa cuando los jefes alcanzan Poder M\195\161ximo y empiezan a lanzar las abilidades especiales."
	L.gather_strength_emote = "¡%s empieza a extraer fuerza de los señores del viento que quedan!"

	L.wind_chill = "\194\161%sx Viento escalofriante en TI!"
end

