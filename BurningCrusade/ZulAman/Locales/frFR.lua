local L = BigWigs:NewBossLocale("Zul'jin", "frFR")
if not L then return end
if L then
	--L[42594] = "Bear Form" -- short form for "Essence of the Bear"
	--L[42607] = "Lynx Form"
	--L[42606] = "Eagle Form"
	--L[42608] = "Dragonhawk Form"
end

L = BigWigs:NewBossLocale("Halazzi", "frFR")
if L then
	--L.spirit_message = "Spirit Phase"
	--L.normal_message = "Normal Phase"
end

L = BigWigs:NewBossLocale("Nalorakk", "frFR")
if L then
	--L.troll_message = "Troll Form"
	L.troll_trigger = "Place, voilà le Nalorakk !"
	L.bear_trigger = "Vous d'mandez la bête, j'vais vous donner la bête !"
end
