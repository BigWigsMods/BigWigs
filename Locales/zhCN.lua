local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs", "zhCN")
if not L then return end

-- API.lua
L.showAddonBar = "'%s' 插件创建了 '%s' 动作条。"

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
L.energy = "能量"
L.energy_desc = "启用与首领战斗中各种能量等级信息的功能。"

L.already_registered = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%s|r）在 BigWigs 中已经存在，但该模块仍试图重新注册。这可能是因为更新失败，导致您的插件文件夹中同时存在两份相同模块的拷贝。建议删除所有 BigWigs 文件夹并重新安装。"

-- Loader / Options.lua
L.okay = "确定"
L.officialRelease = "你所使用的 BigWigs %s 为官方正式版（%s）。"
L.alphaRelease = "你所使用的 BigWigs %s 为“α测试版”（%s）。"
L.sourceCheckout = "你所使用的 BigWigs %s 是从原始代码仓库直接下载的。"
L.littlewigsOfficialRelease = "你所使用的 LittleWigs 为官方正式版（%s）。"
L.littlewigsAlphaRelease = "你所使用的 LittleWigs 为“α测试版”（%s）。"
L.littlewigsSourceCheckout = "你所使用的 LittleWigs 是从原始代码仓库直接下载的。"
L.guildRelease = "你正在使用 BigWigs 公会版，版本 %d ，其基于官方版本 %d 。"
L.getNewRelease = "你的 BigWigs 已过期（/bwv）但是可以使用 CurseForge 客户端轻松升级。另外，也可以从 curseforge.com 或 addons.wago.io 手动升级。"
L.warnTwoReleases = "你的 BigWigs 已过期2个发行版！你的版本可能有错误，功能缺失或不正确的计时器。所以强烈建议你升级。"
L.warnSeveralReleases = "|cffff0000你的 BigWigs 已过期 %d 个发行版！！我们*强烈*建议你更新，以防止把问题同步给其他玩家！|r"
L.warnOldBase = "你正在使用公会版本 BigWigs（%d），但是它是基于官方版本（%d）已过期 %d 个版本。可能出现一些问题。"

L.tooltipHint = "|cffeda55f右击|r打开选项。"
L.activeBossModules = "激活首领模块："

L.oldVersionsInGroup = "在你队伍里有人使用了 |cffff0000旧版本|r 的 BigWigs。你可以使用 /bwv 名字获得详细信息。"
L.upToDate = "已更新："
L.outOfDate = "过期："
L.dbmUsers = "DBM 用户："
L.noBossMod = "没有首领模块："
L.offline = "离线"

L.missingAddOnPopup = "你缺少 |cFF436EEE%s|r 插件!"
L.missingAddOnRaidWarning = "你缺少 |cFF436EEE%s|r 插件！此区域将不显示计时条！"
L.outOfDateAddOnPopup = "|cFF436EEE%s|r 插件已过期！"
L.outOfDateAddOnRaidWarning = "|cFF436EEE%s|r 插件已过期！您当前版本 v%d.%d.%d，最新版本 v%d.%d.%d！"
L.disabledAddOn = "你的 |cFF436EEE%s|r 插件已禁用，计时器将无法显示。"
L.removeAddOn = "请移除“|cFF436EEE%s|r”，其已被“|cFF436EEE%s|r”所替代。"
L.alternativeName = "%s（|cFF436EEE%s|r）"
L.outOfDateContentPopup = "警告！\n你更新了 |cFF436EEE%s|r 但你还需要更新 |cFF436EEEBigWigs|r 主插件。\n忽略这一点将导致功能崩溃。"
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r 需要安装 %d 版本的 |cFF436EEEBigWigs|r 主插件才能正常运行，但你使用了 %d 版本。"
L.addOnLoadFailedWithReason = "BigWigs 未能加载 |cFF436EEE%s|r 插件，原因： %q。请通知 BigWigs 的开发者！"
L.addOnLoadFailedUnknownError = "BigWigs 在加载 |cFF436EEE%s|r 插件时遇到了错误。请通知 BigWigs 的开发者！"

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
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "地下堡",
	["LittleWigs_CurrentSeason"] = "当前赛季",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "当心（奥尔加隆）"
L.FlagTaken = "夺旗（PvP）"
L.Destruction = "毁灭（基尔加丹）"
L.RunAway = "快跑吧小姑娘，快跑……（大灰狼）"
L.spell_on_you = "BigWigs：法术在你身上"
L.spell_under_you = "BigWigs：法术在你脚下"
L.simple_no_voice = "简单（无语音）"

-- Options.lua
L.options = "选项"
L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
L.raidBosses = "团队首领"
L.dungeonBosses = "地下城首领"
L.introduction = "欢迎使用 BigWigs 戏弄各个首领。请系好安全带，吃吃花生并享受这次旅行。它不会吃了你的孩子，但会协助你的团队与新的首领进行战斗就如同享受饕餮大餐一样。"
L.sound = "音效"
L.minimapIcon = "小地图图标"
L.minimapToggle = "打开或关闭小地图图标。"
L.compartmentMenu = "隐藏暴雪插件收纳按钮"
L.compartmentMenu_desc = "关闭此选项将会启用暴雪的小地图插件收纳功能。我们推荐你启用这个选项，隐藏暴雪插件收纳按钮。"
L.configure = "配置"
L.resetPositions = "重置位置"
L.selectEncounter = "选择战斗"
L.privateAuraSounds = "私有光环音效"
L.privateAuraSounds_desc = "私有光环无法被正常追踪，但你可以设置一个音效，在你被技能锁定时播放。"
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
L.EMPHASIZE_desc = "启用这些将醒目具有这种能力相关的任何信息。使它们更大和更可见。可以在主选项的“信息”设置醒目信息的字体和尺寸。"
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
L.DISPEL = "只对驱散"
L.DISPEL_desc = "如果希望看到你不能驱散的技能警报，禁用此选项。"
L.VOICE = "语音"
L.VOICE_desc = "如果安装了语音插件，此选项可以开启并播放警报音效文件。"
L.COUNTDOWN = "倒数"
L.COUNTDOWN_desc = "如启用，将增加最少5秒的语音和可见倒数。想像一下某人倒数“5…4…3…2…1…”时在屏幕中间显示大数字。"
L.CASTBAR_COUNTDOWN = "施法条倒数计时"
L.CASTBAR_COUNTDOWN_desc = "启用后，为施法条的最后五秒显示巨大的文字与语音倒数。"
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = L.sound
L.SOUND_desc = "首领技能通常会播放音效来帮助你注意到它。如禁用此选项，不会在游戏时附加音效。"
L.CASTBAR = "施法条"
L.CASTBAR_desc = "施法条会在某些首领战斗中出现，一些即将到来的重要技能通常会引起注意。如果想隐藏此技能相关的施法条，请禁用此选项。"
L.SAY_COUNTDOWN = "说话冷却"
L.SAY_COUNTDOWN_desc = "聊天泡泡很容易被发现。BigWigs 将使用多个说话消息倒计时提醒附近的人身上的技能即将到期。"
L.ME_ONLY_EMPHASIZE = "醒目（自身）"
L.ME_ONLY_EMPHASIZE_desc = "启用此选项将醒目如只作用于自身相关技能的任一信息，使它们更大更明显。"
L.NAMEPLATE = "姓名板"
L.NAMEPLATE_desc = "如果启用，与此特定技能的相关图标和文字等功能将显示在姓名板上。这样当有多个NPC施放技能时，就能更容易地看到是哪个特定的NPC在施放。"
L.PRIVATE = "私有光环"
L.PRIVATE_desc = "私有光环无法用常规手段追踪，但可以在音效分页指定只有“私有光环”出现在你身上时的音效。"

