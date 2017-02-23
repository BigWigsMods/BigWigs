local L = BigWigs:NewBossLocale("Skorpyron", "zhTW")
if not L then return end
if L then
	L.blue = "藍色"
	L.red = "紅色"
	L.green = "綠色"
	L.mode = "%s模式"
end

L = BigWigs:NewBossLocale("Chronomatic Anomaly", "zhTW")
if L then
	L.affected = "被影響"
	L.totalAbsorb = "總吸收"
end

L = BigWigs:NewBossLocale("Trilliax", "zhTW")
if L then
	L.yourLink = "你和%s相連"
	L.yourLinkShort = "和%s相連"
	L.imprint = "印記"
end

L = BigWigs:NewBossLocale("Tichondrius", "zhTW")
if L then
	L.addsKilled = "援軍擊殺"
	L.gotEssence = "獲得精華"

	L.adds_desc = "援軍刷新計時器和警報。"
	L.adds_yell1 = "手下們！都進來！"
	L.adds_yell2 = "讓這些笨蛋見識真正的戰鬥！"
end

L = BigWigs:NewBossLocale("Krosus", "zhTW")
if L then
	L.leftBeam = "左手光束"
	L.rightBeam = "右手光束"

	L.goRight = "> 往右 >"
	L.goLeft = "< 往左 <"

	L.smashingBridge = "斷橋"
	L.smashingBridge_desc = "斷橋計時器。啟用此選項可強調或倒數。"

	L.removedFromYou = "%s結束了"
end

L = BigWigs:NewBossLocale("Star Augur Etraeus", "zhTW")
if L then
	L.yourSign = "你的星座"
	L.with = "和"
	L[205429] = "|T1391538:15:15:0:0:64:64:4:60:4:60|t|cFFFFDD00巨蟹|r"
	L[205445] = "|T1391537:15:15:0:0:64:64:4:60:4:60|t|cFFFF0000貪狼|r"
	L[216345] = "|T1391536:15:15:0:0:64:64:4:60:4:60|t|cFF00FF00獵戶|r"
	L[216344] = "|T1391535:15:15:0:0:64:64:4:60:4:60|t|cFF00DDFF飛龍|r"

	L.nameplate_requirement = "這個功能目前只有KuiNameplates支援。傳奇難度限定。"

	L.custom_off_icy_ejection_nameplates = "在友方姓名板顯示 {206936} " -- Icy Ejection
	L.custom_off_icy_ejection_nameplates_desc = L.nameplate_requirement

	L.custom_on_fel_ejection_nameplates = "在友方姓名板顯示 {205649} " -- Fel Ejection
	L.custom_on_fel_ejection_nameplates_desc = L.nameplate_requirement

	L.custom_on_gravitational_pull_nameplates = "在友方姓名板顯示 {214335} " -- Gravitational Pull
	L.custom_on_gravitational_pull_nameplates_desc = L.nameplate_requirement

	L.custom_on_grand_conjunction_nameplates = "在友方姓名板顯示 {205408} " -- Grand Conjunction
	L.custom_on_grand_conjunction_nameplates_desc = L.nameplate_requirement
end

L = BigWigs:NewBossLocale("Grand Magistrix Elisande", "zhTW")
if L then
	L.elisande = "艾莉珊德"

	L.ring_msg = "時間的浪潮會粉碎你！"
	L.orb_msg = "你會發現時光有時很不穩定。"

	L.fastTimeZone = "加速區域"

	--L.boss_active = "Elisande Active"
	--L.boss_active_desc = "Time until Elisande is active after clearing the trash event."
	--L.elisande_trigger = "I foresaw your coming, of course. The threads of fate that led you to this place. Your desperate attempt to stop the Legion."
end

L = BigWigs:NewBossLocale("Gul'dan", "zhTW")
if L then
	L.empowered = "(強化) %s" -- (E) Eye of Gul'dan
	L.gains = "古爾丹獲得%s"
	--L.p4_mythic_start_yell = "Time to return the demon hunter's soul to his body... and deny the Legion's master a host!"

	L.nightorb_desc = "召喚一個夜之球，擊殺它會生成一個時間區域。"

	L.manifest_desc = "召喚一個埃辛諾斯靈魂碎片，擊殺它會生成一個惡魔精華。"

	--L.winds_desc = "Gul'dan summons Violent Winds to push the players off the platform."
end

L = BigWigs:NewBossLocale("Nighthold Trash", "zhTW")
if L then
	--[[ Skorpyron to Trilliax ]]--
	--L.torm = "Torm the Brute"
	--L.fulminant = "Fulminant"
	--L.pulsauron = "Pulsauron"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	L.sludgerax = "淤泥雷克斯"

	--[[ Trilliax to Aluriel ]]--
	--L.karzun = "Kar'zun"
	L.guardian = "金輝守護者"
	--L.battle_magus = "Duskwatch Battle-Magus"
	L.chronowraith = "時光怨靈"
	--L.protector = "Nighthold Protector"

	--[[ Aluriel to Etraeus ]]--
	L.jarin = "占星師賈倫"

	--[[ Aluriel to Telarn ]]--
	--L.weaver = "Duskwatch Weaver"
	L.archmage = "夏多雷大法師"
	L.manasaber = "被馴養的法力刃豹"

	--[[ Aluriel to Krosos ]]--
	--L.infernal = "Searing Infernal"

	--[[ Aluriel to Tichondrius ]]--
	--L.watcher = "Abyss Watcher"
end

