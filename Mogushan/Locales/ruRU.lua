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
	L.phase_arcane_trigger = "О, великий мыслитель! Да снизойдет на меня твоя древняя мудрость!"
	L.phase_shadow_trigger = "Великие души защитников! Охраняйте меня!"

	L.phase_lightning = "Фаза молний"
	L.phase_flame = "Фаза огня"
	L.phase_arcane = "Фаза тайной магии"
	L.phase_shadow = "Фаза тьмы"

	L.phase_message = "Новая фаза скоро!"
	L.shroud_message = "Покров"
	L.shroud_can_interrupt = "%s может прервать %s!"
	L.barrier_message = "Барьер АКТИВЕН!"
	L.barrier_cooldown = "Перезарядка барьера"

	L.tank = "Предупреждения для танков"
	L.tank_desc = "Считает стаки: Искрящаяся плеть, Пылающее копье, Чародейское потрясение и Ожог Тьмы (Героик)."
	L.lash_message = "Плеть"
	L.spear_message = "Копье"
	L.shock_message = "Потрясение"
	L.burn_message = "Ожог"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "ruRU")
if L then
	L.engage_yell = "Пора умирать!"

	L.totem_message = "Тотем (%d)"
	L.shadowy_message = "Атака (%d)"
	L.banish_message = "Танк изгнан"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "ruRU")
if L then
	L.bosses = "Боссы"
	L.bosses_desc = "Предупреждать, когда босс становится активным."

	L.shield_removed = "Щит убран! (%s)"
	L.casting_shields = "Наложение щита"
	L.casting_shields_desc = "Предупреждать, когда боссы накладывают щиты."
end

L = BigWigs:NewBossLocale("Elegon", "ruRU")
if L then
	L.engage_yell = "Переход в защитный режим. Отключение предохранителей."

	L.last_phase = "Последняя фаза"
	L.overcharged_total_annihilation = "Перезарядка %d! Многовато?"

	L.floor = "Исчезание пола"
	L.floor_desc = "Предупреждать, когда пол готовится исчезнуть."
	L.floor_message = "Пол пропадает!"

	L.adds = "Защитники"
	L.adds_desc = "Предупреждать о скором появлении небесного защитника."
end

L = BigWigs:NewBossLocale("Will of the Emperor", "ruRU")
if L then
	L.enable_zone = "Кузня Бесконечности"

	L.heroic_start_trigger = "Трубы разрушены"
	L.normal_start_trigger = "Машина гудит"

	L.rage_trigger = "Ярость императора эхом звучит среди холмов."
	L.strength_trigger = "В нишах появляется Сила императора!"
	L.courage_trigger = "В нишах появляется Смелость императора!"
	L.bosses_trigger = "В больших нишах появляются два голема!"
	L.gas_trigger = "Древняя машина могу ломается!"
	L.gas_overdrive_trigger = "Древняя машина могу перегружена!"

	L.target_only = "|cFFFF0000Это предупреждение показывается только для выбранного в цель босса.|r "
	L.combo = "Череда ударов"
	L.combo_message = "%s: Череда ударов скоро!"
end

