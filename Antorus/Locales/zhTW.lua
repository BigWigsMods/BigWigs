local L = BigWigs:NewBossLocale("Argus the Unmaker", "zhTW")
if not L then return end
if L then
	L.combinedBurstAndBomb = "合併靈魂驟發與靈魂炸彈"
	L.combinedBurstAndBomb_desc = "|cff71d5ff靈魂炸彈|r總是與|cff71d5ff靈魂驟發|r一起使用。啟用此選項將兩條訊息合併為一條。"

	L.custom_off_always_show_combined = "總是顯示靈魂驟發與靈魂炸彈的合併訊息"
	L.custom_off_always_show_combined_desc = "當你中了|cff71d5ff靈魂炸彈|r或|cff71d5ff靈魂驟發|r時，不會顯示合併訊息，只會提示你受到影響。啟用此選項將會使訊息強制以合併模式顯示，即使你中了技能。|cff33ff99對團隊領袖很有用。|r"

	L.fear_help = "合併薩格拉斯的恐懼"
	L.fear_help_desc = "當你同時受到|cff71d5ff薩格拉斯的恐懼|r和|cff71d5ff靈魂之疫|r／|cff71d5ff靈魂驟發|r／|cff71d5ff靈魂炸彈|r／|cff71d5ff薩格拉斯的判決|r影響時，改說合併兩者的特殊訊息。"

	L[257931] = "恐懼" -- short for Sargeras' Fear
	L[248396] = "靈魂之疫" -- short for Soulblight
	L[251570] = "炸彈" -- short for Soulbomb
	L[250669] = "驟發" -- short for Soulburst
	L[257966] = "判決" -- short for Sentence of Sargeras

	L.stage2_early = "讓大海的怒濤洗淨所有的腐化吧！"
	L.stage3_early = "沒有希望。只有痛苦！"

	L.gifts = "天之賜：%s，海之賜：%s"
	L.burst = "|T1778229:15:15:0:0:64:64:4:60:4:60|t驟發：%s" -- short for Soulburst
	L.bomb = "|T1778228:15:15:0:0:64:64:4:60:4:60|t炸彈：%s" -- short for Soulbomb

	L.sky_say = "{rt5}爆擊精通" -- short for Critical Strike/Mastery (stats)
	L.sea_say = "{rt6}加速臨機" -- short for Haste/Versatility (stats)

	L.bomb_explosions = "炸彈爆炸"
	L.bomb_explosions_desc = "替靈魂驟發與靈魂炸彈顯示爆炸計時。"
end

L = BigWigs:NewBossLocale("Aggramar", "zhTW")
if L then
	L.wave_cleared = "第%d波清理完畢！" -- Wave 1 Cleared!

	L.track_ember = "泰夏拉克燼火狀態追蹤"
	L.track_ember_desc = "替每個泰夏拉克燼火的死亡顯示訊息。"

	L.custom_off_ember_marker_desc = "標記泰夏拉克燼火為{rt1}{rt2}{rt3}{rt4}{rt5}，需要權限。\n|cff33ff99傳奇模式：只會標記當前這波小怪中能量值超過45的目標。|r"
end

L = BigWigs:NewBossLocale("The Coven of Shivarra", "zhTW")
if L then
	L.torment_of_the_titans_desc = "希瓦拉巫女會迫使泰坦的靈魂使用他們的能力對付玩家。"

	L.timeLeft = "%.1f秒" -- s = seconds
	L.torment = "苦難：%s"
	L.nextTorment = "下次苦難：|cffffffff%s|r"
	L.tormentHeal = "阿曼蘇爾" -- something like Heal/DoT (max 10 characters)
	L.tormentLightning = "閃電鍊" -- short for "Chain Lightning" (or similar, max 10 characters)
	L.tormentArmy = "大軍" -- short for "Spectral Army of Norgannon" (or similar, max 10 characters)
	L.tormentFlames = "噴火" -- short for "Flames of Khaz'goroth" (or similar, max 10 characters)
end

L = BigWigs:NewBossLocale("Eonar the Life-Binder", "zhTW")
if L then
	L.warp_in_desc = "顯示每一波怪的計時器與訊息，並提示其中的重要怪物。"

	L.top_lane = "上"
	L.mid_lane = "中"
	L.bot_lane = "下"

	L.purifier = "淨化者" -- Fel-Powered Purifier
	L.destructor = "毀滅者" -- Fel-Infused Destructor
	L.obfuscator = "匿蹤者" -- Fel-Charged Obfuscator
	L.bats = "蝙蝠"
end

L = BigWigs:NewBossLocale("Portal Keeper Hasabel", "zhTW")
if L then
	L.custom_on_stop_timers = "總是顯示計時器"
	L.custom_on_stop_timers_desc = "海瑟貝爾會在下一次施放技能時隨機施放已經冷卻完畢的技能，啟用此選項後，這些技能的計時條會保持顯示。"
	L.custom_on_filter_platforms = "過濾外側平台的警告與計時器"
	L.custom_on_filter_platforms_desc = "如果你不是上台組，關閉不需要的外側平台提示，只顯示中央場地的警告與計時器。"
	L.worldExplosion_desc = "替崩裂世界的爆炸顯示計時器。"
	L.platform_active = "%s啟動！" -- Platform: Xoroth Active!
	L.add_killed = "%s擊殺！"
end

L = BigWigs:NewBossLocale("Kin'garoth", "zhTW")
if L then
	L.empowered = "（強化）%s" -- (E) Ruiner
	L.gains = "金加洛斯獲得了%s" -- Kin'garoth gains Empowered Ruiner
end

L = BigWigs:NewBossLocale("Antoran High Command", "zhTW")
if L then
	L.felshieldActivated = "%s啟動了魔盾"
	L.felshieldUp = "魔盾"
end

L = BigWigs:NewBossLocale("Gorothi Worldbreaker", "zhTW")
if L then
	L.cannon_ability_desc = "顯示被兩門火砲強化後的技能訊息與計時器。"

	L.missileImpact = "屠殺生效"
	L.missileImpact_desc = "顯示屠殺飛彈著陸計時器。"

	L.decimationImpact = "殲滅生效"
	L.decimationImpact_desc = "顯示殲滅飛彈著陸計時器。"
end

L = BigWigs:NewBossLocale("Antorus Trash", "zhTW")
if L then
	-- [[ Before Antoran High Command ]] --
	--L.flameweaver = "Flameweaver"
	--L.deconix = "Imperator Deconix"
	--L.clobex = "Clobex"

	L.isLinkedWith = ">%s< 與 >%s< 相連"
	L.yourLink = ">你< 與 >%s< 相連"

	-- [[ Before Varimathras / Coven of Shivarra ]] --
	--L.tarneth = "Tarneth"
	--L.priestess = "Priestess of Delirium"

	-- [[ Before Aggramar ]] --
	--L.aedis = "Dark Keeper Aedis"
end
