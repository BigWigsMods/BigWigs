local L = BigWigs:NewBossLocale("The Stone Guard", "deDE")
if not L then return end
if L then
	L.petrifications = "Versteinerung"
	L.petrifications_desc = "Warnung, wenn einer der Bosse Versteinerung wirkt."

	L.overload = "Überladung"
	L.overload_desc = "Warnugen für alle Arten von Überladungen."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "deDE")
if L then
	L.phases = "Phasen"
	L.phases_desc = "Warnungen für Phasenwechsel"

	L.phase_lightning_trigger = "Oh, großer Geist! Gewährt mir die Macht der Erde!"
	L.phase_flame_trigger = "Oh, Erhabener! Durch mich sollt Ihr das Fleisch von den Knochen schmelzen!"
	L.phase_arcane_trigger =  "Oh, Weiser der Zeitalter! Vertraut mir Euer arkanes Wissen an!"
	L.phase_shadow_trigger = "Große Seele vergangener Helden! Reicht mir euer Schild!"		-- ATTENTION! Guessed translation since I did not see the hardmode with the german client. Most probably wrong! Review!

	L.phase_lightning = "Blitzphase!"
	L.phase_flame = "Feuerphase!"
	L.phase_arcane = "Arkanphase!"
	L.phase_shadow = "Schattenphase!"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "deDE")
if L then
	L.frenzy = "Raserei bald!"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "deDE")
if L then
	L.shield_removed = "Schild entfernt!"
end

L = BigWigs:NewBossLocale("Elegon", "deDE")
if L then
	L.floor_despawn = "Boden verschwindet"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "deDE")
if L then
	L.rage_trigger = "Der Zorn des Kaisers schallt durch die Berge."
	L.strength_trigger = "Die Stärke des Kaisers erscheint in den Erkern!"
	L.courage_trigger = "Der Mut des Kaisers erscheint in den Erkern!"
	L.bosses_trigger = "In den riesigen Erkern erscheinen zwei Titanenkonstrukte!"
end

