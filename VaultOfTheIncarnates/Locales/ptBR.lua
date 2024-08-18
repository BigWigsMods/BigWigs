local L = BigWigs:NewBossLocale("Eranog", "ptBR")
if not L then return end
if L then
	L.custom_on_nameplate_fixate = "Ícone de fixação na placa de identificação"
	L.custom_on_nameplate_fixate_desc = "Mostra um ícone na placa de identificação do Tarasek Flamescama que está fixado em você.\n\nRequer o uso de placas de identificação inimigas e um addon de placas de identificação suportado (KuiNameplates, Plater)."

	L.molten_cleave = "Frontal"
	L.molten_spikes = "Espetos"
	L.collapsing_army = "Exército"
	L.greater_flamerift = "Add Mítico"
	L.leaping_flames = "Chamas"
end

L = BigWigs:NewBossLocale("Terros", "ptBR")
if L then
	L.resonating_annihilation = "Aniquilação"
	L.awakened_earth = "Pilar"
	L.shattering_impact = "Batida"
	L.concussive_slam = "Linha de Tanque"
	L.infused_fallout = "Poeira"

	--L.custom_on_repeating_fallout = "Repeating Infused Fallout"
	--L.custom_on_repeating_fallout_desc = "Repeating Infused Fallout say messages with icon {rt7} to find a partner."
end

L = BigWigs:NewBossLocale("The Primal Council", "ptBR")
if L then
	L.primal_blizzard = "Nevasca" -- Nevasca Primeva
	L.earthen_pillars = "Pilares" -- Pilar Telúrico
	L.meteor_axes = "Machados" -- Machados Meteoríticos
	L.meteor_axe = "Machado" -- Singular
	L.meteor_axes_melee = "Machado Melee"
	L.meteor_axes_ranged = "Machado Ranged"

	L.skipped_cast = "Ignorado %s (%d)"
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
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "ptBR")
if L then
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

	L.add_bartext = "%s [Add]" -- "{Spell} [Add]"

	L.Fire = "Fogo"
	L.Frost = "Gelo"
	L.Earth = "Terra"
	L.Storm = "Tempestade"

	-- Fire
	L.molten_rupture = "Ondas"
	L.searing_carnage = "Dança"
	L.raging_inferno = "Poças de Soak"

	-- Frost
	L.biting_chill = "DoT Congelante"
	L.absolute_zero_melee = "Soak Melee"
	L.absolute_zero_ranged = "Soak Ranged"

	-- Earth
	L.erupting_bedrock = "Terremotos"

	-- Storm
	L.lightning_crash = "Relâmpago"

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
	L.clutchwatchers_rage = "Raiva"
	L.rapid_incubation = "Ovos Imbuídos"
	L.broodkeepers_fury = "Fúria"
	L.frozen_shroud = "Enraizamento e Cura Absorvida" -- XXX these should be short
	L.detonating_stoneslam = "Soak do Tank"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "ptBR")
if L then
	L.lighting_devastation_trigger = "Respiração Profunda" -- Raszageth takes a deep breath...

	-- Stage One: The Winds of Change
	L.volatile_current = "Centelhas"
	L.thunderous_blast = "Impacto"
	L.lightning_strikes = "Raios"
	L.electric_scales = "Dano na Raid"
	L.electric_lash = "Açoite"
	-- Stage Two: Surging Power
	L.absorb_text = "%s (%.0f%%)"
	L.stormsurge = "Escudo"
	L.stormcharged = "Positivo ou Negativo"
	L.positive = "Positivo"
	L.negative = "Negativo"
	L.focused_charge = "Buff de Dano"
	L.tempest_wing = "Onda de Tempestade"
	L.fulminating_charge = "Cargas"
	L.fulminating_charge_debuff = "Carga"
	-- Intermission: The Vault Falters
	L.ball_lightning = "Bolas"
	-- Stage Three: Storm Incarnate
	L.magnetic_charge = "Carga Puxante"

	L.custom_on_repeating_stormcharged = "Repetição Positiva ou Negativa"
	L.custom_on_repeating_stormcharged_desc = "Repetição Positiva ou Negativa fala mensagens com os ícones {rt1}, {rt3} para localizar parceiros com finalidade de remover seus Debuffs."

	L.skipped_cast = "Ignorado %s (%d)"

	L.custom_off_raidleader_devastation = "Devastação Elétrica: Modo de lider"
	L.custom_off_raidleader_devastation_desc = "Mostra uma barra para Devastação Elétrica (Sopro) mesmo estando do outro lado da plataforma."
	L.breath_other = "%s [Oposta]" -- Sopro na plataforma oposta
end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "ptBR")
if L then

end
