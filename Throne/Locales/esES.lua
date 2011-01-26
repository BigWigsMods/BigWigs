local L = BigWigs:NewBossLocale("Al'Akir", "esES")
if L then
	-- L.phase3_yell = "Enough! I will no longer be contained!"
	
	L.phase = "Cambio de fase"
	L.phase_desc = "Anuncia los cambios de fase."
	
	L.cloud_message = "\194\161Franklin estar\195\173a orgulloso!"
	L.feedback_message = "%dx rebote"
end

local L = BigWigs:NewBossLocale("Conclave of Wind", "esES")
if L then
	L.gather_strength = "%s empieza a extraer fuerza"

	L.storm_shield = stormShield
	L.storm_shield_desc = "Escudo de absorci\195\179n"
	
	L.full_power = "Poder M\195\161ximo"
	L.full_power_desc = "Avisa cuando los jefes alcanzan Poder M\195\161ximo y empiezan a lanzar las abilidades especiales."
	L.gather_strength_emote = "¡%s empieza a extraer fuerza de los señores del viento que quedan!"
	
	L.wind_chill = "\194\161%sx Viento escalofriante en TI!"
end