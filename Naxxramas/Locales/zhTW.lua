local L = BigWigs:NewBossLocale("Anub'Rekhan", "zhTW")
if not L then return end
if L then
	L.bossName = "阿努比瑞克漢"

	L.gainwarn10sec = "10秒後，下一波蝗蟲風暴！"
	L.gainincbar = "<下一蝗蟲風暴>"
end

L = BigWigs:NewBossLocale("Grand Widow Faerlina", "zhTW")
if L then
	L.bossName = "大寡婦費琳娜"

	L.silencewarn = "沉默！延緩了狂怒！"
	L.silencewarn5sec = "5秒後沉默結束！"
end

L = BigWigs:NewBossLocale("Gluth", "zhTW")
if L then
	L.bossName = "古魯斯"

	L.startwarn = "古魯斯已進入戰鬥 - 105秒後，殘殺！"

	L.decimate_bar = "<殘殺>"
end

L = BigWigs:NewBossLocale("Gothik the Harvester", "zhTW")
if L then
	L.bossName = "『收割者』高希"

	L.room = "進入房間警報"
	L.room_desc = "當『收割者』高希進入房間時發出警報。"

	L.add = "增援警報"
	L.add_desc = "當增援時發出警報。"

	L.adddeath = "增援死亡"
	L.adddeath_desc = "當增援死亡時發出警報。"

	L.starttrigger1 = "你們這些蠢貨已經主動步入了陷阱。"
	L.starttrigger2 = "Kazile Teamanare ZennshinagasRil" -- check
	L.startwarn = "『收割者』高希已進入戰鬥 - 4:30後，進入房間！"

	L.rider = "無情的騎兵"
	L.spectral_rider = "鬼靈騎兵"
	L.deathknight = "無情的死亡騎士"
	L.spectral_deathknight = "鬼靈死亡騎士"
	L.trainee = "無情的受訓員"
	L.spectral_trainee = "鬼靈受訓員"

	L.riderdiewarn = "騎兵已死亡！"
	L.dkdiewarn = "死亡騎士已死亡！"

	L.warn1 = "3分鐘後進入房間！"
	L.warn2 = "90秒後進入房間！"
	L.warn3 = "60秒後進入房間！"
	L.warn4 = "30秒後進入房間！"
	L.warn5 = "10秒後進入房間！"

	L.wave = "%d/23：%s"

	L.trawarn = "3秒後受訓員出現"
	L.dkwarn = "3秒後死亡騎士出現"
	L.riderwarn = "3秒後騎兵出現"

	L.trabar = "受訓員 - %d"
	L.dkbar = "死亡騎士 - %d"
	L.riderbar = "騎兵 - %d"

	L.inroomtrigger = "我已經等待很久了。現在你們將面對靈魂的收割者。"
	L.inroomwarn = "『收割者』高希進入了房間！"

	L.inroombartext = "<進入房間>"
end

L = BigWigs:NewBossLocale("Grobbulus", "zhTW")
if L then
	L.bossName = "葛羅巴斯"

	L.bomb_message = "突變注射"
end

L = BigWigs:NewBossLocale("Heigan the Unclean", "zhTW")
if L then
	L.bossName = "『不潔者』海根"

	L.starttrigger = "你現在是我的了。"
	L.starttrigger2 = "你……就是下一個。"
	L.starttrigger3 = "我看到你了……"

	L.engage = "進入戰鬥"
	L.engage_desc = "當海根進入戰鬥時發出警報。"
	L.engage_message = "海根已進入戰鬥 - 90秒後，傳送！"

	L.teleport = "傳送"
	L.teleport_desc = "當傳送時發出警報。"
	L.teleport_trigger = "你的生命正走向終結。"
	L.teleport_1min_message = "1分鐘後傳送"
	L.teleport_30sec_message = "30秒後傳送"
	L.teleport_10sec_message = "10秒後傳送！"
	L.on_platform_message = "傳送！ - 45秒後海根出現！"

	L.to_floor_30sec_message = "30 秒後返回"
	L.to_floor_10sec_message = "10 秒後返回！"
	L.on_floor_message = "返回！90秒後，傳送！"

	L.teleport_bar = "<傳送>"
	L.back_bar = "<出現>"
