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
	L.charge_trigger = "用力拍动尾巴" -- Horridon sets his eyes on PLAYERNAME and stamps his tail!
	L.door_trigger = "的门蜂拥而出" -- "Farraki forces pour from the Farraki Tribal Door!

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
	L.custom_on_markpossessed_desc = "用骷髅团队标记被控制的首领。"

	L.assault_stun = "坦克眩晕"
	L.assault_message = "冰寒突击！"
	L.full_power = "全能量"
	L.hp_to_go_power = "%d%% 生命！（能量：%d）"
	L.hp_to_go_fullpower = "%d%% 生命！（全能量）"
end

L = BigWigs:NewBossLocale("Tortos", "zhCN")
if L then
	L.kick = "脚踢"
	L.kick_desc = "持续追踪可被脚踢旋龟的数量。"
	L.kick_message = "可脚踢旋龟：>%d<！"

	L.custom_off_turtlemarker = "旋龟标记"
	L.custom_off_turtlemarker_desc = "使用团队标记标记全部旋龟。\n|cFFFF0000团队中只有1名应该启用此选项以防止标记冲突。|r\n|cFFADFF2F提示：如果团队选择你用来标记旋龟，鼠标悬停快速划过全部旋龟是最快的标记方式。|r"

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
	L.lower_hatch_trigger = "下层某个鸟巢中的蛋开始孵化了"
	L.upper_hatch_trigger = "上层某个鸟巢中的蛋开始孵化了"

	L.nest = "巢穴"
	L.nest_desc = "警报依赖于巢穴。|cffff0000如果你没有分配到处理巢穴请关闭该警报！|r"

	L.flight_over = "飞行结束 %d秒！"
	L.upper_nest = "|cff008000下层|r巢穴"
	L.lower_nest = "|cffff0000上层|r巢穴"
	L.up = "UP"
	L.down = "DOWN"
	L.add = "增援"
	L.big_add_message = "大量增援 >%s<！"
end

L = BigWigs:NewBossLocale("Durumu the Forgotten", "zhCN")
if L then
	L.red_spawn_trigger = "猩红雾行兽"
	L.blue_spawn_trigger = "碧蓝雾行兽"
	L.yellow_spawn_trigger = "琥珀雾行兽"

	L.adds = "显形增援"
	L.adds_desc = "当猩红、琥珀和碧蓝雾行兽显形和猩红雾行兽剩余时发出警报。"

	L.custom_off_ray_controllers = "光线控制"
	L.custom_off_ray_controllers_desc = "使用%s%s%s团队标记控制光线增援和移动的玩家。\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.custom_off_parasite_marks = "Dark parasite marker"
	L.custom_off_parasite_marks_desc = "To help healing assignments, mark the people who have dark parasite on them with %s%s%s.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r"

	L.initial_life_drain = "Initial Life Drain cast"
	L.initial_life_drain_desc = "Message for the initial Life Drain cast to help keeping up healing received reducing debuff."

	L.life_drain_say = "%dx Drain"

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
	L.engage_trigger = "宝珠爆炸了"
	L.slam_message = "爆炸猛击！"
end

L = BigWigs:NewBossLocale("Iron Qon", "zhCN")
if L then
	L.molten_energy = "熔火能量"

	L.overload_casting = "正在施放 熔火过载"
	L.overload_casting_desc = "当正在施放熔火过载时发出警报。"

	L.arcing_lightning_cleared = "弧形闪电"
end

L = BigWigs:NewBossLocale("Twin Consorts", "zhCN")
if L then
	L.last_phase_yell_trigger = "Just this once..." -- "<490.4 01:24:30> CHAT_MSG_MONSTER_YELL#Just this once...#Lu'lin###Suen##0#0##0#3273#nil#0#false#false", -- [6]

	L.barrage_fired = "弹幕！"
end

L = BigWigs:NewBossLocale("Lei Shen", "zhCN")
if L then
	L.conduit_abilities = "导管技能"
	L.conduit_abilities_desc = "导管特定技能冷却计时条。"
	L.conduit_abilities_message = "下一导管技能！"

	L.intermission = "阶段转换"
	L.diffusion_add = "散射闪电增援"
	L.shock = "电能震击"

	L.overcharged_message = "昏迷 AoE 脉冲"
	L.static_shock_message = "分摊 AoE 伤害"
	L.diffusion_chain_message = "即将散射闪电增援 - 散开！"
end

L = BigWigs:NewBossLocale("Ra-den", "zhCN")
if L then

end

L = BigWigs:NewBossLocale("Trash", "zhCN")
if L then
	L.stormcaller = "赞达拉风暴召唤者"
	L.stormbringer = "风暴使者达兹基尔"
	L.monara = "莫纳拉"
end

