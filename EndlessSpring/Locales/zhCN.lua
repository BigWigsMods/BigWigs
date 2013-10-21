
local L = BigWigs:NewBossLocale("Protectors of the Endless", "zhCN")
if not L then return end
if L then
	L.under = "%s：>%s<脚下！"
	L.heal = ">%s< 开始治疗！"
end

L = BigWigs:NewBossLocale("Tsulong", "zhCN")
if L then
	L.engage_yell = "你不属于这里！我必须保护水流……我要驱逐李，要不就杀死你！"
	L.kill_yell = "谢谢你，陌生人。我自由了。"

	L.phases = "阶段转换"
	L.phases_desc = "当阶段转换时发出警报。"

	L.sunbeam_spawn = "新阳光！"
end

L = BigWigs:NewBossLocale("Lei Shi", "zhCN")
if L then
	L.hp_to_go = "%d%% 结束"

	L.special = "下一次特殊技能"
	L.special_desc = "当下一次特殊技能时发出警报。"

	L.custom_off_addmarker = "保护者标记"
	L.custom_off_addmarker_desc = "当雷施被保护时标记复生的保护者，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r\n|cFFADFF2F提示：如果团队选择你用来标记保护者，鼠标悬停快速划过全部保护者是最快的标记方式。|r"
end

L = BigWigs:NewBossLocale("Sha of Fear", "zhCN")
if L then
	L.fading_soon = ">%s< 即将潜水"

	L.swing = "连续打击"
	L.swing_desc = "计算先前的痛击连续次数。"

	L.throw = "投掷！"
	L.ball_dropped = "球掉落！"
	L.ball_you = ">你< 球！"
	L.ball = "球"

	L.cooldown_reset = "冷却已被重置！"

	L.ability_cd = "技能冷却计时条"
	L.ability_cd_desc = "显示下次可能施放的技能。"

	L.strike_or_spout = "宿怨打击或龙卷水涌"
	L.huddle_or_spout_or_strike = "因畏惧而蜷缩或龙卷水涌或宿怨打击"

	L.custom_off_huddle = "因畏惧而蜷缩标记"
	L.custom_off_huddle_desc = "帮助治疗分配，使用 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6} 标记玩家受到因畏惧而蜷缩，需要权限。"
end

