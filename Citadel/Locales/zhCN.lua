local L = BigWigs:NewBossLocale("Blood Prince Council", "zhCN")
if L then
	L.switch_message = "虛弱轉換: %s"
	L.switch_bar = "<下一虛弱轉換>"

	L.empowered_flames = "地獄火"

	L.empowered_shock_message = "正在施放 強力震擊漩渦！"
	L.regular_shock_message = "震擊漩渦區域！"
	L.shock_say = ">我< 震擊漩渦！"

	L.skullprince = "Skull on active prince"
	L.skullprince_desc = "Place a skull on the active blood prince with health."
end

L = BigWigs:NewBossLocale("Festergut", "zhCN")
if L then
	L.engage_trigger = "Fun time?"

	L.inhale_message = "Inhale Blight：>%d<！"
	L.inhale_bar = "<下一Inhale Blight：%d>"

	L.blight_warning = "约5秒后，Pungent Blight！"
	L.blight_bar = "<下一Pungent Blight>"

	L.bloat_message = "Gastric Bloat%2$dx：>%1$s<！"
	L.bloat_bar = "<下一Gastric Bloat>"

	L.spore_bar = "<下一Gas Spore>"

	L.sporeicon = "Icon on Spore targets"
	L.sporeicon_desc = "Set a Skull, Cross & Square on the players with a spore (requires promoted or leader)."
end

L = BigWigs:NewBossLocale("Icecrown Gunship Battle", "zhCN")
if L then
	L.adds = "传送门"
	L.adds_desc = "传送门警报。"
	L.adds_trigger_alliance = "Reavers, Sergeants, attack!"
	L.adds_trigger_horde = "Marines, Sergeants, attack!"
	L.adds_message = "传送门！"
	L.adds_bar = "<下一传送门>"

	L.mage = "法师"
	L.mage_desc = "当法师出现冰冻炮舰火炮时发出警报。"
	L.mage_message = "法师 出现！"
	L.mage_bar = "<下一法师>"

	L.enable_trigger_alliance = "Fire up the engines! We got a meetin' with destiny, lads!"
	L.enable_trigger_horde = "Rise up, sons and daughters of the Horde! Today we battle a hated enemy! LOK'TAR OGAR!"

	L.disable_trigger_alliance = "Don't say I didn't warn ya, scoundrels! Onward, brothers and sisters!"
	L.disable_trigger_horde = "The Alliance falter. Onward to the Lich King!"
end

L = BigWigs:NewBossLocale("Lady Deathwhisper", "zhCN")
if L then
	L.engage_trigger = "What is this disturbance?"
	L.phase2_message = "第二阶段 - Mana barrier gone！"

	L.dnd_message = ">你< 死亡凋零！"

	L.adds = "增援"
	L.adds_desc = "当召唤增援时显示计时条。"
	L.adds_bar = "<下一增援>"
	L.adds_warning = "5秒后，新的增援！"

	L.touch_message = "Touch of Insignificance%2$dx：>%1$s<！"
	L.touch_bar = "<下一Touch of Insignificance>"

	L.deformed_fanatic = "Deformed Fanatic!"
end

L = BigWigs:NewBossLocale("Lord Marrowgar", "zhCN")
if L then
	L.impale_cd = "<下一穿刺>"

	L.bonestorm_cd = "<下一Bone Storm>"
	L.bonestorm_warning = "5秒后，Bone Storm！"

	L.coldflame_message = ">你< Coldflame！"

	L.engage_trigger = "The Scourge will wash over this world as a swarm of death and destruction!"
end

L = BigWigs:NewBossLocale("Putricide Dogs", "zhCN")
if L then
	L.wound_message = " Mortal Wound%2$dx：>%1$s<！"
end

