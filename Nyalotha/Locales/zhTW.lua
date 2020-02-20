local L = BigWigs:NewBossLocale("Maut", "zhTW")
if not L then return end
if L then
	L.stage2_over = "第二階段結束：%.1f秒"
end

L = BigWigs:NewBossLocale("Shad'har the Insatiable", "zhTW")
if L then
	L.custom_on_stop_timers = "總是顯示計時器"
	L.custom_on_stop_timers_desc = "夏德哈會在下一次施放技能時隨機施放已經冷卻完畢的技能。啟用此選項後，這些技能的計時條會保持顯示。"
end

L = BigWigs:NewBossLocale("Drest'agath", "zhTW")
if L then
	L.adds_desc = "替卓雷阿葛斯的肢體顯示警告和訊息。"
	-- L.adds_icon = "achievement_nzothraid_drestagath"

	L.eye_killed = "眼已擊殺！"
	L.tentacle_killed = "觸手擊殺！"
	L.maw_killed = "口已擊殺！"
end

L = BigWigs:NewBossLocale("Il'gynoth, Corruption Reborn", "zhTW")
if L then
	L.custom_on_fixate_plates = "在敵方名條顯示鎖定圖示"
	L.custom_on_fixate_plates_desc = "當你被鎖定時，在敵方名條上顯示一個圖示。\n需要啟用敵方名條，此功能目前只有KuiNameplates支援。"
end

L = BigWigs:NewBossLocale("Vexiona", "zhTW")
if L then
	L.killed = "%s擊殺"
end

L = BigWigs:NewBossLocale("Ra-den the Despoiled", "zhTW")
if L then
	L.essences = "精華"
	L.essences_desc = "萊公會周期性地從其他領域汲取精華，不同的精華會賦予萊公不同的能量強化。"
end

L = BigWigs:NewBossLocale("Carapace of N'Zoth", "zhTW")
if L then
	L.player_membrane = "玩家胞膜" -- In stage 3
	L.boss_membrane = "首領胞膜" -- In stage 3
end

L = BigWigs:NewBossLocale("N'Zoth, the Corruptor", "zhTW")
if L then
	L.realm_switch = "領域轉換" -- When you leave the Mind of N'zoth

	L.custom_on_repeating_paranoia_say = "重覆妄想喊話"
	L.custom_on_repeating_paranoia_say_desc = "當你中了妄念時每秒重覆喊話，避免你的搭擋以外的人靠近你。"
	-- L.custom_on_repeating_paranoia_say_icon = 315927

	L.gateway_yell = "警告：心之室已遭到入侵。敵對勢力出現。" -- Yelled by MOTHER to trigger mythic only stage
	L.gateway_open = "傳送門開啟！"

	L.laser_left = "左轉射線"
	L.laser_right = "右轉射線"
end
