
local L = BigWigs:NewBossLocale("Algalon the Observer", "zhCN")
if L then
	L.phase = "阶段"
	L.phase_desc = "当进入不同阶段时发出警报。"
	L.engage_warning = "第一阶段！"
	L.phase2_warning = "即将 第二阶段！"
	L.phase_bar = "<阶段%d>"
	L.engage_trigger = "你们的行动不合逻辑。这场战斗所有可能产生的结果都已被计算在内。无论结果如何，万神殿都会收到观察者发出的信息。"

	L.punch_message = "相位冲压%2$d层：>%1$s<！"
	L.smash_message = "即将 宇宙重击！"
	L.blackhole_message = "黑洞爆炸：>%dx< 出现！"
	L.bigbang_bar = "<下一大爆炸>"
	L.bigbang_soon = "即将 大爆炸！"

	L.end_trigger = "我曾经看过尘世沉浸在造物者的烈焰之中"
end

L = BigWigs:NewBossLocale("Auriaya", "zhCN")
if L then
	L.engage_trigger = "有些东西，最好永远都不去碰！"

	L.fear_warning = "即将 惊骇尖啸！"
	L.fear_message = "正在施放 惊骇尖啸！"
	L.fear_bar = "<惊骇尖啸 冷却>"

	L.swarm_message = "守护虫群"
	L.swarm_bar = "<守护虫群 冷却>"

	L.defender = "野性防御者"
	L.defender_desc = "当野性防御者出现时发出警报。"
	L.defender_message = "野性防御者（%d/9）！"

	L.sonic_bar = "<音速尖啸>"
end

L = BigWigs:NewBossLocale("Freya", "zhCN")
if L then
	L.engage_trigger1 = "必须保卫温室！"
	L.engage_trigger2 = "长老们，将你们的力量赐予我！"

	L.phase = "阶段"
	L.phase_desc = "当进入不同阶段发出警报。"
	L.phase2_message = "第二阶段！"

	L.wave = "波"
	L.wave_desc = "当一波小怪时发出警报。"
	L.wave_bar = "<下一波>"
	L.conservator_trigger = "艾欧娜尔，您的仆人需要帮助！"
	L.detonate_trigger = "元素之潮会击垮你们！"
	L.elementals_trigger = "孩子们，帮帮我！"
	L.tree_trigger = "|cFF00FFFF生命缚誓者的礼物|r开始生长！"
	L.conservator_message = "古树监护者！"
	L.detonate_message = "引爆鞭笞者！"
	L.elementals_message = "古代水之精魂！"

	L.tree = "艾欧娜尔的礼物"
	L.tree_desc = "当弗蕾亚召唤艾欧娜尔的礼物时发出警报。"
	L.tree_message = "艾欧娜尔的礼物 出现！"

	L.fury_message = "自然之怒"
	L.fury_other = "自然之怒：>%s<！"

	L.tremor_warning = "即将 大地震颤！"
	L.tremor_bar = "<下一大地震颤>"
	L.energy_message = ">你<不稳定的能量！"
	L.sunbeam_message = "即将 阳光！"
	L.sunbeam_bar = "<下一阳光>"

	L.end_trigger = "他对我的控制已经不复存在了。我又一次恢复了理智。谢谢你们，英雄们。"
end

L = BigWigs:NewBossLocale("Hodir", "zhCN")
if L then
	L.engage_trigger = "擅闯此地就要付出代价！"

	L.cold = "刺骨之寒（成就）"
	L.cold_desc = "当你受到2层刺骨之寒效果时发出警报。"
	L.cold_message = "刺骨之寒（%d层） - 移动！"

	L.flash_warning = "急速冻结！"
	L.flash_soon = "5秒后，急速冻结！"

	L.hardmode = "困难模式"
	L.hardmode_desc = "显示困难模式计时器。"

	L.end_trigger = "我……我终于从他的魔掌中……解脱了。"
end

