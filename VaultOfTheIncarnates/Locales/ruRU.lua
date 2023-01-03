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
	L.ultimate_desc = "Показывать таймеры для ультимативных способностей (Огненная бойня, Абсолютный нуль, Сейсмический разлом, Громовой удар) когда неизвестен альтарь босса."
	L.ultimate_bartext = "%s [ульт.]" -- {Spell} [Ult]

	-- L.add_bartext = "%s [Add]" -- "{Spell} [Add]"

	L.Fire = "огонь"
	L.Frost = "лед"
	L.Earth = "Земля"
	L.Storm = "буря"

	-- Fire
	L.magma_burst = "Лужи"
	L.molten_rupture = "Волны"
	L.searing_carnage = "Танец"
	-- L.raging_inferno = "Soak Pools"

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
	L.rapid_incubation = "Инкубация"
	L.icy_shroud = "Абсорб"
	L.broodkeepers_fury = "Стаки"
	L.frozen_shroud = "Абсорб + Рут"
	-- L.detonating_stoneslam = "Tank Soak"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "ruRU")
if L then
	L.lighting_devastation_trigger = "Глубокое дыхание" -- Raszageth takes a deep breath...

	-- Stage One: The Winds of Change
	-- L.hurricane_wing = "Pushback"
	-- L.volatile_current = "Sparks"
	-- L.thunderous_blast = "Blast"
	-- L.lightning_breath = "Breath"
	-- L.lightning_strikes = "Strikes"
	-- L.electric_scales = "Raid Damage"
	-- L.electric_lash = "Lash"
	-- Intermission: The Primalist Strike
	-- L.lightning_devastation = "Breath"
	-- L.shattering_shroud = "Heal Absorb"
	-- Stage Two: Surging Power
	-- L.absorb_text = "%s (%.0f%%)"
	-- L.stormsurge = "Absorb Shield"
	-- L.stormcharged = "Positive or Negative"
	-- L.positive = "Positive"
	-- L.negative = "Negative"
	-- L.focused_charge = "Damage Buff"
	-- L.tempest_wing = "Storm Wave"
	-- L.fulminating_charge = "Charges"
	-- L.fulminating_charge_debuff = "Charge"
	-- Intermission: The Vault Falters
	-- L.storm_break = "Teleport"
	-- L.ball_lightning = "Balls"
	-- L.fuses_reached = "%d |4Fuse:Fuses; Reached" -- 1 Fuse Reached, 2 Fuses Reached
	-- Stage Three: Storm Incarnate
	-- L.magnetic_charge = "Pull Charge"

	-- L.storm_nova_cast = "Storm Nova CastBar"
	-- L.storm_nova_cast_desc = "Cast Bar for Storm Nova"

	-- L.custom_on_repeating_stormcharged = "Repeating Positive or Negative"
	-- L.custom_on_repeating_stormcharged_desc = "Repeating Positive or Negative say messages with icons {rt1}, {rt3} to find matches to remove your debuffs."

	-- L.skipped_cast = "Skipped %s (%d)"

	-- L.custom_off_raidleader_devastation = "Lighting Devastation: Leader Mode"
	-- L.custom_off_raidleader_devastation_desc = "Show a bar for the Lighting Devastation (Breath) on the other side as well."
	-- L.breath_other = "%s [Opposite]" -- Breath on opposite platform
end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "ruRU")
if L then

end