L.advanced_options = "高级选项"
L.back = "<< 返回"

L.tank = "|cFFFF0000只警报坦克。|r"
L.healer = "|cFFFF0000只警报治疗。|r"
L.tankhealer = "|cFFFF0000只警报坦克和治疗。|r"
L.dispeller = "|cFFFF0000只警报驱散。|r"

-- Sharing.lua
L.import = "导入"
L.import_info = "导入字符串后，你可以选择要导入的设置。\n如果导入的字符串中有不可使用的设置，则无法选择这些设置。\n\n|cffff4411此导入只会改变你的常规设置，不会改变你对首领的特定设置。|r"
L.import_info_active = "选择要导入的选项，然后点击导入按钮。"
L.import_info_none = "|cFFFF0000导入的字符串不兼容或已过期。|r"
L.export = "导出"
L.export_info = "选择要导出并分享给他人的设置。\n\n|cffff4411您只能分享常规设置，这些设置对首领的特定设置没有影响。|r"
L.export_string = "导出字符串"
L.export_string_desc = "如果要分享设置，请复制此 BigWigs 字符串。"
L.import_string = "导入字符串"
L.import_string_desc = "将要导入的 BigWigs 字符串粘贴到此处。"
L.position = "位置"
L.settings = "设置"
L.other_settings = "其他设置"
L.nameplate_settings_import_desc = "导入所有姓名板设置。"
L.nameplate_settings_export_desc = "导出所有姓名板设置。"
L.position_import_bars_desc = "导入 计时条 的位置（锚点）。"
L.position_import_messages_desc = "导入 信息 的位置（锚点）。"
L.position_import_countdown_desc = "导入 倒数 的位置（锚点）。"
L.position_export_bars_desc = "导出 计时条 的位置（锚点）。"
L.position_export_messages_desc = "导出 信息 的位置（锚点）。"
L.position_export_countdown_desc = "导出 倒数 的位置（锚点）。"
L.settings_import_bars_desc = "导入常规 计时条 设置，例如尺寸、字体等。"
L.settings_import_messages_desc = "导入常规 信息 设置，例如尺寸、字体等。"
L.settings_import_countdown_desc = "导入常规 倒数 设置，例如语音、尺寸、字体等。"
L.settings_export_bars_desc = "导出常规 计时条 设置，例如尺寸、字体等。"
L.settings_export_messages_desc = "导出常规 信息 设置，例如尺寸、字体等。"
L.settings_export_countdown_desc = "导出常规 倒数 设置，例如语音、尺寸、字体等。"
L.colors_import_bars_desc = "导入 计时条 的颜色。"
L.colors_import_messages_desc = "导入 信息 的颜色。"
L.color_import_countdown_desc = "导入 倒数 的颜色"
L.colors_export_bars_desc = "导出 计时条 的颜色"
L.colors_export_messages_desc = "导出 信息 的颜色"
L.color_export_countdown_desc = "导出 倒数 的颜色"
L.confirm_import = "您要导入的所选设置将覆盖您当前所选配置文件：\n\n|cFF33FF99\"%s\"|r 中的设置，\n\n您确定要这样做吗？"
L.confirm_import_addon = "插件 |cFF436EEE\"%s\"|r 想要自动导入新的 BigWigs 设置，这些设置将覆盖您当前选择的 BigWigs 的设置：\n\n|cFF33FF99\"%s\"|r\n\n您确定要这样做吗？"
L.confirm_import_addon_new_profile = "插件 |cFF436EEE\"%s\"|r 想自动创建一个名为：\n\n|cFF33FF99\"%s\"|r 的新 BigWigs 配置文件，\n\n 接受此新配置文件也会替换为它。"
L.confirm_import_addon_edit_profile = "插件 |cFF436EEE\"%s\"|r 想要自动编辑您的一个名为：\n\n|cFF33FF99\"%s\"|r 的 BigWigs 配置文件，\n\n 接受这些更改也会替换为它。"
L.no_string_available = "当前没有导入的字符串需要保存。首先导入一个字符串。"
L.no_import_message = "未导入任何设置。"
L.import_success = "导入：%s" -- 导入：计时条、信息颜色、倒数等所有设置
L.imported_bar_positions = "计时条位置"
L.imported_bar_settings = "计时条设置"
L.imported_bar_colors = "计时条颜色"
L.imported_message_positions = "信息位置"
L.imported_message_settings = "信息设置"
L.imported_message_colors = "信息颜色"
L.imported_countdown_position = "倒数位置"
L.imported_countdown_settings = "倒数设置"
L.imported_countdown_color = "倒数颜色"
L.imported_nameplate_settings = "姓名板设置"
L.imported_mythicplus_settings = "史诗钥石设置"
L.mythicplus_settings_import_desc = "导入所有史诗钥石设置。"
L.mythicplus_settings_export_desc = "导出所有史诗钥石设置。"
L.imported_battleres_settings = "战复设置"
L.battleres_settings_import_desc = "导入所有战复设置。"
L.battleres_settings_export_desc = "导入所有战复设置。"

-- Statistics
L.statistics = "统计"
L.defeat = "被击败"   --用回“被击败”，这样显示统一。
L.defeat_desc = "你在与该首领战斗时被击败的总次数。"
L.victory = "获胜"
L.victory_desc = "你在与该首领战斗时获胜的总次数。"
L.fastest = "最快"
L.fastest_desc = "与该首领战斗最快获胜及发生的日期（年/月/日）"
L.first = "首胜"
L.first_desc = "你在与该首领战斗时首次获胜的详细信息，格式为：\n[首次获胜前被团灭次数] - [战斗时间] - [年/月/日 首胜]"

-- Difficulty levels for statistics display on bosses
L.unknown = "未知"
L.LFR = "随机团队"
L.normal = "普通"
L.heroic = "英雄"
L.mythic = "史诗"
L.timewalk = "时空漫游"
L.solotier8 = "单人难度 8"
L.solotier11 = "单人难度 11"
L.story = "剧情"
L.mplus = "史诗+ %d"
L.SOD = "探索赛季"
L.hardcore = "专家模式"
L.level1 = "难度等级 1"
L.level2 = "难度等级 2"
L.level3 = "难度等级 3"
L.N10 = "10人普通"
L.N25 = "25人普通"
L.H10 = "10人英雄"
L.H25 = "25人英雄"

