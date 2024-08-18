local L = BigWigs:NewBossLocale("Eranog", "esES")
if not L then return end
if L then
	-- L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	-- L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Frenzied Tarasek that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	-- L.molten_cleave = "Frontal"
	-- L.molten_spikes = "Spikes"
	-- L.collapsing_army = "Army"
	-- L.greater_flamerift = "Mythic Add"
	-- L.leaping_flames = "Flames"
end

L = BigWigs:NewBossLocale("Terros", "esES")
if L then
	-- L.resonating_annihilation = "Annihilation"
	-- L.awakened_earth = "Pillar"
	-- L.shattering_impact = "Slam"
	-- L.concussive_slam = "Tank Line"
	-- L.infused_fallout = "Dust"

	--L.custom_on_repeating_fallout = "Repeating Infused Fallout"
	--L.custom_on_repeating_fallout_desc = "Repeating Infused Fallout say messages with icon {rt7} to find a partner."
end

L = BigWigs:NewBossLocale("The Primal Council", "esES")
if L then
	-- L.primal_blizzard = "Blizzard" -- Primal Blizzard
	-- L.earthen_pillars = "Pillars" -- Earthen Pillars
	-- L.meteor_axes = "Axes" -- Meteor Axes
	-- L.meteor_axe = "Axe" -- Singular
	-- L.meteor_axes_melee = "Melee Axe"
	-- L.meteor_axes_ranged = "Ranged Axe"

	-- L.skipped_cast = "Skipped %s (%d)"
end

L = BigWigs:NewBossLocale("Sennarth, The Cold Breath", "esES")
if L then
	-- L.ascend = "Ascend"
	-- L.ascend_desc = "Sennarth ascends the room towards the frozen percipice."
	-- L.chilling_blast = "Spread"
	-- L.freezing_breath = "Add Breath"
	-- L.webs = "Webs"
	-- L.web = "Web"
	-- L.gossamer_burst = "Grip"
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "esES")
if L then
	-- L.raging_burst = "New Tornadoes"
	-- L.cyclone = "Pull In"
	-- L.crosswinds = "Moving Tornadoes"
end

L = BigWigs:NewBossLocale("Kurog Grimtotem", "esES")
if L then
	-- -- Types
	-- L.damage = "Damage Skills"
	-- L.damage_desc = "Display timers for Damage abilities (Magma Burst, Biting Chill, Enveloping Earth, Lightning Crash) when we don't know what alter the boss is at."
	-- L.damage_bartext = "%s [Dmg]" -- {Spell} [Dmg]

	-- L.avoid = "Avoid Skills"
	-- L.avoid_desc = "Display timers for Avoid abilities (Molten Rupture, Frigid Torrent, Erupting Bedrock, Shocking Burst) when we don't know what alter the boss is at."
	-- L.avoid_bartext = "%s [Avoid]" -- {Spell} [Avoid]

	-- L.ultimate = "Ultimate Skills"
	-- L.ultimate_desc = "Display timers for Ultimate abilities (Searing Carnage, Absolute Zero, Seismic Rupture, Thundering Strike) when we don't know what alter the boss is at."
	-- L.ultimate_bartext = "%s [Ult]" -- {Spell} [Ult]

	L.add_bartext = "%s [Add]" -- "{Spell} [Add]"

	L.Fire = "Fuego"
	L.Frost = "Escarcha"
	L.Earth = "Tierra"
	L.Storm = "Tormenta"

	-- Fire
	-- L.molten_rupture = "Waves"
	-- L.searing_carnage = "Dance"
	-- L.raging_inferno = "Soak Pools"

	-- Frost
	-- L.biting_chill = "Chill DoT"
	-- L.absolute_zero_melee = "Melee Soak"
	-- L.absolute_zero_ranged = "Ranged Soak"

	-- Earth
	-- L.erupting_bedrock = "Quakes"

	-- Storm
	-- L.lightning_crash = "Zaps"

	-- General
	-- L.primal_attunement = "Soft Enrage"

	-- Stage 2
	-- L.violent_upheaval = "Pillars"
end

L = BigWigs:NewBossLocale("Broodkeeper Diurna", "esES")
if L then
	-- L.eggs_remaining = "%d Eggs Remaining!"
	-- L.broodkeepers_bond = "Eggs Remaining"
	-- L.greatstaff_of_the_broodkeeper = "Greatstaff"
	-- L.clutchwatchers_rage = "Rage"
	-- L.rapid_incubation = "Infuse Eggs"
	-- L.broodkeepers_fury = "Fury"
	-- L.frozen_shroud = "Root Absorb"
	-- L.detonating_stoneslam = "Tank Soak"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "esES")
if L then
	-- L.lighting_devastation_trigger = "deep breath" -- Raszageth takes a deep breath...

	-- Stage One: The Winds of Change
	-- L.volatile_current = "Sparks"
	-- L.thunderous_blast = "Blast"
	-- L.lightning_strikes = "Strikes"
	-- L.electric_scales = "Raid Damage"
	-- L.electric_lash = "Lash"
	-- Stage Two: Surging Power
	-- L.absorb_text = "%s (%.0f%%)"
	-- L.stormsurge = "Absorb Shield"
	-- L.stormcharged = "Positive or Negative"
	-- L.positive = "Positive"
	-- L.negative = "Negative"
	-- L.focused_charge = "Damage Buff"
	-- L.tempest_wing = "Storm Wave"
	-- L.fulminating_charge = "Charges"
	-- L.fulminating_charge_debuff = "Charge"
	-- Intermission: The Vault Falters
	-- L.ball_lightning = "Balls"
	-- Stage Three: Storm Incarnate
	-- L.magnetic_charge = "Pull Charge"

	-- L.custom_on_repeating_stormcharged = "Repeating Positive or Negative"
	-- L.custom_on_repeating_stormcharged_desc = "Repeating Positive or Negative say messages with icons {rt1}, {rt3} to find matches to remove your debuffs."

	-- L.skipped_cast = "Skipped %s (%d)"

	-- L.custom_off_raidleader_devastation = "Lighting Devastation: Leader Mode"
	-- L.custom_off_raidleader_devastation_desc = "Show a bar for the Lighting Devastation (Breath) on the other side as well."
	-- L.breath_other = "%s [Opposite]" -- Breath on opposite platform
end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "esES")
if L then

end
