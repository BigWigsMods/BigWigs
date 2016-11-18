local L = BigWigs:NewBossLocale("Odyn-TrialOfValor", "frFR")
if not L then return end
if L then
	L[227490] = "|cFF800080En haut à droite|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	L[227491] = "|cFFFFA500En bas à droite|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	L[227498] = "|cFFFFFF00En bas à gauche|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	L[227499] = "|cFF0000FFEn haut à gauche|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	L[227500] = "|cFF008000En haut|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end

L = BigWigs:NewBossLocale("Helya-TrialOfValor", "frFR")
if L then
	L.nearTrigger = "près" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges near Helya! -- Translate this comment with the emote
	--L.farTrigger = "far" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges far from Helya! -- Translate this comment with the emote
	L.tentacle_near = "Tentacule PRÈS d'Helya"
	L.tentacle_near_desc = "Cette option peut être utilisée pour mettre en évidence ou cacher les messages affichés quand un Tentacule frappeur apparaît près d'Helya."
	L.tentacle_far = "Tentacule LOIN d'Helya"
	L.tentacle_far_desc = "Cette option peut être utilisée pour mettre en évidence ou cacher les messages affichés quand un Tentacule frappeur apparaît loin d'Helya."
end
