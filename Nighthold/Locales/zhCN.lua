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
	L.totalAbsorb = "全部吸收"
end

L = BigWigs:NewBossLocale("Trilliax", "zhCN")
if L then
	L.yourLink = ">%s< 与你相连"
	L.yourLinkShort = "相连 %s"
	L.imprint = "烙印"
end

L = BigWigs:NewBossLocale("Tichondrius", "zhCN")
if L then
	L.addsKilled = "增援已击杀"
	L.gotEssence = "获得精华"

	L.adds_desc = "增援刷新计时器和警报。"
	--L.adds_trigger1 = "Underlings! Get in here!"
	--L.adds_trigger2 = "Show these pretenders how to fight!"
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
	L.yourSign = "标记"
	L.with = "与"
	L[205429] = "|T1391538:15:15:0:0:64:64:4:60:4:60|t|cFFFFDD00螃蟹|r"
	L[205445] = "|T1391537:15:15:0:0:64:64:4:60:4:60|t|cFFFF0000狼|r"
	L[216345] = "|T1391536:15:15:0:0:64:64:4:60:4:60|t|cFF00FF00猎人|r"
	L[216344] = "|T1391535:15:15:0:0:64:64:4:60:4:60|t|cFF00DDFF龙|r"

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

	--L.ring_msg = "Let the waves of time crash over you!"
	--L.orb_msg = "You'll find time can be quite volatile."

	L.fastTimeZone = "时间加速区域"
end

L = BigWigs:NewBossLocale("Gul'dan", "zhCN")
if L then
	L[211152] = "（强化）%s"
	L.gains = "古尔丹获得 >%s<"
	--L.p4_mythic_start_yell = "Time to return the demon hunter's soul to his body... and deny the Legion's master a host!"

	--L.nightorb_desc = "Summons a Nightorb, killing it will spawn a Time Zone"

	--L.manifest_desc = "Summons a Soul Fragment of Azzinoth, killing it will spawn a Demonic Essence"
end

L = BigWigs:NewBossLocale("Nighthold Trash", "zhCN")
if L then
	--[[ Skorpyron to Trilliax ]]--
	--L.torm = "Torm the Brute"
	--L.fulminant = "Fulminant"
	--L.pulsauron = "Pulsauron"

	--[[ Chronomatic Anomaly to Trilliax ]]--
	--L.sludgerax = "Sludgerax"

	--[[ Trilliax to Aluriel ]]--
	--L.karzun = "Kar'zun"
	--L.guardian = "Gilded Guardian"
	--L.battle_magus = "Duskwatch Battle-Magus"
	--L.chronowraith = "Chronowraith"
	--L.protector = "Nighthold Protector"

	--[[ Aluriel to Etraeus ]]--
	--L.jarin = "Astrologer Jarin"

	--[[ Aluriel to Telarn ]]--
	--L.weaver = "Duskwatch Weaver"
	--L.archmage = "Shal'dorei Archmage"
	--L.manasaber = "Domesticated Manasaber"

	--[[ Aluriel to Krosos ]]--
	--L.infernal = "Searing Infernal"

	--[[ Aluriel to Tichondrius ]]--
	--L.watcher = "Abyss Watcher"
end

