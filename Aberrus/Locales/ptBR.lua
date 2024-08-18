local L = BigWigs:NewBossLocale("The Amalgamation Chamber", "ptBR")
if not L then return end
if L then
	L.custom_on_fade_out_bars = "Esconder barras da primeira fase"
	L.custom_on_fade_out_bars_desc = "Desaparece com as barras que pertencem ao boss que está fora de alcance na primeira fase."

	L.coalescing_void = "Fuja"

	L.shadow_and_flame = "Debuffs Míticos"
end

L = BigWigs:NewBossLocale("The Forgotten Experiments", "ptBR")
if L then
	L.rending_charge_single = "Primeira Investida"
	L.unstable_essence_new = "Nova Bomba"
	L.custom_on_unstable_essence_high = "Mensagens de Acumulos Altos de Essência Instável"
	L.custom_on_unstable_essence_high_desc = "Diga mensagens com a quantidade de acúmulos do seu debuff de Essência Instável quando eles estiverem altos o suficiente."
	L.volatile_spew = "Esquivar"
	L.volatile_eruption = "Erupção"
	L.temporal_anomaly_knocked = "Orbe de Cura Empurrado"
end

L = BigWigs:NewBossLocale("Assault of the Zaqali", "ptBR")
if L then
	-- These are in-game emotes and need to match the text shown in-game
	-- You should also replace the comment (--) with the full emote as it shows in-game
	L.zaqali_aide_north_emote_trigger = "muralha do norte" -- Commanders ascend the northern battlement!
	L.zaqali_aide_south_emote_trigger = "muralha do sul" -- Commanders ascend the southern battlement!

	L.both = "Ambos"
	L.zaqali_aide_message = "%s Escalando %s" -- Big Adds Climbing North
	L.add_bartext = "%s: %s (%d)"
	L.boss_returns = "Boss Aterrissa: Norte"

	L.molten_barrier = "Barreira"
	L.catastrophic_slam = "Batida na Porta"
end

L = BigWigs:NewBossLocale("Rashok, the Elder", "ptBR")
if L then
	L.doom_flames = "Soaks Pequenos"
	L.charged_smash = "Soak Grande"
	L.energy_gained = "Energia Obtida: %d"
end

L = BigWigs:NewBossLocale("The Vigilant Steward, Zskarn", "ptBR")
if L then
	L.tactical_destruction = "Cabeças de Dragão"
	L.bombs_soaked = "Bombas Limpas" -- Bombs Soaked (2/4)
	L.unstable_embers = "Brasas"
	L.unstable_ember = "Brasa"
end

L = BigWigs:NewBossLocale("Magmorax", "ptBR")
if L then
	L.energy_gained = "Energia Obtida (-17s)" -- When you fail, you lose 17 seconds, the boss reaches full energy faster

	-- Mythic
	L.explosive_magma = "Poça de Soak"
end

L = BigWigs:NewBossLocale("Echo of Neltharion", "ptBR")
if L then
	L.twisted_earth = "Paredes"
	L.echoing_fissure = "Fissura"
	L.rushing_darkness = "Linhas de Empurrão"

	L.umbral_annihilation = "Aniquilação"
	L.ebon_destruction = "Big Bang"

	--L.wall_breaker = "Wall Breaker (Mythic)"
	--L.wall_breaker_desc = "A player targeted by Rushing Darkness will be chosen as the wall breaker. They will be marked ({rt6}) and send a message in say chat. This is restricted to Mythic difficulty on stage 1."
	--L.wall_breaker_message = "Wall Breaker"
end

L = BigWigs:NewBossLocale("Scalecommander Sarkareth", "ptBR")
if L then
	L.claws = "Debuff de Tank" -- (Stage 1) Burning Claws / (Stage 2) Void Claws / (Stage 3) Void Slash
	L.claws_debuff = "Tank Explode"
	L.emptiness_between_stars = "Vazio"
	L.void_slash = "Frontal no Tank"

	L.ebon_might = "Adds Imunes"
end

L = BigWigs:NewBossLocale("Aberrus, the Shadowed Crucible Trash", "ptBR")
if L then
	L.edgelord = "Senhora-da-borda Partida" -- NPC 198873
	L.naturalist = "Naturalista Partido" -- NPC 201746
	L.siegemaster = "Mestre de Cerco Partido" -- NPC 198874
	L.banner = "Estandarte" -- Short for "Sundered Flame Banner" NPC 205638
	L.arcanist = "Arcanista Partida" -- NPC 201736
	L.chemist = "Química Partida" -- NPC 205656
	L.fluid = "Fluido de Animação" -- NPC 203939
	L.slime = "Visgo Borbulhante" -- NPC 205651
	L.goo = "Gosma Rastejante" -- NPC 205820
	L.whisper = "Sussurro das Trevas" -- NPC 203806
end
