local L = BigWigs:NewBossLocale("Zul'jin", "koKR")
if not L then return end
if L then
	--L[42594] = "Bear Form" -- short form for "Essence of the Bear"
	--L[42607] = "Lynx Form"
	--L[42606] = "Eagle Form"
	--L[42608] = "Dragonhawk Form"
end

L = BigWigs:NewBossLocale("Halazzi", "koKR")
if L then
	--L.spirit_message = "Spirit Phase"
	--L.normal_message = "Normal Phase"
end

L = BigWigs:NewBossLocale("Nalorakk", "koKR")
if L then
	--L.troll_message = "Troll Form"
	L.troll_trigger = "날로라크 나가신다!"
	L.bear_trigger = "너희들이 짐승을 불러냈다. 놀랄 준비나 해라!"
end
