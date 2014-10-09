local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "esES") or BigWigs:NewBossLocale("Jin'rokh the Breaker", "esMX")
if not L then return end
if L then
	L.storm_duration = "Tormenta de relámpagos duración"
	L.storm_duration_desc = "Una barra a parte avisa para la duración del casteo de la Tormenta de relámpagos."
	L.storm_short = "Tormenta"

	L.in_water = "¡Estás en el agua!"
end

L = BigWigs:NewBossLocale("Horridon", "esES") or BigWigs:NewBossLocale("Horridon", "esMX")
if L then
	L.charge_trigger = "fija la vista" -- Horridon sets his eyes on PLAYERNAME and stamps his tail!
	L.door_trigger = "salen en tropel" -- Farraki forces pour from the Farraki Tribal Door!
	--L.orb_trigger = "charge" -- PLAYERNAME forces Horridon to charge the Farraki door!

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
end

L = BigWigs:NewBossLocale("Council of Elders", "esES") or BigWigs:NewBossLocale("Council of Elders", "esMX")
if L then
	L.priestess_adds = "Adds de la Sacerdotisa"
	L.priestess_adds_desc = "Aviso para todo tipo de adds de la Suma Sacerdotisa Mar'li."
	L.priestess_adds_message = "Add de la Sacerdotisa"

	--L.priestess_heal = "%s was healed!"
	L.assault_stun = "¡Tanque aturdido!"
	L.full_power = "Poder máximo"
	L.assault_message = "Asalto"
	L.hp_to_go_power = "¡%d%% HP para acabar! (Poder: %d)"
	L.hp_to_go_fullpower = "¡%d%% HP para acabar! (Poder máximo)"

	L.custom_on_markpossessed = "Marcar jefe poseído"
	L.custom_on_markpossessed_desc = "Marca al jefe poseído con una calavera."
end

L = BigWigs:NewBossLocale("Tortos", "esES") or BigWigs:NewBossLocale("Tortos", "esMX")
if L then
	L.bats_desc = "Murciélagos. Contrólalos."

	L.kick = "Patear"
	L.kick_desc = "Lleva la cuenta de cuantas tortugas pueden ser pateadas."
	L.kick_message = "Tortugas pateables: %d"
	L.kicked_message = "¡%s pateada! (%d restantes)"

	L.custom_off_turtlemarker = "Marcador de tortugas"
	L.custom_off_turtlemarker_desc = "Marca las tortugas usando todos los iconos de raid.\n|cFFFF0000Solo 1 persona de la raid debería tener esta opción activada para prevenir conflictos con las marcas.|r\n|cFFADFF2FCONSEJO: Si la raid te ha elegido para activarla, mover el ratón rápidamente sobre todas las tortugas es la forma más rápida de marcarlas.|r"

	L.no_crystal_shell = "SIN Caparazón de cristal"
end

L = BigWigs:NewBossLocale("Megaera", "esES") or BigWigs:NewBossLocale("Megaera", "esMX")
if L then
	L.breaths = "Alientos"
	L.breaths_desc = "Avisos relacionados con los diferentes tipos de alientos."

	L.arcane_adds = "Adds arcanos"
end

L = BigWigs:NewBossLocale("Ji-Kun", "esES") or BigWigs:NewBossLocale("Ji-Kun", "esMX")
if L then
	L.first_lower_hatch_trigger = "¡Los huevos de los nidos más bajos empiezan a abrirse!"
	L.lower_hatch_trigger = "¡Los huevos de uno de los nidos inferiores empiezan a abrirse!"
	L.upper_hatch_trigger = "¡Los huevos de uno de los nidos superiores empiezan a abrirse!"

	L.nest = "Nidos"
	L.nest_desc = "Avisos relacionados con los nidos.\n|cFFADFF2FCONSEJO: No cambies esto para desactivar los avisos, si no estás asignado para gestionar los nidos.|r"

	L.flight_over = "¡Vuelo completado en %d seg!"
	L.upper_nest = "Nido |cff008000superior|r"
	L.lower_nest = "Nido |cffff0000inferior|r"
	L.up = "|cff008000ARRIBA|r"
	L.down = "|cffff0000ABAJO|r"
	L.add = "Add"
	L.big_add_message = "Add grande al %s"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "esES") or BigWigs:NewBossLocale("Durumu the Forgotten", "esMX")
