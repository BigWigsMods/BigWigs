local L = BigWigs:NewBossLocale("Cho'gall", "esES")
if L then
	--heroic
	L.orders = "Shadow/Flame Orders"
	L.orders_desc = "Warning for Shadow/Flame Orders"

	--normal
	L.worship_cooldown = "~Adoración"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "esES")
if L then
	L.phase_switch = "Cambio de fase"
	L.phase_switch_desc = "Aviso para cambios de fase"

	L.engulfingmagic_say = "¡Trago de magia en MI!"
	L.engulfingmagic_cooldown = "~Trago de magia"

	L.devouringflames_cooldown = "~Llamas devoradoras"

	-- L.valiona_trigger = "Theralion, I will engulf the hallway. Cover their escape!"

	L.twilight_shift = "%2$dx Cambio crepuscular en %1$s"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "esES")
if L then

end

L = BigWigs:NewBossLocale("Sinestra", "esES")
if L then

end

L = BigWigs:NewBossLocale("Ascendant Council", "esES")
if L then
	L.static_overload_say = "¡Sobrecarga estática en MI!"
	L.gravity_core_say = "¡Núcleo de gravedad en MI!"
	L.health_report = "%s está al %d%% de vida, ¡cambio pronto!"
	L.switch = "Cambio"
	L.switch_desc = "Avisa los cambios de jefes"

	L.lightning_rod_say = "¡Vara relámpago en MI!"

	L.switch_trigger = "¡Nos ocuparemos de ellos!"

	L.thundershock_quake_soon = "¡%s en 10 seg!"

	L.quake_trigger = "El suelo bajo tus pies empieza a temblar ominosamente..."
	L.thundershock_trigger = "El aire circundante chisporrotea de energía..."

	L.searing_winds_message = "¡Se forman Vientos espirales!"
	L.grounded_message = "¡Toma tierra!"

	L.last_phase_trigger = "¡CONTEMPLAD VUESTRA PERDICIÓN!"
end