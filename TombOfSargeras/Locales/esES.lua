local L = BigWigs:NewBossLocale("Harjatan the Bludger", "esES") or BigWigs:NewBossLocale("Harjatan the Bludger", "esMX")
if not L then return end
if L then
	--L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	--L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
end

L = BigWigs:NewBossLocale("Demonic Inquisition", "esES") or BigWigs:NewBossLocale("Demonic Inquisition", "esMX")
if L then
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
end

L = BigWigs:NewBossLocale("Fallen Avatar", "esES") or BigWigs:NewBossLocale("Fallen Avatar", "esMX")
if L then
	--L.touch_impact = "Touch Impact" -- Touch of Sargeras Impact (short)

	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Fallen Avatar randomizes which off-cooldown ability he uses next. When this option is enabled, the bars for those abilities will stay on your screen."

	--L.energy_leak = "Energy Leak"
	--L.energy_leak_desc = "Display a warning when energy has leaked onto the boss in stage 1."
	--L.energy_leak_msg = "Energy Leak! (%d)"
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
	L.sentry = "Centinela guardián"
	L.acolyte = "Acólita fantasmal"
end