end

L = BigWigs:NewBossLocale("The Four Horsemen", "zhTW")
if L then
	L.bossName = "四騎士"

	L.mark = "印記"
	L.mark_desc = "當施放印記時發出警報。"

	L.markbar = "<印記：%d>"
	L.markwarn1 = "印記%d！"
	L.markwarn2 = "5秒後，印記%d！"

	L.startwarn = "四騎士已進入戰鬥 - 約17秒後，印記！"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "zhTW")
if L then
	L.bossName = "科爾蘇加德"
	L.KELTHUZADCHAMBERLOCALIZEDLOLHAX = "科爾蘇加德密室"

	L.start_trigger = "僕從們，侍衛們，隸屬於黑暗與寒冷的戰士們!聽從科爾蘇加德的召喚!"
	L.start_warning = "戰鬥開始，約3分30秒後，科爾蘇加德進入戰鬥！"

	L.phase2_trigger1 = "祈禱我的慈悲吧!"
	L.phase2_trigger2 = "呼出你的最後一口氣!"
	L.phase2_trigger3 = "你的末日臨近了!"
	L.phase2_warning = "第二階段 - 科爾蘇加德！"
	L.phase2_bar = "<科爾蘇加德進入戰鬥>"

	L.phase3_trigger = "主人，我需要幫助!"
	L.phase3_soon_warning = "即將 第三階段！"
	L.phase3_warning = "第三階段開始， 約15秒後，寒冰皇冠守衛者出現！"

	L.guardians = "寒冰皇冠守護者"
	L.guardians_desc = "當第三階段召喚寒冰皇冠守護者時發出警報。"
	L.guardians_trigger = "非常好，凍原的戰士們，起來吧!我命令你們作戰，為你們的主人殺戮或獻身吧!不要留下活口!"
	L.guardians_warning = "約10秒後，寒冰皇冠守護者出現！"
	L.guardians_bar = "<寒冰皇冠守護者出現>"
end

L = BigWigs:NewBossLocale("Loatheb", "zhTW")
if L then
	L.bossName = "憎恨者"

	L.startwarn = "憎恨者已進入戰鬥 - 2分鐘後，無可避免的末日！"

	L.doom_5sec_warn = "5秒後，無可避免的末日%d！"
	L.doomtime_bar = "<每隔15秒 無可避免的末日>"
	L.doomtime_warn = "%s秒後改變無可避免的末日發動頻率！"
	L.doomtime_now = "無可避免的末日現在每隔15秒發動一次！"

	L.remove_curse = "洛斯伯消除了一個詛咒效果"

	L.spore_warn = "孢子：>%d<！"
end

L = BigWigs:NewBossLocale("Noth the Plaguebringer", "zhTW")
if L then
	L.bossName = "『瘟疫使者』諾斯"

	L.starttrigger1 = "死吧，入侵者!"
	L.starttrigger2 = "榮耀歸於我主!"
	L.starttrigger3 = "你們終將失去生命!"
	L.startwarn = "『瘟疫使者』諾斯已進入戰鬥 - 90秒後，傳送！"
	L.add_trigger = "起來吧，我的戰士們!起來，再為主人盡忠一次!"

	L.blink = "閃現術"
	L.blink_desc = "當施放閃現術時發出警報。"
	L.blink_trigger = "%s閃現離開!"
	L.blink_bar = "<閃現術>"

	L.teleport = "傳送"
	L.teleport_desc = "當施放傳送時發出警報。"
	L.teleport_bar = "<傳送>"
	L.teleportwarn = "傳送！"
	L.teleportwarn2 = "10秒後，傳送！"
	L.back_bar = "<回到房間>"
	L.back_warn = "諾斯回到房間 - %d秒後，傳送！"
	L.back_warn2 = "10秒後諾斯回到房間！"

	L.curse_explosion = "瘟疫使者詛咒！"
	L.curse_warn = "約55秒後，瘟疫使者詛咒！"
	L.curse_10sec_warn = "約10秒後，瘟疫使者詛咒！"
	L.curse_bar = "<下一瘟疫使者詛咒>"

	L.wave = "骷髏"
	L.wave_desc = "當召喚骷髏時發出警報。"
	L.wave1_bar = "<第一波>"
	L.wave2_bar = "<第二波>"
	L.wave2_message = "10秒後，第二波！"
