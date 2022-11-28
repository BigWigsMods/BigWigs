local L = BigWigs:NewBossLocale("Eranog", "ruRU")
if not L then return end
if L then
	L.custom_on_nameplate_fixate = "Метка для тарасекка"
	L.custom_on_nameplate_fixate_desc = "Показывать метку на Бешеном Тарасекке, который зафиксировал вас.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."

	L.molten_cleave = "Фронтал"
	L.incinerating_roar = "Рык"
	L.molten_spikes = "Шипы"
	L.collapsing_army = "Армия"
	L.greater_flamerift = "Мифик адд"
	L.leaping_flames = "ДоТ"
end

L = BigWigs:NewBossLocale("Terros", "ruRU")
if L then
	L.rock_blast = "Делёжка"
	L.resonating_annihilation = "Аннигиляция"
	L.awakened_earth = "Столп"
	L.shattering_impact = "Войда"
	L.concussive_slam = "Танк фронтал"
	L.infused_fallout = "Пыль"
end

L = BigWigs:NewBossLocale("The Primal Council", "ruRU")
if L then
	L.primal_blizzard = "Буря" -- Primal Blizzard
	L.earthen_pillars = "Столп" -- Earthen Pillars
	L.meteor_axes = "Топоры" -- Meteor Axes
	L.meteor_axe = "Топор" -- Singular
	L.meteor_axes_melee = "Мили делёжка"
	L.meteor_axes_ranged = "Рендж делёжка"
	L.conductive_marks = "Знаки" -- Conductive Marks
	L.conductive_mark = "Знак" -- Singular

	L.custom_off_chain_lightning = "Цепная молния выключена по умолчанию. Нажмите, что бы включить её."

	L.custom_on_stop_timers = "Всегда показывать полосы способностей"
	L.custom_on_stop_timers_desc = "Будут показываться следующие способности:  Знак проводимости"
end

L = BigWigs:NewBossLocale("Sennarth, The Cold Breath", "ruRU")
if L then
	L.ascend = "Подъём"
	L.ascend_desc = "Сеннарк поднимается выше."
	L.chilling_blast = "Спред"
	L.freezing_breath = "Фронтал адда"
	L.webs = "Сети"
	L.web = "Паутина"
	L.gossamer_burst = "Притягивание"
	L.repelling_burst = "Отталкивание"
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "ruRU")
if L then
	L.marks_on_me = "%d знак" -- {Stacks} Conductive Mark on the player

	L.conductive_marks = "Знаки"
	L.conductive_mark = "Знак"
	L.raging_burst = "Новые торнадо"
	L.cyclone = "Циклон"
	L.crosswinds = "Торнадо движутся"
end

L = BigWigs:NewBossLocale("Kurog Grimtotem", "ruRU")
if L then
	-- Types
	L.damage = "Дамажущие способности"
	L.damage_desc = "Показывать таймеры для дамажущих способностей (Взрыв магмы, Жгучий холод, Охватывающая земля, Сокрушение молнией) когда неизвестен альтарь босса."
	L.damage_bartext = "%s [урон]" -- {Spell} [Dmg]

	L.avoid = "Додж. способности"
	L.avoid_desc = "Показывать таймеры для додж. способностей (Раскаленный разлом, Ледяный звезды, Каменный разлом , Шоковый удар) когда неизвестен альтарь босса."
	L.avoid_bartext = "%s [додж]" -- {Spell} [Avoid]

	L.ultimate = "Ультимативные способности"
	L.ultimate_desc = "Display timers for Ultimate abilities (Огненная бойня, Абсолютный нуль, Сейсмический разлом, Громовой удар) when we don't know what alter the boss is at."
	L.ultimate_bartext = "%s [ульт.]" -- {Spell} [Ult]

	-- Fire
	L.magma_burst = "Лужи"
	L.molten_rupture = "Волны"
	L.searing_carnage = "Танец"

	-- Frost
	L.biting_chill = "Фрост ДоТ"
	L.frigid_torrent = "Шары"
	L.absolute_zero = "Делёжка"
	L.absolute_zero_melee = "Мили делёжка"
	L.absolute_zero_ranged = "Рендж делёжка"

	-- Earth
	L.enveloping_earth = "Абсорб хила"
	L.erupting_bedrock = "Войд зоны"

	-- Storm
	L.lightning_crash = "Молния"
	L.thundering_strike = "Соки"

	-- General
	L.primal_attunement = "Софт энрейдж"

	-- Stage 2
	L.violent_upheaval = "Столпы"
end

L = BigWigs:NewBossLocale("Broodkeeper Diurna", "ruRU")
if L then
	L.eggs_remaining = "Яиц осталось: %d!"
	L.broodkeepers_bond = "Яиц осталось"
	L.greatstaff_of_the_broodkeeper = "Великий Посох"
	L.greatstaffs_wrath = "Лазер"
	L.clutchwatchers_rage = "Ярость"
	L.rapid_incubation = "Инкуцбация"
	L.icy_shroud = "Хил Абсорб"
	L.broodkeepers_fury = "Неистовство"
	L.frozen_shroud = "Хил Абсорб и рут"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "ruRU")
if L then

end
