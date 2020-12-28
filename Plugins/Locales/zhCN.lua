local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "zhCN")
if not L then return end

L.comma = "，"
L.width = "宽度"
L.height = "高度"
L.sizeDesc = "通常通过拖动锚点设置尺寸。如果需要一个精确的尺寸，可以使用这个滑动条或者将数值输入到没有最大值的框中。"

L.abilityName = "技能名称"
L.abilityNameDesc = "在窗口上面显示或隐藏技能名称。"
L.Alarm = "警示"
L.Alert = "警告"
L.align = "对齐"
L.alignText = "文本对齐"
L.alignTime = "时间对齐"
L.altPowerTitle = "交替能量"
L.background = "背景"
L.backgroundDesc = "显示或隐藏背景。"
L.bars = "计时条"
L.nameplateBars = "姓名板条"
L.nameplateAutoWidth = "匹配姓名板宽度"
L.nameplateAutoWidthDesc = "将姓名板条的宽度设置为其主姓名板。"
L.nameplateOffsetY = "Y 偏移量"
L.nameplateOffsetYDesc = "从姓名板顶部偏移量为向上的条，从姓名板底部偏移量为向下的条。"
L.bestTimeBar = "最快时间"
L.bigWigsBarStyleName_Default = "默认"
L.blockEmotes = "屏蔽屏幕中央表情"
L.blockEmotesDesc = [=[一些首领某些技能会显示表情，这些信息会两种方式显示并有太长的描述。尝试让它们小一些，更紧凑的消息不会影响游戏过程，并且不会告诉你具体做什么。

请注意：首领表情仍将在聊天窗口显示如果你需要看它们的话。]=]
L.blockGuildChallenge = "屏蔽公会挑战弹出窗口"
L.blockGuildChallengeDesc = [=[公会挑战弹出窗口会显示一些事情，主要是公会的队伍完成了英雄地下城或挑战模式地下城。

这些弹出窗口会在首领战斗时覆盖在你重要的用户界面之上，所以建议屏蔽它们。]=]
L.blockMovies = "屏蔽重播电影"
L.blockMoviesDesc = "首领战斗电影将只允许播放一次（所以可以观看每一个），下次重播将被屏蔽掉。"
L.blockSpellErrors = "屏蔽法术失败信息"
L.blockSpellErrorsDesc = "通常在屏幕顶部显示的信息类似于“法术还没有准备好”将被屏蔽掉。"
L.bossBlock = "首领屏蔽"
L.bossBlockDesc = "在首领战斗中可以配置多项屏蔽。"
L.bossDefeatDurationPrint = "“%s”已被击杀，用时%s。"
L.bossStatistics = "首领统计"
L.bossStatsDescription = "首领战斗相关的统计数据，如首领被击杀数量，团灭次数，战斗持续时间，最快的首领击杀记录。可以在配置屏幕上查看每个首领的统计数据，没有首领记录的统计数据会被隐藏。"
L.bossWipeDurationPrint = "“%s”战斗团灭，用时%s。"
L.breakBar = "休息时间"
L.breakFinished = "休息时间结束！"
L.breakMinutes = "休息时间将在 %d 分钟后结束！"
L.breakSeconds = "休息时间将在 %d 秒后结束！"
L.breakStarted = "休息时间计时器由 %s 用户 %s 发起。"
L.breakStopped = "休息时间计时器被 %s 取消了。"
L.bwEmphasized = "BigWigs 醒目"
L.center = "中"
L.chatMessages = "聊天信息"
L.classColors = "职业颜色"
L.classColorsDesc = "玩家名称使用职业颜色。"
L.clickableBars = "可点击计时条"
L.clickableBarsDesc = [=[BigWigs 计时条预设是点击穿越的。这样可以选择目标或使用 AoE 法术攻击物体，更改镜头角度等等，当鼠标指针划过计时条。|cffff4411如果启用可点击计时条，这些将不能实现。|r计时条将拦截任何鼠标点击并阻止相应功能。
]=]
L.close = "关闭"
L.closeButton = "关闭按钮"
L.closeButtonDesc = "显示或隐藏关闭按钮。"
L.closeProximityDesc = [=[关闭近距离显示。

要完全禁用此任一功能，需进入相对应首领模块选项关闭“近距离”功能。]=]
L.colors = "颜色"
L.combatLog = "自动战斗记录"
L.combatLogDesc = "当拉怪计时器开始到战斗结束时自动开始战斗记录。"
L.countDefeats = "击杀次数"
L.countdownAt = "倒数…（秒）"
L.countdownColor = "倒数颜色"
L.countdownTest = "测试倒数"
L.countdownType = "倒数类型"
L.countdownVoice = "倒数语音"
L.countWipes = "团灭次数"
L.createTimeBar = "显示“最快击杀”计时条"
L.customBarStarted = "自定义计时条“%s”由%s玩家%s发起。"
L.customRange = "自定义距离指示器"
L.customSoundDesc = "播放选定的自定义的声音，而不是由模块提供的。"
L.defeated = "%s被击败了！"
L.disable = "禁用"
L.disabled = "禁用"
L.disabledDisplayDesc = "禁用全部模块显示。"
L.disableDesc = "永久禁用此首领战斗技能计时条选项。"
L.displayTime = "显示时间"
L.displayTimeDesc = "以秒计信息显示时间。"
L.emphasize = "醒目"
L.emphasizeAt = "…（秒）后醒目"
L.emphasized = "醒目"
L.emphasizedBars = "醒目计时条"
L.emphasizedCountdownSinkDescription = "路线输出从此插件通过 BigWigs 醒目冷却信息显示。此显示支持文本和颜色，一次只能显示一个消息。"
L.emphasizedMessages = "醒目信息"
L.emphasizedSinkDescription = "通过此插件输出到 BigWigs 醒目信息显示。此显示支持文本和颜色，每次只可显示一条信息。"
L.enable = "启用"
L.enableStats = "启用统计"
L.encounterRestricted = "此功能在战斗中不能使用。"
L.fadeTime = "消退时间"
L.fadeTimeDesc = "以秒计信息消退时间。"
L.fill = "填充"
L.fillDesc = "填充计时条而不是显示为空。"
L.flash = "闪烁"
L.font = "字体"
L.fontColor = "字体颜色"
L.fontSize = "字体尺寸"
L.general = "一般"
L.growingUpwards = "向上成长"
L.growingUpwardsDesc = "切换在锚点向上或向下成长。"
L.icon = "图标"
L.iconDesc = "显示或隐藏计时条图标。"
L.icons = "图标"
L.Info = "信息"
L.interceptMouseDesc = "启用计时条接受点击。"
L.left = "左"
L.localTimer = "本地"
L.lock = "锁定"
L.lockDesc = "锁定显示窗口，防止被移动和缩放。"
L.Long = "长响"
L.messages = "信息"
L.modifier = "修改"
L.modifierDesc = "按住选定的修改键以启用计时条点击操作。"
L.modifierKey = "只与修改键配合"
L.modifierKeyDesc = "除非修改键被按下否则允许计时条点击穿越，此时鼠标以下动作可用。"
L.monochrome = "单一颜色"
L.monochromeDesc = "切换为单一颜色，移除全部字体边缘平滑。"
L.move = "移动"
L.moveDesc = "移动醒目计时条到醒目锚点。如此选项关闭，醒目计时条将只简单的改变缩放和颜色。"
L.movieBlocked = "以前观看过此动画，跳过。"
L.newBestTime = "新的最快击杀！"
L.none = "无"
L.normal = "标准"
L.normalMessages = "一般信息"
L.outline = "轮廓"
L.output = "输出"
L.positionDesc = "在框中输入或移动滑块精准定位锚点位置。"
L.positionExact = "精确位置"
L.positionX = "X 位置"
L.positionY = "Y 位置"
L.primary = "主要"
L.primaryDesc = "战斗时使用的第一个团队标记。"
L.printBestTimeOption = "最快击杀提醒"
L.printDefeatOption = "击杀时间"
L.printWipeOption = "团灭时间"
L.proximity = "近距离"
L.proximity_desc = "显示近距离窗口，列出距离你很近的玩家。"
L.proximity_name = "近距离"
L.proximityTitle = "%d码/%d玩家"
L.pull = "拉怪"
L.pullIn = "%d秒后拉怪"
L.engageSoundTitle = "当首领战斗开始时播放音效"
L.pullStartedSoundTitle = "当拉怪计时器开始时播放音效"
L.pullFinishedSoundTitle = "当拉怪计时器结束时播放音效"
L.pullStarted = "拉怪由%s玩家%s发起的计时器。"
L.pullStopped = "%s取消了拉怪计时器。"
L.pullStoppedCombat = "拉怪计时器因进入战斗而取消。"
L.raidIconsDesc = [=[团队中有些首领模块使用团队标记来为某些中了特定技能的队员打上标记。例如类似“炸弹”类或心灵控制的技能。如果你关闭此功能，你将不会给队员打标记。

|cffff4411只有团队领袖或被提升为助理时才可以这么做！|r]=]
L.raidIconsDescription = [=[可能遇到包含例如炸弹类型的技能指向特定的玩家，玩家被追，或是特定玩家可能有兴趣在其他方面。这里可以自定义团队标记来标记这些玩家。

如果只遇到一种技能，很好，只有第一个图标会被使用。在某些战斗中一个图标不会使用在两个不同的技能上，任何特定技能在下次总是使用相同图标。

|cffff4411注意：如果玩家已经被手动标记，BigWigs 将不会改变他的图标。|r]=]
L.recordBestTime = "记忆最快击杀"
L.regularBars = "常规计时条"
L.remove = "移除"
L.removeDesc = "临时移除计时条和全部相关信息。"
L.removeOther = "移除其它"
L.removeOtherDesc = "临时移除所有计时条（除此之外）和全部相关信息。"
L.report = "报告"
L.reportDesc = "向当前的频道报告计时条信息。可用频道包括副本、团队、小队、普通，自动选择最适频道。"
L.requiresLeadOrAssist = "此功能需要团队领袖或助理权限。"
L.reset = "重置"
L.resetAll = "重置所有"
L.resetAllCustomSound = "如果设置全部首领战斗自定义的声音，此按钮将重置“全部”以这里自定义的声音来代替。"
L.resetAllDesc = "如果为首领战斗自定义了颜色设置，这个按钮将重置替换“所有”颜色为默认。"
L.resetDesc = "重置以上颜色为默认。"
L.respawn = "重生"
L.restart = "重新加载"
L.restartDesc = "重新加载醒目计时条并从10开始倒数。"
L.right = "右"
L.secondary = "次要"
L.secondaryDesc = "战斗时使用的第二个团队标记。"
L.sendBreak = "发送休息时间计时器到 BigWigs 和 DBM 用户。"
L.sendCustomBar = "正在发送自定义计时条“%s”到 BigWigs 和 DBM 玩家。"
L.sendPull = "正在发送一个拉怪计时器到 BigWigs 和 DBM 玩家。"
L.showHide = "显示/隐藏"
L.showRespawnBar = "显示重生计时条"
L.showRespawnBarDesc = "当团灭之后显示首领重生计时条。"
L.sinkDescription = "向外通过 BigWigs 插件信息显示。这些包含了图标，颜色和在同一时间在屏幕上的显示4条信息。新的信息将再一次快速的放大和缩小来提醒用户。新插入的信息将增大并立即缩小提醒用户注意。"
L.sound = "音效"
L.soundButton = "音效按钮"
L.soundButtonDesc = "显示或隐藏音效按钮。"
L.soundDelay = "音效延迟"
L.soundDelayDesc = "当有人太靠近你时指定多长时间 BigWigs 重复间隔等待指定的音效。"
L.soundDesc = "信息出现时伴随着音效。有些人更容易在听到何种音效后发现何种警报，而不是阅读的实际信息。"
L.Sounds = "音效"
L.style = "风格"
L.superEmphasize = "超级醒目"
L.superEmphasizeDesc = [=[相关信息或特定首领战斗技能计时条增强。

在这里设置当开启超级醒目位于首领战斗技能高级选项时所应该发生的事件。

|cffff4411注意：超级醒目功能默认情况下所有技能关闭。|r
]=]
L.superEmphasizeDisableDesc = "对所有模块禁用超级醒目。"
L.tempEmphasize = "临时超级醒目计时条及任何信息的持续时间。"
L.text = "文本"
L.textCountdown = "倒数文本"
L.textCountdownDesc = "当倒数时显示可见数字。"
L.textShadow = "文本阴影"
L.texture = "材质"
L.thick = "粗"
L.thin = "细"
L.time = "时间"
L.timeDesc = "在计时条上显示或隐藏时间。"
L.timerFinished = "%s：计时条[%s]到时间。"
L.title = "标题"
L.titleDesc = "显示或隐藏标题。"
L.toggleDisplayPrint = "显示将在下次出现。完全禁用此首领战斗，需在首领战斗选项中切换关闭。"
L.toggleSound = "切换音效"
L.toggleSoundDesc = "当近距离窗口有其他过近玩家时切换任一或关闭音效。"
L.tooltip = "提示"
L.tooltipDesc = "显示或隐藏近距离显示从首领战斗技能获取的法术提示。"
L.uppercase = "大写"
L.uppercaseDesc = "所有超级醒目选项相关信息大写。"
L.useIcons = "使用图标"
L.useIconsDesc = "消息旁显示图标。"
L.Victory = "胜利"
L.victoryHeader = "配置击败首领战斗之后的动作。"
L.victoryMessageBigWigs = "显示 BigWigs 信息"
L.victoryMessageBigWigsDesc = "BigWigs 的“首领已被击败”信息很简单。"
L.victoryMessageBlizzard = "显示暴雪信息"
L.victoryMessageBlizzardDesc = "位于屏幕中央的暴雪动画“首领已被击败”信息过长。"
L.victoryMessages = "显示击败首领信息"
L.victorySound = "播放胜利音效"
L.Warning = "警报"
L.wipe = "团灭"
L.wipeSoundTitle = "当团灭时播放音效"
L.wrongBreakFormat = "必须位于1至60分钟之间。正确用法：/break 5"
L.wrongCustomBarFormat = "错误格式。正确用法：/raidbar 20 文本"
L.wrongPullFormat = "必须位于1到60秒之间。正确用法：/pull 5"
L.wrongTime = "指定了无效的时间。 <时间>可以是一个以秒为单位，一个分:秒一对，或分秒。例如，1:20或2M。"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.resetAltPowerDesc = "重置全部交替能量有关选项，包括交替能量锚点位置。"

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

