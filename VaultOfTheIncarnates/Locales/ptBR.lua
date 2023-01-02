local L = BigWigs:NewBossLocale("Eranog", "ptBR")
if not L then return end
if L then
	L.custom_on_nameplate_fixate = "Ícone de fixação na placa de identificação"
	L.custom_on_nameplate_fixate_desc = "Mostra um ícone na placa de identificação do Tarasek Flamescama que está fixado em você.\n\nRequer o uso de placas de identificação inimigas e um addon de placas de identificação suportado (KuiNameplates, Plater)."

	L.molten_cleave = "Frontal"
	L.incinerating_roar = "Rugido"
	L.molten_spikes = "Espetos"
	L.collapsing_army = "Exército"
	L.greater_flamerift = "Add Mítico"
	L.leaping_flames = "Chamas"
end

L = BigWigs:NewBossLocale("Terros", "ptBR")
if L then
	L.rock_blast = "Soak"
	L.resonating_annihilation = "Aniquilação"
	L.awakened_earth = "Pilar"
	L.shattering_impact = "Batida"
	L.concussive_slam = "Linha de Tanque"
	L.infused_fallout = "Poeira"
end

L = BigWigs:NewBossLocale("The Primal Council", "ptBR")
if L then
	L.primal_blizzard = "Nevasca" -- Nevasca Primeva
	L.earthen_pillars = "Pilares" -- Pilar Telúrico
	L.meteor_axes = "Machados" -- Machados Meteoríticos
	L.meteor_axe = "Machado" -- Singular
	L.meteor_axes_melee = "Machado Melee"
	L.meteor_axes_ranged = "Machado Ranged"
	L.conductive_marks = "Marcas" -- Marcas Condutoras
	L.conductive_mark = "Marca" -- Singular

	L.custom_on_stop_timers = "Sempre mostrar as barras de habilidade"
	L.custom_on_stop_timers_desc = "Habilidades que sempre serão mostradas: Marca Condutora"
end

L = BigWigs:NewBossLocale("Sennarth, The Cold Breath", "ptBR")
if L then
	L.ascend = "Subir"
	L.ascend_desc = "Sennarth sobe a sala em direção ao Precipício Congelado."
	L.chilling_blast = "Espalhar"
	L.freezing_breath = "Sopro do Add"
	L.webs = "Teias"
	L.web = "Teia"
	L.gossamer_burst = "Puxão"
	L.repelling_burst = "Repulsão"
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "ptBR")
if L then
	L.conductive_marks = "Marcas"
	L.conductive_mark = "Marca"
	L.raging_burst = "Novos Tornados"
	L.cyclone = "Atração"
	L.crosswinds = "Tornados em movimento"
end

L = BigWigs:NewBossLocale("Kurog Grimtotem", "ptBR")
if L then
	-- Types
	L.damage = "Habilidades de Dano"
	L.damage_desc = "Mostra temporizadores para habilidades de dano (Estouro de Magma, Calafrio Penetrante, Terra Envolvente, Queda de Raio) quando não sabemos em que altar o chefe está."
	L.damage_bartext = "%s [Dano]" -- {Spell} [Dmg]

	L.avoid = "Habilidades de Esquiva"
	L.avoid_desc = "Mostra temporizadores para habilidades de esquiva (Ruptura incandescente, Torrente Frígida, Leite Rocohoso Irrompente, Impacto Chocante) quando não sabemos em que altar o chefe está."
	L.avoid_bartext = "%s [Esquiva]" -- {Spell} [Avoid]

	L.ultimate = "Habilidades Finais"
	L.ultimate_desc = "Mostra temporizadores para habilidades finais (Chacina Calcinante, Zero Absoluto, Ruptura Sísmica, Raio e Trovão) quando não sabemos em que altar o chefe está."
	L.ultimate_bartext = "%s [Final]" -- {Spell} [Ult]

	-- L.add_bartext = "%s [Add]" -- "{Spell} [Add]"

	L.Fire = "Fogo"
	L.Frost = "Gelo"
	L.Earth = "Terra"
	L.Storm = "Tempestade"

	-- Fire
	L.magma_burst = "Poças"
	L.molten_rupture = "Ondas"
	L.searing_carnage = "Dança"
	-- L.raging_inferno = "Soak Pools"

	-- Frost
	L.biting_chill = "DoT Congelante"
	L.frigid_torrent = "Orbes"
	L.absolute_zero = "Soaks"
	L.absolute_zero_melee = "Soak Melee"
	L.absolute_zero_ranged = "Soak Ranged"

	-- Earth
	L.enveloping_earth = "Cura Absorvida"
	L.erupting_bedrock = "Terremotos"

	-- Storm
	L.lightning_crash = "Relâmpago"
	L.thundering_strike = "Soaks"

	-- General
	L.primal_attunement = "Enfurecimento Suave"

	-- Stage 2
	L.violent_upheaval = "Pilares"
end

L = BigWigs:NewBossLocale("Broodkeeper Diurna", "ptBR")
if L then
	L.eggs_remaining = "%d Ovos Restantes!"
	L.broodkeepers_bond = "Ovos Restantes"
	L.greatstaff_of_the_broodkeeper = "Grande Cajado"
	L.greatstaffs_wrath = "Laser"
	L.clutchwatchers_rage = "Raiva"
	L.rapid_incubation = "Ovos Imbuídos"
	L.icy_shroud = "Cura Absorvida"
	L.broodkeepers_fury = "Fúria"
	L.frozen_shroud = "Enraizamento e Cura Absorvida" -- XXX these should be short
	-- L.detonating_stoneslam = "Tank Soak"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "ptBR")
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
	-- L.fuses_reached = "%d |4Fuse:Fuses; Reached" -- 1 Fuse Reached, 2 Fuses Reached
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

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "ptBR")
if L then

end
