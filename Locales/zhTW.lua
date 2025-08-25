local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs", "zhTW")
if not L then return end

-- API.lua
L.showAddonBar = "插件「%s」創建了「%s」計時器。"

-- Core.lua
L.berserk = "狂暴"
L.berserk_desc = "為首領狂暴顯示計時條及警報。"
L.altpower = "顯示替代能量"
L.altpower_desc = "顯示替代能量視窗，顯示團隊成員的替代能量值。"
L.infobox = "訊息盒"
L.infobox_desc = "顯示當前戰鬥相關的訊息。"
L.stages = "階段"
L.stages_desc = "啟用首領戰鬥中與階段相關的各種功能，例如階段轉換的訊息提示、階段持續時間的計時器等。"
L.warmup = "預備"
L.warmup_desc = "首領戰鬥開始之前的預備時間。"
L.proximity = "玩家雷達"
L.proximity_desc = "顯示玩家雷達視窗，列出距離你過近的玩家。"
L.adds = "增援"
L.adds_desc = "啟用與首領戰鬥中出現的增援相關的各種功能。"
L.health = "生命值"
L.health_desc = "顯示與首領戰鬥中相關的生命值資訊。"
L.energy = "能量"
L.energy_desc = "啟用後，在首領戰鬥中顯示各種能量等級的資訊。"

L.already_registered = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%s|r）在 BigWigs 中已經存在，但該模組仍試圖重新註冊。通常來說，這可能是由於更新失敗導致你的插件資料夾中同時存在兩份相同模組的拷貝。建議刪除所有 BigWigs 資料夾並重新安裝。"

-- Loader / Options.lua
L.okay = "確定"
L.officialRelease = "你所使用的 BigWigs %s 為官方正式版（%s）。"
L.alphaRelease = "你所使用的 BigWigs %s 為「α測試版（%s）」。"
L.sourceCheckout = "你所使用的 BigWigs（%s）是直接從原始碼倉庫下載的版本。"
L.littlewigsOfficialRelease = "你所使用的 LittleWigs 為官方正式版（%s）。"
L.littlewigsAlphaRelease = "你所使用的 LittleWigs 為「α測試版（%s）」。"
L.littlewigsSourceCheckout = "你所使用的 LittleWigs 是直接從原始碼倉庫下載的版本。"
L.guildRelease = "你正在使用公會製作的 BigWigs，版本 %d，其基於官方版 %d。"
L.getNewRelease = "你的 BigWigs 已過期（/bwv）但是可以使用 CurseForge 客戶端簡單升級。另外，也可以從 curseforge.com 或 addons.wago.io 手動升級。"
L.warnTwoReleases = "你的 BigWigs 已過期 2 個發行版！你的版本可能有錯誤、功能缺失或不正確的計時器。所以強烈建議你升級。"
L.warnSeveralReleases = "|cffff0000你的 BigWigs 已過期 %d 個發行版！！我們「強烈」建議你更新，以防止把問題同步給其他玩家！|r"
L.warnOldBase = "你正在使用公會版 BigWigs（%d），但它所基於的官方版 （%d）已經過期了 %d 個版本，可能會導致問題。"

L.tooltipHint = "|cffeda55f右擊|r打開選項。"
L.activeBossModules = "啟動首領模組："

L.oldVersionsInGroup = "你隊伍中的其他成員使用了舊版本的 BigWigs 或沒有使用 BigWigs。輸入 /bwv 可以獲得詳細資訊。" -- XXX needs updated
L.upToDate = "已更新："
L.outOfDate = "過期："
L.dbmUsers = "使用 DBM："
L.noBossMod = "沒有首領模組："
L.offline = "離線"

L.missingAddOnPopup = "缺少 |cFF436EEE%s|r 模組！"
L.missingAddOnRaidWarning = "缺少 |cFF436EEE%s|r 模組！無法為此區域提供計時條！"
L.outOfDateAddOnPopup = "|cFF436EEE%s|r 模組已過期！"
L.outOfDateAddOnRaidWarning = "|cFF436EEE%s|r 模組已過期！你使用的版本是 v%d.%d.%d，但最新版是 v%d.%d.%d。"
L.disabledAddOn = "模組 |cFF436EEE%s|r 已被禁用，無法顯示計時器。"
L.removeAddOn = "請移除「|cFF436EEE%s|r」，其已被「|cFF436EEE%s|r」所替代。"
L.alternativeName = "%s（|cFF436EEE%s|r）"
L.outOfDateContentPopup = "警告！\n你更新了 |cFF436EEE%s|r，但還需要更新 |cFF436EEEBigWigs|r 主程式，\n忽略這件事可能使插件故障。"
L.outOfDateContentRaidWarning = "需要安裝版本 %2$d 的|cFF436EEEBigWigs|r 主程式，才能使用 |cFF436EEE%1$s|r，但你目前使用的版本是 %3$d。"
L.addOnLoadFailedWithReason = "BigWigs 無法載入模組 |cFF436EEE%s|r，原因是 %q；請將此問題回報給 BigWigs 開發團隊！"
L.addOnLoadFailedUnknownError = "BigWigs 在載入模組 |cFF436EEE%s|r 的過程中發生錯誤。請將此問題回報給 BigWigs 開發團隊！"

