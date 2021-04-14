local L = BigWigs:NewBossLocale("Void Reaver", "zhTW")
if not L then return end
if L then
	L.engage_trigger = "警告!你已經被標記為消滅的對象。"
end

L = BigWigs:NewBossLocale("High Astromancer Solarian", "zhTW")
if L then
	L.engage_trigger = "與血精靈為敵者死!"

	L.phase = "階段警告"
	L.phase_desc = "當階段轉換時警告"
	L.phase1_message = "第一階段 - 50 秒內分身!"
	L.phase2_warning = "即將進入第二階段!"
	L.phase2_trigger = "夠了!現在我要呼喚宇宙中失衡的能量。"
	L.phase2_message = "20% - 第二階段!"

	L.wrath_other = "星術師之怒"

	L.split = "分身警告"
	L.split_desc = "當分身與小兵出現時警示"
	L.split_trigger1 = "我會粉碎你那偉大的夢想!"
	L.split_trigger2 = "我的實力遠勝於你!"
	L.split_bar = "下一次分身"
	L.split_warning = "7 秒內分身來臨!"

	L.agent_warning = "分身! - 6 秒內密探出現!"
	L.agent_bar = "密探計時"
	L.priest_warning = "5 秒內牧師、星術師出現!"
	L.priest_bar = "牧師, 星術師計時"
end

L = BigWigs:NewBossLocale("Kael'thas Sunstrider", "zhTW")
if L then
	L.engage_trigger = "能量。力量。我的人民陷入其中不能自拔……自從太陽之井被摧毀之後就顯得更加明顯。歡迎來到未來。真遺憾，你們無法阻止什麼。沒有人可以阻止我了﹗(薩拉斯語)為了人民的正義!"
	L.engage_message = "第一階段 - 四顧問!"

	L.gaze = "凝視"
	L.gaze_desc = "警報誰受到凝視"
	L.gaze_trigger = "凝視著"

	L.fear_soon_message = "即將恐懼!"
	L.fear_message = "恐懼!"
	L.fear_bar = "恐懼冷卻"

	L.rebirth = "鳳凰復生"
	L.rebirth_desc = "顯示鳳凰復生的計時"
	L.rebirth_warning = "約 5 秒內鳳凰可能復生!"
	L.rebirth_bar = "<估計復生時間>"

	L.pyro = "炎爆術"
	L.pyro_desc = "顯示一個 60 秒的炎爆術計時"
	L.pyro_trigger = "開始施放炎爆術"
	L.pyro_warning = "約 5 秒內施放炎爆術!"
	L.pyro_message = "炎爆術!"

	L.phase = "階段警示"
	L.phase_desc = "開啟各階段警示"
	L.thaladred_inc_trigger = "讓我們看看你們這些大膽的狂徒如何反抗晦暗者薩拉瑞德的力量!"
	L.sanguinar_inc_trigger = "你已經努力的打敗了我的幾位最忠誠的諫言者…但是沒有人可以抵抗血錘的力量。等著看桑古納爾的力量吧!"
	L.capernian_inc_trigger = "卡普尼恩將保證你們不會在這裡停留太久。"
	L.telonicus_inc_trigger = "做得好，你已經證明你的實力足以挑戰我的工程大師泰隆尼卡斯。"
	L.weapons_inc_trigger = "你們看，我的個人收藏中有許多武器……"
	L.phase3_trigger = "也許我低估了你。要你一次對付四位諫言者也許對你來說是不太公平，但是……我的人民從未得到公平的對待。我只是以牙還牙而已。"
	L.phase4_trigger = "唉，有些時候，有些事情，必須得親自解決才行。(薩拉斯語)受死吧!"

	L.flying_trigger = "我的心血是不會被你們輕易浪費的!我精心謀劃的未來是不會被你們輕易破壞的!感受我真正的力量吧!"
	L.flying_message = "第五階段 - 1 分鐘內重力流逝!"

	L.weapons_inc_message = "第二階段 - 武器即將出現!"
	L.phase3_message = "第三階段 - 顧問群重生!"
	L.phase4_message = "第四階段 - 王子來臨!"
	L.phase4_bar = "凱爾薩斯來臨"

	L.mc = "精神控制"
	L.mc_desc = "精神控制警報"

	L.revive_bar = "顧問重生"
	L.revive_warning = "顧問在 5 秒內活動! 坦克、治療準備就位!"

	L.dead_message = "%s dies"

	L.capernian = "大星術師卡普尼恩"
	L.sanguinar = "桑古納爾領主"
	L.telonicus = "工程大師泰隆尼卡斯"
	L.thaladred = "扭曲預言家薩拉瑞德"
end

