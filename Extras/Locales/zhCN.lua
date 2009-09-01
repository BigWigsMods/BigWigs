local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Extras", "zhCN")

if not L then return end


-- Custombars.lua

L["Local"] = "本地"
L["%s: Timer [%s] finished."] = "%s：计时条[%s]到时间。"
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "无效记时条（|cffff0000%q|r）或 |cffd9d919%s|r 上的记时条文字错误，<time> 输入一个数字单位默认为秒，可以为 M:S 或者 Mm。例如 5, 1:20 或 2m。"

-- Version.lua

L["should_upgrade"] = "这似乎是一个旧版本的 Big Wigs。建议您在与首领战斗之前升级。"
L["out_of_date"] = "以下玩家似乎使用旧版本：%s。"
L["not_using"] = "玩家没有使用 Big Wigs：%s。"

-- Proximity.lua

L["Proximity"] = "近距离"
L["Close Players"] = "近距离玩家"
L["Options for the Proximity Display."] = "近距离显示选项。"
L["|cff777777Nobody|r"] = "|cff777777没有玩家|r"
L["Sound"] = "声效"
L["Play sound on proximity."] = "近距离时声效提示。"
L["Disabled"] = "禁用"
L["Disable the proximity display for all modules that use it."] = "禁止所有首领模块使用近距离。"
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "近距离将在下次显示。要完全禁用此功能，需要关闭此功能选项。"
L["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "近距离显示已被锁定，需要移动或其他选项，右击 Big Wigs 图标，附加功能 -> 近距离 -> 显示可以切换锁定选项。"

L.proximity = "近距离显示"
L.proximity_desc = "显示近距离窗口，列出距离你很近的玩家。"

L.font = "Fonts\\ZYKai_T.TTF"

L["Close"] = "关闭"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "关闭近距离显示。\n\n要完全禁用此任一功能，需进入相对应首领模块选项关闭“近距离”功能。"
L["Test"] = "测试"
L["Perform a Proximity test."] = "距离报警测试。"
L["Display"] = "显示"
L["Options for the Proximity display window."] = "近距离显示窗口选项。"
L["Lock"] = "锁定"
L["Locks the display in place, preventing moving and resizing."] = "锁定显示窗口，防止被移动和缩放。"
L["Title"] = "标题"
L["Shows or hides the title."] = "显示或隐藏标题。"
L["Background"] = "背景"
L["Shows or hides the background."] = "显示或隐藏背景。"
L["Toggle sound"] = "切换声效"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "当近距离窗口有其他过近玩家时切换任一或关闭声效。"
L["Sound button"] = "音效按钮"
L["Shows or hides the sound button."] = "显示或隐藏音效按钮。"
L["Close button"] = "关闭按钮"
L["Shows or hides the close button."] = "显示或隐藏关闭按钮。"
L["Show/hide"] = "显示/隐藏"

