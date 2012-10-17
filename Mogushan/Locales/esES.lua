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
	L.phase_arcane_trigger =  "¡Oh, sabio eterno! ¡Transmíteme tu sapiencia Arcana!"
	L.phase_shadow_trigger = "Great soul of champions past! Bear to me your shield!" -- traducir

	L.phase_flame = "¡Fase de llamas!"
	L.phase_lightning = "¡Fase de rayos!"
	L.phase_arcane = "¡Fase arcana!"
	L.phase_shadow = "(Heroico) ¡Fase de sombras!"

	L.shroud_message = "%2$s castea Embozo en %1$s"
	L.barrier_message = "¡Barrera Activa!"

	-- Tanks
	L.tank = "Alertas de tanques"
	L.tank_desc = "Solo alertas de tanques. Cuenta los stacs de Latigazo de relámpagos, Lanza flamígera, Choque arcano y Quemadura de las sombras (Heroico)."
	L.lash_message = "%2$dx Latigazo en %1$s"
	L.spear_message = "%2$dx Lanza en %1$s"
	L.shock_message = "%2$dx Choque en %1$s"
	L.burn_message = "%2$dx Quemadura en %1$s"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "esES") or BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "esMX")
if L then
	L.engage_yell = "¡Ya es hora de morir!"

	L.totem = "Totem"
	L.frenzy = "¡Fresení inminente!"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "esES") or BigWigs:NewBossLocale("The Spirit Kings", "esMX")
if L then
	L.shield_removed = "¡Escudo eliminado!"
end

L = BigWigs:NewBossLocale("Elegon", "esES") or BigWigs:NewBossLocale("Elegon", "esMX")
if L then
	L.last_phase = "Última fase"
	L.overcharged_total_annihilation = "¡Tienes (%d) %s, resetea tu debuff!"

	L.floor = "Floor Despawn"
	L.floor_desc = "Warnings for when the floor is about to despawn."
	L.floor_icon = "ability_vehicle_launchplayer"
	L.floor_message = "The floor is falling!!"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "esES") or BigWigs:NewBossLocale("Will of the Emperor", "esMX")
if L then
	L.enable_zone = "Forge of the Endless"

	L.rage_trigger = "The Emperor's Rage echoes through the hills." -- tradudcir
	L.strength_trigger = "The Emperor's Strength appears in the alcoves!" -- traducir
	L.courage_trigger = "The Emperor's Courage appears in the alcoves!" -- traducir
	L.bosses_trigger = "Two titanic constructs appear in the large alcoves!" -- traducir

	L.arc_desc = "|cFFFF0000Este aviso solo se mostrará para el jefe que estés targeteando.|r " .. (select(2, EJ_GetSectionInfo(5673)))
end

