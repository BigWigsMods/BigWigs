local L = BigWigs:NewBossLocale("Anub'arak", "esES")
if L then
	L.engage_message = "¡Anub'arak activo, se entierra en 80sec!"
	L.engage_trigger = "¡Este lugar será vuestra tumba!"

	L.unburrow_trigger = "emerge de la tierra!"
	L.burrow_trigger = "se entierra en el suelo!"
	L.burrow = "Se entierra"
	L.burrow_desc = "Mostrar contadores para emerger y enterrar, y también para aparición de adds."
	L.burrow_cooldown = "Siguiente enterrar"
	L.burrow_soon = "Se entierra pronto"

	L.nerubian_message = "¡Aparecen Adds!"
	L.nerubian_burrower = "Más adds"

	L.shadow_soon = "¡Golpe de las Sombras en ~5sec!"

	L.freeze_bar = "~Siguiente Tajo congelante"
	L.pcold_bar = "~Siguiente Frío penetrante"

	L.chase = "Perseguido"
end

L = BigWigs:NewBossLocale("The Beasts of Northrend", "esES")
if L then
	L.enable_trigger = "¡Bienvenidos, campeones! ¡Habéis escuchado la Llamada de la Cruzada Argenta y os habéis atrevido a responder!"
	L.wipe_trigger = "Trágico..."

	L.engage_trigger = "Desde las cavernas más oscuras y profundas de Las Cumbres Tormentosas: ¡Gormok el Empalador! ¡A luchar, héroes!"
	L.jormungars_trigger = "Preparaos, héroes, para los temibles gemelos: ¡Fauceácida y Aterraescama! ¡A la arena!"
	L.icehowl_trigger = "El propio aire se congela al presentar a nuestro siguiente combatiente: ¡Aullahielo! ¡Matad o morid, campeones!"
	L.boss_incoming = "%s entrando"

	-- Gormok
	L.snobold = "Snobold"
	L.snobold_desc = "Avisa quien tiene un Snobold en su cabeza."
	L.snobold_message = "Add"
	L.impale_message = "%2$dx Empalar en %1$s"
	L.firebomb_message = "¡Fuego en TI!"

	-- Jormungars
	L.submerge = "Sumerge"
	L.submerge_desc = "Muestra un contador para la siguiente vez que los gusanos se sumerjan."
	L.spew = "Acidic/Molten Spew"
	L.spew_desc = "Warn for Acidic/Molten Spew."
	L.sprays = "Sprays"
	L.sprays_desc = "Muestra un contador para los siguientes sprays de Parálisis y Fuego."
	L.slime_message = "¡Baba paralizante en TI!"
	L.burn_spell = "Fuego"
	L.toxin_spell = "Toxina"
	L.spray = "~Siguiente Spray"

	-- Icehowl
	L.butt_bar = "~Topetazo Cooldown"
	L.charge = "Carga furiosa"
	L.charge_desc = "Avisa sobre la Carga furiosa en jugadores."
	L.charge_trigger = "mira a"
	L.charge_say = "¡Carga en MI!"

	L.bosses = "Jefes"
	L.bosses_desc = "Avisa cuando los Jefes esten entrando."
end

L = BigWigs:NewBossLocale("Faction Champions", "esES")
if L then
	L.enable_trigger = "¡La siguiente batalla os enfrentará a los caballeros más poderosos de la Cruzada Argenta! Solo seréis dignos si los derrotáis..."
	L.defeat_trigger = "Una victoria trágica y fútil."

	L["Shield on %s!"] = "¡Escudo en %s!"
	L["Bladestorming!"] = "¡Filotormenta"
	L["Hunter pet up!"] = "¡Mascota de Cazador up!"
	L["Felhunter up!"] = "¡Manáfago up!"
	L["Heroism on champions!"] = "¡Heroismo en campeones!"
	L["Bloodlust on champions!"] = "¡Ansia de sangre en campeones!"
end

L = BigWigs:NewBossLocale("Lord Jaraxxus", "esES")
if L then
	L.enable_trigger = "¡Un gnomo insignificante! ¡Tu arrogancia será tu perdición!"

	L.engage = "Activo"
	L.engage_trigger = "Soy Jaraxxus, señor Eredar de la Legión Ardiente."
	L.engage_trigger1 = "But I'm in charge here"

	L.adds = "Portales y Volcanes"
	L.adds_desc = "Muestra un contador y un aviso cuando Jaraxxus invoque portales y volcanes."

	L.incinerate_message = "Incinerar"
	L.incinerate_other = "¡%s tiene bomba!"
	L.incinerate_bar = "Siguiente Incinerar"
	L.incinerate_safe = "%s esta a salvo, ya :)"

	L.legionflame_message = "Llamas"
	L.legionflame_other = "¡Llamas en %s!"
	L.legionflame_bar = "Siguiente llamas"

	L.infernal_bar = "Volcán aparece"
	L.netherportal_bar = "Portal aparece"
	L.netherpower_bar = "~Siguiente Poder abisal"

	L.kiss_message = "¡Beso en TI!"
	L.kiss_interrupted = "¡Cortado!"
end

L = BigWigs:NewBossLocale("The Twin Val'kyr", "esES")
if L then
	L.engage_trigger1 = "En el nombre de nuestro oscuro maestro. Por el Rey Exánime. Morirás."

	L.vortex_or_shield_cd = "Siguiente Vórtice o Escudo"
	L.next = "Siguiente Vórtice o Escudo"
	L.next_desc = "Aviso para siguiente Vórtice o Escudo"

	L.vortex = "Vórtice"
	L.vortex_desc = "Aviso cuando la gemela empieza a lanzar vórtices."

	L.shield = "Escudo de Oscuridad/Luz"
	L.shield_desc = "Aviso para Escudo de Oscuridad/Luz."
	L.shield_half_message = "¡Escudo al 50% de fuerza!"
	L.shield_left_message = "%d%% fuerza del escudo acabada"

	L.touch = "Toque de Oscuridad/Luz"
	L.touch_desc = "Aviso para Toque de Oscuridad/Luz"
end
