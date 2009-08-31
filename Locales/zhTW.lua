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

-- Prototype.lua common words
L.you = ">你< %s！"
L.other = "%s：>%s<！"

L.enrage_start = "%s開戰 - %d分後狂怒！"
L.enrage_end = "%s已狂怒！"
L.enrage_min = "%d分後狂怒！"
L.enrage_sec = "%d秒後狂怒！"
L.enrage = "狂怒"

L.berserk_start = "%s開戰 - %d分後狂暴！"
L.berserk_end = "%s已狂暴！"
L.berserk_min = "%d分後狂暴！"
L.berserk_sec = "%d秒後狂暴！"
L.berserk = "狂暴"

