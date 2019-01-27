local L = BigWigs:NewBossLocale("Champion of the Light Horde", "zhTW")
if not L then return end
if L then
	--L.disorient_desc = "Bar for the |cff71d5ff[Blinding Faith]|r cast.\nThis is probably the bar you want to have the countdown on." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Champion of the Light Alliance", "zhTW")
if L then
	--L.disorient_desc = "Bar for the |cff71d5ff[Blinding Faith]|r cast.\nThis is probably the bar you want to have the countdown on." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Jadefire Masters Horde", "zhTW")
if L then
	L.custom_on_fixate_plates = "追蹤圖示位於敵方名條"
	L.custom_on_fixate_plates_desc = "當你被追蹤時在目標名條上顯示一個圖示。\n需要使用敵方名條。此功能目前只支援 KuiNameplates。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.interrupted_after = "%s被%s中斷（%.1f秒剩餘）"
end

L = BigWigs:NewBossLocale("Jadefire Masters Alliance", "zhTW")
if L then
	L.custom_on_fixate_plates = "追蹤圖示位於敵方名條"
	L.custom_on_fixate_plates_desc = "當你被追蹤時在目標名條上顯示一個圖示。\n需要使用敵方名條。此功能目前只支援 KuiNameplates。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.interrupted_after = "%s被%s中斷（%.1f秒剩餘）"
end

L = BigWigs:NewBossLocale("Opulence", "zhTW")
if L then
	L.custom_on_hand_timers = "因扎希之手"
	L.custom_on_hand_timers_desc = "顯示因扎希之手技能警報和計時條。"
	L.hand_cast = "手：%s"

	L.custom_on_bulwark_timers = "雅菈特的壁壘"
	L.custom_on_bulwark_timers_desc = "顯示雅菈特的壁壘技能警報和計時條。"
	L.bulwark_cast = "壁壘：%s"
end

L = BigWigs:NewBossLocale("Conclave of the Chosen", "zhTW")
if L then
	--L.killed = "%s killed!"
	L.count_of = "%s （%d/%d）"
end

L = BigWigs:NewBossLocale("High Tinker Mekkatorque", "zhTW")
if L then
	--L.gigavolt_alt_text = "Bomb"

	--L.custom_off_sparkbot_marker = "Spark Bot Marker"
	--L.custom_off_sparkbot_marker_desc = "Mark Spark Bots with {rt4}{rt5}{rt6}{rt7}{rt8}."
end
