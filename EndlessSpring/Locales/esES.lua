
local L = BigWigs:NewBossLocale("Protector of the Endless", "esES") or BigWigs:NewBossLocale("Protector of the Endless", "esMX")
if not L then return end
if L then
	L.on = "¡%s en %s!"
	L.under = "¡%s bajo %s!"
	L.heal = "%s cura"
end

L = BigWigs:NewBossLocale("Tsulong", "esES") or BigWigs:NewBossLocale("Protector of the Endless", "esMX")
if L then
	L.engage_yell = "¡No debéis estar aquí! He de proteger el agua... ¡Si no puedo expulsaros, os mataré!"

	L.phases = "Fases"
	L.phases_desc = "Aviso para cambios de fases."

	L.sunbeam_spawn = "New Sunbeam!"
end

L = BigWigs:NewBossLocale("Lei Shi", "esES") or BigWigs:NewBossLocale("Protector of the Endless", "esMX")
if L then
	L.hp_to_go = "%d%% to go"
	L.end_hide = "Ocultando terminó"

	L.special = "Próxima habilidad especial"
	L.special_desc = "Aviso para la siguiente habilidad especial"
end

L = BigWigs:NewBossLocale("Sha of Fear", "esES") or BigWigs:NewBossLocale("Protector of the Endless", "esMX")
if L then
	L.fading_soon = "%s fading soon"

	L.swing = "Swing"
	L.swing_desc = "Counts the number of swings before Thrash"

	L.damage = "Daño"
	L.miss = "Fallo"

	L.throw = "¡Lanzar!"
	L.ball_dropped = "¡Bola a tierra!"
	L.ball_you = "¡Tienes la bola!"
	L.ball = "Bola"

	L.cooldown_reset = "¡Tus CDs se reinician!"

	L.ability_cd = "CD de la habilidad"
	L.ability_cd_desc = "Try and guess in which order abilities will be used after an Emerge"

	L.huddle_or_spout = "Huddle or Spout"
	L.huddle_or_strike = "Huddle or Strike"
	L.strike_or_spout = "Strike or Spout"
	L.huddle_or_spout_or_strike =  "Huddle or Spout or Strike"
end

