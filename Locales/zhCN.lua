local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs", "zhCN")
if not L then return end

L.tempRenameFeat = "现在，你可以在任意首领技能的进阶设置中，点击“>>”并在“重命名”标签里|cFF436EEE重命名|r该技能。"

-- API.lua
L.showAddonBar = "插件 '|cFF436EEE%s|r' 创建了 '%s' 计时条。"
L.requestAddonProfile = "插件 '|cFF436EEE%s|r' 刚刚复制了您的配置文件导出字符串。"
L.shortMinutesAndSeconds = "%d 分 %d 秒" -- 1 Minute 2 Seconds
L.shortSecondsOnly = "%d 秒" -- 28 Seconds
L.shortSubTenSeconds = "%.1f 秒" -- 3.2 Seconds

-- Core.lua
L.berserk = "狂暴"
L.berserk_desc = "为首领狂暴显示计时器和警报。"
L.altpower = "交替能量显示"
L.altpower_desc = "显示交替能量窗口，可查看团队成员的交替能量数值。"
L.infobox = "信息盒"
L.infobox_desc = "显示当前战斗相关的信息。"
L.stages = "阶段"
L.stages_desc = "启用与首领战斗阶段相关的功能，如阶段变化警报、阶段持续时间计时器等。"
L.warmup = "预备"
L.warmup_desc = "首领战斗开始前的预备时间。"
L.proximity = "距离监视"
L.proximity_desc = "显示距离监视窗口，列出距离你过近的玩家。"
L.adds = "增援"
L.adds_desc = "启用与首领战斗中出现的各类增援相关的功能。"
L.health = "血量"
L.health_desc = "启用与首领战斗中血量变化相关的信息。"
L.energy = "能量"
L.energy_desc = "启用与首领战斗中各类能量等级信息相关的功能。"

L.already_registered = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%s|r）在 BigWigs 中已存在，但该模块仍试图重新注册。这可能是因为更新失败，导致插件文件夹中同时存在两份相同模块的副本。建议删除所有 BigWigs 文件夹并重新安装。"

-- Loader / Options.lua
L.okay = "确定"
L.officialRelease = "你所使用的 BigWigs %s 为官方正式版（%s）。"
L.alphaRelease = "你所使用的 BigWigs %s 为 Alpha 测试版（%s）。"
L.sourceCheckout = "你所使用的 BigWigs %s 为直接从原始代码仓库获取的版本。"
L.littlewigsOfficialRelease = "你所使用的 LittleWigs 为官方正式版（%s）。"
L.littlewigsAlphaRelease = "你所使用的 LittleWigs 为 Alpha 测试版（%s）。"
L.littlewigsSourceCheckout = "你所使用的 LittleWigs 为直接从原始代码仓库获取的版本。"
L.guildRelease = "你正在使用 BigWigs 公会版（版本 %d），基于官方版本 %d。"
L.getNewRelease = "你的 BigWigs 已过期（输入 /bwv 查看版本）。建议使用 CurseForge 客户端轻松更新，或前往 curseforge.com 或 addons.wago.io 手动下载安装最新版本。"
L.warnTwoReleases = "你的 BigWigs 已过期2个版本！你的版本可能存在错误、功能缺失或计时器不准确的问题，强烈建议你升级。"
L.warnSeveralReleases = "|cffff0000你的 BigWigs 已过期 %d 个版本！！我们*强烈*建议你更新，以免与其他队友发生同步异常！|r"
L.warnOldBase = "你正在使用 BigWigs 公会版（%d），但该版本基于的官方版本（%d）已过期 %d 个版本，可能出现一些问题。"

L.tooltipHint = "|cffeda55f右击|r打开选项。"
L.activeBossModules = "激活的首领模块："

L.oldVersionsInGroup = "队伍中有人使用了 |cffff0000旧版本|r 的 BigWigs 或未使用 BigWigs。可使用 /bwv 名称 查看详细信息。"
L.upToDate = "已更新："
L.outOfDate = "已过期："
L.dbmUsers = "DBM 用户："
L.noBossMod = "未使用首领模块："
L.offline = "离线"

L.missingAddOnPopup = "缺少插件： |cFF436EEE%s|r !"
L.missingAddOnRaidWarning = "缺少插件： |cFF436EEE%s|r ！此区域将无法显示计时条！"
L.outOfDateAddOnPopup = "插件 |cFF436EEE%s|r 已过期！"
L.outOfDateAddOnRaidWarning = "插件 |cFF436EEE%s|r 已过期！您当前版本 v%d.%d.%d，最新版本 v%d.%d.%d！"
L.disabledAddOn = "插件 |cFF436EEE%s|r 已禁用，计时器将无法显示。"
L.removeAddOn = "请移除“|cFF436EEE%s|r”，该插件已被“|cFF436EEE%s|r”取代。"
L.outOfDateContentPopup = "警告！\n你已更新 |cFF436EEE%s|r，但还需要更新 |cFF436EEEBigWigs|r 核心。\n若不更新，将导致插件功能异常或无法正常运行。"
L.outOfDateContentRaidWarning = "|cFF436EEE%s|r 需要安装 %d 版本的 |cFF436EEEBigWigs|r 主插件才能正常运行，但你当前使用的版本是 %d 。"
L.addOnLoadFailedWithReason = "BigWigs 未能加载插件 |cFF436EEE%s|r ，原因： %q。请将此问题反馈给 BigWigs 开发者！"
L.addOnLoadFailedUnknownError = "BigWigs 在加载插件 |cFF436EEE%s|r 时遇到了错误。请将此问题反馈给 BigWigs 开发者！"
L.newFeatures = "BigWigs 新功能："
L.parentheses = "%s（%s）"

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
	"至暗之夜", -- Midnight
}
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "地下堡",
	["LittleWigs_CurrentSeason"] = "当前赛季",
}
L.dayNamesShort = {
	"星期日", -- Sunday
	"星期一", -- Monday
	"星期二", -- Tuesday
	"星期三", -- Wednesday
	"星期四", -- Thursday
	"星期五", -- Friday
	"星期六", -- Saturday
}
L.dayNames = {
	"星期日",
	"星期一",
	"星期二",
	"星期三",
	"星期四",
	"星期五",
	"星期六",
}
L.monthNames = {
	"1月",
	"2月",
	"3月",
	"4月",
	"5月",
	"6月",
	"7月",
	"8月",
	"9月",
	"10月",
	"11月",
	"12月",
}
L.dateFormat = "%1$s，%4$d年%3$d%2$s日" -- Date format: "Monday 1 January 2025" 中文格式1：2025年1月1日，周一 /格式2:周一，2025年1月1日

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
L.introduction = "欢迎使用 BigWigs。请系好安全带，吃点花生，享受这次旅行。它不会吃了你的孩子，但会协助你的团队与首领战斗，如同享受饕餮大餐。"
L.sound = "音效"
L.minimapIcon = "小地图图标"
L.minimapToggle = "打开或关闭小地图图标。"
L.compartmentMenu = "隐藏暴雪插件收纳按钮"
L.compartmentMenu_desc = "关闭此选项将启用暴雪的小地图插件收纳功能。推荐启用此选项，隐藏暴雪插件收纳按钮。"
L.configure = "配置"
L.resetPositions = "重置位置"
L.selectEncounter = "选择战斗"
L.privateAuraSounds = "私有光环音效"
L.privateAuraSounds_desc = "私有光环无法被正常追踪，但你可以为其设置音效，当对应减益施加到你身上时播放。"
L.listAbilities = "列出技能到团队聊天"

