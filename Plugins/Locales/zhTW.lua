local L = BigWigsAPI:NewLocale("BigWigs: Plugins", "zhTW")
if not L then return end

L.comma = "，"
L.width = "寬度"
L.height = "高度"
L.sizeDesc = "通常透過拖動錨點來條整尺寸，如果你需要一個精確的尺寸大小，可以調整這個值，或直接輸入到框中"

L.abilityName = "技能名稱"
L.abilityNameDesc = "在視窗上面顯示或隱藏技能名稱。"
L.Alarm = "鬧鈴"
L.Alert = "警告"
L.align = "對齊"
L.alignText = "文本對齊"
L.alignTime = "時間對齊"
L.altPowerTitle = "替代能量"
L.background = "背景"
L.backgroundDesc = "顯示或隱藏背景。"
L.bars = "計時條"
-- L.nameplateBars = "Nameplate Bars"
-- L.autoNameplateWidth = "Match width of nameplate"
-- L.autoNameplateWidthDesc = "Sets the width of nameplate bars to the with of their parent nameplate."
L.bestTimeBar = "最快時間"
L.bigWigsBarStyleName_Default = "預設"
L.blockEmotes = "封鎖畫面中央表情訊息"
L.blockEmotesDesc = [=[某些首領施放某些技能時會顯示表情，此類訊息過於冗長及不直觀。我們嘗試提供的訊息更精簡、不會影響遊戲體驗和不會指示玩家要做什麼。

請注意：若你想看首領表情，首領表情仍然會顯示於聊天視窗。]=]
L.blockGuildChallenge = "封鎖公會挑戰彈出訊息"
L.blockGuildChallengeDesc = [=[公會挑戰彈出訊息顯示幾種資訊，其中最主要的是你的公會中有小隊完成了一場英雄地城或挑戰地城。

這些彈出訊息有可能在首領戰鬥中遮蓋你的介面中重要的部份，因此我們建議封鎖這些彈出訊息。]=]
L.blockMovies = "封鎖重覆的動畫"
L.blockMoviesDesc = "首領戰鬥中的動畫只會播放一次（你每部都能看一次）然後就會被封鎖。"
L.blockSpellErrors = "封鎖施法失敗訊息"
L.blockSpellErrorsDesc = "如「法術還沒準備好」等顯示於畫面上方的訊息會被封鎖。"
L.bossBlock = "首領戰訊息封鎖"
L.bossBlockDesc = "設定首領戰鬥期間可封鎖的訊息。"
L.bossDefeatDurationPrint = "“%s”已被擊敗，耗時%s。"
L.bossStatistics = "首領統計"
L.bossStatsDescription = "首領戰鬥相關的統計數據，如首領被擊殺數量，團滅次數，戰鬥持續時間，最快的首領擊殺記錄。可以在配置屏幕上查看每個首領的統計數據，沒有首領記錄的統計數據會被隱藏。"
L.bossWipeDurationPrint = "“%s”戰鬥團滅，用時%s。"
L.breakBar = "休息時間"
L.breakFinished = "休息時間結束！"
L.breakMinutes = "休息時間將在 %d 分鐘後結束！"
L.breakSeconds = "休息時間將在 %d 秒後結束！"
L.breakStarted = "休息時間計時器由 %s 用戶 %s 發起。"
L.breakStopped = "休息時間計時器被 %s 取消了。"
L.bwEmphasized = "BigWigs 強調"
L.center = "中"
L.chatMessages = "聊天訊息"
L.classColors = "職業顏色"
L.classColorsDesc = "玩家姓名使用職業顏色。"
L.clickableBars = "可點擊計時條"
L.clickableBarsDesc = [=[BigWigs 計時條預設是點擊穿越的。這樣可以選擇目標或使用 AoE 法術攻擊物體，更改鏡頭角度等等，當滑鼠指針劃過計時條。|cffff4411如果啟用可點擊計時條，這些將不能實現。|r計時條將攔截任何滑鼠點擊並阻止相應功能。
]=]
L.close = "關閉"
L.closeButton = "關閉按鈕"
L.closeButtonDesc = "顯示或隱藏關閉按鈕。"
L.closeProximityDesc = [=[關閉玩家雷達。

要在所有首領戰鬥中停用此功能，你需要到選項的"玩家雷達"中勾選停用。]=]
L.colors = "顏色"
L.combatLog = "自動戰鬥記錄"
L.combatLogDesc = "當拉怪計時器開始到戰鬥結束時自動開始戰鬥記錄。"
L.countDefeats = "擊敗次數"
L.countdownAt = "倒數... (秒)"
L.countdownColor = "倒數顏色"
L.countdownTest = "倒數測試"
L.countdownType = "倒數類型"
L.countdownVoice = "倒數音效"
L.countWipes = "團滅次數"
L.createTimeBar = "顯示“最快擊敗”計時條"
L.customBarStarted = "自訂計時條 '%s' 開始於 %s 使用者 %s."
L.customRange = "自訂距離指示器"
L.customSoundDesc = "播放選定的自訂的聲音，而不是由模塊提供的"
L.defeated = "%s被擊敗了！"
L.disable = "停用"
L.disabled = "停用"
L.disabledDisplayDesc = "停用全部模組顯示。"
L.disableDesc = "永久停用此首領戰鬥技能計時條選項。"
L.displayTime = "顯示時間"
L.displayTimeDesc = "以秒計訊息顯示時間。"
L.emphasize = "強調"
L.emphasizeAt = "…（秒）後強調"
L.emphasized = "強調"
L.emphasizedBars = "強調計時條"
L.emphasizedCountdownSinkDescription = "以 BigWigs 強調倒數訊息輸出此插件資訊。此訊息支持文字和顏色，同一時間只能顯示一條訊息。"
L.emphasizedMessages = "強調訊息"
L.emphasizedSinkDescription = "以 BigWigs 強調訊息輸出此插件資訊。此訊息支持文字和顏色，同一時間只能顯示一條訊息。"
L.enable = "啟用"
L.enableStats = "啟用統計"
L.encounterRestricted = "此功能在戰鬥中不能使用。"
L.fadeTime = "消退時間"
L.fadeTimeDesc = "以秒計訊息消退時間。"
L.fill = "填充"
L.fillDesc = "填充計時條而不是顯示為空。"
L.flash = "閃爍"
L.font = "字型"
L.fontColor = "字型顏色"
L.fontSize = "字型大小"
L.general = "一般"
L.growingUpwards = "向上成長"
L.growingUpwardsDesc = "切換在錨點向上或向下成長。"
L.icon = "圖示"
L.iconDesc = "顯示或隱藏計時條圖示。"
L.icons = "圖示"
L.Info = "資訊"
L.interceptMouseDesc = "啟用計時條接受點擊。"
L.left = "左"
L.localTimer = "本地"
L.lock = "鎖定"
L.lockDesc = "鎖定顯示視窗，防止被移動和縮放。"
L.Long = "長響"
L.messages = "訊息"
L.modifier = "修改"
L.modifierDesc = "按住選定的修改鍵以啟用計時條點擊操作。"
L.modifierKey = "只與修改鍵配合"
L.modifierKeyDesc = "除非修改鍵被按下否則允許計時條點擊穿越，此時游標以下動作可用。"
L.monochrome = "單一顏色"
L.monochromeDesc = "切換為單一顏色，移除全部字型邊緣平滑。"
L.move = "移動"
L.moveDesc = "移動強調計時條到強調錨點。如此選項關閉，強調計時條將只簡單的改變縮放和顏色。"
L.movieBlocked = "已經看過此動畫，跳過"
L.newBestTime = "新的最快擊殺！"
L.none = "無"
L.normal = "普通"
L.normalMessages = "一般訊息"
L.outline = "輪廓"
L.output = "輸出"
L.positionDesc = "在框中輸入座標或移動控制條把錨點定位至精確位置。"
L.positionExact = "精確位置"
L.positionX = "X 座標"
L.positionY = "Y座標"
L.primary = "主要"
L.primaryDesc = "戰鬥時使用的第一個團隊圖示。"
L.printBestTimeOption = "最快擊殺提醒"
L.printDefeatOption = "擊敗時間"
L.printWipeOption = "團滅時間"
L.proximity = "玩家雷達"
L.proximity_desc = "顯示玩家雷達視窗，列出距離你過近的玩家。"
L.proximity_name = "玩家雷達"
L.proximityTitle = "%d碼 / %d 玩家"
L.pull = "開怪倒數"
L.pullIn = "%d秒後開怪"
L.engageSoundTitle = "首領戰開始時播放音效"
L.pullStartedSoundTitle = "開怪倒數計時器開始時播放音效"
L.pullFinishedSoundTitle = "開怪倒數計時器結束時播放音效"
L.pullStarted = "%s使用者%s發起了開怪倒數計時器。"
L.pullStopped = "%s取消了開怪計時器。"
L.pullStoppedCombat = "開怪計時器因為你進入戰鬥而取消。"
L.raidIconsDesc = [=[團隊中有些首領模塊使用團隊標記來為某些中了特定技能的隊員打上標記。例如類似“炸彈”類或心靈控制的技能。如果你關閉此功能，你將不會給隊員打標記。

|cffff4411只有團隊領袖或被提升為助理時才可以這麼做！|r]=]
L.raidIconsDescription = [=[可能遇到包含例如炸彈類型的技能指向特定的玩家，玩家被追，或是特定玩家可能有興趣在其他方面。這裡可以自訂團隊圖示來標記這些玩家。

如果只遇到一種技能，很好，只有第一個圖示會被使用。在某些戰鬥中一個圖示不被使用在兩個不同的技能上，任何特定技能在下次總是使用相同圖示。

|cffff4411注意：如果玩家已經被手動標記，BigWigs 將不會改變他的圖示。|r]=]
L.recordBestTime = "記憶最快擊殺"
L.regularBars = "常規計時條"
L.remove = "移除"
L.removeDesc = "臨時移除計時條和全部相關訊息。"
L.removeOther = "移除其它"
L.removeOtherDesc = "臨時移除所有計時條（除此之外）和全部相關訊息。"
L.report = "報告"
L.reportDesc = "報告目前計時條狀態到合適的聊天頻道；無論是副本頻道、團隊、隊伍或是說。"
L.requiresLeadOrAssist = "這個功能需要團隊領隊或助理權限."
L.reset = "重置"
L.resetAll = "重置所有"
L.resetAllCustomSound = "如果設置全部首領戰鬥自訂的聲音，此按鈕將重置“全部”以這裡自訂的聲音來代替。"
L.resetAllDesc = "如果為首領戰鬥自訂了顏色設定。這個按鈕將重置替換“所有”顏色為預設。"
L.resetDesc = "重置以上顏色為預設。"
L.respawn = "重生"
L.restart = "重新加載"
L.restartDesc = "重新加載強調計時條並從10開始倒數。"
L.right = "右"
L.secondary = "次要"
L.secondaryDesc = "戰鬥時使用的第二個團隊圖示。"
L.sendBreak = "發送休息時間計時器到 BigWigs 和 DBM 用戶。"
L.sendCustomBar = "發送自訂計時條 '%s' 到BigWigs與DBM使用者."
L.sendPull = "發送一個拉怪倒數計時到BigWigs與DBM使用者."
L.showHide = "顯示/隱藏"
L.showRespawnBar = "顯示重生倒數計時器"
L.showRespawnBarDesc = "為滅團後首領重生倒數顯示計時器。"
L.sinkDescription = "向外通過 BigWigs 插件訊息顯示。這些包含了圖示，顏色和在同一時間在螢幕上的顯示4個訊息。新的訊息將再一次快速的放大和縮小來提醒用戶。新插入的訊息將增大並立即縮小提醒用戶注意。"
L.sound = "音效"
L.soundButton = "音效按鈕"
L.soundButtonDesc = "顯示或隱藏音效按鈕。"
L.soundDelay = "音效延遲"
L.soundDelayDesc = "當有人太靠近你時指定多長時間 BigWigs 重複間隔等待指定的音效。"
L.soundDesc = "訊息出現時伴隨著音效。有些人更容易在聽到何種音效後發現何種警報，而不是閱讀的實際訊息。"
L.Sounds = "音效"
L.style = "風格"
L.superEmphasize = "超級強調"
L.superEmphasizeDesc = [=[相關訊息或特定首領戰鬥技能計時條增強。

在這裡設定當開啟超級強調位於首領戰鬥技能進階選項時所應該發生的事件。

|cffff4411注意：超級強調功能預設情況下所有技能關閉。|r
]=]
L.superEmphasizeDisableDesc = "於所有模組停用超級強調。"
L.tempEmphasize = "暫時以超級強調顯示此計時條及任何相關的持續時間訊息。"
L.text = "文字"
L.textCountdown = "倒數文字"
L.textCountdownDesc = "於倒數時顯示倒數文字"
L.textShadow = "文字陰影"
L.texture = "材質"
L.thick = "粗"
L.thin = "細"
L.time = "時間"
L.timeDesc = "在計時條上顯示或隱藏時間。"
L.timerFinished = "%s：計時條[%s]到時間。"
L.title = "標題"
L.titleDesc = "顯示或隱藏標題。"
L.toggleDisplayPrint = "顯示將在下次出現。完全禁用此首領戰鬥，需在首領戰鬥選項中切換關閉。"
L.toggleSound = "切換音效"
L.toggleSoundDesc = "當近距離視窗有其他過近玩家時切換任一或關閉聲效。"
L.tooltip = "工具提示"
L.tooltipDesc = "顯示或隱藏近距離顯示從首領戰鬥技能獲取的法術提示。"
L.uppercase = "大寫"
L.uppercaseDesc = "所有超級強調選項相關訊息大寫。"
L.useColors = "使用彩色訊息"
L.useColorsDesc = "切換是否只發送單色訊息。"
L.useIcons = "使用圖示"
L.useIconsDesc = "訊息旁顯示圖示。"
L.Victory = "勝利訊息"
L.victoryHeader = "設定擊敗首領後顯示的訊息。"
L.victoryMessageBigWigs = "顯示 BigWigs 訊息"
L.victoryMessageBigWigsDesc = "BigWigs 訊息是一條簡單的「首領已被擊敗」訊息。"
L.victoryMessageBlizzard = "顯示暴雪內建訊息"
L.victoryMessageBlizzardDesc = "暴雪內建訊息會以特效顯示「首領被擊敗了」於畫面上。"
L.victoryMessages = "顯示擊敗首領訊息"
L.victorySound = "播放勝利音效"
L.Warning = "警報"
L.wipe = "滅團"
L.wipeSoundTitle = "滅團時播放音效"
L.wrongBreakFormat = "必須介於1至60分鐘之間。正確用法：/break 5"
L.wrongCustomBarFormat = "不正確的格式。一個正確的範例是: /raidbar 20 文字"
L.wrongPullFormat = "必須位於1至60秒之間。正確用法：/pull 5"
L.wrongTime = "指定的時間無效。 <time> 可以為一個秒數，一個 分:秒，或是Mm。例如 5, 1:20 或 2m。"

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
L.autoReplyAdvanced = "正在與「%s」（%s）戰鬥，尚有%d／%d人存活。"
L.autoReplyExtreme = "正在與「%s」（%s）戰鬥，尚有%d／%d人存活：%s"