L.autoReplyLeftCombatBasic = "与首领战斗已结束。"
L.autoReplyLeftCombatNormalWin = "与“%s”战斗取得了胜利。"
L.autoReplyLeftCombatNormalWipe = "与“%s”战斗团灭。"
L.autoReplyLeftCombatAdvancedWin = "与“%s”战斗取得了胜利，%d/%d人存活。"
L.autoReplyLeftCombatAdvancedWipe = "与“%s”战斗团灭：%s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.spacing = "间隙"
L.spacingDesc = "更每个改计时条之间间隙。"
L.emphasizeMultiplier = "尺寸倍数"
L.emphasizeMultiplierDesc = "如禁用计时条移向醒目锚点，此选项将决定以一般计时条乘以倍数作为醒目计时条的尺寸。"
L.iconPosition = "图标位置"
L.iconPositionDesc = "选择计时条上图标的位置。"
L.visibleBarLimit = "可视条限制"
L.visibleBarLimitDesc = "设定同时可见最大条的数量。"
L.textDesc = "显示或隐藏计时条上的文本。"
L.resetBarsDesc = "重置全部计时条有关选项，包括计时条锚点位置。"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.audio = "语音"
L.music = "音乐"
L.ambience = "环境音效"
L.sfx = "声音效果"
L.disableMusic = "音乐静音（推荐）"
L.disableAmbience = "环境音效静音（推荐）"
L.disableSfx = "声音效果静音（不推荐）"
L.disableAudioDesc = "魔兽世界声音选项中的“%s”选项将被关闭，当首领战斗结束后会重新打开。这可以帮助集中注意力放在 BigWigs 警报音效上。"
L.blockTooltipQuests = "屏蔽提示任务物品"
L.blockTooltipQuestsDesc = "当需要因任务击杀首领时，通常在鼠标悬停在首领上会显示为“0/1 完成”的提示。此功能将在战斗中将其隐藏以防止提示变得非常大。"
L.blockFollowerMission = "屏蔽追随者任务弹出窗口"
L.blockFollowerMissionDesc = "追随者任务弹出窗口会显示一些事情，但主要是追随者任务已经完成。\n\n这些弹出窗口会在首领战斗时覆盖在你重要的用户界面之上，所以建议屏蔽它们。"
L.blockObjectiveTracker = "隐藏任务追踪器"
L.blockObjectiveTrackerDesc = "任务追踪器将在首领战斗中隐藏以给屏幕空出更多空间。\n\n此功能在史诗钥石或追踪成就时无效。"

