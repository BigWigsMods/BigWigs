local L = BigWigs:NewBossLocale("Kazzara, the Hellforged", "itIT")
if not L then return end
if L then
    L.dread_rift = "Fenditura" -- Singular Dread Rift
end

L = BigWigs:NewBossLocale("The Amalgamation Chamber", "itIT")
if L then
	L.custom_on_fade_out_bars = "Dissolvenza Barre Fase 1"
	L.custom_on_fade_out_bars_desc = "Dissolvi le barre del boss che fuori raggio d'azione in Fase 1."

	L.coalescing_void = "Scappa"
	L.shadow_convergence = "Globi"
	L.molten_eruption = "Assorbi"
	L.swirling_flame = "Tornado"
	L.gloom_conflagration = "Meteora + Scappare"
	L.blistering_twilight = "Bombe + Tornado"
	L.convergent_eruption = "Assorbi + Globi"
	L.shadowflame_burst = "Cono Frontale"

	L.shadow_and_flame = "Penalità Mitico"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "itIT")
if L then
	L.rending_charge_single = "Prima Carica"
	L.massive_slam = "Cono Frontale"
	L.unstable_essence_new = "Nuova Bomba"
	L.custom_on_unstable_essence_high = "Messaggio Chat Molti Accumuli di Essenza Instabile"
	L.custom_on_unstable_essence_high_desc = "Messaggio di chat con il numero di accumuli per il tuo maleficio di Essenza Instabile quando sono troppi."
	L.volatile_spew = "Evita"
	L.volatile_eruption = "Erupzione"
	L.temporal_anomaly = "Globo Curativo"
	L.temporal_anomaly_knocked = "Globo Curativo Intercettato!"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "itIT")
if L then
	L.big_adds_timer = "Timer per Predatori + Guardie"
	L.final_assault_soon = "Assalto Finale a breve"

	L.south_adds_message = "Add Maggiori Si Arrampicano Da SUD!"
	-- L.south_adds = "Commanders ascend the southern battlement!" -- |TInterface\\ICONS\\Ability_Hunter_KillCommand.blp:20|t Commanders ascend the southern battlement!
	L.north_adds_message = "Add Maggiori Si Arrampicano Da NORD"
	-- L.north_adds = "Commanders ascend the northern battlement!" -- |TInterface\\ICONS\\Ability_Hunter_KillCommand.blp:20|t Commanders ascend the northern battlement!

	L.wallclimbers_bartext = "Scalatori"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "itIT")
if L then
	L.doom_flames = "Assorbimenti Minori"
	L.shadowlave_blast = "Cono Frontale"
	L.charged_smash = "Assorbimento Maggiore"
	L.energy_gained = "Energia Guadagnata: %d"

	-- Mythic
	L.unleash_shadowflame = "Globi Mitico"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "itIT")
if L then
	L.tactical_destruction = "Statue di Drago"
	L.bombs_soaked = "Bombe Assorbite" -- Bombs Soaked (2/4)
	L.unstable_embers = "Braci"
	L.unstable_ember = "Brace"
end

L = BigWigs:NewBossLocale("Magmorax", "itIT")
if L then
	L.energy_gained = "Energia Guadagnata! (-17s)" -- When you fail, you lose 17s on until the boss reaches full energy

	-- Mythic
	L.explosive_magma = "Assorbi Pozza"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "itIT")
if L then
	L.custom_on_repeating_sunder_reality = "Ripeti Avviso per Frammentazione della Realtà"
	L.custom_on_repeating_shattered_reality_desc = "Ripeti un messaggio durante il lancio di Distruzione d'Ebano fino a che non entri dentro un portale."

	L.twisted_earth = "Muri"
	L.echoing_fissure = "Fessura"
	L.rushing_darkness = "Distruggi Linee"

	L.umbral_annihilation = "Annientamento"
	L.sunder_reality = "Portali"
	L.ebon_destruction = "Big Bang"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "itIT")
if L then
	L.claws = "Penalità Difensori" -- (Fase 1) Artigli Ardenti / (Fase 2) Artigli del Vuoto / (Fase 3) Squarcio del Vuoto
end
