local L = BigWigs:NewBossLocale("Anub'arak", "zhCN")
if L then
	L.engage_message = "阿努巴拉克已激活，80秒后，钻地！"
--	L.engage_trigger = "This place will serve as your tomb!"

--	L.unburrow_trigger = "emerges from the ground"
--	L.burrow_trigger = "burrows into the ground"
	L.burrow = "钻地"
	L.burrow_desc = "当阿努巴拉克钻地时显示计时条。"
	L.burrow_cooldown = "下一钻地"
	L.burrow_soon = "即将 钻地！"

	L.nerubian_message = "即将 增援！"
	L.nerubian_burrower = "更多增援！"

	L.shadow_soon = "约5秒后，Shadow Strike！"

	L.freeze_bar = "<下一Freezing Slash>"
	L.pcold_bar = "<下一Penetrating Cold>"

	L.chase = "追击"
end

L = BigWigs:NewBossLocale("The Beasts of Northrend", "zhCN")
if L then
--	L.enable_trigger = "You have heard the call of the Argent Crusade and you have boldly answered"
	L.wipe_trigger = "Tragic..."

--	L.engage_trigger = "Hailing from the deepest, darkest caverns of the Storm Peaks, Gormok the Impaler! Battle on, heroes!"
--	L.jormungars_trigger = "Steel yourselves, heroes, for the twin terrors, Acidmaw and Dreadscale, enter the arena!"
--	L.icehowl_trigger = "The air itself freezes with the introduction of our next combatant, Icehowl! Kill or be killed, champions!"
	L.boss_incoming = "即将%s！"

	-- Gormok
	L.snobold = "Snobold"
	L.snobold_desc = "当出现Snobold时发出警报。"
	L.snobold_message = "Snobold！"
	L.impale_message = "%2$dx Impale：>%1$s<！"
	L.firebomb_message = ">你< Fire Bomb！"

	-- Jormungars
	L.submerge = "Submerge"
	L.submerge_desc = "当下一次虫子即将Submerge时显示计时条。"
	L.spew = "Acidic/Molten Spew"
	L.spew_desc = "当施放Acidic/Molten Spew时发出警报。"
	L.sprays = "喷射"
	L.sprays_desc = "显示下一次Paralytic喷射和Burning喷射计时条。"
	L.slime_message = ">你< Slime pool！"
	L.burn_spell = "Burning Bile"
	L.toxin_spell = "Paralytic Toxin"
	L.spray = "<下一喷射>"

	-- Icehowl
	L.butt_bar = "<Ferocious Butt 冷却>"
	L.charge = "野性冲锋"
	L.charge_desc = "当玩家中了野性冲锋时发出警报。"
--	L.charge_trigger = "^%%s"	--check
	L.charge_say = ">我< 野性冲锋！"

	L.bosses = "首领"
	L.bosses_desc = "当首领即将到来时发出警报。"
end

L = BigWigs:NewBossLocale("Faction Champions", "zhCN")
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

L = BigWigs:NewBossLocale("Lord Jaraxxus", "zhCN")
if L then
--	L.enable_trigger = "Trifling gnome! Your arrogance will be your undoing!"

	L.engage = "激活"
--	L.engage_trigger = "You face Jaraxxus, Eredar lord of the Burning Legion!"
--	L.engage_trigger1 = "Banished to the Nether"

	L.adds = "Portals和volcanos"
	L.adds_desc = "当Jaraxxus召唤portals和volcanos时发出警报和显示计时条。"

	L.incinerate_message = "Incinerate"
	L.incinerate_other = "Incinerate Flesh：>%s<！"
	L.incinerate_bar = "<下一Incinerate Flash>"
	L.incinerate_safe = "安全：>%s<！"

	L.legionflame_message = "Flame"
	L.legionflame_other = "Legion Flame：>%s<！"
	L.legionflame_bar = "<下一Legion Flame>"

	L.infernal_bar = "<Volcano出现>"
	L.netherportal_bar = "<下一Nether Portal>"
	L.netherpower_bar = "<下一Nether Power>"

	L.kiss_message = ">你< Mistress' Kiss！"
	L.kiss_interrupted = "打断！"
end

L = BigWigs:NewBossLocale("The Twin Val'kyr", "zhCN")
if L then
--	L.engage_trigger1 = "In the name of our dark master. For the Lich King. You. Will. Die."

	L.vortex_or_shield_cd = "<下一Vortex/Shield>"
	L.next = "下一Vortex/Shield"
	L.next_desc = "当下一次Vortex或Shield时发出警报。"

	L.vortex = "Vortex"
	L.vortex_desc = "当双子开始施放Vortexes时发出警报。"

	L.shield = "Shield of Darkness/Light"
	L.shield_desc = "当施放Shield of Darkness/Light时发出警报。"
	L.shield_half_message = "Shield： >50%<剩余！"
	L.shield_left_message = "%d%% Shield血量剩余！"

	L.touch = "Touch of Darkness/Light"
	L.touch_desc = "当玩家中了Touch of Darkness/Light时发出警报。"
end
