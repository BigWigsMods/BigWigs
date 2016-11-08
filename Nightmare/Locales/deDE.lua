local L = BigWigs:NewBossLocale("Cenarius", "deDE")
if not L then return end
if L then
	L.forces = "Mächte"
	L.bramblesSay = "Gestrüpp bei %s"
	L.custom_off_multiple_breath_bar = "Mehrere Leisten für Fauler Atem anzeigen"
	L.custom_off_multiple_breath_bar_desc = "Standardmäßig zeigt BigWigs nur die Leiste für den faulen Atem eines Drachens. Aktiviere diese Option, wenn du einen Timer pro Drachen sehen willst."
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "deDE")
if L then
	L.isLinkedWith = "%s ist mit %s verbunden"
	L.yourLink = "Du bist mit %s verbunden"
	L.yourLinkShort = "Verbunden mit %s"
end

L = BigWigs:NewBossLocale("Il'gynoth", "deDE")
if L then
	L.remaining = "Verbleibend"
	L.missed = "Verpasst"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "deDE")
if L then
	L.gelatinizedDecay = "Verrottender Schleim"
	L.befouler = "Pestherzbesudler"
	L.shaman = "Terrorschamane"
end

L = BigWigs:NewBossLocale("Ursoc", "deDE")
if L then
	L.custom_on_gaze_assist = "Hilfe für Fokussierter Blick"
	L.custom_on_gaze_assist_desc = "Zeigt Schlachtzugssymbole in Leisten und Nachrichten für Fokussierter Blick. Verwendet {rt4} für ungerade, {rt6} für gerade Blicke (Blicke werden durchnummeriert). Benötigt Leiter oder Assistent."
end

L = BigWigs:NewBossLocale("Xavius", "deDE")
if L then
	L.linked = "Schreckensbindungen auf DIR! – Verbunden mit %s!"
	L.dreamHealers = "Traumheiler"
end
