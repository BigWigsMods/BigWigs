local L = BigWigs:NewBossLocale("Morchok", "frFR")
if not L then return end
if L then
	L.crush = "Ecraser armure"
	L.crush_desc = "Alerte pour tanks uniquement. Compte les cumuls d'écraser armure et affiche une barre de durée."
	L.crush_icon = 103687
	L.crush_message = "%2$dx Ecraser sur %1$s"

	L.explosion = "Explosion"
end

L = BigWigs:NewBossLocale("Warlord Zon'ozz", "frFR")
if L then
	L.ball = "Boule de Vide"
	L.ball_desc = "Boule de Vide qui rebondit contre les joueurs et le boss."
	L.ball_icon = 28028 -- void sphere icon

	L.bounce = "Rebond de la boule de Vide"
	L.bounce_desc = "Compteur des rebonds de la boule de Vide."
	L.bounce_icon = 73981 -- some bouncing bullet like icon

	L.darkness = "Tentacle disco party!"
	L.darkness_desc = "Cette phase commence quand la boule de Vide touche le boss."
	L.darkness_icon = 109413
end

L = BigWigs:NewBossLocale("Yor'sahj the Unsleeping", "frFR")
if L then
	L.bolt = "Éclair de Vide"
	L.bolt_desc = "Alerte pour tanks uniquement. Compte les cumuls d'éclairs de Vide et affiche une barre de durée."
	L.bolt_icon = 108383
	L.bolt_message = "%2$dx Éclairs sur %1$s"

	L.blue = "Bleu"
	L.green = "Vert"
	L.purple = "Violet"
	L.yellow = "Jaune"
	L.black = "Noir"
	L.red = "Rouge"

	L.blobs = "Globules"
	L.blobs_bar = "Proch. globules"
	L.blobs_desc = "Globules se déplacant en direction du boss."
	L.blobs_icon = "achievement_doublerainbow"
end

L = BigWigs:NewBossLocale("Hagara the Stormbinder", "frFR")
if L then

end

L = BigWigs:NewBossLocale("Ultraxion", "frFR")
if L then
	L.engage_trigger = "I sense a great disturbance in the balance approaching. The chaos of it burns my mind"

	L.warmup = "Échauffement"
	L.warmup_desc = "Délai indiquant le temps restant avant le début de la rencontre."
end

L = BigWigs:NewBossLocale("Warmaster Blackhorn", "frFR")
if L then
	L.harpooning = "Harponnage"

	L.rush = "Volée de lames"
	L.rush_desc = select(2, EJ_GetSectionInfo(4198))
	L.rush_icon = 100 -- charge icon

	L.sunder = "Fracasser armure"
	L.sunder_desc = "Alerte pour tanks uniquement. Compte les cumuls de fracasser armure et affiche une barre de durée."
	L.sunder_icon = 108043
	L.sunder_message = "%2$dx Fracasser sur %1$s"
end

L = BigWigs:NewBossLocale("Spine of Deathwing", "frFR")
if L then
	L.left_start = "va faire un tonneau à gauche"
	L.right_start = "va faire un tonneau à droite"
	L.left = "fait un tonneau à gauche"
	L.right = "fait un tonneau à droite"

	L.roll, L.roll_desc = EJ_GetSectionInfo(4050)
	L.roll_icon = "ACHIEVEMENT_BG_RETURNXFLAGS_DEF_WSG"
	L.roll_soon = "Tonneau imminent !"

	L.not_hooked = "Vous n'êtes PAS accroché !"
end

L = BigWigs:NewBossLocale("Madness of Deathwing", "frFR")
if L then

end

