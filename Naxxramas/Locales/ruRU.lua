local L = BigWigs:NewBossLocale("Anub'Rekhan", "ruRU")
if not L then return end
if L then
	L.bossName = "Ануб'Рекан"

	L.gainwarn10sec = "~10 до жуков-трупоедов"
	L.gainincbar = "Следующая волна жуков-трупоедов"
end

L = BigWigs:NewBossLocale("Grand Widow Faerlina", "ruRU")
if L then
	L.bossName = "Великая вдова Фарлина"

	L.silencewarn = "Безмолвие! Задержка ярости!"
	L.silencewarn5sec = "Безмолвие закончится через 5 секунд"
end

L = BigWigs:NewBossLocale("Gluth", "ruRU")
if L then
	L.bossName = "Глут"

	L.startwarn = "Глут вступает в бой! ~105 cекунд до появления зомби!"

	L.decimatesoonwarn = "Скоро истребление!"
	L.decimatebartext = "~Истребление зомби"
end

L = BigWigs:NewBossLocale("Gothik the Harvester", "ruRU")
if L then
	L.bossName = "Готик Жнец"

	L.room = "Прибытие Готика"
	L.room_desc = "Сообщать о прибытии Готика"

	L.add = "Появление помощников"
	L.add_desc = "Сообщать о появлении помощников"

	L.adddeath = "Оповещать смерть помощников"
	L.adddeath_desc = "Сообщать о смерти помощников."

	L.starttrigger1 = "Глупо было искать свою смерть."
	L.starttrigger2 = "Я очень долго ждал. Положите свою душу в мой комбайн и будем вам дерево с золотыми монетами." -- check this
	L.startwarn = "Готик вступает в бой! 4:30 до входа в комнату."

	L.rider = "Неодолимый всадник"
	L.spectral_rider = "Призрачный всадник"
	L.deathknight = "Безжалостный Рыцарь Смерти"
	L.spectral_deathknight = "Призрачный рыцарь Смерти"
	L.trainee = "Жестокий новобранец"
	L.spectral_trainee = "Призрачный ученик"

	L.riderdiewarn = "Всадник мёртв!"
	L.dkdiewarn = "Рыцарь смерти мёртв!"

	L.warn1 = "В комнате через 3 минуты"
	L.warn2 = "В комнате через 90 секунд"
	L.warn3 = "В комнате через 60 секунд"
	L.warn4 = "В комнате через 30 секунд"
	L.warn5 = "Готик появится через 10 секунд"

	L.wave = "%d/23: %s"

	L.trawarn = "Ученик через 3 секунды"
	L.dkwarn = "Рыцарь Смерти через 3 секунды"
	L.riderwarn = "Всадник через 3 секунды"

	L.trabar = "Ученик - %d"
	L.dkbar = "Рыцарь Смерти - %d"
	L.riderbar = "Всадник - %d"

	L.inroomtrigger = "Я ждал слишком долго. Сейчас вы предстанете пред ликом Жнеца душ."
	L.inroomwarn = "Он в комнате!!"

	L.inroombartext = "В комнате"
end

L = BigWigs:NewBossLocale("Grobbulus", "ruRU")
if L then
	L.bossName = "Гроббулус"

	L.bomb_message = "Укол"
	L.bomb_message_other = "|3-2(%s) сделали укол!"
end

L = BigWigs:NewBossLocale("Heigan the Unclean", "ruRU")
if L then
	L.bossName = "Хейган Нечестивый"

	L.starttrigger = "Теперь вы принадлежите мне!"
	L.starttrigger2 = "Пришло ваше время..."
	L.starttrigger3 = "Я вижу вас..."

	L.engage = "Вступление в бой"
	L.engage_desc = "Предупреждать когда Хейган вступает в бой."
	L.engage_message = "Хейган вступает в бой! 90 секунд до телепорта!"

	L.teleport = "Телепорт"
	L.teleport_desc = "Предупреждать о телепорте."
	L.teleport_trigger = "Вам конец."
	L.teleport_1min_message = "Телепорт через 1 минуту"
	L.teleport_30sec_message = "Телепорт через 30 секунд"
	L.teleport_10sec_message = "Телепорт через 10 секунд!"
	L.on_platform_message = "Телепорт! 45 секунд на платформе!"

	L.to_floor_30sec_message = "Возвращение через 30 секунд"
	L.to_floor_10sec_message = "Возвращение через 10 секунд!"
	L.on_floor_message = "Возвращается! 90 секунд до следующего телепорта!"

	L.teleport_bar = "Телепорт!"
	L.back_bar = "Возвращение!"
end

