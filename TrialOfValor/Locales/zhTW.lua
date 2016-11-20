local L = BigWigs:NewBossLocale("Odyn-TrialOfValor", "zhTW")
if not L then return end
if L then
	--L.yields = "%s yields" -- used when Hymdall and Helya leave the fight in P2: "Hymdall yields"
	L[227490] = "|cFF800080右上|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	L[227491] = "|cFFFFA500右下|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	L[227498] = "|cFFFFFF00左下|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	L[227499] = "|cFF0000FF左上|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	L[227500] = "|cFF008000正上|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end

L = BigWigs:NewBossLocale("Helya-TrialOfValor", "zhTW")
if L then
	L.nearTrigger = "近處" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges near Helya! -- Translate this comment with the emote
	L.farTrigger = "遠處" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges far from Helya! -- Translate this comment with the emote
	L.tentacle_near = "近處觸手提示"
	L.tentacle_near_desc = "提示在黑爾雅近處的觸手，調整這個選項可以強調或隱蔵。"
	L.tentacle_far = "遠處觸手提示"
	L.tentacle_far_desc = "提示在黑爾雅遠處的觸手，調整這個選項可以強調或隱蔵。"
end
