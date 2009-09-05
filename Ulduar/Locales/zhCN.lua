if true then return end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Algalon", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
	phase = "阶段",
	phase_desc = "当进入不同阶段时发出警报。",
	engage_warning = "第一阶段！",
	phase2_warning = "即将 第二阶段！",
	phase_bar = "<阶段%d>",
--	engage_trigger = "Your actions are illogical. All possible results for this encounter have been calculated. The Pantheon will receive the Observer's message regardless of outcome.",

	punch_message = "相位冲压%2$d层：>%1$s<！",
	smash_message = "即将 宇宙重击！",
	blackhole_message = "黑洞爆炸：>%dx< 出现！",
	bigbang_soon = "即将 大爆炸！",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Auriaya", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
	fear_warning = "即将 惊骇尖啸！",
	fear_message = "正在施放 惊骇尖啸！",
	fear_bar = "<惊骇尖啸 冷却>",

	swarm_message = "守护虫群",
	swarm_bar = "<守护虫群 冷却>",

	defender = "野性防御者",
	defender_desc = "当野性防御者出现时发出警报。",
	defender_message = "野性防御者（%d/9）！",

	sonic_bar = "<音速尖啸>",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Freya", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
--	engage_trigger1 = "The Conservatory must be protected!",
--	engage_trigger2 = "Elders grant me your strength!",

	phase = "阶段",
	phase_desc = "当进入不同阶段发出警报。",
	phase2_message = "第二阶段！",

	wave = "波",
	wave_desc = "当一波小怪时发出警报。",
	wave_bar = "<下一波>",
--	conservator_trigger = "Eonar, your servant requires aid!",
--	detonate_trigger = "The swarm of the elements shall overtake you!",
--	elementals_trigger = "Children, assist me!",
--	tree_trigger = "A |cFF00FFFFLifebinder's Gift|r begins to grow!",
	conservator_message = "Conservator!",
	detonate_message = "Detonating lashers!",
	elementals_message = "古代水之精魂！",

	tree = "艾欧娜尔的礼物",
	tree_desc = "当弗蕾亚召唤艾欧娜尔的礼物时发出警报。",	
	tree_message = "艾欧娜尔的礼物 出现！",

	fury_message = "自然之怒",
	fury_other = "自然之怒：>%s<！",

	tremor_warning = "即将 大地震颤！",
	tremor_bar = "<下一大地震颤>",
	energy_message = ">你<不稳定的能量！",
	sunbeam_message = "即将 阳光！",
	sunbeam_bar = "<下一阳光>",

	icon = "位置标记",
	icon_desc = "为中了阳光的队员打上团队标记。（需要权限）",

--	end_trigger = "His hold on me dissipates. I can see clearly once more. Thank you, heroes.",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Hodir", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
--	engage_trigger = "You will suffer for this trespass!",

	cold = "刺骨之寒（成就）",
	cold_desc = "当你受到2层刺骨之寒效果时发出警报。",
	cold_message = "刺骨之寒（%d层） - 移动！",

	flash_warning = "急速冻结！",
	flash_soon = "5秒后，急速冻结！",

	hardmode = "困难模式",
	hardmode_desc = "显示困难模式计时器。",

	icon = "团队标记",
	icon_desc = "为中了风暴雷云的队员打上团队标记。（需要权限）",

--	end_trigger = "I...I am released from his grasp! At...last!",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Ignis", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
--	engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!",

	construct_message = "即将 铁铸像！",
	construct_bar = "<下一铸像>",
	brittle_message = "铁铸像 - 脆弱！",
	flame_bar = "<烈焰喷射 冷却>",
	scorch_message = ">你< 灼烧！",
	scorch_soon = "约5秒后，灼烧！",
	scorch_bar = "<下一灼烧>",
	slagpot_message = "熔渣炉：>%s<！",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Iron Council", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
--	engage_trigger1 = "You will not defeat the Assembly of Iron so easily, invaders!",
--	engage_trigger2 = "Nothing short of total decimation will suffice!",
--	engage_trigger3 = "Whether the world's greatest gnats or the world's greatest heroes, you're still only mortal!",

	overload_message = "6秒后，过载！",
	death_message = ">你< 死亡符文！",
	summoning_message = "闪电元素即将出现！",

	chased_other = "闪电之藤：>%s<！",
	chased_you = ">你< 闪电之藤！",

	overwhelm_other = "压倒能量：>%s<！",

	shield_message = "符文之盾！",

	icon = "团队标记",
	icon_desc = "为中了闪电之藤的队员打上团队标记。（需要权限）",

	council_dies = "%s被击败了！",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Kologarn", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
	arm = "手臂死亡",
	arm_desc = "当左右手臂死亡时发出警报。",
	left_dies = "左臂死亡！",
	right_dies = "右臂死亡！",
	left_wipe_bar = "<左臂重生>",
	right_wipe_bar = "<右臂重生>",

	shockwave = "震荡波",
	shockwave_desc = "当震荡波到来前发出警报。",
