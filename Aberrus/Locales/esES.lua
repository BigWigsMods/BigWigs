local L = BigWigs:NewBossLocale("Kazzara, the Hellforged", "esES")
if not L then return end
if L then
	--L.dread_rift = "Rift" -- Singular Dread Rift
end

L = BigWigs:NewBossLocale("The Amalgamation Chamber", "esES")
if L then
	--L.custom_on_fade_out_bars = "Fade out stage 1 bars"
	--L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the boss that is out of range in stage 1."

	--L.coalescing_void = "Run Away"
	--L.shadow_convergence = "Orbs"
	--L.molten_eruption = "Soaks"
	--L.swirling_flame = "Tornadoes"
	--L.gloom_conflagration = "Meteor + Run Away"
	--L.blistering_twilight = "Bombs + Tornadoes"
	--L.convergent_eruption = "Soaks + Orbs"
	--L.shadowflame_burst = "Frontal Cone"

	--L.shadow_and_flame = "Mythic Debuffs"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "esES")
if L then
	--L.rending_charge_single = "First Charge"
	--L.massive_slam = "Frontal Cone"
	--L.unstable_essence_new = "New Bomb"
	--L.custom_on_unstable_essence_high = "High Stacks Unstable Essence Say Messages"
	--L.custom_on_unstable_essence_high_desc = "Say messages with the amount of stacks for your Unstable Essence debuff when they are high enough."
	--L.volatile_spew = "Dodges"
	--L.volatile_eruption = "Eruption"
	--L.temporal_anomaly = "Heal Orb"
	--L.temporal_anomaly_knocked = "Heal Orb Knocked"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "esES")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	--L.zaqali_aide_north_emote_trigger = "northern battlement" -- Commanders ascend the northern battlement!
	--L.zaqali_aide_south_emote_trigger = "southern battlement" -- Commanders ascend the southern battlement!

	--L.north = "North"
	--L.south = "South"
	--L.both = "Both"

	--L.zaqali_aide_message = "%s Climbing %s" -- Big Adds Climbing North
	L.add_bartext = "%s: %s (%d)"
	--L.boss_returns = "Boss Lands: North"

	L.molten_barrier = "Barrera"
	--L.catastrophic_slam = "Door Slam"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "esES")
if L then
	--L.doom_flames = "Small Soaks"
	--L.shadowlave_blast = "Frontal Cone"
	--L.charged_smash = "Big Soak"
	--L.energy_gained = "Energy Gained: %d"

	-- Mythic
	--L.unleash_shadowflame = "Mythic Orbs"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "esES")
if L then
	--L.tactical_destruction = "Dragonheads"
	--L.bombs_soaked = "Bombs Soaked" -- Bombs Soaked (2/4)
	--L.unstable_embers = "Embers"
	--L.unstable_ember = "Ember"
end

L = BigWigs:NewBossLocale("Magmorax", "esES")
if L then
	--L.energy_gained = "Energy Gained (-17s)" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

	-- Mythic
	--L.explosive_magma = "Soak Pool"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "esES")
if L then
	--L.custom_on_repeating_sunder_reality = "Repeating Sunder Reality Warning"
	--L.custom_on_repeating_sunder_reality_desc = "Repeat a message during the Ebon Destruction cast until you get inside a portal."

	--L.twisted_earth = "Walls"
	--L.echoing_fissure = "Fissure"
	--L.rushing_darkness = "Knock Lines"

	--L.umbral_annihilation = "Annihilation"
	--L.sunder_reality = "Portals"
	--L.ebon_destruction = "Big Bang"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "esES")
if L then
	--L.claws = "Tank Debuff" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	--L.claws_debuff = "Tank Explodes"
	--L.emptiness_between_stars = "Emptiness"
	--L.void_slash = "Tank Frontal"

	--L.boss_immune = "Boss Immune"
	--L.ebon_might = "Adds Immune"
end