-----------------------------------------------------------------------
-- TOOLS
-----------------------------------------------------------------------

L.tools = "工具"
L.toolsDesc = "BigWigs 提供多种工具和\"便利功能\"，让你可以轻松的简化首领战斗流程。"

-----------------------------------------------------------------------
-- AutoRole.lua
--

L.autoRoleTitle = "自动分配职责"
L.autoRoleExplainer = "当你加入一个队伍，或者在队伍中切换你的天赋专精时，BigWigs 将自动调整你在队伍中的职责（坦克、治疗者、伤害输出者）。\n\n"

-----------------------------------------------------------------------
-- BattleRes.lua
--

L.battleResTitle = "战复"
L.battleResDesc = "新建一个图标，显示可用战复次数及下次获得额外次数所需时间。"
L.battleResDesc2 = "\n你的 |cFF33FF99战复|r 使用记录可以通过将鼠标悬停在图标上时查看。\n\n"
L.battleResHistory = "战复："
L.battleResResetAll = "将所有战复设置重置为默认。"
L.battleResDurationText = "时间文本"
L.battleResChargesText = "次数文本"
L.battleResNoCharges = "0 次可用"
L.battleResHasCharges = "1 次或多次可用"
L.battleResPlaySound = "获得新额外次数时播放音效"
L.iconTextureSpellID = "|T%d:0:0:0:0:64:64:4:60:4:60|t 技能图标（Spell ID）"
L.iconTextureSpellIDError = "你必须输入一个有效的法术ID来作为显示的图标。"
L.battleResModeIcon = "显示模式：图标"
L.battleResModeText = "显示模式：仅文字"
L.battleResModeTextTooltip = "显示临时背景以便调整战复功能的位置，并查看鼠标悬停提示位置。"

-----------------------------------------------------------------------
-- Keystones.lua
--

L.keystoneTitle = "BigWigs 钥石信息"
L.keystoneHeaderParty = "队伍"
L.keystoneRefreshParty = "刷新队伍"
L.keystoneHeaderGuild = "公会"
L.keystoneRefreshGuild = "刷新公会"
L.keystoneLevelTooltip = "钥石等级：|cFFFFFFFF%s|r"
L.keystoneMapTooltip = "地下城：|cFFFFFFFF%s|r"
L.keystoneRatingTooltip = "史诗评分：|cFFFFFFFF%d|r"
L.keystoneHiddenTooltip = "该玩家选择隐藏此信息。"
L.keystoneTabOnline = "在线"
L.keystoneTabAlts = "角色"
L.keystoneTabTeleports = "传送"
L.keystoneHeaderMyCharacters = "我的角色"
L.keystoneTeleportNotLearned = "传送法术 '|cFFFFFFFF%s|r' |cFFFF4411尚未学习|r 。"
L.keystoneTeleportOnCooldown = "传送法术 '|cFFFFFFFF%s|r' 目前处于 |cFFFF4411冷却中|r ，还需 %d 小时 %d 分钟可用。"
L.keystoneTeleportReady = "传送法术 '|cFFFFFFFF%s|r' |cFF33FF99已就绪|r，点击施放。"
L.keystoneTeleportInCombat = "你不能在战斗中传送。"
L.keystoneTabHistory = "历史记录"
L.keystoneHeaderThisWeek = "本周"
L.keystoneHeaderOlder = "更早"
L.keystoneScoreGainedTooltip = "获得评分：|cFFFFFFFF+%d|r\n史诗钥石评分：|cFFFFFFFF%d|r"
L.keystoneCompletedTooltip = "限时完成: |cFFFFFFFF%d分%d秒|r\n时限：|cFFFFFFFF%d分%d秒|r"
L.keystoneFailedTooltip = "超时: |cFFFFFFFF%d分%d秒|r\n时限：|cFFFFFFFF%d分%d秒|r"
L.keystoneExplainer = "一个包含多种工具的集合，旨在提升史诗钥石地下城的游戏体验。"
L.keystoneAutoSlot = "自动插入史诗钥石"
L.keystoneAutoSlotDesc = "打开能量之泉时，自动将你的史诗钥石插入。"
L.keystoneAutoSlotMessage = "已将 %s 自动插入能量之泉。"
L.keystoneAutoSlotFrame = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:14:14|t 史诗钥石已自动插入"
L.keystoneModuleName = "史诗钥石地下城"
L.keystoneStartBar = "%s +%d" -- Format is SHORT_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "ROOK +12"
L.keystoneStartMessage = "%s +%d 挑战开始！" -- Format is LONG_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "The Rookery +12 begins now!"
L.keystoneCountdownExplainer = "当你开始一个史诗钥石地下城时，将会播放倒数语音。请选择你想听到的语音以及你希望倒数何时开始。\n\n"
L.keystoneCountdownBeginsDesc = "史诗钥石地下城的倒数计时器还剩多少时，开始播放倒数语音。"
L.keystoneCountdownBeginsSound = "史诗钥石地下城倒数计时器开始时播放的音效"
L.keystoneCountdownEndsSound = "史诗钥石地下城倒数计时器结束时播放的音效"
L.keystoneViewerTitle = "钥石信息"
L.keystoneHideGuildTitle = "向公会成员隐藏我的钥石信息"
L.keystoneHideGuildDesc = "|cffff4411不推荐。|r 此功能将阻止公会成员看到你拥有的钥石信息。你队伍中的其他成员仍然可以看到它。"
L.keystoneHideGuildWarning = "禁用公会成员查看你钥石信息的功能是 |cffff4411不推荐|r 的。\n\n你确定要这样做吗？"
L.keystoneAutoShowEndOfRun = "史诗钥石地下城结束时显示"
L.keystoneAutoShowEndOfRunDesc = "当史诗钥石地下城结束时自动显示钥石信息。\n\n|cFF33FF99这可以帮助你查看队伍成员获得了哪些新钥石。|r"
L.keystoneViewerExplainer = "你可以使用|cFF33FF99/key|r 命令或点击下方按钮打开钥石信息。\n\n"
L.keystoneViewerOpen = "打开钥石信息"
L.keystoneViewerKeybindingExplainer = "\n\n您也可以设置一个快捷键来打开钥石信息：\n\n"
L.keystoneViewerKeybindingDesc = "选择打开的快捷键。"
L.keystoneClickToWhisper = "点击开启密语窗口"
L.keystoneClickToTeleportNow = "\n点击传送至此"
L.keystoneClickToTeleportCooldown = "\n无法传送，法术尚未冷却"
L.keystoneClickToTeleportNotLearned = "\n无法传送，尚未学会该法术"
L.keystoneHistoryRuns = "总计 %d"
L.keystoneHistoryRunsThisWeekTooltip = "本周地下城总计：|cFFFFFFFF%d|r"
L.keystoneHistoryRunsOlderTooltip = "本周之前地下城总计：|cFFFFFFFF%d|r"
L.keystoneHistoryScore = "分数 +%d"
L.keystoneHistoryScoreThisWeekTooltip = "本周获得的分数：|cFFFFFFFF+%d|r"
L.keystoneHistoryScoreOlderTooltip = "本周之前获得的总分数：|cFFFFFFFF+%d|r"
L.keystoneTimeUnder = "|cFF33FF99-%02d:%02d|r"
L.keystoneTimeOver = "|cFFFF4411+%02d:%02d|r"
L.keystoneTeleportTip = "点击下方地下城名称可直接|cFF33FF99传送|r至地下城入口。"

