local L = BigWigs:NewBossLocale("Odyn-TrialOfValor", "deDE")
if not L then return end
if L then
	--L.yields = "%s yields" -- used when Hymdall and Helya leave the fight in P2: "Hymdall yields"
	L[227490] = "|cFF800080Oben Rechts|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	L[227491] = "|cFFFFA500Unten Rechts|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	L[227498] = "|cFFFFFF00Unten Links|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	L[227499] = "|cFF0000FFOben Links|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	L[227500] = "|cFF008000Oben|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end

L = BigWigs:NewBossLocale("Helya-TrialOfValor", "deDE")
if L then
	L.nearTrigger = "Nähe" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges near Helya! -- Translate this comment with the emote
	--L.farTrigger = "far" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t A %s emerges far from Helya! -- Translate this comment with the emote
	L.tentacle_near = "Tentakel BEI Helya"
	L.tentacle_near_desc = "Diese Option kann verwendet werden, um die Nachrichten hervorzuheben oder auszublenden, wenn ein Zuschlagendes Tentakel in der Nähe von Helya erscheint."
	L.tentacle_far = "Tentakel weit ENTFERNT von Helya"
	L.tentacle_far_desc = "Diese Option kann verwendet werden, um die Nachrichten hervorzuheben oder auszublenden, wenn ein Zuschlagendes Tentakel weit entfernt von Helya erscheint."
end
