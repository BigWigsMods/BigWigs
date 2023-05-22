local L = BigWigs:NewBossLocale("Kazzara, the Hellforged", "frFR")
if not L then return end
if L then
	L.dread_rift = "Faille" -- Singular Dread Rift
end

L = BigWigs:NewBossLocale("The Amalgamation Chamber", "frFR")
if L then
	L.custom_on_fade_out_bars = "Fondu enchainé des barres de la phase 1"
	L.custom_on_fade_out_bars_desc = "Fondu enchainé des barres du boss qui est hors de portée durant la phase 1"

	L.coalescing_void = "Fuyez"
	L.shadow_convergence = "Orbes"
	L.molten_eruption = "Soaks"
	L.swirling_flame = "Tornades"
	L.gloom_conflagration = "Météore + Fuyez"
	L.blistering_twilight = "Bombes + Tornades"
	L.convergent_eruption = "Soaks + Orbes"
	L.shadowflame_burst = "Cône Frontal"

	L.shadow_and_flame = "Affaiblissements Mythiques"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "frFR")
if L then
	L.rending_charge_single = "Première Charge"
	L.massive_slam = "Cône Frontal"
	L.unstable_essence_new = "Nouvelle Bombe"
	L.custom_on_unstable_essence_high = "Message Dire quand Essence Instable est élevé"
	L.custom_on_unstable_essence_high_desc = "Messages Dire avec le nombre de piles de votre Essence Instable quand il est suffisamment élevé."
	L.volatile_spew = "Evitez"
	L.volatile_eruption = "Eruption"
	L.temporal_anomaly = "Orbe de Soin"
	L.temporal_anomaly_knocked = "Orbe de Soin repoussé"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "frFR")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	L.zaqali_aide_north_emote_trigger = "rempart nord" -- Les commandants montent sur le rempart nord!
	L.zaqali_aide_south_emote_trigger = "rempart sud" -- Les commandants montent sur le rempart sud!

	L.north = "Nord"
	L.south = "Sud"
	L.both = "Les deux"

	L.zaqali_aide_message = "%s Grimpe %s" -- Big Adds Climbing North
	L.add_bartext = "%s: %s (%d)"
	L.boss_returns = "Atterissage Boss: Nord"

	L.molten_barrier = "Barrière"
	L.catastrophic_slam = "Frappe Porte"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "frFR")
if L then
	L.doom_flames = "Petits Soaks"
	L.shadowlave_blast = "Cône Frontal"
	L.charged_smash = "Gros Soak"
	L.energy_gained = "Energie Gagnée: %d"

	-- Mythic
	L.unleash_shadowflame = "Orbes Mythiques"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "frFR")
if L then
	L.tactical_destruction = "Têtes de dragon"
	L.bombs_soaked = "Bombes Soakées" -- Bombs Soaked (2/4)
	L.unstable_embers = "Braises"
	L.unstable_ember = "Braise"
end

L = BigWigs:NewBossLocale("Magmorax", "frFR")
if L then
	L.energy_gained = "Energie Gagnée (-17s)" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

	-- Mythic
	L.explosive_magma = "Soak Flaque"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "frFR")
if L then
	L.custom_on_repeating_sunder_reality = "Avertissement Réalité Fracturée répétée"
	L.custom_on_repeating_sunder_reality_desc = "Répète un message durant l'incantation de Destruction d'ébène jusqu'à ce que vous alliez dans un portail."

	L.twisted_earth = "Murs"
	L.echoing_fissure = "Fissure"
	L.rushing_darkness = "Lignes d'impact"

	L.umbral_annihilation = "Annéantissement"
	L.sunder_reality = "Portails"
	L.ebon_destruction = "Destruction d'ébène"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "frFR")
if L then
	L.claws = "Affaiblissement sur le Tank" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	L.claws_debuff = "Explosion Tank"
	L.emptiness_between_stars = "Vide interstellaire"
	L.void_slash = "Frontal sur le Tank"

	--L.boss_immune = "Boss Immune"
	--L.ebon_might = "Adds Immune"
end
