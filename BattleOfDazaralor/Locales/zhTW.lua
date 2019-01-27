local L = BigWigs:NewBossLocale("Conclave of the Chosen", "zhTW")
if not L then return end
if L then
	L.killed = "%已擊殺！"
end

local L = BigWigs:NewBossLocale("Frida Ironbellows", "zhTW")
if not L then return end
if L then
	L.disorient_desc = "為|cff71d5ff[盲信]|r顯示施法條，如果你需要一個倒數計時的話。\n" -- Blinding Faith = 283650
end

local L = BigWigs:NewBossLocale("Ra'wani Kanae", "zhTW")
if not L then return end
if L then
	L.disorient_desc = "為|cff71d5ff[盲信]|r顯示施法條，如果你需要一個倒數計時的話。\n" -- Blinding Faith = 283650
end

local L = BigWigs:NewBossLocale("Flamefist and the Illuminated", "zhTW")
if not L then return end
if L then
	L.custom_on_fixate_plates = "在敵方名條顯示追獵圖示"
	L.custom_on_fixate_plates_desc = "當你被追獵時，在敵方名條上顯示一個圖示。\n需要啟用敵方名條，此功能目前只有KuiNameplates支援。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.interrupted_after = "%s被%s中斷（尚餘%.1f秒）"
end

L = BigWigs:NewBossLocale("Grimfang and Firecaller", "zhTW")
if L then
	L.custom_on_fixate_plates = "在敵方名條顯示追獵圖示"
	L.custom_on_fixate_plates_desc = "當你被追獵時，在敵方名條上顯示一個圖示。\n需要啟用敵方名條，此功能目前只有KuiNameplates支援。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.interrupted_after = "%s被%s中斷（尚餘%.1f秒）"
end

L = BigWigs:NewBossLocale("High Tinker Mekkatorque", "zhCN")
if L then
	L.gigavolt_alt_text = "炸彈"

	L.custom_off_sparkbot_marker = "火花機器人標記"
	L.custom_off_sparkbot_marker_desc = "使用 {rt4}{rt5}{rt6}{rt7}{rt8} 標記火花機器人，需要權限。"
end

L = BigWigs:NewBossLocale("Treasure Guardian", "zhTW")
if L then
	L.custom_on_hand_timers = "因扎希之手"
	L.custom_on_hand_timers_desc = "顯示因扎希之手的技能警報和計時器。"
	L.hand_cast = "手：%s"

	L.custom_on_bulwark_timers = "雅菈特的壁壘"
	L.custom_on_bulwark_timers_desc = "顯示雅菈特的壁壘的技能警報和計時器。"
	L.bulwark_cast = "壁壘：%s"
end
