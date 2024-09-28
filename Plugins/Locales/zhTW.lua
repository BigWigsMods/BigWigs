local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "zhTW")
if not L then return end

L.general = "一般"
L.advanced = "進階"
L.comma = "，"

L.positionX = "X 座標"
L.positionY = "Y 座標"
L.positionExact = "精確位置"
L.positionDesc = "在框中輸入座標或移動控制條把錨點定位至精確位置。"
L.width = "寬度"
L.height = "高度"
L.sizeDesc = "通常透過拖動錨點來條整尺寸，如果你需要一個精確的尺寸大小，可以調整這個值，或直接輸入到框中。"
L.fontSizeDesc = "調整捲動軸以更改字型大小，或在輸入框輸入精確數值，最大可以到 200。"
L.disabled = "停用"
L.disableDesc = "即將禁用「%s」的功能，但|cffff4411不建議|r這麼做。\n\n你確定要這麼做嗎？"

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
L.emphasize = "強調"
L.emphasizeMultiplier = "尺寸倍數"
L.emphasizeMultiplierDesc = "如果你禁止計時條移動到強調計時條錨點，此選項可以調整一般計時條進入強調倒數後的放大倍率。"

L.enable = "啟用"
L.move = "移動"
L.moveDesc = "移動強調計時條到強調錨點。如此選項關閉，強調計時條將只簡單的改變縮放和顏色。"
L.emphasizedBars = "強調計時條"
L.align = "對齊"
L.alignText = "文本對齊"
L.alignTime = "時間對齊"
L.left = "左"
L.center = "中"
L.right = "右"
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
L.normal = "普通"
L.emphasized = "強調"

L.reset = "重置"
L.resetDesc = "重置以上顏色為預設。"
L.resetAll = "重置所有"
L.resetAllDesc = "如果為首領戰鬥自訂了顏色設定。這個按鈕將重置替換“所有”顏色為預設。"

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

L.infoBox = "訊息盒"

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
L.autoScale = "自動縮放"
L.autoScaleDesc = "根據名條的縮放比，自動調整圖示大小。"
L.glowAt = "開始發光（秒）"
L.glowAt_desc = "設定技能的冷卻時間剩下幾秒時觸發發光效果。"

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

L.sound = "音效"

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
