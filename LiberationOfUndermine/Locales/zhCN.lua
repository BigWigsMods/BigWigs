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
	L.rolled_over_by = "被 %s 碾过" -- Rolled over by PlayerX
	L.landing = "降落" -- Landing down from the sky

	L.electromagnetic_sorting = "电磁分拣" --中文技能名称短，就不简写了
	L.incinerator = "火圈"
end

L = BigWigs:NewBossLocale("Sprocketmonger Lockenstock", "zhCN")
if L then
	L.foot_blasters = "地雷"
	L.screw_up = "钻头"
	L.sonic_ba_boom = "团队伤害"
	L.polarization_generator = "正负极"
end

L = BigWigs:NewBossLocale("The One-Armed Bandit", "zhCN")
if L then
	L.rewards = "豪华大奖" -- Fabulous Prizes
	L.rewards_desc = "当2种礼卷被组合后，将发放\"豪华大奖\"。\n信息会提醒你获得了哪种奖励。\n信息框也会显示哪些奖励任然可用。"
	--L.rewards_icon = "inv_111_vendingmachine_blackwater"
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
