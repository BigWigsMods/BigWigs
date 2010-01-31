local L = BigWigs:NewBossLocale("Anub'arak", "zhTW")
if L then
	L.engage_message = "阿努巴拉克進入戰鬥，80秒後，鑽地！"
	L.engage_trigger = "這裡將會是你們的墳墓!"

	L.unburrow_trigger = "從地底鑽出"
	L.burrow_trigger = "鑽進地裡"
	L.burrow = "鑽地"
	L.burrow_desc = "當阿努巴拉克鑽地時顯示計時條。"
	L.burrow_cooldown = "下一鑽地"
	L.burrow_soon = "即將 鑽地！"

	L.nerubian_message = "即將 增援！"
	L.nerubian_burrower = "更多增援！"

	L.shadow_soon = "約5秒後，暗影打擊！"

	L.freeze_bar = "<下一冰凍斬>"
	L.pcold_bar = "<下一透骨之寒>"

	L.chase = "追擊"
end

L = BigWigs:NewBossLocale("The Beasts of Northrend", "zhTW")
if L then
	L.enable_trigger = "歡迎，勇士們!你們聽從銀白十字軍的號召前來，英勇的挺身而出。"
	L.wipe_trigger = "真可惜…"

	L.engage_trigger = "來自風暴群山最深邃，最黑暗的洞穴。歡迎『穿刺者』戈莫克!戰鬥吧，英雄們!"
	L.jormungars_trigger = "準備面對酸喉和懼鱗的雙重夢魘吧，英雄們，快就定位!"
	L.icehowl_trigger = "下一場參賽者的出場連空氣都會為之凝結:冰嚎!戰個你死我活吧，勇士們!"
	L.boss_incoming = "即將%s！"

	-- Gormok
	L.snobold = "極地狗頭人奴僕"
	L.snobold_desc = "當出現極地狗頭人奴僕時發出警報。"
	L.snobold_message = "極地狗頭人奴僕！"
	L.impale_message = "%2$dx 刺穿：>%1$s<！"
	L.firebomb_message = ">你< 燃燒彈！"

	-- Jormungars
	L.submerge = "隱沒"
	L.submerge_desc = "當下一次蟲子即將隱沒時顯示計時條。"
	L.spew = "酸液/熔火噴灑"
	L.spew_desc = "當施放酸液/熔火噴灑時發出警報。"
	L.sprays = "噴霧"
	L.sprays_desc = "顯示下一次痲痺噴霧和燃燒噴霧計時條。"
	L.slime_message = ">你< 泥漿池！"
	L.burn_spell = "燃燒膽汁"
	L.toxin_spell = "痲痺劇毒"
	L.spray = "<下一噴霧>"

	-- Icehowl
	L.butt_bar = "<兇猛頭擊 冷卻>"
	L.charge = "狂烈衝鋒"
	L.charge_desc = "當玩家中了狂烈衝鋒時發出警報。"
--	L.charge_trigger = "^%%s"	--check
	L.charge_say = ">我< 狂烈衝鋒！"

	L.bosses = "首領"
	L.bosses_desc = "當首領即將到來時發出警報。"
end

L = BigWigs:NewBossLocale("Faction Champions", "zhTW")
if L then
	L.enable_trigger = "接著進入競技場的是，不論在戰場或聯賽場地都身經百戰的聖騎士，身為銀白十字軍的大勇士"
	L.defeat_trigger = "膚淺而悲痛的勝利。今天痛失的生命反而令我們更加的頹弱。除了巫妖王之外，誰還能從中獲利?偉大的戰士失去了寶貴生命。為了什麼?真正的威脅就在前方 - 巫妖王在死亡的領域中等著我們。"

	L["Shield on %s!"] = "聖盾術：>%s<！"
	L["Bladestorming!"] = "劍刃風暴！"
	L["Hunter pet up!"] = "呼喚寵物！"
	L["Felhunter up!"] = "召喚惡魔獵犬！"
	L["Heroism on champions!"] = "英勇氣概！"
	L["Bloodlust on champions!"] = "嗜血術！"
end

L = BigWigs:NewBossLocale("Lord Jaraxxus", "zhTW")
if L then
	L.enable_trigger = "卑微的地精!你的傲慢將使你喪命!"

	L.engage = "進入戰鬥"
	L.engage_trigger = "你面對的是賈拉克瑟斯，燃燒軍團的埃雷達爾領主!"
	L.engage_trigger1 = "放逐到虛空吧!"

	L.adds = "虛空傳送門和煉獄火山"
	L.adds_desc = "當賈拉克瑟斯領主召喚虛空傳送門和煉獄火山時發出警報和顯示計時條。"

	L.incinerate_message = "焚化血肉"
	L.incinerate_other = "焚化血肉：>%s<！"
	L.incinerate_bar = "<下一焚化血肉>"
	L.incinerate_safe = "安全：>%s<！"

	L.legionflame_message = "軍團烈焰"
	L.legionflame_other = "軍團烈焰：>%s<！"
	L.legionflame_bar = "<下一軍團烈焰>"

	L.infernal_bar = "<煉獄火山出現>"
	L.netherportal_bar = "<下一虛空傳送門>"
	L.netherpower_bar = "<下一虛空傳送門（能量）>"

	L.kiss_message = ">你< 仕女之吻！"
	L.kiss_interrupted = "中斷！"
end

L = BigWigs:NewBossLocale("The Twin Val'kyr", "zhTW")
if L then
	L.engage_trigger1 = "以我們的黑暗君王之名。為了巫妖王。你‧得‧死。"

	L.vortex_or_shield_cd = "<下一漩渦/盾>"
	L.next = "下一漩渦/盾"
	L.next_desc = "當下一次漩渦或盾時發出警報。"

	L.vortex = "漩渦"
	L.vortex_desc = "當華爾琪雙子開始施放漩渦時發出警報。"

	L.shield = "黑暗/光明之盾"
	L.shield_desc = "當施放黑暗/光明之盾時發出警報。"
	L.shield_half_message = "盾血量：>50%<剩餘！"
	L.shield_left_message = "%d%% 盾血量剩餘！"

	L.touch = "黑暗/光明之觸"
	L.touch_desc = "當玩家中了黑暗/光明之觸時發出警報。"
end
