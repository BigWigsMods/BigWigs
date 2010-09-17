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

	L.shadow_soon = "约5秒后，暗影突击！"

	L.freeze_bar = "<下一寒冰打击>"
	L.pcold_bar = "<下一刺骨之寒>"

	L.chase = "追击"
end

L = BigWigs:NewBossLocale("The Beasts of Northrend", "zhCN")
if L then
	L.enable_trigger = "欢迎，勇士们！你们听到了银色北伐军的号召，并勇敢地作出了响应！"
	L.wipe_trigger = "悲剧……"

	L.engage_trigger = "他来自风暴峭壁最幽深，最黑暗的洞穴，穿刺者戈莫克！准备战斗，英雄们！"
	L.jormungars_trigger = "做好准备，英雄们，两头猛兽已经进入了竞技场！它们是酸喉和恐鳞！"
	L.icehowl_trigger = "当下一名斗士出场时，空气都会为之冻结！它是冰吼，胜或是死，勇士们！"
	L.boss_incoming = "即将%s！"

	-- Gormok
	L.snobold = "狗头人奴隶"
	L.snobold_desc = "当出现狗头人奴隶时发出警报。"
	L.snobold_message = "狗头人奴隶！"
	L.impale_message = "%2$dx 穿刺：>%1$s<！"
	L.firebomb_message = ">你< 燃烧弹！"

	-- Jormungars
	L.submerge = "潜地"
	L.submerge_desc = "当下一次虫子即将潜地时显示计时条。"
	L.spew = "强酸/熔岩喷射"
	L.spew_desc = "当施放强酸/熔岩喷射时发出警报。"
	L.sprays = "喷溅"
	L.sprays_desc = "显示下一次麻痹喷溅和烈焰喷射计时条。"
	L.slime_message = ">你< 粘液池！"
	L.burn_spell = "灼热胆汁"
	L.toxin_spell = "麻痹毒素"
	L.spray = "<下一喷溅>"

	-- Icehowl
	L.butt_bar = "<野蛮头冲 冷却>"
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

	L.adds = "虚空传送门和volcanos"
	L.adds_desc = "当加拉克苏斯大王召唤虚空传送门和volcanos时发出警报和显示计时条。"

	L.incinerate_message = "血肉成灰"
	L.incinerate_other = "血肉成灰：>%s<！"
	L.incinerate_bar = "<下一血肉成灰>"
	L.incinerate_safe = "安全：>%s<！"

	L.legionflame_message = "军团烈焰"
	L.legionflame_other = "军团烈焰：>%s<！"
	L.legionflame_bar = "<下一军团烈焰>"

	L.infernal_bar = "<Volcano出现>"
	L.netherportal_bar = "<下一虚空传送门>"
	L.netherpower_bar = "<下一虚空之能>"

	L.kiss_message = ">你< 仕女之吻！"
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