L = BigWigs:NewBossLocale("Professor Putricide", "zhCN")
if L then
	L.phase = "階段"
	L.phase_desc = "當進入不同階段發出警報。"
	L.phase_warning = "即將 第%d階段！"

	L.engage_trigger = "大夥聽著，好消息!"

	L.ball_bar = "<下一延展黏液>"
	L.ball_say = "即將 延展黏液！"

	L.experiment_message = "即將 增援！"
	L.experiment_bar = "<下一增援>"
	L.blight_message = "毒氣膨脹"
	L.violation_message = "暴躁軟泥怪"

	L.plague_message = "%2$dx突變瘟疫：>%1$s<！"
	L.plague_bar = "<下一突變瘟疫>"

	L.gasbomb_bar = "<多個窒息毒氣彈>"
	L.gasbomb_message = "窒息毒氣彈！"
end

L = BigWigs:NewBossLocale("Rotface", "zhCN")
if L then
	L.engage_trigger = "不不不不不!"

	L.infection_bar = "<突變感染：%s>"
	L.infection_message = "突變感染"

	L.ooze = "軟泥融合"
	L.ooze_desc = "當軟泥融合時發出警報！"
	L.ooze_message = "不穩定的軟泥：>%dx<！"

	L.spray_bar = "<下一泥漿噴霧>"
end

L = BigWigs:NewBossLocale("Deathbringer Saurfang", "zhCN")
if L then
	L.adds = "Blood Beasts"
	L.adds_desc = "当召唤Blood Beasts时发出警报和显示计时条。"
	L.adds_warning = "5秒后，Blood Beasts！"
	L.adds_message = "Blood Beasts！"
	L.adds_bar = "<下一Blood Beasts>"

	L.rune_bar = "<下一Rune of Blood>"

	L.mark = "Mark of the Fallen Champion：>%d<！"

	L.engage_trigger = "BY THE MIGHT OF THE LICH KING!"
	L.warmup_alliance = "Let's get a move on then! Move ou..."
	L.warmup_horde = "Kor'kron, move out! Champions, watch your backs. The Scourge have been..."
end

L = BigWigs:NewBossLocale("Sindragosa", "zhCN")
if L then
	L.engage_trigger = "You are fools to have come to this place."

	L.phase2 = "第二阶段"
	L.phase2_desc = "Warn when Sindragosa goes into phase 2, at 35%."
	L.phase2_trigger = "Now, feel my master's limitless power and despair!"
	L.phase2_message = "第二阶段！"

	L.airphase = "空中阶段"
	L.airphase_desc = "当辛达苟萨起飞时发出警报。"
	L.airphase_trigger = "Your incursion ends here! None shall survive!"
	L.airphase_message = "空中阶段！"
	L.airphase_bar = "下一 空中阶段"

	L.boom_message = "Explosion!"
	L.boom_bar = "Explosion"

	L.unchained_message = "Unchained magic on YOU!"
	L.instability_message = "Unstable x%d!"
	L.chilled_message = "Chilled x%d!"
	L.buffet_message = "Magic x%d!"
end

L = BigWigs:NewBossLocale("Valithria Dreamwalker", "zhCN")
if L then
	L.manavoid_message = ">你< Mana Void！"
	L.portal = "Nightmare Portal"
	L.portal_desc = "当Valithria打开Portal时发出警报。"
	L.portal_message = "打开Portal！"
	L.portal_trigger = "I have opened a portal into the Dream. Your salvation lies within, heroes..."

	L.engage_trigger = "Intruders have breached the inner sanctum. Hasten the destruction of the green dragon!"

	L.blazing = "Blazing Skeleton"
	L.blazing_desc = "Blazing Skeleton |cffff0000estimated|r respawn timer. This timer may be innacurate, use only as a rough guide."
end

L = BigWigs:NewBossLocale("Blood-Queen Lana'thel", "zhCN")
if L then
	L.engage_trigger = "You have made an... unwise... decision."

	L.shadow = "群聚暗影"
	L.shadow_message = "群聚暗影！"
	L.shadow_bar = "<下一群聚暗影>"

	L.feed_message = "即將 狂亂嗜血！"

	L.pact_message = "暗殞契印"
	L.pact_bar = "<下一暗殞契印>"

	L.phase_message = "即將 空中階段！"
	L.phase1_bar = "<地面階段>"
	L.phase2_bar = "<空中階段>"
end