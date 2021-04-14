local L = BigWigs:NewBossLocale("ArchimondeHyjal", "frFR")
if not L then return end
if L then
	L.engage_trigger = "Votre résistance est futile."
	L.grip_other = "Poigne"
	L.fear_message = "Peur, prochain dans ~42 sec. !"

	L.killable = "Becomes Killable"
end

L = BigWigs:NewBossLocale("Azgalor", "frFR")
if L then
	L.howl_bar = "~Hurlement"
	L.howl_message = "Silence de zone"
end

L = BigWigs:NewBossLocale("Kaz'rogal", "frFR")
if L then
	L.mark_bar = "Prochaine marque (%d)"
	L.mark_warn = "Marque dans 5 sec. !"
end

L = BigWigs:NewBossLocale("Hyjal Summit Trash", "frFR")
if L then
	L.waves = "Avertissements des vagues"
	L.waves_desc = "Prévient quand la prochaine vague est susceptible d'arriver."

	L.ghoul = "goules"
	L.fiend = "démons des cryptes"
	L.abom = "abominations"
	L.necro = "nécromanciens"
	L.banshee = "banshees"
	L.garg = "gargouilles"
	L.wyrm = "wyrm de givre"
	L.fel = "traqueurs gangrenés"
	L.infernal = "infernaux"
	L.one = "%d|4ère:ème; vague ! %d %s"
	L.two = "%d|4ère:ème; vague ! %d %s, %d %s"
	L.three = "%d|4ère:ème; vague ! %d %s, %d %s, %d %s"
	L.four = "%d|4ère:ème; vague ! %d %s, %d %s, %d %s, %d %s"
	L.five = "%d|4ère:ème; vague ! %d %s, %d %s, %d %s, %d %s, %d %s"
	L.barWave = "Arrivée %d|4ère:ème; vague"

	L.waveInc = "Arrivée de la %d|4ère:ème; vague !"
	L.message = "%s dans ~%d sec. !"
	L.waveMessage = "%d|4ère:ème; vague dans ~%d sec. !"

	L.winterchillGossip = "Mes compagnons et moi sommes à vos côtés, dame Portvaillant."
	L.anetheronGossip = "Nous sommes prêts à affronter tout ce qu'Archimonde pourra mettre sur notre chemin, dame Portvaillant."
	L.kazrogalGossip = "Je suis avec vous, Thrall."
	L.azgalorGossip = "Nous n'avons rien à craindre."
end