--	shockwave_trigger = "Oblivion!",

	eyebeam = "聚焦视线",
	eyebeam_desc = "当玩家中了聚焦视线时发出警报。",
--	eyebeam_trigger = "%s focuses his eyes on you!",
	eyebeam_message = "聚焦视线：>%s<！",
	eyebeam_bar = "<聚焦视线>",
	eyebeam_you = ">你< 聚焦视线！",
	eyebeam_say = ">我< 聚焦视线！",

	eyebeamsay = "聚焦视线",
	eyebeamsay_desc = "当你中了聚焦视线时发出自身警报。",

	armor_message = "粉碎护甲%2$d层：>%1$s<！",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Flame Leviathan", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
--	engage_trigger = "^Hostile entities detected.",
	engage_message = "%s已激怒！",

	pursue = "追踪",
	pursue_desc = "当烈焰巨兽追踪玩家时发出警报。",
--	pursue_trigger = "^%%s被追踪",
	pursue_other = "烈焰巨兽追踪：>%s<！",

	shutdown_message = "系统关闭！",
} end)

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Mimiron", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
	phase = "阶段",
	phase_desc = "当进入不同阶段发出警报。",
	engage_warning = "第一阶段！",
--	engage_trigger = "^We haven't much time, friends!",
	phase2_warning = "即将 第二阶段！",
--	phase2_trigger = "^WONDERFUL! Positively marvelous results!",
	phase3_warning = "即将 第三阶段！",
--	phase3_trigger = "^Thank you, friends!",
	phase4_warning = "即将 第四阶段！",
--	phase4_trigger = "^Preliminary testing phase complete",
	phase_bar = "<阶段：%d>",

	hardmode = "困难模式计时器",
	hardmode_desc = "显示困难模式计时器。",
--	hardmode_trigger = "^Now why would you go and do something like that?",
	hardmode_message = "已开启困难模式！",
	hardmode_warning = "困难模式结束！",

	plasma_warning = "正在施放 等离子冲击！",
	plasma_soon = "即将 等离子冲击！",
	plasma_bar = "<等离子冲击>",

	shock_next = "下一震荡冲击！",

	laser_soon = "即将 P3Wx2激光弹幕！",
	laser_bar = "<P3Wx2激光弹幕>",

	magnetic_message = "空中指挥单位 已降落！",

	suppressant_warning = "即将 烈焰遏制！",

	fbomb_soon = "可能即将 冰霜炸弹！",
	fbomb_bar = "<下一冰霜炸弹>",

	bomb_message = "炸弹机器人 出现！",

--	end_trigger = "^It would appear that I've made a slight miscalculation.",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Razorscale", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
--	["Razorscale Controller"] = true,

	phase = "阶段",
	phase_desc = "当锋鳞转换不同阶段时发出警报。",
--	ground_trigger = "Move quickly! She won't remain grounded for long!",
	ground_message = "锋鳞被锁住了！",
--	air_trigger = "Give us a moment to prepare to build the turrets.",
--	air_trigger2 = "Fires out! Let's rebuild those turrets!",
	air_message = "起飞！",
--	phase2_trigger = "Razorscale lands permanently!",
	phase2_message = "第二阶段！",
	phase2_warning = "即将 第二阶段！",
	stun_bar = "<昏迷>",

--	breath_trigger = "%s takes a deep breath...",
	breath_message = "烈焰喷射！",
	breath_bar = "<烈焰喷射 冷却>",

	flame_message = ">你< 吞噬烈焰！",

	harpoon = "魚叉炮台",
	harpoon_desc = "当魚叉炮台可用时发出警报。",
	harpoon_message = "魚叉炮台：>%d<可用！",
--	harpoon_trigger = "Harpoon Turret is ready for use!",
	harpoon_nextbar = "<魚叉炮台：%d>",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Thorim", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
	phase = "阶段",
	phase_desc = "当进入不同阶段发出警报。",
	phase1_message = "第一阶段！",
--	phase2_trigger = "Interlopers! You mortals who dare to interfere with my sport will pay.... Wait--you...",
	phase2_message = "第二阶段 - 6分15秒后，狂暴！",
