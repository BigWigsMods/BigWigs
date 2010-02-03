local L = BigWigs:NewBossLocale("Blood Prince Council", "zhTW")
if L then
	L.switch_message = "虛弱轉換: %s"
	L.switch_bar = "<下一虛弱轉換>"

	L.infernoflames = "地獄火"
	L.infernoflames_message = "火球術"

	L.empowered_shock_message = "正在施放 強力震擊漩渦！"
	L.regular_shock_message = "震擊漩渦區域！"
	L.shock_say = ">我< 震擊漩渦！"

	L.skullprince = "Skull on active prince"
	L.skullprince_desc = "Place a skull on the active blood prince with health."
end

L = BigWigs:NewBossLocale("Festergut", "zhTW")
if L then
	L.engage_trigger = "玩耍時間?"

	L.inhale_message = "吸入荒疫：>%d<！"
	L.inhale_bar = "<下一吸入荒疫：%d>"

	L.blight_warning = "約5秒後，刺鼻荒疫！"
	L.blight_bar = "<下一刺鼻荒疫>"

	L.bloat_message = "胃囊膨脹%2$dx：>%1$s<！"
	L.bloat_bar = "<下一胃囊膨脹>"

	L.spore_bar = "<下一氣體孢子>"
end

L = BigWigs:NewBossLocale("Icecrown Gunship Battle", "zhTW")
if L then
	L.adds = "傳送門"
	L.adds_desc = "傳送門警報。"
	L.adds_trigger_alliance = "劫奪者，士官們，攻擊!"
	L.adds_trigger_horde = "Marines, Sergeants, attack!"
	L.adds_message = "傳送門！"
	L.adds_bar = "<下一傳送門>"

	L.mage = "法師"
	L.mage_desc = "當法師出現冰凍砲艇火砲時發出警報。"
	L.mage_message = "法師 出現！"
	L.mage_bar = "<下一法師>"

	L.enable_trigger_alliance = "發動引擎!小夥子們，我們即將面對命運啦!"
	L.enable_trigger_horde = "起來吧，部落的子女!今天我們要和最可恨的敵人作戰!為了部落!"

	L.disable_trigger_alliance = "別說我沒警告過你，無賴!兄弟姊妹們，向前衝!"
	L.disable_trigger_horde = "聯盟已經動搖了。向巫妖王前進!"
end

L = BigWigs:NewBossLocale("Lady Deathwhisper", "zhTW")
if L then
	L.engage_trigger = "這騷動是怎麼回事?"
	L.phase2_message = "第二階段 - 失去法力屏障！"

	L.dnd_message = ">你< 死亡凋零！"

	L.adds = "增援"
	L.adds_desc = "當召喚增援時顯示計時條。"
	L.adds_bar = "<下一增援>"
	L.adds_warning = "5秒後，新的增援！"

	L.touch_message = "無脅之觸%2$dx：>%1$s<！"
	L.touch_bar = "<下一無脅之觸>"

	L.deformed_yell = "I release you from the curse of flesh!"
	L.deformed_fanatic = "Deformed Fanatic!"
end

L = BigWigs:NewBossLocale("Lord Marrowgar", "zhTW")
if L then
	L.impale_cd = "<下一刺穿>"

	L.bonestorm_cd = "<下一骸骨風暴>"
	L.bonestorm_warning = "5秒後，骸骨風暴！"

	L.coldflame_message = ">你< 冷焰！"

	L.engage_trigger = "天譴軍團會化身為死亡與毀滅，席捲整個世界。"
end

L = BigWigs:NewBossLocale("Putricide Dogs", "zhTW")
if L then
	L.wound_message = "致死重傷%2$dx：>%1$s<！"
end

L = BigWigs:NewBossLocale("Professor Putricide", "zhTW")
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

L = BigWigs:NewBossLocale("Rotface", "zhTW")
if L then
	L.engage_trigger = "不不不不不!"

	L.infection_bar = "<突變感染：%s>"
	L.infection_message = "突變感染"

	L.ooze = "軟泥融合"
	L.ooze_desc = "當軟泥融合時發出警報！"
	L.ooze_message = "不穩定的軟泥：>%dx<！"

	L.spray_bar = "<下一泥漿噴霧>"
end

L = BigWigs:NewBossLocale("Deathbringer Saurfang", "zhTW")
if L then
	L.adds = "血獸"
	L.adds_desc = "當召喚血獸時發出警報和顯示計時條。"
	L.adds_warning = "5秒後，血獸！"
	L.adds_message = "召喚血獸！"
	L.adds_bar = "<下一血獸>"

	L.rune_bar = "<下一血魄符文>"

	L.mark = "墮落勇士印記：>%d<！"

	L.engage_trigger = "以巫妖王之力!"
	L.warmup_alliance = "那我們走吧!快點……"
	L.warmup_horde = "柯爾克隆，前進!勇士們，要當心，天譴軍團已經……"
end

L = BigWigs:NewBossLocale("Sindragosa", "zhTW")
if L then
	L.airphase_trigger = "你們的入侵將在此終止!誰也別想存活!"
	L.airphase = "空中階段"
	L.airphase_message = "空中階段！"
	L.airphase_desc = "當辛德拉苟莎起飛時發出警報。"
	L.boom = "極凍之寒！"
end

L = BigWigs:NewBossLocale("Valithria Dreamwalker", "zhTW")
if L then
	L.manavoid_message = ">你< 潰法力場！"
	L.portal = "夢魘之門！"
	L.portal_desc = "當瓦莉絲瑞雅·夢行者打開夢魘之門時發出警報。"
	L.portal_message = "打開夢魘之門！"
	L.portal_trigger = "I have opened a portal into the Dream. Your salvation lies within, heroes..."
end

L = BigWigs:NewBossLocale("Blood-Queen Lana'thel", "zhTW")
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