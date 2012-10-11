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
	L.phases = "Фазы"
	L.phases_desc = "Предупреждать о смене фаз"

	L.phase_lightning_trigger = "О, великий дух! Даруй мне силу земли!"
	L.phase_flame_trigger = "О, превозносимый! Моими руками ты отделишь их плоть от костей!"
	L.phase_arcane_trigger =  "О, великий мыслитель! Да снизойдет на меня твоя древняя мудрость!"
	L.phase_shadow_trigger = "Great soul of champions past! Bear to me your shield!" -- Needs review

	L.phase_lightning = "Фаза молний!"
	L.phase_flame = "Фаза огня!"
	L.phase_arcane = "Фаза тайной магии!"
	L.phase_shadow = "Фаза тьмы!"

	L.shroud_message = "%2$s cast Shroud on %1$s"
	L.barrier_message = "Barrier UP!"

	L.tank = "Предупреждения для танков"
	L.tank_desc = "Только для танков. Считает стаки: Искрящаяся плеть, Пылающее копье, Чародейское потрясение и Ожог Тьмы (Героик)."
	L.lash_message = "%2$dx Плеть на |3-5(%1$s)"
	L.spear_message = "%2$dx Копье на |3-5(%1$s)"
	L.shock_message = "%2$dx Потрясение на |3-5(%1$s)"
	L.burn_message = "%2$dx Ожог на |3-5(%1$s)"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "ruRU")
if L then
	L.frenzy = "Бешенство скоро!"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "ruRU")
if L then
	L.shield_removed = "Щит убран!"
end

L = BigWigs:NewBossLocale("Elegon", "ruRU")
if L then
	L.last_phase = "Последняя фаза"
	L.floor_despawn = "Пол исчезает"
	L.overcharged_total_annihilation = "На вас (%d) %s, снимите дебафф!"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "ruRU")
if L then
	L.rage_trigger = "Ярость Императора эхом звучит среди холмов."
	L.strength_trigger = "Сила Императора сжимает эти земли в железных тисках!"
	L.courage_trigger = "Смелость Императора безгранична!"
	L.bosses_trigger = "Two titanic constructs appear in the large alcoves!" -- Needs review
end

