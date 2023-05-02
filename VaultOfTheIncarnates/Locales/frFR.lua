local L = BigWigs:NewBossLocale("Eranog", "frFR")
if not L then return end
if L then
	-- L.custom_on_nameplate_fixate = "Fixate Nameplate Icon"
	-- L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate of Frenzied Tarasek that are fixed on you.\n\nRequires the use of Enemy Nameplates and a supported nameplate addon (KuiNameplates, Plater)."

	L.molten_cleave = "Frontal"
	L.incinerating_roar = "Hurlement"
	L.molten_spikes = "Pointes"
	L.collapsing_army = "Armée"
	L.greater_flamerift = "Add Mythique"
	L.leaping_flames = "Flammes"
end

L = BigWigs:NewBossLocale("Terros", "frFR")
if L then
	L.rock_blast = "Soak"
	L.resonating_annihilation = "Annihilation"
	L.awakened_earth = "Pilier"
	L.shattering_impact = "Impact"
	L.concussive_slam = "Ligne Tank"
	L.infused_fallout = "Poussière"

	--L.custom_on_repeating_fallout = "Repeating Infused Fallout"
	--L.custom_on_repeating_fallout_desc = "Repeating Infused Fallout say messages with icon {rt7} to find a partner."
end

L = BigWigs:NewBossLocale("The Primal Council", "frFR")
if L then
	L.primal_blizzard = "Blizzard" -- Primal Blizzard
	L.earthen_pillars = "Piliers" -- Earthen Pillars
	L.meteor_axes = "Haches" -- Meteor Axes
	L.meteor_axe = "Hache" -- Singular
	L.meteor_axes_melee = "Hache Mêlée"
	L.meteor_axes_ranged = "Hache Distance"
	L.conductive_marks = "Marques" -- Conductive Marks
	L.conductive_mark = "Marque" -- Singular

	-- L.skipped_cast = "Skipped %s (%d)"
end

L = BigWigs:NewBossLocale("Sennarth, The Cold Breath", "frFR")
if L then
	L.ascend = "Ascension"
	L.ascend_desc = "Sennarth entame son ascension vers le précipe gelé."
	-- L.chilling_blast = "Spread"
	L.freezing_breath = "Souffle Add"
	L.webs = "Toiles"
	L.web = "Toile"
	L.gossamer_burst = "Attirer"
	-- L.gossamer_burst_castbar = "Gossamer Burst Cast Bar / Countdown"
	-- L.gossamer_burst_castbar_desc = "A Cast Bar for Gossamer Burst with Countdown enabled by default."
	L.repelling_burst = "Repousser"
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "frFR")
if L then
	L.conductive_marks = "Marques"
	L.conductive_mark = "Marque"
	L.raging_burst = "Nouvelles Tornades"
	-- L.cyclone = "Pull In"
	L.crosswinds = "Otrnades mobiles"
end

L = BigWigs:NewBossLocale("Kurog Grimtotem", "frFR")
if L then
	-- -- Types
	L.damage = "Techniques de dégâts"
	L.damage_desc = "Affiche les délais pour les techniques de dégâts (Explosion de magma, Frisson mordant, Enveloppe terreuse, Déferlante de foudre) quand on ignore à quel autel se trouve le boss."
	L.damage_bartext = "%s [Dgts]" -- {Spell} [Dmg]

	L.avoid = "Techniques à éviter"
	L.avoid_desc = "Affiche les délais pour les techniques à éviter (Rupture en fusion, Torrent glacé, Roche mère en éruption, Explosion électrisante) quand on ignore à quel autel se trouve le boss."
	L.avoid_bartext = "%s [Éviter]" -- {Spell} [Avoid]

	L.ultimate = "Techniques ultimes"
	L.ultimate_desc = "Affiche les délais pour les techniques ultimes (Carnage incendiaire, Zéro absolu, Rupture sismique, Frappe de la foudre) quand on ignore à quel autel se trouve le boss."
	L.ultimate_bartext = "%s [Ult]" -- {Spell} [Ult]

	L.add_bartext = "%s [Add]" -- "{Spell} [Add]"

	L.Fire = "Feu"
	L.Frost = "Givre"
	L.Earth = "Terre"
	L.Storm = "Tempête"

	-- Fire
	L.magma_burst = "Flaques"
	L.molten_rupture = "Vagues"
	L.searing_carnage = "Danse"
	-- L.raging_inferno = "Soak Pools"

	-- Frost
	L.biting_chill = "DoT Frisson"
	L.frigid_torrent = "Orbes"
	L.absolute_zero = "Soaks"
	L.absolute_zero_melee = "Soak Mêlée"
	L.absolute_zero_ranged = "Soak Distance"

	-- Earth
	L.enveloping_earth = "Absorption Soins"
	L.erupting_bedrock = "Tremblements"

	-- Storm
	L.lightning_crash = "Décharges"
	L.thundering_strike = "Soaks"

	-- General
	-- L.primal_attunement = "Soft Enrage"

	-- Stage 2
	L.violent_upheaval = "Piliers"
end

L = BigWigs:NewBossLocale("Broodkeeper Diurna", "frFR")
if L then
	L.eggs_remaining = "Il reste %d Œuf(s) !"
	L.broodkeepers_bond = "Œufs restants"
	L.greatstaff_of_the_broodkeeper = "Grand bâton"
	L.greatstaffs_wrath = "Laser"
	L.clutchwatchers_rage = "Fureur"
	L.rapid_incubation = "Infusion Œufs"
	L.icy_shroud = "Absorption Soins"
	L.broodkeepers_fury = "Furie"
	-- L.frozen_shroud = "Root Absorb"
	-- L.detonating_stoneslam = "Tank Soak"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "frFR")
if L then
	-- L.lighting_devastation_trigger = "deep breath" -- Raszageth takes a deep breath...

	-- Stage One: The Winds of Change
	-- L.hurricane_wing = "Pushback"
	-- L.volatile_current = "Sparks"
	-- L.thunderous_blast = "Blast"
	-- L.lightning_breath = "Breath"
	-- L.lightning_strikes = "Strikes"
	-- L.electric_scales = "Raid Damage"
	-- L.electric_lash = "Lash"
	-- Intermission: The Primalist Strike
	-- L.lightning_devastation = "Breath"
	-- L.shattering_shroud = "Heal Absorb"
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
	-- L.storm_break = "Teleport"
	-- L.ball_lightning = "Balls"
	-- Stage Three: Storm Incarnate
	-- L.magnetic_charge = "Pull Charge"

	-- L.storm_nova_cast = "Storm Nova CastBar"
	-- L.storm_nova_cast_desc = "Cast Bar for Storm Nova"

	-- L.custom_on_repeating_stormcharged = "Repeating Positive or Negative"
	-- L.custom_on_repeating_stormcharged_desc = "Repeating Positive or Negative say messages with icons {rt1}, {rt3} to find matches to remove your debuffs."

	-- L.skipped_cast = "Skipped %s (%d)"

	-- L.custom_off_raidleader_devastation = "Lighting Devastation: Leader Mode"
	-- L.custom_off_raidleader_devastation_desc = "Show a bar for the Lighting Devastation (Breath) on the other side as well."
	-- L.breath_other = "%s [Opposite]" -- Breath on opposite platform
end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "frFR")
if L then

end
