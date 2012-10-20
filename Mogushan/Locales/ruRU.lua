local L = BigWigs:NewBossLocale("The Stone Guard", "ruRU")
if not L then return end
if L then
	L.petrifications = "Окаменение"
	L.petrifications_desc = "Предупреждать, когда боссы начинают окаменение."

	L.overload = "Перенасыщение"
	L.overload_desc = "Предупреждать о всех типах перенасыщения."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "ruRU")
if L then
	L.engage_yell = "Трепещите, пока живы. Это обитель мертвых."

	L.phase_lightning_trigger = "О, великий дух! Даруй мне силу земли!"
	L.phase_flame_trigger = "О, превозносимый! Моими руками ты отделишь их плоть от костей!"
	L.phase_arcane_trigger =  "О, великий мыслитель! Да снизойдет на меня твоя древняя мудрость!"
	L.phase_shadow_trigger = "Великие души защитников! Охраняйте меня!"

	L.phase_lightning = "Фаза молний"
	L.phase_flame = "Фаза огня"
	L.phase_arcane = "Фаза тайной магии"
	L.phase_shadow = "Фаза тьмы"

	L.shroud_message = "%2$s вешает Покров на %1$s"
	L.barrier_message = "Барьер АКТИВЕН!"

	L.tank = "Предупреждения для танков"
	L.tank_desc = "Только для танков. Считает стаки: Искрящаяся плеть, Пылающее копье, Чародейское потрясение и Ожог Тьмы (Героик)."
	L.lash_message = "%2$dx Плеть на |3-5(%1$s)"
	L.spear_message = "%2$dx Копье на |3-5(%1$s)"
	L.shock_message = "%2$dx Потрясение на |3-5(%1$s)"
	L.burn_message = "%2$dx Ожог на |3-5(%1$s)"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "ruRU")
if L then
	L.engage_yell = "Пора умирать!"

	L.totem = "Тотем"
	L.frenzy = "Бешенство скоро!"

	L.shadowy = "Теневая атака"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "ruRU")
if L then
	L.shield_removed = "Щит убран!"
	L.casting_shields = "Наложение щита"
	L.casting_shields_desc = "Предупреждать, когда вешается щит для всех боссов"
end

L = BigWigs:NewBossLocale("Elegon", "ruRU")
if L then
	L.last_phase = "Последняя фаза"
	L.overcharged_total_annihilation = "На вас (%d) %s, срочно сбросьте!"

	L.floor = "Пол исчезает"
	L.floor_desc = "Предупреждать, когда пол готовится исчезнуть."
	L.floor_message = "Пол падает!!"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "ruRU")
if L then
	L.enable_zone = "Кузня Бесконечности"

	L.energizing = "%s наполняется энергией!"
	L.combo = "%s: череда ударов"

	L.heroic_start_trigger = "Трубы разрушены"
	L.normal_start_trigger = "Машина гудит"

	L.rage_trigger = "Ярость Императора эхом звучит среди холмов."
	L.strength_trigger = "В нишах появляется Сила императора!"
	L.courage_trigger = "В нишах появляется Смелость императора!"
	L.bosses_trigger = "В больших нишах появляются два голема!"
	L.gas_trigger = "Древняя машина могу ломается!"
	L.gas_overdrive_trigger = "Древняя машина могу перегружена!"

	L.arc_desc = "|cFFFF0000Это предупреждение показывается только для выбранного в цель босса.|r " .. (select(2, EJ_GetSectionInfo(5673)))
end

