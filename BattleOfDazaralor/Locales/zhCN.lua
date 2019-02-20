local L = BigWigs:NewBossLocale("Battle of Dazar'alor Trash", "zhCN")
if not L then return end
if L then
	L.enforcer = "永恒执行者"
	L.punisher = "拉斯塔利惩罚者"
	L.vessel = "邦桑迪的使者"

	L.victim = "%s的%s刺中了你！"
	L.witness = "%1$s的%3$s刺中了%2$s！"
end

L = BigWigs:NewBossLocale("Champion of the Light Horde", "zhCN")
if L then
	L.disorient_desc = "|cff71d5ff[炫目信仰]|r施放计时条。\n这可能是你所需要的倒数计时条。" -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Champion of the Light Alliance", "zhCN")
if L then
	L.disorient_desc = "|cff71d5ff[炫目信仰]|r施放计时条。\n这可能是你所需要的倒数计时条。" -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Jadefire Masters Horde", "zhCN")
if L then
	L.custom_on_fixate_plates = "追踪图标位于敌对姓名板"
	L.custom_on_fixate_plates_desc = "当你被追踪时在目标姓名板上显示一个图标。\n需要使用敌对姓名板。此功能目前只支持 KuiNameplates。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.interrupted_after = "%s被%s中断（剩余%.1f秒）"
end

L = BigWigs:NewBossLocale("Jadefire Masters Alliance", "zhCN")
if L then
	L.custom_on_fixate_plates = "追踪图标位于敌对姓名板"
	L.custom_on_fixate_plates_desc = "当你被追踪时在目标姓名板上显示一个图标。\n需要使用敌对姓名板。此功能目前只支持 KuiNameplates。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.interrupted_after = "%s被%s中断（剩余%.1f秒）"
end

L = BigWigs:NewBossLocale("Opulence", "zhCN")
if L then
	L.room = "房间（%d/8）"
	L.no_jewel = "没有宝石："

	L.custom_on_fade_out_bars = "淡出第1阶段计时条"
	L.custom_on_fade_out_bars_desc = "第1阶段时，淡出另一侧房间的首领技能计时条。"

	L.custom_on_hand_timers = "因扎希之手"
	L.custom_on_hand_timers_desc = "显示因扎希之手技能警报和计时条。"
	L.hand_cast = "手：%s"

	L.custom_on_bulwark_timers = "亚拉特的堡垒"
	L.custom_on_bulwark_timers_desc = "显示亚拉特的堡垒技能警报和计时条。"
	L.bulwark_cast = "堡垒：%s"
end

L = BigWigs:NewBossLocale("Conclave of the Chosen", "zhCN")
if L then
	L.killed = "%s已击杀！"
	L.count_of = "%s（%d/%d）"
end

L = BigWigs:NewBossLocale("High Tinker Mekkatorque", "zhCN")
if L then
	L.gigavolt_alt_text = "炸弹"

	L.custom_off_sparkbot_marker = "火花机器人标记"
	L.custom_off_sparkbot_marker_desc = "使用 {rt4}{rt5}{rt6}{rt7}{rt8} 标记火花机器人。"

	L.custom_off_repeating_shrunk_say = "重复缩小喊话" -- Shrunk = 284168
	L.custom_off_repeating_shrunk_say_desc = "当你受到|cff71d5ff[缩小]|r时重复喊话。这可能防止你被踩死。"

	L.custom_off_repeating_tampering_say = "重复干涉喊话" -- Tampering = 286105
	L.custom_off_repeating_tampering_say_desc = "当你控制机器人时重复喊话你的名字。"
end

L = BigWigs:NewBossLocale("Stormwall Blockade", "zhCN")
if L then
	L.killed = "%s已击杀！"

	L.custom_on_fade_out_bars = "淡出第1阶段计时条"
	L.custom_on_fade_out_bars_desc = "第1阶段时，淡出另一条船上的首领技能计时条。"
end

L = BigWigs:NewBossLocale("Lady Jaina Proudmoore", "zhCN")
if L then
	L.starbord_ship_emote = "一帮库尔提拉斯海盗朝右舷冲来了！"
	L.port_side_ship_emote = "一帮库尔提拉斯海盗朝左舷冲来了！"

	L.starbord_txt = "右舰" -- starboard
	L.port_side_txt = "左舰" -- port

	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "吉安娜下次会随机释放非冷却技能。当此选项开启，这些技能条将保留在屏幕上。"

	L.frozenblood_player = "%s（%d人）"

	L.intermission_stage2 = "第2阶段 - %.1f秒"
end
