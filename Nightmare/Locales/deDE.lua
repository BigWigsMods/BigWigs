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
	L.custom_off_deathglare_marker = "Todesblicktentakel markieren"
	L.custom_off_deathglare_marker_desc = "Markiert Todesblicktentakel mit {rt6}{rt5}{rt4}{rt3}, benötigt Leiter oder Assistent.\n|cFFFF0000Nur eine Person im Schlachtzug sollte diese Option aktiviert haben, um Markierungskonflikte zu verhindern.|r\n|cFFADFF2FTIP: Wenn der Schlachtzug sich dafür entschieden hat, dass du diese Option aktivierst, ist der schnellste Weg mit der Maus über die Mobs zu fahren, um sie zu markieren.|r"

	L.bloods_remaining = "%d Blut verbleibend"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "deDE")
if L then
	L.gelatinizedDecay = "Verrottender Schleim"
	L.befouler = "Pestherzbesudler"
	L.shaman = "Terrorschamane"
	L.custom_on_mark_totem = "Totems markieren"
	L.custom_on_mark_totem_desc = "Markiert die Totems mit {rt8}{rt7}, benötigt Leiter oder Assistent."
end

L = BigWigs:NewBossLocale("Ursoc", "deDE")
if L then
	L.custom_on_gaze_assist = "Hilfe für Fokussierter Blick"
	L.custom_on_gaze_assist_desc = "Zeigt Schlachtzugssymbole in Leisten und Nachrichten für Fokussierter Blick. Verwendet {rt4} für ungerade, {rt6} für gerade Blicke (Blicke werden durchnummeriert). Benötigt Leiter oder Assistent."
end

L = BigWigs:NewBossLocale("Xavius", "deDE")
if L then
	L.custom_off_blade_marker = "Alptraumklingen markieren"
	L.custom_off_blade_marker_desc = "Markiert die Ziele von Alptraumklingen mit {rt1}{rt2}, benötigt Leiter oder Assistent."

	L.linked = "Schreckensbindungen auf DIR! – Verbunden mit %s!"
end