L = BigWigs:NewBossLocale("The Four Horsemen", "ruRU")
if L then
	L.bossName = "Четыре всадника"

	L.mark = "Знак"
	L.mark_desc = "Предупреждать о знаках."

	L.markbar = "Знак %d"
	L.markwarn1 = "Знак %d!"
	L.markwarn2 = "Знак %d через 5 секунд"

	L.startwarn = "Четверо всадников вступили в бой! Знак через ~17 секунд"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "ruRU")
if L then
	L.bossName = "Кел'Тузад"

	L.KELTHUZADCHAMBERLOCALIZEDLOLHAX = "Зал Кел'Тузада"

	L.start_trigger = "Соратники слуги солдаты холодной тьмы! Повинуйтесь зову Кел'Тузада!"
	L.start_warning = "Бой с Кел'Тузадом начинается! ~3 мин 30 сек до выхода босса!"
	L.start_bar = "Фаза 2"

	L.phase = "Фазы"
	L.phase_desc = "Предупреждать когда босс входит в новую фазу."
	L.phase2_trigger1 = "Молите о пощаде!"
	L.phase2_trigger2 = "Кричите! Кричите изо всех сил!"
	L.phase2_trigger3 = "Вы уже мертвы!"
	L.phase2_warning = "Фаза 2 Кел'Тузад просыпается!"
	L.phase2_bar = "Кел'Тузад активен!"
	L.phase3_soon_warning = "Скоро Фаза 3!"
	L.phase3_trigger = "Господин мне нужна помощь!"
	L.phase3_warning = "Фаза 3 защитники через ~15 секунд!"

	L.mc_message = "Контроль над |3-4(%s)"
	L.mc_warning = "Скоро контроль разума!"
	L.mc_nextbar = "~Контроль Разума"

	L.frostblast_bar = "Возможен ледяной взрыв"
	L.frostblast_soon_message = "Возможный ледяной взрыв через 15 секунд!"

	L.detonate_other = "Взрыв маны на 3-5(%s)"
	L.detonate_possible_bar = "Возможен взрыв маны"
	L.detonate_warning = "Следующий взрыв маны через 5 секунд!"

	L.guardians = "Появление стражей"
	L.guardians_desc = "Сообщать о появлении стражей ледяной короны в третьей фазе."
	L.guardians_trigger = "Хорошо. Воины ледяных пустошей восстаньте! Повелеваю вам сражаться убивать и умирать во имя своего повелителя! Не щадить никого!"
	L.guardians_warning = "Стражи появятся через 15 секунд!"
	L.guardians_bar = "Появляются стражи!"
end

L = BigWigs:NewBossLocale("Loatheb", "ruRU")
if L then
	L.bossName = "Лотхиб"

	L.startwarn = "Лотхиб вступает в бой, 2 минуты до неотвратимого рока!"

	L.aura_message = "Мертвенная аура - продолжительность 17 сек!"
	L.aura_warning = "Мертвенная аура спадает через 3 сек!"

	L.deathbloom_warning = "Бутон смерти через 5 сек!"

	L.doombar = "Неотвратимый рок %d"
	L.doomwarn = "Неотвратимый рок %d! %d секунд до следующего!"
	L.doomwarn5sec = "Неотвратимый рок %d через 5 секунд!"
	L.doomtimerbar = "Рок каждые 15 секунд"
	L.doomtimerwarn = "Рок теперь каждые %s секунд!"
	L.doomtimerwarnnow = "Рок теперь накладывается каждые 15 секунд!"

	L.sporewarn = "Появляется %d спора"
	L.sporebar = "Призвана спора %d"
end

L = BigWigs:NewBossLocale("Noth the Plaguebringer", "ruRU")
if L then
	L.bossName = "Нот Чумной"

	L.starttrigger1 = "Смерть чужакам!"
	L.starttrigger2 = "Слава господину!"
	L.starttrigger3 = "Прощайся с жизнью!"
	L.startwarn = "Нот Чумной вступает в бой! 90 секунд до телепорта"

	L.blink = "Опасность скачка"
	L.blink_desc = "Предупреждать когда Нот использует скачок"
	L.blinktrigger = "%s перескакивает на другое место!"
	L.blinkwarn = "Скачок!"
	L.blinkwarn2 = "Скачок через 5 секунд!"
	L.blinkbar = "Скачок"

	L.teleport = "Телепорт"
	L.teleport_desc = "Предупреждать о телепорте."
	L.teleportbar = "Телепорт!"
	L.backbar = "Назад в Команту!"
	L.teleportwarn = "Телепорт! Он на балконе!"
	L.teleportwarn2 = "Телепорт через 10 секунд!"
	L.backwarn = "Он вернулся в комнату на %d секунд!"
	L.backwarn2 = "10 секунд до возвращения в комнату!"

	L.curseexplosion = "Проклятый взрыв!"
	L.cursewarn = "Проклятие через ~55 секунд"
	L.curse10secwarn = "Проклятие через ~10 секунд"
	L.cursebar = "Следующее проклятие"

	L.wave = "Волны"
	L.wave_desc = "Сообщать о волнах"
	L.addtrigger = "Встаньте мои воины! Встаньте и сражайтесь вновь!"
	L.wave1bar = "1-я волна"
	L.wave2bar = "2-я волна"
	L.wave2_message = "2-я волна через 10 сек"
