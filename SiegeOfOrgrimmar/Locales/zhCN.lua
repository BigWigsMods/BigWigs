local L = BigWigs:NewBossLocale("Immerseus", "zhCN")
if not L then return end
if L then
--@localization(locale="zhCN", namespace="SiegeOfOrgrimmar/Immerseus", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("The Fallen Protectors", "zhCN")
if L then
--@localization(locale="zhCN", namespace="SiegeOfOrgrimmar/TheFallenProtectors", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_bane_marks = "暗言术：蛊标记"
	L.custom_off_bane_marks_desc = "帮助驱散分配，给最初受到暗言术：蛊的玩家使用 {rt1}{rt2}{rt3}{rt4}{rt5} 进行标记（按照这个顺序，不是所有标记会被用到），需要权限。"
end

L = BigWigs:NewBossLocale("Norushen", "zhCN")
if L then
--@localization(locale="zhCN", namespace="SiegeOfOrgrimmar/Norushen", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Sha of Pride", "zhCN")
if L then
--@localization(locale="zhCN", namespace="SiegeOfOrgrimmar/ShaOfPride", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_titan_mark = "泰坦之赐标记"
	L.custom_off_titan_mark_desc = "给受到泰坦之赐的玩家使用 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8} 进行标记，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r"
end

L = BigWigs:NewBossLocale("Galakras", "zhCN")
if L then
--@localization(locale="zhCN", namespace="SiegeOfOrgrimmar/Galakras", format="lua_additive_table", handle-unlocalized="ignore")@

	L.custom_off_shaman_marker = "萨满标记"
	L.custom_off_shaman_marker_desc = "帮助打断分配，使用 {rt1}{rt2}{rt3}{rt4}{rt5} 标记龙喉潮汐萨满，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r\n|cFFADFF2F提示：如果团队选择你打开此选项，鼠标快速指向萨满是标记他们的最快方式。|r"
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "zhCN")
if L then
	L.custom_off_mine_marks = "地雷标记"
	L.custom_off_mine_marks_desc = "帮助沙包分配，使用 {rt1}{rt2}{rt3} 标记蛛形地雷，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r\n|cFFADFF2F提示：如果团队选择你打开此选项，鼠标快速指向全部地雷是标记他们的最快方式。|r"
end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "zhCN")
if L then
	L.blobs = "污秽软泥怪"

	L.custom_off_mist_marks = "剧毒之雾标记"
	L.custom_off_mist_marks_desc = "帮助治疗分配，给受到剧毒之雾的玩家使用 {rt1}{rt2}{rt3}{rt4}{rt5} 进行标记，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r"
end

L = BigWigs:NewBossLocale("General Nazgrim", "zhCN")
if L then
	L.custom_off_bonecracker_marks = "碎骨重锤标记"
	L.custom_off_bonecracker_marks_desc = "帮助治疗分配，给受到碎骨重锤的玩家使用 {rt1}{rt2}{rt3}{rt4}{rt5} 进行标记，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r"

	L.stance_bar = "%s（现在：%s）"
	L.battle = "战斗"
	L.berserker = "狂暴"
	L.defensive = "防御"

	L.adds_trigger1 = "守住大门！"
	L.adds_trigger2 = "重新整队！"
	L.adds_trigger3 = "下一队，冲上去！"
	L.adds_trigger4 = "战士们，快过来！"
	L.adds_trigger5 = "库卡隆，支援我！"
	L.adds_trigger_extra_wave = "库卡隆，听我的命令，杀了他们！"
	L.extra_adds = "额外增援部队"
	L.final_wave = "最后一波"

	L.chain_heal_message = "你的焦点正在施放强效治疗链！"

	L.arcane_shock_message = "你的焦点正在施放奥术震击！"

	L.focus_only = "|cffff0000只警报焦点目标。|r "
end

L = BigWigs:NewBossLocale("Malkorok", "zhCN")
if L then
	L.custom_off_energy_marks = "散逸能量标记"
	L.custom_off_energy_marks_desc = "帮助驱散分配，给受到散逸能量的玩家使用 {rt1}{rt2}{rt3}{rt4} 进行标记，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r"
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "zhCN")
if L then
	L.start_trigger = "录像开了吗？开了？很好。地精泰坦控制模块启动，请退后。"
	L.win_trigger = "系统重置中。请勿关闭电源，否则将发生爆炸。"

	L.enable_zone = "遗物仓库"
	L.matter_scramble_explosion = "斗转乾坤爆炸" -- shorten maybe?
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "zhCN")
if L then
--@localization(locale="zhCN", namespace="SiegeOfOrgrimmar/ThokTheBloodthirsty", format="lua_additive_table", handle-unlocalized="ignore")@
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "zhCN")
if L then
	L.overcharged_crawler_mine = "超载的蛛形地雷" -- sadly this is needed since they have same mobId
	L.custom_off_mine_marker = "地雷标记"
	L.custom_off_mine_marker_desc = "帮助眩晕职业给每个特定地雷打上标记。（会使用全部标记）"

	L.saw_blade_near_you = "锯刃在旁边（不是在你）"
	L.saw_blade_near_you_desc = "你可能想关闭这个功能以避免骚扰，如果你的团队大多是根据自己的战术安排。"

	L.disabled = "已禁用"

	L.shredder_engage_trigger = "一台自动伐木机正在靠近！"
	L.laser_on_you = ">你< 激光 BIU BIU！"
	L.laser_say = "激光 BIU BIU"

	L.assembly_line_trigger = "未完成的武器从装配流水线上传送出来了。"
	L.assembly_line_message = "零散的武器 >%d<"
	L.assembly_line_items = "物品（%d）：%s"
	L.item_missile = "导弹"
	L.item_mines = "地雷"
	L.item_laser = "激光"
	L.item_magnet = "电磁体"
	L.item_deathdealer = "死亡执行者"

	L.shockwave_missile_trigger = "为各位送上"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "zhCN")