L.dbmFaker = "伪装成 DBM 用户"
L.dbmFakerDesc = "当 DBM 用户进行版本检查时，你会被列为其用户。当公会强制要求使用 DBM 时非常有用。"
L.zoneMessages = "显示区域信息"
L.zoneMessagesDesc = "当你进入 BigWigs 支持但未安装相应模块的区域时，会提示可安装的 BigWigs 模块。强烈建议开启此功能，这是你获取新模块提醒的唯一途径，有助于及时安装 BigWigs 功能。"
L.englishSayMessages = "英文喊话"
L.englishSayMessagesDesc = "首领战中所有通过“大喊”与“说”发送的提示信息都将以英文发送，这对多语言团队非常有用。"

L.slashDescTitle = "|cFFFED000命令行：|r"
L.slashDescPull = "|cFFFED000/pull:|r 发送拉怪倒数提示到团队。"
L.slashDescBreak = "|cFFFED000/break:|r 发送休息时间提示到团队。"
L.slashDescRaidBar = "|cFFFED000/raidbar:|r 发送自定义计时条到团队。"
L.slashDescLocalBar = "|cFFFED000/localbar:|r 创建仅自己可见的自定义计时条。"
L.slashDescRange = "|cFFFED000/range:|r 开启距离监视。"
L.slashDescVersion = "|cFFFED000/bwv:|r 进行 BigWigs 版本检测。"
L.slashDescConfig = "|cFFFED000/bw:|r 开启 BigWigs 配置。"

L.gitHubDesc = "|cFF33FF99BigWigs 是 GitHub 上的开源软件。我们一直在寻找新的朋友来帮助我们，欢迎任何人检视代码、做出贡献或提交错误报告。BigWigs 今天的伟大，很大程度上归功于魔兽世界社区的帮助。|r"

L.BAR = "计时条"
L.MESSAGE = "信息"
L.ICON = "标记"
L.SAY = "说"
L.FLASH = "闪烁"
L.EMPHASIZE = "醒目"
L.ME_ONLY = "仅自身"
L.ME_ONLY_desc = "启用后，只有对你有影响的技能信息才会被显示。例如，“炸弹：玩家”只会在你身上有炸弹时显示。"
L.PULSE = "脉冲"
L.PULSE_desc = "除了闪屏外，也可使特定技能的图标在屏幕上闪烁，以提高注意力。"
L.MESSAGE_desc = "大多数首领技能都带有 BigWigs 可以显示的信息。如果禁用此选项，则该技能的任何信息都不会显示。"
L.BAR_desc = "某些技能会显示计时条。如果你想隐藏某个技能的计时条，请禁用此选项。"
L.FLASH_desc = "有些技能比其他技能更重要。如果想在重要技能施放时让屏幕闪烁，请选中此选项。"
L.ICON_desc = "BigWigs 可以根据技能用图标标记玩家，使其更容易被辨认。"
L.SAY_desc = "聊天泡泡容易被看见。BigWigs 将使用说的信息方式通知附近的人你中了什么技能。"
L.EMPHASIZE_desc = "启用后，与此技能相关的任何信息都将醒目显示，使其更大更显眼。可在主选项的“信息”设置中调整醒目信息的字体和尺寸。"
L.PROXIMITY = "距离监视"
L.PROXIMITY_desc = "有些技能需要团队分散。启用此选项后，特定首领战会显示距离监视窗口，列出所有离你过近的玩家。"
L.ALTPOWER = "交替能量显示"
L.ALTPOWER_desc = "某些首领战斗中，玩家会用到交替能量。交替能量显示可以快速预览玩家的最少/最多交替能量，有助于制定战术或分配任务。"
L.TANK = "仅坦克"
L.TANK_desc = "有些技能只对坦克重要。如果你想无视职业看到这些技能的警报，请禁用此选项。"
L.HEALER = "仅治疗"
L.HEALER_desc = "有些技能只对治疗重要。如果你想无视职业看到这些技能的警报，请禁用此选项。"
L.TANK_HEALER = "仅坦克和治疗"
L.TANK_HEALER_desc = "有些技能只对坦克和治疗重要。如果你想无视职业看到这些技能的警报，请禁用此选项。"
L.DISPEL = "仅驱散"
L.DISPEL_desc = "如果你希望看到自己无法驱散的技能警报，请禁用此选项。"
L.VOICE = "语音"
L.VOICE_desc = "如果安装了语音插件，此选项可以开启并播放警报语音文件。"
L.COUNTDOWN = "倒数"
L.COUNTDOWN_desc = "如启用，将增加最少5秒的语音和可见倒数。想像一下某人倒数“5…4…3…2…1…”时屏幕中间显示大数字的效果。"
L.CASTBAR_COUNTDOWN = "施法条倒数计时"
L.CASTBAR_COUNTDOWN_desc = "启用后，为施法条的最后五秒显示大号文字与语音倒数。"
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = L.sound
L.SOUND_desc = "首领技能通常会播放音效来帮助你注意到它。如禁用此选项，将不会播放任何音效。"
L.CASTBAR = "施法条"
L.CASTBAR_desc = "某些首领战斗中会出现施法条，一些重要的技能通常会通过它引起注意。如果想隐藏此技能相关的施法条，请禁用此选项。"
L.SAY_COUNTDOWN = "说话冷却"
L.SAY_COUNTDOWN_desc = "聊天泡泡很容易被看见。BigWigs 将使用多条说话消息进行倒计时，提醒附近的人身上的技能即将到期。"
L.ME_ONLY_EMPHASIZE = "醒目（自身）"
L.ME_ONLY_EMPHASIZE_desc = "启用后，仅对自身生效的技能信息将醒目显示，使其更大更显眼。"
L.NAMEPLATE = "姓名板"
L.NAMEPLATE_desc = "启用后，与此技能相关的图标和文字将显示在姓名板上。这样当多个 NPC 施放技能时，更容易看清是哪个 NPC 在施放。"
L.PRIVATE = "私有光环"
L.PRIVATE_desc = "私有光环无法用常规手段追踪，但可以在音效页面指定当“私有光环”出现在你身上时播放的音效。"

L.advanced_options = "高级选项"
L.back = "<< 返回"

L.tank = "|cFFFF0000仅警报坦克。|r"
L.healer = "|cFFFF0000仅警报治疗。|r"
L.tankhealer = "|cFFFF0000仅警报坦克和治疗。|r"
L.dispeller = "|cFFFF0000仅警报驱散。|r"

L.renames = "重命名"
L.noteLabel = "%s（|cFFFFFF99%s|r）"
L.renameLabel = "%s（|cFF3366FF%s|r）"
L.renameHeader = "为该技能设置一个自定义名称。该名称将取代法术原名，显示在所有信息和计时条中。\n\n"
L.spellName = "法术名称"
L.spellNameResetDesc = "该技能默认使用自定义名称，点击此按钮可恢复为原名（通常为法术名称）。"

