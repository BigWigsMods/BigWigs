local L = BigWigs:NewBossLocale("Hydross the Unstable", "zhTW")
if not L then return end
if L then
	L.start_trigger = "我不准你涉入這件事!"

	L.mark = "印記"
	L.mark_desc = "印記警報及計數"

	L.stance = "形態改變"
	L.stance_desc = "當 不穩定者海卓司 改變型態時發出警報"
	L.poison_stance = "海卓司轉為毒型態!"
	L.water_stance = "海卓司轉為水狀態!"

	L.debuff_warn = "印記施放於 %s%%"
end

L = BigWigs:NewBossLocale("Fathom-Lord Karathress", "zhTW")
if L then
	L.enrage_trigger = "守衛，注意!我們有訪客了……"

	L.totem = "飛火圖騰"
	L.totem_desc = "飛火圖騰施放警示"
	L.totem_message1 = "提達費斯: 飛火圖騰!"
	L.totem_message2 = "卡拉薩瑞斯: 飛火圖騰!"
	L.heal_message = "治療波 - 快中斷!"

	L.priest = "深淵守衛卡利迪斯"
end

L = BigWigs:NewBossLocale("Leotheras the Blind", "zhTW")
if L then
	L.enrage_trigger = "終於結束了我的流放生涯!"

	L.phase = "惡魔型態"
	L.phase_desc = "惡魔型態計時"
	L.phase_trigger = "消失吧，微不足道的精靈。現在開始由我掌管!"
	L.phase_demon = "惡魔型態 - 持續 60 秒!"
	L.phase_demonsoon = "5 秒內進入惡魔型態!"
	L.phase_normalsoon = "5 秒內回到普通型態!"
	L.phase_normal = "普通型態 - 即將施放旋風斬!"
	L.demon_bar = "惡魔型態"
	L.demon_nextbar = "下一次惡魔型態"

	L.mindcontrol = "心靈控制"
	L.mindcontrol_desc = "當隊友受到心靈控制時警告"
	L.mindcontrol_warning = "心靈控制"

	L.image = "影分身"
	L.image_desc = "15% 分身警告"
	L.image_trigger = "不…不!你做了什麼?我是主人!你沒聽見我在說話嗎?我…..啊!無法…控制它。"
	L.image_message = "15% - 分身出現!"
	L.image_warning = "分身即將出現!"

	L.whisper = "陰險之語"
	L.whisper_desc = "當隊友受到陰險之語時警告"
	L.whisper_message = "內心的惡靈"
	L.whisper_bar = "內心的惡靈消失計時"
	L.whisper_soon = "內心的惡靈冷卻"
end

L = BigWigs:NewBossLocale("The Lurker Below", "zhTW")
if L then
	L.engage_warning = "%s 開始攻擊 - 約90秒後下潛"

	L.dive = "潛水"
	L.dive_desc = "海底潛伏者下潛計時器"
	L.dive_warning = "大約 %d 秒後下潛!"
	L.dive_bar = "下潛"
	L.dive_message = "潛水! 請就位打小兵 (60秒後王再次出現)"

	L.spout = "噴射"
	L.spout_desc = "噴射計時器，僅供參考，不一定準確。"
	L.spout_message = "噴射開始!注意閃避!"
	L.spout_warning = "約 3 秒後噴射!"
	L.spout_bar = "噴射"

	L.emerge_warning = "%d 秒後浮現"
	L.emerge_message = "浮現 - 近戰請等旋風結束上前 (約 90 秒後下潛)"
	L.emerge_bar = "浮現"
end

L = BigWigs:NewBossLocale("Morogrim Tidewalker", "zhTW")
if L then
	L.grave_bar = "<水之墓計時>"
	L.grave_nextbar = "水之墓冷卻"

	L.murloc = "魚人警示"
	L.murloc_desc = "魚人來臨時警示"
	L.murloc_bar = "魚人冷卻"
	L.murloc_message = "魚人出現!"
	L.murloc_soon_message = "魚人即將出現，準備 AE!"
	L.murloc_engaged = "%s 開戰 - 魚人在 40 秒內出現!"

	L.globules = "水珠警示"
	L.globules_desc = "當水珠來臨時警示"
	L.globules_trigger1 = "很快，這一切都將結束!"
	L.globules_trigger2 = "這裡是無處可躲的!"
	L.globules_message = "水珠出現!避開水球!"
	L.globules_warning = "水珠即將出現!"
	L.globules_bar = "水珠消失"
end

L = BigWigs:NewBossLocale("Lady Vashj", "zhTW")
if L then
	L.engage_trigger1 = "我不想要因為跟你這種人交手而降低我自己的身份，但是你們讓我別無選擇……"
	L.engage_trigger2 = "我唾棄你們，地表的渣滓!"
	L.engage_trigger3 = "伊利丹王必勝!"
	L.engage_trigger4 = "我要把你們全部殺死!" -- need chatlog.
	L.engage_trigger5 = "入侵者都要死!"
	L.engage_message = "第一階段 - 開戰!"

	L.phase = "階段警示"
	L.phase_desc = "當瓦許進入不同的階段時警示"
	L.phase2_trigger = "機會來了!一個活口都不要留下!"
	L.phase2_soon_message = "即將進入第二階段!"
	L.phase2_message = "第二階段 - 護衛出現!"
	L.phase3_trigger = "你們最好找掩護。"
	L.phase3_message = "第三階段 - 4 分鐘內狂怒!"

	L.elemental = "污染的元素警示"
	L.elemental_desc = "當第二階段污染的元素出現時警示"
	L.elemental_bar = "<污染的元素計時>"
	L.elemental_soon_message = "污染的元素即將出現!優先集火!"

	L.strider = "盤牙旅行者警示"
	L.strider_desc = "當第二階段盤牙旅行者出現時警示"
	L.strider_bar = "<盤牙旅行者計時>"
	L.strider_soon_message = "盤牙旅行者即將出現!牧師漸隱!"

	L.naga = "盤牙精英警示"
	L.naga_desc = "當第二階段盤牙精英出現時警示"
	L.naga_bar = "盤牙精英計時"
	L.naga_soon_message = "盤牙精英即將出現!中央坦克注意!"

	L.barrier_desc = "當瓦許女士的魔法屏障消失時警示"
	L.barrier_down_message = "魔法屏障 %d/4 解除!"
end