L.expansionNames = {
	"艾澤拉斯", -- Classic
	"燃燒的遠征", -- The Burning Crusade
	"巫妖王之怒", -- Wrath of the Lich King
	"浩劫與重生", -- Cataclysm
	"潘達利亞之謎", -- Mists of Pandaria
	"德拉諾之霸", -- Warlords of Draenor
	"軍臨天下", -- Legion
	"決戰艾澤拉斯", -- Battle for Azeroth
	"暗影之境", -- Shadowlands
	"巨龍崛起", -- Dragonflight
	"地心之戰", -- The War Within
}
L.littleWigsExtras = {
	["LittleWigs_Delves"] = "探究",
	["LittleWigs_CurrentSeason"] = "當前賽季",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "當心（艾爾加隆）"
L.FlagTaken = "奪旗（PvP）"
L.Destruction = "毀滅（基爾加丹）"
L.RunAway = "快逃啊小女孩，快逃……（大野狼）"
L.spell_on_you = "BigWigs: 法術在你身上"
L.spell_under_you = "BigWigs: 法術在你腳下"
L.simple_no_voice = "簡單（無語音） "

-- Options.lua
L.options = "選項"
L.optionsKey = "ID: %s" -- The ID that messages/bars/options use
L.raidBosses = "團隊首領"
L.dungeonBosses = "地城首領"
L.introduction = "歡迎使用 BigWigs 戲弄各個首領。請繫好安全帶，吃吃花生並享受這次旅行。它不會吃了你的孩子，但會協助你的團隊與新的首領進行戰鬥，如同享受饕餮大餐一樣。"
L.sound = "音效"
L.minimapIcon = "小地圖圖示"
L.minimapToggle = "打開或關閉小地圖圖示。"
L.compartmentMenu = "隱藏暴雪插件收納按鈕"
L.compartmentMenu_desc = "關閉此選項將會啟用暴雪的小地圖插件收納功能。我們推薦你啟用這個選項，隱藏暴雪插件收納按鈕。"
L.configure = "配置"
L.resetPositions = "重置位置"
L.selectEncounter = "選擇戰鬥"
L.privateAuraSounds = "私有光環音效"
L.privateAuraSounds_desc = "插件無法用一般的方式追蹤私有光環，但可以指定一個音效，在你被光環鎖定時播放。"
L.listAbilities = "將技能列表發送到團隊聊天頻道"

L.dbmFaker = "假裝我是 DBM 用戶"
L.dbmFakerDesc = "當一個 DBM 使用者執行版本檢查以確認哪些人用了 DBM 的時候，他們會看到你在名單之上。當你的公會強制要求使用DBM，這是很有用的。"
L.zoneMessages = "顯示區域訊息"
L.zoneMessagesDesc = "此選項於進入區域時提示可安裝的 BigWigs 模組。建議啟用此選項，因為當我們為一個新區域建立 BigWigs 模組，這將會是唯一的提示安裝訊息。"
L.englishSayMessages = "英文喊話"
L.englishSayMessagesDesc = "首領戰中所有以「說」與「大喊」發送的提示訊息都會以英文發送。這對多語言團隊非常有用。"

L.slashDescTitle = "|cFFFED000指令：|r"
L.slashDescPull = "|cFFFED000/pull:|r 發送拉怪倒數提示到團隊。"
L.slashDescBreak = "|cFFFED000/break:|r 發送休息時間到團隊。"
L.slashDescRaidBar = "|cFFFED000/raidbar:|r 發送自訂計時條到團隊。"
L.slashDescLocalBar = "|cFFFED000/localbar:|r 創建一個只有自身可見的自訂計時條。"
L.slashDescRange = "|cFFFED000/range:|r 開啟範圍偵測。"
L.slashDescVersion = "|cFFFED000/bwv:|r 進行 BigWigs 版本檢測。"
L.slashDescConfig = "|cFFFED000/bw:|r 開啟 BigWigs 配置。"

L.gitHubDesc = "|cFF33FF99BigWigs 是一個在 GitHub 上的開源軟體。我們一直在尋找新的朋友幫助我們和歡迎任何人檢測我們的代碼，做出貢獻和提交錯誤報告。BigWigs 今天的偉大很大程度上一部分因為偉大的魔獸世界社區幫助我們。|r"

L.BAR = "計時條"
L.MESSAGE = "訊息"
L.ICON = "標記"
L.SAY = "說"
L.FLASH = "閃爍"
L.EMPHASIZE = "強調"
L.ME_ONLY = "只對自身"
L.ME_ONLY_desc = "當啟用此選項時只有對你有影響的技能訊息才會被顯示。比如，「炸彈：玩家」將只會在你是炸彈時顯示。"
L.PULSE = "脈衝"
L.PULSE_desc = "除了螢幕閃爍之外，也可以使特定技能的圖示隨之顯示在你的螢幕上，以提高注意力。"
L.MESSAGE_desc = "大多數首領技能會有一條或多條訊息被 BigWigs 顯示在螢幕上。如停用此選項，即便此技能有訊息也不會顯示。"
L.BAR_desc = "在適當時會為首領技能顯示計時條。如果你想隱藏此技能的計時條，停用此選項。"
L.FLASH_desc = "某些技能可能比其他技能更重要。如果你希望此類技能施放時閃爍螢幕，啟用此選項。"
L.ICON_desc = "BigWigs 可以根據技能用圖示標記人物。這將使他們更容易被辨認。"
L.SAY_desc = "對話泡泡容易被看見。BigWigs 將以說話訊息通知附近的人你中了什麼技能。"
L.EMPHASIZE_desc = "啟用後會強調所有與此技能相關的訊息，使它們更大和更容易看到。你可以在「訊息」選項中調整強調訊息的字型及大小。"
L.PROXIMITY = "玩家雷達"
L.PROXIMITY_desc = "有時候，某些技能會要求團隊散開。玩家雷達是一個為此類技能獨立顯示的視窗，告訴你誰距離過近並且不安全。"
L.ALTPOWER = "顯示替代能量"
L.ALTPOWER_desc = "玩家在一些首領戰鬥中會使用替代能量機制。替代能量視窗讓玩家快速查看團隊中誰有最少或最多替代能量，對特定戰術或分配會有幫助。"
L.TANK = "只對坦克"
L.TANK_desc = "有些技能只對坦克重要。如果想無視職業看到這些技能警報，停用此選項。"
L.HEALER = "只對治療"
L.HEALER_desc = "有些技能只對治療重要。如果想無視你的職業一律看到此技能警報，停用此選項。"
L.TANK_HEALER = "只對坦克和治療"
L.TANK_HEALER_desc = "有些技能只對坦克和治療重要。如果想無視職業看到這些技能警報，停用此選項。"
L.DISPEL = "只對驅散和打斷"
L.DISPEL_desc = "如果你希望在你不能打斷或驅散的情況下仍然警報此技能，停用此選項。"
L.VOICE = "語音"
L.VOICE_desc = "如果安裝了語音插件，此選項可以開啟並播放警報音效文件。"
L.COUNTDOWN = "倒數"
L.COUNTDOWN_desc = "啟用後，倒數最後五秒會顯示聲音及文字。想像有人在你的畫面中央以巨大的數字倒數「5... 4... 3... 2... 1...」。"
L.CASTBAR_COUNTDOWN = "施法倒數計時"
L.CASTBAR_COUNTDOWN_desc = "啟用後，為施法條的最後五秒顯示巨大的文字與語音倒數。"
L.INFOBOX = L.infobox
L.INFOBOX_desc = L.infobox_desc
L.SOUND = L.sound
L.SOUND_desc = "首領技能通常會播放音效來提醒你，如果不想附加音效，請停用此選項。"
L.CASTBAR = "施法條"
L.CASTBAR_desc = "施法條會在某些首領戰場合出現，通常用來提醒即將到來的重要技能。如果想隱藏施法條，請停用此選項。"
L.SAY_COUNTDOWN = "倒數報數"
L.SAY_COUNTDOWN_desc = "聊天泡泡十分醒目，利用此特性，BigWigs 以倒數計時的說話訊息來提醒附近的人技能即將到期。"
L.ME_ONLY_EMPHASIZE = "強調（只有我）"
L.ME_ONLY_EMPHASIZE_desc = "啟用後會強調所有只施放在你的技能相關的訊息，使它們更大和更容易看到。"
L.NAMEPLATE = "名條"
L.NAMEPLATE_desc = "啟用後，會在名條上顯示特定技能的圖示和文字。當場上存在多個目標時，這個功能可以使你更快地辨識出是哪個 NPC 在施放技能。"
L.PRIVATE = "私有光環"
L.PRIVATE_desc = "私有光環無法用一般方式追蹤，但可以在音效分頁指定「只對自身」的音效。"

L.advanced_options = "進階選項"
L.back = "<< 返回"

L.tank = "|cFFFF0000只警報坦克。|r"
L.healer = "|cFFFF0000只警報治療。|r"
L.tankhealer = "|cFFFF0000只警報坦克和治療。|r"
L.dispeller = "|cFFFF0000只警報驅散和打斷。|r"

-- Sharing.lua
L.import = "匯入"
L.import_info = "輸入字串後，可以勾選要分別匯入哪些設定。\n如果字串中不包含某些設定，該選項將無法勾選。\n\n|cffff4411導入的字串只會更改一般設定，不會更改針對特定首領技能調整的單獨設定。|r"
L.import_info_active = "勾選要匯入的部份，再點擊匯入按鈕。"
L.import_info_none = "|cFFFF0000匯入的字串格式不符，或者版本過舊已失效。|r"
L.export = "匯出"
L.export_info = "選擇你要匯出分享的設定。\n\n|cffff4411你只能分享一般設定，不能分享針對特定首領技能調整的單獨設定。|r"
L.export_string = "匯出字串"
L.export_string_desc = "如果要分享你的 BigWigs 設定，請複製這段字串。"
L.import_string = "匯入字串"
L.import_string_desc = "在這裡貼上你要匯入的 BigWigs 字串。"
L.position = "位置"
L.settings = "選項設定"
L.other_settings = "其他設定"
L.nameplate_settings_import_desc = "匯入名條的所有設定。"
L.nameplate_settings_export_desc = "匯出名條的所有設定。"
L.position_import_bars_desc = "匯入計時條的錨點與位置。"
L.position_import_messages_desc = "匯入訊息的錨點與位置。"
L.position_import_countdown_desc = "匯入倒數的錨點與位置。"
L.position_export_bars_desc = "匯出計時條的錨點與位置。"
L.position_export_messages_desc = "匯出訊息的錨點與位置。"
L.position_export_countdown_desc = "匯出倒數的錨點與位置。"
L.settings_import_bars_desc = "匯入計時條的選項設定，例如字型和大小等等。"
L.settings_import_messages_desc = "匯入訊息的選項設定，例如字型和大小等等。"
L.settings_import_countdown_desc = "匯入倒數的選項設定，例如字型和大小等等。"
L.settings_export_bars_desc = "匯出計時條的選項設定，例如文字和大小等等。"
L.settings_export_messages_desc = "匯出訊息的選項設定，例如字型和大小等等。"
L.settings_export_countdown_desc = "匯出倒數的選項設定，例如字型和大小等等。"
L.colors_import_bars_desc = "匯入計時條的顏色設定。"
L.colors_import_messages_desc = "匯入訊息的顏色設定。"
L.color_import_countdown_desc = "匯入倒數文字的顏色設定。"
L.colors_export_bars_desc = "匯出計時條的顏色設定。"
L.colors_export_messages_desc = "匯出訊息的顏色設定。"
L.color_export_countdown_desc = "匯出倒數文字的顏色設定。"
L.confirm_import = "即將把你勾選的設定匯入設定檔：\n\n|cFF33FF99\"%s\"|r\n\n匯入後，會取代設定檔中原本的設定。確定要匯入嗎？"
L.confirm_import_addon = "插件|cFF436EEE\"%s\"|r想要自動匯入新的 BigWigs 設定檔，取代你目前使用的設定檔：\n\n|cFF33FF99\"%s\"|r\n\n確定要匯入嗎？"
L.confirm_import_addon_new_profile = "插件|cFF436EEE\"%s\"|r想要自動建立一個新的 BigWigs 設定檔：\n\n|cFF33FF99\"%s\"|r\n\n確定要建立嗎？建立新的設定檔後，會自動切換到該設定檔。"
L.confirm_import_addon_edit_profile = "插件|cFF436EEE\"%s\"|r想要自動修改你的 BigWigs 設定檔：\n\n|cFF33FF99\"%s\"|r\n\n確定要修改嗎？修改設定檔後，會自動切換到該設定檔。"
L.no_string_available = "沒有字串可以匯入。請先匯入一個字串。"
L.no_import_message = "未導入任何設定。"
L.import_success = "匯入：%s" -- Imported: Bar Anchors, Message Colors
L.imported_bar_positions = "計時條位置"
L.imported_bar_settings = "計時條選項設定"
L.imported_bar_colors = "計時條顏色"
L.imported_message_positions = "訊息位置"
L.imported_message_settings = "訊息選項設定"
L.imported_message_colors = "訊息顏色"
L.imported_countdown_position = "倒數位置"
L.imported_countdown_settings = "倒數選項設定"
L.imported_countdown_color = "倒數文字顏色"
L.imported_nameplate_settings = "名條選項設定"

-- Statistics
L.statistics = "統計"
L.defeat = "戰敗"
L.defeat_desc = "你被該首領擊敗的總次數。"
L.victory = "獲勝"
L.victory_desc = "你戰勝該首領的總次數。"
L.fastest = "最佳"
L.fastest_desc = "你與該首領的最快獲勝紀錄，和創下紀錄的日期 (年/月/日)"
L.first = "首勝"
L.first_desc = "你與該首領的首次獲勝紀錄，格式是：:\n[首勝前的戰敗次數] - [戰鬥時長] - [獲勝的年/月/日]"

-- Difficulty levels for statistics display on bosses
L.unknown = "未知"
L.LFR = "隨機團隊"
L.normal = "普通模式"
L.heroic = "英雄模式"
L.mythic = "傳奇模式"
L.timewalk = "時光漫遊"
L.solotier8 = "單人 8 層"
L.solotier11 = "單人 11 層"
L.story = "故事"
L.mplus = "傳奇難度+ %d"
L.SOD = "探索賽季"
L.hardcore = "專家模式"
L.level1 = "等級 1"
L.level2 = "等級 2"
L.level3 = "等級 3"
L.N10 = "10人普通"
L.N25 = "25人普通"
L.H10 = "10人英雄"
L.H25 = "25人英雄"

-----------------------------------------------------------------------
-- TOOLS
-----------------------------------------------------------------------

L.tools = "工具"
L.toolsDesc = "BigWigs 提供了多種實用工具或便利功能，讓你可以輕鬆寫意地擊敗首領。點擊 |cFF33FF99+|r 圖示以展開選單，查看所有功能。"

-----------------------------------------------------------------------
-- AutoRole.lua
--

L.autoRoleTitle = "自動設定職責"
L.autoRoleExplainer = "當你加入隊伍或是在隊伍中更換專精時，BigWigs 會自動根據你的專精調整你的隊伍職責（坦克、治療者、傷害輸出）。\n\n"

-----------------------------------------------------------------------
-- Keystones.lua
--

L.keystoneTitle = "BigWigs 鑰石清單"
L.keystoneHeaderParty = "隊伍"
L.keystoneRefreshParty = "更新隊伍"
L.keystoneHeaderGuild = "公會"
L.keystoneRefreshGuild = "更新公會"
L.keystoneLevelTooltip = "鑰石等級：|cFFFFFFFF%s|r"
L.keystoneMapTooltip = "地城：|cFFFFFFFF%s|r"
L.keystoneRatingTooltip = "傳奇鑰石分數：|cFFFFFFFF%d|r" --按I介面就是傳奇鑰石分數，不是傳奇+
L.keystoneHiddenTooltip = "該玩家隱藏了資訊。"
L.keystoneTabOnline = "線上"
L.keystoneTabAlts = "分身" --NOT SURE
L.keystoneTabTeleports = "傳送"
L.keystoneHeaderMyCharacters = "我的角色"
L.keystoneTeleportNotLearned = "|cFFFF4411尚未學會|r傳送法術「|cFFFFFFFF%s|r」。"
L.keystoneTeleportOnCooldown = "傳送法術「|cFFFFFFFF%s|r」正在|cFFFF4411冷卻中|r，%d 小時  %d 分後可用。"
L.keystoneTeleportReady = "傳送法術「|cFFFFFFFF%s|r」已|cFF33FF99就緒|r，點擊施放。"
L.keystoneTeleportInCombat = "戰鬥中無法傳送。"
L.keystoneTabHistory = "歷史"
L.keystoneHeaderThisWeek = "本周"
L.keystoneHeaderOlder = "先前"
L.keystoneScoreTooltip = "地城分數：|cFFFFFFFF%d|r"
L.keystoneScoreGainedTooltip = "獲得分數：|cFFFFFFFF+%d|r"
L.keystoneCompletedTooltip = "時限內完成"
L.keystoneFailedTooltip = "超時"
L.keystoneExplainer = "傳奇+工具合集，提升你進行傳奇+副本時的遊戲體驗。"
L.keystoneAutoSlot = "自動插鑰石"
L.keystoneAutoSlotDesc = "打開能量之泉時，自動插入鑰石。"
L.keystoneAutoSlotMessage = "已將 %s 插入能量之泉。"
L.keystoneModuleName = "傳奇+"
L.keystoneStartBar = "%s +%d" -- Format is SHORT_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "ROOK +12"
L.keystoneStartMessage = "%s +%d 戰鬥開始！" -- Format is LONG_DUNGEON_NAME +KEYSTONE_LEVEL e.g. "The Rookery +12 begins now!"
L.keystoneCountdownExplainer = "傳奇+地城開始時，播放倒數語音。請選擇使用的語音和倒數秒數。\n\n"
L.keystoneCountdownBeginsDesc = "請選擇在傳奇+地城的倒數計時剩餘幾秒時開始播放倒數語音。"
L.keystoneCountdownBeginsSound = "傳奇+倒數開始時播放音效"
L.keystoneCountdownEndsSound = "傳奇+倒數結束時播放音效"
L.keystoneViewerTitle = "鑰石資訊"
L.keystoneHideGuildTitle = "向公會成員隱藏我的鑰石"
L.keystoneHideGuildDesc = "|cffff4411不推薦。|r啟用此選項會使公會成員無法查看你的鑰石，但你的隊友仍然可以查看。"
L.keystoneHideGuildWarning = "建議你|cffff4411不要關閉|r公會查看功能.\n\n確定仍要關閉嗎？"
L.keystoneAutoShowEndOfRun = "傳奇+地城結束時顯示"
L.keystoneAutoShowEndOfRunDesc = "完成傳奇+地城時開啟鑰石清單。\n\n|cFF33FF99此功能有助於快速查看隊友的新鑰石。|r"
L.keystoneViewerExplainer = "點擊下方按鈕，或輸入 |cFF33FF99/key|r 可以開啟鑰石清單。\n\n"
L.keystoneViewerOpen = "開啟鑰石清單"
L.keystoneViewerKeybindingExplainer = "\n\n或者，替鑰石清單設定一個快捷鍵：\n\n"
L.keystoneViewerKeybindingDesc = "設定開啟鑰石清單的快捷鍵"
L.keystoneClickToWhisper = "點擊發送密語"
L.keystoneClickToTeleportNow = "\n點擊傳送至此"
L.keystoneClickToTeleportCooldown = "\n無法傳送：法術正在冷卻。"
L.keystoneClickToTeleportNotLearned = "\n無法傳送：法術尚未學會。"
L.keystoneHistoryRuns = "總計 %d"
L.keystoneHistoryRunsThisWeekTooltip = "本周地城：|cFFFFFFFF%d|r"
L.keystoneHistoryRunsOlderTooltip = "以前地城：|cFFFFFFFF%d|r"
L.keystoneHistoryScore = "分數 +%d"
L.keystoneHistoryScoreThisWeekTooltip = "本周獲得分數：cFFFFFFFF+%d|r"
L.keystoneHistoryScoreOlderTooltip = "上周分數：|cFFFFFFFF+%d|r"

-- It doesn't really matter what you call it as long as it's recognizable and limited to ~6 characters
L.keystoneShortName_TheRookery = "培育所" --培育
L.keystoneShortName_DarkflameCleft = "暗焰" --暗焰
L.keystoneShortName_PrioryOfTheSacredFlame = "聖焰" --聖焰
L.keystoneShortName_CinderbrewMeadery = "酒莊" --酒莊
L.keystoneShortName_OperationFloodgate = "水閘" --水閘
L.keystoneShortName_TheaterOfPain = "劇場" --劇場
L.keystoneShortName_TheMotherlode = "晶喜" --晶喜
L.keystoneShortName_OperationMechagonWorkshop = "工坊"
L.keystoneShortName_EcoDomeAldani = "秘境" --秘境
L.keystoneShortName_HallsOfAtonement = "贖罪" --贖罪
L.keystoneShortName_AraKaraCityOfEchoes = "回音" --回音
L.keystoneShortName_TazaveshSoleahsGambit = "險招" --索利亞?
L.keystoneShortName_TazaveshStreetsOfWonder = "街道" --街道
L.keystoneShortName_TheDawnbreaker = "破曉" --破曉

-- These short names are for the bar that shows during the Mythic+ countdown
-- Use the real dungeon names but make them shorter to fit on the bar better
L.keystoneShortName_TheRookery_Bar = "培育所"
L.keystoneShortName_DarkflameCleft_Bar = "暗焰"
L.keystoneShortName_PrioryOfTheSacredFlame_Bar = "聖焰"
L.keystoneShortName_CinderbrewMeadery_Bar = "酒莊"
L.keystoneShortName_OperationFloodgate_Bar = "水閘"
L.keystoneShortName_TheaterOfPain_Bar = "劇場"
L.keystoneShortName_TheMotherlode_Bar = "晶喜"
L.keystoneShortName_OperationMechagonWorkshop_Bar = "工坊"
L.keystoneShortName_EcoDomeAldani_Bar = "秘境"
L.keystoneShortName_HallsOfAtonement_Bar = "贖罪"
L.keystoneShortName_AraKaraCityOfEchoes_Bar = "回音"
L.keystoneShortName_TazaveshSoleahsGambit_Bar = "險招"
L.keystoneShortName_TazaveshStreetsOfWonder_Bar = "街道"
L.keystoneShortName_TheDawnbreaker_Bar = "破曉"

-- Instance Keys "Who has a key?"
L.instanceKeysTitle = "誰有鑰石？"
L.instanceKeysDesc = "進入傳奇地城後，列出誰有該副本的鑰石。\n\n"
L.instanceKeysTest8 = "|cFF00FF98武僧:|r +8"
L.instanceKeysTest10 = "|cFFFF7C0A德魯伊:|r +10"
L.instanceKeysDisplay = "|c%s%s:|r +%d" -- "PLAYER_NAME: +DUNGEON_LEVEL"
L.instanceKeysDisplayWithDungeon = "|c%s%s:|r +%d（%s）" -- "PLAYER_NAME: +DUNGEON_LEVEL (DUNGEON_NAME)"
L.instanceKeysShowAll = "總是顯示所有玩家"
L.instanceKeysShowAllDesc = "啟用此選項會顯示所有玩家的鑰石，即便鑰石不屬於當前地城。"
L.instanceKeysOtherDungeonColor = "其他地城顏色"
L.instanceKeysOtherDungeonColorDesc = "替非當前地城的鑰石設定不同的文字顏色。"
L.instanceKeysEndOfRunDesc = "預設只在進入傳奇地城時顯示鑰石列表。啟用此選項後，完成傳奇+地城時也會顯示鑰石列表。"

-----------------------------------------------------------------------
-- LFGTimer.lua
--

L.lfgTimerTitle = "佇列就續計時" --加入佇列/從佇列移除/副本已就續/離開佇列
L.lfgTimerExplainer = "「副本已就續」的視窗彈出時，BigWigs 會在確認視窗下方顯示一個計時條，告訴你還有幾秒可以接受邀請。\n\n"
L.lfgUseMaster = "以主音效頻道播放準備確認音效"
L.lfgUseMasterDesc = "啟用後，以主音效頻道播放副本就續的提示音效。若停用此選項，則會改為透過「%s」頻道播放。"

-----------------------------------------------------------------------
-- PLUGINS
-----------------------------------------------------------------------

L.general = "一般"
L.advanced = "進階"
L.comma = "，"
L.reset = "重置"
L.resetDesc = "將上方設定重設為預設值。"
L.resetAll = "重置所有"

L.positionX = "X 座標"
L.positionY = "Y 座標"
L.positionExact = "精確位置"
L.positionDesc = "在框中輸入座標或移動控制條把錨點定位至精確位置。"
L.width = "寬度"
L.height = "高度"
L.size = "尺寸"
L.sizeDesc = "通常透過拖動錨點來條整尺寸，如果你需要一個精確的尺寸大小，可以調整這個值，或直接輸入到框中。"
L.fontSizeDesc = "調整捲動軸以更改字型大小，或在輸入框輸入精確數值，最大可以到 200。"
L.disabled = "停用"
L.disableDesc = "即將禁用「%s」的功能，但|cffff4411不建議|r這麼做。\n\n你確定要這麼做嗎？"
L.keybinding = "按鍵綁定"
L.dragToResize = "拖曳調整大小"

-- Anchor Points
L.UP = "向上"
L.DOWN = "向下"
L.TOP = "上"
L.RIGHT = "右"
L.BOTTOM = "下"
L.LEFT = "左"
L.TOPRIGHT = "右上"
L.TOPLEFT = "左上"
L.BOTTOMRIGHT = "右下"
L.BOTTOMLEFT = "左下"
L.CENTER = "中"
L.customAnchorPoint = "進階：自定錨點"
L.sourcePoint = "基準錨點"  -- 中文似乎沒有point和relativePoint的正式譯名?
L.destinationPoint = "相對錨點"

-----------------------------------------------------------------------
-- AltPower.lua
--

L.altPowerTitle = "替代能量"
L.altPowerDesc = "只有在有替代能量作用於玩家的首領戰才會顯示，這類首領數量不多，甚至可以說相當罕見；這個框架會顯示你與團隊中擁有的替代能量，其中團隊的替代能量是以清單的方式列出。如果要調整框架，點擊下方的「測試」按鈕。"
L.toggleDisplayPrint = "顯示將在下次出現。完全禁用此首領戰鬥，需在首領戰鬥選項中切換關閉。"
L.disabledDisplayDesc = "停用全部模組顯示。"
L.resetAltPowerDesc = "重設所有替代能量自訂選項，包括錨點和位置。"
L.test = "測試"
L.altPowerTestDesc = "顯示「替代能量」框架，使你可以移動它，並演示有替代能量中的戰鬥中會如何顯示。"
L.yourPowerBar = "你的能量條"
L.barColor = "能量條顏色"
L.barTextColor = "能量條文字顏色"
L.additionalWidth = "延伸寬度"
L.additionalHeight = "延伸高度"
L.additionalSizeDesc = "替代能量框架有一個基本的最小尺寸，調整卷動軸可以使之增加；或者輸入精確的數值，最高可以到 100。"
L.yourPowerTest = "你的能量：%d" -- Your Power: 42
L.yourAltPower = "你的%s：%d" -- e.g. Your Corruption: 42
L.player = "玩家 %d" -- Player 7
L.disableAltPowerDesc = "全局停用替代能量框架，啟用此選項將使任何首領戰都不顯示此框架。"

-----------------------------------------------------------------------
-- AutoReply.lua
--

L.autoReply = "自動回覆"
L.autoReplyDesc = "在首領戰期間自動回覆密語"
L.responseType = "回應格式"
L.autoReplyFinalReply = "戰鬥結束後也發送密語"
L.guildAndFriends = "公會與好友"
L.everyoneElse = "所有人"

L.autoReplyBasic = "正處於首領戰的戰鬥中。"
L.autoReplyNormal = "正在與「%s」戰鬥。"
L.autoReplyAdvanced = "正在與「%s」（%s）戰鬥，尚有 %d/%d 人存活。"
L.autoReplyExtreme = "正在與「%s」（%s）戰鬥，尚有 %d/%d 人存活：%s"

L.autoReplyLeftCombatBasic = "已結束首領戰。"
L.autoReplyLeftCombatNormalWin = "已擊敗「%s」。"
L.autoReplyLeftCombatNormalWipe = "在「%s」的戰鬥中滅團。"
L.autoReplyLeftCombatAdvancedWin = "已擊敗「%s」，尚有 %d/%d 人存活。"
L.autoReplyLeftCombatAdvancedWipe = "在「%s」的戰鬥中滅團：%s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.bars = "計時條"
L.style = "風格"
L.bigWigsBarStyleName_Default = "預設"
L.resetBarsDesc = "重設所有計時條自訂選項，包括錨點和位置。"
L.testBarsBtn = "創建測試計時條"
L.testBarsBtn_desc = "創建一個測試計時條以測試當前顯示設定。"

L.toggleAnchorsBtnShow = "顯示移動錨點"
L.toggleAnchorsBtnHide = "隱藏移動錨點"
L.toggleAnchorsBtnHide_desc = "隱藏所有移動錨點，並鎖定所有元素的位置。"
L.toggleBarsAnchorsBtnShow_desc = "顯示所有移動錨點，使你可以移動計時條。"

L.emphasizeAt = "…（秒）後強調"
L.growingUpwards = "向上成長"
L.growingUpwardsDesc = "切換在錨點向上或向下成長。"
L.texture = "材質"
L.emphasize = L.EMPHASIZE
L.emphasizeMultiplier = "尺寸倍數"
L.emphasizeMultiplierDesc = "如果你禁止計時條移動到強調計時條錨點，此選項可以調整一般計時條進入強調倒數後的放大倍率。"

L.enable = "啟用"
L.move = "移動"
L.moveDesc = "移動強調計時條到強調錨點。如此選項關閉，強調計時條將只簡單的改變縮放和顏色。"
L.emphasizedBars = "強調計時條"
L.align = "對齊"
L.alignText = "文本對齊"
L.alignTime = "時間對齊"
L.time = "時間"
L.timeDesc = "在計時條上顯示或隱藏時間。"
L.textDesc = "是否顯示或隱藏計時條上的文字。"
L.icon = "圖示"
L.iconDesc = "顯示或隱藏計時條圖示。"
L.iconPosition = "圖示位置"
L.iconPositionDesc = "選擇將圖示置於計時條的哪一側。"
L.font = "字型"
L.restart = "重新加載"
L.restartDesc = "重新加載強調計時條並從10開始倒數。"
L.fill = "填充"
L.fillDesc = "填充計時條而不是顯示為空。"
L.spacing = "間距"
L.spacingDesc = "更改每個計時條之間的間距"
L.visibleBarLimit = "最大可見數量"
L.visibleBarLimitDesc = "設定同時於螢幕上可見的計時條之最大數量。"

L.localTimer = "本地"
L.timerFinished = "%s：計時條[%s]到時間。"
L.customBarStarted = "自訂計時條「%s」開始於 %s 使用者 %s."
L.sendCustomBar = "發送自訂計時條 '%s' 到BigWigs與DBM使用者."

L.requiresLeadOrAssist = "這個功能需要團隊領隊或助理權限."
L.encounterRestricted = "此功能在戰鬥中不能使用。"
L.wrongCustomBarFormat = "不正確的格式。一個正確的範例是：/raidbar 20 文字"
L.wrongTime = "指定的時間無效。 <time> 可以為一個秒數，一個 分:秒，或是Mm。例如： 5、1:20 或 2m。"

L.wrongBreakFormat = "必須介於 1 至 60 分鐘之間。正確用法：/break 5"
L.sendBreak = "發送休息時間計時器到 BigWigs 和 DBM 用戶。"
L.breakStarted = "休息時間計時器由 %s 用戶 %s 發起。"
L.breakStopped = "休息時間計時器被 %s 取消了。"
L.breakBar = "休息時間"
L.breakMinutes = "休息時間將在 %d 分鐘後結束！"
L.breakSeconds = "休息時間將在 %d 秒後結束！"
L.breakFinished = "休息時間結束！"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.bossBlock = "首領戰訊息封鎖"
L.bossBlockDesc = "設定首領戰鬥期間要封鎖的訊息。\n\n"
L.bossBlockAudioDesc = "設定首領戰鬥期間要靜音的音效。\n\n如果你已經在系統音效設定裡禁用了某些選項，它們將顯示為|cff808080灰色|r。\n\n"
L.movieBlocked = "已經看過此動畫，跳過"
L.blockEmotes = "封鎖畫面中央表情訊息"
L.blockEmotesDesc = "某些首領技能施放時會顯示首領表情，此類訊息過於冗長且不直觀。我們嘗試提供更精簡的訊息，不會影響遊戲體驗、也不會指示玩家要做什麼。\n\n請注意：若你想看首領表情，首領表情仍然會顯示於聊天視窗。"
L.blockMovies = "封鎖重覆的動畫"
L.blockMoviesDesc = "首領戰鬥中的動畫只會播放一次（你每部都能看一次）然後就會被封鎖。"
L.blockFollowerMission = "封鎖要塞彈出訊息"
L.blockFollowerMissionDesc = "要塞會彈出訊息，其中最主要的是追隨者任務完成的提示。\n\n這些彈出訊息有可能在首領戰鬥中遮蓋你的介面中重要的部份，因此我們建議封鎖這些彈出訊息。"
L.blockGuildChallenge = "封鎖公會挑戰彈出訊息"
L.blockGuildChallengeDesc = "公會挑戰彈出訊息會顯示幾種資訊，其中最主要的是你的公會中有小隊完成了一場英雄地城或挑戰地城。\n\n這些彈出訊息有可能在首領戰鬥中遮蓋你的介面，使你看不見重要的提示，因此我們建議封鎖這些彈出訊息。"
L.blockSpellErrors = "封鎖施法失敗訊息"
L.blockSpellErrorsDesc = "如「法術還沒準備好」等顯示於畫面上方的訊息會被封鎖。"
L.blockZoneChanges = "封鎖地區變更訊息"
L.blockZoneChangesDesc = "封鎖畫面中間偏上的地區變更提示訊息，例如「|cFF33FF99暴風城|r」或「|cFF33FF99奧格瑪|r」。"
L.audio = "音效"
L.music = "音樂"
L.ambience = "環境音效"
L.sfx = "音效"
L.errorSpeech = "錯誤提示語音"
L.disableMusic = "關閉音樂（推薦）"
L.disableAmbience = "關閉環境音效（推薦）"
L.disableSfx = "關閉音效（不推薦）"
L.disableErrorSpeech = "關閉錯誤提示語音（推薦）"
L.disableAudioDesc = "關閉魔獸世界的音效選項中的「%s」部份，然後在首領戰之後恢復。這可以幫助您專注在BigWigs的警告音效。"
L.blockTooltipQuests = "滑鼠提示不顯示任務資訊"
L.blockTooltipQuestsDesc = "當你在進行擊殺某首領的任務時，滑鼠提示指向首領會顯示「0/1 完成」，導致滑鼠提示框變得很大，啟用這項功能可以避免這個情況。"
L.blockObjectiveTracker = "隱藏任務追蹤"
L.blockObjectiveTrackerDesc = "在首領戰期間隱藏任務追蹤列表，使你的畫面能夠淨空。\n\n此功能於傳奇難度+ 或追蹤成就時會自動停用。"

L.blockTalkingHead = "隱藏 NPC 說話時彈出的「會話頭像」"
L.blockTalkingHeadDesc = "當 NPC 說話，|cffff4411有時候|r會在螢幕中下方彈出「會話頭像」的對話盒，內含 NPC 的頭像與台詞。\n\n你可以在特定模式的副本中將它設定為禁止顯示。\n\n|cFF33FF99請注意：|r\n 1) 此功能只會禁止框體顯示，不會禁用 NPC 語音，因此你仍然可以聽到 NPC 的對話。 \n 2) 為了安全起見，只有特定對像的會話頭像會被阻檔；任何特殊或獨特的對話（例如一次性任務）都不會被阻檔。 "
L.blockTalkingHeadDungeons = "普通 & 英雄地城"
L.blockTalkingHeadMythics = "傳奇 & 傳奇鑰石地城"
L.blockTalkingHeadRaids = "團隊副本"
L.blockTalkingHeadTimewalking = "時光漫遊（地城 & 團隊副本）"
L.blockTalkingHeadScenarios = "事件"

L.redirectPopups = "以 BigWigs 訊息取代通知橫幅"
L.redirectPopupsDesc = "以 BigWigs 訊息取代螢幕中央的通知橫幅，例如「|cFF33FF99寶庫欄位解鎖|r」。這些通知橫幅範圍太大、顯示時間太長，會遮擋介面上的其他元素，導致你無法點擊橫幅之後的東西。"
L.redirectPopupsColor = "橫幅替代訊息顏色"
L.blockDungeonPopups = "封鎖地城通知橫幅"
L.blockDungeonPopupsDesc = "有時候，進入地城彈出的通知橫幅會顯示很長的文本，啟用此選項可以完全隱藏它們。"
L.itemLevel = "物品等級%d"
L.newRespawnPoint = "新的復活點"

L.userNotifySfx = "音效原被「首領戰訊息封鎖」功能關閉，現已強制重啟。"
L.userNotifyMusic = "音樂原被「首領戰訊息封鎖」功能關閉，現已強制重啟。"
L.userNotifyAmbience = "環境音效原被「首領戰訊息封鎖」功能關閉， 現已強制重啟。"
L.userNotifyErrorSpeech = "錯誤提示語音原被「首領戰訊息封鎖」功能關閉，現已強制重啟。"

L.subzone_grand_bazaar = "大市集" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "贊達拉港" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "東穿堂" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

L.colors = "顏色"

L.text = "文字"
L.textShadow = "文字陰影"
L.expiring_normal = "普通"
L.emphasized = "強調"

L.resetColorsDesc = "重置以上顏色為預設。"
L.resetAllColorsDesc = "如果為首領戰鬥自訂了顏色設定。這個按鈕將重置替換“所有”顏色為預設。"

L.red = "紅色"
L.redDesc = "一般戰鬥警報"
L.blue = "藍色"
L.blueDesc = "受到影響警報，例如獲得負面效果（中了debuff）。"
L.orange = "橘色"
L.yellow = "黃色"
L.green = "綠色"
L.greenDesc = "好事發生警報，例如負面效果移除（debuff消失）。"
L.cyan = "青色"
L.cyanDesc = "狀態改變警報，例如階段轉換。"
L.purple = "紫色"
L.purpleDesc = "坦克相關警報，例如對坦減益效果疊加（特定層數換坦的debuff）。"

-----------------------------------------------------------------------
-- Countdown.lua
--

L.textCountdown = "倒數文字"
L.textCountdownDesc = "於倒數時顯示倒數文字"
L.countdownColor = "倒數顏色"
L.countdownVoice = "倒數音效"
L.countdownTest = "倒數測試"
L.countdownAt = "倒數…（秒）"
L.countdownAt_desc = "以秒為單位，選擇在首領技能來臨前幾秒開始倒數。"
L.countdown = "倒數"
L.countdownDesc = "倒數功能包括語音和文字倒數。預設情況下，此功能很少啟用，但你可以為任何技能單獨啟用；在首領模組的技能列表中點擊「>>」，就可以選擇單獨啟用特定技能的倒數。"
L.countdownAudioHeader = "語音倒數"
L.countdownTextHeader = "可視文字倒數"
L.resetCountdownDesc = "重設所有倒數計時自訂選項。"
L.resetAllCountdownDesc = "如果你更改了特定首領技能的倒數選項，這個按鈕會在重設所有倒數計時自訂選項時，一併將這些設定全部重置。"

-----------------------------------------------------------------------
-- InfoBox.lua
--

L.infobox_short = "訊息盒"

-----------------------------------------------------------------------
-- Messages.lua
--

L.sinkDescription = "向外通過 BigWigs 插件訊息顯示。這些包含了圖示，顏色和在同一時間在螢幕上的顯示4個訊息。新的訊息將再一次快速的放大和縮小來提醒用戶。新插入的訊息將增大並立即縮小提醒用戶注意。"
L.emphasizedSinkDescription = "以 BigWigs 強調訊息輸出此插件資訊。此訊息支持文字和顏色，同一時間只能顯示一條訊息。"
L.resetMessagesDesc = "重設所有訊息自訂選項，包括錨點和位置。"
L.toggleMessagesAnchorsBtnShow_desc = "顯示所有移動錨點，使你可以移動訊息的位置。"

L.testMessagesBtn = "創建測試訊息"
L.testMessagesBtn_desc = "生成一個測試用的訊息，讓你查看目前設定的訊息外觀。"

L.bwEmphasized = "BigWigs 強調"
L.messages = "訊息"
L.emphasizedMessages = "強調訊息"
L.emphasizedDesc = "強調訊息的目的，是通過在螢幕中央顯示巨大的文字訊息，從而引起你的注意。 預設情況下，此功能很少啟用，但你可以為任何技能單獨啟用；在首領模組的技能列表中點擊「>>」，就可以選擇單獨啟用特定技能的強調訊息。"
L.uppercase = "大寫"
L.uppercaseDesc = "所有的強調訊息都會被轉換為大寫。"

L.useIcons = "使用圖示"
L.useIconsDesc = "訊息旁顯示圖示。"
L.classColors = "職業顏色"
L.classColorsDesc = "有時候訊息內包含了玩家名字，啟用此選項將以職業顏色著色他們的名字。."
L.chatFrameMessages = "聊天框體訊息"
L.chatFrameMessagesDesc = "除了顯示設定，輸出所有 BigWigs 訊息到預設聊天框體。"

L.fontSize = "字型大小"
L.none = "無"
L.thin = "細"
L.thick = "粗"
L.outline = "輪廓"
L.monochrome = "單一顏色"
L.monochromeDesc = "切換為單一顏色，移除全部字型邊緣平滑。"
L.fontColor = "字型顏色"

L.displayTime = "顯示時間"
L.displayTimeDesc = "以秒計訊息顯示時間。"
L.fadeTime = "消退時間"
L.fadeTimeDesc = "以秒計訊息消退時間。"

-----------------------------------------------------------------------
-- Nameplates.lua
--

L.nameplates = "名條"
L.testNameplateIconBtn = "顯示測試圖示"
L.testNameplateIconBtn_desc = "創建一個測試圖示，在當前目標的名條上測試外觀設定。"
L.testNameplateTextBtn = "顯示測試文字"
L.testNameplateTextBtn_desc = "創建一個測試文字，在當前目標的名條上測試文字設定。"
L.stopTestNameplateBtn = "停止測試"
L.stopTestNameplateBtn_desc = "停止名條上的圖示與文字測試。"
L.noNameplateTestTarget = "你需要先選擇一個可攻擊的敵對目標，並顯示它的名條，才能使用測試功能。"
L.anchoring = "定位"
L.growStartPosition = "起始位置"
L.growStartPositionDesc = "第一個圖示的位置。"
L.growDirection = "增長方向"
L.growDirectionDesc = "存在複數圖示時，後續圖示的增長方向。"
L.iconSpacingDesc = "調整圖示與圖示之間的間距。"
L.nameplateIconSettings = "圖示設定"
L.keepAspectRatio = "維持寬高比"
L.keepAspectRatioDesc = "維持圖示的 1:1 寬高比，不隨名條的框架大小而拉伸。"
L.iconColor = "圖示顏色"
L.iconColorDesc = "更改圖示的材質顏色。"
L.desaturate = "去飽和度"
L.desaturateDesc = "使圖示顏色變成灰階，而非彩色。"
L.zoom = "縮放"
L.zoomDesc = "調整圖示的材質大小。"
L.showBorder = "顯示邊框"
L.showBorderDesc = "替圖示顯示邊框。"
L.borderColor = "邊框顏色"
L.borderSize = "邊框大小"
L.showNumbers = "數字"
L.showNumbersDesc = "替圖示顯示數字。"
L.cooldown = "冷卻"
L.showCooldownSwipe = "顯示冷卻動畫"
L.showCooldownSwipeDesc = "當圖示代表的技能正在冷卻中，顯示轉圈的冷卻動畫效果。"
L.showCooldownEdge = "顯示冷卻指針" -- not sure there' s a term in zh already or not, probably not
L.showCooldownEdgeDesc = "當圖示代表的技能正在冷卻中，顯示轉圈的發光指針效果。"
L.inverse = "反轉"
L.inverseSwipeDesc = "反轉冷卻動畫效果。"
L.glow = "發光效果"
L.enableExpireGlow = "啟用結束發光效果"
L.enableExpireGlowDesc = "當技能冷卻結束，在圖示周圍顯示發光動畫效果。"
L.glowColor = "發光顏色"
L.glowType = "發光樣式"
L.glowTypeDesc = "替圖示周圍的發光動畫效果選擇樣式。"
L.resetNameplateIconsDesc = "將名條的圖示設定全部重設為預設值。"
L.nameplateTextSettings = "文字設定"
L.fixate_test = "鎖定" -- Text that displays to test on the frame
L.resetNameplateTextDesc = "將名條的文字設定全部重設為預設值。"
L.glowAt = "開始發光（秒）"
L.glowAt_desc = "設定技能的冷卻時間剩下幾秒時觸發發光效果。"
L.headerIconSizeTarget = "當前目標的圖示尺寸"
L.headerIconSizeOthers = "其他目標的圖示尺寸"
L.headerIconPositionTarget = "當前目標的圖示位置"
L.headerIconPositionOthers = "其他目標的圖示位置"

-- Glow types as part of LibCustomGlow
L.pixelGlow = "像素發光"
L.autocastGlow = "自動施法發光" -- 寵物的自動攻擊那種發光
L.buttonGlow = "快捷鍵發光"
L.procGlow = "脈衝發光" -- wa是"觸發光暈"?
L.speed = "速度"
L.animation_speed_desc = "發光動畫效果的播放速度。"
L.lines = "線條"
L.lines_glow_desc = "設定發光動畫效果中有幾條線條。"
L.intensity = "強度"
L.intensity_glow_desc = "設定發光動畫的強度，強度越高，閃光點越多。"
L.length = "長度"
L.length_glow_desc = "設定發光動畫效果中線條的長度。"
L.thickness = "粗細"
L.thickness_glow_desc = "設定發光動畫效果中線條的粗細。"
L.scale = "縮放"
L.scale_glow_desc = "調整發光動畫中閃光點的大小。"
L.startAnimation = "起始動畫"
L.startAnimation_glow_desc = "你選擇的發光效果有起始動畫效果，通常是一個閃爍。這個選項可以選擇是否啟用起始動畫。"

-----------------------------------------------------------------------
-- Proximity.lua
--

L.customRange = "自訂距離指示器"
L.proximityTitle = "%d碼 / %d 玩家" -- yd = yards (short)
L.proximity_name = "玩家雷達"
L.soundDelay = "音效延遲"
L.soundDelayDesc = "當有人太靠近你時指定多長時間 BigWigs 重複間隔等待指定的音效。"

L.resetProximityDesc = "重設所有玩家雷達自訂選項，包括錨點和位置。"

L.close = "關閉"
L.closeProximityDesc = "關閉玩家雷達。\n\n要在所有首領戰鬥中停用此功能，你需要到選項的「玩家雷達」中勾選停用。"
L.lock = "鎖定"
L.lockDesc = "鎖定顯示視窗，防止被移動和縮放。"
L.title = "標題"
L.titleDesc = "顯示或隱藏標題。"
L.background = "背景"
L.backgroundDesc = "顯示或隱藏背景。"
L.toggleSound = "切換音效"
L.toggleSoundDesc = "當近距離視窗有其他過近玩家時切換任一或關閉聲效。"
L.soundButton = "音效按鈕"
L.soundButtonDesc = "顯示或隱藏音效按鈕。"
L.closeButton = "關閉按鈕"
L.closeButtonDesc = "顯示或隱藏關閉按鈕。"
L.showHide = "顯示/隱藏"
L.abilityName = "技能名稱"
L.abilityNameDesc = "在視窗上面顯示或隱藏技能名稱。"
L.tooltip = "工具提示"
L.tooltipDesc = "顯示或隱藏近距離顯示從首領戰鬥技能獲取的法術提示。"

-----------------------------------------------------------------------
-- Pull.lua
--

L.countdownType = "倒數類型"
L.combatLog = "自動戰鬥記錄"
L.combatLogDesc = "從拉怪計時器開始時自動開始戰鬥記錄，戰鬥結束後自動停止。"

L.pull = "開怪倒數"
L.engageSoundTitle = "首領戰開始時播放音效"
L.pullStartedSoundTitle = "開怪倒數計時器開始時播放音效"
L.pullFinishedSoundTitle = "開怪倒數計時器結束時播放音效"
L.pullStartedBy = "%s發起開怪倒數。"
L.pullStopped = "%s取消了開怪倒數。"
L.pullStoppedCombat = "開怪倒數計時器因為你進入戰鬥而取消。"
L.pullIn = "%d秒後開怪"
L.sendPull = "向你的團隊發送開怪倒數計時器。"
L.wrongPullFormat = "無效倒數。正確的格式範例： /pull 5"
L.countdownBegins = "開始倒數"
L.countdownBegins_desc = "以秒為單位，選擇在開怪計時器剩餘幾秒時開始倒數。"
L.pullExplainer = "\n|cFF33FF99/pull|r 會啟動預設的 10 秒倒數計時器。\n|cFF33FF99/pull 7|r 會啟動一個 7 秒倒數計時器，你可以自行設定秒數。\n另外，你也可以在下方設定倒數快捷鍵。\n\n"
L.pullKeybindingDesc = "設定用來啟動開怪倒數的快捷鍵。"

-----------------------------------------------------------------------
-- RaidIcon.lua
--

L.icons = "圖示"
L.raidIconsDescription = "某些首領戰可能遇到包括但不限於會波及臨近隊友的炸彈類技能、凝視追趕特定玩家的怪物、或類似被特別關注的點名技能，這裡可以自訂團隊圖示來標記這些玩家。\n\n如果只遇到一種技能，很好，只有第一個圖示會被使用。單場戰鬥中，一個圖示不會被使用在兩個不同的技能上，並且同一個技能在下次總是使用相同圖示。\n\n|cffff4411注意：如果玩家已經被手動標記，BigWigs 將不會改變他的團隊標記。|r"
L.primary = "主要"
L.primaryDesc = "戰鬥時使用的第一個團隊圖示。"
L.secondary = "次要"
L.secondaryDesc = "戰鬥時使用的第二個團隊圖示。"

-----------------------------------------------------------------------
-- Sound.lua
--

L.Sounds = "音效"
L.soundsDesc = "BigWigs 使用「主音量」通道播放全部音效。如果你覺得音量過小或過大，打開系統音效設定並調整「主音量」捲動軸至適中。\n\n下列選項可以全局設定特定動作播放的提示音效，或設為「None」來停用它們。如果你想更改特定首領技能的提示音效，在首領模組的技能列表中點擊「>>」即可單獨指定。\n\n"
L.oldSounds = "傳統音效設定"

L.Alarm = "鬧鈴"
L.Info = "資訊"
L.Alert = "警告"
L.Long = "長響"
L.Warning = "警報"
L.onyou = "當一個法術或增減益光環施放在你身上時（點名）"
L.underyou = "當你需要離開一個地板技能的範圍時（跑位）"
L.privateaura = "當私有光環施放在你身上時（點名）"

L.customSoundDesc = "播放選定的自訂的聲音，而不是由模塊提供的。"
L.resetSoundDesc = "將前面的音效設定重設為預設值。"
L.resetAllCustomSound = "如果設置全部首領戰鬥自訂的聲音，此按鈕將重置“全部”以這裡自訂的聲音來代替。"

-----------------------------------------------------------------------
-- Statistics.lua
--

L.bossStatistics = "首領統計"
L.bossStatsDescription = "記錄與首領相關的各種統計數據，例如你獲勝的次數、被擊敗的次數、首勝日期和最快紀錄。你可以在每個首領的頁面查看統計資料，沒有記錄的首領會隱藏統計資料。"
L.createTimeBar = "顯示「最快擊敗」計時條"
L.bestTimeBar = "最快時間"
L.healthPrint = "血量：%s。"
L.healthFormat = "%s（%.1f%%）"
L.chatMessages = "聊天訊息"
L.newFastestVictoryOption = "新的最佳紀錄"
L.victoryOption = "你的勝利"
L.defeatOption = "你的戰敗"
L.bossHealthOption = "首領血量"
L.bossVictoryPrint = "你擊敗了「%s」，用時%s。" -- You were victorious against 'BOSS_NAME' after COMBAT_DURATION.
L.bossDefeatPrint = "你被「%s」擊敗，用時%s。" -- You were defeated by 'BOSS_NAME' after COMBAT_DURATION.
L.newFastestVictoryPrint = "新的最快紀錄：（-%s）" -- New fastest victory: (-COMBAT_DURATION)

-----------------------------------------------------------------------
-- Victory.lua
--

L.Victory = "勝利訊息"
L.victoryHeader = "設定擊敗首領後顯示的訊息。"
L.victorySound = "播放勝利音效"
L.victoryMessages = "顯示擊敗首領訊息"
L.victoryMessageBigWigs = "顯示 BigWigs 訊息"
L.victoryMessageBigWigsDesc = "BigWigs 訊息是一條簡單的「首領已被擊敗」訊息。"
L.victoryMessageBlizzard = "顯示暴雪內建訊息"
L.victoryMessageBlizzardDesc = "暴雪內建訊息會以特效顯示「首領被擊敗了」於畫面上。"
L.defeated = "%s被擊敗了！"

-----------------------------------------------------------------------
-- Wipe.lua
--

L.wipe = "滅團"
L.wipeSoundTitle = "滅團時播放音效"
L.respawn = "重生"
L.showRespawnBar = "顯示重生倒數計時器"
L.showRespawnBarDesc = "為滅團後首領重生倒數顯示計時器。"
