local L = BigWigs:NewBossLocale("Eranog", "frFR")
if not L then return end
if L then
	L.custom_on_nameplate_fixate = "Icône Nameplate fixée"
	L.custom_on_nameplate_fixate_desc = "Affiche un icône sur le nameplate du Tarasèke frénétique qui vous fixe.\n\nNécessite l'utilisation des namemplates ennemi et un addon qui supporte les nameplates (KuiNameplates, Plater)."

	L.molten_cleave = "Frontal"
	L.molten_spikes = "Pointes"
	L.collapsing_army = "Armée"
	L.greater_flamerift = "Add Mythique"
	L.leaping_flames = "Flammes"
end

L = BigWigs:NewBossLocale("Terros", "frFR")
if L then
	L.resonating_annihilation = "Annihilation"
	L.awakened_earth = "Pilier"
	L.shattering_impact = "Impact"
	L.concussive_slam = "Ligne Tank"
	L.infused_fallout = "Poussière"

	L.custom_on_repeating_fallout = "Répéter Retombée imprégnée"
	L.custom_on_repeating_fallout_desc = "Répéter Retombée imprégnée en message Dire avec l'icône {rt7} pour trouver un partenaire."
end

L = BigWigs:NewBossLocale("The Primal Council", "frFR")
if L then
	L.primal_blizzard = "Blizzard" -- Primal Blizzard
	L.earthen_pillars = "Piliers" -- Earthen Pillars
	L.meteor_axes = "Haches" -- Meteor Axes
	L.meteor_axe = "Hache" -- Singular
	L.meteor_axes_melee = "Hache Mêlée"
	L.meteor_axes_ranged = "Hache Distance"

	L.skipped_cast = "%s ignoré (%d)"
end

L = BigWigs:NewBossLocale("Sennarth, The Cold Breath", "frFR")
if L then
	L.ascend = "Ascension"
	L.ascend_desc = "Sennarth entame son ascension vers le précipe gelé."
	L.chilling_blast = "Spread"
	L.freezing_breath = "Souffle Add"
	L.webs = "Toiles"
	L.web = "Toile"
	L.gossamer_burst = "Attirer"
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "frFR")
if L then
	L.raging_burst = "Nouvelles Tornades"
	L.cyclone = "Attraction"
	L.crosswinds = "Tornades mobiles"
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
	L.molten_rupture = "Vagues"
	L.searing_carnage = "Danse"
	L.raging_inferno = "Soak Flaques"

	-- Frost
	L.biting_chill = "DoT Frisson"
	L.absolute_zero_melee = "Soak Mêlée"
	L.absolute_zero_ranged = "Soak Distance"

	-- Earth
	L.erupting_bedrock = "Tremblements"

	-- Storm
	L.lightning_crash = "Décharges"

	-- General
	L.primal_attunement = "Enragé léger"

	-- Stage 2
	L.violent_upheaval = "Piliers"
end

L = BigWigs:NewBossLocale("Broodkeeper Diurna", "frFR")
if L then
	L.eggs_remaining = "Il reste %d Œuf(s) !"
	L.broodkeepers_bond = "Œufs restants"
	L.greatstaff_of_the_broodkeeper = "Grand bâton"
	L.clutchwatchers_rage = "Fureur"
	L.rapid_incubation = "Infusion Œufs"
	L.broodkeepers_fury = "Furie"
	L.frozen_shroud = "Root Absorbant"
	L.detonating_stoneslam = "Soak Tank"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "frFR")
if L then
	L.lighting_devastation_trigger = "profonde inspiration" -- Raszageth takes a deep breath...

	-- Stage One: The Winds of Change
	L.volatile_current = "Etincelles"
	L.thunderous_blast = "Explosion"
	L.lightning_strikes = "Frappes"
	L.electric_scales = "Dégats Raid"
	L.electric_lash = "Fouet"
	-- Stage Two: Surging Power
	L.absorb_text = "%s (%.0f%%)"
	L.stormsurge = "Bouclier Absorbant"
	L.stormcharged = "Positif ou Négatif"
	L.positive = "Positif"
	L.negative = "Négatif"
	L.focused_charge = "Amélioration de Dégats"
	L.tempest_wing = "Vague Tempête"
	L.fulminating_charge = "Charges"
	L.fulminating_charge_debuff = "Charge"
	-- Intermission: The Vault Falters
	L.ball_lightning = "Boules"
	-- Stage Three: Storm Incarnate
	L.magnetic_charge = "Charge attirante"

	L.custom_on_repeating_stormcharged = "Répéter Positif ou Négatif"
	L.custom_on_repeating_stormcharged_desc = "Répéter Positif ou Négatif en message Dire avec les icônes {rt1}, {rt3} pour trouver une correspondance et retirer le débuff."

	L.skipped_cast = "%s ignoré (%d)"

	L.custom_off_raidleader_devastation = "Dévastation de foudre: Mode Leaser"
	L.custom_off_raidleader_devastation_desc = "Affiche une bar pour la Dévastation de foudre (Souffle) pour l'autre côté également."
	L.breath_other = "%s [Opposé]" -- Breath on opposite platform
end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "frFR")
if L then

end
