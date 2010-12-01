local L = BigWigs:NewBossLocale("Atramedes", "zhTW")
if L then
	L.ancientDwarvenShield = "Ancient Dwarven Shield"
	L.ancientDwarvenShield_desc = "Warning for the remaining Ancient Dwarven Shields"
	L.ancientDwarvenShieldLeft = "%d Ancient Dwarven Shield left"

	L.ground_phase = "地面階段"
	L.ground_phase_desc = "Warning for when Atramedes lands."
	L.air_phase = "空中階段"
	L.air_phase_desc = "Warning for when Atramedes takes off."

	L.air_phase_trigger = "Yes, run! With every step your heart quickens. The beating, loud and thunderous... Almost deafening. You cannot escape!"

	L.sonicbreath_cooldown = "~Sonic Breath"
end

L = BigWigs:NewBossLocale("Chimaeron", "zhTW")
if L then
	L.bileotron_engage = "The Bile-O-Tron springs to life and begins to emit a foul smelling substance."

	L.next_system_failure = "Next System Failure"
	L.break_message = "%2$dx Break on %1$s"

	L.warmup = "Warmup"
	L.warmup_desc = "Warmup timer"
end

L = BigWigs:NewBossLocale("Magmaw", "zhTW")
if L then
	L.inferno = (GetSpellInfo(92191))
	L.inferno_desc = "Summons Blazing Bone Construct"

	L.slump = "Slump"
	L.slump_desc = "Slumps forward exposing itself"

	L.slump_trigger = "%s slumps forward, exposing his pincers!"
end

L = BigWigs:NewBossLocale("Maloriak", "zhTW")
if L then
	--heroic
	L.darkSludge = (GetSpellInfo(92987))
	L.darkSludge_desc = ("Warning for when you stand in %s"):format((GetSpellInfo(92987)))

	--normal
	L.final_phase = "最終階段"

	L.release_aberration_message = "%s Aberration left"
	L.release_all = "%s Aberration Released"

	L.bitingchill_say = "Biting Chill on ME!"

	L.flashfreeze = "~Flash Freeze"

	L.phase = "階段"
	L.phase_desc = "階段轉換時發出警報。"
	L.next_phase = "下一階段"

	L.red_phase_trigger = "Mix and stir, apply heat..."
	L.red_phase = "|cFFFF0000Red|r phase"
	L.blue_phase_trigger = "How well does the mortal shell handle extreme temperature change? Must find out! For science!"
	L.blue_phase = "|cFF809FFEBlue|r phase"
	L.green_phase_trigger = "This one's a little unstable, but what's progress without failure?"
	L.green_phase = "|cFF33FF00Green|r phase"
	L.dark_phase = "|cFF660099Dark|r phase"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
end

L = BigWigs:NewBossLocale("Nefarian", "zhTW")
if L then
	L.phase = "階段"
	L.phase_desc = "階段轉換時發出警報。"

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnitron Defense System", "zhTW")
if L then
	L.acquiring_target = "Acquiring Target"

	L.cloud_message = "Cloud on YOU!"
end
