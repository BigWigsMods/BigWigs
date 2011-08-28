local L = BigWigs:NewBossLocale("Beth'tilac", "zhTW")
if not L then return end
if L then
	L.devastate_message = "悶燒破壞：>#%d<！"
	L.devastate_bar = "<下一悶燒破壞>"
	L.drone_bar = "<下一燼網雄蛛>"
	L.drone_message = "即將 燼網雄蛛！"
	L.kiss_message = "寡婦之吻！"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "zhTW")
if L then
	L.armor = "黑曜石護甲"
	L.armor_desc = "當黑曜石護甲堆疊從萊爾利斯領主身上移除時發出警報。"
	L.armor_message = "%d%% 黑曜石護甲剩餘！"
	L.armor_gone_message = "黑曜石護甲消失！"

	L.adds_header = "增援"
	L.big_add_message = "萊爾利斯火花 出現！"
	L.small_adds_message = "即將 萊爾利斯碎片！"

	L.phase2_warning = "第二階段！"

	L.molten_message = "首領炎甲術堆疊：>%d<層！"

	L.stomp_message = "烈焰踐踏！"
	L.stomp_warning = "下一 烈焰踐踏！"
end

L = BigWigs:NewBossLocale("Alysrazor", "zhTW")
if L then
	L.tornado_trigger = "這片天空屬於我。"
	L.claw_message = "熾炎爪擊%2$d層：>%1$s<！"
	L.fullpower_soon_message = "即將 完全的力量！"
	L.halfpower_soon_message = "第四階段！"
	L.encounter_restart = "完全的力量"
	L.no_stacks_message = "你沒有羽毛！"
	L.moonkin_message = "去拿一些羽毛！"
	L.molt_bar = "<下一脫毛>"
	L.cataclysm_bar = "<下一災變>"

	L.stage_message = "階段：>%d<！"
	L.kill_message = "It's now or never - Kill her!"
	L.engage_message = "Alysrazor engaged - Stage 2 in ~%d min"

	L.worm_emote = "熾炎熔岩蟲從地上鑽了出來!"
	L.phase2_soon_emote = "艾里絲拉卓開始快速地在空中盤旋!"

	L.flight = "飛行助手"
	L.flight_desc = "當你“火焰之翼”持續時顯示計時條，使用超級醒目功能。"
end

L = BigWigs:NewBossLocale("Shannox", "zhTW")
if L then
	L.safe = ">%s< 安全！"
	L.immolation_trap = "獻祭陷阱：>%s<！"
	L.crystal_trap = "水晶囚牢陷阱！"

	L.traps_header = "陷阱"
	L.immolation = "獻祭陷阱"
	L.immolation_desc = "當怒面或裂軀階段獻祭陷阱時發出警報。"
	L.immolationyou = ">你<脚下 獻祭陷阱！"
	L.immolationyou_desc = "當你腳下獻祭陷阱被召喚時發出警報。"
	L.immolationyou_message = "獻祭陷阱"
	L.crystal = "投擲水晶"
	L.crystal_desc = "當夏諾克斯施放水晶囚牢陷阱時發出警報。"
end

L = BigWigs:NewBossLocale("Baleroc", "zhTW")
if L then
	L.torment = "焦點折磨堆疊"
	L.torment_desc = "當焦點受到折磨堆疊時發出警報。"

	L.blade_bar = "<虐殺之刃>"
	L.shard_message = "折磨碎片：>%d<！"
	L.focus_message = "焦點目標已有 >%d< 層折磨！"
	L.countdown_bar = "<下一魔法連結>"
	L.link_message = "魔法連結！"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "zhTW")
if L then
	L.seed_explosion = ">你< 即將灼熱種子爆炸！"
	L.seed_bar = "<你：灼熱種子爆炸>"
	L.adrenaline_message = "激奮腺素：>%d層<！"
	L.leap_say = "Leap on ME!"
end

L = BigWigs:NewBossLocale("Ragnaros", "zhTW")
if L then
	L.intermission_end_trigger1 = "薩弗拉斯將終結你。"
	L.intermission_end_trigger2 = "跪下吧，凡人們!一切都將結束。"
	L.intermission_end_trigger3 = "夠了!我將結束這一切。"
	L.phase4_trigger = "太快"
	L.seed_explosion = "熔岩晶粒爆炸！"
	L.intermission_bar = "<中場>"
	L.intermission_message = "中場！"
	L.sons_left = ">%d< 烈焰之子剩餘！"
	L.engulfing_close = "侵噬烈焰：>近場<！"
	L.engulfing_middle = "侵噬烈焰：>中場<！"
	L.engulfing_far = "侵噬烈焰：>遠場<！"
	L.hand_bar = "<下一拉格納羅斯之手>"
	L.ragnaros_back_message = "拉格納羅斯返回，集合！"

	L.wound = "燃燒傷口 "..INLINE_TANK_ICON
	L.wound_desc = "只對坦克警報。燃燒傷口堆疊計數並顯示持續計時條。"
	L.wound_message = "燃燒傷口%2$d層：>%1$s<！"
end

