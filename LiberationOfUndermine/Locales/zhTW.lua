local L = BigWigs:NewBossLocale("Vexie and the Geargrinders", "zhTW")
if not L then return end
if L then
	L.plating_removed = "剩餘 %d 層防身板金"
	L.exhaust_fumes = "煙霧" --排出煙霧
end

L = BigWigs:NewBossLocale("Cauldron of Carnage", "zhTW")
if L then
	L.custom_on_fade_out_bars = "淡出計時器"
	L.custom_on_fade_out_bars_desc = "淡出顯示超出距離的首領計時條。"

	L.bomb_explosion = "炸彈爆炸"
	L.bomb_explosion_desc = "替炸彈爆炸顯示倒數計時。"
end

L = BigWigs:NewBossLocale("Rik Reverb", "zhTW")
if L then
	L.amplification = "增幅器"
	L.echoing_chant = "回音" -- 回音之頌
	L.faulty_zap = "電擊"
	L.sparkblast_ignition = "火花" -- 火花衝擊
end

L = BigWigs:NewBossLocale("Stix Bunkjunker", "zhTW")
if L then
	L.ball_size_medium = "中球！"
	L.ball_size_large = "大球！"
	L.rolled_on_you = "%s 碾了你" -- PlayerX rolled over you
	L.rolled_from_you = "你碾了 %s" -- (you) Rolled over PlayerX
	L.garbage_dump_message = "你對首領造成了 %s 點傷害" -- 視百分比或數值再調整

	L.electromagnetic_sorting = "電磁" -- Short for Electromagnetic Sorting
	L.muffled_doomsplosion = "悶響爆炸" -- 悶響末日爆炸 暫定
	L.incinerator = "火圈" -- 火圈/焚化/燒垃圾
	L.landing = "降落" -- Landing down from the sky
end

L = BigWigs:NewBossLocale("Sprocketmonger Lockenstock", "zhTW")
if L then
	L.foot_blasters = "地雷"
	L.screw_up = "鑽頭"
	L.sonic_ba_boom = "音波" --音速轟爆
	L.polarization_generator = "極性切換" -- 顏色切換/正負極?

	L.polarization_soon = "極性改變：%s"

	L.activate_inventions = "啟動：%s"
	L.blazing_beam = "光束" --熾炎光束
	L.rocket_barrage = "火箭" --火箭彈幕
	L.mega_magnetize = "磁鐵" --超能磁化
	L.jumbo_void_beam = "虛無光束" --就不改了
	--L.void_barrage = "Balls" --虛無彈幕
end

L = BigWigs:NewBossLocale("The One-Armed Bandit", "zhTW")
if L then
	L.rewards = "酷炫獎勵" -- Fabulous Prizes
	L.rewards_desc = "投入二枚代幣後會立即發放「酷炫獎勵」，訊息將會顯示你獲得的獎勵，訊息盒則顯示你尚未領取過的獎勵。"
	L.deposit_time = "投幣時限" -- Timer that indicates how long you have left to deposit the tokens.

	L.pay_line = "錢幣" -- 籌碼？滾錢幣
	L.shock = "電擊"
	L.flame = "烈焰"
	L.coin = "硬幣" -- 應該是獎勵的硬幣
end

L = BigWigs:NewBossLocale("Mug'Zee, Heads of Security", "zhTW")
if L then
	L.earthshaker_gaol = "土牢"
	L.frostshatter_boots = "冰靴" -- Short for Frostshatter Boots 或者乾脆叫「腳滑」吧
	L.frostshatter_spear = "冰矛" -- Short for Frostshatter Spears
	L.stormfury_finger_gun = "手指槍" -- Short for Stormfury Finger Gun 指槍/閃電/射線
	L.molten_gold_knuckles = "坦克擊飛"
	L.unstable_crawler_mines = "地雷"
	L.goblin_guided_rocket = "火箭" --或分攤
	L.double_whammy_shot = "坦克擋線" --雙惡射擊
	L.electro_shocker = "震擊者"
end

L = BigWigs:NewBossLocale("Chrome King Gallywix", "zhTW")
if L then
	L.scatterblast_canisters = "碎爆分攤" --碎爆罐
	--L.fused_canisters = "Group Soaks"
	--L.tick_tock_canisters = "Soaks"

	L.duds = "爆彈" -- Short for 1500-Pound "Dud" dud是啞彈但手冊是爆彈
	L.all_duds_detontated = "爆彈已全部引爆！"
	--L.duds_remaining = "%d |4Dud remains:Duds remaining;" -- 1 Dud Remains | 2 Duds Remaining
	--L.duds_soak = "Soak Duds (%d left)"
end
