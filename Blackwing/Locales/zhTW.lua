local L = BigWigs:NewBossLocale("Atramedes", "zhTW")
if L then
	L.tracking_me = ">我< 追蹤！"

	L.shield = "Ancient Dwarven Shield"
	L.shield_desc = "當Ancient Dwarven Shields剩餘時發出警報。"
	L.shield_message = "%d Ancient Dwarven Shield 剩餘！"

	L.ground_phase = "地面階段"
	L.ground_phase_desc = "當亞特拉米德著陸時發出警報。"
	L.air_phase = "空中階段"
	L.air_phase_desc = "當亞特拉米德起飛時發出警報。"

	L.air_phase_trigger = "Yes, run! With every step your heart quickens. The beating, loud and thunderous... Almost deafening. You cannot escape!"

	L.sonicbreath_cooldown = "<音之息>"
end

L = BigWigs:NewBossLocale("Chimaeron", "zhTW")
if L then
	L.bileotron_engage = "The Bile-O-Tron springs to life and begins to emit a foul smelling substance."

	L.next_system_failure = "<下一系統失效>"
	L.break_message = "%2$dx破壞>%1$s<！"

	L.warmup = "暖身"
	L.warmup_desc = "暖身計時器。"
end

L = BigWigs:NewBossLocale("Magmaw", "zhTW")
if L then
	L.inferno = (GetSpellInfo(92191))
	L.inferno_desc = "當召喚Blazing Bone Construct時發出警報。"

	L.slump = "跌落"
	L.slump_desc = "當跌落並暴露時發出警報。"

	L.slump_trigger = "%s slumps forward, exposing his pincers!"
end

L = BigWigs:NewBossLocale("Maloriak", "zhTW")
if L then
	--heroic
	L.darkSludge = (GetSpellInfo(92987))
	L.darkSludge_desc = ("當你站在%s上面時發出警報。"):format((GetSpellInfo(92987)))

	--normal
	L.final_phase = "最終階段"

	L.release_aberration_message = ">%s<畸形者剩餘！"
	L.release_all = ">%s<釋放畸形者！"

	L.bitingchill_say = ">我< 刺骨之寒！"

	L.flashfreeze = "<閃霜>"

	L.phase = "階段"
	L.phase_desc = "當進入不同階段時發出警報。"
	L.next_phase = "下一階段！"
	
	L.you = ">你< %s！"

	L.red_phase_trigger = "Mix and stir, apply heat..."
	L.red_phase = "|cFFFF0000紅色|r階段！"
	L.blue_phase_trigger = "How well does the mortal shell handle extreme temperature change? Must find out! For science!"
	L.blue_phase = "|cFF809FFE藍色|r階段！"
	L.green_phase_trigger = "This one's a little unstable, but what's progress without failure?"
	L.green_phase = "|cFF33FF00綠色|r階段！"
	L.dark_phase = "|cFF660099黑色|r階段！"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
end

L = BigWigs:NewBossLocale("Nefarian", "zhTW")
if L then
	L.phase = "階段"
	L.phase_desc = "當進入不同階段時發出警報。"

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnitron Defense System", "zhTW")
if L then
	L.switch = "轉換"
	L.switch_desc = "當轉換時發出警報。"
	
	L.next_switch = "<下一轉換>"

	L.acquiring_target = "鎖定目標"

	L.cloud_message = ">你< 化學毒霧！"
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "zhTW")
if L then
	L.switch = "轉換"
	L.switch_desc = "當轉換時發出警報。"
	
	L.next_switch = "<下一轉換>"

	L.acquiring_target = "鎖定目標"

	L.cloud_message = ">你< 化學毒霧！"
end