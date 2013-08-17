local L = BigWigs:NewBossLocale("Immerseus", "ruRU")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("The Fallen Protectors", "ruRU")
if L then
	L.defile = "Чтение Оскверненной земли"

	L.custom_off_bane_marks = "Маркировка Слово Тьмы: Погибель"
	L.custom_off_bane_marks_desc = "Чтобы помочь с рассеиванием, люди со Словом Тьмы: Погибель будут помечены метками %s%s%s%s%s (в этой последовательности)(не все метки могут быть использованы), требуется быть помощником или лидером."

	L.no_meditative_field = "НЕТ Медитативного поля!"

	L.intermission = "Крайние меры"
	L.intermission_desc = "Предупреждать, когда боссы готовятся применить Крайние меры"
end

L = BigWigs:NewBossLocale("Norushen", "ruRU")
if L then
	L.big_adds = "Большие помощники"
	L.big_adds_desc = "Предупреждать об убийстве больших помощников снаружи/внутри."
	L.big_add = "Большой помощник! (%d)"
	L.big_add_killed = "Большой помощник убит! (%d)"
end

L = BigWigs:NewBossLocale("Sha of Pride", "ruRU")
if L then
	L.custom_off_titan_mark = "Маркировка Дара титанов"
	L.custom_off_titan_mark_desc = "Чтобы помочь задействовать Силу титанов, люди с Даром титанов будут помечены метками %s%s%s%s%s%s%s%s (игроки с Аурой гордыни и танки не помечаются), требуется быть помощником или лидером."

	L.projection_message = "Бегите по |cFF00FF00ЗЕЛЕНОЙ|r стрелке!"
	L.projection_explosion = "Проекция взрывается"

	L.big_add_bar = "Большой помощник"
	L.big_add_spawning = "Большой помощник появляется!"
	L.small_adds = "Маленькие помощники"
end

L = BigWigs:NewBossLocale("Galakras", "ruRU")
if L then
	L.demolisher = "Разрушитель"
	L.demolisher_desc = "Таймеры, когда Кор'кронские разрушители вступят в бой."
	L.towers = "Башня"
	L.towers_desc = "Предупреждать, когда башни ломаются."
	-- L.south_tower_trigger = "The door barring the South Tower has been breached!"
	L.south_tower = "Южная башня"
	-- L.north_tower_trigger = "The door barring the North Tower has been breached!"
	L.north_tower = "Северная башня"
	L.tower_defender = "Защитник башни"

	L.custom_off_shaman_marker = "Маркировка Шаманов"
	L.custom_off_shaman_marker_desc = "Чтобы помочь с прерыванием, Шаманы приливов будут помечены метками %s%s%s%s%s%s%s (в этой последовательности)(не все метки могут быть использованы), требуется быть помощником или лидером."
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "ruRU")
if L then
	L.custom_off_mine_marks = "Маркировка мин"
	L.custom_off_mine_marks_desc = "Чтобы помочь с распределением, Ползучие мины будут помечены метками %s%s%s%s%s (в этой последовательности)(не все метки могут быть использованы), требуется быть помощником или лидером."
end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "ruRU")
if L then
	L.blobs = "Капли"

	L.custom_off_mist_marks = "Токсичный туман"
	L.custom_off_mist_marks_desc = "Чтобы помочь лекарям, люди с Токсичным туманом будут помечены метками %s%s%s%s%s%s (в этой последовательности)(не все метки могут быть использованы), требуется быть помощником или лидером."
end

L = BigWigs:NewBossLocale("General Nazgrim", "ruRU")
if L then
	L.custom_off_bonecracker_marks = "Костолом"
	L.custom_off_bonecracker_marks_desc = "Чтобы помочь лекарям, люди с Костоломом будут помечены метками %s%s%s%s%s%s (в этой последовательности)(не все метки могут быть использованы), требуется быть помощником или лидером."

	L.stance_bar = "%s(СЕЙЧАС:%s)"
	L.battle = "Бой"
	L.berserker = "Берсерк"
	L.defensive = "Защита"

	-- L.adds_trigger1 = "Defend the gate!"
	-- L.adds_trigger2 = "Rally the forces!"
	-- L.adds_trigger3 = "Next squad, to the front!"
	-- L.adds_trigger4 = "Warriors, on the double!"
	-- L.adds_trigger5 = "Kor'kron, at my side!"
	-- L.adds_trigger_extra_wave = "All Kor'kron... under my command... kill them... NOW"
	L.extra_adds = "Новые помощники"

	L.chain_heal_message = "Ваш фокус читает Цепное исцеление!"

	L.arcane_shock_message = "Ваш фокус читает Чародейское потрясение!"

	L.focus_only = "|cffff0000Оповещения только для фокуса.|r "
end

L = BigWigs:NewBossLocale("Malkorok", "ruRU")
if L then
	L.custom_off_energy_marks = "Маркировка Блуждающей энергии"
	L.custom_off_energy_marks_desc = "Чтобы помочь с рассеиванием, люди с Блуждающей энергией будут помечены метками %s%s%s%s%s%s%s (в этой последовательности)(не все метки могут быть использованы), требуется быть помощником или лидером."
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "ruRU")
if L then
	L.enable_zone = "Хранилище артефактов"
	L.matter_scramble_explosion = "Взрыв материи"

	L.custom_off_mark_brewmaster = "Маркировка Хмелевара"
	L.custom_off_mark_brewmaster_desc = "Дух древнего хмелевара будет помечен меткой %s"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "ruRU")
if L then
	L.tank_debuffs = "Дебаффы танка"
	L.tank_debuffs_desc = "Предупреждать о разных типах дебаффов танка, связанных со Страшным ревом."
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "ruRU")
if L then
	-- L.shredder_engage_trigger = "An Automated Shredder draws near!"
	L.laser_on_you = "Лазер на тебе ПИУ-ПИУ!"
	L.laser_say = "Лазер ПИУ-ПИУ!"

	-- L.assembly_line_trigger = "Unfinished weapons begin to roll out on the assembly line."
	L.assembly_line_message = "Незавершенные оружия (%d)"

	-- L.shockwave_missile_trigger = "Presenting... the beautiful new ST-03 Shockwave missile turret!"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Siege of Orgrimmar Trash", "ruRU")
if L then

end

