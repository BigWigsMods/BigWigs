local L = BigWigs:NewBossLocale("Anub'Rekhan", "zhCN")
if not L then return end
if L then
	L.bossName = "阿努布雷坎"

	L.gainwarn10sec = "约10秒后，下一波虫群风暴。"
	L.gainincbar = "<下一虫群风暴>"
end

L = BigWigs:NewBossLocale("Grand Widow Faerlina", "zhCN")
if L then
	L.bossName = "黑女巫法琳娜"

	L.silencewarn = "沉默！延缓了激怒！"
	L.silencewarn5sec = "5秒后沉默结束！"
end

L = BigWigs:NewBossLocale("Gluth", "zhCN")
if L then
	L.bossName = "格拉斯"

	L.startwarn = "格拉斯已激活 - 约105秒后，残杀！"

	L.decimate_bar = "<残杀>"
end

L = BigWigs:NewBossLocale("Gothik the Harvester", "zhCN")
if L then
	L.bossName = "收割者戈提克"

	L.room = "进入房间"
	L.room_desc = "当收割者戈提克进入房间时发出警报。"

	L.add = "增援"
	L.add_desc = "当增援时发出警报。"

	L.adddeath = "增援死亡"
	L.adddeath_desc = "当增援死亡时发出警报。"

	L.starttrigger1 = "你们这些蠢货已经主动步入了陷阱。"
	L.starttrigger2 = "你们正在挑战一个无比强大的存在。"
	L.startwarn = "收割者戈提克已激活 - 4:30后，进入房间！"

	L.rider = "冷酷的骑兵"
	L.spectral_rider = "骑兵"
	L.deathknight = "冷酷的死亡骑士"
	L.spectral_deathknight = "死亡骑士"
	L.trainee = "冷酷的学徒"
	L.spectral_trainee = "学徒"

	L.riderdiewarn = "骑兵已死亡！"
	L.dkdiewarn = "死亡骑士已死亡！"

	L.warn1 = "3分钟后进入房间"
	L.warn2 = "90秒后进入房间"
	L.warn3 = "60秒后进入房间"
	L.warn4 = "30秒后进入房间"
	L.warn5 = "收割者戈提克10秒后进入房间！"

	L.wave = "%d/23：%s"

	L.trawarn = "3秒后学徒出现"
	L.dkwarn = "3秒后死亡骑士出现"
	L.riderwarn = "3秒后骑兵出现"

	L.trabar = "学徒 - %d"
	L.dkbar = "死亡骑士 - %d"
	L.riderbar = "骑兵 - %d"

	L.inroomtrigger = "我已经等待很久了。现在你们将面对灵魂的收割者。"
	L.inroomwarn = "收割者戈提克进入了房间！"

	L.inroombartext = "<进入房间>"
end

L = BigWigs:NewBossLocale("Grobbulus", "zhCN")
if L then
	L.bossName = "格罗布鲁斯"

	L.bomb_message = "变异注射"
end

L = BigWigs:NewBossLocale("Heigan the Unclean", "zhCN")
if L then
	L.bossName = "肮脏的希尔盖"

	L.starttrigger = "你是我的了。"
	L.starttrigger2 = "你……就是下一个。"
	L.starttrigger3 = "我看到你了……"

	L.engage = "激活"
	L.engage_desc = "当激活时发出警报。"
	L.engage_message = "希尔盖已激活 - 90秒后，传送！"

	L.teleport = "传送"
	L.teleport_desc = "当传送时发出警报。"
	L.teleport_trigger = "你的生命正走向终结。"
	L.teleport_1min_message = "1分钟后传送"
	L.teleport_30sec_message = "30秒后传送"
	L.teleport_10sec_message = "10秒后传送！"
	L.on_platform_message = "传送！45秒后希尔盖出现！"

	L.to_floor_30sec_message = "30秒后返回"
	L.to_floor_10sec_message = "10秒后返回！"
	L.on_floor_message = "返回！90秒后，传送！"

	L.teleport_bar = "<传送>"
	L.back_bar = "<出现>"
end

L = BigWigs:NewBossLocale("The Four Horsemen", "zhCN")
if L then
	L.bossName = "天启四骑士"

	L.mark = "印记"
	L.mark_desc = "当施放印记时发出警报。"

	L.markbar = "<标记：%d>"
	L.markwarn1 = "印记%d！"
	L.markwarn2 = "5秒后，印记%d！"

	L.startwarn = "四骑士已激活 - 约17秒后，印记！"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "zhCN")