end

L = BigWigs:NewBossLocale("Patchwerk", "ruRU")
if L then
	L.bossName = "Лоскутик"

	L.enragewarn = "5% - Бешенство!"
	L.starttrigger1 = "Лоскутик хочет поиграть!"
	L.starttrigger2 = "Кел'Тузад объявил Лоскутика воплощением войны!"
end

L = BigWigs:NewBossLocale("Maexxna", "ruRU")
if L then
	L.bossName = "Мексна"

	L.webspraywarn30sec = "Паутина через 10 секунд"
	L.webspraywarn20sec = "Паутина! 10 секунд до появления пауков!"
	L.webspraywarn10sec = "Пауки! 10 секунд до паутины!"
	L.webspraywarn5sec = "Паутина через 5 секунд!"
	L.enragewarn = "Бешенство - ХЛЮП ХЛЮП ХЛЮП!"
	L.enragesoonwarn = "Скоро бешенство"

	L.cocoonbar = "Коконы"
	L.spiderbar = "Пауки"
end

L = BigWigs:NewBossLocale("Sapphiron", "ruRU")
if L then
	L.bossName = "Сапфирон"

	L.airphase_trigger = "%s взмывает в воздух!"
	L.deepbreath_incoming_message = "Ледяная бомба через 23 секунды!"
	L.deepbreath_incoming_soon_message = "Ледяная бомба через 5 секунд!"
	L.deepbreath_incoming_bar = "Каст ледяной бомбы"
	L.deepbreath_trigger = "%s глубоко вздыхает."
	L.deepbreath_warning = "Появляется ледяная бомба!"
	L.deepbreath_bar = "Приземляется ледяная бомба!"

	L.lifedrain_message = "Похищение жизни! Следующее через 24 секунды!"
	L.lifedrain_warn1 = "Похищение жизни через 5 секунд!"
	L.lifedrain_bar = "~Возможное похищение жизни"

	L.icebolt_say = "Я в глыбе!"

	L.ping_message = "Глыба - отмечаю положение!"
end

L = BigWigs:NewBossLocale("Instructor Razuvious", "ruRU")
if L then
	L.bossName = "Инструктор Разувий"
	L.understudy = "Ученик рыцаря смерти"

	L.taunt_warning = "Провокация закончится через 5сек!"
	L.shieldwall_warning = "Преграда из костей закончится через 5сек!"
end

L = BigWigs:NewBossLocale("Thaddius", "ruRU")
if L then
	L.bossName = "Таддиус"

	L.phase = "Фазы"
	L.phase_desc = "Сообщать о фазах боя"

	L.throw = "Бросока"
	L.throw_desc = "Предупреждать о смене танков на платформах."

	L.trigger_phase1_1 = "Сталагг сокрушить вас!"
	L.trigger_phase1_2 = "Я скормлю вас господину!"
	L.trigger_phase2_1 = "Я сожру... ваши... кости..."
	L.trigger_phase2_2 = "Растерзаю!!!"
	L.trigger_phase2_3 = "Убью..."

	L.polarity_trigger = "Познайте же боль..."
	L.polarity_message = "Таддиус сдвигает полярность!"
	L.polarity_warning = "3 секунды до сдвига полярности!"
	L.polarity_bar = "Сдвиг полярности"
	L.polarity_changed = "Полярность сменилась!"
	L.polarity_nochange = "Полярность НЕ сменилась!"

	L.polarity_first_positive = "Вы (+) ПОЛОЖИТЕЛЬНЫЙ!"
	L.polarity_first_negative = "Вы (-) ОТРИЦАТЕЛЬНЫЙ!"

	L.phase1_message = "Таддиус фаза 1"
	L.phase2_message = "Таддиус фаза 2 Берсерк через 6 минут!"

	L.surge_message = "Волна силы на Сталагге!"

	L.throw_bar = "Бросок"
	L.throw_warning = "Бросок через 5 секунд!"
end
