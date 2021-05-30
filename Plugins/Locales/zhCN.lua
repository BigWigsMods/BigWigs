local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "zhCN")
if not L then return end

L.general = "一般"
L.comma = "，"

L.positionX = "X 座标"
L.positionY = "Y 座标"
L.positionExact = "精确位置"
L.positionDesc = "在框中输入或移动滑块精准定位锚点位置。"
L.width = "宽度"
L.height = "高度"
L.sizeDesc = "通常通过拖动锚点设置尺寸。如果需要一个精确的尺寸，可以使用这个滑动条或者将数值输入到没有最大值的框中。"
L.fontSizeDesc = "使用滑块或在框内输入数值可调整字体尺寸，最大数值为200。"
L.disableDesc = "将禁用“%s”功能，但|cffff4411不建议|r这么做。\n\n你确定要这么做吗？"
L.transparency = "透明度"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "交替能量"
L.altPowerDesc = "仅在向玩家应用的首领出现交替能量显示，这极为罕见。将显示您和团队拥有的“交替能量”，其中团队的交替能量以列表显示。要移动或显示框架，请使用下面的测试按钮。"
L.toggleDisplayPrint = "显示将在下次出现。完全禁用此首领战斗，需在首领战斗选项中切换关闭。"
L.disabled = "禁用"
L.disabledDisplayDesc = "禁用全部模块显示。"
L.resetAltPowerDesc = "重置全部交替能量有关选项，包括交替能量锚点位置。"
L.test = "测试"
L.altPowerTestDesc = "显示“交替能量”，可以移动，并模拟在首领战斗时会看到的能量变化。"
L.yourPowerBar = "你的能量条"
L.barColor = "条颜色"
L.barTextColor = "条文本颜色"
L.additionalWidth = "附加宽度"
L.additionalHeight = "附加高度"
L.additionalSizeDesc = "调整此滑块可增加标准显示的尺寸，或在框内输入数值，最大数值为100。"
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

L.nameplateBars = "姓名板条"
L.nameplateAutoWidth = "匹配姓名板宽度"
L.nameplateAutoWidthDesc = "将姓名板条的宽度设置为其主姓名板。"
L.nameplateOffsetY = "Y 偏移量"
L.nameplateOffsetYDesc = "从姓名板顶部偏移量为向上的条，从姓名板底部偏移量为向下的条。"
L.nameplateAlphaDesc = "控制姓名板条的透明度。"

L.clickableBars = "可点击计时条"
L.clickableBarsDesc = "BigWigs 计时条默认是点击穿越的。这样一来，当鼠标指针划过计时条，你仍然可以选择目标或使用 AoE 法术攻击物体、更改镜头角度等等。|cffff4411如果启用可点击计时条，这些将不能实现。|r计时条将拦截任何鼠标点击并阻止相应功能。\n"
L.interceptMouseDesc = "启用计时条接受点击。"
L.modifier = "修改"
L.modifierDesc = "按住选定的修改键以启用计时条点击操作。"
L.modifierKey = "只与修改键配合"
L.modifierKeyDesc = "除非修改键被按下否则允许计时条点击穿越，此时鼠标以下动作可用。"

L.temporaryCountdownDesc = "暂时启用与此计时条关联技能的倒计时。"
L.report = "报告"
L.reportDesc = "向当前的频道报告计时条信息。可用频道包括副本、团队、小队、普通，自动选择最适频道。"
L.remove = "移除"
L.removeBarDesc = "暂时移除此计时条。"
L.removeOther = "移除其它"
L.removeOtherBarDesc = "暂时移除这一个之外的其它全部计时条。"

L.emphasizeAt = "…（秒）后醒目"
L.growingUpwards = "向上成长"
L.growingUpwardsDesc = "切换在锚点向上或向下成长。"
L.texture = "材质"
L.emphasize = "醒目"
L.emphasizeMultiplier = "尺寸倍数"
L.emphasizeMultiplierDesc = "如禁用计时条移向醒目锚点，此选项将决定以一般计时条乘以尺寸倍数作为醒目计时条的尺寸。"