-- Sharing.lua
L.import = "导入"
L.import_info = "导入字符串后，你可以选择要导入的设置。\n如果导入的字符串中包含不可用的设置，则无法选择这些设置。\n\n|cffff4411此导入只会改变你的常规设置，不会改变你对首领的特定设置。|r"
L.import_info_active = "选择要导入的选项，然后点击导入按钮。"
L.import_info_none = "|cFFFF0000导入的字符串不兼容或已过期。|r"
L.export = "导出"
L.export_info = "选择要导出并分享给他人的设置。\n\n|cffff4411你只能分享常规设置，这些设置对首领的特定设置没有影响。|r"
L.export_string = "导出字符串"
L.export_string_desc = "要分享设置，请复制此 BigWigs 字符串。"
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
L.confirm_import = "你即将导入的所选设置将覆盖当前所选配置文件：\n\n|cFF33FF99\"%s\"|r 中的设置。\n\n确定要继续吗？"
L.confirm_import_addon = "插件 |cFF436EEE\"%s\"|r 想要自动导入新的 BigWigs 设置，这些设置将覆盖您当前选择的 BigWigs 配置文件：\n\n|cFF33FF99\"%s\"|r\n\n确定要继续吗？"
L.confirm_import_addon_new_profile = "插件 |cFF436EEE\"%s\"|r 想自动创建一个名为：\n\n|cFF33FF99\"%s\"|r 的新 BigWigs 配置文件，\n\n 接受此新配置文件将同时切换为该配置。"
L.confirm_import_addon_edit_profile = "插件 |cFF436EEE\"%s\"|r 想要自动编辑您的一个名为：\n\n|cFF33FF99\"%s\"|r 的 BigWigs 配置文件，\n\n 接受这些更改将同时切换为该配置。"
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
L.mythicplus_settings_import_desc = "导入史诗钥石设置。"
L.mythicplus_settings_export_desc = "导出史诗钥石设置。"
L.imported_battleres_settings = "战复设置"
L.battleres_settings_import_desc = "导入战复设置。"
L.battleres_settings_export_desc = "导入战复设置。"
L.imported_privateAuras_settings = "私有光环设置"
L.privateAuras_settings_import_desc = "导入私有光环设置。"
L.privateAuras_settings_export_desc = "导出私有光环设置。"
L.imported_combattimer_settings = "战斗计时器设置"
L.combattimer_settings_import_desc = "导入计时器设置"
L.combattimer_settings_export_desc = "导出计时器设置"

-- InstanceSharing.lua
L.sharing_window_title = "分享首领设置"
L.sharing_flags = "通用设置"
L.sharing_flags_desc = "导入控制各项功能的设置，例如'显示计时条'、'播放音效'、'显示信息'等。\n这涵盖了技能设置中大部分复选框选项。"
L.sharing_export_flags_desc = "导出控制各项功能的设置，例如'显示计时条'、'播放音效'、'显示信息'等。\n这涵盖了技能设置中大部分复选框选项。"
L.sharing_renames_desc = "导入自定义重命名的设置。"
L.sharing_export_renames_desc = "导出自定义重命名的设置。"
L.sharing_sounds_desc = "导入技能播放的音效设置。"
L.sharing_export_sounds_desc = "导出技能播放的音效设置。"
L.sharing_private_auras = "私有光环"
L.sharing_private_auras_desc = "导入私有光环的音效设置。"
L.sharing_export_private_auras_desc = "导出私有光环的音效设置。"
L.sharing_colors_desc = "导入计时条与信息文本的颜色设置。"
L.sharing_export_colors_desc = "导出计时条与信息文本的颜色设置。"
L.confirm_instance_import = "您即将导入的选中设置将覆盖您当前所选配置文件中的设置：\n\n|cFF33FF99\"%s\"|r\n\n副本：\n|cFFBB66FF\"%s\"|r\n\n确定要继续吗？"
L.status_text_paste_import = "粘贴有效的导入字符串"
L.exporting_instance = "导出 |cFFBB66FF%s|r" -- Exporting Molten Core
L.importing_instance = "导入 |cFFBB66FF%s|r" -- Importing Molten Core
L.share = "分享"

-- Statistics
L.statistics = "统计"
L.defeat = "被击败"   --用回“被击败”，这样显示统一。
L.defeat_desc = "你在与该首领战斗时被击败的总次数。"
L.victory = "获胜"
L.victory_desc = "你在与该首领战斗时获胜的总次数。"
L.fastest = "最快"
L.fastest_desc = "与该首领战斗的最快获胜时间及发生的日期（年/月/日）。"
L.first = "首胜"
L.first_desc = "你在与该首领战斗时首次获胜的详细信息，格式为：\n[首次获胜前被击败次数] - [战斗时间] - [年/月/日 首胜]"

-- Difficulty levels for statistics display on bosses
L.unknown = "未知"
L.LFR = "随机"
L.normal = "普通"
L.heroic = "英雄"
L.mythic = "史诗"
L.LFR_timerun = "|A:timerunning-glues-icon:14:14|a随机团队"
L.normal_timerun = "|A:timerunning-glues-icon:14:14|a普通"
L.heroic_timerun = "|A:timerunning-glues-icon:14:14|a英雄"
L.mythic_timerun = "|A:timerunning-glues-icon:14:14|a史诗"
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
L.titan = "25人泰坦" -- Chinese-only "Titan Reforged" servers
L.mythic_flex = "史诗（弹性）" -- 233. 史诗 - 弹性团队副本

-----------------------------------------------------------------------
-- TOOLS
-----------------------------------------------------------------------

L.tools = "工具"
L.toolsDesc = "BigWigs 提供多种工具和\"便利功能\"，帮你更快、更轻松地应对首领战。"

L.reloadUIWarning = "更改此选项将重载界面，并短暂显示载入画面。你确定要继续吗？"
L.qualityOfLife = "便利功能"
L.notYetImplemented = "功能尚未开放" -- When a feature hasn't been implemented yet 暂未实装

-----------------------------------------------------------------------
-- AutoInvite.lua
--

L.autoInviteTitle = "自动邀请"
L.autoInviteDesc = "当玩家向你密语发送下方列表中的特定关键词时，自动邀请其加入队伍。"
L.yes = "是"
L.no = "否"
L.addWords = "添加关键词"
L.removeWords = "移除关键词（点击删除）"
L.invalidWordWarning = "关键词必须为中文及小写（英文），且不能已存在于列表中。"
L.groupIsFullConvertToRaid = "队伍已满，是否转换为团队？"
L.whisperToPlayerMyGroupIsFull = "[BigWigs] 我的队伍已满。"
L.keywordDetectedInvitingPlayer = "检测到关键词，正在邀请 %s。"

-----------------------------------------------------------------------
-- AutoRole.lua
--

L.autoRoleTitle = "自动分配职责"
L.autoRoleExplainer = "当你加入队伍，或在队伍中切换天赋专精时，BigWigs 将自动调整你在队伍中的职责（坦克、治疗、伤害输出）。\n\n"

-----------------------------------------------------------------------
-- BattleRes.lua
--

L.battleResTitle = "战复"
L.battleResDesc = "新建一个图标，显示可用战复次数及下次获得额外次数所需时间。"
L.battleResDesc2 = "\n将鼠标悬停在图标上时，可以查看你的|cFF33FF99战复|r 使用记录。\n注意：此提示仅在脱离战斗后显示。\n\n"
L.battleResHistory = "战复："
L.battleResResetAll = "将所有战复设置重置为默认。"
L.battleResDurationText = "时间文本"
L.battleResChargesText = "次数文本"
L.battleResNoCharges = "无可用次数"
L.battleResHasCharges = "有可用次数"
L.battleResPlaySound = "获得新可用次数时播放音效"
L.iconTextureSpellID = "|T%d:0:0:0:0:64:64:4:60:4:60|t 技能图标（Spell ID）"
L.iconTextureSpellIDError = "你必须输入一个有效的法术 ID 作为显示的图标。"
L.battleResModeIcon = "显示模式：图标"
L.battleResModeText = "显示模式：仅文字"
L.battleResModeTextTooltip = "显示临时背景以便调整战复功能的位置，并查看鼠标悬停提示位置。"

