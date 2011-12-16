
local L = BigWigs:NewBossLocale("Argaloth", "zhCN")
if not L then return end
if L then
	L.darkness_message = "黑暗噬体！"
	L.firestorm_message = "即将 邪火风暴！"
end

L = BigWigs:NewBossLocale("Occu'thar", "zhCN")
if not L then return end
if L then
	L.shadows_bar = "灼热暗影"
	L.destruction_bar = "欧库塔尔的毁灭"
	L.eyes_bar = "欧库塔尔之眼"

	L.fire_message = "集火！"
	L.fire_bar = "下一集火"
end

L = BigWigs:NewBossLocale("Alizabal", "zhCN")
if L then
	L.first_ability = "刺穿或沸腾之怨"
	L.dance_message = "刃舞：>%d - 3<！"
end

