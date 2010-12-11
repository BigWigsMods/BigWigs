local L = BigWigs:NewBossLocale("Atramedes", "zhCN")
if L then
	L.tracking_me = "Tracking on ME!"

	L.shield = "Ancient Dwarven Shield"
	L.shield_desc = "Warning for the remaining Ancient Dwarven Shields."
	L.shield_message = "%d Ancient Dwarven Shield left"

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

	L.warmup = "Warmup"
	L.warmup_desc = "Warmup timer"
end

L = BigWigs:NewBossLocale("Magmaw", "zhCN")
if L then
	L.inferno = (GetSpellInfo(92191))
	L.inferno_desc = "Summons Blazing Bone Construct"

	L.slump = "Slump"
	L.slump_desc = "Slumps forward exposing itself"

	L.slump_trigger = "%s slumps forward, exposing his pincers!"
end

L = BigWigs:NewBossLocale("Maloriak", "zhCN")
if L then
	--heroic
	L.darkSludge = (GetSpellInfo(92987))
	L.darkSludge_desc = ("Warning for when you stand in %s."):format((GetSpellInfo(92987)))

	--normal
	L.final_phase = "Final Phase"

	L.release_aberration_message = "%s Aberration left"
	L.release_all = "%s Aberration Released"

	L.bitingchill_say = "Biting Chill on ME!"

	L.flashfreeze = "~Flash Freeze"

	L.phase = "Phase"
	L.phase_desc = "Warning for Phase changes."
	L.next_phase = "Next Phase"
	
	L.you = "%s on YOU!"

	L.red_phase_trigger = "Mix and stir, apply heat..."
	L.red_phase = "|cFFFF0000Red|r phase"
	L.blue_phase_trigger = "How well does the mortal shell handle extreme temperature change? Must find out! For science!"
	L.blue_phase = "|cFF809FFEBlue|r phase"
	L.green_phase_trigger = "This one's a little unstable, but what's progress without failure?"
	L.green_phase = "|cFF33FF00Green|r phase"
	L.dark_phase = "|cFF660099Dark|r phase"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
end

L = BigWigs:NewBossLocale("Nefarian", "zhCN")
if L then
	L.phase = "Phases"
	L.phase_desc = "Warnings for the Phase changes."

	L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnitron Defense System", "zhCN")
if L then
	L.switch = "Switch"
	L.switch_desc = "Warning for Switches"
	
	L.next_switch = "Next Switch"

	L.acquiring_target = "Acquiring Target"

	L.cloud_message = "Cloud on YOU!"
end
