local L = BigWigs:NewBossLocale("Zul'jin", "esES") or BigWigs:NewBossLocale("Zul'jin", "esMX")
if not L then return end
if L then
	--L[42594] = "Bear Form" -- short form for "Essence of the Bear"
	--L[42607] = "Lynx Form"
	--L[42606] = "Eagle Form"
	--L[42608] = "Dragonhawk Form"
end

L = BigWigs:NewBossLocale("Halazzi", "esES") or BigWigs:NewBossLocale("Halazzi", "esMX")
if L then
	--L.spirit_message = "Spirit Phase"
	--L.normal_message = "Normal Phase"
end

L = BigWigs:NewBossLocale("Nalorakk", "esES") or BigWigs:NewBossLocale("Nalorakk", "esMX")
if L then
	--L.troll_message = "Troll Form"
	L.troll_trigger = "¡Dejad paso al Nalorakk!"
	L.bear_trigger = "¡Si llamáis a la bestia, vais a recibir más de lo que esperáis!"
end
