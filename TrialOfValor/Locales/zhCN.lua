local L = BigWigs:NewBossLocale("Odyn-TrialOfValor", "zhCN")
if not L then return end
if L then
	L.yields = "%s离场" -- used when Hymdall and Helya leave the fight in P2: "Hymdall yields"
	L[227490] = "|cFF800080右上|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	L[227491] = "|cFFFFA500右下|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	L[227498] = "|cFFFFFF00左下|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	L[227499] = "|cFF0000FF左上|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	L[227500] = "|cFF008000正上|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end

L = BigWigs:NewBossLocale("Guarm-TrialOfValor", "zhCN")
if L then
	L.lick = "舔舐" -- For translators: common name of 228248, 228253, 228228
	L.lick_desc = "显示不同舔舐的计时条。"
end

L = BigWigs:NewBossLocale("Helya-TrialOfValor", "zhCN")
if L then
	L.nearTrigger = "附近" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t一头%s出现在海拉的附近！
	L.farTrigger = "远处" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t一头%s出现在海拉的远处！
	L.tentacle_near = "海拉“附近”触须"
	L.tentacle_near_desc = "此选项可用于醒目或隐藏触须打击信息刷新在海拉附近。"
	L.tentacle_far = "海拉“远处”触须"
	L.tentacle_far_desc = "此选项可用于醒目或隐藏触须打击信息刷新在海拉远处。"

	L.orb_melee = "宝珠：近战计时器"
	L.orb_melee_desc = "显示腐化宝珠出现在近战的计时器。"
	L.orb_melee_bar = "近战宝珠"

	L.orb_ranged = "宝珠：远程计时器"
	L.orb_ranged_desc = "显示腐化宝珠出现在远程的计时器。"
	L.orb_ranged_bar = "远程宝珠"

	L.orb_say = "宝珠"
	L.taint_say = "海洋污染"
end
