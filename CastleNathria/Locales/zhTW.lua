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

	L.custom_off_experimental = "啟用實驗性功能"
	L.custom_off_experimental_desc = "這些功能|cffff0000尚未經過完整測試|r，而且可能造成|cffff0000洗頻|r。"

	L.anima_tracking = "靈魄能量監控|cffff0000（實驗性）|r"
	-L.anima_tracking_desc = "監控靈魄容器等級的訊息與計時條。|n|cffaaff00提示：你可以依據偏好單獨關閉此提示的訊息盒或計時條。"

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

L = BigWigs:NewBossLocale("Stone Legion Generals", "zhTW")
if L then
	L.first_blade = "第一刀"
	L.second_blade = "第二刀"
end
