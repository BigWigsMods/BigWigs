local L = BigWigs:NewBossLocale("Champion of the Light Horde", "zhCN")
if not L then return end
if L then
	--L.disorient_desc = "Bar for the |cff71d5ff[Blinding Faith]|r cast.\nThis is probably the bar you want to have the countdown on." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Champion of the Light Alliance", "zhCN")
if L then
	--L.disorient_desc = "Bar for the |cff71d5ff[Blinding Faith]|r cast.\nThis is probably the bar you want to have the countdown on." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Jadefire Masters Horde", "zhCN")
if L then
	L.custom_on_fixate_plates = "追踪图标位于敌对姓名板"
	L.custom_on_fixate_plates_desc = "当你被追踪时在目标姓名板上显示一个图标。\n需要使用敌对姓名板。此功能目前只支持 KuiNameplates。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.interrupted_after = "%s被%s中断（%.1f秒剩余）"
end

L = BigWigs:NewBossLocale("Jadefire Masters Alliance", "zhCN")
if L then
	L.custom_on_fixate_plates = "追踪图标位于敌对姓名板"
	L.custom_on_fixate_plates_desc = "当你被追踪时在目标姓名板上显示一个图标。\n需要使用敌对姓名板。此功能目前只支持 KuiNameplates。"

	L.absorb = "吸收"
	L.absorb_text = "%s（|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒（|cff%s%.0f%%|r）"

	L.interrupted_after = "%s被%s中断（%.1f秒剩余）"
end

L = BigWigs:NewBossLocale("Opulence", "zhCN")
if L then
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
	L.count_of = "%s （%d/%d）"
end

L = BigWigs:NewBossLocale("High Tinker Mekkatorque", "zhCN")
if L then
	L.gigavolt_alt_text = "炸弹"

	L.custom_off_sparkbot_marker = "火花机器人标记"
	L.custom_off_sparkbot_marker_desc = "使用 {rt4}{rt5}{rt6}{rt7}{rt8} 标记火花机器人。"
end

L = BigWigs:NewBossLocale("Battle of Dazar'alor Trash", "zhCN")
if L then
	--L.punisher = "Rastari Punisher"
	--L.vessel = "Vessel of Bwonsamdi"

	--L.victim = "%s stabbed YOU with %s!"
	--L.witness = "%s stabbed %s with %s!"
end
