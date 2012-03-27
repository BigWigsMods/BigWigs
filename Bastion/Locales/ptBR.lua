
local L = BigWigs:NewBossLocale("Cho'gall", "ptBR")
if not L then return end
if L then
	L.orders = "Trocas de modos"
	L.orders_desc = "Avisa quando Cho'gall muda a ordem de posições entre Sombra/Chamas."

	L.crash_say = "Colisão em MIM!"
	L.worship_cooldown = "~Conversão"
	L.adherent_bar = "Add grande #%d"
	L.adherent_message = "Add %d aparece!"
	L.ooze_bar = "Enxame de lamas %d"
	L.ooze_message = "Enxame de lamas %d em breve!"
	L.tentacles_bar = "Aparecem tentáculos"
	L.tentacles_message = "Festa de tentáculos!"
	L.sickness_message = "Você se sente horrivel!"

	L.blaze_message = "Fogo em VOCÊ!"

	L.fury_message = "Fúria!"
	L.first_fury_soon = "Fúria em breve!"
	L.first_fury_message = "85% - Fúria começou!"

	L.unleashed_shadows = "Sombras Energizadas"

	L.phase2_message = "Fase 2!"
	L.phase2_soon = "Fase 2 Iminente!"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "ptBR")
if L then
	L.phase_switch = "Troca de fase"
	L.phase_switch_desc = "Avisa as trocas de fase"

	L.phase_bar = "%s aterrisa"
	L.breath_message = "Respiração profunda Iminente!"
	L.dazzling_message = "Zonas espirais Iminente!"

	L.blast_message = "Explosão Crepúscular" --Sounds better and makes more sense than Twilight Blast (the user instantly knows something is coming from the sky at them)
	L.engulfingmagic_say = "Magia Engolfante em MIM!"

	L.valiona_trigger = "Theralion, eu vou incendiar o corredor. Cubra a fuga deles!"

	L.twilight_shift = "%2$dx Troca em %1$s"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "ptBR")
if L then
	L.strikes_message = "%2$dx Golpe malévolo em %1$s"

	L.breath_message = "Baforada iminente!"
	L.breath_bar = "~Baforada"

	L.engage_yell = "Cho'gall irá decapitar vocês!"

end

L = BigWigs:NewBossLocale("Sinestra", "ptBR")
if L then
	L.whelps = "Dragonetes"
	L.whelps_desc = "Avisar sobre ondas de Dragonetes."

	L.slicer_message = "Possíveis alvos da orbe"

	L.egg_vulnerable = "Hora do Omelete!"

	L.whelps_trigger = "Alimentem-se crianças! Fartem-se com as carcaças cheias de carne."
	L.omelet_trigger = "Confunde isso com fraqueza?  Quanta tolice!"

	L.phase13 = "Fase 1 e 3"
	L.phase = "Fase"
	L.phase_desc = "Avisa quando trocar de fases."
end

L = BigWigs:NewBossLocale("Ascendant Council", "ptBR")
if L then
	L.static_overload_say = "Sobrecarga estática em MIM!"
	L.gravity_core_say = "Núcleo gravitacional em MIM!"
	L.health_report = "%s com %d%%, mudança de fase iminente!"
	L.switch = "Troca"
	L.switch_desc = "Avisa a troca de chefes."

	L.shield_up_message = "Escudo ATIVADO!"
	L.shield_down_message = "Escudo DESATIVADO!"
	L.shield_bar = "Escudo"

	L.switch_trigger = "Nós cuidaremos deles!"

	L.thundershock_quake_soon = "%s em 10seg!"

	L.quake_trigger = "O chão abaixo de você treme bruscamente...."
	L.thundershock_trigger = "O ar que lhe rodeia fundiu-se com a energia...."

	L.thundershock_quake_spam = "%s em %d"

	L.last_phase_trigger = "Que apresentação incrível..."
end