L.subzone_grand_bazaar = "百商集市" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "赞达拉港" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "东侧耳堂" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

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

--L.countdownAt_desc = "Choose how much time should be remaining on a boss ability (in seconds) when the countdown begins."
--L.countdown = "Countdown"
--L.countdownDesc = "The countdown feature involves a spoken audio countdown and a visual text countdown. It can be enabled for any boss ability (in the boss abilities section) if the ability is on a timer, but is rarely enabled by default."
--L.countdownAudioHeader = "Spoken Audio Countdown"
--L.countdownTextHeader = "Visual Text Countdown"
--L.resetCountdownDesc = "Resets all the above countdown settings to their defaults."
--L.resetAllCountdownDesc = "If you've selected custom countdown voices for any boss encounter settings, this button will reset ALL of them as well as resetting all the above countdown settings to their defaults."

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infoBox = "信息盒"

-----------------------------------------------------------------------
-- Messages.lua
--

L.resetMessagesDesc = "重置全部信息有关选项，包括信息锚点位置。"

-----------------------------------------------------------------------
-- Proximity.lua
--

L.resetProximityDesc = "重置全部近距离有关选项，包括近距离锚点位置。"

-----------------------------------------------------------------------
-- Sound.lua
--

--L.oldSounds = "Old Sounds"
L.resetSoundDesc = "重置以上音效为默认。"
--L.onyou = "A spell, buff, or debuff is on you"
--L.underyou = "You need to move out of a spell under you"

-----------------------------------------------------------------------
-- Statistics.lua
--

L.printHealthOption = "首领血量"
L.healthPrint = "血量：%s。"
L.healthFormat = "%s （%.1f%%）"
