
local L = BigWigs:NewBossLocale("Protectors of the Endless", "esES") or BigWigs:NewBossLocale("Protectors of the Endless", "esMX")
if not L then return end
if L then
	L.under = "¡%s bajo %s!"
	L.heal = "%s cura"
end

L = BigWigs:NewBossLocale("Tsulong", "esES") or BigWigs:NewBossLocale("Protector of the Endless", "esMX")
if L then
	L.engage_yell = "¡No debéis estar aquí! He de proteger el agua... ¡Si no puedo expulsaros, os mataré!"
	L.kill_yell = "Gracias, forasteros. Me habéis liberado."

	L.phases = "Fases"
	L.phases_desc = "Aviso para cambios de fases."

	L.sunbeam_spawn = "¡Nuevo Rayo de Sol!"
end

L = BigWigs:NewBossLocale("Lei Shi", "esES") or BigWigs:NewBossLocale("Protector of the Endless", "esMX")
if L then
	L.hp_to_go = "%d%% para acabar"

	L.special = "Próxima habilidad especial"
	L.special_desc = "Siguiente habilidad especial."

	L.custom_off_addmarker = "Marcador de Protectores"
	L.custom_off_addmarker_desc = "Marca los Protectores animados durante el Proteger de Lei Shi, requiere ayudante o líder.\n|cFFFF0000Solo 1 persona en la raid debería tener activada esta opción para evitar conflictos con las marcas.|r\n|cFFADFF2FCONSEJO: Si la raid te ha elegido para activarla, mover el ratón rápidamente encima de todos los Protectores es la forma más rápida de marcarlos.|r"
end

L = BigWigs:NewBossLocale("Sha of Fear", "esES") or BigWigs:NewBossLocale("Protector of the Endless", "esMX")
if L then
	L.fading_soon = "%s se disipa pronto"

	L.swing = "Golpea"
	L.swing_desc = "Cuenta el número de golpes antes de Vapulear."

	L.damage = "Daño"
	L.miss = "Fallo"

	L.throw = "¡Lanzar!"
	L.ball_dropped = "¡Bola al suelo!"
	L.ball_you = "¡Tienes la bola!"
	L.ball = "Bola"

	L.cooldown_reset = "¡Tus CDs se reinician!"

	L.ability_cd = "CD de la habilidad"
	L.ability_cd_desc = "Intenta adivinar en que orden se usarán las habilidades después de Emerger."

	L.strike_or_spout = "Golpe o Aspersor"
	L.huddle_or_spout_or_strike = "Encogeros o Aspersor o Golpe"

	--L.custom_off_huddle = "Huddle marker"
	--L.custom_off_huddle_desc = "To help healing assignments, mark the people who have huddle in terror on them with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, requires promoted or leader."
end

