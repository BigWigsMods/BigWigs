local L = BigWigs:NewBossLocale("Argus the Unmaker", "frFR")
if not L then return end
if L then
	--L.stage2_early = "Let the fury of the sea wash away this corruption!"
	--L.stage3_early = "No hope. Just pain. Only pain!"
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "frFR")
if L then
	L.torment_of_the_titans_desc = "Les Shivvara forceront les âmes des Titans d'utiliser leurs techniques contre les joueurs."
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
	L.custom_on_filter_platforms = "Filtrer les barres & messages des plateformes latérales"
	L.custom_on_filter_platforms_desc = "Enlève les messages et les barres qui ne sont pas pertinents si vous n'êtes pas sur une plateforme latérale. Les barres et les alertes concernant la platforme principale, Nexus, seront toujours affichées."
	L.platform_active = "%s active !" -- Platform: Xoroth Active!
end

L = BigWigs:NewBossLocale("Kin'garoth", "frFR")
if L then
	--L.empowered = "(E) %s" -- (E) Ruiner
	--L.gains = "Kin'garoth gains %s" -- Kin'garoth gains Empowered Ruiner
end

L = BigWigs:NewBossLocale("Gorothi Worldbreaker", "frFR")
if L then
	L.cannon_ability_desc = "Affiche des messages et des barres relatifs aux 2 canons sur le dos du Brise-monde garothi."
end



