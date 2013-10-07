local L = BigWigs:NewBossLocale("Immerseus", "ruRU")
if not L then return end
if L then
	L.win_yell = "У вас получилось!"
end

L = BigWigs:NewBossLocale("The Fallen Protectors", "ruRU")
if L then
	L.defile = "Чтение Оскверненной земли"

	L.custom_off_bane_marks = "Маркировка Слово Тьмы: Погибель"
	L.custom_off_bane_marks_desc = "Чтобы помочь с рассеиванием, люди со Словом Тьмы: Погибель будут помечены метками {rt1}{rt2}{rt3}{rt4}{rt5} (в этой последовательности, не все метки могут быть использованы), требуется быть помощником или лидером."

	L.no_meditative_field = "НЕТ Медитативного поля!"

	L.intermission = "Крайние меры"
	L.intermission_desc = "Предупреждать, когда боссы готовятся применить Крайние меры."

	L.inferno_self = "Адский удар на тебе"
	L.inferno_self_desc = "Особый отсчет, когда Адский удар на тебе."
	L.inferno_self_bar = "Ты взорвешься!"
end

L = BigWigs:NewBossLocale("Norushen", "ruRU")
if L then
	L.pre_pull = "Подготовка"
	L.pre_pull_desc = "Полоса отсчета до нападения босса."
	L.pre_pull_trigger = "Хорошо, я создам поле для удерживания порчи."

	L.big_adds = "Большие помощники"
	L.big_adds_desc = "Предупреждать об убийстве больших помощников снаружи/внутри."
	L.big_add = "Большой помощник (%d)"
	L.big_add_killed = "Большой помощник убит! (%d)"
end

L = BigWigs:NewBossLocale("Sha of Pride", "ruRU")
if L then
	L.custom_off_titan_mark = "Маркировка Дара титанов"
	L.custom_off_titan_mark_desc = "Отмечать людей с Даром титанов метками {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8}, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r"

	L.projection_message = "Бегите к |cFF00FF00ЗЕЛЕНОЙ|r стрелке!"
	L.projection_explosion = "Проекция взрывается"

	L.big_add_bar = "Большой помощник"
	L.big_add_spawning = "Большой помощник появляется!"
	L.small_adds = "Маленькие помощники"

	L.titan_pride = "Титан+Гордыня: %s"
end

L = BigWigs:NewBossLocale("Galakras", "ruRU")
if L then
	L.demolisher = "Разрушитель"
	L.demolisher_desc = "Таймеры, когда Кор'кронские разрушители вступят в бой."

	L.towers = "Башня"
	L.towers_desc = "Предупреждать, когда башни ломаются."
	L.south_tower_trigger = "Дверь южной башни разбита!"
	L.south_tower = "Южная башня"
	L.north_tower_trigger = "Дверь северной башни разбита!"
	L.north_tower = "Северная башня"
	L.tower_defender = "Защитник башни"

	L.custom_off_shaman_marker = "Маркировка Шаманов"
	L.custom_off_shaman_marker_desc = "To help interrupt assignments, mark the Dragonmaw Tidal Shamans with (rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over the shamans is the fastest way to mark them.|r"
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "ruRU")
if L then
	L.custom_off_mine_marks = "Маркировка мин"
	L.custom_off_mine_marks_desc = "To help soaking assignments, mark the Crawler Mines with (rt1}{rt2}{rt3}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over all the mines is the fastest way to mark them.|r"
end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "ruRU")
if L then
	L.blobs = "Капли"

	L.custom_off_mist_marks = "Toxic Mist marker"
	L.custom_off_mist_marks_desc = "To help healing assignments, mark the people who have Toxic Mist on them with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"
end

