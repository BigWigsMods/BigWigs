local L = BigWigs:NewBossLocale("Shriekwing", "zhTW")
if not L then return end
if L then
	L.pickup_lantern = "%s 撿起了燈籠！"
	L.dropped_lantern = "%s 把燈籠丟掉了！"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "zhTW")
if L then
	L.killed = "已擊殺%s"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "zhTW")
if L then
	L.stage2_yell = "我想使用這個聖物想得要死，不過死的應該是你。"
	L.stage3_yell = "希望這個神奇的聖物跟它看起來一樣致命！"
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "zhTW")
if L then
	-- L.times = "%dx %s"

	L.level = "%s (等級|cffffff00%d|r)"
	L.full = "%s (|cffff0000滿了|r)"

	-- L.container_active = "Enable Container: %s"

	-- L.anima_adds = "Concentrate Anima Adds"
	-- L.anima_adds_desc = "Show a timer for when adds spawn from the Concentrate Anima debuffs."

	L.custom_off_experimental = "啟用實驗性功能"
	L.custom_off_experimental_desc = "這些功能|cffff0000尚未經過完整測試|r，而且可能造成|cffff0000洗頻|r。"

	L.anima_tracking = "靈魄能量監控|cffff0000（實驗性）|r"
	L.anima_tracking_desc = "監控靈魄容器等級的訊息與計時條。|n|cffaaff00提示：你可以依據偏好單獨關閉此提示的訊息盒或計時條。"

	L.custom_on_stop_timers = "總是顯示計時器"
	--L.custom_on_stop_timers_desc = "Just for testing right now"

	L.desires = "欲望"
	L.bottles = "瓶子"
	L.sins = "罪惡"
end

L = BigWigs:NewBossLocale("The Council of Blood", "zhTW")
if L then
	L.macabre_start_emote = "找好位置，準備開始跳死亡之舞！"
	L.custom_on_repeating_dark_recital = "重覆黑暗伴舞喊話"
	L.custom_on_repeating_dark_recital_desc = "使用 {rt1}、{rt2} 重覆黑暗伴舞喊話，方便你找到你的舞伴。"

	-- L.custom_off_select_boss_order = "Mark Boss Kill Order"
	-- L.custom_off_select_boss_order_desc = "Mark the order the raid will kill the bosses in with cross {rt7}. Requires raid leader or assist to mark."
	-- L.custom_off_select_boss_order_value1 = "Niklaus -> Frieda -> Stavros"
	-- L.custom_off_select_boss_order_value2 = "Frieda -> Niklaus -> Stavros"
	-- L.custom_off_select_boss_order_value3 = "Stavros -> Niklaus -> Frieda"
	-- L.custom_off_select_boss_order_value4 = "Niklaus -> Stavros -> Frieda"
	-- L.custom_off_select_boss_order_value5 = "Frieda -> Stavros -> Niklaus"
	-- L.custom_off_select_boss_order_value6 = "Stavros -> Frieda -> Niklaus"

	L.dance_assist = "跳舞助手"
	L.dance_assist_desc = "顯示舞步方向的警報。"
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t 向前 |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t 向右 |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t 向後 |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t 向左 |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "向前進！"
	L.dance_yell_right = "往右擺！"
	L.dance_yell_down = "往後跳！"
	L.dance_yell_left = "往左搖！"
end

L = BigWigs:NewBossLocale("Sludgefist", "zhTW")
if L then
	-- L.stomp_shift = "Stomp & Shift" -- Destructive Stomp + Seismic Shift
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "zhTW")
if L then
	L.first_blade = "第一刀"
	L.second_blade = "第二刀"

	-- L.skirmishers = "Skirmishers" -- Short for Stone Legion Skirmishers

	-- L.custom_on_stop_timers = "Always show ability bars"
	-- L.custom_on_stop_timers_desc = "Just for testing right now"
end

L = BigWigs:NewBossLocale("Sire Denathrius", "zhTW")
if L then
	--L.add_spawn = "Crimson Cabalists answer the call of Denathrius." -- [RAID_BOSS_EMOTE] Crimson Cabalists answer the call of Denathrius.#Sire Denathrius#4#true"

	--L.infobox_stacks = "%d |4Stack:Stacks;: %d |4player:players;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	--L.custom_on_repeating_nighthunter = "Repeating Night Hunter Yell"
	--L.custom_on_repeating_nighthunter_desc = "Repeating yell messages for the Night Hunter ability using icons {rt1} or {rt2} or {rt3} to find your line easier if you have to soak."

	--L.custom_on_repeating_impale = "Repeating Impale Say"
	--L.custom_on_repeating_impale_desc = "Repeating say messages for the Impale ability using '1' or '22' or '333' or '4444' to make it clear in what order you will be hit."

	--L.hymn_stacks = "Nathrian Hymn"
	--L.hym_stacks_desc = "Alerts for the amount of Nathrian Hymn stacks currently on you."

	--L.ravage_target = "Ravage Target Cast Bar"
	--L.ravage_target_desc = "Display a cast bar showing the time until the Ravage Target location is chosen in stage 3."
end
