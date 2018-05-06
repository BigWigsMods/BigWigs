local L = BigWigs:NewBossLocale("Skorpyron", "ptBR")
if not L then return end
if L then
	L.blue = "Azul"
	L.red = "Vermelho"
	L.green = "Verde"
	L.mode = "Modo %s"
end

L = BigWigs:NewBossLocale("Chronomatic Anomaly", "ptBR")
if L then
	L.affected = "Afetado"
	L.totalAbsorb = "Absorção total"
end

L = BigWigs:NewBossLocale("Trilliax", "ptBR")
if L then
	L.yourLink = "Você está ligado a %s"
	L.yourLinkShort = "Ligado a %s"
	L.imprint = "Carimbo"
end

L = BigWigs:NewBossLocale("Tichondrius", "ptBR")
if L then
	L.addsKilled = "Adds mortos"
	L.gotEssence = "Obteve Essência"

	L.adds_desc = "Timers e avisos para a geração de adds."
	L.adds_yell1 = "Subalternos! Entrem aqui!"
	L.adds_yell2 = "Mostrem a esses pretendentes como lutar!"
end

L = BigWigs:NewBossLocale("Krosus", "ptBR")
if L then
	L.leftBeam = "Feixe esquerdo"
	L.rightBeam = "Feixe direito"

	L.goRight = "> PARA A DIREITA >"
	L.goLeft = "< PARA A ESQUERDA <"

	L.smashingBridge = "Batida" -- TODO: needs reviewing
	L.smashingBridge_desc = "Batida que quebra a ponte. Você pode usar essa opção para enfatizar ou ativar a contagem regressiva."

	L.removedFromYou = "%s removido de você" -- "Searing Brand removed from YOU!"
end

L = BigWigs:NewBossLocale("Star Augur Etraeus", "ptBR")
if L then
	L.yourSign = "Seu sinal"
	L.with = "com"
	L[205429] = "|T1391538:15:15:0:0:64:64:4:60:4:60|t|cFFFFDD00Caranguejo|r"
	L[205445] = "|T1391537:15:15:0:0:64:64:4:60:4:60|t|cFFFF0000Lobo|r"
	L[216345] = "|T1391536:15:15:0:0:64:64:4:60:4:60|t|cFF00FF00Caçador|r"
	L[216344] = "|T1391535:15:15:0:0:64:64:4:60:4:60|t|cFF00DDFFDragão|r"
end

L = BigWigs:NewBossLocale("Grand Magistrix Elisande", "ptBR")
if L then
	L.elisande = "Elisande"

	L.ring_yell = "Deixe as ondas do tempo baterem em você!"
	L.orb_yell = "Você descobrirá que o tempo pode ser bastante volátil."

	L.slowTimeZone = "Desacelerar Camada de Tempo"
	L.fastTimeZone = "Acelerar Camada de Tempo"

	L.boss_active = "Elisande Ativa"
	L.boss_active_desc = "Tempo até Elisande estar ativo após a limpeza dos mobs lixos."
	L.elisande_trigger = "Eu previ sua vinda, claro. Os fios do destino te trouxeram a este lugar. Sua tentativa desesperada de parar a Legião."
end

L = BigWigs:NewBossLocale("Gul'dan", "ptBR")
if L then
	L.warmup_trigger = "Vocês esqueceram?" -- Have you forgotten your humiliation on the Broken Shore? How your precious high king was bent and broken before me? Will you beg for your lives as he did, whimpering like some worthless dog?

	L.empowered = "(O) %s" -- (E) Eye of Gul'dan
	L.gains = "Gul'dan ganha %s"
	L.p4_mythic_start_yell = "Hora de devolver a alma do caçador de demônios ao seu corpo... e negar ao dono da Legião um hospedeiro!"

	L.nightorb_desc = "Evoca um Nightorb, matá-lo vai gerar uma Time Zone."
	L.timeStopZone = "Zona de parar o tempo"

	L.manifest_desc = "Sumona um Fragmento de Alma de Azzinoth, mata-ló gerará uma Essência Demoníaca."

	L.winds_desc = "Gul'dan sumona Ventos Violentos que empurra os jogadores para fora da plataforma."
end

L = BigWigs:NewBossLocale("Nighthold Trash", "ptBR")
if L then
	--[[ Skorpyron to Trilliax ]]--
	L.torm = "Torm, o Tosco"
	L.fulminant = "Fulminante"
	L.pulsauron = "Pulsauron"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	L.sludgerax = "Lodonox"

	--[[ Trilliax to Aluriel ]]--
	L.karzun = "Kar'zun"
	L.guardian = "Guardião Dourado"
	L.battle_magus = "Magus de Batalha da Vigia Crepuscular"
	L.chronowraith = "Cronespectro"
	L.protector = "Protetor do Baluarte da Noite"

	--[[ Aluriel to Etraeus ]]--
	L.jarin = "Astrólogo Jarin"

	--[[ Aluriel to Telarn ]]--
	L.defender = "Defensor Astral"
	L.weaver = "Tecelão da Vigia Crepuscular"
	L.archmage = "Arquimaga Shal'dorei"
	L.manasaber = "Manassabre Domesticado"
	L.naturalist = "Naturalista Shal'dorei"

	--[[ Aluriel to Krosus ]]--
	L.infernal = "Infernal Abrasador"

	--[[ Aluriel to Tichondrius ]]--
	L.chaosmage = "Mago do Caos Devoto Vil"
	L.watcher = "Perscrutador do Abismo"
end