L.autoReplyLeftCombatBasic = "已結束首領戰。"
L.autoReplyLeftCombatNormalWin = "已擊敗「%s」。"
L.autoReplyLeftCombatNormalWipe = "在「%s」的戰鬥中滅團。"
L.autoReplyLeftCombatAdvancedWin = "已擊敗「%s」，尚有%d／%d人存活。"
L.autoReplyLeftCombatAdvancedWipe = "在「%s」的戰鬥中滅團：%s"

-----------------------------------------------------------------------
-- Bars.lua
--

L.spacing = "間距"
L.spacingDesc = "更改每個計時條之間的間距"
L.emphasizeMultiplier = "尺寸倍數"
L.emphasizeMultiplierDesc = "如果你禁止計時條移動到強調計時條錨點，此選項可以調整一般計時條進入強調倒數後的放大倍率。"
L.iconPosition = "圖示位置"
L.iconPositionDesc = "選擇將圖示置於計時條的哪一側。"
L.visibleBarLimit = "最大可見數量"
L.visibleBarLimitDesc = "設定同時於螢幕上可見的計時條之最大數量。"
L.textDesc = "是否顯示或隱藏計時條上的文字。"

-----------------------------------------------------------------------
-- BossBlock.lua
--

L.disableSfx = "禁用音效"
L.disableSfxDesc = "關閉魔獸世界的音效選項中的「音效」部份，然後在首領戰之後恢復。這可以幫助您專注在BigWigs的警告音效。"
L.blockTooltipQuests = "滑鼠提示不顯示任務資訊"
L.blockTooltipQuestsDesc = "當你在進行擊殺某首領的任務時，滑鼠提示指向首領會顯示「0/1 完成」，導致滑鼠提示框變得很大，啟用這項功能可以避免這個情況。"
L.blockFollowerMission = "封鎖要塞彈出訊息"
L.blockFollowerMissionDesc = "要塞會彈出訊息，其中最主要的是追隨者任務完成的提示。\n\n這些彈出訊息有可能在首領戰鬥中遮蓋你的介面中重要的部份，因此我們建議封鎖這些彈出訊息。"
L.blockObjectiveTracker = "隱藏任務追蹤"
--L.blockObjectiveTrackerDesc = "在首領戰期間隱藏任務追蹤列表，使你的畫面能夠淨空。\n\nThis will NOT happen if you are in a mythic+ or are tracking an achievement."

L.subzone_grand_bazaar = "大市集" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_port_of_zandalar = "贊達拉港" -- Battle of Dazar'alor raid (Battle for Azeroth)
L.subzone_eastern_transept = "東穿堂" -- Auchindoun dungeon (Warlords of Draenor)

-----------------------------------------------------------------------
-- Colors.lua
--

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
-- InfoBox.lua
--

L.infoBox = "訊息盒"

-----------------------------------------------------------------------
-- Statistics.lua
--

L.printHealthOption = "首領血量"
L.healthPrint = "血量：%s。"
L.healthFormat = "%s（%.1f%%）"