-----------------------------------------------------------------------
-- CombatTimer.lua
--

L.combatTimerTitle = "战斗计时器"
L.anyCombatTimer = "任意战斗计时器"
L.anyCombatTimerDesc = "显示战斗状态持续时间。鼠标悬停查看历史记录。"
L.anyCombatTimerTooltip = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t战斗历史"
L.bossCombatTimer = "首领战计时器"
L.bossCombatTimerDesc = "显示与首领战斗的持续时间。鼠标悬停查看首领战历史。"
L.bossCombatTimerTooltip = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t首领战历史"
L.bossStagesTimer = "首领阶段计时器"
L.bossStagesTimerDesc = "进入新阶段时重置计时器。仅限多阶段首领，鼠标悬停查看阶段历史。"
L.bossStagesTimerTooltip = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t阶段历史"
L.instanceTimer = "副本计时器"
L.instanceTimerDesc = "显示副本内计时（地下城/团队等）。鼠标悬停查看历史记录。"
L.instanceTimerTooltip = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t副本历史"

L.backgroundColor = "背景颜色"
L.inactive = "未激活"
L.whenInactive = "未激活时"
L.doNothing = "无操作"
L.hide = "隐藏"
L.colorFade = "颜色/渐隐"
L.inProgress = "进行中"
L.textFormat = "文本格式"
L.tooltipHistoryMaxLines = "记录：最大行数"
L.tooltipHistoryMaxLinesDesc = "设置工具提示历史记录的最大显示行数。"
L.tooltipHistoryResetConditions = "记录：重置条件"
L.tooltipHistoryResetConditionsDesc = "选择何时重置工具提示的历史记录。"
L.enteringRaid = "团队副本时"
L.enteringDungeon = "地下城时"
L.startingMythicKeystone = "史诗钥石时"
L.historyTimeFormat = "记录：时间格式"
L.twelveHour = "12小时"
L.twentyFourHour = "24小时"
L.hideTooltipInCombat = "在战斗中隐藏提示框"
L.customText = "自定义文本（必须含有 %s）"

-----------------------------------------------------------------------
-- Keystones.lua
--

L.keys = "钥石"

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
L.keystoneTeleportInCombat = "你无法在战斗中传送。"
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
L.keystoneCountdownExplainer = "当你开始史诗钥石地下城时，将会播放倒数语音。请选择你想听到的语音以及你希望倒数何时开始。\n\n"
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
L.keystoneTimerunner = "|A:timerunning-glues-icon:14:14|a时空奔行者。" -- Note: Timerunning is a mode like "Legion Remix", it is NOT the same as Timewalking
L.keystoneSlashKeys = "同时注册 |cFF33FF99/keys|r 命令"
L.keystoneSlashKeystone = "同时注册 |cFF33FF99/keystone|r 命令"
L.unavailableWhilstInCombat = "战斗中无法使用"

-- It doesn't really matter what you call it as long as it's recognizable and limited to ~6 characters
L.keystoneShortName_TheRookery = "驭雷"
L.keystoneShortName_DarkflameCleft = "暗焰"
L.keystoneShortName_PrioryOfTheSacredFlame = "隐修院"
L.keystoneShortName_CinderbrewMeadery = "燧酿"
L.keystoneShortName_OperationFloodgate = "水闸"
L.keystoneShortName_TheaterOfPain = "伤势"
L.keystoneShortName_TheMotherlode = "暴富"
L.keystoneShortName_OperationMechagonWorkshop = "车间"
L.keystoneShortName_EcoDomeAldani = "圆顶" --生态圆顶
L.keystoneShortName_HallsOfAtonement = "赎罪"
L.keystoneShortName_AraKaraCityOfEchoes = "回响"
L.keystoneShortName_TazaveshSoleahsGambit = "宏图"
L.keystoneShortName_TazaveshStreetsOfWonder = "天街"
L.keystoneShortName_TheDawnbreaker = "破晨号"
L.keystoneShortName_BlackRookHold = "黑鸦"
L.keystoneShortName_CourtOfStars = "群星"
L.keystoneShortName_DarkheartThicket = "林地"
L.keystoneShortName_EyeOfAzshara = "艾萨拉"
L.keystoneShortName_HallsOfValor = "英灵殿"
L.keystoneShortName_MawOfSouls = "噬魂"
L.keystoneShortName_NeltharionsLair = "巢穴"
L.keystoneShortName_TheArcway = "回廊"
L.keystoneShortName_VaultOfTheWardens = "地窟"
L.keystoneShortName_ReturnToKarazhanLower = "卡下"
L.keystoneShortName_ReturnToKarazhanUpper = "卡上"
L.keystoneShortName_CathedralOfEternalNight = "永夜"
L.keystoneShortName_SeatOfTheTriumvirate = "执政团"
L.keystoneShortName_WindrunnerSpire = "风行者"
L.keystoneShortName_MagistersTerrace = "魔导师"
L.keystoneShortName_MaisaraCaverns = "迈萨拉"
L.keystoneShortName_NexusPointXenas = "节点"
L.keystoneShortName_AlgetharAcademy = "学院"
L.keystoneShortName_Skyreach = "通天峰"
L.keystoneShortName_PitOfSaron = "萨隆"

-- These short names are for the bar that shows during the Mythic+ countdown
-- Use the real dungeon names but make them shorter to fit on the bar better
L.keystoneShortName_TheRookery_Bar = "驭雷"
L.keystoneShortName_DarkflameCleft_Bar = "暗焰"
L.keystoneShortName_PrioryOfTheSacredFlame_Bar = "隐修院"
L.keystoneShortName_CinderbrewMeadery_Bar = "燧酿"
L.keystoneShortName_OperationFloodgate_Bar = "水闸"
L.keystoneShortName_TheaterOfPain_Bar = "伤逝"
L.keystoneShortName_TheMotherlode_Bar = "暴富"
L.keystoneShortName_OperationMechagonWorkshop_Bar = "车间"
L.keystoneShortName_EcoDomeAldani_Bar = "圆顶"
L.keystoneShortName_HallsOfAtonement_Bar = "赎罪"
L.keystoneShortName_AraKaraCityOfEchoes_Bar = "回响"
L.keystoneShortName_TazaveshSoleahsGambit_Bar = "宏图"
L.keystoneShortName_TazaveshStreetsOfWonder_Bar = "天街"
L.keystoneShortName_TheDawnbreaker_Bar = "破晨号"
L.keystoneShortName_BlackRookHold_Bar = "黑鸦"
L.keystoneShortName_CourtOfStars_Bar = "群星"
L.keystoneShortName_DarkheartThicket_Bar = "林地"
L.keystoneShortName_EyeOfAzshara_Bar = "艾萨拉"
L.keystoneShortName_HallsOfValor_Bar = "英灵殿"
L.keystoneShortName_MawOfSouls_Bar = "噬魂"
L.keystoneShortName_NeltharionsLair_Bar = "巢穴"
L.keystoneShortName_TheArcway_Bar = "回廊"
L.keystoneShortName_VaultOfTheWardens_Bar = "地窟"
L.keystoneShortName_ReturnToKarazhanLower_Bar = "卡下"
L.keystoneShortName_ReturnToKarazhanUpper_Bar = "卡上"
L.keystoneShortName_CathedralOfEternalNight_Bar = "永夜"
L.keystoneShortName_SeatOfTheTriumvirate_Bar = "执政团"
L.keystoneShortName_WindrunnerSpire_Bar = "风行者"
L.keystoneShortName_MagistersTerrace_Bar = "魔导师"
L.keystoneShortName_MaisaraCaverns_Bar = "迈萨拉"
L.keystoneShortName_NexusPointXenas_Bar = "节点"
L.keystoneShortName_AlgetharAcademy_Bar = "学院"
L.keystoneShortName_Skyreach_Bar = "通天峰"
L.keystoneShortName_PitOfSaron_Bar = "萨隆"

