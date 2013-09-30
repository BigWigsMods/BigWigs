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
L["Disable"] = "停用"
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
L["Font"] = "字型"
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

L.customBarSlashPrint = "此功能已被重新命名。使用 /raidbar 發送自訂計時條到團隊或使用 /localbar 只有自身可見計時條。"

-----------------------------------------------------------------------
-- Colors.lua
--

L.Colors = "顏色"

L.Messages = "訊息"
L.Bars = "計時條"
L.Background = "背景"
L.Text = "文字"
L.TextShadow = "文字陰影"
L.Flash = "閃爍"
L.Normal = "普通"
L.Emphasized = "強調"

L.Reset = "重置"
L["Resets the above colors to their defaults."] = "重置以上顏色為預設。"
L["Reset all"] = "重置所有"
L["If you've customized colors for any boss encounter settings, this button will reset ALL of them so the colors defined here will be used instead."] = "如果為首領戰鬥自訂了顏色設定。這個按鈕將重置替換“所有”顏色為預設。"

L.Important = "重要"
L.Personal = "個人"
L.Urgent = "緊急"
L.Attention = "注意"
L.Positive = "積極"
L.Neutral = "中性"

-----------------------------------------------------------------------
-- Emphasize.lua
--

L["Super Emphasize"] = "超級強調"
L.superEmphasizeDesc = "相關訊息或特定首領戰鬥技能計時條增強。\n\n在這裡設定當開啟超級強調位於首領戰鬥技能進階選項時所應該發生的事件。\n\n|cffff4411注意：超級強調功能預設情況下所有技能關閉。|r\n"
L["UPPERCASE"] = "大寫"
L["Uppercases all messages related to a super emphasized option."] = "所有超級強調選項相關訊息大寫。"
L["Double size"] = "雙倍尺寸"
L["Doubles the size of super emphasized bars and messages."] = "超級強調計時條和訊息雙倍尺寸。"
L["Countdown"] = "冷卻"
L["If a related timer is longer than 5 seconds, a vocal and visual countdown will be added for the last 5 seconds. Imagine someone counting down \"5... 4... 3... 2... 1... COUNTDOWN!\" and big numbers in the middle of your screen."] = "如果相關的計時器的長度超過5秒，一個聲音與視覺將增加倒計時的最後5秒。想像某個倒計時\"5... 4... 3... 2... 1... 冷卻！\"和大個數字位於螢幕中間。"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "向外通過 Big Wigs 插件訊息顯示。這些包含了圖示，顏色和在同一時間在螢幕上的顯示4個訊息。新的訊息將再一次快速的放大和縮小來提醒用戶。新插入的訊息將增大並立即縮小提醒用戶注意。"
L.emphasizedSinkDescription = "通過此插件輸出到 Big Wigs 強調訊息顯示。此顯示支持文字和顏色，每次只可顯示一條訊息。"
L.emphasizedCountdownSinkDescription = "路線輸出從此插件通過 Big Wigs 強調冷卻訊息顯示。此顯示支持文本和顏色，一次只能顯示一個消息。"

L["Big Wigs Emphasized"] = "Big Wigs 強調"
L["Messages"] = "訊息"
L["Normal messages"] = "一般訊息"
L["Emphasized messages"] = "強調訊息"
L["Output"] = "輸出"
L["Emphasized countdown"] = "強調冷卻"

L["Use colors"] = "使用彩色訊息"
L["Toggles white only messages ignoring coloring."] = "切換是否只發送單色訊息。"

L["Use icons"] = "使用圖示"
L["Show icons next to messages, only works for Raid Warning."] = "顯示圖示，只能使用在團隊警告頻道。"

L["Class colors"] = "職業顏色"
L["Colors player names in messages by their class."] = "使用職業顏色來染色訊息內玩家顏色。"

L["Font size"] = "字型大小"
L["None"] = "無"
L["Thin"] = "細"
L["Thick"] = "粗"
L["Outline"] = "輪廓"
L["Monochrome"] = "單一顏色"
L["Toggles the monochrome flag on all messages, removing any smoothing of the font edges."] = "在全部訊息切換為單一顏色，移除全部字型邊緣平滑。"
L["Font color"] = "字型顏色"

L["Display time"] = "顯示時間"
L["How long to display a message, in seconds"] = "以秒計訊息顯示時間。"
L["Fade time"] = "消退時間"
L["How long to fade out a message, in seconds"] = "以秒計訊息消退時間。"

-----------------------------------------------------------------------
-- Proximity.lua
--

