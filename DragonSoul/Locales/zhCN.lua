local L = BigWigs:NewBossLocale("Morchok", "zhCN")
if not L then return end
if L then
	L.engage_trigger = "你妄想阻止雪崩。我只会埋葬你。"

	L.crush = "破甲"
	L.crush_desc = "只警报坦克。破甲堆叠计数并显示持续条。"
	L.crush_message = "%2$d层破甲：>%1$s<！"

	L.blood = "大地黑血"

	L.explosion = "爆裂水晶"
end

L = BigWigs:NewBossLocale("Warlord Zon'ozz", "zhCN")
if L then
	L.engage_trigger = "Zzof Shuul'wah. Thoq fssh N'Zoth!"

	L.ball = "末日黑洞"
	L.ball_desc = "末日黑洞在玩家和首领之间来回弹跳时发出警报。"

	L.bounce = "末日黑洞弹跳"
	L.bounce_desc = "末日黑洞弹跳计数。"

	L.darkness = "触手迪斯科聚会！"
	L.darkness_desc = "当此阶段开始，末日黑洞撞击首领。"

	L.shadows = "干扰之影"
end

L = BigWigs:NewBossLocale("Yor'sahj the Unsleeping", "zhCN")
if L then
	L.engage_trigger = "Iilth qi'uothk shn'ma yeh'glu Shath'Yar! H'IWN IILTH!"

	L.bolt_desc = "只警报坦克。虚空箭堆叠计数并显示持续条。"
	L.bolt_message = "%2$d层虚空箭：>%1$s<！"

	L.blue = "|cFF0080FF蓝|r"
	L.green = "|cFF088A08绿|r"
	L.purple = "|cFF9932CD粉|r"
	L.yellow = "|cFFFFA901黄|r"
	L.black = "|cFF424242黑|r"
	L.red = "|cFFFF0404红|r"

	L.blobs = "血球"
	L.blobs_bar = "下一血球"
	L.blobs_desc = "当血球向首领移动时发出警报。"
end

L = BigWigs:NewBossLocale("Hagara the Stormbinder", "zhCN")
if L then
	L.engage_trigger = "你们竟敢挑战缚风者！我要杀光你们。"

	L.lightning_or_frost = "闪电或寒冰"
	L.ice_next = "寒冰阶段"
	L.lightning_next = "闪电阶段"

	L.assault_desc = "只警报坦克。"..select(2, EJ_GetSectionInfo(4159))

	L.nextphase = "下一阶段"
	L.nextphase_desc = "当下一阶段时发出警报。"
end

L = BigWigs:NewBossLocale("Ultraxion", "zhCN")
if L then
	L.engage_trigger = "暮光审判降临了！"

	L.warmup = "暮光审判"
	L.warmup_desc = "暮光审判计时器。"
	L.warmup_trigger = "I am the beginning of the end...the shadow which blots out the sun"

	L.crystal = "增益水晶"
	L.crystal_desc = "守护巨龙召唤各种增益水晶计时器。"
	L.crystal_red = "生命赐福红水晶"
	L.crystal_green = "梦境精华绿水晶"
	L.crystal_blue = "魔力之源蓝水晶"

	L.twilight = "暮光审判"
	L.cast = "暮光审判施法条"
	L.cast_desc = "显示暮光审判5秒施法条。"

	L.lightyou = "自身黯淡之光"
	L.lightyou_desc = "显示自身黯淡之光爆炸剩余计时条。"
	L.lightyou_bar = "<你将爆炸>"

	L.lighttank = "坦克黯淡之光"
	L.lighttank_desc = "只警报坦克。如果坦克中了黯淡之光，显示一个爆炸计时条及闪屏震动。"
	L.lighttank_bar = "<%s 爆炸>"
	L.lighttank_message = "坦克爆炸！"
end

L = BigWigs:NewBossLocale("Warmaster Blackhorn", "zhCN")
if L then
	L.harpooning = "鱼叉炮"

	L.rush = "邪刃冲击"

	L.sunder = "破甲攻击"
	L.sunder_desc = "只警报坦克。破甲攻击堆叠计数并显示持续条。"
	L.sunder_message = "%2$d层破甲攻击：>%1$s<！"

	L.sapper_trigger = "A drake swoops down to drop a Twilight Sapper onto the deck!"
	L.sapper = "暮光工兵"
	L.sapper_desc = "暮光工兵对天火号造成伤害。"

	L.stage2_trigger = "Looks like I'm doing this myself. Good!"
end

L = BigWigs:NewBossLocale("Spine of Deathwing", "zhCN")
if L then
	L.left_start = "即将左侧翻滚"
	L.right_start = "即将右侧翻滚"
	L.left = "左侧翻滚"
	L.right = "右侧翻滚"
	L.not_hooked = ">你< 没有抓牢！"
	L.roll_message = "他开始滚了！滚了，滚啦！"
	L.level_trigger = "levels out"
	L.level_message = "别急，他已经平稳了！"

	L.exposed = "装甲暴露"
end

L = BigWigs:NewBossLocale("Madness of Deathwing", "zhCN")
if L then
	L.impale_desc = "只警报坦克。"..select(2,EJ_GetSectionInfo(4114))
end

