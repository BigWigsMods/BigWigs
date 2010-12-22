local L = BigWigs:NewBossLocale("Atramedes", "deDE")
if L then
	L.tracking_me = "Absuchen auf MIR!"

	L.shield = "Uralter Zwergenschild" --check
	L.shield_desc = "Warnt, wieviele Uralte Zwergenschilde noch übrig sind."
	L.shield_message = "%d Schilde noch"

	L.ground_phase = "Bodenphase"
	L.ground_phase_desc = "Warnt, wenn Atramedes landet."
	L.air_phase = "Luftphase"
	L.air_phase_desc = "Warnt, wenn Atramedes abhebt."

	L.air_phase_trigger = "Ja, lauft! Jeder Schritt lässt Euer Herz stärker klopfen. Laut und heftig... ohrenbetäubend. Es gibt kein Entkommen!" --check

	L.sonicbreath_cooldown = "~Schallatem"
end

L = BigWigs:NewBossLocale("Chimaeron", "deDE")
if L then
	L.bileotron_engage = "Der Gall-O-Tron springt an und stößt eine übel riechende Substanz aus." -- check

	L.next_system_failure = "Nächstes Systemversagen"
	L.break_message = "%2$dx Brechen auf %1$s"

	L.warmup = "Aufwärmen"
	L.warmup_desc = "Timer für die Aufwärmphase."
end

L = BigWigs:NewBossLocale("Magmaw", "deDE")
if L then
	L.inferno = (GetSpellInfo(92191))
	L.inferno_desc = "Beschwört [Blazing Bone Construct]." -- need german name

	L.slump = "Nach vorne schlittern"
	L.slump_desc = "Magmaul schlittert nach vorne und entblößt seine Zangen."

	L.slump_trigger = "%s schlittert nach vorne und entblößt seine Zangen!" -- check
end

L = BigWigs:NewBossLocale("Maloriak", "deDE")
if L then
	--heroic
	L.darkSludge = (GetSpellInfo(92987))
	L.darkSludge_desc = ("Warnt, wenn du in %s stehst."):format((GetSpellInfo(92987)))

	--normal
	L.final_phase = "Letzte Phase"

	L.release_aberration_message = "%s Adds noch!"
	L.release_all = "%s Adds freigelassen!"

	L.bitingchill_say = "Beißende Kälte auf MIR!"

	L.flashfreeze = "~Blitzeis"

	L.phase = "Phasen"
	L.phase_desc = "Warnt vor Phasenwechsel."
	L.next_phase = "Nächste Phase"
	
	L.you = "%s auf DIR!"

	L.red_phase_trigger = "Vermischen, rühren, erhitzen..." -- check
	L.red_phase = "|cFFFF0000Rote|r Phase"
	L.blue_phase_trigger = "Muss rausfinden, wie die sterbliche Hülle auf extreme Temperaturen reagiert... FÜR DIE FORSCHUNG!" -- check
	L.blue_phase = "|cFF809FFEBlaue|r Phase"
	L.green_phase_trigger = "Etwas instabil vielleicht, aber keine Forschung ohne Risiko!" -- check
	L.green_phase = "|cFF33FF00Grüne|r Phase"
	L.dark_phase = "|cFF660099Dunkle|r Phase"
	--L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
end

L = BigWigs:NewBossLocale("Nefarian", "deDE")
if L then
	L.phase = "Phasen"
	L.phase_desc = "Warnt vor Phasenwechsel."

	--L.phase_two_trigger = "Curse you, mortals! Such a callous disregard for one's possessions must be met with extreme force!"

	--L.chromatic_prototype = "Chromatic Prototype" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "deDE")
if L then
	L.switch = "Wechsel"
	L.switch_desc = "Warnt vor dem Wechseln der Bosse."
	
	L.next_switch = "Nächster Wechsel"

	L.acquiring_target = "Zielerfassung"

	L.cloud_message = "Wolke auf DIR!"
end
