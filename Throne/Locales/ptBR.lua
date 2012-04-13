
local L = BigWigs:NewBossLocale("Al'Akir", "ptBR")
if not L then return end
if L then
	L.stormling = "Tempestinhas"
	L.stormling_desc = "Invoca Tempestinha."
	L.stormling_message = "Tempestinha iminente!"
	L.stormling_bar = "Tempestinha"
	L.stormling_yell = "Tempestades! Eu as convoco para me ajudar!"

	L.acid_rain = "Chuva ácida (%d)"

	L.phase3_yell = "Chega! Eu não serei mais contido!"

	L.phase = "Troca de fase"
	L.phase_desc = "Anúncia as trocas de fase."

	L.cloud_message = "Franklin estaria orgulhoso!"
	L.feedback_message = "%dx Retornado"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "ptBR")
if L then
	L.gather_strength = "%s começou a ganhar forças"

	L.storm_shield = "Escudo de Tempestade"
	L.storm_shield_desc = "Escudo de absorção"

	L.full_power = "Poder Máximo"
	L.full_power_desc = "Avisa quando os chefes alcanção Poder Máximo e começam a lançar as habilidades especiais."
	L.gather_strength_emote = "%s começou a ganhar forças dos Senhores do vento que cairam!"

	L.wind_chill = "%sx Calafrio Eólico em VOCÊ!"
end

