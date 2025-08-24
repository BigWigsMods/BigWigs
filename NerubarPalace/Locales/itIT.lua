local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "itIT")
if not L then return end
if L then
	L.carnivorous_contest_pull = "Trascinato Dentro"
	L.chunky_viscera_message = "Porta da mangiare al Boss! (Pulsante di Azione Speciale)"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "itIT")
if L then
	L.gruesome_disgorge_debuff = "Cambio Fase"
	L.grasp_from_beyond = "Tentacoli"
	L.grasp_from_beyond_say = "Tentacoli"
	L.bloodcurdle = "Spargersi"
	L.bloodcurdle_on_you = "Spread" -- Singular of Spread
	L.goresplatter = "Corri via"
end

L = BigWigs:NewBossLocale("Rasha'nan", "itIT")
if L then
	L.spinnerets_strands = "Fili"
	L.enveloping_webs = "Ragnatele"
	L.enveloping_web_say = "Ragnatela" -- Singular of Webs
	L.erosive_spray = "Spruzzo"
	L.caustic_hail = "Prossima Posizione"
end

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "itIT")
if L then
	L.sticky_web = "Ragnatele Appiccicose"
	L.sticky_web_say = "Ragnatela" -- Singular of Webs
	L.infest_message = "Cast Infestazione su di TE!"
	L.infest_say = "Parassiti"
	L.experimental_dosage = "Rottura Uova"
	L.experimental_dosage_say = "Rottura Uovo"
	L.ingest_black_blood = "Prossimo Contenitore"
	L.unstable_infusion = "Cerchi"

	L.custom_on_experimental_dosage_marks = "Assegnamento Dose Sperimentale"
	L.custom_on_experimental_dosage_marks_desc = "Assegna giocatori con 'Dose Sperimentale' a {rt6}{rt4}{rt3}{rt7} con una priorità mischia > ranged > curatori. Impatta messagio Bersaglio e Say"

	--L.volatile_concoction_explosion_desc = "Show a target bar for the Volatile Concoction debuff."
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "itIT")
if L then
	L.assasination = "Fantasmi"
	L.twiligt_massacre = "Scatti"
	L.nexus_daggers = "Pugnali"
end

L = BigWigs:NewBossLocale("The Silken Court", "itIT")
if L then
	L.skipped_cast = "Saltato %s (%d)"
	L.intermission_trigger = "Ascensione nel Vuoto!" -- Skeinspinner Takazj 100 energy yell

	L.venomous_rain = "Pioggia"
	L.burrowed_eruption = "Rintanato"
	L.stinging_swarm = "Dissolvi penalità"
	L.strands_of_reality = "Frontale [S]" -- S for Skeinspinner Takazj
	L.strands_of_reality_message = "Frontale [Skeinspinner Takazj]"
	L.impaling_eruption = "Frontale [A]" -- A for Anub'arash
	L.impaling_eruption_message = "Frontale [Anub'arash]"
	L.entropic_desolation = "Corri fuori"
	L.cataclysmic_entropy = "Esplosione grossa" -- Interrupt before it casts
	L.spike_eruption = "Spuntoni"
	L.unleashed_swarm = "Sciame"
	L.void_degeneration = "Sfera Blu"
	L.burning_rage = "Sfera Rossa"
end

L = BigWigs:NewBossLocale("Queen Ansurek", "itIT")
if L then
	L.stacks_onboss = "%dx %s sul BOSS"

	L.reactive_toxin = "Tossine"
	L.reactive_toxin_say = "Tossina"
	L.venom_nova = "Nova"
	L.web_blades = "Lame"
	L.silken_tomb = "Immobilizza" -- Raid being rooted in place
	L.wrest = "Trascina dentro"
	L.royal_condemnation = "Catene"
	L.frothing_gluttony = "Anello"

	L.stage_two_end_message_storymode = "Corri dentro il portale"
end
