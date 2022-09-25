local L = BigWigs:NewBossLocale("High Warlord Naj'entus", "zhCN")
if not L then return end
if L then
	L.start_trigger = "以瓦丝琪女王的名义，去死吧！"
end

L = BigWigs:NewBossLocale("Supremus", "zhCN")
if L then
	L.normal_phase_trigger = "苏普雷姆斯愤怒地击打着地面！"
	L.kite_phase_trigger = "地面崩裂了！"
	L.normal_phase = "一般阶段"
	L.kite_phase = "风筝阶段"
	L.next_phase = "下一阶段"
end

L = BigWigs:NewBossLocale("Shade of Akama", "zhCN")
if L then
	L.wipe_trigger = "不！我不能死！"
	L.defender = "防御者" -- Ashtongue Defender
	L.sorcerer = "巫师" -- Ashtongue Sorcerer
	L.adds_right = "增援（右侧）"
	L.adds_left = "增援（左侧）"

	L.engaged = "阿卡玛之影激活"
end

L = BigWigs:NewBossLocale("Reliquary of Souls", "zhCN")
if L then
	L.zero_mana = "零法力"
	L.zero_mana_desc = "当欲望精华将减少所有人法力值为零时显示计时器。"
	L.desire_start = "欲望精华！160秒后零法力。"
end

L = BigWigs:NewBossLocale("The Illidari Council", "zhCN")
if L then
	L.veras = "维尔莱斯：%s"
	L.malande = "玛兰德：%s"
	L.gathios = "加西奥斯：%s"
	L.zerevor = "塞勒沃尔：%s"

	L.circle_heal_message = "治疗成功！约20秒后，再次发动。"
	L.circle_fail_message = "%s 打断！约12秒后，再次发动治疗之环。"

	L.magical_immunity = "魔法免疫！"
	L.physical_immunity = "物理免疫！"
end

L = BigWigs:NewBossLocale("Illidan Stormrage", "zhCN")
if L then
	L.barrage_bar = "黑暗壁垒"
	L.warmup_trigger = "阿卡玛。你的两面三刀并没有让我感到意外。我早就应该把你和你那些畸形的同胞全部杀掉。"
end
