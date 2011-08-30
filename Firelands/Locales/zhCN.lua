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
	L.armor = "Obsidian Armor"
	L.armor_desc = "Warn when armor stacks are being removed from Rhyolith."
	L.armor_message = "%d%% armor left"
	L.armor_gone_message = "Armor go bye-bye!"

	L.adds_header = "Adds"
	L.big_add_message = "Big add spawned!"
	L.small_adds_message = "Small adds inc!"

	L.phase2_warning = "Phase 2 soon!"

	L.molten_message = "%dx stacks on boss!"

	L.stomp_message = "Stomp! Stomp! Stomp!"
	L.stomp_warning = "Next Stomp"
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
	L.molt_bar = "<下一脱毛>"
	L.cataclysm_bar = "<下一灾变>"

	L.stage_message = "阶段：>%d<！"
	L.kill_message = "It's now or never - Kill her!"
	L.engage_message = "Alysrazor engaged - Stage 2 in ~%d min"

	L.worm_emote = "Fiery Lava Worms erupt from the ground!"
	L.phase2_soon_emote = "Alysrazor begins to fly in a rapid circle!"

	L.flight = "飞行助手"
	L.flight_desc = "当你“火焰之翼”持续时显示计时条，使用超级醒目功能。"
end

L = BigWigs:NewBossLocale("Shannox", "zhCN")
if L then
	L.safe = ">%s< 安全！"
	L.immolation_trap = "献祭陷阱：>%s<！"
	L.crystal_trap = "水晶囚牢陷阱！"

	L.traps_header = "陷阱"
	L.immolation = "献祭陷阱"
	L.immolation_desc = "Alert when Rageface or Riplimb steps on an Immolation Trap."
	L.immolationyou = "Immolation Trap under You"
	L.immolationyou_desc = "Alert when an Immolation Trap is summoned under you."
	L.immolationyou_message = "Immolation Trap"
	L.crystal = "Crystal Trap"
	L.crystal_desc = "Warn whom Shannox casts a Crystal Trap under."
end

L = BigWigs:NewBossLocale("Baleroc", "zhCN")
if L then
	L.torment = "焦点Torment堆叠"
	L.torment_desc = "Warn when your /focus gains another torment stack."

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
	L.leap_say = "Leap on ME!"
end

L = BigWigs:NewBossLocale("Ragnaros", "zhCN")
if L then
	--L.intermission_end_trigger1 = "Sulfuras will be your end."
	--L.intermission_end_trigger2 = "Fall to your knees, mortals!  This ends now."
	--L.intermission_end_trigger3 = "Enough! I will finish this."
	--L.phase4_trigger = "Too soon..."
	L.seed_explosion = "Seed Explosion!"
	L.intermission_bar = "<中場>"
	L.intermission_message = "Intermission... Got cookies?"
	L.sons_left = "%d Sons Left"
	L.engulfing_close = "Close quarters Engulfed!"
	L.engulfing_middle = "Middle section Engulfed!"
	L.engulfing_far = "Far side Engulfed!"
	L.hand_bar = "Next knockback"
	L.ragnaros_back_message = "Raggy is back, party on!"

	L.wound = "Burning Wound"
	L.wound_desc = "Tank alert only. Count the stacks of burning wound and show a duration bar."
	L.wound_message = "%2$dx Wound on %1$s"
end