L.enable = "启用"
L.move = "移动"
L.moveDesc = "移动醒目计时条到醒目锚点。如此选项关闭，醒目计时条将只简单的改变缩放和颜色。"
L.emphasizedBars = "醒目计时条"
L.align = "对齐"
L.alignText = "文本对齐"
L.alignTime = "时间对齐"
L.left = "左"
L.center = "中"
L.right = "右"
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
L.wrongTime = "指定了无效的时间。 <时间>可以是一个以秒为单位，一个分:秒一对，或分秒。例如，1:20或2M。"

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
L.bossBlockDesc = "配置在首领战斗中可以多项屏蔽。\n\n"
L.bossBlockAudioDesc = "配置在首领战斗中哪些音效将被静音。\n\n魔兽世界任意已禁用的声音选项在这里将显示为|cff808080灰色|r。\n\n"
L.movieBlocked = "以前观看过此动画，跳过。"
L.blockEmotes = "屏蔽屏幕中央表情"
L.blockEmotesDesc = "一些首领某些技能会显示表情，这些信息会两种方式显示并有太长的描述。尝试让它们小一些，更紧凑的消息不会影响游戏过程，并且不会告诉你具体做什么。\n\n请注意：如果你要看首领表情，它们仍会显示在聊天窗口。"
L.blockMovies = "屏蔽重播电影"
L.blockMoviesDesc = "首领战斗电影将只允许播放一次（所以可以观看每一个），下次重播将被屏蔽掉。"
L.blockFollowerMission = "屏蔽追随者任务弹出窗口"
L.blockFollowerMissionDesc = "追随者任务弹出窗口会显示一些事情，但主要是追随者任务已经完成。\n\n这些弹出窗口会在首领战斗时覆盖在你重要的用户界面之上，所以建议屏蔽它们。"
L.blockGuildChallenge = "屏蔽公会挑战弹出窗口"
L.blockGuildChallengeDesc = "公会挑战弹出窗口会显示一些信息，主要是公会的队伍完成了英雄地下城或挑战模式地下城。\n\n这些弹出窗口会在首领战斗时覆盖在你重要的用户界面之上，所以建议屏蔽它们。"
L.blockSpellErrors = "屏蔽法术失败信息"
L.blockSpellErrorsDesc = "通常在屏幕顶部显示的信息类似于“法术还没有准备好”将被屏蔽掉。"
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
L.blockObjectiveTracker = "隐藏任务追踪器"
L.blockObjectiveTrackerDesc = "在首领战斗中将任务追踪器隐藏，以给屏幕空出更多空间。\n\n此功能在史诗钥石或追踪成就时无效。"

L.blockTalkingHead = "隐藏 NPC 说话时弹出的“对话头像”"
L.blockTalkingHeadDesc = "当 NPC 头像和聊天文本在屏幕中央下方的一个弹出的对话盒子称为“对话头像”，|cffff4411有时候|r会在 NPC 讲话时显示。\n\n可以选择不同类型设定为禁止显示。\n\n|cFF33FF99请注意：|r\n 1) 此功能将允许 NPC 语音继续播放所以可以继续听到对话。\n 2) 为了安全起见，只有特定的对话头像会被屏蔽，任何特殊或独特的对话如一次性任务，都不会被屏蔽。 "
L.blockTalkingHeadDungeons = "普通和英雄地下城"
L.blockTalkingHeadMythics = "史诗和史诗钥石地下城"
L.blockTalkingHeadRaids = "团队"
L.blockTalkingHeadTimewalking = "时空漫游（地下城和团队）"
L.blockTalkingHeadScenarios = "场景事件"

L.subzone_grand_bazaar = "百商集市" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "赞达拉港" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "东侧耳堂" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "颜色"

L.text = "文本"
L.textShadow = "文本阴影"
L.flash = "闪烁"
L.normal = "标准"
L.emphasized = "醒目"