-- Instance Keys "Who has a key?"
L.instanceKeysTitle = "谁拥有钥石？"
L.instanceKeysDesc = "当你进入史诗钥石地下城时，拥有该地下城钥石的玩家将以列表形式显示。\n\n"
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

-- Challenges UI Decoration
L.partyRatingHeader = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t队伍评分"
L.dungeonScoreString = "|c%s%03d|r |cFFFFFFFF+%02d|r |cFF%s%02d:%02d|r |c%s（%s）|r"
L.dungeonScoreNoDataString = "|cFFFFFFFF暂无数据|r |c%s（%s）|r"
L.dungeonTeleportHeader = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t传送"

-- Progress %
L.progressPercent = "进度 %"
L.progressPercentDesc = "显示史诗钥石地下城中，击杀每个敌对目标可获得的进度值。"
L.progressPercentTooltip = "鼠标悬停时，在提示信息中显示该目标提供的进度百分比。"
L.progressPercentTooltipText = {
	"|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t进度：%s%%",
	"|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t进度：%s%%（%d）",
	"|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|t进度：%s%%（%d/%d）",
}
L.progressPercentNameplate = "在敌对目标姓名板上显示进度百分比"
L.progressCurrentPull = "当前波次"
L.progressCurrentPullDesc = "显示当前战斗中，当前波次所有目标提供的总进度。\n\n尚未实装！"
L.settingsForCurrentTarget = "当前目标设置"
L.settingsForOtherTargets = "其他目标设置"

-----------------------------------------------------------------------
-- LFGTimer.lua
--

L.lfgTimerTitle = "队列就绪计时"
L.lfgTimerExplainer = "每当队列确认窗口出现时，BigWigs 会创建一个计时条，告诉你还有多长时间必须接受队列邀请。\n\n"
L.lfgUseMaster = "通过“主”声道播放队列就绪提示音"
L.lfgUseMasterDesc = "启用此选项后，队列就绪提示音将通过“主”声道播放。禁用后将通过“%s”声道播放。"

-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "综合"
L.advanced = "高级"
L.comma = "，"
L.reset = "重置"
L.resetDesc = "将上述设置重置为默认。"
L.resetAll = "重置所有"
L.startTest = "开始测试"
L.stopTest = "停止测试"
L.always = "总是" -- ALWAYS
L.never = "从不" -- NEVER

L.positionX = "水平位置"
L.positionY = "垂直位置"
L.positionExact = "精确位置"
L.positionDesc = "在框中输入数值或拖动滑条精准定位锚点位置。"
L.copyCustomAnchorWidth = "复制自定义锚点的宽度"
L.copyCustomAnchorWidthDesc = "用自定义锚点的宽度覆盖当前的宽度设置。"
L.width = "宽度"
L.height = "高度"
L.size = "尺寸"
L.sizeDesc = "通常情况下，你可以通过拖动滑条来设置尺寸。如需精确尺寸，可以使用滑条下方的数字框输入数值。"
L.fontSizeDesc = "拖动滑条或在框内输入数值可调整字体尺寸，最大为200。"
L.disabled = "禁用"
L.disableDesc = "将禁用“%s”功能，但|cffff4411不推荐|r这么做。\n\n确定要继续吗？"
L.keybinding = "按键设置"
L.dragToResize = "拖动调整尺寸"
L.cannotMoveInCombat = "战斗中时无法移动此框体。"

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
L.toggleDisplayPrint = "显示将在下次出现时生效。要完全禁用此首领战功能，请在首领战斗选项中关闭。"
L.disabledDisplayDesc = "禁用全部模块显示。"
L.resetAltPowerDesc = "重置全部交替能量有关选项，包括交替能量锚点位置。"
L.test = "测试"
L.altPowerTestDesc = "显示“交替能量”，可以移动，并模拟在首领战斗时会看到的能量变化。"
L.yourPowerBar = "你的能量条"
L.barColor = "条颜色"
L.barTextColor = "条文本颜色"
L.additionalWidth = "附加宽度"
L.additionalHeight = "附加高度"
L.additionalSizeDesc = "拖动此滑条可增加显示尺寸，或在数字框内输入数值，最大为100。"
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
L.bigWigsBarStyleName_Blizzard = "暴雪风格"
L.resetBarsDesc = "重置全部计时条有关选项，包括计时条锚点位置。"
L.testBarsBtn = "创建测试计时条"
L.testBarsBtn_desc = "创建一个测试计时条，用于测试当前显示设置。"

L.toggleAnchorsBtnShow = "显示移动锚点"
L.toggleAnchorsBtnHide = "隐藏移动锚点"
L.toggleAnchorsBtnHide_desc = "隐藏全部移动锚点，锁定所有元素的位置。"
L.toggleBarsAnchorsBtnShow_desc = "显示全部移动锚点，允许您移动计时条。"

L.emphasizeAt = "…（秒）后醒目"
L.growingUpwards = "向上增长"
L.growingUpwardsDesc = "切换计时条在锚点处向上或向下增长。"
L.texture = "材质"
L.emphasize = L.EMPHASIZE
L.emphasizeMultiplier = "尺寸倍数"
L.emphasizeMultiplierDesc = "禁用了计时条移动到醒目计时条后，此选项决定醒目计时条相对于普通计时条的尺寸倍数。"

L.enable = "启用"
L.move = "移动"
L.moveDesc = "将醒目计时条移动到醒目锚点位置。关闭后，醒目计时条仅改变缩放和颜色。"
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
L.iconTooltip = "图标提示"
L.iconTooltipDesc = "当鼠标悬停在图标上时，显示包含首领技能信息的提示框。"
L.font = "字体"
L.restart = "重新加载"
L.restartDesc = "重新加载醒目计时条并从10开始倒数。"
L.fill = "填充"
L.fillDesc = "填充计时条而不是显示为空。"
L.spacing = "间距"
L.spacingDesc = "调整每个计时条之间的间距。"
L.visibleBarLimit = "最大可见数量"
L.visibleBarLimitDesc = "设置同时可见计时条的最大数量。"

L.localTimer = "本地"
L.timerFinished = "%s：计时条[%s]到时间。"
L.customBarStarted = "自定义计时条“%s”由%s玩家%s发起。"
L.sendCustomBar = "正在向 BigWigs 和 DBM 用户发送自定义计时条“%s”。"

L.requiresLeadOrAssist = "此功能需要团队领袖或助理权限。"
L.encounterRestricted = "战斗中无法使用此功能。"
L.wrongCustomBarFormat = "错误格式。正确用法：/raidbar 20 文本"
L.wrongTime = "指定的时间无效。  <time> 可以是秒数、M:S格式或分钟数。例如：5、1:20 或 2分钟"

