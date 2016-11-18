local L = BigWigs:NewBossLocale("Odyn-TrialOfValor", "zhCN")
if not L then return end
if L then
	--L.yields = "%s yields" -- used when Hymdall and Helya leave the fight in P2: "Hymdall yields"
	L[227490] = "|cFF800080右上|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	L[227491] = "|cFFFFA500右下|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	L[227498] = "|cFFFFFF00左下|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	L[227499] = "|cFF0000FF左上|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	L[227500] = "|cFF008000上|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end

L = BigWigs:NewBossLocale("Helya-TrialOfValor", "zhCN")
if L then
	--L.nearTrigger = "near" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges near Helya! -- Translate this comment with the emote
	--L.farTrigger = "far" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges far from Helya! -- Translate this comment with the emote
	L.tentacle_near = "海拉“近点”触须"
	L.tentacle_near_desc = "此选项可用于醒目或隐藏触须打击信息刷新在海拉近点。"
	L.tentacle_far = "海拉“远点”触须"
	L.tentacle_far_desc = "此选项可用于醒目或隐藏触须打击信息刷新在海拉远点。"
end
