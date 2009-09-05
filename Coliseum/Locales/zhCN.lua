if true then return end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
	engage_message = "阿努巴拉克已激活，80秒后，钻地！",
--	engage_trigger = "This place will serve as your tomb!",

--	unburrow_trigger = "emerges from the ground",
--	burrow_trigger = "burrows into the ground",
	burrow = "钻地",
	burrow_desc = "当阿努巴拉克钻地时显示计时条。",
	burrow_cooldown = "下一钻地",
	burrow_soon = "即将 钻地！",

	icon = "团队标记",
	icon_desc = "为中了阿努巴拉克钻地追击的队员打上团队标记。（需要权限）",

	chase = "追击",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
	--engage_trigger = "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!",
	--jormungars_trigger = "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!",
	--icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!",
	boss_incoming = "即将%s！",

	-- Gormok
	snobold = "Snobold",
	snobold_desc = "当玩家头上出现Snobold时发出警报。",
	snobold_message = "Snobold：>%s<！",
	impale_message = "%2$dx Impale：>%1$s<！",
	firebomb_message = ">你< Fire Bomb！",

	-- Jormungars
	spew = "Acidic/Molten Spew",
	spew_desc = "当施放Acidic/Molten Spew时发出警报。",

	slime_message = ">你< Slime pool！",
	burn_spell = "Burning Bile",
	toxin_spell = "Paralytic Toxin",

	-- Icehowl
	butt_bar = "<Ferocious Butt 冷却>",
	charge = "野性冲锋",
	charge_desc = "当玩家中了野性冲锋时发出警报。",

--	charge_trigger = "^%%s",	--check
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faction Champions", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
--	enable_trigger = "The next battle will be against the Argent Crusade's most powerful knights! Only by defeating them will you be deemed worthy...",
--	defeat_trigger = "A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death.",

	["Shield on %s!"] = "圣盾术：>%s<！",
	["Bladestorming!"] = "剑刃风暴！",
	["Hunter pet up!"] = "召唤宠物！",
	["Felhunter up!"] = "召唤地狱猎犬！",
	["Heroism on champions!"] = "英勇！",
	["Bloodlust on champions!"] = "嗜血！",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
	engage = "激活",
	engage_trigger = "You face Jaraxxus, Eredar lord of the Burning Legion!",
	engage_trigger1 = "Banished to the Nether",

	incinerate_message = "Incinerate",
	incinerate_other = "Incinerate Flesh：>%s<！",
	incinerate_bar = "<下一Incinerate Flash>",

	legionflame_message = "Flame",
	legionflame_other = "Legion Flame：>%s<！",
	legionflame_bar = "<下一Legion Flame>",

	icon = "团队标记",
	icon_desc = "为中了Legion Flame的队员打上团队标记。（需要权限）",

	netherportal_bar = "<下一Nether Portal>",
	netherpower_bar = "<下一Nether Power>",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
--	engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die.",

	vortex_or_shield_cd = "<下一Vortex/Shield>",

	vortex = "Vortex",
	vortex_desc = "当双子开始施放Vortexes时发出警报。",

	shield = "Shield of Darkness/Light",
	shield_desc = "当施放Shield of Darkness/Light时发出警报。",

	touch = "Touch of Darkness/Light",
	touch_desc = "当玩家中了Touch of Darkness/Light时发出警报。",
} end)
