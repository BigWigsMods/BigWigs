local L = BigWigs:NewBossLocale("Cenarius", "esES") or BigWigs:NewBossLocale("Cenarius", "esMX")
if not L then return end
if L then
	L.forces = "Fuerzas"
end

L = BigWigs:NewBossLocale("Elerethe Renferal", "esES") or BigWigs:NewBossLocale("Elerethe Renferal", "esMX")
if L then
	L.isLinkedWith = "%s está enlazado con %s"
	L.yourLink = "Estás enlazado con %s"
	L.yourLinkShort = "Enlazado con %s"
end

L = BigWigs:NewBossLocale("Il'gynoth", "esES") or BigWigs:NewBossLocale("Il'gynoth", "esMX")
if L then
	L.custom_off_deathglare_marker = "Deathglare Tentacle marker"
	L.custom_off_deathglare_marker_desc = "Mark Deathglare Tentacles with {rt6}{rt5}{rt4}{rt3}, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, having nameplates enabled or quickly mousing over the spears is the fastest way to mark them.|r"
end

L = BigWigs:NewBossLocale("Emerald Nightmare Trash", "esES") or BigWigs:NewBossLocale("Emerald Nightmare Trash", "esMX")
if L then
	L.gelatinizedDecay = "Gelatinized Decay" -- to translate
end

L = BigWigs:NewBossLocale("Ursoc", "esES") or BigWigs:NewBossLocale("Ursoc", "esMX")
if L then
	L.custom_off_gaze_assist = "Focused Gaze Assist"
	L.custom_off_gaze_assist_desc = "Show raid icons in bars and messages for Focused Gaze. Using {rt4} for odd, {rt6} for even soaks. Requires promoted or leader."
end

L = BigWigs:NewBossLocale("Xavius", "esES") or BigWigs:NewBossLocale("Xavius", "esMX")
if L then
	L.custom_off_blade_marker = "Nightmare Blade marker"
	L.custom_off_blade_marker_desc = "Mark the targets of Nightmare Blades with {rt1}{rt2}, requires promoted or leader."

	L.linked = "Bonds of Terror on YOU! - Linked with %s!"
end