if L then
	L.catalyst_match = "催化药剂：|c%s 引爆 >你<|r" -- might not be best for colorblind?
	L.you_ate = "你已吃寄生虫（%d 剩余）"
	L.other_ate = "%s 已吃 %s 寄生虫（%d 剩余）"
	L.parasites_up = "%d |4寄生虫:寄生虫; 可用"
	L.dance = "跳舞"
	L.prey_message = "使用控制诱捕寄生虫"
	L.injection_over_soon = "注射即将结束 >%s<！"

	L.one = "依约库克选择：一！"
	L.two = "依约库克选择：二！"
	L.three = "依约库克选择：三！"
	L.four = "依约库克选择：四！"
	L.five = "依约库克选择：五！"

	L.custom_off_edge_marks = "炎界标记"
	L.custom_off_edge_marks_desc = "基于计算给谁将会炎界的玩家使用 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8} 进行标记，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r"
	L.edge_message = ">你< 炎界"

	L.custom_off_parasite_marks = "寄生虫标记"
	L.custom_off_parasite_marks_desc = "帮助群体控制和诱捕分配，给寄生虫使用 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} 进行标记，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r"

	L.injection_tank = "施放注射"
	L.injection_tank_desc = "当对当前坦克施放注射时显示计时条。"
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "zhCN")
if L then
	L.manifest_rage = "暴怒具象"
	L.manifest_rage_desc = "当加尔鲁什获得100能量时将释放2秒引导的暴怒具象技能，当引导结束后会召唤大型增援。风筝钢铁之星到加尔鲁什将昏迷并打断他的施法。"

	L.phase_3_end_trigger = "别以为你们已经赢了，你们这些瞎子，睁大眼睛好好看看！"

	L.clump_check_desc = "在呼叫轰炸阶段时每3秒检查扎堆的玩家，如果检查到群体存在库卡隆钢铁之星将会出现。"
	L.clump_check_warning = "发现呼叫轰炸，即将 >钢铁之星<！"

	L.bombardment = "呼叫轰炸"
	L.bombardment_desc = "轰击暴风城，并在地面上留下火焰。 库卡隆钢铁之星只会在呼叫轰炸阶段出现。"

	L.intermission = "中场休息"
	L.mind_control = "亚煞极之触"
	L.empowered_message = ">%s< 强化腐蚀！"

	L.ironstar_impact_desc = "当钢铁之星将撞击墙壁另一边时显示计时条。"
	L.ironstar_rolling = "钢铁之星翻滚！"

	L.chain_heal_desc = "治疗一个友方目标40%最大生命，会跳到附近友方目标身上。"
	L.chain_heal_message = "你的焦点目标正在施放先祖治疗链！"
	L.chain_heal_bar = "焦点：先祖治疗链"

	L.farseer_trigger = "先知们，为我们治疗！"
	L.custom_off_shaman_marker = "先知标记"
	L.custom_off_shaman_marker_desc = "帮助打断分配，使用 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7} 标记先知狼骑（按照这个顺序，不是所有标记会被用到），需要权限。"

	L.custom_off_minion_marker = "亚煞极的爪牙标记"
	L.custom_off_minion_marker_desc = "帮助分离亚煞极的爪牙，使用 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}{rt7}{rt8} 标记，需要权限。"

	L.focus_only = "|cffff0000只警报焦点目标。|r "
end

