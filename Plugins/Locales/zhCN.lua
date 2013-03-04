local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "zhCN")
if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = "风格"
L.bigWigsBarStyleName_Default = "默认"

L["Clickable Bars"] = "可点击计时条"
L.clickableBarsDesc = "Big Wigs 计时条预设是点击穿越的。这样可以选择目标或使用 AoE 法术攻击物体，更改镜头角度等等，当滑鼠指针划过计时条。|cffff4411如果启用可点击计时条，这些将不能实现。|r计时条将拦截任何鼠标点击并阻止相应功能。\n"
L["Enables bars to receive mouse clicks."] = "启用计时条接受点击。"
L["Modifier"] = "修改"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "按住选定的修改键以启用计时条点击操作。"
L["Only with modifier key"] = "只与修改键配合"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "除非修改键被按下否则允许计时条点击穿越，此时鼠标以下动作可用。"

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "临时超级醒目计时条及任何讯息的持续时间。"
L["Report"] = "报告"
L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = "向当前的频道报告计时条信息。可用频道包括副本、团队、小队、普通，自动选择最适频道。"
L["Remove"] = "移除"
L["Temporarily removes the bar and all associated messages."] = "临时移除计时条和全部相关信息。"
L["Remove other"] = "移除其它"
L["Temporarily removes all other bars (except this one) and associated messages."] = "临时移除所有计时条（除此之外）和全部相关信息。"
L["Disable"] = "禁用"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "永久禁用此首领战斗技能计时条选项。"

L["Scale"] = "缩放"
L["Grow upwards"] = "向上成长"
L["Toggle bars grow upwards/downwards from anchor."] = "切换计时条在锚点向上或向下成长。"
L["Texture"] = "材质"
L["Emphasize"] = "醒目"
L["Enable"] = "启用"
L["Move"] = "移动"
--L.moveDesc = "Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color."
L["Regular bars"] = "常规计时条"
L["Emphasized bars"] = "醒目计时条"
L["Align"] = "对齐"
L["Left"] = "左"
L["Center"] = "中"
L["Right"] = "右"
L["Time"] = "时间"
L["Whether to show or hide the time left on the bars."] = "在计时条上显示或隐藏时间。"
L["Icon"] = "图标"
L["Shows or hides the bar icons."] = "显示或隐藏计时条图标。"
L["Font"] = "字体"
L["Restart"] = "重新加载"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "重新加载醒目计时条并从10开始倒数。"
L["Fill"] = "填充"
L["Fills the bars up instead of draining them."] = "填充计时条而不是显示为空。"

L["Local"] = "本地"
L["%s: Timer [%s] finished."] = "%s：计时条[%s]到时间。"
L["Custom bar '%s' started by %s user '%s'."] = "Custom bar '%s' started by %s user '%s'."

L["Pull"] = "Pull"
L["Pulling!"] = "Pulling!"
L["Pull timer started by %s user '%s'."] = "Pull timer started by %s user '%s'."
L["Pull in %d sec"] = "Pull in %d sec"
L["Sending a pull timer to Big Wigs and DBM users."] = "Sending a pull timer to Big Wigs and DBM users."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "Sending custom bar '%s' to Big Wigs and DBM users."
L["This function requires raid leader or raid assist."] = "This function requires raid leader or raid assist."
L["Must be between 1 and 10. A correct example is: /pull 5"] = "Must be between 1 and 10. A correct example is: /pull 5"
L["Incorrect format. A correct example is: /bwcb 20 text"] = "Incorrect format. A correct example is: /bwcb 20 text"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."
L["This function can't be used during an encounter."] = "This function can't be used during an encounter."

-----------------------------------------------------------------------
-- Colors.lua
--

L["Colors"] = "颜色"

L["Messages"] = "信息"
L["Bars"] = "计时条"
L["Background"] = "背景"
L["Text"] = "文本"
--L["Flash"] = "Flash"
L["Normal"] = "标准"
L["Emphasized"] = "醒目"

