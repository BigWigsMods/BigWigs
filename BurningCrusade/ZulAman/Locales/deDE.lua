local L = BigWigs:NewBossLocale("Zul'jin", "deDE")
if not L then return end
if L then
	L[42594] = "Bärenform" -- short form for "Essence of the Bear"
	L[42607] = "Fuchsform"
	L[42606] = "Adlerform"
	L[42608] = "Drachenfalkenform"
end

L = BigWigs:NewBossLocale("Halazzi", "deDE")
if L then
	L.spirit_message = "Geisterphase"
	L.normal_message = "Normale Phase"
end

L = BigWigs:NewBossLocale("Nalorakk", "deDE")
if L then
	L.troll_message = "Trollform"
	L.troll_trigger = "Macht Platz für Nalorakk!"
	L.bear_trigger = "Ihr provoziert die Bestie, jetzt werdet Ihr sie kennenlernen!"
end
