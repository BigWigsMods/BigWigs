local L = BigWigs:NewBossLocale("Atramedes", "zhTW")
if L then
	L.tracking_me = ">我< 追蹤！"

	L.shield = "古代矮人盾牌"
	L.shield_desc = "當古代矮人盾牌剩餘時發出警報。"
	L.shield_message = "%d古代矮人盾牌 剩餘！"

	L.ground_phase = "地面階段"
	L.ground_phase_desc = "當亞特拉米德著陸時發出警報。"
	L.air_phase = "空中階段"
	L.air_phase_desc = "當亞特拉米德起飛時發出警報。"

	L.air_phase_trigger = "沒錯，逃吧!每一步都會讓你的心跳加速。跳得轟隆作響...震耳欲聾。你逃不掉的!"

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
	L.blazing = "Skeleton Ads"
	L.blazing_desc = "當召喚Blazing Bone Construct時發出警報。"

	L.slump = "跌落"
	L.slump_desc = "當跌落並暴露時發出警報。"

	L.slump_trigger = "%s往前撲倒，露出他的鉗子!"

	L.expose_trigger = "頭"
	L.expose_message = "Head Explosed!"
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

	L.red_phase_trigger = "紅色" --verify
	L.red_phase = "|cFFFF0000紅色|r階段！"
	L.blue_phase_trigger = "藍色" --verify
	L.blue_phase = "|cFF809FFE藍色|r階段！"
	L.green_phase_trigger = "綠色" --verify
	L.green_phase = "|cFF33FF00綠色|r階段！"
	L.dark_phase_trigger = "黑色" --verify
	L.dark_phase = "|cFF660099黑色|r階段！"
end

L = BigWigs:NewBossLocale("Nefarian", "zhTW")
if L then
	L.phase = "階段"
	L.phase_desc = "當進入不同階段時發出警報。"

	L.phase_two_trigger = "詛咒你們，凡人!如此冷酷地漠視他人的所有物必須受到嚴厲的懲罰!"

	L.phase_three_trigger = "I have tried to be an accommodating host, but you simply will not die! Time to throw all pretense aside and just... KILL YOU ALL!"

	L.crackle_trigger = "The air crackles with electricity!"
	L.crackle_message = "Electrocute soon!"

	L.onyxia_power_message = "Explosion soon!"

	L.cinder_say = "Explosive Cinders on ME!"

	L.chromatic_prototype = "炫彩原型體" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "zhTW")
if L then
	L.nef = "維克多·奈法利斯領主"
	L.nef_desc = "當維克多·奈法利斯領主施放技能時發出警報。"
	L.switch = "轉換"
	L.switch_desc = "當轉換時發出警報。"
	L.switch_message = "%s %s"

	L.next_switch = "<下一轉換>"

	L.nef_trigger1 = "Were you planning on using Toxitron's chemicals to damage the other constructs? Clever plan, let me ruin that for you."
	L.nef_trigger2 = "Stupid Dwarves and your fascination with runes! Why would you create something that would help your enemy?"

	L.nef_next = "~Next ability buff"

	L.acquiring_target = "鎖定目標"

	L.cloud_message = ">你< 化學毒霧！"
	L.protocol_message = "Poison Bombs!"

	L.iconomnotron = "Icon on active boss"
	L.iconomnotron_desc = "Place the primary raid icon on the active boss (requires promoted or leader)."
end

