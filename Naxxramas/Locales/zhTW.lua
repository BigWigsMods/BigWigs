local L = BigWigs:NewBossLocale("Anub'Rekhan", "zhTW")
if not L then return end
if L then
	L.bossName = "阿努比瑞克漢"

	L.starttrigger1 = "一些小點心……"
	L.starttrigger2 = "對，跑吧!那樣傷口出血就更多了!"
	L.starttrigger3 = "你們逃不掉的。"
	L.engagewarn = "阿努比瑞克漢已進入戰鬥 - %d秒後，蝗蟲風暴！"

	L.gainendwarn = "蝗蟲風暴結束了！"
	L.gainnextwarn = "85秒後，下一波蝗蟲風暴！"
	L.gainwarn10sec = "10秒後，下一波蝗蟲風暴！"
	L.gainincbar = "<下一蝗蟲風暴>"

	L.castwarn = "蝗蟲風暴！"
end

L = BigWigs:NewBossLocale("Grand Widow Faerlina", "zhTW")
if L then
	L.bossName = "大寡婦費琳娜"

	L.starttrigger1 = "跪下求饒吧，懦夫!"
	L.starttrigger2 = "以主人之名，殺了他們!"
	L.starttrigger3 = "休想從我面前逃掉!"
	L.starttrigger4 = "逃啊!有本事就逃啊!"

	L.startwarn = "大寡婦費琳娜已進入戰鬥 - 60秒後，狂怒！"

	L.enragewarn15sec = "15秒後，狂怒！"
	L.enragewarn = "狂怒！"
	L.enragewarn2 = "即將 狂怒！"
	L.enrageremovewarn = "狂怒已移除 - 約60秒後，狂怒！"

	L.silencewarn = "沉默！延緩了狂怒！"
	L.silencewarn5sec = "5秒後沉默結束！"
	L.silencebar = "<沉默>"

	L.rain_message = ">你< 火焰之雨！"
end

L = BigWigs:NewBossLocale("Gluth", "zhTW")
if L then
	L.bossName = "古魯斯"

	L.startwarn = "古魯斯已進入戰鬥 - 105秒後，殘殺！"

	L.decimatesoonwarn = "即將 殘殺！"
	L.decimatebartext = "<殘殺>"
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
	L.bomb_message_other = "突變注射：>%s<！"
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

	L.dies = "#%d死亡！"

	L.startwarn = "四騎士已進入戰鬥 - 約17秒後，印記！"
end

L = BigWigs:NewBossLocale("Kel'Thuzad", "zhTW")
if L then
	L.bossName = "科爾蘇加德"

	L.KELTHUZADCHAMBERLOCALIZEDLOLHAX = "科爾蘇加德之間"

	L.start_trigger = "僕從們，侍衛們，隸屬於黑暗與寒冷的戰士們!聽從科爾蘇加德的召喚!"
	L.start_warning = "戰鬥開始，約3分30秒後，科爾蘇加德進入戰鬥！"
	L.start_bar = "<第二階段>"

	L.phase = "階段"
	L.phase_desc = "當進入不同階段時發出警報。"
	L.phase2_trigger1 = "祈禱我的慈悲吧!"
	L.phase2_trigger2 = "呼出你的最後一口氣!"
	L.phase2_trigger3 = "你的末日臨近了!"
	L.phase2_warning = "第二階段 - 科爾蘇加德！"
	L.phase2_bar = "<科爾蘇加德進入戰鬥>"
	L.phase3_soon_warning = "即將 第三階段！"
	L.phase3_trigger = "主人，我需要幫助!"
	L.phase3_warning = "第三階段開始， 約15秒後，寒冰皇冠守衛者出現！"

	L.mc_message = "科爾蘇加德之鍊：>%s<！"
	L.mc_warning = "即將 科爾蘇加德之鍊！"
	L.mc_nextbar = "<下一科爾蘇加德之鍊>"

	L.frostblast_bar = "<可能 冰霜衝擊>"
	L.frostblast_soon_message = "約5秒後，可能冰霜衝擊！"

	L.detonate_other = "爆裂法力：>%s<！"
	L.detonate_possible_bar = "<可能 爆裂法力>"
	L.detonate_warning = "約5秒後，爆裂法力！"

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

	L.aura_message = "亡域光環 - 持續17秒！"
	L.aura_warning = "3秒後，亡域光環消失！"

	L.deathbloom_warning = "5秒後，死亡之花！"

	L.doombar = "<無可避免的末日：%d>"
	L.doomwarn = "無可避免的末日%d，%s秒後！"
	L.doomwarn5sec = "5秒後，無可避免的末日%d！"
	L.doomtimerbar = "<每隔15秒 無可避免的末日>"
	L.doomtimerwarn = "%s秒後改變無可避免的末日發動頻率！"
	L.doomtimerwarnnow = "無可避免的末日現在每隔15秒發動一次！"

	L.sporewarn = "孢子：>%d<！"
	L.sporebar = "<孢子：%d>"
end

