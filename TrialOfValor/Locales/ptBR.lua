local L = BigWigs:NewBossLocale("Guarm-TrialOfValor", "ptBR")
if L then
	L.lick = "Lambida"
	L.lick_desc = "Mostra barras para as lambidas."
end

L = BigWigs:NewBossLocale("Helya-TrialOfValor", "ptBR")
if L then
	L.nearTrigger = "perto de" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t Um %s surge perto de Helya!
	L.farTrigger = "longe de" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t Um %s surge longe de Helya!
	L.tentacle_near = "Tentáculo PERTO DE Helya"
	L.tentacle_near_desc = "Esta opção pode ser usada para enfatizar ou esconder a mensagem quando uma Batida com Tentáculo aparece perto de Heyla."
	L.tentacle_far = "Tentáculo LONGE DE Helya"
	L.tentacle_far_desc = "Esta opção pode ser usada para enfatizar ou esconder a mensagem quando uma Batida com Tentáculo aparece longe de Heyla."

	L.orb_melee = "Orbe: contador de Corpo a corpo" -- TODO: needs reviewing
	L.orb_melee_desc = "Mostra um contador para Orbes que surgem em jogadores corpo a corpo."-- TODO: needs reviewing
	L.orb_melee_bar = "Orbe corpo a corpo"-- TODO: needs reviewing

	L.orb_ranged = "Orbe: contador de Distância"-- TODO: needs reviewing
	L.orb_ranged_desc = "Mostra um contador para Orbes que surgem em jogadores a distância."-- TODO: needs reviewing
	L.orb_ranged_bar = "Orbe a distância"-- TODO: needs reviewing

	L.orb_say = "Orbe"
	L.taint_say = "Mácula"
end

L = BigWigs:NewBossLocale("Odyn-TrialOfValor", "ptBR")
if not L then return end
if L then
	L.yields = "%s cedeu" -- used when Hymdall and Helya leave the fight in P2: "Hymdall yields"
	L[227490] = "|cFF800080Cima Direita|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	L[227491] = "|cFFFFA500Baixo Direita|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	L[227498] = "|cFFFFFF00Baixo Esquerda|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	L[227499] = "|cFF0000FFCima Esquerda|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	L[227500] = "|cFF008000Cima|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end