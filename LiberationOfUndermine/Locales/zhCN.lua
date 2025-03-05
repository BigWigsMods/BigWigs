local L = BigWigs:NewBossLocale("Vexie and the Geargrinders", "zhCN")
if not L then return end
if L then
	L.plating_removed = "剩余 %d 层防御护板"
	L.exhaust_fumes = "团队伤害"
end

L = BigWigs:NewBossLocale("Cauldron of Carnage", "zhCN")
if L then
	L.custom_on_fade_out_bars = "淡出计时器"
	L.custom_on_fade_out_bars_desc = "当首领超出范围时，淡出其相关的技能计时器。"

	L.bomb_explosion = "炸弹爆炸"
	L.bomb_explosion_desc = "显示炸弹爆炸的倒计时。"
end

L = BigWigs:NewBossLocale("Rik Reverb", "zhCN")
if L then
	L.amplification = "增幅器"
	L.echoing_chant = "音波"
	L.faulty_zap = "电击"
	L.sparkblast_ignition = "桶"
end

L = BigWigs:NewBossLocale("Stix Bunkjunker", "zhCN")
if L then
	L.ball_size_medium = "中型球！"
	L.ball_size_large = "大型球！"
	L.rolled_on_you = "%s 碾过你" -- PlayerX rolled over you
	L.rolled_from_you = "你碾过 %s" -- (you) Rolled over PlayerX
	L.garbage_dump_message = "你对首领造成了 %s 伤害"

	L.electromagnetic_sorting = "电磁分拣" --中文技能名称短，就不简写了
	L.muffled_doomsplosion = "炸弹吸收"
	L.incinerator = "火圈"
	L.landing = "降落" -- Landing down from the sky

end

L = BigWigs:NewBossLocale("Sprocketmonger Lockenstock", "zhCN")
if L then
	L.foot_blasters = "地雷"
	L.screw_up = "钻头"
	L.sonic_ba_boom = "团队伤害"
	L.polarization_generator = "正负极"

	L.polarization_soon = "极性改变: %s"

	--L.activate_inventions = "Activate: %s"
	--L.blazing_beam = "Beams"
	--L.rocket_barrage = "Rockets"
	--L.mega_magnetize = "Magnets"
	--L.jumbo_void_beam = "Big Beams"
	--L.void_barrage = "Balls"
end

L = BigWigs:NewBossLocale("The One-Armed Bandit", "zhCN")
if L then
	L.rewards = "豪华大奖" -- Fabulous Prizes
	L.rewards_desc = "当2种礼卷被组合后，将发放\"豪华大奖\"。\n信息会提醒你获得了哪种奖励。\n信息框也会显示哪些奖励任然可用。"
	L.deposit_time = "投卷计时" -- Timer that indicates how long you have left to deposit the tokens.

	L.pay_line = "凭证"
	L.shock = "震击"
	L.flame = "烈焰"
	L.coin = "硬币"
end

L = BigWigs:NewBossLocale("Mug'Zee, Heads of Security", "zhCN")
if L then
	L.earthshaker_gaol = "牢狱"
	L.frostshatter_boots = "冰靴" -- “霜裂冰靴”简写
	L.frostshatter_spear = "长矛" -- “霜裂长矛”简写
	L.stormfury_finger_gun = "手指枪" -- “风暴手指枪”简写
	L.molten_gold_knuckles = "坦克正面"
	L.unstable_crawler_mines = "地雷"
	L.goblin_guided_rocket = "火箭"
	L.double_whammy_shot = "坦克分摊"
end

L = BigWigs:NewBossLocale("Chrome King Gallywix", "zhCN")
if L then
	L.scatterblast_canisters = "裂破分摊" --使用技能名“裂破弹药筒”前2字做提醒
	L.fused_canisters = "引线分摊" --使用技能名“引线弹药筒”前2字做提醒
	L.tick_tock_canisters = "分摊"

	L.duds = "哑弹" -- Short for 1500-Pound "Dud"
	L.all_duds_detontated = "所有哑弹已引爆！"
	L.duds_remaining = "剩余：%d 个哑弹" -- 1 Dud Remains | 2 Duds Remaining
	L.duds_soak = "分摊哑弹 （剩余：%d 个）"
end
