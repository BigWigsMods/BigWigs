local L = BigWigs:NewBossLocale("Battle of Dazar'alor Trash", "frFR")
if not L then return end
if L then
	L.enforcer = "Massacreur éternel"
	L.punisher = "Punisseur rastari"
	L.vessel = "Engeance de Bwonsamdi"

	L.victim = "%s VOUS a poignardé avec %s!"
	L.witness = "%s a poignardé %s avec %s!"
end

L = BigWigs:NewBossLocale("Champion of the Light Horde", "frFR")
if L then
	--L.disorient_desc = "Bar for the |cff71d5ff[Blinding Faith]|r cast.\nThis is probably the bar you want to have the countdown on." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Champion of the Light Alliance", "frFR")
if L then
	--L.disorient_desc = "Bar for the |cff71d5ff[Blinding Faith]|r cast.\nThis is probably the bar you want to have the countdown on." -- Blinding Faith = 283650
end

L = BigWigs:NewBossLocale("Jadefire Masters Horde", "frFR")
if L then
	--L.custom_on_fixate_plates = "Stalking icon on Enemy Nameplate"
	--L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is stalking on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."

	--L.absorb = "Absorb"
	--L.absorb_text = "%s (|cff%s%.0f%%|r)"
	--L.cast = "Cast"
	--L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	L.interrupted_after = "%s interrompu par %s (%.1f secondes restantes)"
end

L = BigWigs:NewBossLocale("Jadefire Masters Alliance", "frFR")
if L then
	--L.custom_on_fixate_plates = "Stalking icon on Enemy Nameplate"
	--L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is stalking on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."

	--L.absorb = "Absorb"
	--L.absorb_text = "%s (|cff%s%.0f%%|r)"
	--L.cast = "Cast"
	--L.cast_text = "%.1fs (|cff%s%.0f%%|r)"

	--L.interrupted_after = "%s interrupted by %s (%.1f seconds remaining)"
end

L = BigWigs:NewBossLocale("Opulence", "frFR")
if L then
	L.room = "Salle (%d/8)"
	--L.no_jewel = "No Jewel:"
	--L.seconds = "%.1fs"

	--L.custom_on_fade_out_bars = "Fade out stage 1 bars"
	--L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the construct which isn't in your hall during stage 1."

	--L.custom_on_hand_timers = "The Hand of In'zashi"
	--L.custom_on_hand_timers_desc = "Show warnings and bars for The Hand of In'zashi's abilities."
	--L.hand_cast = "Hand: %s"

	--L.custom_on_bulwark_timers = "Yalat's Bulwark"
	--L.custom_on_bulwark_timers_desc = "Show warnings and bars for Yalat's Bulwark's abilities."
	--L.bulwark_cast = "Bulwark: %s"
end

L = BigWigs:NewBossLocale("Conclave of the Chosen", "frFR")
if L then
	--L.killed = "%s killed!"
	--L.count_of = "%s (%d/%d)"
end

L = BigWigs:NewBossLocale("High Tinker Mekkatorque", "frFR")
if L then
	--L.gigavolt_alt_text = "Bomb"

	--L.custom_off_sparkbot_marker = "Spark Bot Marker"
	--L.custom_off_sparkbot_marker_desc = "Mark Spark Bots with {rt4}{rt5}{rt6}{rt7}{rt8}."

	--L.custom_off_repeating_shrunk_say = "Repeating Shrunk Say" -- Shrunk = 284168
	--L.custom_off_repeating_shrunk_say_desc = "Spam Shrunk while you're |cff71d5ff[Shrunk]|r. Maybe they'll stop running you over."

	--L.custom_off_repeating_tampering_say = "Repeating Tampering Say" -- Tampering = 286105
	--L.custom_off_repeating_tampering_say_desc = "Spam your name while you're controlling a robot."
end

L = BigWigs:NewBossLocale("Stormwall Blockade", "frFR")
if L then
	--L.killed = "%s killed!"

	--L.custom_on_fade_out_bars = "Fade out stage 1 bars"
	--L.custom_on_fade_out_bars_desc = "Fade out bars which belong to the boss who isn't active on your boat in stage 1."
end

L = BigWigs:NewBossLocale("Lady Jaina Proudmoore", "frFR")
if L then
	L.starbord_ship_emote = "Un bateau de Kul Tiras se rapproche à tribord !"
	L.port_side_ship_emote = "Un bateau de Kul Tiras se rapproche à bâbord !"

	--L.starbord_txt = "Right Ship" -- starboard
	--L.port_side_txt = "Left Ship" -- port

	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Jaina randomizes which off-cooldown ability she uses next. When this option is enabled, the bars for those abilities will stay on your screen."

	--L.frozenblood_player = "%s (%d players)"

	--L.intermission_stage2 = "Stage 2 - %.1f sec"
end
