local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "esES")
if not L then return end
if L then
	L.storm_duration = "Tormenta de relámpagos duración"
	L.storm_duration_desc = "Una barra a parte avisa para la duración del casteo de la Tormenta de relámpagos."
	L.storm_short = "Tormenta"

	L.in_water = "¡Estás en el agua!"
end

L = BigWigs:NewBossLocale("Horridon", "esES")
if L then
	L.charge_trigger = "fija la vista" -- Horridon sets his eyes on PLAYERNAME and stamps his tail!

	L.chain_lightning_message = "¡Tu foco está casteando Cadena de relámpagos!"
	L.chain_lightning_bar = "Foco: Cadena de relámpagos"

	L.fireball_message = "¡Tu foco está casteando Bola de Fuego!"
	L.fireball_bar = "Foco: Bola de Fuego"

	L.venom_bolt_volley_message = "¡Tu foco está casteando Salva!"
	L.venom_bolt_volley_bar = "Foco: Salva"

	L.adds = "Aparecen adds"
	L.adds_desc = "Avisa cuando los Farraki, los Gurubashi, los Drakkari, los Amani y dios de la guerra Jalak aparecen."

	L.orb_message = "¡Orbe de control suelto!"

	L.focus_only = "|cffff0000Solo alertas de Foco.|r "

	L.door_opened = "¡Puerta abierta!"
	L.door_bar = "Siguiente Puerta (%d)"
	L.balcony_adds = "Adds de balcón"
	L.door_trigger = "salen en tropel" -- "<160.1 21:33:04> CHAT_MSG_RAID_BOSS_EMOTE#Farraki forces pour from the Farraki Tribal Door!#War-God Jalak#####0#0##0#1107#nil#0#false#false", -- [1]
end

L = BigWigs:NewBossLocale("Council of Elders", "esES")
if L then
	L.priestess_adds = "Adds de la Sacerdotisa"
	L.priestess_adds_desc = "Aviso para todo tipo de adds de la Suma Sacerdotisa Mar'li."
	L.priestess_adds_message = "Add de la Sacerdotisa"

	L.assault_stun = "¡Tanque aturdido!"
	L.full_power = "Poder máximo"
	L.assault_message = "Asalto"
	L.hp_to_go_power = "¡%d%% HP para acabar! (Poder: %d)"
	L.hp_to_go_fullpower = "¡%d%% HP para acabar! (Poder máximo)"

	L.custom_on_markpossessed = "Marcar jefe poseído"
	L.custom_on_markpossessed_desc = "Marca al jefe poseído con una calavera."
end

L = BigWigs:NewBossLocale("Tortos", "esES")
if L then
	L.kick = "Patear"
	L.kick_desc = "Lleva la cuenta de cuantas tortugas pueden ser pateadas."
	L.kick_message = "Tortugas pateables: %d"

	L.crystal_shell_removed = "¡Caparazón de cristal eliminado!"
	L.no_crystal_shell = "SIN Caparazón de cristal"
end

L = BigWigs:NewBossLocale("Megaera", "esES")
if L then
	L.breaths = "Alientos"
	L.breaths_desc = "Avisos relacionados con los diferentes tipos de alientos."

	L.arcane_adds = "Adds arcanos"
end

L = BigWigs:NewBossLocale("Ji-Kun", "esES")
if L then
	L.lower_hatch_trigger = "¡Los huevos de uno de los nidos inferiores empiezan a abrirse!"
	L.upper_hatch_trigger = "¡Los huevos de uno de los nidos superiores empiezan a abrirse!"

	L.nest = "Nidos"
	L.nest_desc = "Avisos relacionados con los nidos. |cffff0000¡No cambies esto para desactivar los avisos, si no estás asignado para gestionar los nidos!|r"

	L.flight_over = "Vuelo completado durante %d sec!"
	L.upper_nest = "Nido |cff008000superior|r"
	L.lower_nest = "Nido |cffff0000inferior|r"
	L.upper = "|cff008000Superior|r"
	L.lower = "|cffff0000Inferior|r"
	L.add = "Add"
	L.big_add_message = "Add grande al %s"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "esES")
if L then
	L.red_spawn_trigger = "¡La Luz infrarroja revela una niebla carmesí!"
	L.blue_spawn_trigger = "¡Los Rayos azules revelan una niebla azur!"
	L.yellow_spawn_trigger = "¡La Luz brillante revela una niebla ámbar!" -- verificar

	L.adds = "Adds revelados"
	L.adds_desc = "Avisa cuando revelas una niebla carmesí, ámbar o azur y cuantas nieblas carmesies quedan."

	L.custom_off_ray_controllers = "Controladores de rayo"
	L.custom_off_ray_controllers_desc = "Usa las marcas de raid %s%s%s para marcar gente que controlará las posiciones y movimientos cuando aparecen los rayos."

	L.rays_spawn = "Aparecen rayos"
	L.red_add = "Add |cffff0000rojo|r"
	L.blue_add = "Add |cff0000ffazul|r"
	L.yellow_add = "Add |cffffff00amarillo|r"
	L.death_beam = "Rayo mortal"
	L.red_beam = "Rayo |cffff0000rojo|r"
	L.blue_beam = "Rayo |cff0000ffazul|r"
	L.yellow_beam = "Rayo |cffffff00amarillo|r"
end

L = BigWigs:NewBossLocale("Primordius", "esES")
if L then
	L.mutations = "Mutaciones |cff008000(%d)|r |cffff0000(%d)|r"
end

L = BigWigs:NewBossLocale("Dark Animus", "esES")
if L then
	L.engage_trigger = "¡El orbe explota!"
	L.slam_message = "Embate"
end

L = BigWigs:NewBossLocale("Iron Qon", "esES")
if L then
	L.molten_energy = "Energía de arrabio"

	L.overload_casting = "Casteando Sobrecarga de arrabio"
	L.overload_casting_desc = "Avisa cuando está casteando Sobrecarga de arrabio"

	L.arcing_lightning_cleared = "Raid limpia de Arco de relámpagos"
end

L = BigWigs:NewBossLocale("Twin Consorts", "esES")
if L then
	L.barrage_fired = "¡Tromba disparada!"
	L.last_phase_yell_trigger = "Solo esta vez..." -- "<490.4 01:24:30> CHAT_MSG_MONSTER_YELL#Just this once...#Lu'lin###Suen##0#0##0#3273#nil#0#false#false", -- [6]
end

L = BigWigs:NewBossLocale("Lei Shen", "esES")
if L then
	L.conduit_abilities = "Habilidades de conducto"
	L.conduit_abilities_desc = "Barras para CD aproximado para las habilidades específicas de los conductos."
	L.conduit_abilities_message = "Próx. hab. de conducto"

	L.intermission = "Intermedio"
	L.diffusion_add = "Difusión de adds"
	L.shock = "Choque"

	L.overcharged_message = "Pulso de zona aturdidor"
	L.static_shock_message = "Daño de zona para compartir"
	L.diffusion_chain_message = "Difusión de adds inminente - ¡DISPERSAOS!"
end

L = BigWigs:NewBossLocale("Ra-den", "esES")
if L then

end