L["Custom range indicator"] = "自訂距離指示器"
L.proximityTitle = "%d碼/%d玩家"
L["Proximity"] = "近距離顯"
L.sound = "音效"
L["Disabled"] = "禁用"
L["Disable the proximity display for all modules that use it."] = "禁止所有首領模组使用近距離。"
L["The proximity display will show next time. To disable it completely for this encounter, you need to toggle it off in the encounter options."] = "近距離顯示將在下次顯示。要完全禁用此功能，需要關閉此功能選項。"
L["Sound delay"] = "音效延遲"
L["Specify how long Big Wigs should wait between repeating the specified sound when someone is too close to you."] = "當有人太靠近你時指定多長時間 Big Wigs 重複間隔等待指定的音效。"

L.proximity = "近距離顯示"
L.proximity_desc = "顯示近距離顯示視窗，列出距離你很近的玩家。"

L["Close"] = "關閉"
L["Closes the proximity display.\n\nTo disable it completely for any encounter, you have to go into the options for the relevant boss module and toggle the 'Proximity' option off."] = "關閉近距離顯示。\n\n要完全禁用此任一功能，需進入相對應首領模組選項關閉“近距離”功能。"
L["Lock"] = "鎖定"
L["Locks the display in place, preventing moving and resizing."] = "鎖定顯示視窗，防止被移動和縮放。"
L["Title"] = "標題"
L["Shows or hides the title."] = "顯示或隱藏標題。"
L["Background"] = "背景"
L["Shows or hides the background."] = "顯示或隱藏背景。"
L["Toggle sound"] = "切換音效"
L["Toggle whether or not the proximity window should beep when you're too close to another player."] = "當近距離視窗有其他過近玩家時切換任一或關閉聲效。"
L["Sound button"] = "音效按鈕"
L["Shows or hides the sound button."] = "顯示或隱藏音效按鈕。"
L["Close button"] = "關閉按鈕"
L["Shows or hides the close button."] = "顯示或隱藏關閉按鈕。"
L["Show/hide"] = "顯示/隱藏"
L["Ability name"] = "技能名稱"
L["Shows or hides the ability name above the window."] = "在視窗上面顯示或隱藏技能名稱。"
L["Tooltip"] = "工具提示"
L["Shows or hides a spell tooltip if the Proximity display is currently tied directly to a boss encounter ability."] = "顯示或隱藏近距離顯示從首領戰鬥技能獲取的法術提示。"

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L["Icons"] = "圖示"

L.raidIconsDescription = "可能遇到包含例如炸彈類型的技能指向特定的玩家，玩家被追，或是特定玩家可能有興趣在其他方面。這裡可以自訂團隊圖示來標記這些玩家。\n\n如果只遇到一種技能，很好，只有第一個圖示會被使用。在某些戰鬥中一個圖示不被使用在兩個不同的技能上，任何特定技能在下次總是使用相同圖示。\n\n|cffff4411注意：如果玩家已經被手動標記，Big Wigs 將不會改變他的圖示。|r"
L["Primary"] = "主要"
L["The first raid target icon that a encounter script should use."] = "戰鬥時使用的第一個團隊圖示。"
L["Secondary"] = "次要"
L["The second raid target icon that a encounter script should use."] = "戰鬥時使用的第二個團隊圖示。"

L["Star"] = "星星"
L["Circle"] = "圓圈"
L["Diamond"] = "菱形"
L["Triangle"] = "三角"
L["Moon"] = "月亮"
L["Square"] = "方塊"
L["Cross"] = "十字"
L["Skull"] = "骷髏"
L["|cffff0000Disable|r"] = "|cffff0000禁用|r"

-----------------------------------------------------------------------
-- Sound.lua
--

L.soundDefaultDescription = "根據這些選項設定，Big Wigs 將只使用暴雪預設團隊訊息警報音效。注意：只有一些訊息透過遇到腳本時才會觸發音效警告。"

L.Sounds = "音效"

L.Alarm = "鬧鈴"
L.Info = "資訊"
L.Alert = "警告"
L.Long = "長響"
L.Warning = "警報"
L.Victory = "勝利"

L.Beware = "當心（艾爾加隆 ）"
L.FlagTaken = "奪旗（PvP）"
L.Destruction = "毀滅（基爾加丹）"
L.RunAway = "快逃啊小女孩，快逃……（大野狼）"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "設定使用%q音效（Ctrl-點擊可以預覽效果）。"
L.defaultOnly = "僅用預設"

L.customSoundDesc = "播放選定的自訂的聲音，而不是由模塊提供的"
L.resetAllCustomSound = "如果設置全部首領戰鬥自訂的聲音，此按鈕將重置“全部”以這裡自訂的聲音來代替。"

-----------------------------------------------------------------------
-- Statistics.lua
--

-- These localization strings are translated on WoWAce: http://www.wowace.com/addons/big-wigs/localization/
--@localization(locale="zhTW", namespace="Plugins", format="lua_additive_table", handle-unlocalized="ignore")@

