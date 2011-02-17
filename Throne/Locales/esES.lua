
local L = BigWigs:NewBossLocale("Al'Akir", "esES")
if not L then return end
if L then
	L.stormling = "Tormentillas"
	L.stormling_desc = "Invoca Tormentillas."
	L.stormling_message = "¡Tormentilla inminente!"
	L.stormling_bar = "Siguiente Tormentilla"
	L.stormling_yell = "¡Tormentas! ¡Os convoco a mi lado!"

	L.acid_rain = "Lluvia ácida (%d)"

	L.phase3_yell = "¡Basta! ¡No permitiré que se me contenga más tiempo!"

	L.phase = "Cambio de fase"
	L.phase_desc = "Anuncia los cambios de fase."

	L.cloud_message = "¡Franklin estaría orgulloso!"
	L.feedback_message = "%dx Rebote"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "esES")
if L then
	L.gather_strength = "%s empieza a extraer fuerza"

	L.storm_shield = "Escudo de tormenta"
	L.storm_shield_desc = "Escudo de absorción"

	L.full_power = "Poder Máximo"
	L.full_power_desc = "Avisa cuando los jefes alcanzan Poder Máximo y empiezan a lanzar las abilidades especiales."
	L.gather_strength_emote = "¡%s empieza a extraer fuerza de los señores del viento que quedan!"

	L.wind_chill = "¡%sx Viento escalofriante en TI!"
end

