local L = BigWigs:NewBossLocale("Beth'tilac", "esES")
if not L then return end
if L then
	L.devastate_message = "¡Devastación #%d!"
	L.devastate_bar = "~Próxima devastación"
	L.drone_bar = "Próximo Zángano"
	L.drone_message = "¡Zángano aparece!"
	L.kiss_message = "Beso"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "esES")
if L then
	L.armor = "Obsidian Armor"
	L.armor_desc = "Warn when armor stacks are being removed from Rhyolith."
	L.armor_icon = 98632
	L.armor_message = "%d%% armadura restante"
	L.armor_gone_message = "¡Armadura destruida!"

	L.adds_header = "Adds"
	L.big_add_message = "¡Aparece una Chispa!"
	L.small_adds_message = "¡Aparecen fragmentos pequeños!"

	L.phase2_warning = "Fase 2 inminente!"

	L.molten_message = "%dx stacks en el jefe!"

	L.stomp_message = "¡Pisotón! ¡Pisotón! ¡Pisotón!"
	L.stomp_warning = "Próximo pisotón"
end

L = BigWigs:NewBossLocale("Alysrazor", "esES")
if L then
	L.tornado_trigger = "¡Estos cielos son MÍOS!"
	L.claw_message = "%2$dx Garra en %1$s"
	L.fullpower_soon_message = "¡Poder máximo inminente!"
	L.halfpower_soon_message = "¡Fase 4 inminente!"
	L.encounter_restart = "Aquí vamos otra vez ..."
	L.no_stacks_message = "No sé si te importa, pero no tienes plumas"
	L.moonkin_message = "Deja de fingir y consigue algunas plumas reales"
	L.molt_bar = "Siguiente Muda"

	L.stage_message = "Fase %d"
	
	L.worm_emote = "¡Gusanos de lava ígneos surgen del suelo!"
	L.phase2_soon_emote = "Alysrazor empieza a volar rápido en círculos."
	L.phase2_emote = "99794" -- Fiery Vortex spell ID used in the emote
	L.phase3_emote = "99432" -- Burns Out spell ID used in the emote
	L.phase4_emote = "99922" -- Re-Ignites spell ID used in the emote
	L.restart_emote = "99925" -- Full Power spell ID used in the emote
	
	L.flight = "Asistente de vuelo"
	L.flight_desc = "Muestra una barra con la duración de 'Alas de llamas' en ti, es ideal usarlo con la opción de Super Enfatizar."
end

L = BigWigs:NewBossLocale("Shannox", "esES")
if L then
	L.safe = "%s a salvo"
	L.immolation_trap = "¡Inmolación en %s!"
	L.crystaltrap = "Prisión de cristal"
end

L = BigWigs:NewBossLocale("Baleroc", "esES")
if L then
	L.torment = "Torment stacks on Focus"
	L.torment_desc = "Warn when your /focus gains another torment stack."
	L.torment_message = "%2$dx Tormento en %1$s"

	L.blade_bar = "~Hoja"
	L.shard_message = "¡Fragmento morado (%d)!"
	L.focus_message = "¡Tu foco tiene %d stacks!"
	L.countdown_bar = "Próximo enlace"
	L.link_message = "Enlazado"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "esES")
if L then
	L.seed_explosion = "¡Semilla explota pronto!"
	L.seed_bar = "¡Explotas!"
	L.adrenaline_message = "¡Adrenalina x%d!"
end

L = BigWigs:NewBossLocale("Ragnaros", "esES")
if L then
	L.seed_explosion = "¡Explosión de semillas!"
	L.intermission_bar = "¡Intermisión!"
	L.intermission_message = "¡Intermisión!"
	L.sons_left = "%d hijos restantes"
	L.engulfing_close = "¡Sección cercana sumergida!"
	L.engulfing_middle = "¡Sección central sumergida!"
	L.engulfing_far = "¡Sección lejana sumergida"
	L.hand_bar = "Próximo rebote"
	L.wound_bar = "Herida en %s"
	L.ragnaros_back_message = "¡Raggy ha vuelto, fiesta!"
end

