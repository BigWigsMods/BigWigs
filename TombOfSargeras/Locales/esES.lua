local L = BigWigs:NewBossLocale("Harjatan the Bludger", "esES") or BigWigs:NewBossLocale("Harjatan the Bludger", "esMX")
if not L then return end
if L then
	--L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	--L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
end

L = BigWigs:NewBossLocale("Demonic Inquisition", "esES") or BigWigs:NewBossLocale("Demonic Inquisition", "esMX")
if L then
	--L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	--L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."

	--L.infobox_title_prisoners = "%d |4Prisoner:Prisoners;"

	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Demonic Inquisition has some spells which are delayed by interupts/other casts. When this option is enabled, the bars for those abilities will stay on your screen."
end

L = BigWigs:NewBossLocale("Mistress Sassz'ine", "esES") or BigWigs:NewBossLocale("Mistress Sassz'ine", "esMX")
if L then
	--L.inks_fed_count = "Ink (%d/%d)"
	--L.inks_fed = "Inks fed: %s" -- %s = List of players
end

L = BigWigs:NewBossLocale("The Desolate Host", "esES") or BigWigs:NewBossLocale("The Desolate Host", "esMX")
if L then
	--L.infobox_players = "Players"
	--L.armor_remaining = "%s Remaining (%d)" -- Bonecage Armor Remaining (#)
	--L.custom_on_mythic_armor = "Ignore Bonecage Armor on Reanimated Templars in Mythic Difficulty"
	--L.custom_on_mythic_armor_desc = "Leave this option enabled if you are offtanking Reanimated Templars to ignore warnings and counting the Bonecage Armor on the Ranimated Templars"
	--L.custom_on_armor_plates = "Bonecage Armor icon on Enemy Nameplate"
	--L.custom_on_armor_plates_desc = "Show an icon on the nameplate of Reanimated Templars who have Bonecage Armor.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
	--L.tormentingCriesSay = "Cries" -- Tormenting Cries (short say)
end

L = BigWigs:NewBossLocale("Maiden of Vigilance", "esES") or BigWigs:NewBossLocale("Maiden of Vigilance", "esMX")
if L then
	--L.infusionChanged = "Infusion CHANGED: %s"
	--L.sameInfusion = "Same Infusion: %s"
	--L.fel = "Fel"
	--L.light = "Light"
	--L.felHammer = "Fel Hammer" -- Better name for "Hammer of Obliteration"
	--L.lightHammer = "Light Hammer" -- Better name for "Hammer of Creation"
	--L.absorb = "Absorb"
	--L.absorb_text = "%s (|cff%s%.0f%%|r)"
	--L.cast = "Cast"
	--L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
	--L.stacks = "Stacks"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "esES") or BigWigs:NewBossLocale("Fallen Avatar", "esMX")
if L then
	--L.touch_impact = "Touch Impact" -- Touch of Sargeras Impact (short)

	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Fallen Avatar randomizes which off-cooldown ability he uses next. When this option is enabled, the bars for those abilities will stay on your screen."

	--L.energy_leak = "Energy Leak"
	--L.energy_leak_desc = "Display a warning when energy has leaked onto the boss in stage 1."
	--L.energy_leak_msg = "Energy Leak! (%d)"

	--L.warmup_trigger = "The husk before you" -- The husk before you was once a vessel for the might of Sargeras. But this temple itself is our prize. The means by which we will reduce your world to cinders!

	--L.absorb = "Absorb"
	--L.absorb_text = "%s (|cff%s%.0f%%|r)"
	--L.cast = "Cast"
	--L.cast_text = "%.1fs (|cff%s%.0f%%|r)" -- s = seconds
end

L = BigWigs:NewBossLocale("Kil'jaeden", "esES") or BigWigs:NewBossLocale("Kil'jaeden", "esMX")
if L then
	--L.singularityImpact = "Singularity Impact"
	--L.obeliskExplosion = "Obelisk Explosion"
	--L.obeliskExplosion_desc = "Timer for the Obelisk Explosion"

	--L.darkness = "Darkness" -- Shorter name for Darkness of a Thousand Souls (238999)
	--L.reflectionErupting = "Reflection: Erupting" -- Shorter name for Shadow Reflection: Erupting (236710)
	--L.reflectionWailing = "Reflection: Wailing" -- Shorter name for Shadow Reflection: Wailing (236378)
	--L.reflectionHopeless = "Reflection: Hopeless" -- Shorter name for Shadow Reflection: Hopeless (237590)

	--L.rupturingKnock = "Rupturing Singularity Knockback"
	--L.rupturingKnock_desc = "Show a timer for the knockback"

	--L.meteorImpact_desc = "Show a timer for the Meteors landing"

	--L.shadowsoul = "Shadowsoul Health Tracker"
	--L.shadowsoul_desc = "Show the info box displaying the current health of the 5 Shadowsoul adds."

	--L.custom_on_track_illidan = "Automatically Track Humanoids"
	--L.custom_on_track_illidan_desc = "If you are a hunter or a feral druid, this option will automatically enable tracking of humanoids so you can track Illidan."

	--L.custom_on_zoom_in = "Automatically Zoom Minimap"
	--L.custom_on_zoom_in_desc = "This feature will set the minimap zoom to level 4 to make it easier to track Illidan, and then restore it to your previous level once the stage has ended."
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "esES") or BigWigs:NewBossLocale("Tomb of Sargeras Trash", "esMX")
if L then
	L.rune = "Runa orca"
	L.chaosbringer = "Portador de caos infernal"
	L.rez = "Rez el Vigilatumbas"
	L.erduval = "Erdu'val"
	L.varah = "Señora de hipogrifos Varah"
	L.seacaller = "Clamamares Marescama"
	L.custodian = "Custodio submarino"
	L.dresanoth = "Dresanoth"
	L.stalker = "El acechador siniestro"
	L.darjah = "Señor de la guerra Darjah"
	L.sentry = "Centinela guardián"
	L.acolyte = "Acólita fantasmal"
	L.ryul = "Ryul el Marchito"
	L.countermeasure = "Contramedida defensiva"
end
