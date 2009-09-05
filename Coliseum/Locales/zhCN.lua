local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "zhCN")
if L then
	L.engage_message = "阿努巴拉克已激活，80秒后，钻地！"
--	L.engage_trigger = "This place will serve as your tomb!"

--	L.unburrow_trigger = "emerges from the ground"
--	L.burrow_trigger = "burrows into the ground"
	L.burrow = "钻地"
	L.burrow_desc = "当阿努巴拉克钻地时显示计时条。"
	L.burrow_cooldown = "下一钻地"
	L.burrow_soon = "即将 钻地！"

	L.icon = "团队标记"
	L.icon_desc = "为中了阿努巴拉克钻地追击的队员打上团队标记。（需要权限）"

	L.chase = "追击"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "zhCN")
if L then
	--L.engage_trigger = "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!"
	--L.jormungars_trigger = "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!"
	--L.icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!"
	L.boss_incoming = "即将%s！"

	-- Gormok
	L.snobold = "Snobold"
	L.snobold_desc = "当玩家头上出现Snobold时发出警报。"
	L.snobold_message = "Snobold：>%s<！"
	L.impale_message = "%2$dx Impale：>%1$s<！"
	L.firebomb_message = ">你< Fire Bomb！"

	-- Jormungars
	L.spew = "Acidic/Molten Spew"
	L.spew_desc = "当施放Acidic/Molten Spew时发出警报。"

	L.slime_message = ">你< Slime pool！"
	L.burn_spell = "Burning Bile"
	L.toxin_spell = "Paralytic Toxin"

	-- Icehowl
	L.butt_bar = "<Ferocious Butt 冷却>"
	L.charge = "野性冲锋"
	L.charge_desc = "当玩家中了野性冲锋时发出警报。"

--	L.charge_trigger = "^%%s"	--check
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faction Champions", "zhCN")
if L then
--	L.enable_trigger = "The next battle will be against the Argent Crusade's most powerful knights! Only by defeating them will you be deemed worthy..."
--	L.defeat_trigger = "A shallow and tragic victory. We are weaker as a whole from the losses suffered today. Who but the Lich King could benefit from such foolishness? Great warriors have lost their lives. And for what? The true threat looms ahead - the Lich King awaits us all in death."

	L["Shield on %s!"] = "圣盾术：>%s<！"
	L["Bladestorming!"] = "剑刃风暴！"
	L["Hunter pet up!"] = "召唤宠物！"
	L["Felhunter up!"] = "召唤地狱猎犬！"
	L["Heroism on champions!"] = "英勇！"
	L["Bloodlust on champions!"] = "嗜血！"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "zhCN")
if L then
	L.engage = "激活"
	L.engage_trigger = "You face Jaraxxus, Eredar lord of the Burning Legion!"
	L.engage_trigger1 = "Banished to the Nether"

	L.incinerate_message = "Incinerate"
	L.incinerate_other = "Incinerate Flesh：>%s<！"
	L.incinerate_bar = "<下一Incinerate Flash>"

	L.legionflame_message = "Flame"
	L.legionflame_other = "Legion Flame：>%s<！"
	L.legionflame_bar = "<下一Legion Flame>"

	L.icon = "团队标记"
	L.icon_desc = "为中了Legion Flame的队员打上团队标记。（需要权限）"

	L.netherportal_bar = "<下一Nether Portal>"
	L.netherpower_bar = "<下一Nether Power>"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "zhCN")
if L then
--	L.engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die."

	L.vortex_or_shield_cd = "<下一Vortex/Shield>"

	L.vortex = "Vortex"
	L.vortex_desc = "当双子开始施放Vortexes时发出警报。"

	L.shield = "Shield of Darkness/Light"
	L.shield_desc = "当施放Shield of Darkness/Light时发出警报。"

	L.touch = "Touch of Darkness/Light"
	L.touch_desc = "当玩家中了Touch of Darkness/Light时发出警报。"
end
