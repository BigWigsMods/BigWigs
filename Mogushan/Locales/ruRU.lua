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
	L.phases_desc = "Предупреждать о смене фаз."

	L.phase_flame_trigger = "Oh exalted one! Through me you shall melt flesh from bone!"	-- Needs review
	L.phase_lightning_trigger = "О, великий дух! Даруй мне силу земли!"
	L.phase_arcane_trigger =  "Oh sage of the ages! Instill to me your arcane wisdom!"		-- Needs review
	L.phase_shadow_trigger = "Great soul of champions past! Bear to me your shield!"		-- Needs review

	L.phase_flame = "Фаза огня!"
	L.phase_lightning = "Фаза молний!"
	L.phase_arcane = "Фаза тайной магии!"
	L.phase_shadow = "Фаза тьмы!"
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
	L.floor_despawn = "Исчезновение пола"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "ruRU")
if L then
	L.rage_trigger = "The Emperor's Rage echoes through the hills."				-- Needs review
	L.strength_trigger = "The Emperor's Strength appears in the alcoves!"		-- Needs review
	L.courage_trigger = "The Emperor's Courage appears in the alcoves!"			-- Needs review
	L.bosses_trigger = "Two titanic constructs appear in the large alcoves!"	-- Needs review
end

