local L = BigWigs:NewBossLocale("Shriekwing", "zhCN")
if not L then return end
if L then
	L.pickup_lantern = "%s 捡起了灯笼！"
	L.dropped_lantern = "%s 丢掉了灯笼!"
end

L = BigWigs:NewBossLocale("Huntsman Altimor", "zhCN")
if L then
	L.killed = "%s 已击杀"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox", "zhCN")
if L then
	-- L.stage2_yell = "The anticipation to use this relic is killing me! Though, it will more likely kill you."
	-- L.stage3_yell = "I hope this wondrous item is as lethal as it looks!"
end

L = BigWigs:NewBossLocale("Lady Inerva Darkvein", "zhCN")
if L then
	L.times = "%d层 %s"

	L.level = "%s（等级 |cffffff00%d|r）"
	L.full = "%s（|cffff0000满|r）"

	L.custom_off_experimental = "启用实验性功能"
	L.custom_off_experimental_desc = "此功能|cffff0000未测试|r并可能|cffff0000刷屏|r。"

	L.anima_tracking = "心能追踪|cffff0000（实验性）|r"
	L.anima_tracking_desc = "追踪容器的心能等级的信息和计时条。|n|cffaaff00提示：可能要禁用信息盒或计时条，根据配置。"

	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "只是为了马上测试"

	L.bottles = "瓶子"
	L.sins = "罪孽"
end

L = BigWigs:NewBossLocale("The Council of Blood", "zhCN")
if L then
	-- L.macabre_start_emote = "Take your places for the Danse Macabre!" -- [RAID_BOSS_EMOTE] Take your places for the Danse Macabre!#Dance Controller#4#false"
	L.custom_on_repeating_dark_recital = "重复黑暗伴舞"
	L.custom_on_repeating_dark_recital_desc = "重复黑暗伴舞喊话信息使用 {rt1}，{rt2} 图标，和伙伴共舞。"
end

L = BigWigs:NewBossLocale("Stone Legion Generals", "zhCN")
if L then
	L.first_blade = "第一刀"
	L.second_blade = "第二刀"
end
