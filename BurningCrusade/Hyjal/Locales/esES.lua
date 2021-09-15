local L = BigWigs:NewBossLocale("ArchimondeHyjal", "esES") or BigWigs:NewBossLocale("ArchimondeHyjal", "esMX")
if not L then return end
if L then
	L.engage_trigger = "Vuestra resistencia es insignificante."
	L.grip_other = "Apretón"
	L.fear_message = "Miedo, sig. en ~ 42seg!"

	L.killable = "Becomes Killable"
end

L = BigWigs:NewBossLocale("Azgalor", "esES") or BigWigs:NewBossLocale("Azgalor", "esMX")
if L then
	L.howl_bar = "~Aullido"
	L.howl_message = "Silencio de área"
end

L = BigWigs:NewBossLocale("Kaz'rogal", "esES") or BigWigs:NewBossLocale("Kaz'rogal", "esMX")
if L then
	L.mark_bar = "~Marca (%d)"
	L.mark_warn = "Marca en 5 seg"
end

L = BigWigs:NewBossLocale("Hyjal Summit Trash", "esES") or BigWigs:NewBossLocale("Hyjal Summit Trash", "esMX")
if L then
	L.waves = "Oleadas"
	L.waves_desc = "Avisos aproximados para cada oleada."

	L.ghoul = "Necrófagos"
	L.fiend = "Malignos de cripta"
	L.abom = "Abominación"
	L.necro = "Nigromantes"
	L.banshee = "Almas en pena"
	L.garg = "Gárgolas"
	L.wyrm = "Vermis de escarcha"
	L.fel = "Acechador vil"
	L.infernal = "Infernales"
	L.one = "¡Oleada %d! %d %s"
	L.two = "¡Oleada %d! %d %s, %d %s"
	L.three = "¡Oleada %d! %d %s, %d %s, %d %s"
	L.four = "¡Oleada %d! %d %s, %d %s, %d %s, %d %s"
	L.five = "¡Oleada %d! %d %s, %d %s, %d %s, %d %s, %d %s"
	L.barWave = "Oleada %d aparece"

	L.waveInc = "¡Oleada %d viene!"
	L.message = "¡%s en ~%d seg!"
	L.waveMessage = "¡Oleada %d en ~%d seg!"

	L.winterchillGossip = "Mis compañeros y yo estamos contigo, Lady Valiente."
	L.anetheronGossip = "Estamos listos para cualquier cosa que Archimonde nos mande, lady Valiente."
	L.kazrogalGossip = "Estoy contigo, Thrall."
	L.azgalorGossip = "No tenemos nada que temer."
end
