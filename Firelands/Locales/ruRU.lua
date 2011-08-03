local L = BigWigs:NewBossLocale("Beth'tilac", "ruRU")
if not L then return end
if L then
	L.devastate_message = "Разрушение #%d!"
	L.devastate_bar = "~След. разрушение"
	L.drone_bar = "След. дрон"
	L.drone_message = "Появился дрон!"
	L.kiss_message = "Поцелуй"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "ruRU")
if L then
	L.armor = "Обсидиановые доспехи"
	L.armor_desc = "Предупрежать, когда с босса спадают стаки доспехов."
	L.armor_icon = 98632
	L.armor_message = "Осталось брони: %d%%"
	L.armor_gone_message = "Брони больше нет!"

	L.adds_header = "Помощники"
	L.big_add_message = "Появилась искра!"
	L.small_adds_message = "Появились фрагменты!"

	L.phase2_warning = "Скоро 2 фаза!"

	L.molten_message = "Стаков на боссе: %d!"

	L.stomp_message = "Огненная поступь!"
	L.stomp_warning = "След. поступь"
end

L = BigWigs:NewBossLocale("Alysrazor", "ruRU")
if L then
	L.tornado_trigger = "Небо над вами принадлежит МНЕ!"
	L.claw_message = "%2$dx Claw on %1$s"--need check
	L.fullpower_soon_message = "У Алисразор почти 100 энергии!"
	L.halfpower_soon_message = "Скоро 4 фаза!"
	L.encounter_restart = "Начинаем заново..."
	L.no_stacks_message = "У тебя нет ни 1 пера, дружище"
	L.moonkin_message = "У пингвинов тоже есть крылья...собери три пера и лети!"
	L.molt_bar = "След. линька"

	L.stage_message = "Фаза %d"

	L.worm_emote = "На поверхность вылезают огненные лавовые паразиты!"
	L.phase2_soon_emote = "Алисразор начинает летать по кругу!"
	L.phase2_emote = "99794" -- Fiery Vortex spell ID used in the emote
	L.phase3_emote = "99432" -- Burns Out spell ID used in the emote
	L.phase4_emote = "99922" -- Re-Ignites spell ID used in the emote
	L.restart_emote = "99925" -- Full Power spell ID used in the emote

	L.flight = "Помощник летчика"
	L.flight_desc = "Отсчитывать время действия бафа 'Огненные крылья'. Советую использовать вместе с функцией 'Супер увеличение'."
	L.flight_icon = 98619
end

L = BigWigs:NewBossLocale("Shannox", "ruRU")
if L then
	L.safe = "%s в безопасности"
	L.immolation_trap = "Обжигающая ловушка на %s!"
	L.crystal_trap = "Кристаллическая ловушка"

	L.traps_header = "Ловушки"
	L.immolation = "Обжигающая ловушка"
	L.immolation_desc = "Объявлять, когда Лютогрыз или Косоморд попадают в обжигающую ловушку."
	L.immolation_icon = 99838
	L.crystal = "Кристаллическая ловушка"
	L.crystal_desc = "Объявлять, когда Шэннокс бросает кристаллическую ловушку."
	L.crystal_icon = 99836
end

L = BigWigs:NewBossLocale("Baleroc", "ruRU")
if L then
	L.torment = "Стаки 'мучения' на фокусе"
	L.torment_desc = "Объявлять, когда ваш /фокус получает стаки мучения."
	L.torment_icon = 99256
	-- L.torment_message = "%2$dx torment on %1$s"

	L.blade_bar = "~След. лезвие"
	L.shard_message = "Кристаллы (%d)!"
	L.focus_message = "У вашего фокуса %d стаков!"
	L.countdown_bar = "След. линк"
	L.link_message = "Связан"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "ruRU")
if L then
	L.seed_explosion = "Скоро взрыв!"
	L.seed_bar = "Взрыв!"
	L.adrenaline_message = "Адреналин x%d!"	
end

L = BigWigs:NewBossLocale("Ragnaros", "ruRU")
if L then
	L.intermission_end_trigger1 = "Сульфурас уничтожит вас!"
	L.intermission_end_trigger2 = "На колени, смертные!"
	L.intermission_end_trigger3 = "Пора покончить с этим."
	L.phase4_trigger = "Слишком рано..."
	L.seed_explosion = "Взрыв семян!"
	L.intermission_bar = "Переходная фаза!"
	L.intermission_message = "Переходная фаза"
	L.sons_left = "Осталось адов: %d"
	L.engulfing_close = "Пламя в мили!"
	L.engulfing_middle = "Пламя по центру!"
	L.engulfing_far = "Пламя с краю!"
	L.hand_bar = "След. отбрасывание"
	L.wound_bar = "Рана на %s"
	L.ragnaros_back_message = "Рагнарос вернулся!" -- yeah thats right PARRY ON!
end