if L then
	L.bossName = "克尔苏加德"
	L.KELTHUZADCHAMBERLOCALIZEDLOLHAX = "克尔苏加德的大厅"

	L.start_trigger = "仆从们，侍卫们，隶属于黑暗与寒冷的战士们！听从克尔苏加德的召唤！"
	L.start_warning = "战斗开始，约3分30秒后，克尔苏加德激活！"

	L.phase2_trigger1 = "祈祷我的慈悲吧！"
	L.phase2_trigger2 = "呼出你的最后一口气！"
	L.phase2_trigger3 = "你的末日临近了！"
	L.phase2_warning = "第二阶段 - 克尔苏加德！"
	L.phase2_bar = "<激活克尔苏加德>"

	L.phase3_trigger = "主人，我需要帮助！"
	L.phase3_soon_warning = "即将 第三阶段！"
	L.phase3_warning = "第三阶段 - 约15秒后，寒冰皇冠卫士出现！"

	L.guardians = "寒冰皇冠卫士"
	L.guardians_desc = "当第三阶段召唤寒冰皇冠卫士时发出警报。"
	L.guardians_trigger = "很好，冰荒废土的战士们，起来吧！我命令你们为主人而战斗，杀戮，直到死亡！一个活口都不要留！"
	L.guardians_warning = "约10秒后，寒冰皇冠卫士出现！"
	L.guardians_bar = "<寒冰皇冠卫士出现>"
end

L = BigWigs:NewBossLocale("Loatheb", "zhCN")
if L then
	L.bossName = "洛欧塞布"

	L.startwarn = "洛欧塞布已激活 - 2分钟后，必然的厄运！"

	L.doom_5sec_warn = "5秒后，必然的厄运%d！"
	L.doomtime_bar = "<每隔15秒 必然的厄运>"
	L.doomtime_warn = "%s秒后改变必然的厄运发动频率！"
	L.doomtime_now = "必然的厄运现在每隔15秒发动一次！"

	L.remove_curse = "洛欧塞布驱散了一个诅咒效果"

	L.spore_warn = "孢子：>%d<！"
end

L = BigWigs:NewBossLocale("Noth the Plaguebringer", "zhCN")
if L then
	L.bossName = "药剂师诺斯"

	L.starttrigger1 = "死吧，入侵者！"
	L.starttrigger2 = "荣耀归于我主！"
	L.starttrigger3 = "我要没收你的生命！"
	L.startwarn = "药剂师诺斯已激活 - 90秒后，传送！"
	L.add_trigger = "起来吧，我的战士们！起来，再为主人尽忠一次！"

	L.blink = "闪现术"
	L.blink_desc = "当施放闪现术时发出警报。"
	L.blink_trigger = "%s施放了瞬移！"
	L.blink_bar = "<闪现术>"

	L.teleport = "传送"
	L.teleport_desc = "当施放传送时发出警报。"
	L.teleport_bar = "<传送>"
	L.teleportwarn = "传送！"
	L.teleportwarn2 = "10秒后，传送！"
	L.back_bar = "<回到房间>"
	L.back_warn = "诺斯回到房间 - %d秒后，传送！"
	L.back_warn2 = "10秒后诺斯回到房间！"

	L.curse_explosion = "瘟疫使者的诅咒！"
	L.curse_warn = "约55秒后，瘟疫使者的诅咒！"
	L.curse_10sec_warn = "约10秒后，瘟疫使者的诅咒！"
	L.curse_bar = "<下一瘟疫使者的诅咒>"

	L.wave = "骷髅"
	L.wave_desc = "当召唤骷髅时发出警报。"
	L.wave1_bar = "<第一波>"
	L.wave2_bar = "<第二波>"
	L.wave2_message = "10秒后，第二波！"
end

L = BigWigs:NewBossLocale("Patchwerk", "zhCN")
if L then
	L.bossName = "帕奇维克"
end

L = BigWigs:NewBossLocale("Maexxna", "zhCN")
if L then
	L.bossName = "迈克斯纳"

	L.webspraywarn30sec = "10秒后，蛛网裹体！"
	L.webspraywarn20sec = "蛛网裹体！10秒后小蜘蛛出现！"
	L.webspraywarn10sec = "小蜘蛛出现！10秒后蛛网喷射！"
	L.webspraywarn5sec = "蛛网喷射5秒！"
	L.enragewarn = "激怒！"
	L.enragesoonwarn = "即将 激怒！"

	L.cocoonbar = "<蛛网裹体>"
	L.spiderbar = "<出现 小蜘蛛>"
