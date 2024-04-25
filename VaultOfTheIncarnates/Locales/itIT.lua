local L = BigWigs:NewBossLocale("Eranog", "itIT")
if not L then return end
if L then
	L.custom_on_nameplate_fixate = "Icona Nameplate Inseguimento"
	L.custom_on_nameplate_fixate_desc = "Mostra un'icona sulla barra del Tarasek Scagliafiamma che ti insegue.\n\nRichiede l'uso delle Barre del Bersaglio Nemichee un'addon delle Barre del bersaglio supportato (KuiNameplates, Plater)."

	L.molten_cleave = "Frontale"
	L.molten_spikes = "Spuntoni"
	L.collapsing_army = "Armata"
	L.greater_flamerift = "Add Mitico"
	L.leaping_flames = "Fiamme"
end

L = BigWigs:NewBossLocale("Terros", "itIT")
if L then
	L.resonating_annihilation = "Annientamento"
	L.awakened_earth = "Pilastri"
	L.shattering_impact = "Contusione"
	L.concussive_slam = "Linea del Difensore"
	L.infused_fallout = "Dust"

	L.custom_on_repeating_fallout = "Ripetisione Ricaduta Infusa"
	L.custom_on_repeating_fallout_desc = "Ripetisione Ricaduta Infusa avvisa un messaggio con l'icona {rt7} per trovare un partner."
end

L = BigWigs:NewBossLocale("The Primal Council", "itIT")
if L then
L.primal_blizzard = "Tormenta" -- Primal Blizzard
	L.earthen_pillars = "Pilastri" -- Earthen Pillars
	L.meteor_axes = "Asce" -- Meteor Axes
	L.meteor_axe = "Ascia" -- Singular
	L.meteor_axes_melee = "Ascia Corpo a Corpo"
	L.meteor_axes_ranged = "Ascia a Distanza"

	L.skipped_cast = "Saltato %s (%d)"
end

L = BigWigs:NewBossLocale("Sennarth, The Cold Breath", "itIT")
if L then
	L.ascend = "Ascesa"
	L.ascend_desc = "Sennarth inizia l'ascesa verso la cima ghiacciata della sua tana."
	L.chilling_blast = "Sparpagliarsi"
	L.freezing_breath = "Soffio degli Add"
	L.webs = "Ragnatele"
	L.web = "Ragnatela"
	L.gossamer_burst = "Presa"
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "itIT")
if L then
	L.raging_burst = "Nuovi Tornado"
	L.cyclone = "Trascinamento"
	L.crosswinds = "Tornado in Movimento"
end

L = BigWigs:NewBossLocale("Kurog Grimtotem", "itIT")
if L then
	-- -- Types
	L.damage = "Abilità di Danno"
	L.damage_desc = "Mostra timer per le Abilità di Danno (Getto di Magma, Gelo Pungente, Terra Avvolgente, Schianto di Fulmini) quando non sappiamo a che altare il Boss è."
	L.damage_bartext = "%s [Danno]" -- {Spell} [Dmg]

	L.avoid = "Abilità da Evitare"
	L.avoid_desc = "Mostra timer per le Abilità da Evitare (Perforazione Fusa, Torrente Gelido, Formazione Rocciosa Eruttante, Scarica Folgorante) quando non sappiamo a che altare il Boss è."
	L.avoid_bartext = "%s [Evita]" -- {Spell} [Avoid]

	L.ultimate = "Abilità Finali"
	L.ultimate_desc = "Mostra timer per le Abilità Finali (Carneficina Rovente, Zero Assoluto, Perforazione Sismica, Assalto del Tuono) quando non sappiamo a che altare il Boss è."
	L.ultimate_bartext = "%s [Finali]" -- {Spell} [Ult]

	L.add_bartext = "%s [Add]" -- "{Spell} [Add]"

	L.Fire = "Fuoco"
	L.Frost = "Gelo"
	L.Earth = "Terra"
	L.Storm = "Tempesta"

	-- Fire
	L.molten_rupture = "Ondate"
	L.searing_carnage = "Danza"
	L.raging_inferno = "Assorbi Pozze"

	-- Frost
	L.biting_chill = "DoT Morsa Gelida"
	L.absolute_zero_melee = "Assorbimento Corpo a Corpo"
	L.absolute_zero_ranged = "Assorbimento a Distanza"

	-- Earth
	L.erupting_bedrock = "Terremoti"

	-- Storm
	L.lightning_crash = "Fulmini"

	-- General
	L.primal_attunement = "Rabbia Leggera"

	-- Stage 2
	L.violent_upheaval = "Pilastri"
end

L = BigWigs:NewBossLocale("Broodkeeper Diurna", "itIT")
if L then
	L.eggs_remaining = "%d Uova Rimanenti!"
	L.broodkeepers_bond = "Uova Rimanenti"
	L.greatstaff_of_the_broodkeeper = "Granbastone"
	L.clutchwatchers_rage = "Rabbia"
	L.rapid_incubation = "Infusione Uova"
	L.broodkeepers_fury = "Furia"
	L.frozen_shroud = "Assorbimento Cure e Immobilizzazione"
	L.detonating_stoneslam = "Assorbimento Difensore"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "itIT")
if L then
	L.lighting_devastation_trigger = "respiro profondo" -- Raszageth takes a deep breath...

	-- Stage One: The Winds of Change
	L.volatile_current = "Scintilla"
	L.thunderous_blast = "Detonazione"
	L.lightning_strikes = "Assalti"
	L.electric_scales = "Danno Incursione"
	L.electric_lash = "Sferzata"
	-- Stage Two: Surging Power
	L.absorb_text = "%s (%.0f%%)"
	L.stormsurge = "Assorbimento Scudo"
	L.stormcharged = "Positivo o Negativo"
	L.positive = "Positivo"
	L.negative = "Negativo"
	L.focused_charge = "Potenziamento Danno"
	L.tempest_wing = "Ondata di tempesta"
	L.fulminating_charge = "Cariche"
	L.fulminating_charge_debuff = "Carica"
	-- Intermission: The Vault Falters
	L.ball_lightning = "Sfere"
	-- Stage Three: Storm Incarnate
	L.magnetic_charge = "Carica Attirante"

	L.custom_on_repeating_stormcharged = "Ripetizione Positivo o Negativo"
	L.custom_on_repeating_stormcharged_desc = "Messaggio di Ripetizione Positivo o Negativo con le icone {rt1}, {rt3} per trovare con chi accoppiarti per togliere il maleficio."

	L.skipped_cast = "Saltato %s (%d)"

	L.custom_off_raidleader_devastation = "Devastazione Fulminante: Modalità Capo"
	L.custom_off_raidleader_devastation_desc = "Mostra una barra per Devastazione Fulminante (Soffio) anche per l'altro lato."
	L.breath_other = "%s [Opposto]" -- Breath on opposite platform
end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "itIT")
if L then

end