L = BigWigs:NewBossLocale("Noth the Plaguebringer", "zhTW")
if L then
	L.bossName = "『瘟疫使者』諾斯"

	L.starttrigger1 = "死吧，入侵者!"
	L.starttrigger2 = "榮耀歸於我主!"
	L.starttrigger3 = "你們終將失去生命!"
	L.startwarn = "『瘟疫使者』諾斯已進入戰鬥 - 90秒後，傳送！"

	L.blink = "閃現術"
	L.blink_desc = "當施放閃現術時發出警報。"
	L.blinktrigger = "%s閃現離開!"
	L.blinkwarn = "閃現術！停止攻擊！"
	L.blinkwarn2 = "約5秒後，閃現術！"
	L.blinkbar = "<閃現術>"

	L.teleport = "傳送"
	L.teleport_desc = "當施放傳送時發出警報。"
	L.teleportbar = "<傳送>"
	L.backbar = "<回到房間>"
	L.teleportwarn = "傳送！"
	L.teleportwarn2 = "10秒後，傳送！"
	L.backwarn = "諾斯回到房間 - %d秒後，傳送！"
	L.backwarn2 = "10秒後諾斯回到房間！"

	L.curseexplosion = "瘟疫使者詛咒！"
	L.cursewarn = "約55秒後，瘟疫使者詛咒！"
	L.curse10secwarn = "約10秒後，瘟疫使者詛咒！"
	L.cursebar = "<下一瘟疫使者詛咒>"

	L.wave = "骷髏"
	L.wave_desc = "當召喚骷髏時發出警報。"
	L.addtrigger = "起來吧，我的戰士們!起來，再為主人盡忠一次!"
	L.wave1bar = "<第一波>"
	L.wave2bar = "<第二波>"
	L.wave2_message = "10秒後，第二波！"
end

L = BigWigs:NewBossLocale("Patchwerk", "zhTW")
if L then
	L.bossName = "縫補者"

	L.enragewarn = "5 % - 狂亂！"
	L.starttrigger1 = "縫補者要跟你玩!"
	L.starttrigger2 = "科爾蘇加德讓縫補者成為戰爭的化身!"
end

L = BigWigs:NewBossLocale("Maexxna", "zhTW")
if L then
	L.bossName = "梅克絲娜"

	L.webspraywarn30sec = "10秒後，纏繞之網！"
	L.webspraywarn20sec = "纏繞之網！10秒後小蜘蛛出現！"
	L.webspraywarn10sec = "小蜘蛛出現！10秒後撒網！"
	L.webspraywarn5sec = "撒網5秒！"
	L.webspraywarn = "40秒後 撒網！"
	L.enragewarn = "狂怒！"
	L.enragesoonwarn = "即將 狂怒！"

	L.webspraybar = "<撒網>"
	L.cocoonbar = "<纏繞之網>"
	L.spiderbar = "<出現 小蜘蛛>"
end

L = BigWigs:NewBossLocale("Sapphiron", "zhTW")
if L then
	L.bossName = "薩菲隆"

	L.airphase_trigger = "%s離地升空了!"
	L.deepbreath_incoming_message = "約14秒後，冰息術！"
	L.deepbreath_incoming_soon_message = "約5秒後，冰息術！"
	L.deepbreath_incoming_bar = "<施放 冰息術>"
	L.deepbreath_trigger = "%s深深地吸了一口氣……"
	L.deepbreath_warning = "即將 冰息術！"
	L.deepbreath_bar = "<冰息術 落地>"

	L.lifedrain_message = "約24秒後，生命吸取！"
	L.lifedrain_warn1 = "5秒後，生命吸取！"
	L.lifedrain_bar = "<生命吸取>"

	L.icebolt_say = "我是寒冰凍體！快躲到我後面！"

	L.ping_message = "寒冰凍體 - 點擊你的位置！"
end

L = BigWigs:NewBossLocale("Instructor Razuvious", "zhTW")
if L then
	L.bossName = "講師拉祖維斯"

	L.shout_warning = "5秒後，混亂怒吼！"
	L.shout_next = "混亂怒吼冷卻！"

	L.taunt_warning = "5秒後，可以嘲諷！"
	L.shieldwall_warning = "5秒後，可以骸骨屏障！"
end

L = BigWigs:NewBossLocale("Thaddius", "zhTW")
if L then
	L.bossName = "泰迪斯"

	L.phase = "階段"
	L.phase_desc = "當進入不同階段時發出警報。"

	L.throw = "投擲"
	L.throw_desc = "當主坦克被投擲到對面平台時發出警報。"

	L.trigger_phase1_1 = "斯塔拉格要碾碎你!"
	L.trigger_phase1_2 = "主人要吃了你!"
	L.trigger_phase2_1 = "咬碎……你的……骨頭……"
	L.trigger_phase2_2 = "打…碎…你……"
	L.trigger_phase2_3 = "殺……"

	L.polarity_trigger = "你感受到痛苦的滋味了吧……"
	L.polarity_message = "泰迪斯開始施放兩極移形！"
	L.polarity_warning = "3秒後，兩極移形！"
	L.polarity_bar = "<兩極移形>"
	L.polarity_changed = "兩極移形改變！"
	L.polarity_nochange = "相同兩極移形！"

	L.polarity_first_positive = "你是 >正極<！"
	L.polarity_first_negative = "你是 >負極<！"

	L.phase1_message = "第一階段"
	L.phase2_message = "第二階段 - 6分鍾後狂怒！"

	L.surge_message = "力量澎湃！加大對坦克的治療！"

	L.throw_bar = "<投擲>"
	L.throw_warning = "約5秒後，投擲！"
end
