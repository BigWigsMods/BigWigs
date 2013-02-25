local L = BigWigs:NewBossLocale("The Stone Guard", "esES") or BigWigs:NewBossLocale("The Stone Guard", "esMX")
if not L then return end
if L then
	L.petrifications = "Petrificación"
	L.petrifications_desc = "Aviso para cuando el jefe empieza petrificación"

	L.overload = "Sobrecarga" -- maybe should use a spellId that says exactly "Overload"
	L.overload_desc = "Aviso para todo tipo de sobrecargas."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "esES") or BigWigs:NewBossLocale("Feng the Accursed", "esMX")
if L then
	L.engage_yell = "Preparad vuestras almas, mortales. ¡Os adentráis en las cámaras de los muertos!"

	L.phase_flame_trigger = "¡Oh, exaltado! ¡Soy tu herramienta para desgarrar la carne de los huesos!"
	L.phase_lightning_trigger = "¡Oh, gran espíritu! ¡Otórgame el poder de la tierra!"
	L.phase_arcane_trigger = "¡Oh, sabio eterno! ¡Transmíteme tu sapiencia Arcana!"
	L.phase_shadow_trigger = "¡Almas de campeones antiguos! ¡Concededme vuestro escudo!"

	L.phase_flame = "¡Fase de llamas!"
	L.phase_lightning = "¡Fase de rayos!"
	L.phase_arcane = "¡Fase arcana!"
	L.phase_shadow = "(Heroico) ¡Fase de sombras!"

	L.phase_message = "¡Nueva fase pronto!"
	L.shroud_message = "Embozo"
	L.shroud_can_interrupt = "¡%s se puede interrumpir %s!"
	L.barrier_message = "¡Barrera Activa!"
	L.barrier_cooldown = "Barrera disponible"

	-- Tanks
	L.tank = "Alertas de tanques"
	L.tank_desc = "Cuenta los stacs de Latigazo de relámpagos, Lanza flamígera, Choque arcano y Quemadura de las sombras (Heroico)."
	L.lash_message = "Latigazo"
	L.spear_message = "Lanza"
	L.shock_message = "Choque"
	L.burn_message = "Quemadura"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "esES") or BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "esMX")
if L then
	L.engage_yell = "¡Ya es hora de morir!"

	L.totem_message = "Totem (%d)"
	L.shadowy_message = "Ataque (%d)"
	L.banish_message = "Tanque desterrado"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "esES") or BigWigs:NewBossLocale("The Spirit Kings", "esMX")
if L then
	L.bosses = "Jefes"
	L.bosses_desc = "Avisa cuando un jefe se activa."

	L.shield_removed = "¡Escudo eliminado! (%s)"
	L.casting_shields = "Casteando escudos"
	L.casting_shields_desc = "Alerta cuando los escudos son casteados por todos los jefes."
end

L = BigWigs:NewBossLocale("Elegon", "esES") or BigWigs:NewBossLocale("Elegon", "esMX")
if L then
	L.engage_yell = "Activando modo defensivo. Desactivando mecanismos de prevención."

	L.last_phase = "Última fase"
	L.overcharged_total_annihilation = "¡Sobrecarga %d! ¿Un poco excesivo?"

	L.floor = "Desaparece el suelo"
	L.floor_desc = "Aviso para cuando el suelo esté a punto de desaparecer."
	L.floor_message = "¡El suelo está desapareciendo!"

	L.adds = "Adds"
	L.adds_desc = "Aviso para cuando un Protector Celestial esta a punto de aparecer."
end

L = BigWigs:NewBossLocale("Will of the Emperor", "esES") or BigWigs:NewBossLocale("Will of the Emperor", "esMX")
if L then
	L.enable_zone = "Forja del Infinito"

	L.heroic_start_trigger = "¡Las tuberías rotas" -- Destroying the pipes leaks |cFFFF0000|Hspell:116779|h[Titan Gas]|h|r into the room!
	L.normal_start_trigger = "¡La máquina vuelve a la vida! ¡Baja el nivel inferior!" -- The machine hums to life!  Get to the lower level!

	L.rage_trigger = "La ira del Emperador resuena por las colinas."
	L.strength_trigger = "¡La fuerza del Emperador aparece en la habitación!"
	L.courage_trigger = "¡El coraje del Emperador aparece en la habitación!"
	L.bosses_trigger = "¡Aparecen dos construcciones titánicas en las enormes habitaciones!"
	L.gas_trigger = "¡La Antigua Máquina Mogu se rompe!"
	L.gas_overdrive_trigger = "¡La Antigua Máquina Mogu se sobrecarga!"

	L.target_only = "|cFFFF0000Este aviso solo se mostrará para el jefe que estés targeteando.|r "
	L.combo_message = "¡%s: Combo inminente!"
end

