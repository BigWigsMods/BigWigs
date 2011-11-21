
local L = BigWigs:NewBossLocale("Atramedes", "zhTW")
if not L then return end
if L then
	L.ground_phase = "地面階段"
	L.ground_phase_desc = "當亞特拉米德著陸時發出警報。"
	L.air_phase = "空中階段"
	L.air_phase_desc = "當亞特拉米德起飛時發出警報。"

	L.air_phase_trigger = "沒錯，逃吧!每一步都會讓你的心跳加速。跳得轟隆作響...震耳欲聾。你逃不掉的!"

	L.obnoxious_soon = "即將 討人厭的惡魔！"

	L.searing_soon = "10秒後，灼熱烈焰！"
end

L = BigWigs:NewBossLocale("Chimaeron", "zhTW")
if L then
	L.bileotron_engage = "「好膽」機器人開始活動，並且噴出一種惡臭的物質。"

	L.next_system_failure = "下一系統失效"
	L.break_message = "破壞%2$dx：>%1$s<！"

	L.phase2_message = "即將 致命性階段！"

	L.warmup = "暖身"
	L.warmup_desc = "暖身計時器。"
end

L = BigWigs:NewBossLocale("Magmaw", "zhTW")
if L then
	-- heroic
	L.blazing = "熾炎骸骨傀儡"
	L.blazing_desc = "當召喚熾炎骸骨傀儡時發出警報。"
	L.blazing_message = "即將 熾炎骸骨傀儡！"
	L.blazing_bar = "熾炎骸骨傀儡"

	L.armageddon = "末日風暴"
	L.armageddon_desc = "當頭部階段施放末日風暴時發出警報。"

	L.phase2 = "第二階段"
	L.phase2_desc = "當第二階段時顯示距離檢查。"
	L.phase2_message = "第二階段！"
	L.phase2_yell = "真難想像!看來你真有機會打敗我的蟲子!也許我可幫忙...扭轉戰局。"

	-- normal
	L.slump = "撲倒（騎乘）"
	L.slump_desc = "當熔喉撲倒並暴露時發出警報。"
	L.slump_bar = "騎乘"
	L.slump_message = "嘿，快騎上它！"
	L.slump_trigger = "%s往前撲倒，露出他的鉗子!"

	L.infection_message = ">你< 寄生感染！"

	L.expose_trigger = "露出了他的頭"
	L.expose_message = "頭部暴露！"

	L.spew_warning = "即將 熔岩噴灑！"
end

L = BigWigs:NewBossLocale("Maloriak", "zhTW")
if L then
	--heroic
	L.sludge = "黑暗淤泥"
	L.sludge_desc = "當你站在黑暗淤泥上面時發出警報。"
	L.sludge_message = ">你< 黑暗淤泥！"

	--normal
	L.final_phase = "最終階段"
	L.final_phase_soon = "即將 最終階段！"

	L.release_aberration_message = ">%s< 畸形者剩餘！"
	L.release_all = ">%s< 釋放畸形者！"

	L.phase = "階段"
	L.phase_desc = "當進入不同階段時發出警報。"
	L.next_phase = "下一階段！"
	L.green_phase_bar = "綠色階段"

	L.red_phase_trigger = "混合攪拌，然後加熱..."
	L.red_phase_emote_trigger = "紅色"
	L.red_phase = "|cFFFF0000紅色|r階段！"
	L.blue_phase_trigger = "凡人之軀能承受多大的溫度改變?必須測試!為了科學!"
	L.blue_phase_emote_trigger = "藍色"
	L.blue_phase = "|cFF809FFE藍色|r階段！"
	L.green_phase_trigger = "這個有點不穩定，但哪有實驗不失敗的?"
	L.green_phase_emote_trigger = "綠色"
	L.green_phase = "|cFF33FF00綠色|r階段！"
	L.dark_phase_trigger = "你的混合劑太弱了，瑪洛里亞克!需要多點...後勁!"
	L.dark_phase_emote_trigger = "黑色"
	L.dark_phase = "|cFF660099黑色|r階段！"
end

L = BigWigs:NewBossLocale("Nefarian", "zhTW")
if L then
	L.phase = "階段"
	L.phase_desc = "當進入不同階段時發出警報。"

	L.discharge_bar = "閃電釋放 冷卻"

	L.phase_two_trigger = "詛咒你們，凡人!如此冷酷地漠視他人的所有物必須受到嚴厲的懲罰!"

	L.phase_three_trigger = "我本來只想略盡地主之誼"

	L.crackle_trigger = "響起了電流霹啪作響的聲音!"
	L.crackle_message = "即將 電擊！"

	L.shadowblaze_trigger = "化為灰燼吧!"
	L.shadowblaze_message = ">你< 暗影炎！"

	L.onyxia_power_message = "即將 電荷超載！"

	L.chromatic_prototype = "炫彩原型體" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "zhTW")
if L then
	L.nef = "維克多·奈法利斯領主"
	L.nef_desc = "當維克多·奈法利斯領主施放技能時發出警報。"

	L.pool = "秘法逆爆"

	L.switch = "轉換"
	L.switch_desc = "當轉換時發出警報。"
	L.switch_message = ">%s< %s！"

	L.next_switch = "下一轉換"

	L.nef_next = "闇能灌注"

	L.acquiring_target = "鎖定目標"

	L.bomb_message = ">你< 毒泥炸彈追擊！"
	L.cloud_message = ">你< 化學毒霧！"
	L.protocol_message = "毒殺計畫！"

	L.iconomnotron = "標記啟動首領"
	L.iconomnotron_desc = "為啟動的首領打上主團隊標記。（需要權限）"
end

