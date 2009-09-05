if true then return end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	engage_message = "阿努巴拉克進入戰斗，80秒後，鑽地！",
	engage_trigger = "這裡將會是你們的墳墓!",

--	unburrow_trigger = "emerges from the ground",
--	burrow_trigger = "burrows into the ground",
	burrow = "鑽地",
	burrow_desc = "當阿努巴拉克鑽地時顯示計時條。",
	burrow_cooldown = "下一鑽地",
	burrow_soon = "即將 鑽地！",

	icon = "團隊標記",
	icon_desc = "為中了阿努巴拉克鑽地追擊的隊員打上團隊標記。（需要權限）",

	chase = "追擊",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "來自風暴群山最深邃，最黑暗的洞穴。歡迎『穿刺者』戈莫克!戰鬥吧，英雄們!",
	jormungars_trigger = "準備面對酸喉和懼鱗的雙重夢魘吧，英雄們，快就定位!",
	icehowl_trigger = "下一場參賽者的出場連空氣都會為之凝結:冰嚎!戰個你死我活吧，勇士們! ",
	boss_incoming = "即將%s！",

	-- Gormok
	snobold = "極地狗頭人奴僕",
	snobold_desc = "當玩家頭上出現極地狗頭人奴僕時發出警報。",
	snobold_message = "極地狗頭人奴僕：>%s<！",
	impale_message = "%2$dx 刺穿：>%1$s<！",
	firebomb_message = ">你< 燃燒彈！",

	-- Jormungars
	spew = "酸液/熔火噴灑",
	spew_desc = "當施放酸液/熔火噴灑時發出警報。",

	slime_message = ">你< 泥漿池！",
	burn_spell = "燃燒膽汁",
	toxin_spell = "痲痺劇毒",

	-- Icehowl
	butt_bar = "<兇猛頭擊 冷卻>",
	charge = "狂烈衝鋒",
	charge_desc = "當玩家中了狂烈衝鋒時發出警報。",

--	charge_trigger = "^%%s",	--check
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faction Champions", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	enable_trigger = "The next battle will be against the Argent Crusade's most powerful knights! Only by defeating them will you be deemed worthy...",
	defeat_trigger = "膚淺而悲痛的勝利。今天痛失的生命反而令我們更加的頹弱。除了巫妖王之外，誰還能從中獲利?偉大的戰士失去了寶貴生命。為了什麼?真正的威脅就在前方 - 巫妖王在死亡的領域中等著我們。",

	["Shield on %s!"] = "聖盾術：>%s<！",
	["Bladestorming!"] = "劍刃風暴！",
	["Hunter pet up!"] = "呼喚寵物！",
	["Felhunter up!"] = "召喚惡魔獵犬！",
	["Heroism on champions!"] = "英勇氣概！",
	["Bloodlust on champions!"] = "嗜血術！",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	engage = "進入戰斗",
	engage_trigger = "You face Jaraxxus, Eredar lord of the Burning Legion!",
	engage_trigger1 = "Banished to the Nether",

	incinerate_message = "焚化血肉",
	incinerate_other = "焚化血肉：>%s<！",
	incinerate_bar = "<下一焚化血肉>",

	legionflame_message = "聚合烈焰",
	legionflame_other = "聚合烈焰：>%s<！",
	legionflame_bar = "<下一聚合烈焰>",

	icon = "團隊標記",
	icon_desc = "為中了聚合烈焰的隊員打上團隊標記。（需要權限）",

	netherportal_bar = "<下一虛空傳送門>",
	netherpower_bar = "<下一虛空傳送門（能量）>",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "enUS", true)
L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "以我們的黑暗君王之名。為了巫妖王。你‧得‧死。",

	vortex_or_shield_cd = "<下一漩渦/盾>",

	vortex = "漩渦",
	vortex_desc = "當華爾琪雙子開始施放漩渦時發出警報。",

	shield = "黑暗/光明之盾",
	shield_desc = "當施放黑暗/光明之盾時發出警報。",

	touch = "黑暗/光明之觸",
	touch_desc = "當玩家中了黑暗/光明之觸時發出警報。",
} end)
