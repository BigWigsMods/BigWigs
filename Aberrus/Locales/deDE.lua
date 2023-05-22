local L = BigWigs:NewBossLocale("Kazzara, the Hellforged", "deDE")
if not L then return end
if L then
	L.dread_rift = "Schreckensrisse" -- Singular Dread Rift
end

L = BigWigs:NewBossLocale("The Amalgamation Chamber", "deDE")
if L then
	L.custom_on_fade_out_bars = "Ausblendender Balken in Phase 1"
	L.custom_on_fade_out_bars_desc = "Ausblendender Balken, für den Boss außer Reichweite in Phase 1"

	L.coalescing_void = "Weg laufen"
	L.shadow_convergence = "Orbs"
	L.molten_eruption = "Soaks"
	L.swirling_flame = "Tornados"
	L.gloom_conflagration = "Meteor + Weg laufen"
	L.blistering_twilight = "Bomben + Tornados
	L.convergent_eruption = "Soaks + Orbs"
	L.shadowflame_burst = "Frontal Angriff"

	L.shadow_and_flame = "Mytisch Debuffs"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "deDE")
if L then
	L.rending_charge_single = "Erste Aufladung"
	L.massive_slam = "Frontal Angriff"
	L.unstable_essence_new = "Neue Bombe"
	L.custom_on_unstable_essence_high = "Zu viele Stacks Instabile Essenz"
	L.custom_on_unstable_essence_high_desc = "Ansage, mit der Menge an Stacks Instabile Essenz, wenn diese zu hoch sind."
	L.volatile_spew = "Ausweichen"
	L.volatile_eruption = "Eruption"
	L.temporal_anomaly = "Heilungs Orb"
	L.temporal_anomaly_knocked = "Heilungs Orb geblockt"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "deDE")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	L.zaqali_aide_north_emote_trigger = "Add Magmamystikerin auf Nordseite" -- |TInterface\\ICONS\\Ability_Hunter_KillCommand.blp:20|t Commanders ascend the northern battlement!
	L.zaqali_aide_south_emote_trigger = "Add Magmamystikerin auf Südseite" -- |TInterface\\ICONS\\Ability_Hunter_KillCommand.blp:20|t Commanders ascend the southern battlement!

	L.north = "Norden"
	L.south = "Süden"
	L.both = "Beide Seiten"

	L.zaqali_aide_message = "%s Große Adds klettern %s" -- Große Adds kletten im Norden
	L.add_bartext = "%s: %s (%d)"
	L.boss_returns = "Boss landet: Norden"

	L.molten_barrier = "Barriere"
	L.catastrophic_slam = "Türschlag"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "deDE")
if L then
	L.doom_flames = "Kleine Soaks"
	L.shadowlave_blast = "Frontal Angriff"
	L.charged_smash = "Großer Soak"
	L.energy_gained = "Energie erhalten: %d"

	Mythic
	L.unleash_shadowflame = "Mytisch Orbs"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "deDE")
if L then
	L.tactical_destruction = "Drachenköpfe"
	L.bombs_soaked = "Bomben aufgenommen" -- Bomben aufgenommen (2/4)
	L.unstable_embers = "Instabile Funken"
	L.unstable_ember = "Instabiler Funken"
end

L = BigWigs:NewBossLocale("Magmorax", "deDE")
if L then
	L.energy_gained = "Energie erhalten (-17s)" -- Bei Fehlschlag erreicht der Boss 17 Sekunden schneller volle Energie

	Mythic
	L.explosive_magma = "Soak Fläche"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "deDE")
if L then
	L.custom_on_repeating_sunder_reality = "Realität zerreißen - Portale erscheinen"
	L.custom_on_repeating_shattered_reality_desc = "Schwarze Zerstörung - Gehe in Portal!"

	L.twisted_earth = "Wände"
	L.echoing_fissure = "Hallender Spalt"
	L.rushing_darkness = "Rauschende Finsternis"

	L.umbral_annihilation = "Schattenhafte Auslöschung"
	L.sunder_reality = "Portale"
	L.ebon_destruction = "Big Bang"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "deDE")
if L then
	L.claws = "Tank Debuff" -- (Phase 1) Brennende Klauen / (Phase 2) Leerenklauen / (Phase 3) Leerenschlitzer
	L.claws_debuff = "Tank explodiert"
	L.emptiness_between_stars = "Leere"
	L.void_slash = "Tank Frontal Angriff"

	L.boss_immune = "Boss immun"
	L.ebon_might = "Adds immun"
end
