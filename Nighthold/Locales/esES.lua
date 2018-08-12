local L = BigWigs:NewBossLocale("Skorpyron", "esES") or BigWigs:NewBossLocale("Skorpyron", "esMX")
if not L then return end
if L then
	--L.blue = "Blue"
	--L.red = "Red"
	--L.green = "Green"
	--L.mode = "%s Mode"
end

L = BigWigs:NewBossLocale("Chronomatic Anomaly", "esES") or BigWigs:NewBossLocale("Chronomatic Anomaly", "esMX")
if L then
	--L.timeLeft = "%.1fs" -- s = seconds
end

L = BigWigs:NewBossLocale("Trilliax", "esES") or BigWigs:NewBossLocale("Trilliax", "esMX")
if L then
	--L.yourLink = "You are linked with %s"
	--L.yourLinkShort = "Linked with %s"
	--L.imprint = "Imprint"
end

L = BigWigs:NewBossLocale("Tichondrius", "esES") or BigWigs:NewBossLocale("Tichondrius", "esMX")
if L then
	--L.addsKilled = "Adds killed"
	--L.gotEssence = "Got Essence"

	--L.adds_desc = "Timers and warnings for the add spawns."
	--L.adds_yell1 = "Underlings! Get in here!"
	--L.adds_yell2 = "Show these pretenders how to fight!"
end

L = BigWigs:NewBossLocale("Krosus", "esES") or BigWigs:NewBossLocale("Krosus", "esMX")
if L then
	--L.leftBeam = "Left Beam"
	--L.rightBeam = "Right Beam"

	--L.goRight = "> GO RIGHT >"
	--L.goLeft = "< GO LEFT <"

	--L.smashingBridge = "Smashing Bridge"
	--L.smashingBridge_desc = "Slams which break the bridge. You can use this option to emphasize or enable countdown."

	--L.removedFromYou = "%s removed from you" -- "Searing Brand removed from YOU!"
end

L = BigWigs:NewBossLocale("Star Augur Etraeus", "esES") or BigWigs:NewBossLocale("Star Augur Etraeus", "esMX")
if L then
	--L.yourSign = "Your sign"
	--L.with = "with"
	--L[205429] = "|T1391538:15:15:0:0:64:64:4:60:4:60|t|cFFFFDD00Crab|r"
	--L[205445] = "|T1391537:15:15:0:0:64:64:4:60:4:60|t|cFFFF0000Wolf|r"
	--L[216345] = "|T1391536:15:15:0:0:64:64:4:60:4:60|t|cFF00FF00Hunter|r"
	--L[216344] = "|T1391535:15:15:0:0:64:64:4:60:4:60|t|cFF00DDFFDragon|r"
end

L = BigWigs:NewBossLocale("Grand Magistrix Elisande", "esES") or BigWigs:NewBossLocale("Grand Magistrix Elisande", "esMX")
if L then
	--L.elisande = "Elisande"

	--L.ring_yell = "Let the waves of time crash over you!"
	--L.orb_yell = "You'll find time can be quite volatile."

	--L.slowTimeZone = "Slow Time Zone"
	--L.fastTimeZone = "Fast Time Zone"

	--L.boss_active = "Elisande Active"
	--L.boss_active_desc = "Time until Elisande is active after clearing the trash event."
	--L.elisande_trigger = "I foresaw your coming, of course. The threads of fate that led you to this place. Your desperate attempt to stop the Legion."
end

L = BigWigs:NewBossLocale("Gul'dan", "esES") or BigWigs:NewBossLocale("Gul'dan", "esMX")
if L then
	--L.warmup_trigger = "Have you forgotten" -- Have you forgotten your humiliation on the Broken Shore? How your precious high king was bent and broken before me? Will you beg for your lives as he did, whimpering like some worthless dog?

	--L.empowered = "(E) %s" -- (E) Eye of Gul'dan
	--L.gains = "Gul'dan gains %s"
	--L.p4_mythic_start_yell = "Time to return the demon hunter's soul to his body... and deny the Legion's master a host!"

	--L.nightorb_desc = "Summons a Nightorb, killing it will spawn a Time Zone."
	--L.timeStopZone = "Time Stop Zone"

	--L.manifest_desc = "Summons a Soul Fragment of Azzinoth, killing it will spawn a Demonic Essence."

	--L.winds_desc = "Gul'dan summons Violent Winds to push the players off the platform."
end

L = BigWigs:NewBossLocale("Nighthold Trash", "esES") or BigWigs:NewBossLocale("Nighthold Trash", "esMX")
if L then
	--[[ Skorpyron to Trilliax ]]--
	--L.torm = "Torm the Brute"
	--L.fulminant = "Fulminant"
	--L.pulsauron = "Pulsauron"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	--L.sludgerax = "Sludgerax"

	--[[ Trilliax to Aluriel ]]--
	--L.karzun = "Kar'zun"
	--L.guardian = "Gilded Guardian"
	--L.battle_magus = "Duskwatch Battle-Magus"
	--L.chronowraith = "Chronowraith"
	--L.protector = "Nighthold Protector"

	--[[ Aluriel to Etraeus ]]--
	--L.jarin = "Astrologer Jarin"

	--[[ Aluriel to Telarn ]]--
	L.defender = "Defensor astral"
	--L.weaver = "Duskwatch Weaver"
	--L.archmage = "Shal'dorei Archmage"
	--L.manasaber = "Domesticated Manasaber"
	L.naturalist = "Naturalista shal'dorei"

	--[[ Aluriel to Krosus ]]--
	--L.infernal = "Searing Infernal"

	--[[ Aluriel to Tichondrius ]]--
	L.chaosmage = "Mago de caos jurapenas"
	--L.watcher = "Abyss Watcher"
end