L = BigWigs:NewBossLocale("Ignis the Furnace Master", "zhCN")
if L then
	L.engage_trigger = "大胆！今天就要以尔等的鲜血，为曾用来改造这个世界的武器淬火"

	L.construct_message = "即将 铁铸像！"
	L.construct_bar = "<下一铸像>"
	L.brittle_message = "铁铸像 - 脆弱！"
	L.flame_bar = "<烈焰喷射 冷却>"
	L.scorch_message = ">你< 灼烧！"
	L.scorch_soon = "约5秒后，灼烧！"
	L.scorch_bar = "<下一灼烧>"
	L.slagpot_message = "熔渣炉：>%s<！"
end

L = BigWigs:NewBossLocale("The Iron Council", "zhCN")
if L then
	L.engage_trigger1 = "你们这些入侵者，休想轻易击败钢铁议会！"
	L.engage_trigger2 = "只有把你们全部消灭才能解恨。"
	L.engage_trigger3 = "任你是天下最厉害的恶棍，还是最强大的英雄，都只不过是凡人之躯。"

	L.overload_message = "6秒后，过载！"
	L.death_message = ">你< 死亡符文！"
	L.summoning_message = "闪电元素即将出现！"

	L.chased_other = "闪电之藤：>%s<！"
	L.chased_you = ">你< 闪电之藤！"

	L.overwhelm_other = "压倒能量：>%s<！"

	L.shield_message = "符文之盾！"

	L.council_dies = "%s被击败了！"
end

L = BigWigs:NewBossLocale("Kologarn", "zhCN")
if L then
	L.arm = "手臂死亡"
	L.arm_desc = "当左右手臂死亡时发出警报。"
	L.left_dies = "左臂死亡！"
	L.right_dies = "右臂死亡！"
	L.left_wipe_bar = "<左臂重生>"
	L.right_wipe_bar = "<右臂重生>"

	L.shockwave = "震荡波"
	L.shockwave_desc = "当震荡波到来前发出警报。"
	L.shockwave_trigger = "毁灭！"

	L.eyebeam = "聚焦视线"
	L.eyebeam_desc = "当玩家中了聚焦视线时发出警报。"
	L.eyebeam_trigger = "科隆加恩在注视着你！"
	L.eyebeam_message = "聚焦视线：>%s<！"
	L.eyebeam_bar = "<聚焦视线>"
	L.eyebeam_you = ">你< 聚焦视线！"
	L.eyebeam_say = ">我< 聚焦视线！"

	L.eyebeamsay = "聚焦视线"
	L.eyebeamsay_desc = "当你中了聚焦视线时发出自身警报。"

	L.armor_message = "粉碎护甲%2$d层：>%1$s<！"
end

L = BigWigs:NewBossLocale("Flame Leviathan", "zhCN")
if L then
	L.engage_trigger = "检测到敌对实体。威胁评定协议启动。向主要目标发动攻击。30秒后重新评估。"
	L.engage_message = "%s已激怒！"

	L.pursue = "追踪"
	L.pursue_desc = "当烈焰巨兽追踪玩家时发出警报。"
	L.pursue_trigger = "^%%s开始追赶"
	L.pursue_other = "烈焰巨兽追踪：>%s<！"

	L.shutdown_message = "系统关闭！"
end