L["Reset"] = "重置"
L["Resets the above colors to their defaults."] = "重置以上颜色为默认。"
L["Reset all"] = "重置所有"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "如果为首领战斗自定义了颜色设置，这个按钮将重置替换“所有”颜色为默认。"

L["Important"] = "重要"
L["Personal"] = "个人"
L["Urgent"] = "紧急"
L["Attention"] = "注意"
L["Positive"] = "醒目"

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "超级醒目"
L.superEmphasizeDesc = "相关信息或特定首领战斗技能计时条增强。\n\n在这里设置当开启超级醒目位于首领战斗技能高级选项时所应该发生的事件。\n\n|cffff4411注意：超级醒目功能默认情况下所有技能关闭。|r\n"
L["UPPERCASE"] = "大写"
L["Uppercases all messages related to a super emphasized option."] = "所有超级醒目选项相关信息大写。"
L["Double size"] = "双倍尺寸"
L["Doubles the size of super emphasized bars and messages."] = "超级醒目计时条和信息双倍尺寸。"
L["Countdown"] = "冷却"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = "如果相关的计时器的长度超过5秒，一个声音与视觉将增加倒计时的最后5秒。想象某个倒计时\"5... 4... 3... 2... 1... 冷却！\"和大个数字位于屏幕中间。"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "向外通过 Big Wigs 插件信息显示。这些包含了图标，颜色和在同一时间在屏幕上的显示4条信息。新的信息将再一次快速的放大和缩小来提醒用户。新插入的信息将增大并立即缩小提醒用户注意。"
L.emphasizedSinkDescription = "通过此插件输出到 Big Wigs 醒目信息显示。此显示支持文本和颜色，每次只可显示一条信息。"
L.emphasizedCountdownSinkDescription = "Route output from this addon through the Big Wigs Emphasized Countdown message display. This display supports text and colors, and can only show one message at a time."

L["Messages"] = "信息"
L["Normal messages"] = "一般信息"
L["Emphasized messages"] = "醒目信息"
L["Output"] = "输出"
L["Emphasized countdown"] = "Emphasized countdown"

L["Use colors"] = "使用彩色信息"
L["Toggles white only messages ignoring coloring."] = "选择是否只发送单色信息。"

L["Use icons"] = "使用图标"
L["Show icons next to messages, only works for Raid Warning."] = "显示图标，只能使用在团队警告频道。"

L["Class colors"] = "职业颜色"
L["Colors player names in messages by their class."] = "使用职业颜色来染色信息内玩家颜色。"

L["Font size"] = "字体大小"
L["None"] = "无"
L["Thin"] = "细"
L["Thick"] = "粗"
L["Outline"] = "轮廓"
L["Monochrome"] = "单一颜色"
L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."] = "在全部信息切换为单一颜色，移除全部字体边缘平滑。"
L["Font color"] = "Font color"

L["Display time"] = "显示时间"
L["How long to display a message, in seconds"] = "以秒计信息显示时间。"
L["Fade time"] = "消退时间"
L["How long to fade out a message, in seconds"] = "以秒计信息消退时间。"

-----------------------------------------------------------------------
-- Proximity.lua
--

L["|T%s:20:20:-5|tAbility name"] = "|T%s:20:20:-5|t技能名称"
L["Custom range indicator"] = "自定义距离指示器"
L["%d yards"] = "%d码"
L["Proximity"] = "近距离"
L["Sound"] = "音效"
L["Disabled"] = "禁用"
L["Disable the proximity display for all modules that use it."] = "禁止所有首领模块使用近距离。"
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "近距离显示将在下次显示。要完全禁用此功能，需要关闭此功能选项。"
L["Sound delay"] = "音效延迟"
L["Specify how long Big Wigs should wait between repeating the specified sound when someone is too close to you."] = "当有人太靠近你时指定多长时间 Big Wigs 重复间隔等待指定的音效。"

L.proximity = "近距离显示"
L.proximity_desc = "显示近距离显示窗口，列出距离你很近的玩家。"

