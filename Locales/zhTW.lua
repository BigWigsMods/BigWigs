local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs", "zhTW")

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
L["Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n\n|cffff0000Note that some (!) of these options do not work at the moment. Please don't file bug reports for things concerning the Big Wigs interface right now, come talk to us on IRC instead.|r\n"] = "歡迎使用 Big Wigs，戲弄各個首領。請係好安全帶，吃吃花生並享受這次旅行。它不會吃了你的孩子，但會協助你的團隊與新的首領準備戰鬥如同享受饕餮大餐一樣。\n\n|cffff0000注意有(!)的選項現在沒有作用。請現在不要為 Big Wigs 插件出錯相關打小報告，另用 IRC 來和我們談談。|r\n"
L["Configure ..."] = "配置…"
L["Closes the interface options window and lets you configure displays for things like bars and messages."] = "關閉插件選項窗口並配置顯示項，如計時條、信息。"
L["Whisper warnings |cffff0000(!)|r"] = "密語警報|cffff0000(!)|r"
L["Toggles whether you will send a whisper notification to fellow players about certain boss encounter abilities that affect them personally. Think 'bomb'-type effects and such."] = "打開或關閉你對其他隊員的首領戰鬥技能密語警報功能，想想類似“炸彈”類的技能。"
L["Raid icons |cffff0000(!)|r"] = "團隊標記|cffff0000(!)|r"
L["Some boss modules use raid icons to mark players in your group that are of special interest to your raid. Things like 'bomb'-type effects and mind control are examples of this. If you turn this off, you won't mark anyone. Note that you need to be promoted to assistant or be the raid leader in order to set these raid icons."] = "有些首領模組使用團隊標記來為某些中了特定技能的隊員打上標記。想想類似“炸彈”類或心靈控制的技能。如果你關閉此功能，你將不會給隊員打標記。請注意你必須被提升到團隊領袖或助理才可使用此標記功能。"
L["Sound |cffff0000(!)|r"] = "音效|cffff0000(!)|r"
L["Some boss messages come with warning sounds of different kinds. Some people find it easier to just listen for these sounds after they've learned which sound goes with which message, instead of reading the actual message on screen."] = "有些首領警報信息出現時伴隨著不同的音效。有些人更容易在聽到何種音效後發現何種警報，而不是閱讀屏幕上的實際警報信息。"
L["\n\n\n|cffccccccMooses don't appreciate being prodded with long pointy sticks.\nContact us on #wowace. [Ammo] and Rabbit can service all your needs.|r"] = "\n\n\n|cffcccccc麋鹿並不喜歡被標槍戳到。\n在 #wowace 上聯繫我們 [Ammo] 和 Rabbit 可以為你服務。|r"
L["Customize ..."] = "自定義…"

L["Toggles whether or not the boss module should warn about %s."] = "打開或關閉%s的首領模組報警。"
L.bosskill = "首領死亡"
L.bosskill_desc = "首領被擊敗時發出提示。"
L.enrage = "狂怒"
L.enrage_desc = "當首領狂怒時發出警報。"
L.berserk = "狂暴"
L.berserk_desc = "當首領狂暴時發出警報。"

L["Load"] = "載入"
L["Load All"] = "載入全部"
L["Load all %s modules."] = "載入全部%s模組。"

L.already_registered = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%d|r）在 Big Wigs 中已經存在首領模組，但存在（版本 |cffffff00%d|r）模組仍試圖重新註冊。可能由於更新失敗的原因，通常表示您有兩份模組拷貝在您插件的檔案夾中。建議您刪除所有 Big Wigs 檔案夾並重新安裝。"

-- Options.lua
L["|cff00ff00Module running|r"] = "|cff00ff00模組運作中|r"
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them."] = "|cffeda55f點擊|r圖示重置所有運作中的模組。|cffeda55fAlt+點擊|r圖示關閉所有運作中的模組。|cffeda55fCtrl-Alt+點擊|r圖示關閉 BigWigs。"
L["Active boss modules:"] = "啟動首領模組："
L["All running modules have been reset."] = "所有運行中的模組都已重置。"
L["Menu"] = "選單"
L["Menu options."] = "選單設置。"


