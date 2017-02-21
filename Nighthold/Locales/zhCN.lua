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
	L.affected = "已影响"
	L.totalAbsorb = "总共吸收"
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

	L.nameplate_requirement = "此功能当前只支持 KuiNameplates。只限史诗难度。"

	L.custom_off_icy_ejection_nameplates = "显示 {206936} 到友方姓名板。" -- Icy Ejection
	L.custom_off_icy_ejection_nameplates_desc = L.nameplate_requirement

	L.custom_on_fel_ejection_nameplates = "显示 {205649} 到友方姓名板。" -- Fel Ejection
	L.custom_on_fel_ejection_nameplates_desc = L.nameplate_requirement

	L.custom_on_gravitational_pull_nameplates = "显示 {214335} 到友方姓名板。" -- Gravitational Pull
	L.custom_on_gravitational_pull_nameplates_desc = L.nameplate_requirement

	L.custom_on_grand_conjunction_nameplates = "显示 {205408} 到友方姓名板。" -- Grand Conjunction
	L.custom_on_grand_conjunction_nameplates_desc = L.nameplate_requirement

	L.custom_off_gc_replacement_icons = "{205408} 使用更明亮些的图标"
	L.custom_off_gc_replacement_icons_desc = "替换姓名板上强力联结图标获得更加的视觉效果："

	L.custom_off_gc_redgreen_icons = "{205408} 只使用红色和绿色"
	L.custom_off_gc_redgreen_icons_desc = "更改姓名板匹配星座标记图标为 |T876914:15:15:0:0:64:64:4:60:4:60|t 不匹配星座标记为 |T876915:15:15:0:0:64:64:4:60:4:60|t。"
end

L = BigWigs:NewBossLocale("Grand Magistrix Elisande", "zhCN")
if L then
	L.elisande = "艾利桑德"

	L.ring_yell = "让时间的浪潮碾碎你们！"
	L.orb_yell = "你们会发现，时间极不稳定。"

	L.fastTimeZone = "时间加速区域"

	--L.boss_active = "Elisande Active"
	--L.boss_active_desc = "Time until Elisande is active after clearing the trash event."
	--L.elisande_trigger = "I foresaw your coming, of course. The threads of fate that led you to this place. Your desperate attempt to stop the Legion."
end

L = BigWigs:NewBossLocale("Gul'dan", "zhCN")
if L then
	L.empowered = "（强化）%s"
	L.gains = "古尔丹获得 >%s<"
	L.p4_mythic_start_yell = "该让这个恶魔猎手的灵魂回到躯体中……防止军团之王占据它了！"

	L.nightorb_desc = "召唤暗夜宝珠，击杀后将出现时间停止力场。"

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
	L.weaver = "暮色卫队织法者"
	L.archmage = "夏多雷大法师"
	L.manasaber = "驯养的魔刃豹"

	--[[ Aluriel to Krosos ]]--
	L.infernal = "灼热的地狱火"

	--[[ Aluriel to Tichondrius ]]--
	L.watcher = "深渊守护者"
end

