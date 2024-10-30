local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "esES")
if not L then return end
if L then
	L.carnivorous_contest_pull = "Atraer"
	L.chunky_viscera_message = "¡Aliméntalo! (Special Action Button)"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "esES")
if L then
	L.gruesome_disgorge_debuff = "Cambio de dimensión"
	L.grasp_from_beyond = "Tentáculos"
	L.grasp_from_beyond_say = "Tentáculos"
	L.bloodcurdle = "Propagación"
	L.bloodcurdle_on_you = "Sepárate" -- Singular of Spread
	L.goresplatter = "Huye"
end

L = BigWigs:NewBossLocale("Rasha'nan", "esES")
if L then
	L.spinnerets_strands = "Ataduras"
	L.enveloping_webs = "Telarañas"
	L.enveloping_web_say = "Telaraña" -- Singular of Webs
	L.erosive_spray = "Escupir"
	L.caustic_hail = "Siguiente posición"
end

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "esES")
if L then
	L.sticky_web = "Telarañas"
	L.sticky_web_say = "Telaraña" -- Singular of Webs
	L.infest_message = "¡Lanzando Infestar en ti!"
	L.infest_say = "Parásitos"
	L.experimental_dosage = "Huevo abriéndose"
	L.experimental_dosage_say = "Apertura de huevo"
	L.ingest_black_blood = "Siguiente bote"
	L.unstable_infusion = "Remolinos"

	L.custom_on_experimental_dosage_marks = "Asignaciones de Dosis experimentales"
	L.custom_on_experimental_dosage_marks_desc = "Asigna a las personas afectadas por Dosis experimental a {rt6}{rt4}{rt3}{rt7} con prioridad: melee > ranged > healer. Afecta a los mensajes enviados."

	--L.volatile_concoction_explosion_desc = "Show a target bar for the Volatile Concoction debuff."
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "esES")
if L then
	L.assasination = "Fantasmas"
	L.twiligt_massacre = "Arremetidas"
	L.nexus_daggers = "Dagas"
end

L = BigWigs:NewBossLocale("The Silken Court", "esES")
if L then
	L.skipped_cast = "Omitido %s (%d)"
	L.intermission_trigger = "¡Límite de poder!" -- Skeinspinner Takazj 100 energy yell

	L.venomous_rain = "Lluvia"
	L.burrowed_eruption = "Erupción"
	L.stinging_swarm = "Disipa Debuffs"
	L.strands_of_reality = "Frontal [T]" -- S for Skeinspinner Takazj
	L.strands_of_reality_message = "Frontal [Takazj Giramadeja]"
	L.impaling_eruption = "Frontal [A]" -- A for Anub'arash
	L.impaling_eruption_message = "Frontal [Anub'arash]"
	L.entropic_desolation = "Escapa"
	L.cataclysmic_entropy = "Estallido" -- Interrupt before it casts
	L.spike_eruption = "Púas"
	L.unleashed_swarm = "Enjambre"
	L.void_degeneration = "Orbe azul"
	L.burning_rage = "Orbe rojo"
end

L = BigWigs:NewBossLocale("Queen Ansurek", "esES")
if L then
	L.stacks_onboss = "%dx %s on BOSS"

	L.reactive_toxin = "Toxinas"
	L.reactive_toxin_say = "Toxina"
	L.venom_nova = "Nova"
	L.web_blades = "Hojas"
	L.silken_tomb = "Enraizar" -- Raid being rooted in place
	L.wrest = "Atraer"
	L.royal_condemnation = "Cadenas"
	L.frothing_gluttony = "Anillo"

	L.stage_two_end_message_storymode = "Corre hacia el portal"
end
