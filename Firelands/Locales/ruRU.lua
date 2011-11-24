local L = BigWigs:NewBossLocale("Beth'tilac", "ruRU")
if not L then return end
if L then
	L.flare = GetSpellInfo(100936)
	L.flare_desc = "Show a timer bar for AoE flare."
	L.devastate_message = "Разрушение #%d"
	L.drone_bar = "дрон"
	L.drone_message = "Появился дрон!"
	L.kiss_message = "Поцелуй"
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

	L.phase2_warning = "Скоро 2 фаза!"

	L.molten_message = "Стаков на боссе: %d!"

	L.stomp_message = "Огненная поступь!"
	L.stomp = "поступь"
end

L = BigWigs:NewBossLocale("Alysrazor", "ruRU")
if L then
	L.claw_message = "%2$dx Claw on %1$s"--need check
	L.fullpower_soon_message = "У Алисразор почти 100 энергии!"
	L.halfpower_soon_message = "Скоро 4 фаза!"
	L.encounter_restart = "Начинаем заново..."
	L.no_stacks_message = "У тебя нет ни 1 пера, дружище"
	L.moonkin_message = "У пингвинов тоже есть крылья...собери три пера и лети!"
	L.molt_bar = "След. линька"

	L.meteor = "Meteor"
	L.meteor_desc = "Warn when a Molten Meteor is summoned."
	L.meteor_message = "Meteor!"

	L.stage_message = "Фаза %d"
	L.kill_message = "It's now or never - Kill her!"
	L.engage_message = "Alysrazor engaged - Stage 2 in ~%d min"

	L.worm_emote = "На поверхность вылезают огненные лавовые паразиты!"
	L.phase2_soon_emote = "Алисразор начинает летать по кругу!"

	L.flight = "Помощник летчика"
	L.flight_desc = "Отсчитывать время действия бафа 'Огненные крылья'. Советую использовать вместе с функцией 'Супер увеличение'."

	L.initiate = "Initiate Spawn"
	L.initiate_desc = "Show timer bars for initiate spawns."
	L.initiate_both = "Both Initiates"
	L.initiate_west = "West Initiate"
	L.initiate_east = "East Initiate"
end

L = BigWigs:NewBossLocale("Shannox", "ruRU")
if L then
	L.safe = "%s в безопасности"
	L.wary_dog = "%s is Wary!"
	L.crystal_trap = "Кристаллическая ловушка"

	L.traps_header = "Ловушки"
	L.immolation = "Обжигающая ловушка"
	L.immolation_desc = "Объявлять, когда Лютогрыз или Косоморд попадают в обжигающую ловушку."
	L.immolationyou = "Immolation Trap under You"
	L.immolationyou_desc = "Alert when an Immolation Trap is summoned under you."
	L.immolationyou_message = "Immolation Trap"
	L.crystal = "Кристаллическая ловушка"
	L.crystal_desc = "Объявлять, когда Шэннокс бросает кристаллическую ловушку."
end

L = BigWigs:NewBossLocale("Baleroc", "ruRU")
if L then
	L.torment = "Стаки 'мучения' на фокусе"
	L.torment_desc = "Объявлять, когда ваш /фокус получает стаки мучения."

	L.blade_bar = "~След. лезвие"
	L.shard_message = "Кристаллы (%d)!"
	L.focus_message = "У вашего фокуса %d стаков!"
	L.link_message = "Связан"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "ruRU")
if L then
	L.seed_explosion = "Скоро взрыв!"
	L.seed_bar = "Взрыв!"
	L.adrenaline_message = "Адреналин x%d!"
	L.leap_say = "Leap on ME!"
end

L = BigWigs:NewBossLocale("Ragnaros", "ruRU")
if L then
	L.intermission_end_trigger1 = "Сульфурас уничтожит вас"
	L.intermission_end_trigger2 = "На колени, смертные"
	L.intermission_end_trigger3 = "Пора покончить с этим"
	L.phase4_trigger = "Слишком рано"
	L.seed_explosion = "Взрыв семян!"
	L.intermission_bar = "Переходная фаза!"
	L.intermission_message = "Переходная фаза"
	L.sons_left = "Осталось адов: %d"
	L.engulfing_close = "Пламя в мили!"
	L.engulfing_middle = "Пламя по центру!"
	L.engulfing_far = "Пламя с краю!"
	L.hand_bar = "отбрасывание"
	L.ragnaros_back_message = "Рагнарос вернулся!" -- yeah thats right PARRY ON!

	L.wound = "Burning Wound"
	L.wound_desc = "Tank alert only. Count the stacks of burning wound and show a duration bar."
	L.wound_message = "%2$dx Wound on %1$s"
end

