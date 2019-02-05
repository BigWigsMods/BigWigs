local L = BigWigs:NewBossLocale("Battle of Dazar'alor Trash", "zhTW")
if not L then return end
if L then
	L.punisher = "拉斯塔瑞懲戒者"
	L.vessel = "伯昂薩姆第的容器"

	L.victim = "%s的%s刺中了你！"
	L.witness = "%1$s的%3$s刺中了%2$s！"
end

L = BigWigs:NewBossLocale("Champion of the Light Horde", "zhTW")
if L then
	L.disorient_desc = "為|cff71d5ff[盲信]|r顯示施法條，如果你需要顯示精確的施法進度。" -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Champion of the Light Alliance", "zhTW")
if L then
	L.disorient_desc = "為|cff71d5ff[盲信]|r顯示施法條，如果你需要顯示精確的施法進度。" -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Jadefire Masters Horde", "zhTW")
if L then
	L.custom_on_fixate_plates = "在敵方名條顯示追獵圖示"
	L.custom_on_fixate_plates_desc = "當你被追獵時，在敵方名條上顯示一個圖示。\n需要啟用敵方名條，此功能目前只有KuiNameplates支援。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.interrupted_after = "%s被%s中斷（尚餘%.1f秒）"
end

L = BigWigs:NewBossLocale("Jadefire Masters Alliance", "zhTW")
if L then
	L.custom_on_fixate_plates = "在敵方名條顯示追獵圖示"
	L.custom_on_fixate_plates_desc = "當你被追獵時，在敵方名條上顯示一個圖示。\n需要啟用敵方名條，此功能目前只有KuiNameplates支援。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.interrupted_after = "%s被%s中斷（尚餘%.1f秒）"
end

L = BigWigs:NewBossLocale("Opulence", "zhTW")
if L then
	L.room = "房間（%d／8）"
	L.no_jewel = "無寶石："
	L.seconds = "%.1f秒"

	L.custom_on_fade_out_bars = "淡出第一階段計時條"
	L.custom_on_fade_out_bars_desc = "第一階段時，淡出另一個房間的首領技能計時條。"

	L.custom_on_hand_timers = "因扎希之手"
	L.custom_on_hand_timers_desc = "顯示因扎希之手的技能警報和計時條。"
	L.hand_cast = "手：%s"

	L.custom_on_bulwark_timers = "雅菈特的壁壘"
	L.custom_on_bulwark_timers_desc = "顯示雅菈特的壁壘的技能警報和計時條。"
	L.bulwark_cast = "壁壘：%s"
end

L = BigWigs:NewBossLocale("Conclave of the Chosen", "zhTW")
if L then
	L.killed = "%s%已擊殺！"
	L.count_of = "%s（%d／%d）"
end

L = BigWigs:NewBossLocale("High Tinker Mekkatorque", "zhTW")
if L then
	L.gigavolt_alt_text = "炸彈"

	L.custom_off_sparkbot_marker = "火花機器人標記"
	L.custom_off_sparkbot_marker_desc = "使用 {rt4}{rt5}{rt6}{rt7}{rt8} 標記火花機器人，需要權限。"
end

L = BigWigs:NewBossLocale("Stormwall Blockade", "zhTW")
if L then
	L.killed = "%s%已擊殺！"

	L.custom_on_fade_out_bars = "淡出第一階段計時條"
	L.custom_on_fade_out_bars_desc = "第一階段時，淡出另一條船上的首領技能計時條。"

	--L.custom_off_repeating_shrunk_say = "Repeating Shrunk Say" -- Shrunk = 284168
	--L.custom_off_repeating_shrunk_say_desc = "Spam Shrunk while you're |cff71d5ff[Shrunk]|r. Maybe they'll stop running you over."

	--L.custom_off_repeating_tampering_say = "Repeating Tampering Say" -- Tampering = 286105
	--L.custom_off_repeating_tampering_say_desc = "Spam your name while you're controlling a robot."
end

L = BigWigs:NewBossLocale("Lady Jaina Proudmoore", "zhTW")
if L then
	--L.starbord_ship_emote = "A Kul Tiran Corsair approaches on the starboard side!"
	--L.port_side_ship_emote = "A Kul Tiran Corsair approaches on the port side!"

	--L.starbord_txt = "Right Ship" -- starboard
	--L.port_side_txt = "Left Ship" -- port

	--L.ship_icon = "inv_garrison_cargoship"

	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Jaina randomizes which off-cooldown ability he uses next. When this option is enabled, the bars for those abilities will stay on your screen."

	--L.frozenblood_player = "%s (%d players)"

	--L.intermission_stage2 = "Stage 2 - %.1f sec"
end
