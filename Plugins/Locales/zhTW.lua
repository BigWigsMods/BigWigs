local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs:Plugins", "zhTW")

if not L then return end

-- Bars2.lua

L["Bars"] = "計時條"
L["Normal Bars"] = "一般計時條"
L["Emphasized Bars"] = "強調條"
L["Options for the timer bars."] = "計時條選項。"
L["Toggle anchors"] = "切換錨點"
L["Show or hide the bar anchors for both normal and emphasized bars."] = "顯示或隱藏計時條與強調條錨點。"
L["Scale"] = "縮放"
L["Set the bar scale."] = "設定計時條縮放。"
L["Grow upwards"] = "向上成長"
L["Toggle bars grow upwards/downwards from anchor."] = "切換計時條在錨點向上或向下成長。"
L["Texture"] = "材質"
L["Set the texture for the timer bars."] = "設定計時條的材質。"
L["Test"] = "測試"
L["Close"] = "關閉"
L["Emphasize"] = "強調"
L["Emphasize bars that are close to completion (<10sec). Also note that bars started at less than 15 seconds initially will be emphasized right away."] = "強調條是當接近（小於10秒）。如果計時條開始時間小於15秒則會立刻強調顯示。"
L["Enable"] = "啟用"
L["Enables emphasizing bars."] = "啟用強調條。"
L["Move"] = "移動"
L["Moves emphasized bars to the Emphasize anchor. If this option is off, emphasized bars will simply change scale and color, and maybe start flashing."] = "移動強調條到強調錨點。如果此選項關閉，強調條將只改變縮放與顏色以及可能開始閃爍。"
L["Set the scale for emphasized bars."] = "設定強調條縮放。"
L["Reset position"] = "重置位置"
L["Reset the anchor positions, moving them to their default positions."] = "重置錨點位置，移動它們到預設位置。"
L["Test"] = "測試"
L["Creates a new test bar."] = "新建測試計時條。"
L["Hide"] = "隱藏"
L["Hides the anchors."] = "隱藏錨點。"
L["Flash"] = "閃爍"
L["Flashes the background of emphasized bars, which could make it easier for you to spot them."] = "強調條背景閃爍，方便你留意它。"
L["Regular bars"] = "常規計時條"
L["Emphasized bars"] = "強調條"
L["Align"] = "對齊"
L["How to align the bar labels."] = "對齊計時條標籤。"
L["Left"] = "左"
L["Center"] = "中"
L["Right"] = "右"
L["Time"] = "時間"
L["Whether to show or hide the time left on the bars."] = "在計時條上顯示或隱藏時間。"
L["Icon"] = "圖示"
L["Shows or hides the bar icons."] = "顯示或隱藏計時條圖示。"
L["Font"] = "字型"
L["Set the font for the timer bars."] = "設定計時條字型。"

-- Colors.lua

L["Colors"] = "顏色"

L["Messages"] = "訊息"
L["Bars"] = "計時條"
L["Short"] = "短"
L["Long"] = "長"
L["Short bars"] = "短計時條"
L["Long bars"] = "長計時條"
L["Color "] = "顏色 "
L["Number of colors"] = "顏色數量"
L["Background"] = "背景"
L["Text"] = "文字"
L["Reset"] = "重置"

L["Bar"] = "計時條"
L["Change the normal bar color."] = "改變計時條顏色。"
L["Emphasized bar"] = "強調條"
L["Change the emphasized bar color."] = "改變強調條顏色。"

L["Colors of messages and bars."] = "訊息文字與計時條顏色。"
L["Change the color for %q messages."] = "變更%q訊息的顏色。"
L["Change the %s color."] = "變更%s顏色。"
L["Change the bar background color."] = "變計時條更背景顏色"
L["Change the bar text color."] = "變更計時條文字顏色。"
L["Resets all colors to defaults."] = "全部重置為預設狀態。"

L["Important"] = "重要"
L["Personal"] = "個人"
L["Urgent"] = "緊急"
L["Attention"] = "注意"
L["Positive"] = "積極"
L["Bosskill"] = "首領擊殺"
L["Core"] = "核心"

