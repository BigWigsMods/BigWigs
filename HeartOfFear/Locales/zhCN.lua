local L = BigWigs:NewBossLocale("Imperial Vizier Zor'lok", "zhCN")
if not L then return end
if L then
	L.engage_yell = "我们不会向黑暗虚空的绝望屈服。如果女皇要我们去死，我们便照做。"

	L.force_message = "力与魄脉冲"

	L.attenuation = EJ_GetSectionInfo(6426) .. "（跳舞）"
	L.attenuation_bar = "音波衰减"
	L.attenuation_message = "%s 音波衰减 %s"
	L.echo = "|c001cc986回响傀儡|r"
	L.zorlok = "|c00ed1ffa佐尔洛克|r"
	L.left = "|c00008000<- 左 <-|r"
	L.right = "|c00FF0000-> 右 ->|r"

	L.platform_emote = "皇家宰相佐尔洛克朝他其中一个平台飞去了！" -- Imperial Vizier Zor'lok flies to one of his platforms!
	L.platform_emote_final = "皇家宰相佐尔洛克吸入狂热信息素！"-- Imperial Vizier Zor'lok inhales the Pheromones of Zeal!
	L.platform_message = "换平台"
end

L = BigWigs:NewBossLocale("Blade Lord Ta'yak", "zhCN")
if L then
	L.engage_yell = "自求多福吧，入侵者。我——刀锋领主塔亚克，将是你们的对手。"

	L.unseenstrike_soon = "5-10秒后，无影击(%d)！"
	L.assault_message = "压制突袭"
	L.side_swap = "换边"

	L.custom_off_windstep = "疾风步标记"
	L.custom_off_windstep_desc = "帮助治疗分配，使用 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6} 标记玩家受到疾风步，需要权限。"
end

L = BigWigs:NewBossLocale("Garalon", "zhCN")
if L then
	L.phase2_trigger = "巨型盔甲开始碎裂了"

	L.removed = ">%s< 已移除！"
end

L = BigWigs:NewBossLocale("Wind Lord Mel'jarak", "zhCN")
if L then
	L.spear_removed = "你的穿刺之矛被移除了！"

	L.mending_desc = "|cFFFF0000警告: 计时条仅对你的“焦点”目标显示，因为每个扎尔提克助战者有独立的治疗冷却。|r "
	L.mending_warning = "你的焦点目标正在施放治疗！"
	L.mending_bar = "焦点：治疗"
end

L = BigWigs:NewBossLocale("Amber-Shaper Un'sok", "zhCN")
if L then
	L.explosion_by_other = "琥珀畸怪/焦点目标的琥珀爆炸冷却计时条"
	L.explosion_by_other_desc = "当琥珀畸怪或你的焦点目标施放琥珀爆炸时显示冷却警报和计时条。"

	L.explosion_casting_by_other = "琥珀畸怪/焦点目标施放琥珀爆炸"
	L.explosion_casting_by_other_desc = "当琥珀畸怪或你的焦点目标施放琥珀爆炸时显示警报。强烈建议使用醒目！"

	L.explosion_by_you = "你的琥珀爆炸冷却"
	L.explosion_by_you_desc = "当你的琥珀爆炸冷却时发出警报。"
	L.explosion_by_you_bar = "你正在施放…"

	L.explosion_casting_by_you = "你的琥珀爆炸施放条"
	L.explosion_casting_by_you_desc = "你正在施放琥珀爆炸时显示警报。强烈建议使用醒目！"

	L.willpower = "意志力"
	L.willpower_message = "意志力：>%d<！"

	L.break_free_message = "血量：>%d%%<！"
	L.fling_message = "快吸水！"
	L.parasite = "寄生生长"

	L.monstrosity_is_casting = "琥珀畸怪：爆炸"
	L.you_are_casting = ">你< 正在施法！"

	L.unsok_short = "首领"
	L.monstrosity_short = "琥珀畸怪"
end

L = BigWigs:NewBossLocale("Grand Empress Shek'zeer", "zhCN")
if L then
	L.engage_trigger = "胆敢挑战我帝国的人都只有死路一条！"

	L.phases = "阶段"
	L.phases_desc = "当转换阶段时警报。"

	L.eyes = "女皇邪眼"
	L.eyes_desc = "当女皇邪眼堆叠时显示持续计时条。"
	L.eyes_message = "女皇邪眼"

	L.visions_message = "死亡幻象"
	L.visions_dispel = "玩家被恐惧！"
	L.fumes_bar = "你的毒雾增益"
end

