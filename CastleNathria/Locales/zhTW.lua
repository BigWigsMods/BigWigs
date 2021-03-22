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

L = BigWigs:NewBossLocale("Sun King's Salvation", "zhTW")
if L then
	L.shield_removed = "%s在 %.1f 秒後移除" -- "Shield removed after 1.1s" s = seconds
	L.shield_remaining = "%s剩餘：%s（%.1f%%）" -- "Shield remaining: 2.1K (5.3%)"
end

L = BigWigs:NewBossLocale("Hungering Destroyer", "zhTW")
if L then
	L.miasma = "瘴氣" -- Short for Gluttonous Miasma

	L.custom_on_repeating_yell_miasma = "重覆貪食瘴氣喊話"
	L.custom_on_repeating_yell_miasma_desc = "當你中了貪食瘴氣，會在生命值低於 75% 時持續喊話。"

	L.custom_on_repeating_say_laser = "重覆猛烈噴射說話"
	L.custom_on_repeating_say_laser_desc = "當你你被標記為猛烈噴射的目標時，重覆發送說話訊息，以便接近你的玩家可以立刻看見並避開。"

	L.tempPrint = "我們已經替瘴氣添增加了喊話提示。如果你之前為此使用過 WeakAuras 字符串，可能需要將其刪除以防止出現重覆喊話。"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "zhTW")
if L then
	L.tear = "裂口" -- Short for Dimensional Tear
	L.spirits = "靈魂" -- Short for Fleeting Spirits
	L.seeds = "種子" -- Short for Seeds of Extinction
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "zhTW")
if L then
	L.times = "%d層 %s"

	L.level = "%s (等級|cffffff00%d|r)"
	L.full = "%s (|cffff0000滿了|r)"

	L.anima_adds = "濃縮靈魄增援"
	L.anima_adds_desc = "替濃縮靈魄減益效果召喚的增援生成顯示計時條。"

	L.custom_off_experimental = "啟用實驗性功能"
	L.custom_off_experimental_desc = "這些功能|cffff0000尚未經過完整測試|r，而且可能造成|cffff0000洗頻|r。"

	L.anima_tracking = "靈魄能量監控|cffff0000（實驗性）|r"
	L.anima_tracking_desc = "監控靈魄容器等級的訊息與計時條。|n|cffaaff00提示：你可以依據偏好單獨關閉此提示的訊息盒或計時條。"

	L.custom_on_stop_timers = "總是顯示計時器"
	--L.custom_on_stop_timers_desc = "Just for testing right now"

	L.desires = "欲望"
	L.bottles = "瓶子"
	L.sins = "苦難"
end

L = BigWigs:NewBossLocale("The Council of Blood", "zhTW")
if L then
	L.macabre_start_emote = "找好位置，準備開始跳死亡之舞！"
	L.custom_on_repeating_dark_recital = "重覆黑暗伴舞喊話"
	L.custom_on_repeating_dark_recital_desc = "使用 {rt1} 和 {rt2} 重覆黑暗伴舞喊話，方便你找到你的舞伴。"

	L.custom_off_select_boss_order = "標記擊殺順序"
	L.custom_off_select_boss_order_desc = "以紅叉 {rt7} 標記首領擊殺順序，需要權限。"
	L.custom_off_select_boss_order_value1 = "守城將領 -> 佛蕾妲女爵 -> 史塔沃斯"
	L.custom_off_select_boss_order_value2 = "佛蕾妲女爵 -> 守城將領 -> 史塔沃斯"
	L.custom_off_select_boss_order_value3 = "史塔沃斯勛爵 -> 守城將領 -> 佛蕾妲女爵"
	L.custom_off_select_boss_order_value4 = "守城將領 -> 史塔沃斯 -> 佛蕾妲女爵"
	L.custom_off_select_boss_order_value5 = "佛蕾妲女爵 -> 史塔沃斯 -> 守城將領"
	L.custom_off_select_boss_order_value6 = "史塔沃斯 -> 佛蕾妲女爵 -> 守城將領"

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
	L.stomp_shift = "踐踏與震地" -- Destructive Stomp + Seismic Shift

	L.fun_info = "傷害訊息"
	L.fun_info_desc = "以訊息顯示泥拳在毀滅撞擊的昏迷期間所損失的生命值。"

	L.health_lost = "泥拳的血量下降了 %.1f%%！"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "zhTW")
