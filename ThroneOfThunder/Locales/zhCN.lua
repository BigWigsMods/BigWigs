local L = BigWigs:NewBossLocale("Jin'rokh the Breaker", "zhCN")
if not L then return end
if L then
	L.storm_duration = "闪电风暴持续"
	L.storm_duration_desc = "当闪电风暴施放时显示分离持续警报条。"
	L.storm_short = "闪电风暴"

	L.in_water = ">你< 水中！"
end

L = BigWigs:NewBossLocale("Horridon", "zhCN")
if L then
	L.charge_trigger = "开始拍打他的尾巴"
	L.door_trigger = "之门中涌出"
	L.orb_trigger = "冲向" -- PLAYERNAME forces Horridon to charge the Farraki door!

	L.chain_lightning_message = "焦点：>闪电链<！"
	L.chain_lightning_bar = "焦点：闪电链"

	L.fireball_message = "焦点：>火球术<！"
	L.fireball_bar = "焦点：火球术"

	L.venom_bolt_volley_message = "焦点：>毒箭之雨<！"
	L.venom_bolt_volley_bar = "焦点：毒箭之雨"

	L.adds = "增援出现"
	L.adds_desc = "当法拉基，古拉巴什，达卡莱和阿曼尼部族以及战神贾拉克出现时发出警报。"

	L.door_opened = "开门！"
	L.door_bar = "下一门（%d）"
	L.balcony_adds = "阳台增援"
	L.orb_message = "控制之球掉落！"

	L.focus_only = "|cffff0000只警报焦点目标。|r "
end

L = BigWigs:NewBossLocale("Council of Elders", "zhCN")
if L then
	L.priestess_adds = "神灵增援"
	L.priestess_adds_desc = "当击杀全部高阶祭司玛尔里的增援时发出警报。"
	L.priestess_adds_message = "神灵增援"

	L.custom_on_markpossessed = "标记控制首领"
	L.custom_on_markpossessed_desc = "用骷髅团队标记被控制的首领，需要权限。"

	L.priestess_heal = ">%s< 被治疗！"
	L.assault_stun = "坦克眩晕"
	L.assault_message = "冰寒突击！"
	L.full_power = "全能量"
	L.hp_to_go_power = "%d%% 生命！（能量：%d）"
	L.hp_to_go_fullpower = "%d%% 生命！（全能量）"
end

L = BigWigs:NewBossLocale("Tortos", "zhCN")
if L then
	L.bats_desc = "大量吸血蝠。控制。"

	L.kick = "脚踢"
	L.kick_desc = "持续追踪可被脚踢旋龟的数量。"
	L.kick_message = "可脚踢旋龟：>%d<！"
	L.kicked_message = "%s已被踢！（%d剩余）"

	L.custom_off_turtlemarker = "旋龟标记"
	L.custom_off_turtlemarker_desc = "使用团队标记标记全部旋龟。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突，需要权限。|r\n|cFFADFF2F提示：如果团队选择你用来标记旋龟，鼠标悬停快速划过全部旋龟是最快的标记方式。|r"

	L.no_crystal_shell = "没有晶化甲壳"
end

L = BigWigs:NewBossLocale("Megaera", "zhCN")
if L then
	L.breaths = "火息术"
	L.breaths_desc = "全部不同类型的火息术警报。"

	L.arcane_adds = "奥术之头"
end

L = BigWigs:NewBossLocale("Ji-Kun", "zhCN")
if L then
	L.first_lower_hatch_trigger = "下层某个鸟巢中的蛋开始孵化了！"
	L.lower_hatch_trigger = "下层某个鸟巢中的蛋开始孵化了！"
	L.upper_hatch_trigger = "上层某个鸟巢中的蛋开始孵化了！"

	L.nest = "巢穴"
	L.nest_desc = "警报依赖于巢穴。\n|cFFADFF2F提示：如果你没有分配到处理巢穴请关闭该警报。|r"

	L.flight_over = "飞行结束 %d秒！"
	L.upper_nest = "|cff008000上层|r巢穴"
	L.lower_nest = "|cffff0000下层|r巢穴"
	L.up = "|cff008000上层|r"
	L.down = "|cffff0000下层|r"
	L.add = "增援"
	L.big_add_message = "大量增援 >%s<！"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "zhCN")
if L then
	L.red_spawn_trigger = "红光照出了一只猩红雾行兽！"
	L.blue_spawn_trigger = "蓝光照出了一只碧蓝雾行兽！"
	L.yellow_spawn_trigger = "强光照出了一只琥珀雾行兽！"

	L.adds = "显形增援"
	L.adds_desc = "当猩红、琥珀和碧蓝雾行兽显形和雾行兽剩余时发出警报。"

	L.custom_off_ray_controllers = "光线控制"
	L.custom_off_ray_controllers_desc = "使用 {rt1}{rt7}{rt6} 团队标记控制光线增援和移动的玩家，需要权限。"

	L.custom_off_parasite_marks = "黑暗寄生标记"
	L.custom_off_parasite_marks_desc = "使用 {rt3}{rt4}{rt5} 标记中了黑暗寄生的玩家帮助分配治疗，需要权限。"

	L.initial_life_drain = "初始生命吸取施放"
	L.initial_life_drain_desc = "初始生命吸取施放消息以帮助保持减少受到治疗的减益。"

	L.life_drain_say = ">%d<层吸取"

	L.rays_spawn = "光线出现"
	L.red_add = "|cffff0000红色|r增援"
	L.blue_add = "|cff0000ff蓝色|r增援"
	L.yellow_add = "|cffffff00黄色|r增援"
	L.death_beam = "衰变光束"
	L.red_beam = "|cffff0000红色|r光束"
	L.blue_beam = "|cff0000ff蓝色|r光束"
	L.yellow_beam = "|cffffff00黄色|r光束"
