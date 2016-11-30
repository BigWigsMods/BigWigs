local L = BigWigs:NewBossLocale("Odyn-TrialOfValor", "frFR")
if not L then return end
if L then
	--L.yields = "%s yields" -- used when Hymdall and Helya leave the fight in P2: "Hymdall yields"
	L[227490] = "|cFF800080En haut à droite|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	L[227491] = "|cFFFFA500En bas à droite|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	L[227498] = "|cFFFFFF00En bas à gauche|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	L[227499] = "|cFF0000FFEn haut à gauche|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	L[227500] = "|cFF008000En haut|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end

L = BigWigs:NewBossLocale("Guarm-TrialOfValor", "frFR")
if L then
	L.lick = "Langue"
	L.lick_desc = "Affiche les barres des différentes langues."
end

L = BigWigs:NewBossLocale("Helya-TrialOfValor", "frFR")
if L then
	L.nearTrigger = "à proximité" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t Un %s apparaît à proximité de Helya !
	L.farTrigger = "loin" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t Un %s apparaît loin de Helya !
	L.tentacle_near = "Tentacule PRÈS de Helya"
	L.tentacle_near_desc = "Cette option peut être utilisée pour mettre en évidence ou cacher les messages affichés quand un Tentacule frappeur apparaît près de Helya."
	L.tentacle_far = "Tentacule LOIN de Helya"
	L.tentacle_far_desc = "Cette option peut être utilisée pour mettre en évidence ou cacher les messages affichés quand un Tentacule frappeur apparaît loin de Helya."

	L.orb_melee = "Délai Orbe en mêlée"
	L.orb_melee_desc = "Affiche le délai des Orbes apparaissant sur les joueurs de mêlée."
	L.orb_melee_bar = "Orbe en mêlée"

	L.orb_ranged = "Délai Orbe à distance"
	L.orb_ranged_desc = "Affiche le delai des Orbes apparaissant sur les joueurs à distance."
	L.orb_ranged_bar = "Orbe à distance"

	L.orb_say = "Orbe"
	L.taint_say = "Souillure"
end
