local L = BigWigs:NewBossLocale("Beth'tilac", "esES")
if not L then return end
if L then
	L.devastate_message = "¡Devastación #%d!"
	L.devastate_bar = "~Próxima devastación"
	L.drone_bar = "Próximo Zángano telaceniza"
	L.drone_message = "¡Atención zángano aparece!"
	L.kiss_message = "Beso"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "esES")
if L then
	L.molten_message = "%dx stacks en el jefe!"
	L.armor_message = "%d%% armadura restante"
	L.armor_gone_message = "¡Armadura destruida!"
	L.phase2_soon_message = "Fase 2 inminente!"
	L.stomp_message = "¡Pisotón! ¡Pisotón! ¡Pisotón!"
	L.stomp_warning = "Next Stomp"
	L.big_add_message = "¡Atención add aparece!"
	L.small_adds_message = "¡Aparecen fragmentos pequeños!"
end

L = BigWigs:NewBossLocale("Alysrazor", "esES")
if L then
	L.tornado_trigger = "¡Estos cielos son MÍOS!"
	L.claw_message = "%2$dx Garra en %1$s"
	L.fullpower_soon_message = "¡Poder máximo inminente!"
	L.halfpower_soon_message = "¡Fase 4 inminente!"
	L.encounter_restart = "¡Poder máximo! Aquí vamos otra vez ..."
	L.no_stacks_message = "No sé si te importa, pero no tienes plumas"
	L.moonkin_message = "Deja de fingir y consigue algunas plumas reales"

	L.worm_emote = "¡Gusanos de lava ígneos surgen del suelo!"
	L.phase2_soon_emote = "Alysrazor empieza a volar rápido en círculos."
	L.phase2_emote = "99794" -- Fiery Vortex spell ID used in the emote
	L.phase3_emote = "99432" -- Burns Out spell ID used in the emote
	L.phase4_emote = "99922" -- Re-Ignites spell ID used in the emote
	L.restart_emote = "99925" -- Full Power spell ID used in the emote
end

L = BigWigs:NewBossLocale("Shannox", "esES")
if L then
	L.safe = "%s a salvo"
	L.immolation_trap = "¡Inmolación en %s!"
	L.crystaltrap = "Prisión de cristal"
end

L = BigWigs:NewBossLocale("Baleroc", "esES")
if L then
	L.torment_message = "%2$dx Tormento en %1$s"
	L.blade = "~Hoja"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "esES")
if L then
	L.seed_explosion = "¡Semilla explota pronto!"
end

L = BigWigs:NewBossLocale("Ragnaros", "esES")
if L then
	L.seed_explosion = "¡Explosión de semillas!"
	L.intermission = "Intermision"
	L.sons_left = "%d hijos restantes"
	L.engulfing_close = "%s cerca"
	L.engulfing_middle = "%s en el medio"
	L.engulfing_far = "%s lejos"
end

