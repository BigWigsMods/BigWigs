local L = BigWigs:NewBossLocale("Skorpyron", "deDE")
if not L then return end
if L then
	L.blue = "Blau"
	L.red = "Rot"
	L.green = "Grün"
	L.mode = "Modus %s"
end

L = BigWigs:NewBossLocale("Chronomatic Anomaly", "deDE")
if L then
	L.affected = "Betroffen"
	L.totalAbsorb = "Gesamte Absorption"
end

L = BigWigs:NewBossLocale("Trilliax", "deDE")
if L then
	L.yourLink = "Du bist mit %s verbunden"
	L.yourLinkShort = "Mit %s verbunden"
	L.imprint = "Prägung"
end

L = BigWigs:NewBossLocale("Tichondrius", "deDE")
if L then
	L.addsKilled = "Adds getöted"
	L.gotEssence = "Erhielt Essenz"

	L.adds_desc = "Timer und Warnungen für das Erscheinen der Adds."
	L.adds_yell1 = "Untertanen! Her zu mir!"
	L.adds_yell2 = "Zeigt diesen Amateuren, wie man kämpft!"
end

L = BigWigs:NewBossLocale("Krosus", "deDE")
if L then
	L.leftBeam = "Linker Strahl"
	L.rightBeam = "Rechter Strahl"

	L.goRight = "> GEH NACH RECHTS >"
	L.goLeft = "< GEH NACH LINKS <"

	L.smashingBridge = "Brücke zerschmettern"
	L.smashingBridge_desc = "Schläge, welche die Brücke zerstören. Du kannst diese Option zur Hervorhebung oder zur Aktivierung eines Countdowns verwenden."

	L.removedFromYou = "%s wurde von dir entfernt" -- "Searing Brand removed from YOU!"
end

L = BigWigs:NewBossLocale("Star Augur Etraeus", "deDE")
if L then
	L.yourSign = "Dein Zeichen"
	L.with = "mit"
	L[205429] = "|T1391538:15:15:0:0:64:64:4:60:4:60|t|cFFFFDD00Krabbe|r"
	L[205445] = "|T1391537:15:15:0:0:64:64:4:60:4:60|t|cFFFF0000Wolf|r"
	L[216345] = "|T1391536:15:15:0:0:64:64:4:60:4:60|t|cFF00FF00Jäger|r"
	L[216344] = "|T1391535:15:15:0:0:64:64:4:60:4:60|t|cFF00DDFFDrache|r"

	L.nameplate_requirement = "Diese Funktion wird momentan nur von KuiNameplates unterstützt. Nur für mythisch."

	L.custom_off_icy_ejection_nameplates = "{206936} auf Namensplaketten Verbündeter zeigen" -- Icy Ejection
	L.custom_off_icy_ejection_nameplates_desc = L.nameplate_requirement

	L.custom_on_fel_ejection_nameplates = "{205649} auf Namensplaketten Verbündeter zeigen" -- Fel Ejection
	L.custom_on_fel_ejection_nameplates_desc = L.nameplate_requirement

	L.custom_on_gravitational_pull_nameplates = "{214335} auf Namensplaketten Verbündeter zeigen" -- Gravitational Pull
	L.custom_on_gravitational_pull_nameplates_desc = L.nameplate_requirement

	L.custom_on_grand_conjunction_nameplates = "{205408} auf Namensplaketten Verbündeter zeigen" -- Grand Conjunction
	L.custom_on_grand_conjunction_nameplates_desc = L.nameplate_requirement
end

L = BigWigs:NewBossLocale("Grand Magistrix Elisande", "deDE")
if L then
	L.elisande = "Elisande"

	L.ring_yell = "Die Wellen der Zeit spülen Euch fort!"
	L.orb_yell = "Ihr seht, die Zeit kann recht flüchtig sein."

	L.fastTimeZone = "Zone Schnelle Zeit"
end

L = BigWigs:NewBossLocale("Gul'dan", "deDE")
if L then
	L[211152] = "(A) %s" -- (E) Eye of Gul'dan
	L.gains = "Gul'dan erhält %s"
	--L.p4_mythic_start_yell = "Time to return the demon hunter's soul to his body... and deny the Legion's master a host!"

	L.nightorb_desc = "Beschwört eine Nachtkugel, beim Töten dieser Kugel erscheint eine Zeitzone"

	L.manifest_desc = "Beschwört ein Seelenfragment von Azzinoth, beim Töten des Fragments erscheint eine Dämonische Essenz"
end

L = BigWigs:NewBossLocale("Nighthold Trash", "deDE")
if L then
	--[[ Skorpyron to Trilliax ]]--
	L.torm = "Torm der Schläger"
	L.fulminant = "Fulminant"
	L.pulsauron = "Pulsauron"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	L.sludgerax = "Schlickrax"

	--[[ Trilliax to Aluriel ]]--
	L.karzun = "Kar'zun"
	L.guardian = "Vergoldeter Wächter"
	L.battle_magus = "Kampfmagus der Dämmerwache"
	L.chronowraith = "Chronogespenst"
	L.protector = "Beschützer der Nachtfestung"

	--[[ Aluriel to Etraeus ]]--
	L.jarin = "Astrologe Jarin"

	--[[ Aluriel to Telarn ]]--
	L.weaver = "Weber der Dämmerwache"
	L.archmage = "Erzmagierin der Shal'dorei"
	L.manasaber = "Zahmer Manasäbler"

	--[[ Aluriel to Krosos ]]--
	L.infernal = "Sengende Höllenbestie"

	--[[ Aluriel to Tichondrius ]]--
	L.watcher = "Abgrundbeobachter"
end

