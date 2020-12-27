local L = BigWigs:NewBossLocale("Shriekwing", "zhCN")
if not L then return end
if L then
	L.pickup_lantern = "%s 捡起了灯笼！"
	L.dropped_lantern = "%s 丢掉了灯笼!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "zhCN")
if L then
	L.killed = "%s 已击杀"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "zhCN")
if L then
	L.stage2_yell = "我一直想玩玩这件圣物，都快想疯了！而你们的死，可以填补我多年的空虚。"
	L.stage3_yell = "如此美妙的东西，如果没有杀伤力就太可惜了！"
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "zhCN")
if L then
	L.times = "%d层 %s"

	L.level = "%s（等级 |cffffff00%d|r）"
	L.full = "%s（|cffff0000满|r）"

	-- L.container_active = "Enable Container: %s"

	-- L.anima_adds = "Concentrate Anima Adds"
	-- L.anima_adds_desc = "Show a timer for when adds spawn from the Concentrate Anima debuffs."

	L.custom_off_experimental = "启用实验性功能"
	L.custom_off_experimental_desc = "此功能|cffff0000未测试|r并可能|cffff0000刷屏|r。"

	L.anima_tracking = "心能追踪|cffff0000（实验性）|r"
	L.anima_tracking_desc = "追踪容器的心能等级的信息和计时条。|n|cffaaff00提示：可能要禁用信息盒或计时条，根据配置。"

	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "只是为了马上测试"

	L.desires = "欲望"
	L.bottles = "瓶子"
	L.sins = "罪孽"
end

L = BigWigs:NewBossLocale("The Council of Blood", "zhCN")
if L then
	L.macabre_start_emote = "找到你的位置，准备开始断魂之舞！" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	L.custom_on_repeating_dark_recital = "重复黑暗伴舞"
	L.custom_on_repeating_dark_recital_desc = "重复黑暗伴舞喊话信息使用 {rt1}，{rt2} 图标，和伙伴共舞。"

	-- L.custom_off_select_boss_order = "Mark Boss Kill Order"
	-- L.custom_off_select_boss_order_desc = "Mark the order the raid will kill the bosses in with cross {rt7}. Requires raid leader or assist to mark."
	-- L.custom_off_select_boss_order_value1 = "Niklaus -> Frieda -> Stavros"
	-- L.custom_off_select_boss_order_value2 = "Frieda -> Niklaus -> Stavros"
	-- L.custom_off_select_boss_order_value3 = "Stavros -> Niklaus -> Frieda"
	-- L.custom_off_select_boss_order_value4 = "Niklaus -> Stavros -> Frieda"
	-- L.custom_off_select_boss_order_value5 = "Frieda -> Stavros -> Niklaus"
	-- L.custom_off_select_boss_order_value6 = "Stavros -> Frieda -> Niklaus"

	L.dance_assist = "跳舞助手"
	L.dance_assist_desc = "显示舞台的定向警报。"
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t 向前跳 |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t 向右跳 |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t 向后跳 |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t 向左跳 |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "前阔步" -- Prance Forward!
	L.dance_yell_right = "右摆步" -- Shimmy right!
	L.dance_yell_down = "后摇步" -- Boogie down!
	L.dance_yell_left = "左滑步" -- Sashay left!
end

L = BigWigs:NewBossLocale("Sludgefist", "zhCN")
if L then
	-- L.stomp_shift = "Stomp & Shift" -- Destructive Stomp + Seismic Shift
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "zhCN")
if L then
	L.first_blade = "第一刀"
	L.second_blade = "第二刀"

	-- L.skirmishers = "Skirmishers" -- Short for Stone Legion Skirmishers

	-- L.custom_on_stop_timers = "Always show ability bars"
	-- L.custom_on_stop_timers_desc = "Just for testing right now"
end

L = BigWigs:NewBossLocale("Sire Denathrius", "zhCN")
if L then
	--L.add_spawn = "Crimson Cabalists answer the call of Denathrius." -- [RAID_BOSS_EMOTE] Crimson Cabalists answer the call of Denathrius.#Sire Denathrius#4#true"

	--L.infobox_stacks = "%d |4Stack:Stacks;: %d |4player:players;" -- 4 Stacks: 5 players // 1 Stack: 1 player

	--L.custom_on_repeating_nighthunter = "Repeating Night Hunter Yell"
	--L.custom_on_repeating_nighthunter_desc = "Repeating yell messages for the Night Hunter ability using icons {rt1} or {rt2} or {rt3} to find your line easier if you have to soak."

	--L.custom_on_repeating_impale = "Repeating Impale Say"
	--L.custom_on_repeating_impale_desc = "Repeating say messages for the Impale ability using '1' or '22' or '333' or '4444' to make it clear in what order you will be hit."

	-- L.hymn_stacks = "Nathrian Hymn"
	-- L.hymn_stacks_desc = "Alerts for the amount of Nathrian Hymn stacks currently on you."

	-- L.ravage_target = "Reflection: Ravage Target Cast Bar"
	-- L.ravage_target_desc = "Cast bar showing the time until the reflection targets a location for Ravage."
	-- L.ravage_targeted = "Ravage Targeted" -- Text on the bar for when Ravage picks its location to target in stage 3

	-- L.no_mirror = "No Mirror: %d" -- Player amount that does not have the Through the Mirror
	-- L.mirror = "Mirror: %d" -- Player amount that does have the Through the Mirror
end
