local L = BigWigs:NewBossLocale("Argus the Unmaker", "frFR")
if not L then return end
if L then
	L.combinedBurstAndBomb = "Combiner Explosion d'âme et Bombe d'âme"
	L.combinedBurstAndBomb_desc = "Les |cff71d5ffBombes d'âme|r sont toujours lancés en association avec des |cff71d5ffExplosions d'âme|r. Activez cette option pour combiner ces deux messages en un seul."

	L.custom_off_always_show_combined = "Toujours afficher les messages Explosion d'âme et Bombe d'âme combinés"
	L.custom_off_always_show_combined_desc = "Le message combiné ne s'affichera pas si vous êtes vous-même affecté par |cff71d5ffExplosion d'âme|r ou |cff71d5ffBombe d'âme|r. Activez cette option pour toujours avoir le message combiné, même si vous êtes affecté. |cff33ff99Pratique pour les chefs de raid.|r"

	--L.fear_help = "Sargeras' Fear Combination"
	--L.fear_help_desc = "Say a special message if you're afflicted by |cff71d5ffSargeras' Fear|r and |cff71d5ffSoulblight|r/|cff71d5ffSoulburst|r/|cff71d5ffSoulbomb|r/|cff71d5ffSentence of Sargeras|r."

	--L[257931] = "Fear" -- short for Sargeras' Fear
	--L[248396] = "Blight" -- short for Soulblight
	--L[251570] = "Bomb" -- short for Soulbomb
	--L[250669] = "Burst" -- short for Soulburst
	--L[257966] = "Sentence" -- short for Sentence of Sargeras

	L.stage2_early = "Que la fureur de la mer engloutisse la corruption !"
	L.stage3_early = "Aucun espoir, mais de la souffrance... et rien que de la souffrance !" -- à vérifier

	L.gifts = "Dons : %s (cieux), %s (mers)"
	L.burst = "|T1778229:15:15:0:0:64:64:4:60:4:60|tExplosion :%s" -- short for Soulburst
	L.bomb = "|T1778228:15:15:0:0:64:64:4:60:4:60|tBombe :%s" -- short for Soulbomb

	L.sky_say = "{rt5} Crit/Maît" -- short for Critical Strike/Mastery (stats)
	L.sea_say = "{rt6} Hâte/Poly" -- short for Haste/Versatility (stats)

	L.bomb_explosions = "Explosions des bombes"
	L.bomb_explosions_desc = "Affiche un délai pour les explosions de Explosion d'âme et Bombe d'âme."
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "frFR")
if L then
	L.torment_of_the_titans_desc = "Les Shivarra forceront les âmes des Titans d'utiliser leurs techniques contre les joueurs."

	L.timeLeft = "%.1fs" -- s = seconds
	L.torment = "Tourment : %s"
	L.nextTorment = "Prochain Tourment : |cffffffff%s|r"
	L.tormentHeal = "Soin/DoT" -- something like Heal/DoT (max 10 characters)
	L.tormentLightning = "Éclairs" -- short for "Chain Lightning" (or similar, max 10 characters)
	L.tormentArmy = "Armée" -- short for "Spectral Army of Norgannon" (or similar, max 10 characters)
	L.tormentFlames = "Flammes" -- short for "Flames of Khaz'goroth" (or similar, max 10 characters)
end

L = BigWigs:NewBossLocale("Eonar the Life-Binder", "frFR")
if L then
	L.warp_in_desc = "Affiche messages et délais pour chaque vague, ainsi que les adds spéciaux de chaque vague."

	L.top_lane = "Hau"
	L.mid_lane = "Mil"
	L.bot_lane = "Bas"

	L.purifier = "Purificateur" -- Fel-Powered Purifier
	L.destructor = "Destructeur" -- Fel-Infused Destructor
	L.obfuscator = "Négateur" -- Fel-Charged Obfuscator
	L.bats = "Gangroptères"
end

L = BigWigs:NewBossLocale("Portal Keeper Hasabel", "frFR")
if L then
	L.custom_on_stop_timers = "Toujours afficher les barres des techniques"
	L.custom_on_stop_timers_desc = "Hasabel choisit au hasard quelle technique hors cooldown elle utilise ensuite. Quand cette option est activée, les barres pour ces techniques resteront affichées sur votre écran."
	L.custom_on_filter_platforms = "Filtrer les barres & messages des plateformes latérales"
	L.custom_on_filter_platforms_desc = "Enlève les messages et les barres qui ne sont pas pertinents si vous n'êtes pas sur une plateforme latérale. Les barres et les alertes concernant la platforme principale, Nexus, seront toujours affichées."
	L.worldExplosion_desc = "Affiche un délai pour l'explosion d'Effondrement du monde."
	L.platform_active = "%s active !" -- Platform: Xoroth Active!
	L.add_killed = "%s tué !"
end

L = BigWigs:NewBossLocale("Kin'garoth", "frFR")
if L then
	--L.empowered = "(E) %s" -- (E) Ruiner
	L.gains = "Kin'garoth obtient %s" -- Kin'garoth gains Empowered Ruiner
end

L = BigWigs:NewBossLocale("Antoran High Command", "frFR")
if L then
	L.felshieldActivated = "Gangrebouclier activé par %s"
	L.felshieldUp = "Gangrebouclier en place"
end

L = BigWigs:NewBossLocale("Gorothi Worldbreaker", "frFR")
if L then
	L.cannon_ability_desc = "Affiche des messages et des barres relatifs aux 2 canons sur le dos du Brise-monde garothi."

	L.missileImpact = "Impact Annihilation"
	L.missileImpact_desc = "Affiche un délai pour l'atterrissage des missiles d'Annihilation."

	L.decimationImpact = "Impact Décimation"
	L.decimationImpact_desc = "Affiche un délai pour l'atterrissage des missiles de Décimation."
end
