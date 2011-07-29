local L = BigWigs:NewBossLocale("Beth'tilac", "zhCN")
if not L then return end
if L then
	L.devastate_message = "Devastation #%d!"
	L.devastate_bar = "<下一Devastation>"
	L.drone_bar = "Next Cinderweb Drone"
	L.drone_message = "Big drone incoming!"
	L.kiss_message = "Kiss"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "zhCN")
if L then
	L.molten_message = "%dx stacks on boss!"
	L.armor_message = "%d%% armor left"
	L.armor_gone_message = "Armor go bye-bye!"
	L.phase2_soon_message = "Phase 2 soon!"
	L.stomp_message = "Stomp! Stomp! Stomp!"
	L.stomp_warning = "Next Stomp"
	L.big_add_message = "Big add spawned!"
	L.small_adds_message = "Small adds inc!"
end

L = BigWigs:NewBossLocale("Alysrazor", "zhCN")
if L then
	L.tornado_trigger = "These skies are MINE!"
	L.claw_message = "%2$dx Claw on %1$s"
	L.fullpower_soon_message = "Full power soon!"
	L.halfpower_soon_message = "Phase 4 soon!"
	L.encounter_restart = "完全的力量"
	L.no_stacks_message = "你沒有羽毛！"
	L.moonkin_message = "去拿一些羽毛！"

	L.stage_message = "Stage：>%d<！"

	L.worm_emote = "Fiery Lava Worms erupt from the ground!"
	L.phase2_soon_emote = "Alysrazor begins to fly in a rapid circle!"
end

L = BigWigs:NewBossLocale("Shannox", "zhCN")
if L then
	L.safe = "%s safe"
	L.immolation_trap = "Immolation on %s!"
	L.crystaltrap = "水晶囚牢陷阱！"
end

L = BigWigs:NewBossLocale("Baleroc", "zhCN")
if L then
	L.torment = "Torment stacks on Focus"
	L.torment_desc = "Warn when your /focus gains another torment stack."
	L.torment_message = "%2$dx torment on %1$s"

	L.blade_bar = "~Next Blade"
	L.shard_message = "Purple shards (%d)!"
	L.focus_message = "Your focus has %d stacks!"
	L.countdown_bar = "Next link"
	L.link_message = "Linked"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "zhCN")
if L then
	L.seed_explosion = "Seed explosion soon!"
	L.seed_bar = "<你：灼熱種子爆炸>"
	L.adrenaline_message = "Adrenaline x%d!"
end

L = BigWigs:NewBossLocale("Ragnaros", "zhCN")
if L then
	L.seed_explosion = "Seed Explosion!"
	L.intermission_bar = "<中場>"
	L.intermission_message = "Intermission... Got cookies?"
	L.sons_left = "%d Sons Left"
	L.engulfing_close = "Close quarters Engulfed!"
	L.engulfing_middle = "Middle section Engulfed!"
	L.engulfing_far = "Far side Engulfed!"
	L.hand_bar = "Next knockback"
	L.wound_bar = "Wound：>%s<！"
	L.ragnaros_back_message = "Raggy is back, party on!"
end

