
local L = BigWigs:NewBossLocale("Atramedes", "deDE")
if not L then return end
if L then
	L.ground_phase = "Bodenphase"
	L.ground_phase_desc = "Warnt, wenn Atramedes landet."
	L.air_phase = "Luftphase"
	L.air_phase_desc = "Warnt, wenn Atramedes abhebt."

	L.air_phase_trigger = "Ja, lauft! Jeder Schritt lässt Euer Herz stärker klopfen. Laut und heftig... ohrenbetäubend. Es gibt kein Entkommen!" -- check

	L.sonicbreath_cooldown = "~Schallatem"
end

L = BigWigs:NewBossLocale("Chimaeron", "deDE")
if L then
	L.bileotron_engage = "Der Gall-O-Tron springt an und stößt eine übel riechende Substanz aus."
	--L.win_trigger = "A shame to lose that experiment..."

	L.next_system_failure = "~Systemversagen"
	L.break_message = "%2$dx Brechen auf %1$s"

	L.phase2_message = "Sterblichkeitsphase bald!"

	L.warmup = "Aufwärmen"
	L.warmup_desc = "Timer für die Aufwärmphase."
end

L = BigWigs:NewBossLocale("Magmaw", "deDE")
if L then
	-- heroic
	L.blazing = "Loderndes Knochenkonstrukt"
	L.blazing_desc = "Warnt vor dem Auftauchen der Lodernden Knochenkonstrukte."
	L.blazing_message = "Add kommt!"
	L.blazing_bar = "Nächstes Skelett"

	L.phase2 = "Phase 2"
	L.phase2_desc = "Warnt vor dem Übergang in Phase 2 und öffnet die Anzeige naher Spieler."
	L.phase2_message = "Phase 2!"
	--L.phase2_yell = "Inconceivable! You may actually defeat my lava worm! Perhaps I can help... tip the scales."

	-- normal
	L.pillar_of_flame_cd = "~Flammensäule"

	L.slump = "Nach vorne schlittern (Rodeo)"
	L.slump_desc = "Warnt vor dem nach vorne Schlittern, das das Rodeo erlaubt zu starten."
	L.slump_bar = "Nächstes Rodeo"
	L.slump_message = "Yeehaa, Rodeo!"
	L.slump_trigger = "%s schlittert nach vorne und entblößt seine Zangen!" -- check

	L.infection_message = "Infektion auf DIR!"

	L.expose_trigger = "Kopf" -- check
	L.expose_message = "Kopf freigelegt!"

	L.spew_bar = "~Lavafontäne"
	L.spew_warning = "Lavafontäne bald!"
end

L = BigWigs:NewBossLocale("Maloriak", "deDE")
if L then
	--heroic
	L.sludge = "Dunkler Schlick"
	L.sludge_desc = "Warnt, wenn du in Dunkler Schlick stehst."
	L.sludge_message = "Schlick auf DIR!"

	--normal
	L.final_phase = "Finale Phase"

	L.release_aberration_message = "%s Adds noch!"
	L.release_all = "%s Adds freigelassen!"

	L.flashfreeze = "~Blitzeis"
	L.next_blast = "~Sengende Explosion"
	L.jets_bar = "Next Magma Jets"

	L.phase = "Phasen"
	L.phase_desc = "Warnt vor Phasenwechsel."
	L.next_phase = "Nächste Phase"
	L.green_phase_bar = "Grüne Phase"

	L.red_phase_trigger = "Vermischen, rühren, erhitzen..."
	L.red_phase_emote_trigger = "rote"
	L.red_phase = "|cFFFF0000Rote|r Phase"
	L.blue_phase_trigger = "Muss rausfinden, wie die sterbliche Hülle auf extreme Temperaturen reagiert... FÜR DIE FORSCHUNG!"
	L.blue_phase_emote_trigger = "blaue"
	L.blue_phase = "|cFF809FFEBlaue|r Phase"
	L.green_phase_trigger = "Etwas instabil vielleicht, doch keine Forschung ohne Risiko!"
	L.green_phase_emote_trigger = "grüne"
	L.green_phase = "|cFF33FF00Grüne|r Phase"
	--L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
	L.dark_phase_emote_trigger = "dunkle" -- check
	L.dark_phase = "|cFF660099Dunkle|r Phase"
end

L = BigWigs:NewBossLocale("Nefarian", "deDE")
if L then
	L.phase = "Phasen"
	L.phase_desc = "Warnt vor Phasenwechsel."

	L.phase_two_trigger = "Verfluchte Sterbliche! Ein solcher Umgang mit dem Eigentum anderer verlangt nach Gewalt!" -- check

	L.phase_three_trigger = "Ich habe versucht, ein guter Gastgeber zu sein, aber ihr wollt einfach nicht sterben! Genug der Spielchen! Ich werde euch einfach... ALLE TÖTEN!" -- check

	L.crackle_trigger = "Elektrizität lässt die Luft knistern!" -- check
	L.crackle_message = "Stromschlag bald!"

	L.shadowblaze_message = "Feuer"

	L.onyxia_power_message = "Überladung bald!"

	L.chromatic_prototype = "Chromatischer Prototyp"
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "deDE")
if L then
	L.nef = "Lord Victor Nefarius"
	L.nef_desc = "Warnungen für Nefarians Fähigkeiten."

	L.pool = "Pool-Explosion"

	L.switch = "Wechsel"
	L.switch_desc = "Warnt vor dem Wechseln der Bosse."
	L.switch_message = "%s %s"

	L.next_switch = "Nächster Wechsel"

	-- not using these but lets not just remove them yet who knows what will 4.0.6 break
	--L.nef_trigger1 = "Were you planning on using Toxitron's chemicals to damage the other constructs? Clever plan, let me ruin that for you."
	--L.nef_trigger2 = "Stupid Dwarves and your fascination with runes! Why would you create something that would help your enemy?"

	L.nef_next = "~Fähigkeiten Buff"

	L.acquiring_target = "Zielerfassung"

	L.bomb_message = "Giftbombe verfolgt DICH!"
	L.cloud_message = "Wolke auf DIR!"
	L.protocol_message = "Giftbomben kommen!"

	L.iconomnotron = "Symbol auf aktivem Boss"
	L.iconomnotron_desc = "Plaziert das primäre Schlachtzugssymbol auf dem aktiven Boss (benötigt Assistent oder höher)."
end

