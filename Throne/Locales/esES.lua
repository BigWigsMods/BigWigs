local L = BigWigs:NewBossLocale("Al'Akir", "esES")
if L then
	L.windburst = windburst

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

	L.storm_shield = stormShield
	L.storm_shield_desc = "Escudo de absorción"
	
	L.full_power = "Lleno de poder"
	L.full_power_desc = "Avisa cuando los jefes están llenos de poder y empiezan a lanzar las abilidades especiales."
	L.gather_strength_emote = "¡%s empieza a reunir fuerza de los señores de viento restantes!"
	
	L.wind_chill = "TIENES %s stacks de Viento escalofriante"
end
