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
	L.timeLeft = "%.1f秒" -- s = seconds
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
end

L = BigWigs:NewBossLocale("Grand Magistrix Elisande", "zhTW")
if L then
	L.elisande = "艾莉珊德"

	L.ring_msg = "時間的浪潮會粉碎你！"
	L.orb_msg = "你會發現時光有時很不穩定。"

	L.slowTimeZone = "減速區域"
	L.fastTimeZone = "加速區域"

	L.boss_active = "艾莉珊德備戰"
	L.boss_active_desc = "為清光小怪後的劇情事件提供計時，直到艾莉珊德可被攻擊。"
	L.elisande_trigger = "艾莉珊德說：我預見了你的到來。命運的絲線帶你來到這裡。你竭盡全力，想阻止燃燒軍團。"
end

L = BigWigs:NewBossLocale("Gul'dan", "zhTW")
if L then
	--L.warmup_trigger = "Have you forgotten" -- Have you forgotten your humiliation on the Broken Shore? How your precious high king was bent and broken before me? Will you beg for your lives as he did, whimpering like some worthless dog?

	L.empowered = "(強化) %s" -- (E) Eye of Gul'dan
	L.gains = "古爾丹獲得%s"
	L.p4_mythic_start_yell = "把靈魂送回惡魔獵人的體內…別讓燃燒軍團的主宰佔用！"

	L.nightorb_desc = "召喚一個夜之球，擊殺它會生成一個時間停止力場。"
	L.timeStopZone = "時間停止區域"

	L.manifest_desc = "召喚一個埃辛諾斯靈魂碎片，擊殺它會生成一個惡魔精華。"

	L.winds_desc = "古爾丹召喚強風將玩家吹離平台。"
end

L = BigWigs:NewBossLocale("Nighthold Trash", "zhTW")
if L then
	--[[ Skorpyron to Trilliax ]]--
	L.torm = "野蠻的托姆"
	L.fulminant = "爆燃元素"
	L.pulsauron = "時脈之靈"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	L.sludgerax = "淤泥雷克斯"

	--[[ Trilliax to Aluriel ]]--
	L.karzun = "卡祖恩"
	L.guardian = "金輝守護者"
	L.battle_magus = "暮衛魔戰士"
	L.chronowraith = "時光怨靈"
	L.protector = "暮衛保衛者"

	--[[ Aluriel to Etraeus ]]--
	L.jarin = "占星師賈倫"

	--[[ Aluriel to Telarn ]]--
	L.defender = "星界保衛者"
	L.weaver = "暮衛編織者"
	L.archmage = "夏多雷大法師"
	L.manasaber = "被馴養的法力刃豹"
	L.naturalist = "夏多雷自然學家"

	--[[ Aluriel to Krosus ]]--
	L.infernal = "灼熱的煉獄火"

	--[[ Aluriel to Tichondrius ]]--
	L.chaosmage = "魔誓混沌法師"
	L.watcher = "暮衛哨兵"
end