L["color_upgrade"] = "為了更快升級到最新版本,訊息顏色數據和計時條已經重置. 如果你想要再次調整, 右鍵點擊 BigWigs然後移到插件 -> 顏色。"

-- Messages.lua

L["Messages"] = "訊息"
L["Options for message display."] = "訊息框架選項。"

L["BigWigs Anchor"] = "BigWigs 錨點"
L["Output Settings"] = "輸出設定"

L["Show anchor"] = "顯示錨點"
L["Show the message anchor frame.\n\nNote that the anchor is only usable if you select 'BigWigs' as Output."] = "顯示訊息錨點。\n\n只有輸出為“BigWigs”時錨點可用。"

L["Use colors"] = "使用彩色訊息"
L["Toggles white only messages ignoring coloring."] = "切換是否只發送單色訊息。"

L["Scale"] = "縮放"
L["Set the message frame scale."] = "設定訊息框架縮放。"

L["Use icons"] = "使用圖示"
L["Show icons next to messages, only works for Raid Warning."] = "顯示圖示，只能使用在團隊警告頻道。"

L["Class colors"] = "職業顏色"
L["Colors player names in messages by their class."] = "使用職業顏色來染色訊息內玩家顏色。"

L["|cffff0000Co|cffff00fflo|cff00ff00r|r"] = "|cffff0000顏|cffff00ff色|r"
L["White"] = "白色"

L["Outputs all BigWigs messages to the default chat frame in addition to the display setting."] = "除了選擇的顯示位置外，也顯示在聊天頻道上。"

L["Chat frame"] = "聊天框架"

L["Test"] = "測試"
L["Close"] = "關閉"

L["Reset position"] = "重置位置"
L["Reset the anchor position, moving it to the center of your screen."] = "重置錨點位置，將它移至螢幕中央。"

L["Spawns a new test warning."] = "生成一個新的警報測試。"
L["Hide"] = "隱藏"
L["Hides the anchors."] = "隱藏錨點。"


-- RaidIcon.lua

L["Raid Icons"] = "團隊圖示"
L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = "為 BigWigs 配置一個團隊標記，以便為中了'炸彈'級別的玩家打上標記，以示提醒。"

L["RaidIcon"] = "團隊標記"

L["Place"] = "標記"
L["Place Raid Icons"] = "標記團隊圖示"
L["Toggle placing of Raid Icons on players."] = "切換是否在玩家身上標記團隊圖示。"

L["Icon"] = "圖示"
L["Set Icon"] = "設定圖示"
L["Set which icon to place on players."] = "設定玩家身上標記的圖示。"

L["Use the %q icon when automatically placing raid icons for boss abilities."] = "使用%q標記首領的需要注意的技能目標。"

L["Star"] = "星星"
L["Circle"] = "圓圈"
L["Diamond"] = "菱形"
L["Triangle"] = "三角"
L["Moon"] = "月亮"
L["Square"] = "方塊"
L["Cross"] = "十字"
L["Skull"] = "骷髏"

-- RaidWarn.lua
L["RaidWarning"] = "團隊警報"

L["Whisper"] = "密語"
L["Toggle whispering warnings to players."] = "切換是否通過密語向玩家發送訊息。"

L["raidwarning_desc"] = "團隊警告選項"

-- Sound.lua

L["Sounds"] = "聲音"
L["Options for sounds."] = "聲音選項。"

L["Alarm"] = "鬧鈴"
L["Info"] = "資訊"
L["Alert"] = "警告"
L["Long"] = "長響"
L["Victory"] = "勝利"

L["Set the sound to use for %q.\n\nCtrl-Click a sound to preview."] = "設置使用%q聲音（Ctrl-點擊可以預覽效果）。"
L["Use sounds"] = "使用聲音"
L["Toggle all sounds on or off."] = "切換是否使用聲音。"
L["Default only"] = "僅用預設"
L["Use only the default sound."] = "只用預設聲音。"
