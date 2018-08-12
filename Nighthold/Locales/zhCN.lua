local L = BigWigs:NewBossLocale("Skorpyron", "zhCN")
if not L then return end
if L then
	L.blue = "蓝"
	L.red = "红"
	L.green = "绿"
	L.mode = "%s模式"
end

L = BigWigs:NewBossLocale("Chronomatic Anomaly", "zhCN")
if L then
	L.timeLeft = "%.1f秒" -- s = seconds
end

L = BigWigs:NewBossLocale("Trilliax", "zhCN")
if L then
	L.yourLink = ">%s< 与你相连"
	L.yourLinkShort = "相连 %s"
	L.imprint = "印记"
end

L = BigWigs:NewBossLocale("Tichondrius", "zhCN")
if L then
	L.addsKilled = "增援已击杀"
	L.gotEssence = "获得精华"

	L.adds_desc = "增援刷新计时器和警报。"
	L.adds_yell1 = "我的部下们！进来！"
	L.adds_yell2 = "让这些僭越者看看应该怎么战斗！"
end

L = BigWigs:NewBossLocale("Krosus", "zhCN")
if L then
	L.leftBeam = "左侧光束"
	L.rightBeam = "右侧光束"

	L.goRight = "> 往右 >"
	L.goLeft = "< 往左 <"

	L.smashingBridge = "断桥"
	L.smashingBridge_desc = "猛击断桥。可以使用此选项醒目或启用冷却。"

	L.removedFromYou = "%s已从你移除"
end

L = BigWigs:NewBossLocale("Star Augur Etraeus", "zhCN")
if L then
	L.yourSign = "星座"
	L.with = "与"
	L[205429] = "|T1391538:15:15:0:0:64:64:4:60:4:60|t|cFFFFDD00巨蟹|r"
	L[205445] = "|T1391537:15:15:0:0:64:64:4:60:4:60|t|cFFFF0000天狼|r"
	L[216345] = "|T1391536:15:15:0:0:64:64:4:60:4:60|t|cFF00FF00猎户|r"
	L[216344] = "|T1391535:15:15:0:0:64:64:4:60:4:60|t|cFF00DDFF天龙|r"
end

L = BigWigs:NewBossLocale("Grand Magistrix Elisande", "zhCN")
if L then
	L.elisande = "艾利桑德"

	L.ring_yell = "让时间的浪潮碾碎你们！"
	L.orb_yell = "你们会发现，时间极不稳定。"

	L.slowTimeZone = "时间减速区域"
	L.fastTimeZone = "时间加速区域"

	L.boss_active = "艾利桑德激活"
	L.boss_active_desc = "清理小怪事件到艾利桑德激活计时。"
	L.elisande_trigger = "我早就预见了你们的到来。命运指引你们来到此地。为了阻止军团，你们想背水一战。"
end

L = BigWigs:NewBossLocale("Gul'dan", "zhCN")
if L then
	L.warmup_trigger = "你们忘了破碎海滩的耻辱了吗？" -- 你们忘了破碎海滩的耻辱了吗？你们的宝贝国王是怎么在我面前卑躬屈膝，支离破碎的？你们也想像他一样，像条狗一样呜咽求饶吗？

	L.empowered = "（强化）%s"
	L.gains = "古尔丹获得 >%s<"
	L.p4_mythic_start_yell = "该让这个恶魔猎手的灵魂回到躯体中……防止军团之王占据它了！"

	L.nightorb_desc = "召唤暗夜宝珠，击杀后将出现时间停止力场。"
	L.timeStopZone = "时间停止区域"

	L.manifest_desc = "召唤埃辛诺斯灵魂碎片，击杀后将出现恶魔精华。"

	L.winds_desc = "古尔丹召唤暴虐之风将玩家吹离平台。"
end

L = BigWigs:NewBossLocale("Nighthold Trash", "zhCN")
if L then
	--[[ Skorpyron to Trilliax ]]--
	L.torm = "野蛮的托姆"
	L.fulminant = "弗米纳特"
	L.pulsauron = "普尔萨隆"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	L.sludgerax = "斯拉吉拉克斯"

	--[[ Trilliax to Aluriel ]]--
	L.karzun = "卡祖恩"
	L.guardian = "鎏金守卫"
	L.battle_magus = "暮色卫队战斗魔导师"
	L.chronowraith = "时光怨灵"
	L.protector = "暗夜要塞防御者"

	--[[ Aluriel to Etraeus ]]--
	L.jarin = "占星家贾林"

	--[[ Aluriel to Telarn ]]--
	L.defender = "星界防御者"
	L.weaver = "暮色卫队织法者"
	L.archmage = "夏多雷大法师"
	L.manasaber = "驯养的魔刃豹"
	L.naturalist = "夏多雷自然学家"

	--[[ Aluriel to Krosus ]]--
	L.infernal = "灼热的地狱火"

	--[[ Aluriel to Tichondrius ]]--
	L.chaosmage = "魔誓混沌法师"
	L.watcher = "深渊守护者"
end
