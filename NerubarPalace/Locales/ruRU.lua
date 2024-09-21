local L = BigWigs:NewBossLocale("Ulgrax the Devourer", "ruRU")
if not L then return end
if L then
	--L.carnivorous_contest_pull = "Pull In"
	L.chunky_viscera_message = "Корми Босса! (Дополнительное действие)"
end

L = BigWigs:NewBossLocale("The Bloodbound Horror", "ruRU")
if L then
	--L.gruesome_disgorge_debuff = "Phase Shift"
	L.grasp_from_beyond = "Щупальца"
	L.grasp_from_beyond_say = "Щупальца"
	L.bloodcurdle = "Спреды"
	L.bloodcurdle_on_you = "Спредай" -- Singular of Spread
	L.goresplatter = "Убегай"
end

L = BigWigs:NewBossLocale("Rasha'nan", "ruRU")
if L then
	L.spinnerets_strands = "Нити"
	L.enveloping_webs = "Паутины"
	L.enveloping_web_say = "Паутина" -- Singular of Webs
	L.erosive_spray = "Брызги"
	L.caustic_hail = "Следующая позиция"
end

L = BigWigs:NewBossLocale("Broodtwister Ovi'nax", "ruRU")
if L then
	L.sticky_web = "Паутины"
	L.sticky_web_say = "Паутина" -- Singular of Webs
	L.infest_message = "Заражение на ТЕБЕ!"
	L.infest_say = "Паразиты"
	L.experimental_dosage = "Яйца" -- best to keep concise
	L.experimental_dosage_say = "Яйца"
	L.ingest_black_blood = "Следующий контейнер"
	L.unstable_infusion = "Доджи"

	L.custom_on_experimental_dosage_marks = "Экспериментальная доза: метки"
	L.custom_on_experimental_dosage_marks_desc = "Отмечает игроков с эффектом 'Экспериментальная доза' метками {rt6}{rt4}{rt3}{rt7} с приоритетом милики > ренджи > хилы. Затрагивает сообщения /сказать и цели."
end

L = BigWigs:NewBossLocale("Nexus-Princess Ky'veza", "ruRU")
if L then
	L.assasination = "Фантомы"
	L.twiligt_massacre = "Рывки"
	L.nexus_daggers = "Кинжалы"
end

L = BigWigs:NewBossLocale("The Silken Court", "ruRU")
if L then
	L.skipped_cast = "Пропущено %s (%d)"

	L.venomous_rain = "Дождь"
	L.burrowed_eruption = "Рывок"
	L.stinging_swarm = "Дебаффы" -- to keep concise
	L.strands_of_reality = "Фронтал [Н]" -- S for Skeinspinner Takazj
	L.impaling_eruption = "Фронтал [А]" -- A for Anub'arash
	L.entropic_desolation = "Выбегай"
	L.cataclysmic_entropy = "Большой взрыв" -- Interrupt before it casts
	L.spike_eruption = "Шипы"
	L.unleashed_swarm = "Рой"
end

L = BigWigs:NewBossLocale("Queen Ansurek", "ruRU")
if L then
	--L.stacks_onboss = "%dx %s on BOSS"

	--L.reactive_toxin = "Toxins"
	--L.reactive_toxin_say = "Toxin"
	--L.venom_nova = "Nova"
	--L.web_blades = "Blades"
	--L.silken_tomb = "Roots" -- Raid being rooted in place
	--L.wrest = "Pull In"
	--L.slow = "Slow"
	--L.royal_condemnation = "Shackles"
	--L.frothing_gluttony = "Ring"

	--L.stage_two_end_message_storymode = "Run into the portal"
end