--	phase3_trigger = "Impertinent whelps, you dare challenge me atop my pedestal? I will crush you myself!",
	phase3_message = "第三阶段 - %s已激怒！",

	hardmode = "困难模式",
	hardmode_desc = "显示困难模式计时器。",
	hardmode_warning = "困难模式结束！",

	shock_message = ">你< 闪电震击！移动！",
	barrier_message = "符文巨像 - 符文屏障！",

	detonation_say = "我是炸弹！",

	charge_message = "闪电充能：>%d<！",
	charge_bar = "<闪电充能：%d>",

	strike_bar = "<重压打击 冷却>",

--	end_trigger = "Stay your arms! I yield!",

	icon = "团队标记",
	icon_desc = "为中了符文爆炸的队员打上团队标记。（需要权限）",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: General Vezax", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
--	["Vezax Bunny"] = true, -- For emote catching.

--	engage_trigger = "^Your destruction will herald a new age of suffering!",

	surge_message = "黑暗涌动：>%d<！",
	surge_cast = "正在施放 黑暗涌动：>%d<！",
	surge_bar = "<黑暗涌动：%d>",

	animus = "萨隆邪铁畸体",
	animus_desc = "当萨隆邪铁畸体出现时发出警报。",
--	animus_trigger = "The saronite vapors mass and swirl violently, merging into a monstrous form!",
	animus_message = "萨隆邪铁畸体 出现！",

	vapor = "萨隆邪铁蒸汽",
	vapor_desc = "当萨隆邪铁蒸汽出现时发出警报。",
	vapor_message = "萨隆邪铁蒸汽：>%d<！",
	vapor_bar = "<萨隆邪铁蒸汽：%d/6>",
--	vapor_trigger = "A cloud of saronite vapors coalesces nearby!",

	vaporstack = "萨隆邪铁蒸汽堆叠",
	vaporstack_desc = "当玩家中了5层或更多萨隆邪铁蒸汽时发出警报。",
	vaporstack_message = "萨隆邪铁蒸汽：>x%d<！",

	crash_say = ">我< 暗影冲撞！",

	crashsay = "自身暗影冲撞",
	crashsay_desc = "当你中了暗影冲撞时发出说话警报。",

	crashicon = "暗影冲撞标记",
	crashicon_desc = "为中了暗影冲撞的队员打上蓝色方框团队标记。（需要权限）",

	mark_message = "Mark",
	mark_message_other = "无面者的印记：>%s<！",

	icon = "团队标记",
	icon_desc = "为中了暗影冲撞的队员打上团队标记。（需要权限）",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: XT-002", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
	exposed_warning = "即将 暴露心脏！",
	exposed_message = "暴露心脏！",

	gravitybomb_other = "重力炸弹：>%s<！",

	gravitybombicon = "重力炸弹标记",
	gravitybombicon_desc = "为中了重力炸弹的玩家打上蓝色方框标记。（需要权限）",

	lightbomb_other = "灼热之光：>%s<！",

	tantrum_bar = "<发脾气 冷却>",
} end )

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Yogg-Saron", "enUS", true)
L:RegisterTranslations("zhCN", function() return {
	["Crusher Tentacle"] = "重压触须",
--	["The Observation Ring"] = true,

	phase = "阶段",
	phase_desc = "当阶段改变发出警报。",
	engage_warning = "第一阶段！",
--	engage_trigger = "^The time to",
	phase2_warning = "第二阶段！",
--	phase2_trigger = "^I am the lucid dream",
	phase3_warning = "第三阶段！",
--	phase3_trigger = "^Look upon the true face",

	portal = "传送门",
	portal_desc = "当传送门时发出警报。",
--	portal_trigger = "Portals open into Yogg-Saron's mind!",
	portal_message = "开启传送门！",
	portal_bar = "<下一传送门>",

	sanity_message = ">你< 即将疯狂！",

	weakened = "昏迷",
	weakened_desc = "当尤格-萨隆昏迷时发出警报。",
	weakened_message = "昏迷：>%s<！",
--	weakened_trigger = "The Illusion shatters and a path to the central chamber opens!",

	madness_warning = "5秒后，疯狂诱导！",
	malady_message = "心灵疾病：>%s<！",

	tentacle = "粉碎触须",
	tentacle_desc = "当粉碎触须出现时发出警报。",
	tentacle_message = "粉碎触须：>%d<！",

	link_warning = ">你< 心智链接！",

	gaze_bar = "<疯乱凝视 冷却>",
	empower_bar = "<暗影信标 冷却>",

	guardian_message = "召唤卫士：>%d<！",

	empowericon = "暗影信标标记",
	empowericon_desc = "为中了暗影信标的不朽守护者打上骷髅标记。（需要权限）.",
	empowericon_message = "暗影信标 消退！",

	roar_warning = "5秒后，震耳咆哮！",
	roar_bar = "<下一震耳咆哮>",
} end )
