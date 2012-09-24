local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "ruRU")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "ruRU")
if L then
	L.unseenstrike_cone = "Невидимый удар"

	L.assault = "Сокрушительный выпад"
	L.assault_desc = "Только для танков. The attack leaves the target's defenses exposed, increasing the target's damage taken when an Overwhelming Assault lands by 100% for 45 sec."
end

L = BigWigs:NewBossLocale("Garalon", "ruRU")
if L then

end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "ruRU")
if L then
	L.next_pack = "Следующая группа"
	L.next_pack_desc = "Предупреждать, когда новая группа появится, после убийства предыдущей."

	L.spear_removed = "Ваше Пронзающее копье снялось!"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "ruRU")
if L then
	L.explosion_boss = "Взрыв на БОССЕ!"
	L.explosion_you = "Взрыв на ТЕБЕ!"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "ruRU")
if L then
	L.phases = "Фаза"
	L.phases_desc = "Предупредать о смене фаз."

	L.eyes = "Взгляд императрицы"
	L.eyes_desc = "Только для танков. Считает стаки взгляда императрицы и показывает таймер."
	L.eyes_message = "%2$dx взгляд на %1$s"
end

