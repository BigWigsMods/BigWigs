local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "ruRU")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "ruRU")
if L then
	L.unseenstrike_cone = "Невидимый удар"

	L.assault_message = "%2$dx Выпад на |3-5(%1$s)"
end

L = BigWigs:NewBossLocale("Garalon", "ruRU")
if L then
	L.crush_stun = "Сокрушение"
	L.crush_trigger1 = "Garalon prepares to"
	L.crush_trigger2 = "Гаралон чувствует"
	L.crush_trigger3 = "Garalon detects"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "ruRU")
if L then
	L.next_pack = "Следующая группа"
	L.next_pack_desc = "Предупреждать, когда появится новая группа после убийства предыдущей."

	L.spear_removed = "Ваше Пронзающее копье снялось!"
	L.residue_removed = "%s снято!"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "ruRU")
if L then
	L.explosion_casting = "Янтарный взрыв"
	L.explosion_casting_desc = "Warning for when any of the Amber Explosions are being casted. Cast start message warnings are associated to this option. Emphasizing this is highly recommended!"

	L.willpower = "Сила воли"
	L.willpower_desc = "When Willpower runs out, the player dies and the Mutated Construct continues to act, uncontrolled."
	L.willpower_message = "Ваша сила воли: %d (%d)"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "ruRU")
if L then
	L.phases = "Фаза"
	L.phases_desc = "Предупредать о смене фаз."

	L.eyes = "Взгляд императрицы"
	L.eyes_desc = "Считает стаки взгляда императрицы и показывает таймер."
	L.eyes_message = "%2$dx Взгляд на |3-5(%1$s)"
end