L.wrongBreakFormat = "时间必须在1至60分钟之间。正确用法：/break 5"
L.sendBreak = "向 BigWigs 和 DBM 用户发送休息时间计时器。"
L.breakStarted = "休息时间计时器由 %s 用户 %s 发起。"
L.breakStopped = "休息时间计时器被 %s 取消了。"
L.breakBar = "休息时间"
L.breakMinutes = "休息时间将在 %d 分钟后结束！"
L.breakSeconds = "休息时间将在 %d 秒后结束！"
L.breakFinished = "休息时间结束！"

L.indicatorTitle = "法术辅助图标"
L.indicatorType_Deadly = "灭团技"
L.indicatorType_Bleed = "流血"
L.indicatorType_Magic = "魔法"
L.indicatorType_Dispels = "驱散"
L.indicatorType_Tank = "坦克"
L.indicatorType_Healer = "治疗者"
L.indicatorType_Damager = "伤害输出者"

L.spellIndicatorsPosition = "法术辅助图标位置"
L.spellIndicatorsPositionDesc = "选择法术辅助图标在技能条上的显示位置。"
L.spellIndicatorsOffset = "法术辅助图标偏移"
L.spellIndicatorSize = "法术辅助图标尺寸"
L.spellIndicatorSizeDropdown_Large1 = "1个大图标"
L.spellIndicatorSizeDropdown_Large2 = "2个大图标"
L.spellIndicatorSizeDropdown_Large3 = "3个大图标"
L.spellIndicatorSizeDropdown_Small4 = "4个小图标"
L.spellIndicatorSizeDropdown_Small2 = "2个小图标"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "首领屏蔽"
L.bossBlockDesc = "设置在首领战斗中要屏蔽的选项（多选）。\n\n"
L.bossBlockAudioDesc = "设置在首领战斗中哪些音效将被静音。\n\n如果你已经在系统音频设定禁用了某些选项，这里将显示为|cff808080灰色|r。\n\n"
L.movieBlocked = "已观看过此剧情动画，跳过。"
L.blockEmotes = "屏蔽屏幕中央表情信息"
L.blockEmotesDesc = "某些首领在施放技能时会显示表情信息，这些信息会以两种方式显示且描述过长。尝试让它们更紧凑，不干扰游戏过程，同时不会告诉你具体该做什么。\n\n请注意：如果你想看首领表情，它们仍会显示在聊天窗口中。"
L.blockMovies = "屏蔽重播剧情动画"
L.blockMoviesDesc = "首领战斗中剧情动画将只允许播放一次（可观看一次），后续将被屏蔽。"
L.blockFollowerMission = "屏蔽追随者任务弹出窗口"
L.blockFollowerMissionDesc = "追随者任务弹出窗口会显示一些事情，主要是追随者任务已经完成。\n\n这些弹出窗口会在首领战中覆盖在你的用户界面上方，因此建议屏蔽它们。"
L.blockGuildChallenge = "屏蔽公会挑战弹出窗口"
L.blockGuildChallengeDesc = "公会挑战弹出窗口会显示一些信息，主要是公会的队伍完成了英雄地下城或挑战模式地下城。\n\n这些弹出窗口会在首领战中覆盖在你的用户界面上方，因此建议屏蔽它们。"
L.blockSpellErrors = "屏蔽法术失败信息"
L.blockSpellErrorsDesc = "通常在屏幕顶部显示的信息类似于“法术还没有准备好”将被屏蔽掉。"
L.blockZoneChanges = "屏蔽区域切换信息"
L.blockZoneChangesDesc = "当你到达新区域 例如：“|cFF33FF99暴风城|r”和“|cFF33FF99奥格瑞玛|r”时，屏幕中上方显示的信息将被屏蔽。"
L.audio = "语音"
L.music = "音乐"
L.ambience = "环境音效"
L.sfx = "声音效果"
L.errorSpeech = "错误提示"
L.disableMusic = "音乐静音（推荐）"
L.disableAmbience = "环境音效静音（推荐）"
L.disableSfx = "声音效果静音（不推荐）"
L.disableErrorSpeech = "错误提示静音（推荐）"
L.disableAudioDesc = "魔兽世界声音选项中的“%s”选项将被关闭，首领战斗结束后会重新打开。这有助于将注意力集中在 BigWigs 警报音效上。"
L.blockTooltipQuests = "屏蔽任务物品提示"
L.blockTooltipQuestsDesc = "当需要因任务击杀首领时，鼠标悬停在首领上通常会显示“0/1 已完成”的提示。此功能将在战斗中将其隐藏，防止提示变得过大。"
L.blockObjectiveTracker = "隐藏任务追踪栏"
L.blockObjectiveTrackerDesc = "在首领战斗中隐藏任务追踪栏，给屏幕空出更多空间。\n\n此功能在史诗钥石+或追踪成就时会自动停用。"

L.blockTalkingHead = "隐藏 NPC 对话特写头像"
L.blockTalkingHeadDesc = "当 NPC 讲话时，屏幕中央下方会弹出一个包含头像和文本的对话盒子，称为“对话特写头像”。|cffff4411有时候|r会在首领战中弹出。\n\n可以选择在不同类型的内容中禁止显示。\n\n|cFF33FF99请注意：|r\n 1) 此功能将允许 NPC 语音继续播放，因此仍可听到对话。\n 2) 为了安全起见，只有特定的对话头像会被屏蔽，任何特殊或独特的对话（如一次性任务）都不会被屏蔽。 "
L.blockTalkingHeadDungeons = "普通和英雄地下城"
L.blockTalkingHeadMythics = "史诗和史诗钥石+地下城"
L.blockTalkingHeadRaids = "团队副本"
L.blockTalkingHeadTimewalking = "时空漫游（地下城和团队）"
L.blockTalkingHeadScenarios = "场景战役"

L.redirectPopups = "弹出式横幅在BigWigs信息中显示"
L.redirectPopupsDesc = "屏幕中间的弹出式横幅，例如：“|cFF33FF99宏伟宝库已解锁|r”横幅将改为 BigWigs 信息显示。这些横幅可能很大，持续时间很长，而且会阻止你点击交互。"
L.redirectPopupsColor = "横幅信息的颜色"
L.blockDungeonPopups = "屏蔽地下城弹出式横幅"
L.blockDungeonPopupsDesc = "进入地下城时弹出的横幅有时会包含很长的文字。启用此功能将完全屏蔽它们。"
L.itemLevel = "物品等级%d"
L.newRespawnPoint = "新的重生点"
L.playerLevel = "等级 %d"

