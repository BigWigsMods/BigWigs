
local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Onyxia", "deDE")
if L then
	L.deepbreath = "Tiefer Atem"
	L.deepbreath_desc = "Warnt, wenn Onyxia tief einatmet."

	L.phase1 = "Phase 1"
	L.phase1_desc = "Warnt, wenn Onyxia in Phase 1 eintritt."

	L.phase2 = "Phase 2"
	L.phase2_desc = "Warnt, wenn Onyxia abhebt und in Phase 2 eintritt."

	L.phase3 = "Phase 3"
	L.phase3_desc = "Warnt, wenn Onyxia landet und in Phase 3 eintritt."

	L.fear = "Furcht"
	L.fear_desc = "Warnt vor der AoE Furcht in Phase 3."

	--L.phase1_trigger = "How fortuitous"
	L.phase2_trigger = "^Diese sinnlose Anstrengung langweilt mich"
	L.phase3_trigger = "^Mir scheint, dass Ihr noch eine Lektion braucht"

	L.deepbreath_message = "Tiefer Atem!"
	L.phase1_message = "%s angegriffen - Phase 1!"
	L.phase2_message = "Phase 2 - Onyxia hebt ab!"
	L.phase3_message = "Phase 3 - Onyxia landet!"
	L.fear_message = "Furcht in 1.5 sek!"
end

