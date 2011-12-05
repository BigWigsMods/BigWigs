local L = BigWigs:NewBossLocale("Morchok", "frFR")
if not L then return end
if L then
	L.engage_trigger = "Vous cherchez à arrêter l'avalanche. Je vais vous ensevelir."

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

	L.shadows = "Ombres"
end

L = BigWigs:NewBossLocale("Yor'sahj the Unsleeping", "frFR")
if L then
	L.engage_trigger = "Iilth qi'uothk shn'ma yeh'glu Shath'Yar! H'IWN IILTH!"

	L.bolt_desc = "Alerte pour tanks uniquement. Compte les cumuls d'éclairs de Vide et affiche une barre de durée."
	L.bolt_message = "%2$dx Éclairs sur %1$s"

	L.blue = "|cFF0080FFBleu|r"
	L.green = "|cFF088A08Vert|r"
	L.purple = "|cFF9932CDViolet|r"
	L.yellow = "|cFFFFA901Jaune|r"
	L.black = "|cFF424242Noir|r"
	L.red = "|cFFFF0404Rouge|r"

	L.blobs = "Globules"
	L.blobs_bar = "Proch. globules"
	L.blobs_desc = "Globules se déplacant en direction du boss."
end

L = BigWigs:NewBossLocale("Hagara the Stormbinder", "frFR")
if L then
	L.engage_trigger = "Vous êtes face à la Lieuse des tempêtes ! Je vais tous vous massacrer."

	L.lightning_or_frost = "Foudre ou Glace"
	L.ice_next = "Phase de glace"
	L.lightning_next = "Phase de foudre"

	L.nextphase = "Prochaine phase"
	L.nextphase_desc = "Prévient quand arrive la phase suivante."
end

L = BigWigs:NewBossLocale("Ultraxion", "frFR")
if L then
	L.engage_trigger = "L'heure du Crépuscule a sonné !"

	L.warmup = "Échauffement"
	L.warmup_desc = "Délai avant le début de la rencontre."
	L.warmup_trigger = "Je suis le début de la fin, l'ombre qui cache le soleil, le beffroi qui sonne votre glas."

	L.crystal = "Cristaux d'amélioration"
	L.crystal_desc = "Délais pour les divers cristaux d'amélioration que les PNJs invoquent."
	L.crystal_red = "Cristal rouge"
	L.crystal_green = "Cristal vert"
	L.crystal_blue = "Cristal bleu"

	L.twilight = "Twilight"
end

L = BigWigs:NewBossLocale("Warmaster Blackhorn", "frFR")
if L then
	L.harpooning = "Harponnage"

	L.rush = "Volée de lames"

	L.sunder = "Fracasser armure"
	L.sunder_desc = "Alerte pour tanks uniquement. Compte les cumuls de fracasser armure et affiche une barre de durée."
	L.sunder_message = "%2$dx Fracasser sur %1$s"

	L.sapper_trigger = "Un drake plonge et dépose un sapeur du Crépuscule sur le pont !" -- à vérifier
	L.sapper = "Sapeur"
	L.sapper_desc = "Sapeur infligeant des dégâts au vaisseau."
end

L = BigWigs:NewBossLocale("Spine of Deathwing", "frFR")
if L then
	L.left_start = "va faire un tonneau à gauche"
	L.right_start = "va faire un tonneau à droite"
	L.left = "fait un tonneau à gauche"
	L.right = "fait un tonneau à droite"

	L.roll_soon = "Tonneau imminent !"

	L.not_hooked = "Vous n'êtes >PAS< accroché !"
end

L = BigWigs:NewBossLocale("Madness of Deathwing", "frFR")
if L then

end