L.userNotifySfx = "首领屏蔽已禁用声音效果，强制重新启用。"
L.userNotifyMusic = "首领屏蔽已禁用音乐，强制重新启用。"
L.userNotifyAmbience = "首领屏蔽已禁用环境音效，强制重新启用。"
L.userNotifyErrorSpeech = "首领屏蔽已禁用错误提示，强制重新启用。"

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
L.blueDesc = "直接对你造成影响的警报，例如减益效果。"
L.orange = "橙色"
L.yellow = "黄色"
L.green = "绿色"
L.greenDesc = "对你有好事发生的警报，例如减益效果移除。"
L.cyan = "青色"
L.cyanDesc = "状态发生变化的警报，例如进入到下一阶段。"
L.purple = "紫色"
L.purpleDesc = "坦克特定技能的警报，例如减益效果叠加。"

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "倒数文本"
L.textCountdownDesc = "倒数时显示倒数文本。"
L.countdownColor = "倒数颜色"
L.countdownVoice = "倒数语音"
L.countdownTest = "测试倒数"
L.countdownAt = "倒数…（秒）"
L.countdownAt_desc = "选择倒计时开始时首领技能应剩余多少时间（以秒为单位）。"
L.countdown = "倒数"
L.countdownDesc = "倒数功能包括语音倒计时和倒数文本。默认情况下很少启用它，可以为任何首领技能启用它；可以在首领模块的技能列表内点击“>>”后进行指定技能倒数设置。"
L.countdownAudioHeader = "语音倒数"
L.countdownTextHeader = "可视文本倒数"
L.resetCountdownDesc = "重置所有倒数设置为默认。"
L.resetAllCountdownDesc = "如果你为任何首领战斗的设置“倒数”选项，此按钮将重置*所有*这些设置，并将上述所有“倒数”设置重置为默认。"

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infobox_short = "信息盒"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "通过 BigWigs 信息框显示。支持图标和颜色，同屏最多显示4条。新消息会通过放大再缩小的动画提醒注意。"
L.emphasizedSinkDescription = "通过 BigWigs 醒目信息框显示。支持文本和颜色，每次仅显示一条。"
L.resetMessagesDesc = "重置所有消息相关选项，包括消息锚点位置。"
L.toggleMessagesAnchorsBtnShow_desc = "显示所有可移动锚点，允许你调整消息显示位置。"

L.testMessagesBtn = "创建测试信息"
L.testMessagesBtn_desc = "创建一条测试信息，用于测试当前显示设置。"

L.bwEmphasized = "BigWigs 醒目"
L.messages = "信息"
L.emphasizedMessages = "醒目信息"
L.emphasizedDesc = "在屏幕中央以大号文字显示重要信息以引起注意。默认多数技能未启用，可在首领战斗设置中单独开启。"
L.uppercase = "大写"
L.uppercaseDesc = "全部醒目信息将转换为*大写*。"

L.useIcons = "使用图标"
L.useIconsDesc = "消息旁显示图标。"
L.classColors = "职业颜色"
L.classColorsDesc = "为信息中的玩家名称启用职业颜色。"
L.chatFrameMessages = "聊天框信息"
L.chatFrameMessagesDesc = "除了显示设置外，将所有 BigWigs 信息输出到默认聊天框。"

L.fontSize = "字体尺寸"
L.none = "无"
L.thin = "细"
L.thick = "粗"
L.outline = "轮廓"
L.monochrome = "单色"
L.monochromeDesc = "切换为单色模式，移除全部字体边缘平滑效果。"
L.fontColor = "字体颜色"
L.slugRendering = "Slug 渲染"
L.slugRenderingDesc = "使用 Slug 库进行字体渲染。这有时可以使大字号字体看起来更清晰，但可能会改变描边的大小。|cFF33FF99详情请访问 sluglibrary.com 。|r"

L.displayTime = "显示时间"
L.displayTimeDesc = "信息的显示时间（秒）。"
L.fadeTime = "消退时间"
L.fadeTimeDesc = "信息的消退时间（秒）。"

L.messagesOptInHeaderOff = "消息'手动选择'模式：启用此选项将关闭所有模块的消息。\n\n您需要逐个进入每个模块的设置，手动开启您想要的消息提示。\n\n"
L.messagesOptInHeaderOn = "消息'手动选择'模式已|cFF33FF99启用|r。要查看消息，请进入特定技能的设置并开启'|cFF33FF99消息|r'选项。\n\n"
L.messagesOptInTitle = "消息'手动选择'模式"
L.messagesOptInWarning = "|cffff4411警告！|r\n\n启用'手动选择'模式将关闭所有模块的消息。您需要逐个进入每个模块的设置，手动开启您想要的消息提示。\n\n界面即将重新加载，是否继续？"

-----------------------------------------------------------------------
-- Nameplates.lua
--

L.nameplates = "姓名板"
L.testNameplateIconBtn = "显示测试图标"
L.testNameplateIconBtn_desc = "创建一个测试图标，用于在目标姓名板上测试当前图标设置。"
L.testNameplateTextBtn = "显示测试文本"
L.testNameplateTextBtn_desc = "创建一个测试文本，用于在目标姓名板上测试当前文本设置。"
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
L.iconColorDesc = "更改图标材质的颜色"
L.desaturate = "饱和度"
L.desaturateDesc = "取消图标材质的饱和度"
L.zoom = "缩放"
L.zoomDesc = "缩放图标材质的尺寸。"
L.showBorder = "显示边框"
L.showBorderDesc = "显示图标的边框"
L.borderColor = "边框颜色"
L.borderSize = "边框厚度"
L.borderOffset = "边框偏移"
L.borderName = "边框材质"
L.showNumbers = "显示数字"
L.showNumbersDesc = "在图标上显示数字。"
L.cooldown = "冷却"
L.cooldownEmphasizeHeader = "默认情况下，醒目效果为关闭状态（0秒）。设置为1秒或更高时将会启用醒目效果。此功能可让您为这些数字设置不同的字体颜色和字体尺寸。"
L.showCooldownSwipe = "显示冷却动画"
L.showCooldownSwipeDesc = "当冷却激活时，在图标上显示转圈的动画效果。"
L.showCooldownEdge = "时针显示"
L.showCooldownEdgeDesc = "当冷却激活时，在图标上显示指针旋转的动画效果。"
L.inverse = "反转"
L.inverseSwipeDesc = "反转冷却时间的动画效果。"
L.glow = "发光效果"
L.enableExpireGlow = "启用冷却结束发光效果"
L.enableExpireGlowDesc = "当冷却时间结束时，在图标周围显示发光动画效果。"
L.glowColor = "发光颜色"
L.glowType = "发光样式"
L.glowTypeDesc = "更改图标周围显示的发光效果样式。"
L.resetNameplateIconsDesc = "重置与姓名板图标相关的所有选项。"
L.nameplateTextSettings = "文本设置"
L.fixate_test = "测试文本" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "重置与姓名板文本相关的所有选项。"
L.glowAt = "开始发光（秒）"
L.glowAt_desc = "选择在冷却计时剩余多少秒时触发发光效果。"
L.offsetX = "水平偏移"
L.offsetY = "垂直偏移"
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
-- PrivateAuras.lua
--

L.privateAuras = "私有光环"
L.privateAurasDesc1 = "“私有光环”是一种特殊的减益效果，插件既无法检测，也无法对其进行任何自动化操作。如今，这类机制已普遍应用于所有现代首领战中。\n\n"
L.privateAurasDesc2 = "BigWigs 会用醒目的图标为你单独显示这些效果，|cFF33FF99帮助你精准定位关键减益，不再受普通减益的干扰。|r\n\n"

L.createTestAura = "创建测试光环"
L.showDispelType = "显示驱散类型图标"
L.showDispelTypeDesc = "如果在私有光环框体上有驱散类型，则显示一个图标。\n\n|cffffd200注意：这是对所有私有光环框体的全局设置。|r"
L.iconSize = "图标尺寸"
L.iconSpacing = "图标间距"
L.showCooldown = "显示冷却转圈"
L.showCooldownText = "显示冷却文本"
L.cooldownTextScale = "冷却文本缩放"
L.growthDirection = "图标增长方向"
L.aurasOnYou = "你身上的光环"
L.aurasOnYouDesc = "自定义你身上的光环图标。\n\n"
L.aurasOnAnother = "其他玩家身上的光环"
L.aurasOnAnotherDesc = "选择一名特定玩家，然后为该玩家自定义光环图标。\n\n"
L.chooseAPlayer = "选择一名玩家"
L.theOtherTank = "自动寻找坦克"
L.theOtherTankDesc = "在你队伍中除你之外另一位坦克身上的私有光环。（当前：%s）"
L.onlyWhenYouAreTank = "仅当你是坦克时显示"
L.playerInYourGroup = "你队伍中的玩家"
L.maxIcons = "最大图标数"
L.maxIconsDesc = "显示图标的最大数量。"
L.privateAurasHelpTip = "|TInterface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid:0:0|tBigWigs：现在您可以显示自己的私有光环减益图标，甚至还可以显示其他玩家（例如坦克）的私有光环。"

