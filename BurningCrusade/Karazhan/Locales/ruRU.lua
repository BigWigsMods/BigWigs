local L = BigWigs:NewBossLocale("Attumen the Huntsman Raid", "ruRU")
if not L then return end
if L then
	L.phase = "Фаза"
	L.phase_desc = "Предупреждать о смене фаз."
	L.phase2_trigger = "%s зовет своего господина!"
	L.phase2_message = "Фаза 2 - %s и Аттумен"
	L.phase3_trigger = "Давай, Полночь, разгоним этот сброд!"
	L.phase3_message = "Фаза 3"
end

L = BigWigs:NewBossLocale("The Curator Raid", "ruRU")
if L then
	L.engage_trigger = "Галерея только для гостей."

	L.weaken_message = "Прилив сил - Ослабление на 20сек!"
	L.weaken_fade_message = "Прилив сил закончился - Ослабление рассеялось!"
	L.weaken_fade_warning = "Прилив сил заканчивается через 5сек!"
end

L = BigWigs:NewBossLocale("Maiden of Virtue Raid", "ruRU")
if L then
	L.engage_trigger = "Ваше поведение нестерпимо."
	L.engage_message = "Контакт с Пресветлой девой! Покаяние за ~33сек"

	L.repentance_message = "Покаяние! Следующее через ~33сек"
	L.repentance_warning = "Покаяние перезарядилось - скоро будет!"
end

L = BigWigs:NewBossLocale("Prince Malchezaar", "ruRU")
if L then
	L.wipe_bar = "Возрождение"

	L.phase = "Контакт"
	L.phase_desc = "Сообщать о смене фаз."
	L.phase1_trigger = "Безумие привело вас сюда, ко мне. Я стану вашей погибелью!"
	L.phase2_trigger = "Простофили! Время – это пламя, в котором вы сгорите!"
	L.phase3_trigger = "Как ты можешь надеяться выстоять против такой ошеломляющей мощи?"
	L.phase1_message = "Фаза 1 - Инфернал через ~40сек!"
	L.phase2_message = "60% - Фаза 2"
	L.phase3_message = "30% - Фаза 3 "

	L.infernal = "Инферналы"
	L.infernal_desc = "Показывает таймеры призыва Инферналов."
	L.infernal_bar = "Появление Инфернала"
	L.infernal_warning = "Появление Инфернала через 20сек!"
	L.infernal_message = "Появление Инфернала! Адское Пламя через 5сек!"
	L.infernal_trigger1 = "но и всем подвластным мне легионам"
	L.infernal_trigger2 = "Безумие привело вас сюда"
end

L = BigWigs:NewBossLocale("Moroes Raid", "ruRU")
if L then
	L.engage_trigger = "Хмм, неожиданные посетители. Нужно подготовиться…"
	L.engage_message = "Контакт с %s - исчезновение за ~35 сек"
end

L = BigWigs:NewBossLocale("Netherspite", "ruRU")
if L then
	L.phase = "Фазы"
	L.phase_desc = "Предупреждать о изменении фаз Пустогнева."
	L.phase1_message = "Назад - Дыхания Хаоса закончилось"
	L.phase1_bar = "~возможен отвод"
	L.phase1_trigger = "%s издает крик, отступая, открывая путь Пустоте."
	L.phase2_message = "Ярость - скоро Дыхание Хаоса!"
	L.phase2_bar = "~возможная Ярость"
	L.phase2_trigger = "%s впадает в предельную ярость!"

	L.voidzone_warn = "Портал Бездны (%d)!"
end

L = BigWigs:NewBossLocale("Nightbane Raid", "ruRU")
if L then
	L.name = "Ночная Погибель"

	L.phase = "Фазы"
	L.phase_desc = "Предупреждает о переключениях фаз Ночной Погибели."
	L.airphase_trigger = "Жалкий гнус! Я изгоню тебя из воздуха!"
	L.landphase_trigger1 = "Довольно! Я сойду на землю и сам раздавлю тебя!"
	L.landphase_trigger2 = "Ничтожества! Я вам покажу мою силу поближе!"
	L.airphase_message = "Полет!"
	L.landphase_message = "Приземление!"
	L.summon_trigger = "Древнее существо пробуждается вдалеке…"

	L.engage_trigger = "Ну и глупцы! Я быстро покончу с вашими страданиями!"
