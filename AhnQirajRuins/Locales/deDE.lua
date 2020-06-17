local L = BigWigs:NewBossLocale("Kurinnaxx", "deDE")
if not L then return end
if L then
	L.bossName = "Kurinnaxx"
end

local L = BigWigs:NewBossLocale("General Rajaxx", "deDE")
if L then
	L.bossName = "General Rajaxx"

	L.wave = "Wellenwarnungen"
	L.wave_desc = "Warnung vor den ankommenden Gegner Wellen."

	L.wave_trigger1a = "Hier kommen sie. Bleibt am Leben, Welpen."
	L.wave_trigger1b = "Erinnerst du dich daran, Rajaxx, wann ich dir das letzte Mal sagte, ich w\195\188rde dich t\195\182ten?"
	L.wave_trigger3 = "Die Zeit der Vergeltung ist gekommen! Lasst uns die Herzen unserer Feinde mit Dunkelheit f\195\188llen!"
	L.wave_trigger4 = "Wir werden nicht l\195\164nger hinter verbarrikadierten Toren und Mauern aus Stein ausharren! Die Rache wird unser sein! Selbst die Drachen werden im Angesicht unseres Zornes erzittern!"
	L.wave_trigger5 = "Wir kennen keine Furcht! Und wir werden unseren Feinden den Tod bringen!"
	L.wave_trigger6 = "Staghelm wird winseln und um sein Leben betteln, genau wie sein r\195\164udiger Sohn! Eintausend Jahre der Ungerechtigkeit werden heute enden!"
	L.wave_trigger7 = "Fandral! Deine Zeit ist gekommen! Geh und verstecke dich im Smaragdgr\195\188nen Traum, und bete, dass wir dich nie finden werden!"
	L.wave_trigger8 = "Unversch\195\164mter Narr! Ich werde Euch h\195\182chstpers\195\182nlich t\195\182ten!"

	L.wave_message = "Welle (%d/8)"
end

local L = BigWigs:NewBossLocale("Moam", "deDE")
if L then
	L.bossName = "Moam"
end

local L = BigWigs:NewBossLocale("Buru the Gorger", "deDE")
if L then
	L.bossName = "Buru der Verschlinger"

	L.fixate = "Fixieren"
	L.fixate_desc = "Fixiert sich auf ein Ziel und ignoriert die Bedrohung anderer Angreifer."
end

local L = BigWigs:NewBossLocale("Ayamiss the Hunter", "deDE")
if L then
	L.bossName = "Ayamiss der Jäger"
end

local L = BigWigs:NewBossLocale("Ossirian the Unscarred", "deDE")
if L then
	L.bossName = "Ossirian der Narbenlose"

	L.debuff = "Schwäche"
	--L.debuff_desc = "Warn for various weakness types."
end

local L = BigWigs:NewBossLocale("Ruins of Ahn'Qiraj Trash", "deDE")
if L then
	L.guardian = "Beschützer des Anubisath"
end
