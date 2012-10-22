local L = BigWigs:NewBossLocale("The Stone Guard", "zhTW")
if not L then return end
if L then
	L.petrifications = "Petrification"
	L.petrifications_desc = "Warning for when bosses start petrification"

	L.overload = "Overload" -- maybe should use a spellId that says exactly "Overload"
	L.overload_desc = "Warning for all types of overloads."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "zhTW")
if L then
	L.engage_yell = "Tender your souls, mortals! These are the halls of the dead!"

	L.phase_lightning_trigger = "噢，偉大的靈魂!賜予我大地之力!"
	L.phase_flame_trigger = "噢，至高的神啊!藉由我來融化他們的血肉吧!"
	L.phase_arcane_trigger =  "噢，上古的賢者!賜予我祕法的智慧!"
	L.phase_shadow_trigger = "Great soul of champions past! Bear to me your shield!"

	L.phase_lightning = "Lightning phase!"
	L.phase_flame = "Flame phase!"
	L.phase_arcane = "Arcane phase!"
	L.phase_shadow = "(Heroic) Shadow phase!"

	L.shroud_message = "%2$s cast Shroud on %1$s"
	L.barrier_message = "Barrier UP!"

	-- Tanks
	L.tank = "Tank Alerts"
	L.tank_desc = "Tank alerts only. Count the stacks of Lightning Lash, Flaming Spear, Arcane Shock & Shadowburn (Heroic)."
	L.lash_message = "%2$dx Lash on %1$s"
	L.spear_message = "%2$dx Spear on %1$s"
	L.shock_message = "%2$dx Shock on %1$s"
	L.burn_message = "%2$dx Burn on %1$s"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "zhTW")
if L then
	L.engage_yell = "受死吧，你們!"

	L.totem = "Totem"
	L.frenzy = "Frenzy soon!"

	L.shadowy = "Shadowy Attack" -- Singular not plural
end

L = BigWigs:NewBossLocale("The Spirit Kings", "zhTW")
if L then
	L.shield_removed = "Shield removed! (%s)"
	L.casting_shields = "Casting shields"
	L.casting_shields_desc = "Warning for when shields are casted for all bosses"
end

L = BigWigs:NewBossLocale("Elegon", "zhTW")
if L then
	L.last_phase = "Last Phase"
	L.overcharged_total_annihilation = "You have (%d) %s, reset your debuff!"

	L.floor = "Floor Despawn"
	L.floor_desc = "Warnings for when the floor is about to despawn."
	L.floor_message = "The floor is falling!!"
end

L = BigWigs:NewBossLocale("Will of the Emperor", "zhTW")
if L then
	L.enable_zone = "無盡熔爐"

	L.energizing = "%s is energizing!"
	L.combo = "%s: combo in progress"

	L.heroic_start_trigger = "Destroying the pipes" -- Destroying the pipes leaks |cFFFF0000|Hspell:116779|h[Titan Gas]|h|r into the room!
	L.normal_start_trigger = "The machine hums" -- The machine hums to life!  Get to the lower level!

	L.rage_trigger = "The Emperor's Rage echoes through the hills."
	L.strength_trigger = "The Emperor's Strength appears in the alcoves!"
	L.courage_trigger = "The Emperor's Courage appears in the alcoves!"
	L.bosses_trigger = "Two titanic constructs appear in the large alcoves!"
	L.gas_trigger = "The Ancient Mogu Machine breaks down!"
	L.gas_overdrive_trigger = "The Ancient Mogu Machine goes into overdrive!"

	L.arc_desc = "|cFFFF0000This warning will only show for the boss you're targetting.|r " .. (select(2, EJ_GetSectionInfo(5673)))
end

