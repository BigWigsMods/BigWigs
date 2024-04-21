local L = BigWigsAPI:NewLocale("BigWigs", "zhCN")
if not L then return end

-- Core.lua
L.berserk = "狂暴"
L.berserk_desc = "为首领狂暴显示计时器和警报。"
L.altpower = "交替能量显示"
L.altpower_desc = "显示交替能量窗口，可以显示团队成员交替能量计数。"
L.infobox = "信息盒"
L.infobox_desc = "显示当前战斗相关的信息。"
L.stages = "阶段"
L.stages_desc = "启用与首领战斗的各个阶段相关的功能，如阶段变化警告、阶段持续时间计时器等。"
L.warmup = "预备"
L.warmup_desc = "首领战斗开始前预备时间。"
L.proximity = "近距离"
L.proximity_desc = "显示近距离窗口，列出距离你很近的玩家。"
L.adds = "增援"
L.adds_desc = "启用与首领战斗中出现的各种增援相关的功能。"
L.health = "血量"
L.health_desc = "启用与首领战斗时显示血量变化信息。"

L.already_registered = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%s|r）在 BigWigs 中已经存在，但该模块仍试图重新注册。这可能是因为更新失败，导致您的插件文件夹中同时存在两份相同模块的拷贝。建议删除所有 BigWigs 文件夹并重新安装。"
L.testNameplate = "检测到目标，在目标姓名板上创建一个测试计时条。 |cFF33FF99此功能很少用到，而且通常一次只存在一个计时条，用于追踪同时存在的多个目标的同个技能。|r"

-- Loader / Options.lua
L.officialRelease = "你所使用的 BigWigs %s 为官方正式版（%s）"
L.alphaRelease = "你所使用的 BigWigs %s 为“α测试版”（%s）"
L.sourceCheckout = "你所使用的 BigWigs %s 是从原始代码仓库直接下载的。"
L.guildRelease = "你正在使用 BigWigs 公会版，版本 %d ，其基于官方版本 %d 。"
L.getNewRelease = "你的 BigWigs 已过期（/bwv）但是可以使用 CurseForge 客户端轻松升级。另外，也可以从 curseforge.com 或 wowinterface.com 手动升级。"
L.warnTwoReleases = "你的 BigWigs 已过期2个发行版！你的版本可能有错误，功能缺失或不正确的计时器。所以强烈建议你升级。"
L.warnSeveralReleases = "|cffff0000你的 BigWigs 已过期 %d 个发行版！！我们*强烈*建议你更新，以防止把问题同步给其他玩家！|r"
L.warnOldBase = "你正在使用公会版本 BigWigs（%d），但是它是基于官方版本（%d）已过期 %d 个版本。可能出现一些问题。"

L.tooltipHint = "|cffeda55f右击|r打开选项。"
L.activeBossModules = "激活首领模块："

L.oldVersionsInGroup = "在你队伍里有人使用了旧版本或没有使用 BigWigs。你可以用 /bwv 获得详细信息。"
L.upToDate = "已更新："
L.outOfDate = "过期："
L.dbmUsers = "DBM 用户："
L.noBossMod = "没有首领模块："
L.offline = "离线"

L.missingAddOn = "你缺少 |cFF436EEE%s|r 插件!"
L.disabledAddOn = "你的 |cFF436EEE%s|r 插件已禁用，计时器将无法显示。"
L.removeAddOn = "请移除“|cFF436EEE%s|r”，其已被“|cFF436EEE%s|r”所替代。"
L.alternativeName = "%s（|cFF436EEE%s|r）"

L.expansionNames = {
	"经典旧世", -- Classic
	"燃烧的远征", -- The Burning Crusade
	"巫妖王之怒", -- Wrath of the Lich King
	"大地的裂变", -- Cataclysm
	"熊猫人之谜", -- Mists of Pandaria
	"德拉诺之王", -- Warlords of Draenor
	"军团再临", -- Legion
	"争霸艾泽拉斯", -- Battle for Azeroth
	"暗影国度", -- Shadowlands
	"巨龙时代", -- Dragonflight
	"地心之战", -- The War Within
}
L.currentSeason = "当前赛季"

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "当心（奥尔加隆）"
L.FlagTaken = "夺旗（PvP）"
L.Destruction = "毁灭（基尔加丹）"
L.RunAway = "快跑吧小姑娘，快跑……（大灰狼）"
L.spell_on_you = "BigWigs：法术在你身上"
L.spell_under_you = "BigWigs：法术在你脚下"