if L then
	L.red_spawn_trigger = "¡La Luz infrarroja revela una niebla carmesí!"
	L.blue_spawn_trigger = "¡Los Rayos azules revelan una niebla azur!"
	L.yellow_spawn_trigger = "¡La Luz brillante revela una niebla ámbar!" -- verificar

	L.adds = "Adds revelados"
	L.adds_desc = "Avisa cuando revelas una niebla carmesí, ámbar o azur y cuantas nieblas carmesies quedan."

	L.custom_off_ray_controllers = "Controladores de rayo"
	L.custom_off_ray_controllers_desc = "Usa las marcas de raid {rt1}{rt7}{rt6} para marcar gente que controlará las posiciones y movimientos cuando aparecen los rayos."

	L.custom_off_parasite_marks = "Marcador de Parásito oscuro"
	L.custom_off_parasite_marks_desc = "Para ayudar con las sanaciones, marca la gente que tiene Parásito oscuro en ellos con {rt3}{rt4}{rt5}."

	L.initial_life_drain = "Casteo inicial de Drenar vida"
	L.initial_life_drain_desc = "Mensaje para el casteo inicial de Drenar vida para ayudar a mantener la sanación recibida por el debuff de reducción."

	L.life_drain_say = "%dx Drenar"

	L.rays_spawn = "Aparecen rayos"
	L.red_add = "Add |cffff0000rojo|r"
	L.blue_add = "Add |cff0000ffazul|r"
	L.yellow_add = "Add |cffffff00amarillo|r"
	L.death_beam = "Rayo mortal"
	L.red_beam = "Rayo |cffff0000rojo|r"
	L.blue_beam = "Rayo |cff0000ffazul|r"
	L.yellow_beam = "Rayo |cffffff00amarillo|r"
end

L = BigWigs:NewBossLocale("Primordius", "esES") or BigWigs:NewBossLocale("Primordius", "esMX")
if L then
	L.mutations = "Mutaciones |cff008000(%d)|r |cffff0000(%d)|r"
end

L = BigWigs:NewBossLocale("Dark Animus", "esES") or BigWigs:NewBossLocale("Dark Animus", "esMX")
if L then
	L.engage_trigger = "¡El orbe explota!"

	L.matterswap_desc = "Un jugador con Intercambio de materia está lejos de ti. Intercambiaréis lugares si se disipa."
	L.matterswap_message = "¡Estás alejado de Intercambio de materia!"

	L.siphon_power = "Succionar ánima (%d%%)"
	L.siphon_power_soon = "¡Succionar ánima (%d%%) %s inminente!"
	L.slam_message = "Embate"
end

L = BigWigs:NewBossLocale("Iron Qon", "esES") or BigWigs:NewBossLocale("Iron Qon", "esMX")
if L then
	L.molten_energy = "Energía de arrabio"

	L.overload_casting = "Casteando Sobrecarga de arrabio"
	L.overload_casting_desc = "Avisa cuando está casteando Sobrecarga de arrabio"

	L.arcing_lightning_cleared = "Raid limpia de Arco de relámpagos"

	L.custom_off_spear_target = "Objetivo de Lanzar lanza"
	L.custom_off_spear_target_desc = "Intentará avisar del objetivo de Lanzar lanza. Esto requiere un uso elevado de la CPU y a veces muestra un objetivo equivocado así que esta deshabilitado por defecto.\n|cFFADFF2FCONSEJO: Crear roles de TANQUE debería ayudar a aumentar la precisión del aviso.|r"
	L.possible_spear_target = "Posible Lanza"
end