L = BigWigs:NewBossLocale("Mimiron", "zhCN")
if L then
	L.phase = "阶段"
	L.phase_desc = "当进入不同阶段发出警报。"
	L.engage_warning = "第一阶段！"
	L.engage_trigger = "^我们时间不多了，朋友们！"
	L.phase2_warning = "即将 第二阶段！"
	L.phase2_trigger = "^太棒了！测试结果非常好！"
	L.phase3_warning = "即将 第三阶段！"
	L.phase3_trigger = "^非常感谢，朋友们！"
	L.phase4_warning = "即将 第四阶段！"
	L.phase4_trigger = "^初步测试阶段完成。"
	L.phase_bar = "<阶段：%d>"

	L.hardmode = "困难模式计时器"
	L.hardmode_desc = "显示困难模式计时器。"
	L.hardmode_trigger = "^嘿，你们为什么要这么做啊？"
	L.hardmode_message = "已开启困难模式！"
	L.hardmode_warning = "困难模式结束！"

	L.plasma_warning = "正在施放 等离子冲击！"
	L.plasma_soon = "即将 等离子冲击！"
	L.plasma_bar = "<等离子冲击>"

	L.shock_next = "下一震荡冲击！"

	L.laser_soon = "即将 P3Wx2激光弹幕！"
	L.laser_bar = "<P3Wx2激光弹幕>"

	L.magnetic_message = "空中指挥单位 已降落！"

	L.suppressant_warning = "即将 烈焰遏制！"

	L.fbomb_soon = "可能即将 冰霜炸弹！"
	L.fbomb_bar = "<下一冰霜炸弹>"

	L.bomb_message = "炸弹机器人 出现！"

	L.end_trigger = "^看起来我的计算有一点小小的偏差。"
end

L = BigWigs:NewBossLocale("Razorscale", "zhCN")
if L then
--	L["Razorscale Controller"] = true,

	L.phase = "阶段"
	L.phase_desc = "当锋鳞转换不同阶段时发出警报。"
	L.ground_trigger = "快一点！她马上就要挣脱了！"
	L.ground_message = "锋鳞被锁住了！"
	L.air_trigger = "给我们一点时间，做好建筑炮台的准备。"
	L.air_trigger2 = "火灭了！准备重建炮台！"
	L.air_message = "起飞！"
	L.phase2_trigger = "%s被永久地禁锢在地面上！"
	L.phase2_message = "第二阶段！"
	L.phase2_warning = "即将 第二阶段！"
	L.stun_bar = "<昏迷>"

	L.breath_trigger = "%s深深地吸了一口气……"
	L.breath_message = "烈焰喷射！"
	L.breath_bar = "<烈焰喷射 冷却>"

	L.flame_message = ">你< 吞噬烈焰！"

	L.harpoon = "鱼叉炮台"
	L.harpoon_desc = "当鱼叉炮台可用时发出警报。"
	L.harpoon_message = "鱼叉炮台：>%d<可用！"
	L.harpoon_trigger = "可以使用鱼叉炮台了！"
	L.harpoon_nextbar = "<鱼叉炮台：%d>"
end

L = BigWigs:NewBossLocale("Thorim", "zhCN")
if L then
	L.phase = "阶段"
	L.phase_desc = "当进入不同阶段发出警报。"
	L.phase1_message = "第一阶段！"
	L.phase2_trigger = "入侵者！你们这些凡人竟敢坏了我的兴致，看我怎么……等等，你们……"
	L.phase2_message = "第二阶段 - 6分15秒后，狂暴！"
	L.phase3_trigger = "狂妄的小崽子们，竟敢在我的地盘上挑战我？我要亲自碾碎你们！"
	L.phase3_message = "第三阶段 - 托里姆！"

	L.hardmode = "困难模式"
	L.hardmode_desc = "显示困难模式计时器。"
	L.hardmode_warning = "困难模式结束！"

	L.shock_message = ">你< 闪电震击！移动！"
	L.barrier_message = "符文巨像 - 符文屏障！"

	L.detonation_say = "我是炸弹！"

	L.charge_message = "闪电充能：>%d<！"
	L.charge_bar = "<闪电充能：%d>"

	L.strike_bar = "<重压打击 冷却>"

	L.end_trigger = "住手！我认输了！"
end

