local L = BigWigs:NewBossLocale("Hellfire Assault", "ruRU")
if not L then return end
if L then
	L.left = "Слева: %s"
	L.middle = "Центр: %s"
	L.right = "Справа: %s"
end

L = BigWigs:NewBossLocale("Kilrogg Deadeye", "ruRU")
if L then
	L.add_warnings = "Предупреждения о появлении аддов"
end

L = BigWigs:NewBossLocale("Gorefiend", "ruRU")
if L then
	L.fate_root_you = "Общая судьба - Вы обездвижены!"
	L.fate_you = "Общая судьба на ВАС! - Обездвижен(а) %s"
end

L = BigWigs:NewBossLocale("Shadow-Lord Iskar", "ruRU")
if L then
	L.custom_off_wind_marker = "Маркировка Ирреальные ран"
	L.custom_off_wind_marker_desc = "Отмечать цели Ирреальных ран метками {rt1}{rt2}{rt3}{rt4}{rt5}, требуется быть помощником или лидером рейда.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r"

	L.bindings_removed = "Путы сняты (%d/3)"
	L.custom_off_binding_marker = "Маркировка Темных пут"
	L.custom_off_binding_marker_desc = "Отмечать метками {rt1}{rt2}{rt3}{rt4}{rt5}{rt6} цели Темных пут, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r"
end

L = BigWigs:NewBossLocale("Socrethar the Eternal", "ruRU")
if L then
	L.dominator_desc = "Предупреждения о появлении Саргерайского доминатора."

	L.portals = "Перемещения порталов"
	L.portals_desc = "Таймер изменения позиции порталов на 2 фазе."
	L.portals_msg = "Порталы переместились!"
end

L = BigWigs:NewBossLocale("Fel Lord Zakuun", "ruRU")
if L then
	L.seed = "Семя"

	L.custom_off_seed_marker = "Маркировка Семени разрушения"
	L.custom_off_seed_marker_desc = "Отмечать цели Семени разрушения метками {rt1}{rt2}{rt3}{rt4}{rt5}, требуется быть помощником или лидером рейда."

	L.tank_proximity = "Радар танков"
	L.tank_proximity_desc = "Открытие радара близости в 5 метров с отображением других танков поможет справляться со способностями Тяжелая рука и Тяжелое вооружение."
end

L = BigWigs:NewBossLocale("Tyrant Velhari", "ruRU")
if L then
	L.font_removed_soon = "Купель скоро спадет с вас!"
end

L = BigWigs:NewBossLocale("Mannoroth", "ruRU")
if L then
	L["185147"] = "Портал Владыки судеб закрыт!"
	L["185175"] = "Портал бесов скверны закрыт!"
	L["182212"] = "Портал инферналов закрыт!"

	L.gaze = "Взгляд (%d)"
	L.felseeker_message = "%s (%d) %dм"

	L.custom_off_gaze_marker = "Маркировка Взгляда Маннорота"
	L.custom_off_gaze_marker_desc = "Отмечать цели Взгляда Маннорота метками {rt1}{rt2}{rt3}, требуется быть помощником или лидером рейда."

	L.custom_off_doom_marker = "Маркировка Знака Рока"
	L.custom_off_doom_marker_desc = "На эпохальной сложности отмечает Знак Рока метками {rt1}{rt2}{rt3}, требуется быть помощником или лидером рейда."

	L.custom_off_wrath_marker = "Маркировка Гнева Гул'дана"
	L.custom_off_wrath_marker_desc = "Отмечать цели Гнева Гул'дана метками {rt8}{rt7}{rt6}{rt5}{rt4}, требуется быть помощником или лидером рейда."
end

L = BigWigs:NewBossLocale("Archimonde", "ruRU")
if L then
	L.torment_removed = "Страдание снято (%d/%d)"
	L.chaos_from = "%s от %s"
	L.chaos_to = "%s к %s"

	L.custom_off_torment_marker = "Маркировка Скованного страдания"
	L.custom_off_torment_marker_desc = "Отмечать цели Скованного страдания метками {rt1}{rt2}{rt3}, требуется быть помощником или лидером рейда."

	L.markofthelegion_self = "Клеймо Легиона на вас"
	L.markofthelegion_self_desc = "Специальный отсчет, когда Клеймо Легиона на вас."
	L.markofthelegion_self_bar = "Вы взорветесь!"

	L.custom_off_legion_marker = "Маркировка Клейма Легиона"
	L.custom_off_legion_marker_desc = "Отмечать цели Клейма Легиона метками {rt1}{rt2}{rt3}{rt4}, требуется быть помощником или лидером рейда."

	L.custom_off_infernal_marker = "Маркировка Инферналов"
	L.custom_off_infernal_marker_desc = "Отмечать Инферналов, появляющихся во время Ливня Хаоса, метками {rt1}{rt2}{rt3}{rt4}{rt5}, требуется быть помощником или лидером рейда."

	L.custom_off_chaos_helper = "Помощник Устроенного Хаоса"
	L.custom_off_chaos_helper_desc = "Только для эпохальной сложности. Эта функция говорит какой номер хаоса вам присвоен, показывая вам обычное сообщение и отправляя номер в /сказать. В зависимости от тактики, которую вы используете, эта функция может быть полезной или наоборот."
	L.chaos_helper_message = "Ваша позиция во время Хаоса: %d"
end

L = BigWigs:NewBossLocale("Hellfire Citadel Trash", "ruRU")
if L then
	L.anetheron = "Анетерон"
	L.azgalor = "Азгалор"
	L.bloodthirster = "Истекающий слюной кровопийца"
	L.burster = "Темный преследователь"
	L.daggorath = "Даг'горат"
	L.darkcaster = "Темный маг из клана Кровавой Глазницы"
	L.eloah = "Властитель Элоа"
	L.enkindler = "Огненная возжигательница"
	L.faithbreaker = "Эредар – разрушитель веры"
	L.graggra = "Граггра"
	L.kazrogal = "Каз'рогал"
	L.kuroh = "Адъюнкт Куро"
	L.orb = "Сфера разрушения"
	L.peacekeeper = "Голем-миротворец"
	L.talonpriest = "Оскверненный жрец Когтя"
	L.weaponlord = "Мастер оружия Мельхиор"
end