end

L = BigWigs:NewBossLocale("Primordius", "zhCN")
if L then
	L.mutations = "变异 |cff008000>%d<|r |cffff0000>%d<|r"
	L.acidic_spines = "酸性脊刺（溅射伤害）"
end

L = BigWigs:NewBossLocale("Dark Animus", "zhCN")
if L then
	L.engage_trigger = "宝珠爆炸了！"

	L.matterswap_desc = "中了物质交换的玩家离你过远，如果他们被驱散时你会与他们交换的位置。"
	L.matterswap_message = ">你< 最远距离物质交换！"

	L.siphon_power = "心能虹吸（%d%%）"
	L.siphon_power_soon = "心能虹吸（%d%%）即将%s！"
	L.slam_message = "爆炸猛击！"
end

L = BigWigs:NewBossLocale("Iron Qon", "zhCN")
if L then
	L.molten_energy = "熔火能量"

	L.overload_casting = "正在施放 熔火过载"
	L.overload_casting_desc = "当正在施放熔火过载时发出警报。"

	L.arcing_lightning_cleared = "弧形闪电"

	L.custom_off_spear_target = "投掷长矛目标"
	L.custom_off_spear_target_desc = "尝试警报投掷长矛目标。此方法将提高 CPU 使用率，有时会显示错误的目标，所以它在默认情况下是被禁用。\n|cFFADFF2F提示：设置为坦克职业会有助于提高警报准确性。|r"
	L.possible_spear_target = "可能的长矛"
end

L = BigWigs:NewBossLocale("Twin Consorts", "zhCN")
if L then
	L.last_phase_yell_trigger = "只此一次……"

	L.barrage_fired = "弹幕！"
end

L = BigWigs:NewBossLocale("Lei Shen", "zhCN")
if L then
	L.custom_off_diffused_marker = "散射闪电标记"
	L.custom_off_diffused_marker_desc = "使用全部团队标记标记全部散射闪电，需要权限。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r\n|cFFADFF2F提示：如果团队选择你用来标记散射闪电，鼠标悬停快速划过全部散射闪电是最快的标记方式。|r"

	L.stuns = "昏迷"
	L.stuns_desc = "显示昏迷持续计时条，用于处理球状闪电。"

	L.aoe_grip = "AoE 之握"
	L.aoe_grip_desc = "当死亡骑士使用血魔之握时发出警报，用于处理球状闪电。"

	L.shock_self = "自身静电冲击"
	L.shock_self_desc = "显示静电冲击减益持续计时条。"

	L.overcharged_self = "自身超载"
	L.overcharged_self_desc = "显示超载减益持续计时条。"

	L.last_inermission_ability = "最终阶段转换技能已使用！"
	L.safe_from_stun = "超载昏迷你也许是安全的"
	L.diffusion_add = "散射闪电增援"
	L.shock = "电能震击"
	L.static_shock_bar = "<静电冲击分摊>"
	L.overcharge_bar = "<超载脉冲>"
end

L = BigWigs:NewBossLocale("Ra-den", "zhCN")
if L then
	L.vita_abilities = "生命技能"
	L.anima_abilities = "心能技能"
	L.worm = "血色恐魔"
	L.worm_desc = "召唤血色恐魔。"
	L.balls = "造物材料"
	L.balls_desc = "心能（红）和生命（蓝）造物材料，这些技能使莱登获得增益。"
	L.corruptedballs = "腐化心能"
	L.corruptedballs_desc = "腐化生命和腐化心能，（腐化生命）增加伤害或（腐化心能）增加生命值。"
	L.unstablevitajumptarget = "不稳定的生命弹跳目标"
	L.unstablevitajumptarget_desc = "当你距离最远受到不稳定的生命玩家时发出提示。如果醒目此选项，将会在不稳定的生命弹跳到你时候看到冷却计时条。"
	L.unstablevitajumptarget_message = ">你< 距离不稳定的生命最远！"
	L.sensitivityfurthestbad = "生命过敏+最远距离 = |cffff0000坏|r！"
	L.kill_trigger = "等等"

	L.assistPrint = "一个名为“BigWigs_Ra-denAssist”的插件已经发布，可以帮助公会在莱登的战斗中提供帮助。"
end

L = BigWigs:NewBossLocale("Throne of Thunder Trash", "zhCN")
if L then
	L.stormcaller = "赞达拉风暴召唤者"
	L.stormbringer = "风暴使者达兹基尔"
	L.monara = "莫纳拉"
	L.rockyhorror = "岩石恐魔"
	L.thunderlord_guardian = "雷电领主/雷电守卫"
end

