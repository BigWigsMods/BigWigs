
local L = BigWigs:NewBossLocale("Cho'gall", "esES")
if not L then return end
if L then
	L.orders = "Cambios de posici\195\179n"
	L.orders_desc = "Avisa cuando Cho'gall cambia el orden de posiciones entre Sombra/Llama."

	L.crash_say = "\194\161Colisi\195\179n en MI!"
	L.worship_cooldown = "~Conversi\195\179n"
	L.adherent_bar = "Gran add #%d"
	L.adherent_message = "\194\161Add %d aparece!"
	L.ooze_bar = "Enjambre de mocos %d"
	L.ooze_message = "\194\161Enjambre de mocos %d entrando!"
	L.tentacles_bar = "Aparecen tent\195\161culos"
	L.tentacles_message = "\194\161Fiesta de tent\195\161culos!"
	L.sickness_message = "\194\161Te sientes fatal!"
	L.fury_bar = "Pr\195\179xima furia"
	L.fury_message = "\194\161Furia!"

	L.phase2_message = "\194\161Fase 2!"
	L.phase2_soon = "\194\161Fase 2 pronto!"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "esES")
if L then
	L.phase_switch = "Cambio de fase"
	L.phase_switch_desc = "Avisa los cambios de fase"

	L.phase_bar = "%s aterriza"
	L.breath_message = "\194\161Aliento profundo entrante!"
	L.dazzling_message = "\194\161Zonas espirales entrantes!"

	L.engulfingmagic_say = "\194\161Trago de magia en MI!"
	L.engulfingmagic_cooldown = "(CD) Trago de magia"

	L.devouringflames_cooldown = "(CD) Llamas devoradoras"

	L.valiona_trigger = "Theralion, voy a incendiar el corredor. ¡Que no escapen!"

	L.win_trigger = "Al menos... Theralion muere conmigo..."

	L.twilight_shift = "%2$dx Cambio en %1$s"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "esES")
if L then
	L.paralysis_bar = "Pr\195\179xima par\195\161lisis"

	L.strikes_message = "%2$dx Golpes mal\195\169volos en %1$s"
end

L = BigWigs:NewBossLocale("Sinestra", "esES")
if L then
	L.egg_vulnerable = "\194\161Hora de la tortilla!"

	L.omelet_trigger = "You mistake this for weakness?  Fool!"

	L.phase13 = "Fase 1 y 3"
	L.phase = "Fase"
	L.phase_desc = "Avisa los cambios de fase"
end

L = BigWigs:NewBossLocale("Ascendant Council", "esES")
if L then
	L.static_overload_say = "\194\161Sobrecarga est\195\161tica en MI!"
	L.gravity_core_say = "\194\161N\195\186cleo de gravedad en MI!"
	L.health_report = "%s est\195\161 al %d%% de vida, \194\161cambio pronto!"
	L.switch = "Cambio"
	L.switch_desc = "Avisa los cambios de jefes"

	L.shield_up_message = "\194\161Escudo activo!"
	L.shield_bar = "Pr\195\179ximo escudo"

	L.switch_trigger = "¡Nos ocuparemos de ellos!"

	L.thundershock_quake_soon = "\194\161%s en 10 seg!"

	L.quake_trigger = "El suelo bajo tus pies empieza a temblar ominosamente..."
	L.thundershock_trigger = "El aire circundante chisporrotea de energía..."

	L.searing_winds_message = "\194\161Rel\195\161mpago entrante!"
	L.grounded_message = "\194\161Terremoto entrante!"

	L.last_phase_trigger = "¡CONTEMPLAD VUESTRA PERDICIÓN!"
end