-- It doesn't really matter what you call it as long as it's recognizable and limited to ~6 characters
L.keystoneShortName_TheRookery = "驭雷栖巢"
L.keystoneShortName_DarkflameCleft = "暗焰裂口"
L.keystoneShortName_PrioryOfTheSacredFlame = "圣焰隐修院"
L.keystoneShortName_CinderbrewMeadery = "燧酿酒庄"
L.keystoneShortName_OperationFloodgate = "水闸行动"
L.keystoneShortName_TheaterOfPain = "伤势剧场"
L.keystoneShortName_TheMotherlode = "暴富矿区"
L.keystoneShortName_OperationMechagonWorkshop = "麦卡贡-车间"
L.keystoneShortName_EcoDomeAldani = "生态圆顶"
L.keystoneShortName_HallsOfAtonement = "赎罪大厅"
L.keystoneShortName_AraKaraCityOfEchoes = "回响之城"
L.keystoneShortName_TazaveshSoleahsGambit = "索·莉亚宏图"
L.keystoneShortName_TazaveshStreetsOfWonder = "琳彩天街"
L.keystoneShortName_TheDawnbreaker = "破晨号"

-- These short names are for the bar that shows during the Mythic+ countdown
-- Use the real dungeon names but make them shorter to fit on the bar better
L.keystoneShortName_TheRookery_Bar = "驭雷栖巢"
L.keystoneShortName_DarkflameCleft_Bar = "暗焰裂口"
L.keystoneShortName_PrioryOfTheSacredFlame_Bar = "圣焰隐修院"
L.keystoneShortName_CinderbrewMeadery_Bar = "燧酿酒庄"
L.keystoneShortName_OperationFloodgate_Bar = "水闸行动"
L.keystoneShortName_TheaterOfPain_Bar = "伤逝剧场"
L.keystoneShortName_TheMotherlode_Bar = "暴富矿区"
L.keystoneShortName_OperationMechagonWorkshop_Bar = "麦卡贡-车间"
L.keystoneShortName_EcoDomeAldani_Bar = "生态圆顶"
L.keystoneShortName_HallsOfAtonement_Bar = "赎罪大厅"
L.keystoneShortName_AraKaraCityOfEchoes_Bar = "回响之城"
L.keystoneShortName_TazaveshSoleahsGambit_Bar = "索·莉亚宏图"
L.keystoneShortName_TazaveshStreetsOfWonder_Bar = "琳彩天街"
L.keystoneShortName_TheDawnbreaker_Bar = "破晨号"

-- Instance Keys "Who has a key?"
L.instanceKeysTitle = "谁拥有钥石？"
L.instanceKeysDesc = "当你进入一个史诗钥石地下城时，拥有该地下城钥石的玩家将会以列表形式显示。\n\n"
L.instanceKeysTest8 = "|cFF00FF98武僧：|r +8"
L.instanceKeysTest10 = "|cFFFF7C0A德鲁伊：|r +10"
L.instanceKeysDisplay = "|c%s%s：|r+%d" -- "PLAYER_NAME: +DUNGEON_LEVEL"
L.instanceKeysDisplayWithDungeon = "|c%s%s：|r+%d（%s）" -- "PLAYER_NAME: +DUNGEON_LEVEL (DUNGEON_NAME)"
L.instanceKeysShowAll = "始终显示所有玩家"
L.instanceKeysShowAllDesc = "启用此选项将显示列表中的所有玩家，即使他们的钥石不属于当前地下城。"
L.instanceKeysOtherDungeonColor = "其他地下城颜色"
L.instanceKeysOtherDungeonColorDesc = "为持有非当前地下城钥石选择字体颜色。"
L.instanceKeysEndOfRunDesc = "默认情况下，列表仅在你进入史诗钥石地下城时显示。启用此选项后，还将在史诗钥石结束后继续显示列表。"
L.instanceKeysHideTitle = "隐藏标题"
L.instanceKeysHideTitleDesc = "隐藏 \"谁拥有钥石？\" 标题。"

-----------------------------------------------------------------------
-- LFGTimer.lua
--

L.lfgTimerTitle = "寻找组队计时器"
L.lfgTimerExplainer = "每当寻找组队队列确认窗口出现时，BigWigs 会创建一个计时条，告诉你还有多长时间必须接受队列。\n\n"
L.lfgUseMaster = "在'主'声道播放寻找组队就绪提示音"
L.lfgUseMasterDesc = "启用此选项后，寻找组队就绪提示音将通过'主'声道播放。如果禁用此选项，则会通过'%s'声道播放。"

-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "一般"
L.advanced = "高级"
L.comma = "，"
L.reset = "重置"
L.resetDesc = "将上述设置重置为默认。"
L.resetAll = "重置所有"
L.startTest = "开始测试"
L.stopTest = "停止测试"
L.always = "总是" -- ALWAYS
L.never = "从不" -- NEVER

L.positionX = "横向位置"
L.positionY = "纵向位置"
L.positionExact = "精确位置"
L.positionDesc = "在框中输入数值或移动滑条精准定位锚点位置。"
L.width = "宽度"
L.height = "高度"
L.size = "尺寸"
L.sizeDesc = "通常情况下，您可以通过移动滑条来设置尺寸。如果需要精确的尺寸，可以使用该滑条下面的数字框中输入数值（需有效数值）。"
L.fontSizeDesc = "使用滑条或在框内输入数值可调整字体尺寸，最大数值为200。"
L.disabled = "禁用"
L.disableDesc = "将禁用“%s”功能，但|cffff4411不建议|r这么做。\n\n你确定要这么做吗？"
L.keybinding = "按键设置"
L.dragToResize = "拖动调整尺寸"
L.cannotMoveInCombat = "你在战斗中时无法移动此框体。"