end

L = BigWigs:NewBossLocale("Patchwerk", "zhTW")
if L then
	L.bossName = "縫補者"
end

L = BigWigs:NewBossLocale("Maexxna", "zhTW")
if L then
	L.bossName = "梅克絲娜"

	L.webspraywarn30sec = "10秒後，纏繞之網！"
	L.webspraywarn20sec = "纏繞之網！10秒後小蜘蛛出現！"
	L.webspraywarn10sec = "小蜘蛛出現！10秒後撒網！"
	L.webspraywarn5sec = "撒網5秒！"
	L.enragewarn = "狂怒！"
	L.enragesoonwarn = "即將 狂怒！"

	L.cocoonbar = "<纏繞之網>"
	L.spiderbar = "<出現 小蜘蛛>"
end

L = BigWigs:NewBossLocale("Sapphiron", "zhTW")
if L then
	L.bossName = "薩菲隆"

	L.deepbreath_trigger = "%s深深地吸了一口氣……"

	-- L.air_phase = "Air phase"
	-- L.ground_phase = "Ground phase"

	L.deepbreath = "寒冰炸彈"
	L.deepbreath_warning = "即將 寒冰炸彈！"
	L.deepbreath_bar = "<寒冰炸彈 落地>"

	L.icebolt_say = "我是寒冰凍體！"
end

L = BigWigs:NewBossLocale("Instructor Razuvious", "zhTW")
if L then
	L.bossName = "講師拉祖維斯"
	L.understudy = "死亡騎士實習者"

	L.taunt_warning = "5秒後，可以嘲諷！"
	L.shieldwall_warning = "5秒後，可以骸骨屏障！"
end

L = BigWigs:NewBossLocale("Thaddius", "zhTW")
if L then
	L.bossName = "泰迪斯"

	L.trigger_phase1_1 = "斯塔拉格要碾碎你!"
	L.trigger_phase1_2 = "主人要吃了你!"
	L.trigger_phase2_1 = "咬碎……你的……骨頭……"
	L.trigger_phase2_2 = "打…碎…你……"
	L.trigger_phase2_3 = "殺……"

	L.polarity_trigger = "你感受到痛苦的滋味了吧……"

	L.polarity_warning = "3秒後，兩極移形！"
	L.polarity_changed = "兩極移形改變！"
	L.polarity_nochange = "相同兩極移形！"
	L.polarity_first_positive = "你是 >正極<！"
	L.polarity_first_negative = "你是 >負極<！"

	L.phase1_message = "第一階段"
	L.phase2_message = "第二階段 - 5分鍾後狂怒！"

	L.throw = "投擲"
	L.throw_desc = "當主坦克被投擲到對面平台時發出警報。"
	L.throw_warning = "約5秒後，投擲！"

	-- L.polarity_extras = "Additional alerts for Polarity positioning. Make sure to only choose one strategy!"

	-- L.custom_off_charge_RL = "Strategy 1"
	-- L.custom_off_charge_RL_desc = "|cffff2020Negative|r (-) are LEFT, |cff20ff20Positive|r (+) are RIGHT. Start in front of the boss."
	-- L.custom_off_charge_LR = "Strategy 2"
	-- L.custom_off_charge_LR_desc = "|cff20ff20Positive|r (+) are LEFT, |cffff2020Negative|r (-) are RIGHT. Start in front of the boss."

	-- L.custom_off_charge_text = "Text arrows"
	-- L.custom_off_charge_text_desc = "Show a message with the direction to move when Polarity Shift happens."
	-- L.custom_off_charge_voice = "Voice alerts"
	-- L.custom_off_charge_voice_desc = "Play a voice direction when Polarity Shift happens."

	L.warn_left = "<--- 到左邊 <--- 到左邊 <---"
	L.warn_right = "---> 向右 ---> 向右 --->"
	L.warn_swap = "^^^^ 交換 ^^^^ 交換 ^^^^"
	L.warn_stay = "==== 不要動 ==== 不要動 ===="
end
