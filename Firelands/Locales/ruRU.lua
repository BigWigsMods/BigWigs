local L = BigWigs:NewBossLocale("Beth'tilac", "ruRU")
if not L then return end
if L then
	L.flare_desc = "Показать таймер для АоЕ."

	L.devastate_message = "Разрушение #%d"
	L.drone_bar = "Трутень"
	L.drone_message = "Появился Трутень!"
	L.kiss_message = "Поцелуй"
	L.spinner_warn = "Ткачи #%d"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "ruRU")
if L then
	L.armor = "Обсидиановые доспехи"
	L.armor_desc = "Предупрежать, когда с босса спадают стаки доспехов."
	L.armor_message = "Осталось брони: %d%%"
	L.armor_gone_message = "Брони больше нет!"

	L.adds_header = "Помощники"
	L.big_add_message = "Появилась искра!"
	L.small_adds_message = "Появились фрагменты!"

	L.phase2_warning = "Скоро 2-я фаза!"

	L.molten_message = "Обсидиановые доспехи: %d!"

	L.stomp_message = "Поступь! Поступь! Поступь!"
	L.stomp = "Поступь"
end

L = BigWigs:NewBossLocale("Alysrazor", "ruRU")
if L then
	L.claw_message = "%2$dx Коготь на |3-5(%1$s)"
	L.fullpower_soon_message = "Скоро Полная мощь!"
	L.halfpower_soon_message = "Скоро 4-я фаза!"
	L.encounter_restart = "Начинаем заново..."
	L.no_stacks_message = "У тебя нет ни 1 пера, дружище"
	L.moonkin_message = "У пингвинов тоже есть крылья...собери три пера и лети!"
	L.molt_bar = "Линька"

	L.meteor = "Метеор"
	L.meteor_desc = "Предупреждать о призыве расплавенного метеора."
	L.meteor_message = "Метеор!"

	L.stage_message = "Фаза %d"
	L.kill_message = "Сейчас или никогда - Убей её!"
	L.engage_message = "Алисразор прилетает - Фаза 2 через ~%d мин"

	L.worm_emote = "На поверхность вылезают огненные лавовые паразиты!"
	L.phase2_soon_emote = "Алисразор начинает летать по кругу!"

	L.flight = "Помощник летчика"
	L.flight_desc = "Отсчитывать время действия эффекта 'Огненные крылья'. Отлично сочетается с функцией 'Супер увеличение'."

	L.initiate = "Появление Друида"
	L.initiate_desc = "Показывать таймер для появления друида."
	L.initiate_both = "Два Друида"
	L.initiate_west = "Друид на Западе"
	L.initiate_east = "Друид на Востоке"
end

L = BigWigs:NewBossLocale("Shannox", "ruRU")
if L then
	L.safe = "%s в безопасности"
	L.wary_dog = "Осторожность на %s!"
	L.crystal_trap = "Кристаллическая ловушка"

	L.traps_header = "Ловушки"
	L.immolation = "Обжигающая ловушка на собаке"
	L.immolation_desc = "Объявлять, когда Лютогрыз или Косоморд попадают в обжигающую ловушку, получая бафф 'Осторожности'."
	L.immolationyou = "Обжигающая ловушка под Тобой"
	L.immolationyou_desc = "Предупреждать, когда обжигающая ловушка появляется под вами."
	L.immolationyou_message = "Обжигающая ловушка"
	L.crystal = "Кристаллическая ловушка"
	L.crystal_desc = "Объявлять, когда Шэннокс бросает кристаллическую ловушку."
end

L = BigWigs:NewBossLocale("Baleroc", "ruRU")
if L then
	L.torment = "Стаки 'Мучения' на фокусе"
	L.torment_desc = "Объявлять, когда ваш /фокус получает стаки мучения."

	L.blade_bar = "~След. лезвие"
	L.shard_message = "Осколки (%d)!"
	L.focus_message = "У вашего фокуса %d стаков!"
	L.link_message = "Связан"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "ruRU")
if L then
	L.seed_explosion = "Скоро взрыв!"
	L.seed_bar = "Взрыв!"
	L.adrenaline_message = "Адреналин x%d!"
	L.leap_say = "Прыжок на МНЕ!"
end

L = BigWigs:NewBossLocale("Ragnaros", "ruRU")
if L then
	L.intermission_end_trigger1 = "Сульфурас уничтожит вас!"
	L.intermission_end_trigger2 = "На колени, смертные!"
	L.intermission_end_trigger3 = "Пора покончить с этим."
	L.phase4_trigger = "Слишком рано…"
	L.seed_explosion = "Взрыв семян!"
	L.intermission_bar = "Переходная фаза!"
	L.intermission_message = "Переходная фаза... Получил печеньки?"
	L.sons_left = "Осталось адов: %d"
	L.engulfing_close = "Пламя у босса!"
	L.engulfing_middle = "Пламя по центру!"
	L.engulfing_far = "Пламя с краю!"
	L.hand_bar = "Отбрасывание"
	L.ragnaros_back_message = "Рагнарос вернулся!"

	L.wound = "Жгучая рана"
	L.wound_desc = "Только для танков. Считает стаки жгучей раны и показывает их таймер."
	L.wound_message = "%2$dx Рана на |3-5(%1$s)"
end