-- Anchor Points
L.UP = "向上"
L.DOWN = "向下"
L.TOP = "上"
L.RIGHT = "右"
L.BOTTOM = "下"
L.LEFT = "左"
L.TOPRIGHT = "右上"
L.TOPLEFT = "左上"
L.BOTTOMRIGHT = "右下"
L.BOTTOMLEFT = "左下"
L.CENTER = "中"
L.customAnchorPoint = "高级：自定义锚点"
L.sourcePoint = "源点"
L.destinationPoint = "相对锚点"
L.drawStrata = "层级"
L.medium = "中"
L.low = "低"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "交替能量"
L.altPowerDesc = "仅在向玩家应用的首领出现交替能量显示，这极为罕见。将显示您和团队拥有的“交替能量”，其中团队的交替能量以列表显示。要移动或显示框架，请使用下面的测试按钮。"
L.toggleDisplayPrint = "显示将在下次出现。完全禁用此首领战斗，需在首领战斗选项中切换关闭。"
L.disabledDisplayDesc = "禁用全部模块显示。"
L.resetAltPowerDesc = "重置全部交替能量有关选项，包括交替能量锚点位置。"
L.test = "测试"
L.altPowerTestDesc = "显示“交替能量”，可以移动，并模拟在首领战斗时会看到的能量变化。"
L.yourPowerBar = "你的能量条"
L.barColor = "条颜色"
L.barTextColor = "条文本颜色"
L.additionalWidth = "附加宽度"
L.additionalHeight = "附加高度"
L.additionalSizeDesc = "移动此滑条可增加显示的尺寸，或在数字框内输入数值，最大数值为100。"
L.yourPowerTest = "你的能量：%d" -- Your Power: 42
L.yourAltPower = "你的 %s：%d" -- e.g. Your Corruption: 42
L.player = "玩家 %d" -- Player 7
L.disableAltPowerDesc = "全局禁用交替能量显示，任何首领战斗都不会显示它。"

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "自动回复"
L.autoReplyDesc = "在与首领战斗时自动回复密语。"
L.responseType = "回应类型"
L.autoReplyFinalReply = "离开战斗后密语"
L.guildAndFriends = "公会和好友"
L.everyoneElse = "所有人"

L.autoReplyBasic = "正在与首领战斗，很忙。"
L.autoReplyNormal = "正在与“%s”战斗，很忙。"
L.autoReplyAdvanced = "正在与“%s”（%s）战斗，%d/%d人存活。"
L.autoReplyExtreme = "正在与“%s”（%s）战斗，%d/%d人存活：%s"

L.autoReplyLeftCombatBasic = "首领战斗已结束。"
L.autoReplyLeftCombatNormalWin = "与“%s”战斗取得了胜利。"
L.autoReplyLeftCombatNormalWipe = "与“%s”战斗团灭。"
L.autoReplyLeftCombatAdvancedWin = "与“%s”战斗取得了胜利，%d/%d人存活。"
L.autoReplyLeftCombatAdvancedWipe = "与“%s”战斗团灭：%s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.bars = "计时条"
L.style = "风格"
L.bigWigsBarStyleName_Default = "默认"
L.resetBarsDesc = "重置全部计时条有关选项，包括计时条锚点位置。"
L.testBarsBtn = "创建测试计时条"
L.testBarsBtn_desc = "创建一个测试计时条以便于测试当前显示设置。"

L.toggleAnchorsBtnShow = "显示移动锚点"
L.toggleAnchorsBtnHide = "隐藏移动锚点"
L.toggleAnchorsBtnHide_desc = "隐藏全部移动锚点，锁定一切就位。"
L.toggleBarsAnchorsBtnShow_desc = "显示全部移动锚点，允许您移动计时条。"

L.emphasizeAt = "…（秒）后醒目"
L.growingUpwards = "向上成长"
L.growingUpwardsDesc = "切换在锚点向上或向下成长。"
L.texture = "材质"
L.emphasize = L.EMPHASIZE
L.emphasizeMultiplier = "尺寸倍数"
L.emphasizeMultiplierDesc = "如禁用计时条移向醒目锚点，此选项将决定以一般计时条乘以尺寸倍数作为醒目计时条的尺寸。"

L.enable = "启用"
L.move = "移动"
L.moveDesc = "移动醒目计时条到醒目锚点。如此选项关闭，醒目计时条将只简单的改变缩放和颜色。"
L.emphasizedBars = "醒目计时条"
L.align = "对齐"
L.alignText = "文本对齐"
L.alignTime = "时间对齐"
L.time = "时间"
L.timeDesc = "在计时条上显示或隐藏时间。"
L.textDesc = "显示或隐藏计时条上的文本。"
L.icon = "图标"
L.iconDesc = "显示或隐藏计时条图标。"
L.iconPosition = "图标位置"
L.iconPositionDesc = "选择计时条上图标的位置。"
L.font = "字体"
L.restart = "重新加载"
L.restartDesc = "重新加载醒目计时条并从10开始倒数。"
L.fill = "填充"
L.fillDesc = "填充计时条而不是显示为空。"
L.spacing = "间距"
L.spacingDesc = "更每个改计时条之间的间距。"
L.visibleBarLimit = "可视条限制"
L.visibleBarLimitDesc = "设定同时可见计时条的最大数量。"

L.localTimer = "本地"
L.timerFinished = "%s：计时条[%s]到时间。"
L.customBarStarted = "自定义计时条“%s”由%s玩家%s发起。"
L.sendCustomBar = "正在发送自定义计时条“%s”到 BigWigs 和 DBM 玩家。"

L.requiresLeadOrAssist = "此功能需要团队领袖或助理权限。"
L.encounterRestricted = "此功能在战斗中不能使用。"
L.wrongCustomBarFormat = "错误格式。正确用法：/raidbar 20 文本"
L.wrongTime = "指定的时间无效。  <time> 可以是秒数、M:S格式或分钟数。例如：5、1:20 或 2分钟"

