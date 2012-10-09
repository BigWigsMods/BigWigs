local L = BigWigs:NewBossLocale("The Stone Guard", "esES")
if not L then return end
if L then
	L.petrifications = "Petrificación"
	L.petrifications_desc = "Aviso para cuando el jefe empieza petrificación"

	L.overload = "Sobrecarga" -- maybe should use a spellId that says exactly "Overload"
	L.overload_desc = "Aviso para todo tipo de sobrecargas."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "esES")
if L then
	L.phases = "Fases"
	L.phases_desc = "Aviso para cambios de fase"

	L.phase_flame_trigger = "¡Oh, exaltado! ¡Soy tu herramienta para desgarrar la carne de los huesos!"
	L.phase_lightning_trigger = "¡Oh, gran espíritu! ¡Otórgame el poder de la tierra!"
	L.phase_arcane_trigger =  "¡Oh, sabio eterno! ¡Transmíteme tu sapiencia Arcana!"
	L.phase_shadow_trigger = "Great soul of champions past! Bear to me your shield!" -- traducir

	L.phase_flame = "¡Fase de llamas!"
	L.phase_lightning = "¡Fase de rayos!"
	L.phase_arcane = "¡Fase arcana!"
	L.phase_shadow = "¡Fase de sombras!"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "esES")
if L then
	L.frenzy = "¡Fresení inminente!"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "esES")
if L then
	L.shield_removed = "¡Escudo eliminado!"
end

L = BigWigs:NewBossLocale("Elegon", "esES")
if L then
	L.last_phase = "Última fase"
	L.floor_despawn = "Desaparece el suelo"
	L.overcharged_total_annihilation = "¡Tienes (%d) %s, resetea tu debuff!"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "esES")
if L then
	L.rage_trigger = "The Emperor's Rage echoes through the hills." -- tradudcir
	L.strength_trigger = "The Emperor's Strength appears in the alcoves!" -- traducir
	L.courage_trigger = "The Emperor's Courage appears in the alcoves!" -- traducir
	L.bosses_trigger = "Two titanic constructs appear in the large alcoves!" -- traducir

	L.arc_desc = "|cFFFF0000Este aviso solo se mostrará para el jefe que estés targeteando.|r " .. (select(2, EJ_GetSectionInfo(5673)))
end

