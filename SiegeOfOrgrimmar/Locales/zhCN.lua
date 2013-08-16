local L = BigWigs:NewBossLocale("Immerseus", "zhCN")
if not L then return end
if L then

end

L = BigWigs:NewBossLocale("The Fallen Protectors", "zhCN")
if L then
	L.defile = "施放大地污染"

	L.custom_off_bane_marks = "暗言术：蛊标记"
	L.custom_off_bane_marks_desc = "帮助驱散分配，给受到暗言术：蛊的玩家使用 %s%s%s%s%s%s%s 进行标记（按照这个顺序）（不是所有标记会被用到），需要权限。"

	L.no_meditative_field = "没有黑暗冥想！"

	L.intermission = "背水一战"
	L.intermission_desc = "当任一首领即将使用背水一战时发出警报。"
end

L = BigWigs:NewBossLocale("Norushen", "zhCN")
if L then
	L.pre_pull = "准备开战"
	L.pre_pull_desc = "准备与首领开始战斗前的计时条。"
	L.pre_pull_trigger = "Very well, I will create a field to keep your corruption quarantined."

	L.big_adds = "大型腐化物"
	L.big_adds_desc = "当在内心或现实杀死大型腐化物时发出警报。"
	L.big_add = "大型腐化物！>%d<"
	L.big_add_killed = "杀死大型腐化物！>%d<"
end

L = BigWigs:NewBossLocale("Sha of Pride", "zhCN")
if L then
	L.custom_off_titan_mark = "泰坦之赐标记"
	L.custom_off_titan_mark_desc = "帮助提示泰坦之赐，给受到泰坦之赐的玩家使用 %s%s%s%s%s%s%s%s 进行标记（受到傲气之环的玩家不会被标记），需要权限。"

	L.projection_message = "快到|cFF00FF00绿|r箭头！"
	L.projection_explosion = "投影爆炸"

	L.big_add_bar = "傲慢具象"
	L.big_add_spawning = "傲慢具象出现！"
	L.small_adds = "本我具象"
end

L = BigWigs:NewBossLocale("Galakras", "zhCN")
if L then
	L.demolisher = "投石车"
	L.demolisher_desc = "库卡隆投石车进入战斗计时条。"
	L.towers = "塔楼"
	L.towers_desc = "当塔楼被突破时发出警报。"
	L.south_tower_trigger = "The door barring the South Tower has been breached!"
	L.south_tower = "南塔楼"
	L.north_tower_trigger = "The door barring the North Tower has been breached!"
	L.north_tower = "北塔楼"

	L.custom_off_shaman_marker = "萨满标记"
	L.custom_off_shaman_marker_desc = "帮助打断分配，使用 %s%s%s%s%s%s%s 标记龙喉潮汐萨满（按照这个顺序）（不是所有标记会被用到），需要权限。"
end

L = BigWigs:NewBossLocale("Iron Juggernaut", "zhCN")
if L then

end

L = BigWigs:NewBossLocale("Kor'kron Dark Shaman", "zhCN")
if L then
	L.blobs = "污秽软泥怪"

	L.custom_off_mist_marks = "剧毒之雾"
	L.custom_off_mist_marks_desc = "帮助治疗分配，给受到剧毒之雾的玩家使用 %s%s%s%s%s%s%s 进行标记（按照这个顺序）（不是所有标记会被用到），需要权限。"
end

L = BigWigs:NewBossLocale("General Nazgrim", "zhCN")
if L then
	L.custom_off_bonecracker_marks = "碎骨重锤"
	L.custom_off_bonecracker_marks_desc = "帮助治疗分配，给受到碎骨重锤的玩家使用  %s%s%s%s%s%s 进行标记（按照这个顺序）（不是所有标记会被用到），需要权限。"

	L.stance_bar = "%s（现在：%s）"
	L.battle = "战斗"
	L.berserker = "狂暴"
	L.defensive = "防御"

	L.adds_trigger1 = "Defend the gate!"
	L.adds_trigger2 = "Rally the forces!"
	L.adds_trigger3 = "Next squad, to the front!"
	L.adds_trigger4 = "Warriors, on the double!"
	L.adds_trigger5 = "Kor'kron, at my side!"
	L.adds_trigger_extra_wave = "All Kor'kron... under my command... kill them... NOW"
	L.extra_adds = "额外增援部队"

	L.chain_heal_message = "你的焦点正在施放强效治疗链！"

	L.arcane_shock_message = "你的焦点正在施放奥术震击！"

	L.focus_only = "|cffff0000只警报焦点目标。|r "
end

L = BigWigs:NewBossLocale("Malkorok", "zhCN")
if L then
	L.custom_off_energy_marks = "散逸能量"
	L.custom_off_energy_marks_desc = "帮助驱散分配，给受到散逸能量的玩家使用 %s%s%s%s%s%s%s 进行标记（按照这个顺序）（不是所有标记会被用到），需要权限。"
end

L = BigWigs:NewBossLocale("Spoils of Pandaria", "zhCN")
if L then
	L.enable_zone = "遗物仓库"
	L.matter_scramble_explosion = "斗转乾坤爆炸" -- shorten maybe?

	L.custom_off_mark_brewmaster = "酒仙标记"
	L.custom_off_mark_brewmaster_desc = "使用 %s 标记上古酒仙之灵。"
end

L = BigWigs:NewBossLocale("Thok the Bloodthirsty", "zhCN")
if L then
	L.tank_debuffs = "坦克减益"
	L.tank_debuffs_desc = "当坦克受到不同类型的恐惧咆哮减益时发出警报。"
end

L = BigWigs:NewBossLocale("Siegecrafter Blackfuse", "zhCN")
if L then
	L.shredder_engage_trigger = "An Automated Shredder draws near!"
	L.laser_on_you = ">你< 激光 BIU BIU！"
	L.laser_say = "激光 BIU BIU！"

	L.assembly_line_trigger = "Unfinished weapons begin to roll out on the assembly line."
	L.assembly_line_message = "零散的武器 >%d<"

	L.shockwave_missile_trigger = "Presenting... the beautiful new ST-03 Shockwave missile turret!"
end

L = BigWigs:NewBossLocale("Paragons of the Klaxxi", "zhCN")
if L then
	L.one = "依约库克选择：一！"
	L.two = "依约库克选择：二！"
	L.three = "依约库克选择：三！"
	L.four = "依约库克选择：四！"
	L.five = "依约库克选择：五！"
	L.edge_message = ">你< 炎界"
	L.custom_off_edge_marks = "炎界标记"
	L.custom_off_edge_marks_desc = "基于计算给谁将会炎界的玩家使用 %s%s%s%s%s%s 进行标记，需要权限。"
	L.injection_over_soon = "注射即将结束 >%s<！"
end

L = BigWigs:NewBossLocale("Garrosh Hellscream", "zhCN")
if L then
	L.mind_control = "亚煞极之触"

	L.chain_heal_desc = "治疗一个友方目标40%最大生命，会跳到附近友方目标身上。"
	L.chain_heal_message = "你的焦点目标正在施放先祖治疗链！"
	L.chain_heal_bar = "焦点：先祖治疗链"

	L.farseer_trigger = "Farseers, mend our wounds!"
	L.custom_off_shaman_marker = "先知标记"
	L.custom_off_shaman_marker_desc = "帮助打断分配，使用 %s%s%s%s%s%s%s 标记先知狼骑（按照这个顺序）（不是所有标记会被用到），需要权限。"

	L.focus_only = "|cffff0000只警报焦点目标。|r "
end

L = BigWigs:NewBossLocale("Siege of Orgrimmar Trash", "zhCN")
if L then

end