L.wrongBreakFormat = "必须位于1至60分钟之间。正确用法：/break 5"
L.sendBreak = "发送休息时间计时器到 BigWigs 和 DBM 用户。"
L.breakStarted = "休息时间计时器由 %s 用户 %s 发起。"
L.breakStopped = "休息时间计时器被 %s 取消了。"
L.breakBar = "休息时间"
L.breakMinutes = "休息时间将在 %d 分钟后结束！"
L.breakSeconds = "休息时间将在 %d 秒后结束！"
L.breakFinished = "休息时间结束！"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "首领屏蔽"
L.bossBlockDesc = "设置在首领战斗中要屏蔽的选项（多选）。\n\n"
L.bossBlockAudioDesc = "设置在首领战斗中哪些音效将被静音。\n\n如果你已经在系统音频设定禁用了某些选项，这里将显示为|cff808080灰色|r。\n\n"
L.movieBlocked = "以前观看过此剧情动画，跳过。"
L.blockEmotes = "屏蔽屏幕中央表情信息"
L.blockEmotesDesc = "一些首领在施放某些技能时会显示表情，这些信息会两种方式显示并有太长的描述。尝试让它们小一些，更紧凑的消息不会影响游戏过程，并且不会告诉你具体做什么。\n\n请注意：如果你要看首领表情，它们仍会显示在聊天窗口。"
L.blockMovies = "屏蔽重播剧情动画"
L.blockMoviesDesc = "首领战斗中剧情动画将只允许播放一次（可以观看一次），下次将被屏蔽掉。"
L.blockFollowerMission = "屏蔽追随者任务弹出窗口"
L.blockFollowerMissionDesc = "追随者任务弹出窗口会显示一些事情，但主要是追随者任务已经完成。\n\n这些弹出窗口会在首领战斗时覆盖在你重要的用户界面之上，所以建议屏蔽它们。"
L.blockGuildChallenge = "屏蔽公会挑战弹出窗口"
L.blockGuildChallengeDesc = "公会挑战弹出窗口会显示一些信息，主要是公会的队伍完成了英雄地下城或挑战模式地下城。\n\n这些弹出窗口会在首领战斗时覆盖在你重要的用户界面之上，所以建议屏蔽它们。"
L.blockSpellErrors = "屏蔽法术失败信息"
L.blockSpellErrorsDesc = "通常在屏幕顶部显示的信息类似于“法术还没有准备好”将被屏蔽掉。"
L.blockZoneChanges = "屏蔽区域切换信息"
L.blockZoneChangesDesc = "当你到达一个新区域 例如：“|cFF33FF99暴风城|r”和“|cFF33FF99奥格瑞玛|r”时，屏幕中上方显示的信息将被屏蔽。"
L.audio = "语音"
L.music = "音乐"
L.ambience = "环境音效"
L.sfx = "声音效果"
L.errorSpeech = "错误提示"
L.disableMusic = "音乐静音（推荐）"
L.disableAmbience = "环境音效静音（推荐）"
L.disableSfx = "声音效果静音（不推荐）"
L.disableErrorSpeech = "错误提示静音（推荐）"
L.disableAudioDesc = "魔兽世界声音选项中的“%s”选项将被关闭，当首领战斗结束后会重新打开。这有助于将注意力集中在 BigWigs 警报音效上。"
L.blockTooltipQuests = "屏蔽提示任务物品"
L.blockTooltipQuestsDesc = "当需要因任务击杀首领时，通常在鼠标悬停在首领上会显示为“0/1 完成”的提示。此功能将在战斗中将其隐藏以防止提示变得非常大。"
L.blockObjectiveTracker = "隐藏任务追踪栏"
L.blockObjectiveTrackerDesc = "在首领战斗中隐藏任务追踪栏，给屏幕空出更多空间。\n\n此功能在史诗钥石+或追踪成就时会自动停用。"

L.blockTalkingHead = "隐藏 NPC 说话时弹出的“对话头像”"
L.blockTalkingHeadDesc = "当 NPC 头像和聊天文本在屏幕中央下方的一个弹出的对话盒子称为“对话头像”，|cffff4411有时候|r会在 NPC 讲话时显示。\n\n可以选择不同类型设定为禁止显示。\n\n|cFF33FF99请注意：|r\n 1) 此功能将允许 NPC 语音继续播放所以可以继续听到对话。\n 2) 为了安全起见，只有特定的对话头像会被屏蔽，任何特殊或独特的对话如一次性任务，都不会被屏蔽。 "
L.blockTalkingHeadDungeons = "普通和英雄地下城"
L.blockTalkingHeadMythics = "史诗和史诗钥石+地下城"
L.blockTalkingHeadRaids = "团队"
L.blockTalkingHeadTimewalking = "时空漫游（地下城和团队）"
L.blockTalkingHeadScenarios = "场景事件"

L.redirectPopups = "弹出式横幅在BigWigs信息中显示"
L.redirectPopupsDesc = "屏幕中间的弹出式横幅，例如：“|cFF33FF99宏伟宝库已解锁|r”横幅将改为 BigWigs 信息显示。这些横幅可能很大，持续时间很长，而且会阻止你点击穿越。"
L.redirectPopupsColor = "横幅信息的颜色"
L.blockDungeonPopups = "屏蔽地下城弹出式横幅"
L.blockDungeonPopupsDesc = "进入地下城时弹出的横幅有时会包含很长的文字。启用此功能将完全屏蔽它们。"
L.itemLevel = "物品等级%d"
L.newRespawnPoint = "新的复活位置"

L.userNotifySfx = "首领屏蔽禁用了声音效果，强制它重新启用。"
L.userNotifyMusic = "首领屏蔽禁用了音乐，强制它重新启用。"
L.userNotifyAmbience = "首领屏蔽禁用了环境音效，强制它重新启用。"
L.userNotifyErrorSpeech = "首领屏蔽禁用了错误提示，强制它重新启用。"

L.subzone_grand_bazaar = "百商集市" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "赞达拉港" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "东侧耳堂" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "颜色"

L.text = "文本"
L.textShadow = "文本阴影"
L.expiring_normal = "普通"
L.emphasized = "醒目"

L.resetColorsDesc = "重置以上颜色为默认。"
L.resetAllColorsDesc = "如果为首领战斗自定义了颜色设置，这个按钮将重置替换“所有”颜色为默认。"

L.red = "红色"
L.redDesc = "一般战斗警报。"
L.blue = "蓝色"
L.blueDesc = "直接对你造成影响的警报，例如负面效果。"
L.orange = "橙色"
L.yellow = "黄色"
L.green = "绿色"
L.greenDesc = "对你有好事发生的警报，例如负面效果移除。"
L.cyan = "青色"
L.cyanDesc = "遇到状态改变的警报，例如进入到下一阶段。"
L.purple = "紫色"
L.purpleDesc = "坦克特定技能的警报，例如负面效果叠加。"

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "倒数文本"
L.textCountdownDesc = "当倒数时显示可见数字。"
L.countdownColor = "倒数颜色"
L.countdownVoice = "倒数语音"
L.countdownTest = "测试倒数"
L.countdownAt = "倒数…（秒）"
L.countdownAt_desc = "选择倒计时开始时首领技能应剩余多少时间（以秒为单位）。"
L.countdown = "倒数"
L.countdownDesc = "倒数功能包括语音倒计时和可视文字倒计时。默认情况下很少启用它，但是在查看特定的首领战斗设置时，可以为任何首领技能启用它。"
L.countdownAudioHeader = "语音倒计时"
L.countdownTextHeader = "可视文字倒计时"
L.resetCountdownDesc = "重置全部以上倒计时设置为默认。"
L.resetAllCountdownDesc = "如果为任何首领战斗的设置选择了自定义倒计时声音，此按钮将重置*所有*这些声音并将上述所有倒计时设置重置为默认。"

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infobox_short = "信息盒"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "向外通过 BigWigs 插件信息显示。这些包含了图标，颜色和在同一时间在屏幕上的显示4条信息。新的信息将再一次快速的放大和缩小来提醒用户。新插入的信息将增大并立即缩小提醒用户注意。"
L.emphasizedSinkDescription = "通过此插件输出到 BigWigs 醒目信息显示。此显示支持文本和颜色，每次只可显示一条信息。"
L.resetMessagesDesc = "重置全部信息有关选项，包括信息锚点位置。"
L.toggleMessagesAnchorsBtnShow_desc = "显示全部移动锚点，允许您移动消息显示。"

L.testMessagesBtn = "创建测试信息"
L.testMessagesBtn_desc = "创建一条信息，用于测试当前的显示设置。"