L = BigWigs:NewBossLocale("General Nazgrim", "ruRU")
if L then
	L.custom_off_bonecracker_marks = "Bonecracker marker"
	L.custom_off_bonecracker_marks_desc = "To help healing assignments, mark the people who have Bonecracker on them with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.stance_bar = "%s(СЕЙЧАС:%s)"
	L.battle = "Бой"
	L.berserker = "Берсерк"
	L.defensive = "Защита"

	L.adds_trigger1 = "Удерживайте врата!"
	L.adds_trigger2 = "Сомкнуть ряды!"
	L.adds_trigger3 = "Следующий отряд, вперед!"
	L.adds_trigger4 = "Воины, бегом!"
	L.adds_trigger5 = "Кор'крон, ко мне!"
	L.adds_trigger_extra_wave = "Кор'кронцы... все, кто со мной! Убейте их!"
	L.extra_adds = "Новые помощники"

	L.chain_heal_message = "Ваш фокус читает Цепное исцеление!"

	L.arcane_shock_message = "Ваш фокус читает Чародейское потрясение!"

	L.focus_only = "|cffff0000Оповещения только для фокуса.|r "
end

L = BigWigs:NewBossLocale("Malkorok", "ruRU")
if L then
	L.custom_off_energy_marks = "Маркировка Блуждающей энергии"
	L.custom_off_energy_marks_desc = "Чтобы помочь с рассеиванием, люди с Блуждающей энергией будут помечены метками {rt1}{rt2}{rt3}{rt4}, требуется быть помощником или лидером.\n|cFFFF0000Только 1 человек в рейде должен включить эту опцию, чтобы предотвратить конфликты.|r"
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "ruRU")
if L then
	L.win_trigger = "Система перезагружается. Не выключать питание, иначе возможен взрыв."

	L.enable_zone = "Хранилище артефактов"
	L.matter_scramble_explosion = "Взрыв материи"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "ruRU")
if L then
	L.tank_debuffs = "Дебаффы танка"
	L.tank_debuffs_desc = "Предупреждать о разных типах дебаффов танка, связанных со Страшным ревом."

	L.cage_opened = "Клетка открыта"
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "ruRU")
if L then
	L.shredder_engage_trigger = "Приближается автоматический крошшер!"
	L.laser_on_you = "Лазер на тебе ПИУ-ПИУ!"
	L.laser_say = "Лазер ПИУ-ПИУ!"

	L.assembly_line_trigger = "На сборочную линию начинает поступать незаконченное оружие."
	L.assembly_line_message = "Незаконченное оружие (%d)"

	L.shockwave_missile_trigger = "Представляю вам прекрасную ударно-волновую турель УТ-03!"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "ruRU")
if L then
	L.one = "Выбор Ийокука: Один!"
	L.two = "Выбор Ийокука: Два!"
	L.three = "Выбор Ийокука: Три!"
	L.four = "Выбор Ийокука: Четыре!"
	L.five = "Выбор Ийокука: Пять!"
	--------------------------------
	L.edge_message = "Ты в луче"
	L.custom_off_edge_marks = "Маркировка луча"
	L.custom_off_edge_marks_desc = "Маркировка людей, которые станут лучами, на основе вычислений %s%s%s%s%s%s, требуется быть помощником или лидером."
	L.injection_over_soon = "Инъекция заканчивается (%s)!"
	L.custom_off_mutate_marks = "Мутирование: Янтарный скорпион маркировка"
	L.custom_off_mutate_marks_desc = "Отмечать игроков, имеющих Мутирование: Янтарный скорпион метками %s%s%s чтобы помочь лекарям, требуется быть помощником или лидером."
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "ruRU")
if L then
	L.intermission = "Перерыв"
	L.mind_control = "Контроль разума"

	L.chain_heal_desc = "Лечит союзника, восстанавливая определенный процент от его максимального запаса здоровья, переходя на находящиеся поблизости дружественные цели."
	L.chain_heal_message = "Ваш фокус читает Цепное исцеление!"
	L.chain_heal_bar = "Фокус: Цепное исцеление"

	L.farseer_trigger = "Исцелите наши раны!"
	L.custom_off_shaman_marker = "Маркировка Предсказателей"
	L.custom_off_shaman_marker_desc = "Чтобы помочь с прерыванием, Предсказатели - всадники на волках будет помечены метками {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} (в этой последовательности, не все метки могут быть использованы), требуется быть помощником или лидером."

	L.focus_only = "|cffff0000Оповещения только для фокуса.|r "
end

L = BigWigs:NewBossLocale("Siege of Orgrimmar Trash", "ruRU")
if L then

end