L = BigWigs:NewBossLocale("General Vezax", "zhCN")
if L then
--	L["Vezax Bunny"] = true -- For emote catching.

	L.engage_trigger = "^你们的毁灭预示着痛苦的新时代即将降临！"

	L.surge_message = "黑暗涌动：>%d<！"
	L.surge_cast = "正在施放 黑暗涌动：>%d<！"
	L.surge_bar = "<黑暗涌动：%d>"

	L.animus = "萨隆邪铁畸体"
	L.animus_desc = "当萨隆邪铁畸体出现时发出警报。"
	L.animus_trigger = "萨隆邪铁蒸汽剧烈地旋转着，汇集成一个畸体。"
	L.animus_message = "萨隆邪铁畸体 出现！"

	L.vapor = "萨隆邪铁蒸汽"
	L.vapor_desc = "当萨隆邪铁蒸汽出现时发出警报。"
	L.vapor_message = "萨隆邪铁蒸汽：>%d<！"
	L.vapor_bar = "<萨隆邪铁蒸汽：%d/6>"
	L.vapor_trigger = "一团萨隆邪铁蒸汽在附近聚集起来！"

	L.vaporstack = "萨隆邪铁蒸汽堆叠"
	L.vaporstack_desc = "当玩家中了5层或更多萨隆邪铁蒸汽时发出警报。"
	L.vaporstack_message = "萨隆邪铁蒸汽：>x%d<！"

	L.crash_say = ">我< 暗影冲撞！"

	L.mark_message = "无面者的印记"
	L.mark_message_other = "无面者的印记：>%s<！"
end

L = BigWigs:NewBossLocale("XT-002 Deconstructor", "zhCN")
if L then
	L.exposed_warning = "即将 暴露心脏！"
	L.exposed_message = "暴露心脏！"

	L.gravitybomb_other = "重力炸弹：>%s<！"

	L.lightbomb_other = "灼热之光：>%s<！"

	L.tantrum_bar = "<发脾气 冷却>"
end

L = BigWigs:NewBossLocale("Yogg-Saron", "zhCN")
if L then
	L["Crusher Tentacle"] = "重压触须"
--	L["The Observation Ring"] = true,

	L.phase = "阶段"
	L.phase_desc = "当阶段改变发出警报。"
	L.engage_warning = "第一阶段！"
	L.engage_trigger = "攻击这头野兽要害的时刻即将来临！将你们的愤怒和仇恨倾泻到它的爪牙身上！"
	L.phase2_warning = "第二阶段！"
	L.phase2_trigger = "我是清醒的梦境。"
	L.phase3_warning = "第三阶段！"
	L.phase3_trigger = "凝视死亡的真正面孔吧，你们的末日就要来了！"

	L.portal = "传送门"
	L.portal_desc = "当传送门时发出警报。"
	L.portal_trigger = "通往%s思维的传送门打开了！"
	L.portal_message = "开启传送门！"
	L.portal_bar = "<下一传送门>"

	L.fervor_cast_message = "正在施放 萨拉的热情：>%s<！"
	L.fervor_message = "萨拉的热情：>%s<！"

	L.sanity_message = ">你< 即将疯狂！"

	L.weakened = "昏迷"
	L.weakened_desc = "当尤格-萨隆昏迷时发出警报。"
	L.weakened_message = "昏迷：>%s<！"
	L.weakened_trigger = "幻象消散，通往中央房间的道路开启了！"

	L.madness_warning = "5秒后，疯狂诱导！"
	L.malady_message = "心灵疾病：>%s<！"

	L.tentacle = "粉碎触须"
	L.tentacle_desc = "当粉碎触须出现时发出警报。"
	L.tentacle_message = "粉碎触须：>%d<！"

	L.link_warning = ">你< 心智链接！"

	L.gaze_bar = "<疯乱凝视 冷却>"
	L.empower_bar = "<暗影信标 冷却>"

	L.guardian_message = "召唤卫士：>%d<！"

	L.empowericon_message = "暗影信标 消退！"

	L.roar_warning = "5秒后，震耳咆哮！"
	L.roar_bar = "<下一震耳咆哮>"
end