end

L = BigWigs:NewBossLocale("Romulo & Julianne", "ruRU")
if L then
	L.name = "Ромуло и Джулианна"

	L.phase = "Фазы"
	L.phase_desc = "Предупреждать о начале новой фазы."
	L.phase1_trigger = "Что же за демон ты есмь, коий мучает меня так?"
	L.phase1_message = "Акт I - Джулианна"
	L.phase2_trigger = "Твоя меня дразнить – твоя получать, малявка!"
	L.phase2_message = "Акт II - Ромуло"
	L.phase3_trigger = "Ночь, добрая и строгая, приди! Верни мне моего Ромуло!"
	L.phase3_message = "Акт III - Вместе"

	L.poison = "Яд"
	L.poison_desc = "Предупреждать о отравлении игроков."
	L.poison_message = "Отравлен"

	L.heal = "Исцеление"
	L.heal_desc = "Предупреждать когда Джульенна применяет Вечную привязанность."
	L.heal_message = "Джулианна выполняет Исцеление!"

	L.buff = "Сигнал о баффах"
	L.buff_desc = "Предупреждать когда Ромуло и Джульенна наносят положительные заклинания на себя."
	L.buff1_message = "Ромуло получил(а) Бесстрашие!"
	L.buff2_message = "Джулианна получил(а) Преданность!"
end

L = BigWigs:NewBossLocale("Shade of Aran", "ruRU")
if L then
	L.adds = "Элементали"
	L.adds_desc = "Предупреждать о появлении водных элементалей."
	L.adds_message = "Надвигаются Элементали!"
	L.adds_warning = "Скоро Элементали!"
	L.adds_bar = "Исчезновение Элементалей"

	L.drink = "Выпивание"
	L.drink_desc = "Предупреждать когда Аран начинает Выпивание."
	L.drink_warning = "Мало маны - Скоро Выпивание!"
	L.drink_message = "Выпивание - Масс Превращение"
	L.drink_bar = "Надвигается Огненная глыба"

	L.blizzard = "Снежная буря"
	L.blizzard_desc = "Предупреждать о начале появления снежной бури."
	L.blizzard_message = "Снежная буря!"

	L.pull = "Тяга/Супер ВВ"
	L.pull_desc = "Предупреждать о магнитном притягивании и Супер Волшебном взрыве."
	L.pull_message = "Волшебный взрыв!"
	L.pull_bar = "Волшебный взрыв"
end

L = BigWigs:NewBossLocale("Terestian Illhoof", "ruRU")
if L then
	L.engage_trigger = "^А, вы как раз вовремя!."

	L.weak = "Ослабление"
	L.weak_desc = "Предупреждение о Ослабление статов."
	L.weak_message = "Ослабление на ~45сек!"
	L.weak_warning1 = "Ослабление исчезнет через ~5сек!"
	L.weak_warning2 = "Ослабление прошло!"
	L.weak_bar = "~Ослабление исчезает"
end

L = BigWigs:NewBossLocale("The Big Bad Wolf", "ruRU")
if L then
	L.name = "Злой и страшный серый волк"

	L.riding_bar = "%s БЕГИ!!!"
end

L = BigWigs:NewBossLocale("The Crone", "ruRU")
if L then
	L.name = "Ведьма"

	L.engage_trigger = "^О, Тито, нам просто надо найти дорогу домой!"

	L.spawns = "Таймер появления"
	L.spawns_desc = "Таймеры активации персонажей."
	L.spawns_warning = "%s через 5 сек"

	L.roar = "Хохотун"
	L.tinhead = "Медноголовый"
	L.strawman = "Балбес"
	L.tito = "Тито"
end