if L then
	L.first_blade = "第一刀"
	L.second_blade = "第二刀"

	L.skirmishers = "鬥爭者" -- Short for Stone Legion Skirmishers
	L.eruption = "爆發" -- Short for Reverberating Eruption

	L.custom_on_stop_timers = "總是顯示計時器"
	--L.custom_on_stop_timers_desc = "Just for testing right now"

	L.goliath_short = "巨人"
	L.goliath_desc = "對即將到來的石源魔軍團巨人顯示警告和計時器。"

	L.commando_short = "特種兵"
	L.commando_desc = "擊殺石源魔軍團特種兵時顯示警告。"
end

L = BigWigs:NewBossLocale("Sire Denathrius", "zhTW")
if L then
	L.add_spawn = "赤紅秘術師回應了戴納瑟斯的呼喚。" -- [RAID_BOSS_EMOTE] Crimson Cabalists answer the call of Denathrius.#Sire Denathrius#4#true"

	L.infobox_stacks = "%d 堆疊：%d 玩家" -- 4 Stacks: 5 players // 1 Stack: 1 player

	L.custom_on_repeating_nighthunter = "重覆黑夜獵人喊話"
	L.custom_on_repeating_nighthunter_desc = "以 {rt1}、{rt2} 或 {rt3} 重覆黑夜獵人喊話，使需要分攤的人可以更方便地找到你負責分攤的那條線。"

	L.custom_on_repeating_impale = "重覆刺穿喊話"
	L.custom_on_repeating_impale_desc = "以「1」、「22」、「333」或「4444」的方式重覆刺穿喊話，使你能清楚明瞭地知道擊中順序。"

	L.hymn_stacks = "納撒亞讚歌"
	L.hymn_stacks_desc = "以警報提示你的納撒亞讚歌層數。"

	L.ravage_target = "倒影：劫掠目標施法條"
	L.ravage_target_desc = "顯示倒影指向劫掠目標位置時間的施法條。"
	L.ravage_targeted = "劫掠鎖定目標" -- Text on the bar for when Ravage picks its location to target in stage 3

	L.no_mirror = "沒鏡子：%d" -- Player amount that does not have the Through the Mirror
	L.mirror = "鏡子：%d" -- Player amount that does have the Through the Mirror
end

L = BigWigs:NewBossLocale("Castle Nathria Trash", "zhTW")
if L then
	--[[ Pre Shriekwing ]]--
	L.moldovaak = "魔多瓦克"
	L.caramain = "卡拉曼"
	L.sindrel = "辛德雷"
	L.hargitas = "哈吉塔斯"

	--[[ Shriekwing -> Huntsman Altimor ]]--
	L.gargon = "笨重的石獸"
	L.hawkeye = "納撒亞追蹤者"
	L.overseer = "養狗場監督者"

	--[[ Huntsman Altimor -> Hungering Destroyer ]]--
	L.feaster = "噬懼者"
	L.rat = "大得離譜的老鼠"
	L.miasma = "瘴氣" -- Short for Gluttonous Miasma

	--[[ Hungering Destroyer -> Lady Inerva Darkvein ]]--
	L.deplina = "戴普琳娜"
	L.dragost = "德苟斯特"
	L.kullan = "庫倫"

	--[[ Shriekwing -> Xy'mox ]]--
	L.antiquarian = "邪惡的古物收藏家"
	L.conservator = "納撒亞栽培者"
	L.archivist = "納撒亞文獻管理員"

	--[[ Sludgefist -> Stone Legion Generals ]]--
	L.goliath = "石源魔軍團巨人"
end