end

L = BigWigs:NewBossLocale("Sapphiron", "zhCN")
if L then
	L.bossName = "萨菲隆"

	L.deepbreath_trigger = "%s深深地吸了一口气……"

	L.air_phase = "空中阶段"
	L.ground_phase = "地面阶段"

	L.deepbreath = "寒冰炸弹"
	L.deepbreath_warning = "即将 寒冰炸弹！"
	L.deepbreath_bar = "<寒冰炸弹 落地>"

	L.icebolt_say = "我是寒冰屏障！"
end

L = BigWigs:NewBossLocale("Instructor Razuvious", "zhCN")
if L then
	L.bossName = "教官拉苏维奥斯"
	L.understudy = "见习死亡骑士"

	L.taunt_warning = "5秒后，可以嘲讽！"
	L.shieldwall_warning = "5秒后，可以白骨屏障！"
end

L = BigWigs:NewBossLocale("Thaddius", "zhCN")
if L then
	L.bossName = "塔迪乌斯"

	L.trigger_phase1_1 = "斯塔拉格要碾碎你！"
	L.trigger_phase1_2 = "主人要吃了你！"
	L.trigger_phase2_1 = "咬碎……你的……骨头……"
	L.trigger_phase2_2 = "打……烂……你！"
	L.trigger_phase2_3 = "杀……"

	L.add_death_trigger = "%s死了。"
	L.overload_trigger = "%s超载了！"
	L.polarity_trigger = "你感受到痛苦的滋味了吧……"

	L.polarity_warning = "3秒后，极性转化！"
	L.polarity_changed = "极性转化改变！"
	L.polarity_nochange = "相同极性转化！"
	L.polarity_first_positive = "你是 >正极<！"
	L.polarity_first_negative = "你是 >负极<！"

	L.phase1_message = "第一阶段"
	L.phase2_message = "第二阶段 - 5分钟后激怒！"

	L.throw = "投掷"
	L.throw_desc = "当 MT 被投掷到对面平台时发出警报。"
	L.throw_warning = "约5秒后，投掷！"

	L.polarity_extras = "有关极性转化后需要跑位的警报"

	L.custom_off_select_charge_position = "起始位置"
	L.custom_off_select_charge_position_desc = "第一次极性转化后的位置。"
	L.custom_off_select_charge_position_value1 = "|cffff2020负极(-)|r 向左, |cff20ff20正极(+)|r 向右"
	L.custom_off_select_charge_position_value2 = "|cff20ff20正极(+)|r 向左, |cffff2020负极(-)|r 向右"

	L.custom_off_select_charge_movement = "移动战术"
	L.custom_off_select_charge_movement_desc = "你团队使用的移动战术。"
	L.custom_off_select_charge_movement_value1 = "使用战术： |cff20ff20穿过|r BOSS"
	L.custom_off_select_charge_movement_value2 = "使用战术：在BOSS身边 |cff20ff20顺时针|r 移动"
	L.custom_off_select_charge_movement_value3 = "使用战术：在BOSS身边 |cff20ff20逆时针|r 移动"
	L.custom_off_select_charge_movement_value4 = "四点战术 1: 极性转化改变 |cff20ff20向右|r, 极性转化未改变 |cff20ff20向左|r"
	L.custom_off_select_charge_movement_value5 = "四点战术 2: 极性转化改变 |cff20ff20向左|r, 极性转化未改变 |cff20ff20向右|r"

	L.custom_off_charge_graphic = "图形箭头"
	L.custom_off_charge_graphic_desc = "显示图形箭头。"
	L.custom_off_charge_text = "文字箭头"
	L.custom_off_charge_text_desc = "显示文字箭头。"
	L.custom_off_charge_voice = "语音提示"
	L.custom_off_charge_voice_desc = "播放语音提示。"

	-- Translate these to get locale sound files!
	L.left = "<--- 向左 <--- 向左 <---"
	L.right = "---> 向右 ---> 向右 --->"
	L.swap = "^^^^ 交换 ^^^^ 迅速 ^^^^"
	L.stay = "==== 不要动 ==== 不要动 ===="
end
