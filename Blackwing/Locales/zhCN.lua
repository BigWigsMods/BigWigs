
local L = BigWigs:NewBossLocale("Atramedes", "zhCN")
if not L then return end
if L then
	L.ground_phase = "Ground Phase"
	L.ground_phase_desc = "Warning for when Atramedes lands."
	L.air_phase = "Air Phase"
	L.air_phase_desc = "Warning for when Atramedes takes off."

	L.air_phase_trigger = "Yes, run! With every step your heart quickens. The beating, loud and thunderous... Almost deafening. You cannot escape!"

	L.sonicbreath_cooldown = "~Sonic Breath"
end

L = BigWigs:NewBossLocale("Chimaeron", "zhCN")
if L then
	L.bileotron_engage = "The Bile-O-Tron springs to life and begins to emit a foul smelling substance."

	L.next_system_failure = "Next System Failure"
	L.break_message = "%2$dx Break on %1$s"

	L.phase2_message = "即將 致命性階段！"

	L.warmup = "Warmup"
	L.warmup_desc = "Warmup timer"
end

L = BigWigs:NewBossLocale("Magmaw", "zhCN")
if L then
	-- heroic
	L.blazing = "Skeleton Adds"
	L.blazing_desc = "Summons Blazing Bone Construct"
	L.blazing_message = "即將 熾炎骸骨傀儡！"
	L.blazing_bar = "<下一熾炎骸骨傀儡>"

	L.phase2 = "第二階段"
	L.phase2_desc = "當第二階段時顯示距離檢查。"
	L.phase2_message = "第二階段！"
	L.phase2_yell = "Inconceivable! You may actually defeat my lava worm! Perhaps I can help... tip the scales."

	-- normal
	L.pillar_of_flame_cd = "<烈焰之柱>"

	L.slump = "Slump"
	L.slump_desc = "Magmaw slumps forward exposing itself."
	L.slump_bar = "<下一騎乘>"
	L.slump_message = "嘢，快騎上它！"
	L.slump_trigger = "%s往前撲倒，露出他的鉗子!"

	L.slump_trigger = "%s slumps forward, exposing his pincers!"

	L.expose_trigger = "head"
	L.expose_message = "Head Explosed!"

	L.spew_bar = "<下一熔岩噴灑>"
	L.spew_warning = "即將 熔岩噴灑！"
end

L = BigWigs:NewBossLocale("Maloriak", "zhCN")
if L then
	--heroic
	L.sludge = "黑暗淤泥"
	L.sludge_desc = "當你站在黑暗淤泥上面時發出警報。"
	L.sludge_message = ">你< 黑暗淤泥！"

	--normal
	L.final_phase = "Final Phase"
	L.final_phase_soon = "Final phase soon!"

	L.release_aberration_message = "%s adds left!"
	L.release_all = "%s adds released!"

	L.flashfreeze = "~Flash Freeze"
	L.next_blast = "<灼燒衝擊>"
	L.jets_bar = "Next Magma Jets"

	L.phase = "Phase"
	L.phase_desc = "Warning for Phase changes."
	L.next_phase = "Next Phase"
	L.green_phase_bar = "綠色階段"

	L.red_phase_trigger = "Mix and stir, apply heat..."
	L.red_phase_emote_trigger = "红色" --verify
	L.red_phase = "|cFFFF0000红色|r阶段！"
	L.blue_phase_trigger = "How well does the mortal shell handle extreme temperature change? Must find out! For science!"
	L.blue_phase_emote_trigger = "蓝色" --verify
	L.blue_phase = "|cFF809FFE蓝色|r阶段！"
	L.green_phase_trigger = "This one's a little unstable, but what's progress without failure?"
	L.green_phase_emote_trigger = "绿色" --verify
	L.green_phase = "|cFF33FF00绿色|r阶段！"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
	L.dark_phase_emote_trigger = "黑色" --verify
	L.dark_phase = "|cFF660099黑色|r阶段！"
end

L = BigWigs:NewBossLocale("Nefarian", "zhCN")
if L then
	L.phase = "Phases"
	L.phase_desc = "Warnings for the Phase changes."

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.phase_three_trigger = "I have tried to be an accommodating host"

	L.crackle_trigger = "The air crackles with electricity!"
	L.crackle_message = "Electrocute soon!"

	L.shadowblaze_message = "暗影炎！"

	L.onyxia_power_message = "Explosion soon!"

	L.cinder_say = "Explosive Cinders on ME!"

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "zhCN")
if L then
	L.nef = "维克多·奈法里奥斯"
	L.nef_desc = "当维克多·奈法里奥斯施放技能时发出警报。"

	L.pool = "Pool Explosion"

	L.switch = "转换"
	L.switch_desc = "当转换时发出警报。"
	L.switch_message = "%s %s"

	L.next_switch = "<下一转换>"

	-- not using these but lets not just remove them yet who knows what will 4.0.6 break
	--L.nef_trigger1 = "Were you planning on using Toxitron's chemicals to damage the other constructs? Clever plan, let me ruin that for you."
	--L.nef_trigger2 = "Stupid Dwarves and your fascination with runes! Why would you create something that would help your enemy?"

	L.nef_next = "~Next ability buff"

	L.acquiring_target = "Acquiring Target"

	L.bomb_message = "Ooze chasing YOU!"
	L.cloud_message = "Cloud on YOU!"
	L.protocol_message = "Poison Bombs!"

	L.iconomnotron = "Icon on active boss"
	L.iconomnotron_desc = "Place the primary raid icon on the active boss (requires promoted or leader)."
end

