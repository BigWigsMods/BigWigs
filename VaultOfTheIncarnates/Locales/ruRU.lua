local L = BigWigs:NewBossLocale("Eranog", "ruRU")
if not L then return end
if L then
	L.custom_on_nameplate_fixate = "Метка для тарасекка"
	L.custom_on_nameplate_fixate_desc = "Показывать метку на Бешеном Тарасекке, который зафиксировал вас.\n\nТребует включённых индикаторов здоровья врагов и соответствующего аддона (KuiNameplates, Plater)."

	L.molten_cleave = "Фронтал"
	L.molten_spikes = "Шипы"
	L.collapsing_army = "Армия"
	L.greater_flamerift = "Мифик адд"
	L.leaping_flames = "ДоТ"
end

L = BigWigs:NewBossLocale("Terros", "ruRU")
if L then
	L.resonating_annihilation = "Аннигиляция"
	L.awakened_earth = "Столп"
	L.shattering_impact = "Войда"
	L.concussive_slam = "Танк фронтал"
	L.infused_fallout = "Пыль"

	L.custom_on_repeating_fallout = "Повторять Пыль в чат"
	L.custom_on_repeating_fallout_desc = "Повторять сообщение в чат с иконкой {rt7} с целью найти партнёра."
end

L = BigWigs:NewBossLocale("The Primal Council", "ruRU")
if L then
	L.primal_blizzard = "Буря" -- Primal Blizzard
	L.earthen_pillars = "Столп" -- Earthen Pillars
	L.meteor_axes = "Топоры" -- Meteor Axes
	L.meteor_axe = "Топор" -- Singular
	L.meteor_axes_melee = "Мили делёжка"
	L.meteor_axes_ranged = "Рендж делёжка"

	L.skipped_cast = "Пропущено %s (%d)"
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
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "ruRU")
if L then
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
	L.ultimate_desc = "Показывать таймеры для ультимативных способностей (Огненная бойня, Абсолютный нуль, Сейсмический разлом, Громовой удар) когда неизвестен альтарь босса."
	L.ultimate_bartext = "%s [ульт.]" -- {Spell} [Ult]

	L.add_bartext = "%s [Адд]" -- "{Spell} [Add]"

	L.Fire = "огонь"
	L.Frost = "лед"
	L.Earth = "Земля"
	L.Storm = "буря"

	-- Fire
	L.molten_rupture = "Волны"
	L.searing_carnage = "Танец"
	L.raging_inferno = "Соак лужи"

	-- Frost
	L.biting_chill = "Фрост ДоТ"
	L.absolute_zero_melee = "Мили делёжка"
	L.absolute_zero_ranged = "Рендж делёжка"

	-- Earth
	L.erupting_bedrock = "Войд зоны"

	-- Storm
	L.lightning_crash = "Молния"

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
	L.clutchwatchers_rage = "Ярость"
	L.rapid_incubation = "Инкубация"
	L.broodkeepers_fury = "Стаки"
	L.frozen_shroud = "Абсорб + Рут"
	L.detonating_stoneslam = "Танк Соак"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "ruRU")
if L then
	L.lighting_devastation_trigger = "глубокий вдох" -- Рашагет делает глубокий вдох...

	-- Stage One: The Winds of Change
	L.volatile_current = "Искры"
	L.thunderous_blast = "Танкбастер"
	L.lightning_strikes = "Войд зоны"
	L.electric_scales = "Рейд урон"
	L.electric_lash = "Хлыст"
	-- Stage Two: Surging Power
	L.absorb_text = "%s (%.0f%%)"
	L.stormsurge = "Щит"
	L.stormcharged = "Плюс или Минус"
	L.positive = "Плюс"
	L.negative = "Минус"
	L.focused_charge = "Бафф урона"
	L.tempest_wing = "Отталкивание"
	L.fulminating_charge = "Вынос"
	L.fulminating_charge_debuff = "Вынос"
	-- Intermission: The Vault Falters
	L.ball_lightning = "Шарики"
	-- Stage Three: Storm Incarnate
	L.magnetic_charge = "Притягивание"

	L.custom_on_repeating_stormcharged = "Повторять плюс или минус"
	L.custom_on_repeating_stormcharged_desc = "Повторять в чате Плюс или Минус иконками {rt1}, {rt3} что бы найти партнёра."

	L.skipped_cast = "Пропущено %s (%d)"

	L.custom_off_raidleader_devastation = "Полёт: Режим Рейдлидера"
	L.custom_off_raidleader_devastation_desc = "Показывать полоску для Опустошающей молнии (Дыхание) на противоположной стороне."
	L.breath_other = "%s [другая сторона]" -- Breath on opposite platform
end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "ruRU")
if L then

end
