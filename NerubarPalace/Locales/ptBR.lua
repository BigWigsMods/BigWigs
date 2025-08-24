local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "ptBR")
if not L then return end
if L then
	L.carnivorous_contest_pull = "Arrastar para Perto"
	L.chunky_viscera_message = "Alimente o Chefe! (Botão para Ação Especial)"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "ptBR")
if L then
	L.gruesome_disgorge_debuff = "Troca de Fase"
	L.grasp_from_beyond = "Tentáculos"
	L.grasp_from_beyond_say = "Tentáculos"
	L.bloodcurdle = "Espalhamento"
	L.bloodcurdle_on_you = "Espalhar" -- Singular of Spread
	L.goresplatter = "Corra para Longe"
end

L = BigWigs:NewBossLocale("Rasha'nan", "ptBR")
if L then
	L.spinnerets_strands = "Fios"
	L.enveloping_webs = "Teias"
	L.enveloping_web_say = "Teia" -- Singular of Webs
	L.erosive_spray = "Pulverizar"
	L.caustic_hail = "Próxima Posição"
end

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "ptBR")
if L then
	L.sticky_web = "Teias"
	L.sticky_web_say = "Teia" -- Singular of Webs
	L.infest_message = "Lançando Infestação em VOCÊ!"
	L.infest_say = "Parasitas"
	L.experimental_dosage = "Quebrar os Ovos"
	L.experimental_dosage_say = "Quebrar os Ovo"
	L.ingest_black_blood = "Próximo Contêiner"
	L.unstable_infusion = "Redemoinhos"

	L.custom_on_experimental_dosage_marks = "Atribuição de Dosagem Experimental"
	L.custom_on_experimental_dosage_marks_desc = "Atribuir jogadores afetados por 'Dosagem Experimental' para {rt6}{rt4}{rt3}{rt7} com o melee > ranged > healer prioritariamente. Afeta Falas e mensagens de Alvos."

	--L.volatile_concoction_explosion_desc = "Show a target bar for the Volatile Concoction debuff."
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "ptBR")
if L then
	L.assasination = "Fantasmas"
	L.twiligt_massacre = "Traços"
	L.nexus_daggers = "Adagas"
end

L = BigWigs:NewBossLocale("The Silken Court", "ptBR")
if L then
	L.skipped_cast = "Pulou %s (%d)"
	L.intermission_trigger = "Ápice do poder!" -- Skeinspinner Takazj 100 energy yell

	L.venomous_rain = "Chuva"
	L.burrowed_eruption = "Escavação"
	L.stinging_swarm = "Dissipar Debuffs"
	L.strands_of_reality = "Frontal [S]" -- S for Skeinspinner Takazj
	L.strands_of_reality_message = "Frontal [Skeinspinner Takazj]"
	L.impaling_eruption = "Frontal [A]" -- A for Anub'arash
	L.impaling_eruption_message = "Frontal [Anub'arash]"
	L.entropic_desolation = "Fugir"
	L.cataclysmic_entropy = "Grande Explosão" -- Interrupt before it casts
	L.spike_eruption = "Espinhos"
	L.unleashed_swarm = "Enxame"
	L.void_degeneration = "Esfera Azul"
	L.burning_rage = "Esfera Vermelha"
end

L = BigWigs:NewBossLocale("Queen Ansurek", "ptBR")
if L then
	L.stacks_onboss = "%dx %s no CHEFE"

	L.reactive_toxin = "Toxinas"
	L.reactive_toxin_say = "Toxina"
	L.venom_nova = "Nova"
	L.web_blades = "Lâminas"
	L.silken_tomb = "Enraizar" -- Raid being rooted in place
	L.wrest = "Arrastar para Perto"
	L.royal_condemnation = "Algemas"
	L.frothing_gluttony = "Anel"

	L.stage_two_end_message_storymode = "Corra para dentro do portal"
end
