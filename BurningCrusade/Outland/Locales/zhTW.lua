local L = BigWigs:NewBossLocale("Doomwalker", "zhTW")
if not L then return end
if L then
	L.name = "厄運行者"

	L.engage_trigger = "別在繼續下去。你將會被消除的。"
	L.engage_message = "與厄運行者進入戰鬥，30 秒後發動地震!"

	L.overrun_desc = "當厄運行者發動 超越 技能時發出警報"

	L.earthquake_desc = "當厄運行者發動地震術時發出警報"
end

L = BigWigs:NewBossLocale("Doom Lord Kazzak", "zhTW")
if L then
	L.name = "毀滅領主卡札克"

	L.engage_trigger1 = "燃燒軍團將征服一切!"
	L.engage_trigger2 = "所有的凡人都將死亡!"

	L.enrage_warning1 = "與 %s 進入戰鬥! 50-60 秒後狂怒!"
	L.enrage_warning2 = "即將狂怒!"
	L.enrage_message = "狂怒狀態 10 秒!"
	L.enrage_finished = "狂怒結束! 50-60 秒後再次狂怒!"
	L.enrage_bar = "狂怒"
	L.enraged_bar = "<已狂怒>"
end

L = BigWigs:NewBossLocale("Gruul the Dragonkiller", "zhTW")
if L then
	L.engage_trigger = "來……受死吧。"
	L.engage_message = "%s 進入戰鬥"

	L.grow = "成長警告"
	L.grow_desc = "計算並當戈魯爾成長時發送警告"
	L.grow_message = "成長: (%d)"
	L.grow_bar = "成長 (%d)"

	L.grasp = "破碎警告"
	L.grasp_desc = "當戈魯爾施放大地猛擊跟破碎時發送警告並顯示計時條"
	L.grasp_message = "大地猛擊 - 10 秒內破碎"
	L.grasp_warning = "大地猛擊即將來臨!"

	L.silence_message = "迴響 - 範圍沉默"
	L.silence_warning = "戈魯爾即將施放迴響"
	L.silence_bar = "迴響"
end

L = BigWigs:NewBossLocale("High King Maulgar", "zhTW")
if L then
	--L.engage_trigger = "Gronn are the real power in Outland!"

	L.heal_message = "先知盲眼施放群體治療 - 請中斷"
	L.heal_bar = "<治療>"

	L.shield_message = "先知盲眼施放強效真言術:盾 - 請快速擊破"

	L.spellshield_message = "火手施放法術護盾 - 法師偷取！"

	L.summon_message = "野生地獄獵犬要出來咬人嚕"
	L.summon_bar = "召喚倒數"

	L.whirlwind_message = "大君王莫卡爾 - 旋風斬 15 秒"
	L.whirlwind_warning = "進入戰鬥 - 60 秒後施放旋風斬"

	L.mage = "克羅斯·火手 (法師)"
	L.warlock = "召喚者歐莫 (術士)"
	L.priest = "先知盲眼 (牧師)"
end

L = BigWigs:NewBossLocale("Magtheridon", "zhTW")
if L then
	L.escape = "釋放"
	L.escape_desc = "倒數計時，直到 瑪瑟里頓 獲得自由"
	L.escape_trigger1 = "束縛開始變弱"
	L.escape_trigger2 = "我……被……釋放了!"
	L.escape_warning1 = "與 %s 進入戰鬥 - 2 分鐘後獲得自由!"
	L.escape_warning2 = "1 分鐘後獲得自由!"
	L.escape_warning3 = "30 秒後獲得自由!"
	L.escape_warning4 = "10 秒後獲得自由!"
	L.escape_warning5 = "3 秒後獲得自由!"
	L.escape_bar = "被釋放"
	L.escape_message = "%s 被釋放了!"

	L.abyssal = "燃燒的冥淵火"
	L.abyssal_desc = "當地獄火導魔師創造燃燒的冥淵火時發出警報"
	L.abyssal_message = "燃燒的冥淵火已創造 (%d)"

	L.heal = "黑暗治療"
	L.heal_desc = "當地獄火導魔師開始治療時發出警報"
	L.heal_message = "黑暗治療 - 快中斷!"

	L.banish = "驅逐"
	L.banish_desc = "當你驅逐 瑪瑟里頓."
	L.banish_message = "驅逐成功 - 衝擊新星巳中斷"
	L.banish_over_message = "驅逐效果消失!"
	L.banish_bar = "<驅逐中>"

	L.exhaust_desc = "玩家中心靈耗損時計時器"
	L.exhaust_bar = "心靈耗損: [%s]"

	L.debris_trigger = "我不會這麼輕易就被擊敗!讓這座監獄的牆壁震顫……然後崩塌!"
	L.debris_message = "30% - 殘骸來臨!"
end

