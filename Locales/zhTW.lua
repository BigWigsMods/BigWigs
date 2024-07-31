local L = BigWigsAPI:NewLocale("BigWigs", "zhTW")
if not L then return end

L.tempMessage = "計時條位置已重置，現在可以使用匯入匯出功能直接匯入設定檔。"

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
L.warmup_desc = "首領戰鬥之前的預備時間。"
L.proximity = "玩家雷達"
L.proximity_desc = "顯示玩家雷達視窗，列出距離你過近的玩家。"
L.adds = "增援"
L.adds_desc = "啟用與首領戰鬥中出現的增援相關的各種功能。"
L.health = "生命值"
L.health_desc = "顯示與首領戰鬥中相關的生命值資訊。"

L.already_registered = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%s|r）在 BigWigs 中已經存在，但該模組仍試圖重新註冊。通常來說，這可能是由於更新失敗導致你的插件資料夾中同時存在兩份相同模組的拷貝。建議刪除所有 BigWigs 資料夾並重新安裝。"

-- Loader / Options.lua
L.okay = "確定"
L.officialRelease = "你所使用的 BigWigs %s 為官方正式版（%s）"
L.alphaRelease = "你所使用的 BigWigs %s 為「α測試版（%s）」"
L.sourceCheckout = "你所使用的 BigWigs（%s）是直接從原始碼倉庫下載的版本。"
L.guildRelease = "你正在使用公會製作的 BigWigs，版本 %d，其基於官方版 %d。"
L.getNewRelease = "你的 BigWigs 已過期（/bwv）但是可以使用 CurseForge 客戶端簡單升級。另外，也可以從 curseforge.com 或 wowinterface.com 手動升級。"
L.warnTwoReleases = "你的 BigWigs 已過期 2 個發行版！你的版本可能有錯誤，功能缺失或不正確的計時器。所以強烈建議你升級。"
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

L.missingAddOn = "缺少插件 |cFF436EEE%s|r！"
L.disabledAddOn = "模組 |cFF436EEE%s|r 已被禁用，無法顯示計時器。"
L.removeAddOn = "請移除「|cFF436EEE%s|r」，其已被「|cFF436EEE%s|r」所替代。"
L.alternativeName = "%s（|cFF436EEE%s|r）"
--L.outOfDateContentPopup = "WARNING!\nYou updated |cFF436EEE%s|r but you also need to update the main |cFF436EEEBigWigs|r addon.\nIgnoring this will result in broken functionality."
--L.outOfDateContentRaidWarning = "|cFF436EEE%s|r requires version %d of the main |cFF436EEEBigWigs|r addon to function correctly, but you're on version %d."

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
	["LittleWigs_Delves"] = "Delves",
	["LittleWigs_CurrentSeason"] = "當前賽季",
}

-- Media.lua (These are the names of the sounds in the dropdown list in the "sounds" section)
L.Beware = "當心（艾爾加隆）"
L.FlagTaken = "奪旗（PvP）"
L.Destruction = "毀滅（基爾加丹）"
L.RunAway = "快逃啊小女孩，快逃……（大野狼）"
L.spell_on_you = "BigWigs: 法術在你身上"
L.spell_under_you = "BigWigs: 法術在你腳下"

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
L.colors = "顏色"
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
L.SOUND = "音效"
L.SOUND_desc = "首領技能通常會播放音效來提醒你，如果不想附加音效，請停用此選項。"
L.CASTBAR = "施法條"
L.CASTBAR_desc = "施法條會在某些首領戰場合出現，通常用來提醒即將到來的重要技能。如果想隱藏施法條，請停用此選項。"
L.SAY_COUNTDOWN = "倒數報數"
L.SAY_COUNTDOWN_desc = "聊天泡泡十分醒目，利用此特性，BigWigs 以倒數計時的說話訊息來提醒附近的人技能即將到期。"
L.ME_ONLY_EMPHASIZE = "強調（只有我）"
L.ME_ONLY_EMPHASIZE_desc = "啟用後會強調所有只施放在你的技能相關的訊息，使它們更大和更容易看到。"
L.NAMEPLATEBAR = "名條計時條"
L.NAMEPLATEBAR_desc = "當多個敵方單位施放相同的法術時，在名條上方顯示各自的計時條。如果不想要名條上依附的計時條，請停用此項。"
L.PRIVATE = "私有光環"
L.PRIVATE_desc = "私有光環無法用一般方式追蹤，但可以在音效分頁指定「只對自身」的音效。"

L.advanced = "進階選項"
L.back = "<< 返回"

L.tank = "|cFFFF0000只警報坦克。|r"
L.healer = "|cFFFF0000只警報治療。|r"
L.tankhealer = "|cFFFF0000只警報坦克和治療。|r"
L.dispeller = "|cFFFF0000只警報驅散和打斷。|r"

-- Sharing.lua
L.import = "匯入"
L.import_info = "輸入字串後，可以勾選要分別匯入哪些設定。\n如果字串中不包含某些設定，該選項將無法勾選。\n\n導入的字串只會更改一般設定，不會更改針對特定首領技能調整的單獨設定。"
L.import_info_active = "勾選要匯入的部份，再點擊匯入按鈕。"
L.import_info_none = "|cFFFF0000匯入的字串格式不符，或者版本過舊已失效。|r"
L.export = "匯出"
L.export_info = "選擇你要匯出分享的設定。\n\n你只能分享一般設定，不能分享針對特定首領技能調整的單獨設定。"
L.export_string = "匯出字串"
L.export_string_desc = "如果要分享你的 BigWigs 設定，請複製這段字串。"
L.import_string = "匯入字串"
L.import_string_desc = "在這裡貼上你要匯入的 BigWigs 字串。"
L.position = "位置"
L.settings = "選項設定"
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

-- Statistics
L.statistics = "統計"
--L.defeat = "Defeat"
--L.defeat_desc = "The total amount of times you've been defeated by this boss encounter."
--L.victory = "Victory"
--L.victory_desc = "The total amount of times you were victorious against this boss encounter."
--L.fastest = "Fastest"
--L.fastest_desc = "The fastest victory and the date it occured on (Year/Month/Day)"
--L.first = "First"
--L.first_desc = "The first time you were victorious against this boss encounter, formatted as:\n[Amount of defeats prior to first victory] - [Combat duration] - [Year/Month/Day of victory]"
-- Difficulty levels for statistics display on bosses
--L.unknown = "Unknown"
L.LFR = "隨機團隊"
L.normal = "普通模式"
L.heroic = "英雄模式"
L.mythic = "傳奇模式"
--L.timewalk = "Timewalking"
--L.story = "Story"
--L.mplus = "Mythic+ %d"
--L.SOD = "Season of Discovery"
--L.hardcore = "Hardcore"
--L.level1 = "Level 1"
--L.level2 = "Level 2"
--L.level3 = "Level 3"
--L["10N"] = "Normal 10"
--L["25N"] = "Normal 25"
--L["10H"] = "Heroic 10"
--L["25H"] = "Heroic 25"
