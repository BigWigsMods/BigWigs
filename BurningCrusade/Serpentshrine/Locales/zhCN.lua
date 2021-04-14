local L = BigWigs:NewBossLocale("Hydross the Unstable", "zhCN")
if not L then return end
if L then
	L.start_trigger = "我不能允许你们介入！"

	L.mark = "印记"
	L.mark_desc = "显示印记警报及计数。"

	L.stance = "形态改变"
	L.stance_desc = "当毒性改变时发出警报。"
	L.poison_stance = "毒形态！"
	L.water_stance = "水形态！"

	L.debuff_warn = "印记施放于 %s%%！"
end

L = BigWigs:NewBossLocale("Fathom-Lord Karathress", "zhCN")
if L then
	L.enrage_trigger = "卫兵！提高警惕！我们有客人来了……"

	L.totem = "溅火图腾"
	L.totem_desc = "当施放溅火图腾时发出警报。"
	L.totem_message1 = "泰达维斯：>溅火图腾<！"
	L.totem_message2 = "卡拉瑟雷斯：>溅火图腾<！"
	L.heal_message = "卡莉蒂丝 - 施放治疗！"

	L.priest = "深水卫士卡莉蒂丝"
end

L = BigWigs:NewBossLocale("Leotheras the Blind", "zhCN")
if L then
	L.enrage_trigger = "我的放逐终于结束了！"

	L.phase = "恶魔形态"
	L.phase_desc = "恶魔形态计时。"
	L.phase_trigger = "滚开吧，脆弱的精灵。现在我说了算！"
	L.phase_demon = "恶魔形态！60秒。"
	L.phase_demonsoon = "5秒后，恶魔形态！"
	L.phase_normalsoon = "5秒后，正常形态！"
	L.phase_normal = "正常形态！"
	L.demon_bar = "恶魔形态"
	L.demon_nextbar = "下一恶魔阶段"

	L.mindcontrol = "精神控制"
	L.mindcontrol_desc = "当玩家受到精神控制时发出警报。"
	L.mindcontrol_warning = "精神控制"

	L.image = "镜像"
	L.image_desc = "当15%镜像分裂时发出警报。"
	L.image_trigger = "不……不！你在干什么？我才是主宰！你听到没有？我……啊啊啊啊！控制……不住了。"
	L.image_message = "15% - 镜像出现！"
	L.image_warning = "即将 镜像！"

	L.whisper = "心魔"
	L.whisper_desc = "当玩家受到心魔时发出警报。"
	L.whisper_message = "心魔"
	L.whisper_bar = "心魔消失"
	L.whisper_soon = "心魔 冷却！"
end

L = BigWigs:NewBossLocale("The Lurker Below", "zhCN")
if L then
	L.engage_warning = "%s 激活！90秒后，可能下潜！"

	L.dive = "下潜"
	L.dive_desc = "下潜计时条。"
	L.dive_warning = "约%d秒后，下潜！"
	L.dive_bar = "下潜"
	L.dive_message = "下潜！60秒后，重新出现。"

	L.spout = "喷涌"
	L.spout_desc = "喷涌计时条。"
	L.spout_message = "喷涌！注意躲避！"
	L.spout_warning = "约3秒后，可能喷涌！"
	L.spout_bar = "可能喷涌"

	L.emerge_warning = "%秒后，出现！"
	L.emerge_message = "出现！90秒后，再次下潜！"
	L.emerge_bar = "出现"
end

L = BigWigs:NewBossLocale("Morogrim Tidewalker", "zhCN")
if L then
	L.grave_bar = "<水之墓穴>"
	L.grave_nextbar = "水之墓穴 冷却"

	L.murloc = "鱼群"
	L.murloc_desc = "当鱼群来临时发出警报。"
	L.murloc_bar = "鱼群 冷却"
	L.murloc_message = "鱼群 来临！"
	L.murloc_soon_message = "即将 鱼群！"
	L.murloc_engaged = "%s激活！约40秒后，鱼群出现！"

	L.globules = "水泡"
	L.globules_desc = "当水泡来临时发出警报。"
	L.globules_trigger1 = "很快就都结束了。"
	L.globules_trigger2 = "你们无处可逃！"
	L.globules_message = "水泡 来临！"
	L.globules_warning = "即将 水泡！"
	L.globules_bar = "水泡 消失"
end

L = BigWigs:NewBossLocale("Lady Vashj", "zhCN")
if L then
	L.engage_trigger1 = "我不想贬低自己来获取你的宽容，但是你让我别无选择……"
	L.engage_trigger2 = "我唾弃你们，地表的渣滓！"
	L.engage_trigger3 = "伊利丹大人必胜！"
	L.engage_trigger4 = "逃吧，否则就来受死！"
	L.engage_trigger5 = "入侵者都要受死！"
	L.engage_message = "进入第一阶段！"

	L.phase = "阶段警报"
	L.phase_desc = "当进入不同阶段时发出警报。"
	L.phase2_trigger = "机会来了！一个活口都不要留下！"
	L.phase2_soon_message = "即将 第二阶段！"
	L.phase2_message = "第二阶段 - 援兵 来临！"
	L.phase3_trigger = "你们最好找掩护。"
	L.phase3_message = "第三阶段 - 4分钟后，激怒！"

	L.elemental = "被污染的元素"
	L.elemental_desc = "在第二阶段，被污染的元素计时条。"
	L.elemental_bar = "<被污染的元素 来临>"
	L.elemental_soon_message = "被污染的元素 即将出现！"

	L.strider = "盘牙巡逻者"
	L.strider_desc = "在第二阶段，盘牙巡逻者计时条。"
	L.strider_bar = "<巡逻者 来临>"
	L.strider_soon_message = "盘牙巡逻者 即将出现！"

	L.naga = "盘牙精英"
	L.naga_desc = "在第二阶段，盘牙精英计时条。"
	L.naga_bar = "<精英 来临>"
	L.naga_soon_message = "盘牙精英 即将出现！"

	L.barrier_desc = "当护盾击碎发出警报。"
	L.barrier_down_message = "护盾 - %d/4 击碎！"
end