L.privateAurasTestAnchorText = "私有\n光环\n（%d）"
L.privateAurasTestTankAnchorText = "坦克\n光环\n（%d）"

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "自定义距离指示器"
L.proximityTitle = "%d码/%d玩家" -- yd = yards (short)
L.proximity_name = "距离监视"
L.soundDelay = "音效延迟"
L.soundDelayDesc = "当有人距离你过近时，指定 BigWigs 重复播放音效的间隔时间。"

L.resetProximityDesc = "重置所有自定义距离指示器有关选项，包括锚点和位置。"

L.close = "关闭"
L.closeProximityDesc = "关闭距离监视显示。\n\n这是临时性的关闭，要完全禁用此功能，需进入相对应首领模块选项关闭“距离监视”功能。"
L.lock = "锁定"
L.lockDesc = "锁定显示窗口，防止被移动和缩放。"
L.title = "标题"
L.titleDesc = "显示或隐藏标题。"
L.background = "背景"
L.backgroundDesc = "显示或隐藏背景。"
L.toggleSound = "切换音效"
L.toggleSoundDesc = "当距离监视窗口中有人过近时，切换音效的开启或关闭。"
L.soundButton = "音效按钮"
L.soundButtonDesc = "显示或隐藏音效按钮。"
L.closeButton = "关闭按钮"
L.closeButtonDesc = "显示或隐藏关闭按钮。"
L.showHide = "显示/隐藏"
L.abilityName = "技能名称"
L.abilityNameDesc = "在窗口上方显示或隐藏技能名称。"
L.tooltip = "工具提示"
L.tooltipDesc = "显示或隐藏从首领战斗技能获取的法术提示。"

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "倒数类型"
L.combatLog = "自动战斗记录"
L.combatLogDesc = "当开怪倒数计时器开始到战斗结束时，自动开始战斗记录。"

L.pull = "开怪倒数"
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
L.raidIconsDescription = "某些技能（如炸弹、被追逐等）会指向特定玩家。你可以在此自定义团队标记来标记这些玩家。\n\n如果只有一种技能，则只会使用第一个图标。在某些战斗中，同一个图标不会用于两个不同的技能，每个技能每次都会使用相同的图标。\n\n|cffff4411注意：如果玩家已被手动标记，BigWigs 将不会更改他的图标。|r"
L.primary = "主要"
L.primaryDesc = "战斗时使用的第一个团队标记。"
L.secondary = "次要"
L.secondaryDesc = "战斗时使用的第二个团队标记。"

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "音效"
L.soundsDesc = "BigWigs 使用“主音量”通道播放所有音效。如果觉得音效过小或过大，请打开游戏声音设置并调整“主音量”滑块。\n\n下面可以全局配置为特定操作播放的不同音效，或将其设置为“None（无）”来禁用。如果只想更改特定首领技能的音效，可以在首领模块的技能列表中点击“>>”后进行指定设置。\n\n"
L.oldSounds = "传统音效"

L.Alarm = "警示"
L.Info = "信息"
L.Alert = "警告"
L.Long = "长响"
L.Warning = "警报"
L.onyou = "法术，增益或减益效果在你身上时"
L.underyou = "你需要移动，离开你脚下的法术范围"
L.privateaura = "只要“私有光环”出现在你身上"

L.customSoundDesc = "播放选定的自定义音效，而不是模块提供的默认音效。"
L.resetSoundDesc = "重置以上音效为默认。"
L.resetAllCustomSound = "如果你为所有首领战斗设置了自定义音效，此按钮将重置“所有”自定义音效为默认设置。"
L.soundResetPrint = "模块'|cFF436EEE%s|r'使用了一个名为'|cFF436EEE%s|r'的自定义音效，但该音效已不存在。已重置为默认。"

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "首领统计"
L.bossStatsDescription = "记录首领的各项统计数据：获胜次数、被击败次数、首次获胜日期、最快获胜时间。可在配置界面按首领查看。无记录的首领不显示。"
L.createTimeBar = "显示“最快获胜”计时条"
L.bestTimeBar = "最快时间"
L.healthPrint = "血量：%s。"
L.healthFormat = "%s （%.1f%%）"
L.chatMessages = "聊天信息"
L.newFastestVictoryOption = "新的最快记录"
L.victoryOption = "你取得了胜利"
L.defeatOption = "你被击败了"
L.bossHealthOption = "首领血量"
L.bossVictoryPrint = "你击败首领 “%s”，用时 %s 。" -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "你被首领 “%s” 击败，用时 %s 。" -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "新的最快记录：（-%s）" -- New fastest victory: (-COMBAT_DURATION)

-----------------------------------------------------------------------
-- Timeline.lua
--

L.timeline = "暴雪首领预警"
L.blizzTimelineSettings = "暴雪首领预警设置"
L.blizzTimelineSettingsNote = "|cffff4411本页选项仅控制暴雪内置首领预警。在此提供是为方便与 BigWigs 选项统一设置。|r"
L.enableBlizzTimeline = "启用暴雪内置首领预警"
L.enableBlizzTimelineDesc = "在暴雪内置首领技能的“类型”上显示所有首领战计时。"
L.show_bars = "显示来源"
L.bigwigsEnhancedTimers = "BigWigs 增强首领预警及计时条|cFF33FF99（推荐）|r"
L.blizzBasicAsBars = "暴雪内置首领预警显示在 BigWigs 计时条上"
L.blizzBasicAsBlizzTimeline = "暴雪内置首领预警及首领技能显示“类型”"
L.developerMode = "开发者模式"
L.enhancedModeWarning = "警告！\n\n禁用增强模式将禁用多项 BigWigs 功能，包括：\n\n计时条颜色、法术重命名、计数器、自定义声音/语音、倒计时、计时条开关、额外消息提示等。"
L.blizzTimelineEnhancedWarning = "警告！\n\n暴雪内置时间轴不支持 BigWigs 增强功能。你将无法看到重命名的法术，且计时可能不准确。\n\n确定要启用吗？"

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "胜利"
L.victoryHeader = "设置击败首领战斗之后的信息。"
L.victorySound = "播放胜利音效"
L.victoryMessages = "显示击败首领信息"
L.victoryMessageBigWigs = "显示 BigWigs 信息"
L.victoryMessageBigWigsDesc = "BigWigs 信息显示是简单的“首领已被击败”信息。"
L.victoryMessageBlizzard = "显示暴雪内置信息"
L.victoryMessageBlizzardDesc = "暴雪内置信息会以特效显示“首领已被击败”在动画上。"
L.defeated = "%s 被击败！"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "团灭"
L.wipeSoundTitle = "当团灭时播放音效"
L.respawn = "重生"
L.showRespawnBar = "显示重生倒数计时条"
L.showRespawnBarDesc = "当团灭后显示首领重生倒数计时条。"
