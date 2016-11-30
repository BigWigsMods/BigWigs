local L = BigWigs:NewBossLocale("Odyn-TrialOfValor", "ruRU")
if not L then return end
if L then
	L.yields = "%s отступает" -- used when Hymdall and Helya leave the fight in P2: "Hymdall yields"
	L[227490] = "|cFF800080Вверху справа|r (|T1323037:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Purple
	L[227491] = "|cFFFFA500Внизу справа|r (|T1323039:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Orange
	L[227498] = "|cFFFFFF00Внизу слева|r (|T1323038:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Yellow
	L[227499] = "|cFF0000FFВверху слева|r (|T1323035:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Blue
	L[227500] = "|cFF008000Вверху|r (|T1323036:15:15:0:0:64:64:4:60:4:60|t)" -- Boss_OdunRunes_Green
end

L = BigWigs:NewBossLocale("Guarm-TrialOfValor", "ruRU")
if L then
	L.lick = "Язык" -- For translators: common name of 228248, 228253, 228228
	L.lick_desc = "Показывать полосы для разных языков."
end

L = BigWigs:NewBossLocale("Helya-TrialOfValor", "ruRU")
if L then
	L.nearTrigger = "Возле" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20| Возле Хелии появляется %s!
	L.farTrigger = "Вдалеке" -- |TInterface\\Icons\\inv_misc_monsterhorn_03.blp:20|t Вдалеке от Хелии появляется %s!
	L.tentacle_near = "Щупальце РЯДОМ с Хелией"
	L.tentacle_near_desc = "Эта настройка может использоваться для уведомления или скрытия анонса о щупальцах, появляющихся рядом с Хелией."
	L.tentacle_far = "Щупальце ВДАЛИ от Хелии"
	L.tentacle_far_desc = "Эта настройка может использоваться для уведомления или скрытия анонса о щупальцах, появляющихся вдали от Хелии."

	L.orb_melee = "Сфера: таймер для бойца ближнего боя"
	L.orb_melee_desc = "Показывать таймер для сфер, которые появляются в бойцах ближнего боя."
	L.orb_melee_bar = "Сфера в мили"

	L.orb_ranged = "Сфера: таймер для бойца дальнего боя"
	L.orb_ranged_desc = "Показывать таймер для сфер, которые появляются в бойцах дальнего боя."
	L.orb_ranged_bar = "Сфера в рдд"

	L.orb_say = "Сфера"
	L.taint_say = "Порча"
end
