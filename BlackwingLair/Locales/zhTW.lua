local L = BigWigs:NewBossLocale("Razorgore the Untamed", "zhTW")
if not L then return end
if L then
	L.bossName = "狂野的拉佐格爾"
	L.start_trigger = "入侵者"
	L.start_message = "狂野的拉佐格爾進入戰鬥！45秒後小怪出現！"
	L.start_soon = "5 秒後小兵出現！"
	L.start_mob = "小兵出現"

	L.eggs = "龍蛋計數"
	L.eggs_desc = "已摧毀龍蛋計數。"
	L.eggs_message = "已摧毀 %d/30 個龍蛋！"

	L.phase2_message = "已摧毀所有龍蛋"
end

L = BigWigs:NewBossLocale("Vaelastrasz the Corrupt", "zhTW")
if L then
	L.bossName = "墮落的瓦拉斯塔茲"
end

L = BigWigs:NewBossLocale("Broodlord Lashlayer", "zhTW")
if L then
	L.bossName = "勒西雷爾"
end

L = BigWigs:NewBossLocale("Firemaw", "zhTW")
if L then
	L.bossName = "費爾默"
end

L = BigWigs:NewBossLocale("Ebonroc", "zhTW")
if L then
	L.bossName = "埃博諾克"
end

L = BigWigs:NewBossLocale("Flamegor", "zhTW")
if L then
	L.bossName = "弗莱格尔"
end

L = BigWigs:NewBossLocale("Chromaggus", "zhTW")
if L then
	L.bossName = "克洛瑪古斯"
	L.breath = "吐息警報"
	L.breath_desc = "當克洛瑪古斯吐息時發出警報"

	L.debuffs = "{23174} （{605}）" -- 炫彩變形 （支配心智）
	L.debuffs_message = "3/5 減益，注意！"
	L.debuffs_warning = "4/5 減益， 5層後將%s！"
end

L = BigWigs:NewBossLocale("NefarianBWL", "zhTW")
if L then
	L.bossName = "奈法利安"
	L.landing_soon_trigger = "幹得好，手下們。凡人的勇氣開始消退了！現在，我們就來看看他們怎麼面對黑石之王的力量吧！"
	L.landing_trigger = "燃燒吧！一群廢物！燒吧！"
	L.zerg_trigger = "^不可能！來吧，我的僕人！再次為你們的主人服務！"

	L.triggershamans = "^薩滿，讓我看看你圖騰到底是什麼用處的！"
	L.triggerwarlock = "^術士，不要隨便去玩那些你不理解的法術。看看會發生什麼吧？"
	L.triggerhunter = "^獵人和你那討厭的豌豆射擊！"
	L.triggermage = "^還有法師？你應該小心使用你的魔法……"

	L.landing_soon_warning = "10秒後降落！"
	L.landing_warning = "奈法利安已降落！"
	L.zerg_warning = "龍獸出現！"
	L.classcall_warning = "5 秒後開始點名！"

	L.warnshaman = "薩滿 - 圖騰湧現"
	L.warndruid = "德魯伊 - 強制貓形態，無法治療和解詛咒"
	L.warnwarlock = "術士 - 地獄火出現，DPS職業盡快將其消滅"
	L.warnpriest = "牧師 - 停止治療，靜等 25 秒"
	L.warnhunter = "獵人 - 遠程武器損壞"
	L.warnwarrior = "戰士 - 強制狂暴姿態，加大對MT的治療量"
	L.warnrogue = "盜賊 - 被傳送和麻痺"
	L.warnpaladin = "聖騎士 - BOSS受到保護祝福，物理攻擊無效"
	L.warnmage = "法師 - 變形術發動，注意解除"

	L.classcall_bar = "職業點名"

	L.classcall = "職業點名警報"
	L.classcall_desc = "當奈法利安進行職業點名時發出警報"

	L.otherwarn = "其他警報"
	L.otherwarn_desc = "降落及龍獸出現時發出警報"

	-- L.add = "Phase 1 Drakonids"
	-- L.add_desc = "Counts the number of adds killed in Phase 1 before Nefarian lands."
end

