local L = BigWigs:NewBossLocale("Cauldron of Carnage", "zhCN")
if not L then return end
if L then
	L.custom_on_fade_out_bars = "淡出计时器"
	L.custom_on_fade_out_bars_desc = "当首领超出范围时，淡出其相关技能的计时器。"

	L.bomb_explosion = "炸弹爆炸"
	L.bomb_explosion_desc = "显示炸弹爆炸的倒计时。"

	L.eruption_stomp = "重踏" -- 喷发重踏
	L.thunderdrum_salvo = "齐射" -- 雷鼓齐射

	L.static_charge_high = "%d - 你移动得太频繁"
end

L = BigWigs:NewBossLocale("Rik Reverb", "zhCN")
if L then
	L.amplification = "增幅器"
	L.echoing_chant = "音波"
	L.faulty_zap = "电击"
	L.sparkblast_ignition = "烟火桶"
end

L = BigWigs:NewBossLocale("Stix Bunkjunker", "zhCN")
if L then
	L.rolled_on_you = "%s 碾过你" -- PlayerX rolled over you
	L.rolled_from_you = "你碾过 %s" -- (you) Rolled over PlayerX
	L.garbage_dump_message = "你对首领造成了 %s 伤害"

	L.electromagnetic_sorting = "电磁分拣" -- 中文技能名称短，就不简写了
	L.muffled_doomsplosion = "炸弹爆炸" -- 闷声毁灭爆炸
	L.short_fuse = "爆壳蟹爆炸" -- 超短引线
	L.incinerator = "火圈"
end

L = BigWigs:NewBossLocale("Sprocketmonger Lockenstock", "zhCN")
if L then
	L.foot_blasters = "地雷"
	L.unstable_shrapnel = "地雷爆炸"
	L.screw_up = "钻头"
	L.screw_up_single = "钻头" -- Singular of Drills
	L.sonic_ba_boom = "声波爆轰"
	L.polarization_generator = "极性转化"

	L.polarization_soon = "极性改变：%s"
	L.polarization_soon_change = "极性即将改变：%s"

	L.activate_inventions = "激活：%s"  --激活发明！
	L.blazing_beam = "光束" -- 炙热光束
	L.rocket_barrage = "火箭" -- 火箭弹幕
	L.mega_magnetize = "磁吸" -- 超级磁吸
	L.jumbo_void_beam = "虚空光束" -- 大号虚空光束
	L.void_barrage = "黑球" -- 虚空弹幕
	L.everything = "组合技" -- 光束+火箭+磁吸等组合技能

	L.under_you_comment = "在你脚下" -- Implies this setting is for the damage from the ground effect under you
end

L = BigWigs:NewBossLocale("The One-Armed Bandit", "zhCN")
if L then
	L.rewards = "豪华大奖" -- Fabulous Prizes
	L.rewards_desc = "当2种礼卷被组合后，将发放\"豪华大奖\"。\n信息会提醒你获得了哪种奖励。\n信息框也会显示哪些奖励任然可用。"
	L.deposit_time = "投卷计时：" -- Timer that indicates how long you have left to deposit the tokens.

	L.pay_line = "凭证"
	L.shock = "震击"
	L.flame = "烈焰"
	L.coin = "硬币"

	L.withering_flames = "烈焰" -- Short for Withering Flames

	L.cheat = "激活：%s" -- Cheat: Coils, Cheat: Debuffs, Cheat: Raid Damage, Cheat: Final Cast
	L.linked_machines = "线圈"
	L.linked_machine = "线圈" -- Singular of Coils
	L.hot_hot_heat = "烈焰减益"
	L.explosive_jackpot = "爆破大奖"
end

L = BigWigs:NewBossLocale("Mug'Zee, Heads of Security", "zhCN")
if L then
	L.earthshaker_gaol = "牢狱"
	L.frostshatter_boots = "冰靴" -- “霜裂冰靴”简写
	L.frostshatter_spear = "长矛" -- “霜裂长矛”简写
	L.stormfury_finger_gun = "手指枪" -- “风暴手指枪”简写
	L.molten_gold_knuckles = "真金指虎" -- “熔火真金指虎”
	L.unstable_crawler_mines = "地雷"
	L.goblin_guided_rocket = "火箭"
	L.double_whammy_shot = "双厄射击"
	L.electro_shocker = "振荡器" -- Mk II型电击振荡器
end

L = BigWigs:NewBossLocale("Chrome King Gallywix", "zhCN")
if L then
	L.story_phase_trigger = "怎么，自以为胜利了？" -- 怎么，自以为胜利了？呵，我给你准备了惊喜。

	L.scatterblast_canisters = "弹药筒分摊" -- 因为“裂破弹药筒”和“散射弹药筒”使用相同本地化，改成“弹药筒”
	L.fused_canisters = "引线分摊" -- 使用技能名“引线弹药筒”前2字做提醒
	L.tick_tock_canisters = "分摊"
	L.total_destruction = "毁灭！" -- 毁灭一切！！！

	L.duds = "哑弹" -- Short for 1500-Pound "Dud"
	L.all_duds_detontated = "所有哑弹已引爆！"
	L.duds_remaining = "剩余：%d 个哑弹" -- 1 Dud Remains | 2 Duds Remaining
	L.duds_soak = "哑弹爆炸 （剩余：%d 个）"
end
