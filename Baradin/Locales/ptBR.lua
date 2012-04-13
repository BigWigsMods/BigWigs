
local L = BigWigs:NewBossLocale("Argaloth", "ptBR")
if not L then return end
if L then
	L.darkness_message = "Escuridão"
	L.firestorm_message = "Tempestade de fogo iminente!"
end

L = BigWigs:NewBossLocale("Occu'thar", "ptBR")
if L then
	L.shadows_bar = "~Sombras"
	L.destruction_bar = "<Explosão>"
	L.eyes_bar = "~Olhos"

	L.fire_message = "Laser, Pew Pew"
	L.fire_bar = "~Laser"
end

L = BigWigs:NewBossLocale("Alizabal", "ptBR")
if L then
	L.first_ability = "Ódio ou Espetinho"
	L.dance_message = "Dança de Lâminas %d de 3"
end

