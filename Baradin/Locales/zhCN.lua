
local L = BigWigs:NewBossLocale("Argaloth", "zhCN")
if not L then return end
if L then
	L.darkness_message = "黑暗噬体！"
	L.firestorm_message = "即将 邪火风暴！"
	L.meteor_bar = "<流星猛击>"
end

L = BigWigs:NewBossLocale("Occu'thar", "zhCN")
if not L then return end
if L then
	L.shadows_bar = "<灼熱暗影>"
	L.destruction_bar = "<欧库塔尔的毁灭>"
	L.eyes_bar = "<欧库塔尔之眼>"

	L.fire_message = "Lazer, Pew Pew"
	L.fire_bar = "~Next Lazer"
end

