local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "zhCN")
if not L then return end

L.general = "一般"
L.advanced = "高级"
L.comma = "，"

L.positionX = "水平位置"
L.positionY = "垂直位置"
L.positionExact = "精确位置"
L.positionDesc = "在框中输入数值或移动滑条精准定位锚点位置。"
L.width = "宽度"
L.height = "高度"
L.sizeDesc = "通常情况下，您可以通过移动滑条来设置尺寸。如果需要精确的尺寸，可以使用该滑条下面的数字框中输入数值（需有效数值）。"
L.fontSizeDesc = "使用滑条或在框内输入数值可调整字体尺寸，最大数值为200。"
L.disabled = "禁用"
L.disableDesc = "将禁用“%s”功能，但|cffff4411不建议|r这么做。\n\n你确定要这么做吗？"

-- Anchor Points
L.UP = "向上"
L.DOWN = "向下"
L.TOP = "顶部"
L.RIGHT = "右侧"
L.BOTTOM = "底部"
L.LEFT = "左侧"
L.TOPRIGHT = "右上"
L.TOPLEFT = "左上"
L.BOTTOMRIGHT = "右下"
L.BOTTOMLEFT = "左下"
L.CENTER = "中心"
L.customAnchorPoint = "高级：自定义锚点"
L.sourcePoint = "源点"
L.destinationPoint = "目标点"

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
L.countdown = "倒数"
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
L.keepAspectRatioDesc = "保持图标的宽高比为1:1，而不是将其拉伸以适应姓名板框体大小。"
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
L.showNumbers = "显示数字"
L.showNumbersDesc = "在图标上显示数字。"
L.cooldown = "冷却"
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
L.autoScale = "自动缩放"
L.autoScaleDesc = "根据姓名板的比例自动缩放图标比例。"
L.glowAt = "开始高亮（秒）"
L.glowAt_desc = "选择在冷却计时剩余多少秒时开始高亮。"

-- Glow types as part of LibCustomGlow
L.pixelGlow = "像素发光"
L.autocastGlow = "自动施法发光"
L.buttonGlow = "快捷键发光"
L.procGlow = "脉冲发光"
L.speed = "速度"
L.animation_speed_desc = "发光动画效果的播放速度。"
L.lines = "线条"
L.lines_glow_desc = "设置发光动画效果中几条线条"
L.intensity = "强度"
L.intensity_glow_desc = "设置发光动画的强度，强度越高，闪光点越多。"
L.length = "长度"
L.length_glow_desc = "设置发光动画效果中线条的长度。"
L.thickness = "粗细"
L.thickness_glow_desc = "设置发光动画效果中线条的粗细。"
L.scale = "缩放"
L.scale_glow_desc = "调整发光动画中闪光点的大小。"
L.startAnimation = "起始动画"
L.startAnimation_glow_desc = "您选择的发光效果有起始动画特效，通常是一个闪烁。这个选项可以选择启用/禁用起始动画。"

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
L.pullFinishedSoundTitle = "当开怪倒数计时器结束时播放音效"
L.pullStartedBy = "%s 发起开怪倒数计时。"
L.pullStopped = "%s 取消了开怪倒数计时。"
L.pullStoppedCombat = "开怪倒数计时器因进入战斗而取消。"
L.pullIn = "%d 秒后开怪"
L.sendPull = "向您的队伍/团队发送开怪倒数计时器。"
L.wrongPullFormat = "无效的开怪倒数。正确用法：/pull 5"
L.countdownBegins = "开始倒计时"
L.countdownBegins_desc = "选择开怪计时器上倒计开始时应剩余多少时间（以秒为单位）。"

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

L.sound = "音效"

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
