local L = BigWigs:NewBossLocale("Krosus", "ptBR")
if L then
	L.leftBeam = "Feixe esquerdo"
	L.rightBeam = "Feixe direito"

	L.smashingBridge = "Destruição da ponte" -- TODO: needs reviewing
end

L = BigWigs:NewBossLocale("Skorpyron", "ptBR")
if L then
	L.blue = "Azul"
	L.red = "Vermelho"
	L.green = "Verde"
	L.mode = "Modo %s"
end

L = BigWigs:NewBossLocale("High Botanist Tel'arn", "ptBR")
if L then
	L.custom_off_night_marker = "Marcador de Chamado da Noite"
	L.custom_off_night_marker_desc = "Marca os alvos de Chamado da Noite com {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, requer líder ou assistente."

	L.custom_off_fetter_marker = "Marcador de Grilhão Parasita"
	L.custom_off_fetter_marker_desc = "Marca o ultimo alvo de Grilhão Parasita com {rt8}, requer líder ou assistente."
end