L.bwEmphasized = "BigWigs 醒目"
L.messages = "信息"
L.emphasizedMessages = "醒目信息"
L.emphasizedDesc = "醒目消息的目的是通过在屏幕中间显示一条大消息来引起注意。默认情况下很少启用它，但可以在查看特定的首领战斗设置时将其启用任何首领技能。"
L.uppercase = "大写"
L.uppercaseDesc = "全部醒目信息将转换为*大写*。"

L.useIcons = "使用图标"
L.useIconsDesc = "消息旁显示图标。"
L.classColors = "职业颜色"
L.classColorsDesc = "信息有时会包含玩家名称。启用此项将这些名称使用职业颜色。"
L.chatFrameMessages = "聊天框体信息"
L.chatFrameMessagesDesc = "除了显示设置，输出所有 BigWigs 信息到默认聊天框体。"

L.fontSize = "字体尺寸"
L.none = "无"
L.thin = "细"
L.thick = "粗"
L.outline = "轮廓"
L.monochrome = "单一颜色"
L.monochromeDesc = "切换为单一颜色，移除全部字体边缘平滑。"
L.fontColor = "字体颜色"

L.displayTime = "显示时间"
L.displayTimeDesc = "以秒计信息显示时间。"
L.fadeTime = "消退时间"
L.fadeTimeDesc = "以秒计信息消退时间。"

L.messagesOptInHeaderOff = "消息'手动选择'模式：启用此选项将关闭所有模块的消息。\n\n您需要逐个进入每个模块的设置，手动开启您想要的消息提示。\n\n"
L.messagesOptInHeaderOn = "消息'手动选择'模式已|cFF33FF99启用|r。要查看消息，请进入特定技能的设置并开启'|cFF33FF99消息|r'选项。\n\n"
L.messagesOptInTitle = "消息'手动选择'模式"
L.messagesOptInWarning = "|cffff4411警告！|r\n\n启用'手动选择'模式将关闭所有模块的消息。您需要逐个进入每个模块的设置，手动开启您想要的消息提示。\n\n界面即将重新加载，是否继续？"

-----------------------------------------------------------------------
-- Nameplates.lua
--

L.nameplates = "姓名板"
L.testNameplateIconBtn = "显示测试图标"
L.testNameplateIconBtn_desc = "创建一个测试图标，供您在目标姓名板上测试时显示当前的图标设置。"
L.testNameplateTextBtn = "显示测试文本"
L.testNameplateTextBtn_desc = "创建一个测试文本，供您在目标姓名板上测试时显示当前的文本设置。"
L.stopTestNameplateBtn = "停止测试"
L.stopTestNameplateBtn_desc = "停止姓名板上的图标和文本测试。"
L.noNameplateTestTarget = "您需要选择一个可攻击的敌对目标来测试姓名板功能。"
L.anchoring = "设定"
L.growStartPosition = "增长起始位置"
L.growStartPositionDesc = "第一个图标的起始位置"
L.growDirection = "增长方向"
L.growDirectionDesc = "图标从起始位置开始增长的方向。"
L.iconSpacingDesc = "更改图标之间的间距"
L.nameplateIconSettings = "图标设置"
L.keepAspectRatio = "保持宽高比"
L.keepAspectRatioDesc = "保持图标的宽高比为1:1，而不是将其拉伸以适应姓名板框体尺寸。"
L.iconColor = "图标颜色"
L.iconColorDesc = "更改图标纹理的颜色"
L.desaturate = "饱和度"
L.desaturateDesc = "取消图标纹理的饱和度"
L.zoom = "缩放"
L.zoomDesc = "缩放图标纹理。"
L.showBorder = "显示边框"
L.showBorderDesc = "显示图标的边框"
L.borderColor = "边框颜色"
L.borderSize = "边框厚度"
L.borderOffset = "边框偏移"
L.borderName = "边框名"
L.showNumbers = "显示数字"
L.showNumbersDesc = "在图标上显示数字。"
L.cooldown = "冷却"
L.cooldownEmphasizeHeader = "默认情况下，醒目效果为关闭状态（0秒）。设置为1秒或更高时将会启用醒目效果。此功能可让您为这些数字设置不同的字体颜色和字体尺寸。"
L.showCooldownSwipe = "填充显示"
L.showCooldownSwipeDesc = "当冷却激活时，在图标上显示转动动画。"
L.showCooldownEdge = "时针显示"
L.showCooldownEdgeDesc = "当冷却激活时，在图标上显示旋转动画。"
L.inverse = "反向"
L.inverseSwipeDesc = "反向冷却时间动画。"
L.glow = "高亮"
L.enableExpireGlow = "启用冷却结束高亮"
L.enableExpireGlowDesc = "当冷却时间结束时，在图标周围显示的高亮动画效果。"
L.glowColor = "高亮颜色"
L.glowType = "高亮动画"
L.glowTypeDesc = "更改图标周围显示的高亮动画。"
L.resetNameplateIconsDesc = "重置与姓名板图标相关的所有选项。"
L.nameplateTextSettings = "文本设置"
L.fixate_test = "测试文本" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "重置与姓名板文本相关的所有选项。"
L.glowAt = "开始高亮（秒）"
L.glowAt_desc = "选择在冷却计时剩余多少秒时开始高亮。"
L.offsetX = "横向偏移"
L.offsetY = "纵向偏移"
L.headerIconSizeTarget = "当前目标的图标尺寸"
L.headerIconSizeOthers = "其他目标的图标尺寸"
L.headerIconPositionTarget = "当前目标的图标位置"
L.headerIconPositionOthers = "其他目标的图标位置"

-- Glow types as part of LibCustomGlow
L.pixelGlow = "像素发光"
L.autocastGlow = "自动施法发光"
L.buttonGlow = "快捷键发光"
L.procGlow = "脉冲发光"
L.speed = "速度"
L.animation_speed_desc = "发光动画效果的播放速度。"
L.lines = "线条"
L.lines_glow_desc = "设置发光动画效果中有几条线条"
L.intensity = "强度"
L.intensity_glow_desc = "设置发光动画的强度，强度越高，闪光点越多。"
L.length = "长度"
L.length_glow_desc = "设置发光动画效果中线条的长度。"
L.thickness = "粗细"
L.thickness_glow_desc = "设置发光动画效果中线条的粗细。"
L.scale = "缩放"
L.scale_glow_desc = "调整发光动画中闪光点的尺寸。"
L.startAnimation = "起始动画"
L.startAnimation_glow_desc = "您选择的发光效果有起始动画特效，通常是一个闪烁。这个选项可以选择启用/禁用起始动画。"

