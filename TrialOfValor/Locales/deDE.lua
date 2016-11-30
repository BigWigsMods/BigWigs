local L = BigWigs:NewBossLocale("Odyn-TrialOfValor", "deDE")
if not L then return end
if L then
	L.yields = "%s gibt auf" -- used when Hymdall and Helya leave the fight in P2: "Hymdall yields"
	L[227490] = "|cFF800080Oben Rechts|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	L[227491] = "|cFFFFA500Unten Rechts|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	L[227498] = "|cFFFFFF00Unten Links|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	L[227499] = "|cFF0000FFOben Links|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	L[227500] = "|cFF008000Oben|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end

L = BigWigs:NewBossLocale("Guarm-TrialOfValor", "deDE")
if L then
	L.lick = "Schlabbern" -- For translators: common name of 228248, 228253, 228228
	L.lick_desc = "Zeigt Leisten für die verschiedenen Arten des Schlabberns."
end

L = BigWigs:NewBossLocale("Helya-TrialOfValor", "deDE")
if L then
	L.nearTrigger = "Nähe" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t Ein %s erscheint in Helyas Nähe!
	L.farTrigger = "entfernt" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t Ein %s erscheint weit von Helya entfernt!
	L.tentacle_near = "Tentakel BEI Helya"
	L.tentacle_near_desc = "Diese Option kann verwendet werden, um die Nachrichten hervorzuheben oder auszublenden, wenn ein Zuschlagendes Tentakel in der Nähe von Helya erscheint."
	L.tentacle_far = "Tentakel weit ENTFERNT von Helya"
	L.tentacle_far_desc = "Diese Option kann verwendet werden, um die Nachrichten hervorzuheben oder auszublenden, wenn ein Zuschlagendes Tentakel weit entfernt von Helya erscheint."

	L.orb_melee = "Kugel: Nahkämpfer-Timer"
	L.orb_melee_desc = "Zeigt den Timer für die Kugeln, die auf Nahkämpfern erscheinen."
	L.orb_melee_bar = "Nahkämpfer-Kugel"

	L.orb_ranged = "Kugel: Fernkämpfer-Timer"
	L.orb_ranged_desc = "Zeigt den Timer für die Kugeln, die auf Fernkämpfern erscheinen."
	L.orb_ranged_bar = "Fernkämpfer-Kugel"

	L.orb_say = "Kugel"
	L.taint_say = "Verseuchung"
end
