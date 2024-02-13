local L = BigWigs:NewBossLocale("The Amalgamation Chamber", "esMX")
if not L then return end
if L then
	--L.custom_on_fade_out_bars = "Fade out stage 1 bars"
	--L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the boss that is out of range in stage 1."

	--L.coalescing_void = "Run Away"

	--L.shadow_and_flame = "Mythic Debuffs"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "esMX")
if L then
	--L.rending_charge_single = "First Charge"
	--L.unstable_essence_new = "New Bomb"
	--L.custom_on_unstable_essence_high = "High Stacks Unstable Essence Say Messages"
	--L.custom_on_unstable_essence_high_desc = "Say messages with the amount of stacks for your Unstable Essence debuff when they are high enough."
	--L.volatile_spew = "Dodges"
	--L.volatile_eruption = "Eruption"
	--L.temporal_anomaly_knocked = "Heal Orb Knocked"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "esMX")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	--L.zaqali_aide_north_emote_trigger = "northern battlement" -- Commanders ascend the northern battlement!
	--L.zaqali_aide_south_emote_trigger = "southern battlement" -- Commanders ascend the southern battlement!

	--L.both = "Both"
	--L.zaqali_aide_message = "%s Climbing %s" -- Big Adds Climbing North
	L.add_bartext = "%s: %s (%d)"
	--L.boss_returns = "Boss Lands: North"

	L.molten_barrier = "Barrera"
	--L.catastrophic_slam = "Door Slam"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "esMX")
if L then
	--L.doom_flames = "Small Soaks"
	--L.charged_smash = "Big Soak"
	--L.energy_gained = "Energy Gained: %d"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "esMX")
if L then
	--L.tactical_destruction = "Dragonheads"
	--L.bombs_soaked = "Bombs Soaked" -- Bombs Soaked (2/4)
	--L.unstable_embers = "Embers"
	--L.unstable_ember = "Ember"
end

L = BigWigs:NewBossLocale("Magmorax", "esMX")
if L then
	--L.energy_gained = "Energy Gained (-17s)" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

	-- Mythic
	--L.explosive_magma = "Soak Pool"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "esMX")
if L then
	--L.twisted_earth = "Walls"
	--L.echoing_fissure = "Fissure"
	--L.rushing_darkness = "Knock Lines"

	--L.umbral_annihilation = "Annihilation"
	--L.ebon_destruction = "Big Bang"

	--L.wall_breaker = "Wall Breaker (Mythic)"
	--L.wall_breaker_desc = "A player targeted by Rushing Darkness will be chosen as the wall breaker. They will be marked ({rt6}) and send a message in say chat. This is restricted to Mythic difficulty on stage 1."
	--L.wall_breaker_message = "Wall Breaker"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "esMX")
if L then
	--L.claws = "Tank Debuff" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	--L.claws_debuff = "Tank Explodes"
	--L.emptiness_between_stars = "Emptiness"
	--L.void_slash = "Tank Frontal"

	--L.ebon_might = "Adds Immune"
end

L = BigWigs:NewBossLocale("Aberrus, the Shadowed Crucible Trash", "esMX")
if L then
	--L.edgelord = "Sundered Edgelord" -- NPC 198873
	--L.naturalist = "Sundered Naturalist" -- NPC 201746
	--L.siegemaster = "Sundered Siegemaster" -- NPC 198874
	--L.banner = "Banner" -- Short for "Sundered Flame Banner" NPC 205638
	--L.arcanist = "Sundered Arcanist" -- NPC 201736
	--L.chemist = "Sundered Chemist" -- NPC 205656
	--L.fluid = "Animation Fluid" -- NPC 203939
	--L.slime = "Bubbling Slime" -- NPC 205651
	--L.goo = "Crawling Goo" -- NPC 205820
	--L.whisper = "Whisper in the Dark" -- NPC 203806
end