L.nameplateOptInHeaderOff = "\n\n\n\n姓名板'手动选择'模式：启用此选项将关闭所有模块的姓名板效果。\n\n您需要逐个进入每个模块的设置，手动开启您想要的姓名板效果。\n\n"
L.nameplateOptInHeaderOn = "\n\n\n\n姓名板'手动选择'模式已|cFF33FF99启用|r。需要单独启用姓名板，请进入特定技能的设置并开启'|cFF33FF99姓名板|r'选项。\n\n"
L.nameplateOptInTitle = "姓名板'手动选择'模式"
L.nameplateOptInWarning = "|cffff4411警告！|r\n\n启用'手动选择'模式将关闭所有模块的姓名板效果。您需要逐个进入每个模块的设置，手动开启您想要的姓名板效果。\n\n界面即将重新加载，是否继续？"

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "自定义距离指示器"
L.proximityTitle = "%d码/%d玩家" -- yd = yards (short)
L.proximity_name = "近距离"
L.soundDelay = "音效延迟"
L.soundDelayDesc = "当有人太靠近你时指定多长时间 BigWigs 重复间隔等待指定的音效。"

L.resetProximityDesc = "重置全部近距离有关选项，包括近距离锚点位置。"

L.close = "关闭"
L.closeProximityDesc = "关闭近距离显示。\n\n这是临时性的关闭，要完全禁用此一功能，需进入相对应首领模块选项关闭“近距离”功能。"
L.lock = "锁定"
L.lockDesc = "锁定显示窗口，防止被移动和缩放。"
L.title = "标题"
L.titleDesc = "显示或隐藏标题。"
L.background = "背景"
L.backgroundDesc = "显示或隐藏背景。"
L.toggleSound = "切换音效"
L.toggleSoundDesc = "当近距离窗口有其他过近玩家时切换任一或关闭音效。"
L.soundButton = "音效按钮"
L.soundButtonDesc = "显示或隐藏音效按钮。"
L.closeButton = "关闭按钮"
L.closeButtonDesc = "显示或隐藏关闭按钮。"
L.showHide = "显示/隐藏"
L.abilityName = "技能名称"
L.abilityNameDesc = "在窗口上面显示或隐藏技能名称。"
L.tooltip = "提示"
L.tooltipDesc = "显示或隐藏近距离显示从首领战斗技能获取的法术提示。"

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "倒数类型"
L.combatLog = "自动战斗记录"
L.combatLogDesc = "当开怪倒数计时器开始到战斗结束时自动开始战斗记录。"

L.pull = "开怪"
L.engageSoundTitle = "当首领战斗开始时播放音效"
L.pullStartedSoundTitle = "当开怪倒数计时器开始时播放音效"
L.pullStartedMessageTitle = "当开怪倒数计时器开始时显示消息"
L.pullFinishedSoundTitle = "当开怪倒数计时器结束时播放音效"
L.pullStartedBy = "%s 发起开怪倒数计时。"
L.pullStopped = "%s 取消了开怪倒数计时。"
L.pullStoppedCombat = "开怪倒数计时器因进入战斗而取消。"
L.pullIn = "%d 秒后开怪"
L.sendPull = "向您的队伍/团队发送开怪倒数计时器。"
L.wrongPullFormat = "无效的开怪倒数。正确用法：/pull 5"
L.countdownBegins = "开始倒计时"
L.countdownBegins_desc = "选择开怪计时器上倒计开始时应剩余多少时间（以秒为单位）。"
L.pullExplainer = "\n|cFF33FF99/pull|r 将开启默认开怪计时器。\n|cFF33FF99/pull 7|r 将开启7秒拉怪计时器，数字可任意指定。\n您也可以在下方的按键设置中设置快捷键。\n\n"
L.pullKeybindingDesc = "为启用开怪计时器选择一个按键设置。"

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "图标"
L.raidIconsDescription = "可能遇到包含例如炸弹类型的技能指向特定的玩家，玩家被追，或是特定玩家可能有兴趣在其他方面。这里可以自定义团队标记来标记这些玩家。\n\n如果只遇到一种技能，很好，只有第一个图标会被使用。在某些战斗中一个图标不会使用在两个不同的技能上，任何特定技能在下次总是使用相同图标。\n\n|cffff4411注意：如果玩家已经被手动标记，BigWigs 将不会改变他的图标。|r"
L.primary = "主要"
L.primaryDesc = "战斗时使用的第一个团队标记。"
L.secondary = "次要"
L.secondaryDesc = "战斗时使用的第二个团队标记。"

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "音效"
L.soundsDesc = "BigWigs 使用“主音量”通道播放全部音效。如果发现音效过小或过大，打开游戏声音设置并调整“主音量”滑块到所需的级别。\n\n下面可以全局配置为特定操作播放的不同音效，或将它们设置为“None（无）”来将其禁用。如果只想更改特定首领技能音效，可以在首领模块的技能列表内点击“>>”后进行指定设置。\n\n"
L.oldSounds = "传统音效"

L.Alarm = "警示"
L.Info = "信息"
L.Alert = "警告"
L.Long = "长响"
L.Warning = "警报"
L.onyou = "一个法术，增益或负面效果在你身上"
L.underyou = "你需要移动，离开你脚下的法术范围"
L.privateaura = "只要“私有光环”出现在你身上"

L.customSoundDesc = "播放选定的自定义的声音，而不是由模块提供的。"
L.resetSoundDesc = "重置以上音效为默认。"
L.resetAllCustomSound = "如果设置全部首领战斗自定义的声音，此按钮将重置“全部”以这里自定义的声音来代替。"

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "首领统计"
L.bossStatsDescription = "记录与 BOSS 有关的各种统计数据，如获胜次数、被击败次数、首次获胜日期和最快获胜时间。可以在配置屏幕上查看每个首领的统计数据，没有首领记录的统计数据会被隐藏。"
L.createTimeBar = "显示“最快获胜”计时条"
L.bestTimeBar = "最快时间"
L.healthPrint = "血量：%s。"
L.healthFormat = "%s （%.1f%%）"
L.chatMessages = "聊天信息"
L.newFastestVictoryOption = "新的最快获胜"
L.victoryOption = "你取得了胜利"
L.defeatOption = "你被击败了"
L.bossHealthOption = "首领血量"
L.bossVictoryPrint = "你战胜了 “%s”，用时 %s 。" -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "你被 “%s” 击败了，用时 %s 。" -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "新的最快获胜：（-%s）" -- New fastest victory: (-COMBAT_DURATION)

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "胜利"
L.victoryHeader = "配置击败首领战斗之后的动作。"
L.victorySound = "播放胜利音效"
L.victoryMessages = "显示击败首领信息"
L.victoryMessageBigWigs = "显示 BigWigs 信息"
L.victoryMessageBigWigsDesc = "BigWigs 的“首领已被击败”信息很简单。"
L.victoryMessageBlizzard = "显示暴雪信息"
L.victoryMessageBlizzardDesc = "位于屏幕中央的暴雪动画“首领已被击败”信息过长。"
L.defeated = "%s被击败了！"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "团灭"
L.wipeSoundTitle = "当团灭时播放音效"
L.respawn = "刷新"
L.showRespawnBar = "显示刷新计时条"
L.showRespawnBarDesc = "当团灭之后显示首领刷新计时条。"
