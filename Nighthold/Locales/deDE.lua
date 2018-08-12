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
	L.timeLeft = "%.1fs" -- s = seconds
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
end

L = BigWigs:NewBossLocale("Grand Magistrix Elisande", "deDE")
if L then
	L.elisande = "Elisande"

	L.ring_yell = "Die Wellen der Zeit spülen Euch fort!"
	L.orb_yell = "Ihr seht, die Zeit kann recht flüchtig sein."

	L.slowTimeZone = "Zone Langsame Zeit"
	L.fastTimeZone = "Zone Schnelle Zeit"

	L.boss_active = "Elisande Aktiv"
	L.boss_active_desc = "Zeit bis Elisande aktiv wird, nachdem die Trash-Phase abgeschlossen wurde."
	L.elisande_trigger = "Natürlich habe ich Eure Ankunft vorausgesehen. Das Schicksal, das Euch hierherführt. Euren verzweifelten Kampf gegen die Legion."
end

L = BigWigs:NewBossLocale("Gul'dan", "deDE")
if L then
	--L.warmup_trigger = "Have you forgotten" -- Have you forgotten your humiliation on the Broken Shore? How your precious high king was bent and broken before me? Will you beg for your lives as he did, whimpering like some worthless dog?

	L.empowered = "(A) %s" -- (E) Eye of Gul'dan
	L.gains = "Gul'dan erhält %s"
	L.p4_mythic_start_yell = "Zeit, die Seele des Dämonenjägers seinem Körper zurückzugeben... und der Legion einen Wirt zu nehmen!"

	L.nightorb_desc = "Beschwört eine Nachtkugel, beim Töten dieser Kugel erscheint eine Zeitzone."
	--L.timeStopZone = "Time Stop Zone"

	L.manifest_desc = "Beschwört ein Seelenfragment von Azzinoth, beim Töten des Fragments erscheint eine Dämonische Essenz."

	L.winds_desc = "Gul'dan beschwört Verheerende Winde, um die Spieler von der Plattform zu drücken."
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
	L.defender = "Astralverteidiger"
	L.weaver = "Weber der Dämmerwache"
	L.archmage = "Erzmagierin der Shal'dorei"
	L.manasaber = "Zahmer Manasäbler"
	L.naturalist = "Naturalist der Shal'dorei"

	--[[ Aluriel to Krosus ]]--
	L.infernal = "Sengende Höllenbestie"

	--[[ Aluriel to Tichondrius ]]--
	L.chaosmage = "Chaosmagier des Dämonenpakts"
	L.watcher = "Abgrundbeobachter"
end
