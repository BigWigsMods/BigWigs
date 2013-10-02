local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Plugins", "zhTW")
if not L then return end

-----------------------------------------------------------------------
-- Bars.lua
--

L["Style"] = "風格"
L.bigWigsBarStyleName_Default = "預設"

L["Clickable Bars"] = "可點擊計時條"
L.clickableBarsDesc = "Big Wigs 計時條預設是點擊穿越的。這樣可以選擇目標或使用 AoE 法術攻擊物體，更改鏡頭角度等等，當滑鼠指針劃過計時條。|cffff4411如果啟用可點擊計時條，這些將不能實現。|r計時條將攔截任何滑鼠點擊並阻止相應功能。\n"
L["Enables bars to receive mouse clicks."] = "啟用計時條接受點擊。"
L["Modifier"] = "修改"
L["Hold down the selected modifier key to enable click actions on the timer bars."] = "按住選定的修改鍵以啟用計時條點擊操作。"
L["Only with modifier key"] = "只與修改鍵配合"
L["Allows bars to be click-through unless the specified modifier key is held down, at which point the mouse actions described below will be available."] = "除非修改鍵被按下否則允許計時條點擊穿越，此時游標以下動作可用。"

L["Temporarily Super Emphasizes the bar and any messages associated with it for the duration."] = "臨時超級強調調計時條及任何訊息的持續時間。"
L["Report"] = "報告"
L["Reports the current bars status to the active group chat; either instance chat, raid, party or say, as appropriate."] = "報告目前計時條狀態到合適的聊天頻道；無論是副本頻道、團隊、隊伍或是說。"
L["Remove"] = "移除"
L["Temporarily removes the bar and all associated messages."] = "臨時移除計時條和全部相關訊息。"
L["Remove other"] = "移除其它"
L["Temporarily removes all other bars (except this one) and associated messages."] = "臨時移除所有計時條（除此之外）和全部相關訊息。"
L.disable = "停用"
L["Permanently disables the boss encounter ability option that spawned this bar."] = "永久停用此首領戰鬥技能計時條選項。"

L["Emphasize at... (seconds)"] = "…（秒）後強調"
L["Scale"] = "縮放"
L["Grow upwards"] = "向上成長"
L["Toggle bars grow upwards/downwards from anchor."] = "切換計時條在錨點向上或向下成長。"
L["Texture"] = "材質"
L["Emphasize"] = "強調"
L["Enable"] = "啟用"
L["Move"] = "移動"
L.moveDesc = "移動強調計時條到強調錨點。如此選項關閉，強調計時條將只簡單的改變縮放和顏色。"
L["Regular bars"] = "常規計時條"
L["Emphasized bars"] = "強調計時條"
L["Align"] = "對齊"
L["Left"] = "左"
L["Center"] = "中"
L["Right"] = "右"
L["Time"] = "時間"
L["Whether to show or hide the time left on the bars."] = "在計時條上顯示或隱藏時間。"
L["Icon"] = "圖示"
L["Shows or hides the bar icons."] = "顯示或隱藏計時條圖示。"
L.font = "字型"
L["Restart"] = "重新加載"
L["Restarts emphasized bars so they start from the beginning and count from 10."] = "重新加載強調計時條並從10開始倒數。"
L["Fill"] = "填充"
L["Fills the bars up instead of draining them."] = "填充計時條而不是顯示為空。"

L["Local"] = "區域"
L["%s: Timer [%s] finished."] = "%s：計時條[%s]到時間。"
L["Custom bar '%s' started by %s user %s."] = "自訂計時條 '%s' 開始於 %s 使用者 %s."

L["Pull"] = "拉怪倒數"
L["Pulling!"] = "拉怪中!"
L["Pull timer started by %s user %s."] = "拉怪倒數計時開始於 %s 使用者 %s."
L["Pull in %d sec"] = "%d秒後拉怪"
L["Sending a pull timer to Big Wigs and DBM users."] = "發送一個拉怪倒數計時到Big Wigs與DBM使用者."
L["Sending custom bar '%s' to Big Wigs and DBM users."] = "發送自訂計時條 '%s' 到Big Wigs與DBM使用者."
L["This function requires raid leader or raid assist."] = "這個功能需要團隊領隊或助理權限."
L["Must be between 1 and 60. A correct example is: /pull 5"] = "必須在1跟60之間。一個正確的範例是: /pull 5"
L["Incorrect format. A correct example is: /raidbar 20 text"] = "不正確的格式。一個正確的範例是: /raidbar 20 文字"
L["Invalid time specified. <time> can be either a number in seconds, a M:S pair, or Mm. For example 5, 1:20 or 2m."] = "指定的時間無效。 <time> 可以為一個秒數，一個 分:秒，或是Mm。例如 5, 1:20 或 2m。"
L["This function can't be used during an encounter."] = "此功能在戰鬥中不能使用。"
L["Pull timer cancelled by %s."] = "%s取消了拉怪計時器。"



-- These localization strings are translated on WoWAce: http://www.wowace.com/addons/big-wigs/localization/
--@localization(locale="zhTW", namespace="Plugins", format="lua_additive_table", handle-unlocalized="ignore")@

