local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs", "zhTW")

if not L then return end

-- Core.lua
L["%s has been defeated"] = "%s被擊敗了！"     -- "<boss> has been defeated"
L["%s have been defeated"] = "%s被擊敗了！"    -- "<bosses> have been defeated"
L["Bosses"] = "首領模組"
L["Options for bosses in %s."] = "%s首領模組選項。" -- "Options for bosses in <zone>"
L["Options for %s (r%d)."] = "%s模組選項版本（r%d）。"     -- "Options for <boss> (<revision>)"
L["Plugins"] = "插件"
L["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "插件是 Big Wigs 的核心功能 - 如訊息顯示、計時條以及其他必要的功能。"
L["Extras"] = "附加功能"
L["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "附加功能是第三方插件，增強 Big Wigs 的功能。"
L["Active"] = "啟動"
L["Activate or deactivate this module."] = "打開或關閉此模組。"
L["Reboot"] = "重啟"
L["Reboot this module."] = "重啟此模組。"
L["Options"] = "選項"
L["Minimap icon"] = "小地圖圖示"
L["Toggle show/hide of the minimap icon."] = "開啟或關閉小地圖圖示。"
L["Advanced"] = "進階"
L["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = "並不需要去修改這些選項，但如果想進行調整我們歡迎這樣做！"

L["Toggles whether or not the boss module should warn about %s."] = "打開或關閉%s的首領模組報警。"
L.bosskill = "首領死亡"
L.bosskill_desc = "首領被擊敗時發出提示。"
L.berserk = "狂暴"
L.berserk_desc = "當首領狂暴時發出警報。"

L["Load"] = "載入"
L["Load All"] = "載入全部"
L["Load all %s modules."] = "載入全部%s模組。"

L.already_registered = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%s|r）在 Big Wigs 中已經存在模組，但存在模組仍試圖重新註冊。可能由於更新失敗的原因，通常表示您有兩份模組拷貝在您插件的檔案夾中。建議刪除所有 Big Wigs 檔案夾並重新安裝。"

-- Loader / Options.lua
L["You are running an official release of Big Wigs 3.0 (revision %d)"] = "你所使用的 Big Wigs 3.0 為官方正式版（修訂號%d）"
L["You are running an ALPHA RELEASE of Big Wigs 3.0 (revision %d)"] = "你所使用的 Big Wigs 3.0 為“α測試版”（修訂號%d）"
L["You are running a source checkout of Big Wigs 3.0 directly from the repository."] = "你所使用的 Big Wigs 3.0 為從源直接檢出的。"
L["There is a new release of Big Wigs available. You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."] = "有新的 Big Wigs 正式版可用。你可以訪問 Curse.com，wowinterface.com，wowace.com 或使用 Curse 更新器來更新到新的正式版。"

L["|cff00ff00Module running|r"] = "|cff00ff00模組運作中|r"
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them."] = "|cffeda55f點擊|r圖示重置所有運作中的模組。|cffeda55fAlt+點擊|r圖示關閉所有運作中的模組。|cffeda55fCtrl-Alt+點擊|r圖示關閉 BigWigs。"
L["Active boss modules:"] = "啟動首領模組："
L["All running modules have been reset."] = "所有運行中的模組都已重置。"
L["Menu"] = "選單"
L["Menu options."] = "選單設置。"

L["Big Wigs is currently disabled."] = "Big Wigs 已被禁用。"
L["|cffeda55fClick|r to enable."] = "|cffeda55f點擊|r啟用。"
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55f點擊|r重置所有運作中的模組。|cffeda55fAlt-點擊|r關閉所有首領模組。|cffeda55fCtrl-Alt-點擊|r禁用 Big Wigs 所有功能。"
L["All running modules have been disabled."] = "所有運行中的模組都已禁用。"

-- Options.lua
L["Customize ..."] = "自定義…"
L["Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n"] = "歡迎使用 Big Wigs 戲弄各個首領。請係好安全帶，吃吃花生並享受這次旅行。它不會吃了你的孩子，但會協助你的團隊與新的首領進行戰鬥就如同享受饕餮大餐一樣。"
L["Configure ..."] = "配置…"
L["Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection."] = "關閉插件選項窗口並配置顯示項，如計時條、訊息。\n\n如果需要自定義更多幕後時間，你可以展開左側 Big Wigs 找到“自定義…”小項進行設置。"
L["Sound"] = "音效"
L["Messages might come with a sound. Some people find it easier to listen for these after they've learned which sound goes with which message, as opposed to reading the actual messages.\n\n|cffff4411Even when off, the default raid warning sound might be played by incoming raid warnings from other players. That sound, however, is different from the sounds we use.|r"] = "訊息出現時伴隨著音效。有些人更容易在聽到何種音效後發現何種警報，而不是閱讀的實際訊息。\n\n|cffff4411即使被關閉，默認的團隊警報音效可能會隨其他玩家的團隊警報出現，那些聲音與這裡用的不同。|r"
L["Blizzard warnings"] = "暴雪警報"
L["Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r"] = "暴雪提供了他們自己的警報訊息。我們認為，這些訊息太長和復雜。我們試著簡化這些消息而不打擾遊戲的樂趣，並不需要你做什麼。\n\n|cffff4411當關閉時，暴雪警報將不會再螢幕中間顯示，但是仍將顯示在聊天框體內。|r"
L["Raid icons"] = "團隊標記"
L["Some encounter scripts use raid icons to mark players that are of special interest to your group. For example 'bomb'-type effects and mind control. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "團隊中有些首領模塊使用團隊標記來為某些中了特定技能的隊員打上標記。例如類似“炸彈”類或心靈控制的技能。如果你關閉此功能，你將不會給隊員打標記。\n\n|cffff4411只有團隊領袖或被提升為助理時才可以這麼做！|r"
L["Whisper warnings"] = "密語警報"
L["Send a whisper notification to fellow players about certain encounter abilities that affect them. Think 'bomb'-type effects and such.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "發送給其他隊員的首領戰鬥技能密語警報功能，例如類似“炸彈”類的技能。\n\n|cffff4411只有團隊領袖或被提升為助理時才可以這麼做！|r"
L["Broadcast"] = "廣播"
L["Broadcast all messages from Big Wigs to the raid warning channel.\n\n|cffff4411Only applies if you are raid leader or in a 5-man party!|r"] = "Big Wigs 廣播所有訊息到團隊警報頻道。\n\n|cffff4411只有團隊領袖或在5人小隊時才可以這麼做！|r"
L["Raid channel"] = "團隊頻道"
L["Use the raid channel instead of raid warning for broadcasting messages."] = "使用團隊頻道而不是團隊警報廣播訊息。"
L["|cffccccccMooses don't appreciate being prodded with long pointy sticks.\nContact us on irc.freenode.net/#wowace. [Ammo] and vhaarr can service all your needs.|r\n|cff44ff44"] = "|cffcccccc麋鹿並不喜歡被標槍戳到。\n在 irc.freenode.net/##wowace 上聯繫我們 [Ammo] 和 vhaarr 可以為你服務。|r\n|cff44ff44"
L["Configure"] = "配置"
L["Test"] = "測試"
L["Reset positions"] = "重置位置"
L["Options for %s."] = "%s選項。"