L["Close"] = "关闭"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "关闭近距离显示。\n\n要完全禁用此任一功能，需进入相对应首领模块选项关闭“近距离”功能。"
L["Lock"] = "锁定"
L["Locks the display in place, preventing moving and resizing."] = "锁定显示窗口，防止被移动和缩放。"
L["Title"] = "标题"
L["Shows or hides the title."] = "显示或隐藏标题。"
L["Background"] = "背景"
L["Shows or hides the background."] = "显示或隐藏背景。"
L["Toggle sound"] = "切换音效"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "当近距离窗口有其他过近玩家时切换任一或关闭音效。"
L["Sound button"] = "音效按钮"
L["Shows or hides the sound button."] = "显示或隐藏音效按钮。"
L["Close button"] = "关闭按钮"
L["Shows or hides the close button."] = "显示或隐藏关闭按钮。"
L["Show/hide"] = "显示/隐藏"
L["Ability name"] = "技能名称"
L["Shows or hides the ability name above the window."] = "在窗口上面显示或隐藏技能名称。"
L["Tooltip"] = "提示"
L["Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."] = "显示或隐藏近距离显示从首领战斗技能获取的法术提示。"

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L["Icons"] = "图标"

L.raidIconDescription = "可能遇到包含例如炸弹类型的技能指向特定的玩家，玩家被追，或是特定玩家可能有兴趣在其他方面。这里可以自定义团队标记来标记这些玩家。\n\n如果只遇到一种技能，很好，只有第一个图标会被使用。在某些战斗中一个图标不会使用在两个不同的技能上，任何特定技能在下次总是使用相同图标。\n\n|cffff4411注意：如果玩家已经被手动标记，Big Wigs 将不会改变他的图标。|r"
L["Primary"] = "主要"
L["The first raid target icon that a encounter script should use."] = "战斗时使用的第一个团队标记。"
L["Secondary"] = "次要"
L["The second raid target icon that a encounter script should use."] = "战斗时使用的第二个团队标记。"

L["Star"] = "星形"
L["Circle"] = "圆形"
L["Diamond"] = "棱形"
L["Triangle"] = "三角"
L["Moon"] = "月亮"
L["Square"] = "方形"
L["Cross"] = "十字"
L["Skull"] = "骷髅"
L["|cffff0000Disable|r"] = "|cffff0000禁用|r"

-----------------------------------------------------------------------
-- Sound.lua
--

L.soundDefaultDescription = "根据这些选项设置，Big Wigs 将只使用暴雪默认团队信息警报音效。注意：只有一些信息通过遇到脚本时才会出发音效警报。"

L["Sounds"] = "音效"

L["Alarm"] = "警报"
L["Info"] = "信息"
L["Alert"] = "报警"
L["Long"] = "长计时"
L["Victory"] = "胜利"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "设置使用%q音效（Ctrl-点击可以预览效果）。"
L["Default only"] = "只用预设"

L.customSoundDesc = "Play the selected custom sound instead of the one supplied by the module"
L.resetAllCustomSound = "If you've customized sounds for any boss encounter settings, this button will reset ALL of them so the sounds defined here will be used instead."

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossKillDurationPrint = "Defeated '%s' after %s."
L.bossWipeDurationPrint = "Wiped on '%s' after %s."
L.newBestKill = "New best kill!"
L.bossStatistics = "Boss Statistics"
L.bossStatsDescription = "Recording of various boss-related statistics such as the amount of times a boss had been killed, the amount of wipes, total time that combat lasted, or the fastest boss kill. These statistics can be viewed on each boss's configuration screen, but will be hidden for bosses that have no recorded statistics."
L.enableStats = "Enable Statistics"
L.chatMessages = "Chat Messages"
L.printBestKillOption = "Best Kill Notification"
L.printKillOption = "Kill Time"
L.printWipeOption = "Wipe Time"
L.countKills = "Count Kills"
L.countWipes = "Count Wipes"
L.recordBestKills = "Remember Best Kills"

