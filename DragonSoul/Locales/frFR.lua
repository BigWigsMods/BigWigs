local L = BigWigs:NewBossLocale("Morchok", "frFR")
if not L then return end
if L then
	L.engage_trigger = "Vous cherchez à arrêter l'avalanche. Je vais vous ensevelir." -- à vérifier

	L.crush = "Ecraser armure"
	L.crush_desc = "Alerte pour tanks uniquement. Compte les cumuls d'écraser armure et affiche une barre de durée."
	L.crush_message = "%2$dx Ecraser sur %1$s"

	L.blood = "Sang"

	L.explosion = "Explosion"
end

L = BigWigs:NewBossLocale("Warlord Zon'ozz", "frFR")
if L then
	L.engage_trigger = "Zzof Shuul'wah. Thoq fssh N'Zoth!"

	L.ball = "Boule de Vide"
	L.ball_desc = "Boule de Vide qui rebondit contre les joueurs et le boss."

	L.bounce = "Rebond de la boule de Vide"
	L.bounce_desc = "Compteur des rebonds de la boule de Vide."

	L.darkness = "La boum des tentacules !"
	L.darkness_desc = "Cette phase commence quand la boule de Vide touche le boss."
end

L = BigWigs:NewBossLocale("Yor'sahj the Unsleeping", "frFR")
if L then
	L.engage_trigger = "Iilth qi'uothk shn'ma yeh'glu Shath'Yar! H'IWN IILTH!"

	L.bolt = "Éclair de Vide"
	L.bolt_desc = "Alerte pour tanks uniquement. Compte les cumuls d'éclairs de Vide et affiche une barre de durée."
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
	L.engage_trigger = "Vous êtes face à la Lieuse des tempêtes ! Je vais tous vous massacrer." -- à vérifier

	L.lightning_or_frost = "Foudre ou Glace"
	L.ice_next = "Phase de glace"
	L.lightning_next = "Phase de foudre"

	L.nextphase = "Prochaine phase"
	L.nextphase_desc = "Prévient quand arrive la phase suivante."
end

L = BigWigs:NewBossLocale("Ultraxion", "frFR")
if L then
	L.engage_trigger = "Je suis le début de la fin" -- à compléter

	L.warmup = "Échauffement"
	L.warmup_desc = "Délai indiquant le temps restant avant le début de la rencontre."
end

L = BigWigs:NewBossLocale("Warmaster Blackhorn", "frFR")
if L then
	L.harpooning = "Harponnage"

	L.rush = "Volée de lames"
	L.rush_desc = select(2, EJ_GetSectionInfo(4198))

	L.sunder = "Fracasser armure"
	L.sunder_desc = "Alerte pour tanks uniquement. Compte les cumuls de fracasser armure et affiche une barre de durée."
	L.sunder_message = "%2$dx Fracasser sur %1$s"

	L.sapper_trigger = "A drake swoops down to drop a Twilight Sapper onto the deck!" -- à traduire
	L.sapper = "Sapeur"
	L.sapper_desc = "Sappeur infligeant des dégâts au vaisseau."
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

	L.not_hooked = "Vous n'êtes >PAS< accroché !"
end

L = BigWigs:NewBossLocale("Madness of Deathwing", "frFR")
if L then

end

