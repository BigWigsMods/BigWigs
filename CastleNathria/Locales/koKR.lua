local L = BigWigs:NewBossLocale("Shriekwing", "koKR")
if not L then return end
if L then
	-- L.pickup_lantern = "%s picked up the lantern!"
	-- L.dropped_lantern = "Lantern dropped by %s!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "koKR")
if L then
	L.killed = "%s 죽음"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "koKR")
if L then
	L.stage2_yell = "이 유물을 써 보고 싶어서 숨이 멎을 뻔했답니다! 뭐, 당신네는 진짜로 멎겠지만."
	L.stage3_yell = "보기만큼 치명적인 물건이어야 할 텐데!"
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "koKR")
if L then
	-- L.times = "%dx %s"

	-- L.level = "%s (Level |cffffff00%d|r)"
	-- L.full = "%s (|cffff0000FULL|r)"

	-- L.custom_off_experimental = "Enable experimental features"
	-- L.custom_off_experimental_desc = "These features are |cffff0000not tested|r and could |cffff0000spam|r."

	-- L.anima_tracking = "Anima Tracking |cffff0000(Experimental)|r"
	-- L.anima_tracking_desc = "Messages and Bars to track anima levels in the containers.|n|cffaaff00Tip: You might want to disable the information box or bars, depending your preference."

	-- L.custom_on_stop_timers = "Always show ability bars"
	-- L.custom_on_stop_timers_desc = "Just for testing right now"

	-- L.desires = "Desires"
	-- L.bottles = "Bottles"
	-- L.sins = "Sins"
end

L = BigWigs:NewBossLocale("The Council of Blood", "koKR")
if L then
	L.macabre_start_emote = "죽음의 무도를 위해 자신의 위치에 서야 합니다!" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	-- L.custom_on_repeating_dark_recital = "Repeating Dark Recital"
	-- L.custom_on_repeating_dark_recital_desc = "Repeating Dark Recital say messages with icons {rt1}, {rt2} to find your partner while dancing."

	--L.dance_assist = "Dance Assist"
	--L.dance_assist_desc = "Show directional warnings for the dancing stage."
	L.dance_assist_up = "|T450907:0:0:0:0:64:64:4:60:4:60|t 앞으로 |T450907:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_right = "|T450908:0:0:0:0:64:64:4:60:4:60|t 오른쪽으로 |T450908:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_down = "|T450905:0:0:0:0:64:64:4:60:4:60|t 밑으로 |T450905:0:0:0:0:64:64:4:60:4:60|t"
	L.dance_assist_left = "|T450906:0:0:0:0:64:64:4:60:4:60|t 왼쪽으로 |T450906:0:0:0:0:64:64:4:60:4:60|t"
	-- These need to match the in-game boss yells
	L.dance_yell_up = "앞으로" -- Prance Forward!
	L.dance_yell_right = "오른쪽으로" -- Shimmy right!
	L.dance_yell_down = "밑으로" -- Boogie down!
	L.dance_yell_left = "왼쪽으로" -- Sashay left!
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "koKR")
if L then
	-- L.first_blade = "First Blade"
	-- L.second_blade = "Second Blade"
end

L = BigWigs:NewBossLocale("Sire Denathrius", "koKR")
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