-- Options.lua
L.options = "选项"
L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
L.raidBosses = "团队首领"
L.dungeonBosses = "地下城首领"
L.introduction = "欢迎使用 BigWigs 戏弄各个首领。请系好安全带，吃吃花生并享受这次旅行。它不会吃了你的孩子，但会协助你的团队与新的首领进行战斗就如同享受饕餮大餐一样。"
L.toggleAnchorsBtnShow = "显示移动锚点"
L.toggleAnchorsBtnHide = "隐藏移动锚点"
L.toggleAnchorsBtnShow_desc = "显示全部移动锚点，允许移动计时条、信息等。"
L.toggleAnchorsBtnHide_desc = "隐藏全部移动锚点，锁定一切就位。"
L.testBarsBtn = "创建测试计时条"
L.testBarsBtn_desc = "创建一个测试计时条以便于测试当前显示设置。"
L.sound = "音效"
L.minimapIcon = "小地图图标"
L.minimapToggle = "打开或关闭小地图图标。"
L.compartmentMenu = "隐藏暴雪插件收纳按钮"
L.compartmentMenu_desc = "关闭此选项将会启用暴雪的小地图插件收纳功能。我们推荐你启用这个选项，隐藏暴雪插件收纳按钮。"
L.configure = "配置"
L.test = "测试"
L.resetPositions = "重置位置"
L.colors = "颜色"
L.selectEncounter = "选择战斗"
L.listAbilities = "列出技能到团队聊天"

L.dbmFaker = "伪装成 DBM 用户"
L.dbmFakerDesc = "如果 DBM 用户进行版本检查，看看谁在使用 DBM，他们会看到你的列表上。当公会强制使用 DBM 时非常有用。"
L.zoneMessages = "显示区域信息"
L.zoneMessagesDesc = "禁用此项 BigWigs 在进入新区域时将停止显示已有计时器。建议不要关闭此选项，因为可能在进入新的区域时需要创建新的计时器，这是非常有帮助的。"
L.englishSayMessages = "英文喊话"
L.englishSayMessagesDesc = "在首领战中所有以“大喊”与“说”发送的提示信息都会以英文发送，这对多语言的团队非常有用。"

L.slashDescTitle = "|cFFFED000命令行：|r"
L.slashDescPull = "|cFFFED000/pull:|r 发送拉怪倒数提示到团队。"
L.slashDescBreak = "|cFFFED000/break:|r 发送休息时间到团队。"
L.slashDescRaidBar = "|cFFFED000/raidbar:|r 发送自定义计时条到团队。"
L.slashDescLocalBar = "|cFFFED000/localbar:|r 创建一个只有自身可见的自定义计时条。"
L.slashDescRange = "|cFFFED000/range:|r 开启范围侦测。"
L.slashDescVersion = "|cFFFED000/bwv:|r 进行 BigWigs 版本检测。"
L.slashDescConfig = "|cFFFED000/bw:|r 开启 BigWigs 配置。"

L.gitHubDesc = "|cFF33FF99BigWigs 是一个在 GitHub 上的开源软件。我们一直在寻找新的朋友帮助我们和欢迎任何人检测我们的代码，做出贡献和提交错误报告。BigWigs 今天的伟大很大程度上一部分因为伟大的魔兽世界社区帮助我们。|r"

