local L = BigWigs:NewBossLocale("Al'Akir", "esES")
if L then
	L.windburst = (GetSpellInfo(87770))

	-- L.phase3_yell = "Enough! I will no longer be contained!"
	
	L.phase_change = "Cambio de fase"
	L.phase_change_desc = "Anuncia los cambios de fase."
	L.phase_message = "Fase %d"
	
	L.feedback_message = "%dx rebote"
	
	L.you = "%s en TI!"
end

local L = BigWigs:NewBossLocale("Conclave of Wind", "esES")
if L then
	L.gather_strength = "%s está reuniendo fuerza"

	L.storm_shield = GetSpellInfo(95865)
	L.storm_shield_desc = "Escudo de absorción"
	
	L.full_power = "Full Power"
	L.full_power_desc = "Avisa cuando los jefes alcanzan Full Power y empiezan a lanzar las abilidades especiales."
	L.gather_strength_emote = "¡%s empieza a reunir fuerza de los señores de viento restantes!"
	
	L.wind_chill = "TU tienes %s stacks de Viento escalofriante"
end
