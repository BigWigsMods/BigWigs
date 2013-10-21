local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "zhTW")
if not L then return end
if L then
	L.engage_yell = "聖女皇選上我們將她神聖的意志傳達給凡人。我們只是實現她意志的軀殼。"

	L.force_message = "力與魄(AoE)"

	L.attenuation = EJ_GetSectionInfo(6426) .. "（跳舞）"
	L.attenuation_bar = "定音區... 跳吧!"
	L.attenuation_message = "%s 跳舞 %s"
	L.echo = "|c001cc986回音|r"
	L.zorlok = "|c00ed1ffa索拉格|r"
	L.left = "|c00008000<- 往左 <-|r"
	L.right = "|c00FF0000-> 往右 ->|r"

	L.platform_emote = "女皇大臣索拉格飛向他的其中一個露臺!" -- Imperial Vizier Zor'lok flies to one of his platforms!
	L.platform_emote_final = "吸氣"-- Imperial Vizier Zor'lok inhales the Pheromones of Zeal!
	L.platform_message = "切換平台"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "zhTW")
if L then
	L.engage_yell = "自求多福吧，入侵者。我，刀鋒領主塔亞克，將是你們的對手。"

	L.unseenstrike_soon = "5-10秒後無形打擊(%d)！"
	L.assault_message = "壓倒性的襲擊"
	L.side_swap = "換邊"

	L.custom_off_windstep = "疾風步標記"
	L.custom_off_windstep_desc = "幫助治療分配，使用 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6} 標記玩家受到疾風步，需要權限。"
end

L = BigWigs:NewBossLocale("Garalon", "zhTW")
if L then
	L.phase2_trigger = "Garalon's massive armor plating begins to crack and split!"

	L.removed = "%s 已去除！"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "zhTW")
if L then
	L.spear_removed = "你的穿刺之矛被移除了！"

	L.mending_desc = "|cFFFF0000注意: 只有你的'專注'目標的計時條會顯示，因為所有的Zar'thik Battle-Menders有分離的治療冷卻時間。|r "
	L.mending_warning = "你的專注目標正在施放癒合！"
	L.mending_bar = "專注目標: 癒合"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "zhTW")
if L then
	L.explosion_by_other = "突變傀儡/焦點的琥珀爆炸冷卻計時條"
	L.explosion_by_other_desc = "突變傀儡或焦點的琥珀爆炸冷卻警告。"

	L.explosion_casting_by_other = "突變傀儡/焦點施放琥珀爆炸"
	L.explosion_casting_by_other_desc = "突變傀儡或焦點的琥珀爆炸施法警告。高度建議強調！"

	L.explosion_by_you = "你的琥珀爆炸冷卻"
	L.explosion_by_you_desc = "你的琥珀爆炸的冷卻警告。"
	L.explosion_by_you_bar = "你在施法中..."

	L.explosion_casting_by_you = "你的琥珀爆炸施法條"
	L.explosion_casting_by_you_desc = "你施放琥珀爆炸的警告。 高度建議強調！"

	L.willpower = "意志力"
	L.willpower_message = "意志力為 %d!"

	L.break_free_message = "血量為 %d%%!"
	L.fling_message = "快吸水！"
	L.parasite = "寄生"

	L.monstrosity_is_casting = "琥珀巨怪: 爆炸"
	L.you_are_casting = "»你«在施法！"

	L.unsok_short = "首領"
	L.monstrosity_short = "琥珀巨怪"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "zhTW")
if L then
	L.engage_trigger = "殺死所有膽敢挑戰我帝國的人！"

	L.phases = "階段"
	L.phases_desc = "警告階段改變。"

	L.eyes = "女皇之眼"
	L.eyes_desc = "計算女皇之眼的堆疊與顯示持續時間條。"
	L.eyes_message = "女皇之眼"

	L.visions_message = "死亡幻覺"
	L.visions_dispel = "玩家被恐懼！"
	L.fumes_bar = "你的毒氣增益"
end

