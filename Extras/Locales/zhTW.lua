local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Extras", "zhTW")

if not L then return end


-- Custombars.lua

L["Local"] = "區域"
L["%s: Timer [%s] finished."] = "%s: 計時器 [%s] 終了。"
L["Invalid time (|cffff0000%q|r) or missing bar text in a custom bar started by |cffd9d919%s|r. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "無效記時條（|cffff0000%q|r）或 |cffd9d919%s|r 上的記時條文字錯誤，<time> 輸入一個數字單位默認為秒，可以為 M:S 或者 Mm。例如5, 1:20 或 2m。"

-- Version.lua

L["should_upgrade"] = "這似乎是一個舊版本的 Big Wigs。建議您在與首領戰鬥之前升級。"
L["out_of_date"] = "以下玩家似乎使用舊版本：%s。"
L["not_using"] = "玩家沒有使用 Big Wigs：%s。"

-- Proximity.lua

L["Proximity"] = "鄰近顯示"
L["Close Players"] = "鄰近玩家"
L["Options for the Proximity Display."] = "設定鄰近顯示選項。"
L["|cff777777Nobody|r"] = "|cff777777沒有玩家|r"
L["Sound"] = "音效"
L["Play sound on proximity."] = "接近時發出音效。"
L["Disabled"] = "禁用"
L["Disable the proximity display for all modules that use it."] = "禁止所有首領模组使用。"
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "鄰近顯示將在下次顯示。要完全禁用此功能，需要關閉此功能選項。"
L["The proximity display has been locked, you need to right click the Big Wigs icon, go to Extras -> Proximity -> Display and toggle the Lock option if you want to move it or access the other options."] = "鄰近顯示視窗已經鎖定，你需要右鍵點擊BigWigs圖示，移到附加功能 -> 鄰近顯示 -> 切換鎖定選項如果你想要移動視窗或是透過其他設定。"

L.proximity = "鄰近顯示"
L.proximity_desc = "顯示鄰近顯示視窗，列出距離你很近的玩家。"

L.font = "Fonts\\bHEI01B.TTF"

L["Close"] = "關閉"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "關閉鄰近顯示顯示。\n\n要完全禁用此任一功能，需進入相對應首領模組選項關閉“鄰近顯示”功能。"
L["Test"] = "測試"
L["Perform a Proximity test."] = "進行鄰近顯示測試。"
L["Display"] = "顯示"
L["Options for the Proximity display window."] = "鄰近顯示視窗選項。"
L["Lock"] = "鎖定"
L["Locks the display in place, preventing moving and resizing."] = "鎖定顯示視窗，防止被移動和縮放。"
L["Title"] = "標題"
L["Shows or hides the title."] = "顯示或隱藏標題。"
L["Background"] = "背景"
L["Shows or hides the background."] = "顯示或隱藏背景。"
L["Toggle sound"] = "切換聲效"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "當鄰近顯示視窗有其他過近玩家時切換任一或關閉聲效。"
L["Sound button"] = "音效按鈕"
L["Shows or hides the sound button."] = "顯示或隱藏音效按鈕。"
L["Close button"] = "關閉按鈕"
L["Shows or hides the close button."] = "顯示或隱藏關閉按鈕。"
L["Show/hide"] = "顯示/隱藏"