L.BAR = "计时条"
L.MESSAGE = "信息"
L.ICON = "标记"
L.SAY = "说"
L.FLASH = "闪烁"
L.EMPHASIZE = "醒目"
L.ME_ONLY = "只对自身"
L.ME_ONLY_desc = "当启用此选项时只有对你有影响的技能信息才会被显示。比如，“炸弹：玩家”将只会在你是炸弹时显示。"
L.PULSE = "脉冲"
L.PULSE_desc = "除了闪屏之外，也可以使特定技能的图标随之显示在你的屏幕上，以提高注意力。"
L.MESSAGE_desc = "大多数首领技能带有若干个 BigWigs 可以显示的信息。如果禁用此选项，则此技能的任何信息都不会显示。"
L.BAR_desc = "当遇到某些技能时计时条将会适当显示。如果这个功能伴随着你想要隐藏的计时条，禁用此选项。"
L.FLASH_desc = "有些技能可能比其他的更重要。如果想这些重要技能施放时屏幕进行闪烁，选中此选项。"
L.ICON_desc = "BigWigs 可以根据技能用图标标记人物。这将使他们更容易被辨认。"
L.SAY_desc = "聊天泡泡容易辨认。BigWigs 将使用说的信息方式通知给附近的人告诉他们你中了什么技能。"
L.EMPHASIZE_desc = "启用这些将醒目具有这种能力相关的任何信息。使它们更大和更可见。可以在主选项的“信息”设置醒目信息的大小和的字体。"
L.PROXIMITY = "近距离显示"
L.PROXIMITY_desc = "有些技能有时会要求团队散开。近距离显示为这些技能独立的设置一个窗口告诉你谁离你过近是并且是不安全的。"
L.ALTPOWER = "交替能量显示"
L.ALTPOWER_desc = "一些首领战斗团队中的玩家将用到交替能量方式。交替能量显示提供了玩家最少/最多交替能量的快速预览，可以帮助特定的战术或分配。"
L.TANK = "只对坦克"
L.TANK_desc = "有些技能只对坦克重要。如想看到这些技能警报而无视你的职业，禁用此选项。"
L.HEALER = "只对治疗"
L.HEALER_desc = "有些技能只对治疗重要。如想看到这些技能警报而无视你的职业，禁用此选项。"
L.TANK_HEALER = "只对坦克和治疗"
L.TANK_HEALER_desc = "有些技能只对坦克和治疗重要。如想看到这些技能警报而无视你的职业，禁用此选项。"
L.DISPEL = "只对驱散和打断"
L.DISPEL_desc = "如果希望看到你不能打断和驱散的技能警报，禁用此选项。"
L.VOICE = "语音"
L.VOICE_desc = "如果安装了语音插件，此选项可以开启并播放警报音效文件。"
L.COUNTDOWN = "倒数"
L.COUNTDOWN_desc = "如启用，将增加最少5秒的语音和可见倒数。想像一下某人倒数“5…4…3…2…1…”时在屏幕中间显示大数字。"
L.CASTBAR_COUNTDOWN = "施法条倒数计时"
L.CASTBAR_COUNTDOWN_desc = "启用后，为施法条的最后五秒显示巨大的文字与语音倒数。"
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = "音效"
L.SOUND_desc = "首领技能通常会播放音效来帮助你注意到它。如禁用此选项，不会在游戏时附加音效。"
L.CASTBAR = "施法条"
L.CASTBAR_desc = "施法条会在某些首领战斗中出现，一些即将到来的重要技能通常会引起注意。如果想隐藏此技能相关的施法条，请禁用此选项。"
L.SAY_COUNTDOWN = "说话冷却"
L.SAY_COUNTDOWN_desc = "聊天泡泡很容易被发现。BigWigs 将使用多个说话消息倒计时提醒附近的人身上的技能即将到期。"
L.ME_ONLY_EMPHASIZE = "醒目（自身）"
L.ME_ONLY_EMPHASIZE_desc = "启用此选项将醒目如只作用于自身相关技能的任一信息，使它们更大更明显。"
L.NAMEPLATEBAR = "姓名板条"
L.NAMEPLATEBAR_desc = "当多个怪物施放相同的法术时，有时会在姓名板上附加条。如果此技能要伴随姓名板条隐藏，则禁用此选项。"
L.PRIVATE = "私有光环"
L.PRIVATE_desc = "私有光环无法用常规手段追踪，但可以在音效分页指定“只对自身”的音效。"

L.advanced = "高级选项"
L.back = "<< 返回"

L.tank = "|cFFFF0000只警报坦克。|r"
L.healer = "|cFFFF0000只警报治疗。|r"
L.tankhealer = "|cFFFF0000只警报坦克和治疗。|r"
L.dispeller = "|cFFFF0000只警报驱散和打断。|r"

-- Statistics
L.statistics = "统计"
L.LFR = "随机团队"
L.normal = "普通"
L.heroic = "英雄"
L.mythic = "史诗"
L.wipes = "团灭："
L.kills = "击杀："
L.best = "最快："
