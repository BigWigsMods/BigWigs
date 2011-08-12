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
	L.armor = "Armadura obsidiana"
	L.armor_desc = "Avisar cuando los stacs de armadura estén desapareciendo de Piroclaso."
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
	L.cataclysm_bar = "Próximo cataclismo"

	L.stage_message = "Fase %d"
	L.kill_message = "It's now or never - Kill her!"
	L.engage_message = "Alysrazor engaged - Stage 2 in ~%d min"

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
	L.crystal_trap = "Prisión de cristal"

	L.traps_header = "Trampas"
	L.immolation = "Trampa de inmolación"
	L.immolation_desc = "Alerta cuando Rostrofuria o Desmembrador pasen por una trampa de inmolación."
	L.immolation_icon = 99838
	L.immolationyou = "Immolation Trap under You"
	L.immolationyou_desc = "Alert when an Immolation Trap is summoned under you."
	L.immolationyou_icon = 99838
	L.immolationyou_message = "Immolation Trap"
	L.crystal = "Trampa de cristal"
	L.crystal_desc = "Avisa a quien Shannox lance una trampa de cristal debajo."
	L.crystal_icon = 99836
end

L = BigWigs:NewBossLocale("Baleroc", "esES")
if L then
	L.torment = "Stacs de Tormento en Foco"
	L.torment_desc = "Avisa cuando tu /focus gana otro stac de Tormento."
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
	--L.intermission_end_trigger1 = "Sulfuras will be your end."
	--L.intermission_end_trigger2 = "Fall to your knees, mortals!  This ends now."
	--L.intermission_end_trigger3 = "Enough! I will finish this."
	--L.phase4_trigger = "Too soon..."
	L.seed_explosion = "¡Explosión de semillas!"
	L.intermission_bar = "¡Intermisión!"
	L.intermission_message = "¡Intermisión!"
	L.sons_left = "%d hijos restantes"
	L.engulfing_close = "¡Sección cercana sumergida!"
	L.engulfing_middle = "¡Sección central sumergida!"
	L.engulfing_far = "¡Sección lejana sumergida"
	L.hand_bar = "Próximo rebote"
	L.ragnaros_back_message = "¡Raggy ha vuelto, fiesta!"

	L.wound = "Burning Wound "..INLINE_TANK_ICON
	L.wound_desc = "Tank alert only. Count the stacks of burning wound and show a duration bar."
	L.wound_message = "%2$dx Wound on %1$s"
end