L = BigWigs:NewBossLocale("Twin Consorts", "esES") or BigWigs:NewBossLocale("Twin Consorts", "esMX")
if L then
	L.barrage_fired = "¡Tromba disparada!"
	L.last_phase_yell_trigger = "Solo esta vez..." -- "<490.4 01:24:30> CHAT_MSG_MONSTER_YELL#Just this once...#Lu'lin###Suen##0#0##0#3273#nil#0#false#false", -- [6]
end

L = BigWigs:NewBossLocale("Lei Shen", "esES") or BigWigs:NewBossLocale("Lei Shen", "esMX")
if L then
	L.custom_off_diffused_marker = "Marcador de Relámpago difuminado"
	L.custom_off_diffused_marker_desc = "Marca los adds Relámpago difuminado usando todos los iconos de raid, requiere ayudante o líder.\n|cFFFF0000Solo 1 persona en la raid debería tener esto activado para prevenir conflictos con las marcas.|r\n|cFFADFF2FCONSEJO: Si la raid te ha elegido para activar esto, mover el ratón rápidamente por encima de todos los adds es la forma más rápida de marcarlos.|r"

	L.stuns = "Aturdimientos"
	L.stuns_desc = "Muestra barras para la duración del aturdimiento, usar para controlar la Bola de relámpagos."

	L.aoe_grip = "Agarre zonal"
	L.aoe_grip_desc = "Avisa cuando un DK usa Abrazo de Sanguino, usar para controlar la Bola de relámpagos."

	L.shock_self = "Choque estático en TI"
	L.shock_self_desc = "Muestra una barra con la duración del debuff Choque estático en ti."

	L.overcharged_self = "Sobrecarga en TI"
	L.overcharged_self_desc = "Muestra una barra con la duración del debuff Sobrecarga en ti."

	L.last_inermission_ability = "¡Última habilidad del intermedio usada!"
	L.safe_from_stun = "Probablemente estés a salvo de los aturdimientos por Sobrecarga"
	L.diffusion_add = "Difusión de adds"
	L.shock = "Choque"
	L.static_shock_bar = "<Choque estático dividido>"
	L.overcharge_bar = "<Pulso de Sobrecarga>"
end

L = BigWigs:NewBossLocale("Ra-den", "esES") or BigWigs:NewBossLocale("Ra-den", "esMX")
if L then
	L.vita_abilities = "Habilidades de Vita"
	L.anima_abilities = "Habilidades de Ánima"
	L.worm = "Gusano"
	L.worm_desc = "Invocar gusano"

	L.balls = "Bolas"
	L.balls_desc = "Bolas de Ánima (rojo) y Vita (azul), que determinan que habilidades ganará Ra-den"

	L.assistPrint = "Un plugin llamado 'BigWigs_Ra-denAssist' ha sido publicado para ayudarte en el encuentro contra Ra-den y puede que tu grupo esté interesado en probarlo."

	L.corruptedballs = "Bolas corruptas"
	L.corruptedballs_desc = "Bolas Vita y Ánima corruptas, que, o bien aumenta el daño (Vita) o hp máximo (Ánima)"

	L.unstablevitajumptarget = "Salto intestable de Vita"
	L.unstablevitajumptarget_desc = "Te avisa cuando estás más alejado de un jugador con Vita inestable. Si enfatizas esto, también mostrará una cuenta atrás para cuando Vita inestable esté a punto de saltar DE ti."

	L.unstablevitajumptarget_message = "Eres el más alejado de Vita inestable"
	L.sensitivityfurthestbad = "Sensibilidad a la vita + alejado = |cffff0000MALO|r!"
	L.kill_trigger = "Wait!" -- Wait! I am... I am not your enemy. You are powerful. More powerful than he was, even.... Perhaps you are right. Perhaps there is still hope.
end

L = BigWigs:NewBossLocale("Throne of Thunder Trash", "esES") or BigWigs:NewBossLocale("Throne of Thunder Trash", "esMX")
if L then
	L.stormcaller = "Invocatormentas Zandalari"
	L.stormbringer = "Extiendetormentas Draz'kil"
	L.monara = "Monara"
	L.rockyhorror = "Horror rocoso"
	L.thunderlord_guardian = "Señor de los truenos / Guardián de los relámpagos"
end

