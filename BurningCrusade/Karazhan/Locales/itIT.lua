local L = BigWigs:NewBossLocale("Attumen the Huntsman Raid", "itIT")
if not L then return end
if L then
	--L.phase = "Phase"
	--L.phase_desc = "Warn when entering a new Phase."
	--L.phase2_trigger = "%s calls for her master!"
	--L.phase2_message = "Phase 2"
	--L.phase3_trigger = "Come Midnight, let's disperse this petty rabble!"
	--L.phase3_message = "Phase 3"
end

L = BigWigs:NewBossLocale("The Curator Raid", "itIT")
if L then
	--L.engage_trigger = "The Menagerie is for guests only."

	--L.weaken_message = "Evocation - Weakened for 20sec!"
	--L.weaken_fade_message = "Evocation Finished - Weakened Gone!"
	--L.weaken_fade_warning = "Evocation over in 5sec!"
end

L = BigWigs:NewBossLocale("Maiden of Virtue Raid", "itIT")
if L then
	--L.engage_trigger = "Your behavior will not be tolerated."
	--L.engage_message = "Maiden Engaged! Repentance in ~33sec"

	--L.repentance_message = "Repentance! Next in ~33sec"
	--L.repentance_warning = "Repentance Cooldown Over - Inc Soon!"
end

L = BigWigs:NewBossLocale("Prince Malchezaar", "itIT")
if L then
	--L.wipe_bar = "Respawn"

	--L.phase = "Engage"
	--L.phase_desc = "Alert when changing phases."
	--L.phase1_trigger = "Madness has brought you here to me. I shall be your undoing!"
	--L.phase2_trigger = "Simple fools! Time is the fire in which you'll burn!"
	--L.phase3_trigger = "How can you hope to stand against such overwhelming power?"
	--L.phase1_message = "Phase 1 - Infernal in ~40sec!"
	--L.phase2_message = "60% - Phase 2"
	--L.phase3_message = "30% - Phase 3 "

	--L.infernal = "Infernals"
	--L.infernal_desc = "Show cooldown timer for Infernal summons."
	--L.infernal_bar = "Incoming Infernal"
	--L.infernal_warning = "Infernal incoming in 20sec!"
	--L.infernal_message = "Infernal Landed! Hellfire in 5sec!"
	--L.infernal_trigger1 = "but the legions I command"
	--L.infernal_trigger2 = "All realities"
end

L = BigWigs:NewBossLocale("Moroes Raid", "itIT")
if L then
	--L.engage_trigger = "Hm, unannounced visitors. Preparations must be made..."
	--L.engage_message = "%s Engaged - Vanish in ~35sec!"
end

L = BigWigs:NewBossLocale("Netherspite", "itIT")
if L then
	--L.phase = "Phases"
	--L.phase_desc = "Warns when Netherspite changes from one phase to another."
	--L.phase1_message = "Withdrawal - Netherbreaths Over"
	--L.phase1_bar = "~Possible Withdrawal"
	--L.phase1_trigger = "%s cries out in withdrawal, opening gates to the nether."
	--L.phase2_message = "Rage - Incoming Netherbreaths!"
	--L.phase2_bar = "~Possible Rage"
	--L.phase2_trigger = "%s goes into a nether-fed rage!"

	--L.voidzone_warn = "Void Zone (%d)!"
end

L = BigWigs:NewBossLocale("Nightbane Raid", "itIT")
if L then
	--L.name = "Nightbane"

	--L.phase = "Phases"
	--L.phase_desc = "Warn when Nightbane switches between phases."
	--L.airphase_trigger = "Miserable vermin. I shall exterminate you from the air!"
	--L.landphase_trigger1 = "Enough! I shall land and crush you myself!"
	--L.landphase_trigger2 = "Insects! Let me show you my strength up close!"
	--L.airphase_message = "Flying!"
	--L.landphase_message = "Landing!"
	--L.summon_trigger = "An ancient being awakens in the distance..."

	--L.engage_trigger = "What fools! I shall bring a quick end to your suffering!"
end

L = BigWigs:NewBossLocale("Romulo & Julianne", "itIT")
if L then
	--L.name = "Romulo & Julianne"

	--L.phase = "Phases"
	--L.phase_desc = "Warn when entering a new Phase."
	--L.phase1_trigger = "What devil art thou, that dost torment me thus?"
	--L.phase1_message = "Act I - Julianne"
	--L.phase2_trigger = "Wilt thou provoke me? Then have at thee, boy!"
	--L.phase2_message = "Act II - Romulo"
	--L.phase3_trigger = "Come, gentle night; and give me back my Romulo!"
	--L.phase3_message = "Act III - Both"

	--L.poison = "Poison"
	--L.poison_desc = "Warn of a poisoned player."
	--L.poison_message = "Poisoned"

	--L.heal = "Heal"
	--L.heal_desc = "Warn when Julianne casts Eternal Affection."
	--L.heal_message = "Julianne casting Heal!"

	--L.buff = "Self-Buff Alert"
	--L.buff_desc = "Warn when Romulo & Julianne gain a self-buff."
	--L.buff1_message = "Romulo gains Daring!"
	--L.buff2_message = "Julianne gains Devotion!"
end

L = BigWigs:NewBossLocale("Shade of Aran", "itIT")
if L then
	--L.adds = "Elementals"
	--L.adds_desc = "Warn about the water elemental adds spawning."
	--L.adds_message = "Elementals Incoming!"
	--L.adds_warning = "Elementals Soon"
	--L.adds_bar = "Elementals despawn"

	--L.drink = "Drinking"
	--L.drink_desc = "Warn when Aran starts to drink."
	--L.drink_warning = "Low Mana - Drinking Soon!"
	--L.drink_message = "Drinking - AoE Polymorph!"
	--L.drink_bar = "Super Pyroblast Incoming"

	--L.blizzard = "Blizzard"
	--L.blizzard_desc = "Warn when Blizzard is being cast."
	--L.blizzard_message = "Blizzard!"

	--L.pull = "Pull/Super AE"
	--L.pull_desc = "Warn for the magnetic pull and Super Arcane Explosion."
	--L.pull_message = "Arcane Explosion!"
	--L.pull_bar = "Arcane Explosion"
end

L = BigWigs:NewBossLocale("Terestian Illhoof", "itIT")
if L then
	--L.engage_trigger = "^Ah, you're just in time."

	--L.weak = "Weakened"
	--L.weak_desc = "Warn for weakened state."
	--L.weak_message = "Weakened for ~45sec!"
	--L.weak_warning1 = "Weakened over in ~5sec!"
	--L.weak_warning2 = "Weakened over!"
	--L.weak_bar = "~Weakened Fades"
end

L = BigWigs:NewBossLocale("The Big Bad Wolf", "itIT")
if L then
	--L.name = "The Big Bad Wolf"

	--L.riding_bar = "%s Running"
end

L = BigWigs:NewBossLocale("The Crone", "itIT")
if L then
	--L.name = "The Crone"

	--L.engage_trigger = "^Oh Tito, we simply must find a way home!"

	--L.spawns = "Spawn Timers"
	--L.spawns_desc = "Timers for when the characters become active."
	--L.spawns_warning = "%s in 5 sec"

	--L.roar = "Roar"
	--L.tinhead = "Tinhead"
	--L.strawman = "Strawman"
	--L.tito = "Tito"
end