L.reset = "重置"
L.resetDesc = "重置以上颜色为默认。"
L.resetAll = "重置所有"
L.resetAllDesc = "如果为首领战斗自定义了颜色设置，这个按钮将重置替换“所有”颜色为默认。"

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
L.purple = "粉色"
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
L.countdown = "倒计时"
L.countdownDesc = "倒数功能包括语音倒计时和可视文字倒计时。默认情况下很少启用它，但是在查看特定的首领战斗设置时，可以为任何首领技能启用它。"
L.countdownAudioHeader = "语音倒计时"
L.countdownTextHeader = "可视文字倒计时"
L.resetCountdownDesc = "重置全部以上倒计时设置为默认。"
L.resetAllCountdownDesc = "如果为任何首领战斗的设置选择了自定义倒计时声音，此按钮将重置*所有*这些声音并将上述所有倒计时设置重置为默认。"

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "信息盒"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "向外通过 BigWigs 插件信息显示。这些包含了图标，颜色和在同一时间在屏幕上的显示4条信息。新的信息将再一次快速的放大和缩小来提醒用户。新插入的信息将增大并立即缩小提醒用户注意。"
L.emphasizedSinkDescription = "通过此插件输出到 BigWigs 醒目信息显示。此显示支持文本和颜色，每次只可显示一条信息。"
L.resetMessagesDesc = "重置全部信息有关选项，包括信息锚点位置。"

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
L.combatLogDesc = "当拉怪计时器开始到战斗结束时自动开始战斗记录。"

L.pull = "拉怪"
L.engageSoundTitle = "当首领战斗开始时播放音效"
L.pullStartedSoundTitle = "当拉怪计时器开始时播放音效"
L.pullFinishedSoundTitle = "当拉怪计时器结束时播放音效"
L.pullStarted = "拉怪由%s玩家%s发起的计时器。"
L.pullStopped = "%s取消了拉怪计时器。"
L.pullStoppedCombat = "拉怪计时器因进入战斗而取消。"
L.pullIn = "%d秒后拉怪"
L.sendPull = "正在发送一个拉怪计时器到 BigWigs 和 DBM 玩家。"
L.wrongPullFormat = "必须位于1到60秒之间。正确用法：/pull 5"
L.countdownBegins = "开始倒计时"
L.countdownBegins_desc = "选择拉怪计时器上倒计开始时应剩余多少时间（以秒为单位）。"

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
L.soundsDesc = "BigWigs 使用“主音量”通道播放全部音效。如果发现音效过小或过大，打开游戏声音设置并调整“主音量”滑块到所需的级别。\n\n下面可以全局配置为特定操作播放的不同音效，或将它们设置为“无”以将其禁用。如果只想更改特定首领技能音效，可以在首领战斗进行设置。\n\n"
L.oldSounds = "传统音效"

L.Alarm = "警示"
L.Info = "信息"
L.Alert = "警告"
L.Long = "长响"
L.Warning = "警报"
L.onyou = "一个法术，增益或负面效果在你身上"
L.underyou = "你需要移动，离开你脚下的法术范围"

L.sound = "音效"

L.customSoundDesc = "播放选定的自定义的声音，而不是由模块提供的。"
L.resetSoundDesc = "重置以上音效为默认。"
L.resetAllCustomSound = "如果设置全部首领战斗自定义的声音，此按钮将重置“全部”以这里自定义的声音来代替。"

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossDefeatDurationPrint = "“%s”已被击杀，用时%s。"
L.bossWipeDurationPrint = "“%s”战斗团灭，用时%s。"
L.newBestTime = "新的最快击杀！"
L.bossStatistics = "首领统计"
L.bossStatsDescription = "首领战斗相关的统计数据，如首领被击杀数量、团灭次数、战斗持续时间和最快的首领击杀记录。可以在配置屏幕上查看每个首领的统计数据，没有首领记录的统计数据会被隐藏。"
L.enableStats = "启用统计"
L.chatMessages = "聊天信息"
L.printBestTimeOption = "最快击杀提醒"
L.printDefeatOption = "击杀时间"
L.printWipeOption = "团灭时间"
L.countDefeats = "击杀次数"
L.countWipes = "团灭次数"
L.recordBestTime = "记忆最快击杀"
L.createTimeBar = "显示“最快击杀”计时条"
L.bestTimeBar = "最快时间"
L.printHealthOption = "首领血量"
L.healthPrint = "血量：%s。"
L.healthFormat = "%s （%.1f%%）"

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
L.respawn = "重生"
L.showRespawnBar = "显示重生计时条"
L.showRespawnBarDesc = "当团灭之后显示首领重生计时条。"
