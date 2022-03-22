local L = BigWigs:NewBossLocale("Zul'jin", "ruRU")
if not L then return end
if L then
	--L[42594] = "Bear Form" -- short form for "Essence of the Bear"
	--L[42607] = "Lynx Form"
	--L[42606] = "Eagle Form"
	--L[42608] = "Dragonhawk Form"
end

L = BigWigs:NewBossLocale("Halazzi", "ruRU")
if L then
	--L.spirit_message = "Spirit Phase"
	--L.normal_message = "Normal Phase"
end

L = BigWigs:NewBossLocale("Nalorakk", "ruRU")
if L then
	--L.troll_message = "Troll Form"
	L.troll_trigger = "Пропустите Налоракка!"
	L.bear_trigger = "Если вызвать чудище, то мало не покажется, точно говорю!"
end
