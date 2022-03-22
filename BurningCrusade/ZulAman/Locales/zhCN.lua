local L = BigWigs:NewBossLocale("Zul'jin", "zhCN")
if not L then return end
if L then
	L[42594] = "野熊之形" -- short form for "Essence of the Bear"
	L[42607] = "山猫之形"
	L[42606] = "雄鹰之形"
	L[42608] = "龙鹰之形"
end

L = BigWigs:NewBossLocale("Halazzi", "zhCN")
if L then
	L.spirit_message = "灵魂阶段"
	L.normal_message = "一般阶段"
end

L = BigWigs:NewBossLocale("Nalorakk", "zhCN")
if L then
	L.troll_message = "巨魔之形"
	L.troll_trigger = "纳洛拉克，变形，出发！"
	L.bear_trigger = "你们召唤野兽？你马上就要大大的后悔了！"
end
