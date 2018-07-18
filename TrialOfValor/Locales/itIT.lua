local L = BigWigs:NewBossLocale("Odyn-TrialOfValor", "itIT")
if not L then return end
if L then
	--L.yields = "%s yields" -- used when Hymdall and Helya leave the fight in P2: "Hymdall yields"
	--L[227490] = "|cFF800080Top Right|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	--L[227491] = "|cFFFFA500Bottom Right|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	--L[227498] = "|cFFFFFF00Bottom Left|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	--L[227499] = "|cFF0000FFTop Left|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	--L[227500] = "|cFF008000Top|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end

L = BigWigs:NewBossLocale("Guarm-TrialOfValor", "itIT")
if L then
	--L.lick = "Lick" -- For translators: common name of 228248, 228253, 228228
	--L.lick_desc = "Show bars for the different licks."
end

L = BigWigs:NewBossLocale("Helya-TrialOfValor", "itIT")
if L then
	L.nearTrigger = "vicino" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t Un %s emerge vicino a Helya!
	L.farTrigger = "lontano" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t Un %s emerge lontano da Helya!
	--L.tentacle_near = "Tentacle NEAR Helya"
	--L.tentacle_near_desc = "This option can be used to emphasize or hide the messages when a Striking Tentacle spawns near Helya."
	--L.tentacle_far = "Tentacle FAR from Helya"
	--L.tentacle_far_desc = "This option can be used to emphasize or hide the messages when a Striking Tentacle spawns far from Helya."

	--L.orb_melee = "Orb: Melee timer"
	--L.orb_melee_desc = "Show the timer for the Orbs that spawn on Melee."
	--L.orb_melee_bar = "Melee Orb"

	--L.orb_ranged = "Orb: Ranged timer"
	--L.orb_ranged_desc = "Show the timer for the Orbs that spawn on Ranged."
	--L.orb_ranged_bar = "Ranged Orb"

	L.orb_say = "Globo"
	L.taint_say = "Contaminazione"
end
