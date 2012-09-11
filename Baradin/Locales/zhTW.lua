
local L = BigWigs:NewBossLocale("Argaloth", "zhTW")
if not L then return end
if L then
	L.darkness_message = "吞噬黑暗！"
	L.firestorm_message = "即將 魔化火颶！"
end

L = BigWigs:NewBossLocale("Occu'thar", "zhTW")
if not L then return end
if L then
	L.shadows_bar = "灼熱暗影"
	L.destruction_bar = "歐庫薩的毀滅"
	L.eyes_bar = "歐庫薩之眼"

	L.fire_message = "專注之火！"
	L.fire_bar = "下一專注之火"
end

L = BigWigs:NewBossLocale("Alizabal", "zhTW")
if L then
	L.first_ability = "烤肉釘或沸騰憎恨"
	L.dance_message = "劍刃之舞：>%d - 3<！"
end

