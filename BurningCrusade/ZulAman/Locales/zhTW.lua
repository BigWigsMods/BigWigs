local L = BigWigs:NewBossLocale("Zul'jin", "zhTW")
if not L then return end
if L then
	--L[42594] = "Bear Form" -- short form for "Essence of the Bear"
	--L[42607] = "Lynx Form"
	--L[42606] = "Eagle Form"
	--L[42608] = "Dragonhawk Form"
end

L = BigWigs:NewBossLocale("Halazzi", "zhTW")
if L then
	--L.spirit_message = "Spirit Phase"
	--L.normal_message = "Normal Phase"
end

L = BigWigs:NewBossLocale("Nalorakk", "zhTW")
if L then
	--L.troll_message = "Troll Form"
	L.troll_trigger = "沒有人可以擋在納羅拉克的面前!"
	L.bear_trigger = "你們既然將野獸召喚出來，就將付出更多的代價!"
end
