local L = BigWigs:NewBossLocale("Harjatan the Bludger", "zhTW")
if not L then return end
if L then
	L.custom_on_fixate_plates = "在敵方名條顯示追擊圖示"
	L.custom_on_fixate_plates_desc = "當你被凝視時，在敵方名條上顯示一個圖示。\n需要啟用敵方名條，此功能目前只支援KuiNameplates。"
end

L = BigWigs:NewBossLocale("Demonic Inquisition", "zhTW")
if L then
	L.custom_on_fixate_plates = "在敵方名條顯示追擊圖示"
	L.custom_on_fixate_plates_desc = "當你被凝視時，在敵方明條上顯示一個圖示。\n需要啟用敵方名條，此功能目前只支援KuiNameplates。"

	L.infobox_title_prisoners = "%d囚犯"

	L.custom_on_stop_timers = "總是顯示技能條"
	L.custom_on_stop_timers_desc = "惡魔審判官的部份技能會被斷法或其他技能的法術詠唱推遲。啟用此選項後，這些技能的計時條會保持顯示。"
end

L = BigWigs:NewBossLocale("Mistress Sassz'ine", "zhTW")
if L then
	L.inks_fed_count = "墨水（%d/%d）"
	L.inks_fed = "喂食墨水：%s" -- %s = List of players
end

L = BigWigs:NewBossLocale("The Desolate Host", "zhTW")
if L then
	L.infobox_players = "玩家"
	L.armor_remaining = "剩餘%s（%d）" -- Bonecage Armor Remaining (#)
	L.custom_on_mythic_armor = "在傳奇難度中，忽略再活化的聖殿騎士的骨牢護甲"
	L.custom_on_mythic_armor_desc = "如果你不是負責坦住「再活化的聖殿騎士」的坦克，請保持此選項啟用，以便忽略骨牢護甲的提示和計數。"
	L.custom_on_armor_plates = "在敵方名條上顯示骨牢護甲"
	L.custom_on_armor_plates_desc = "在敵方名條上顯示骨牢護甲和其層數。\n需要啟用敵方名條，此功能目前只支援KuiNameplates。"
	L.tormentingCriesSay = "號哭" -- Tormenting Cries (short say)
end

L = BigWigs:NewBossLocale("Maiden of Vigilance", "zhTW")
if L then
	L.infusionChanged = "注入改變：%s"
	L.sameInfusion = "相同注入：%s"
	L.fel = "魔化"
	L.light = "聖光"
	L.felHammer = "魔化錘" -- Better name for "Hammer of Obliteration"
	L.lightHammer = "聖光錘" -- Better name for "Hammer of Creation"
	L.absorb = "吸收"
	L.absorb_text = "%s （|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒 （|cff%s%.0f%%|r）" -- s = seconds
	L.stacks = "層數"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "zhTW")
if L then
	L.touch_impact = "薩格拉斯之觸衝擊" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "總是顯示技能條"
	L.custom_on_stop_timers_desc = "墮落化身會在下一次施放技能時隨機施放已經冷卻完畢的技能，啟用此選項後，這些技能的計時條會保持顯示。"

	L.energy_leak = "能量外泄"
	L.energy_leak_desc = "第一階段的能量外泄至墮落化身身上时發送警報。"
	L.energy_leak_msg = "能量外泄！（%d）"

	L.warmup_trigger = "你看到的這個軀殼原本蘊含薩格拉斯的力量" -- The husk before you was once a vessel for the might of Sargeras. But this temple itself is our prize. The means by which we will reduce your world to cinders!

	L.absorb = "吸收"
	L.absorb_text = "%s （|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒 （|cff%s%.0f%%|r）" -- s = seconds
end

L = BigWigs:NewBossLocale("Kil'jaeden", "zhTW")
if L then
	L.singularityImpact = "奇異點衝擊"
	L.obeliskExplosion = "石碑爆炸"
	L.obeliskExplosion_desc = "石碑爆炸計時器"

	L.darkness = "千魂之暗" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "分身：爆發" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "分身：哀號" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "分身：絕望" -- Shorter name for Shadow Reflection: Hopeless (237590)

	L.rupturingKnock = "破裂奇異點擊退"
	L.rupturingKnock_desc = "顯示擊退計時器"

	L.meteorImpact_desc = "顯示隕石雨降落計時器"

	L.shadowsoul = "暗影之魂生命值追蹤器"
	L.shadowsoul_desc = "在訊息盒顯示五個暗影之魂的當前生命值。"

	L.custom_on_track_illidan = "自動追蹤人型生物"
	L.custom_on_track_illidan_desc = "如果你是野性德魯伊或獵人，啟用此選像項會自動啟用追蹤人型生物，以便追蹤伊利丹。"

	L.custom_on_zoom_in = "自動縮放小地圖"
	L.custom_on_zoom_in_desc = "這個功能會將小地圖的縮放等級調整到等級4，使之更便於追蹤伊利丹；並在這個階段結束後還原為你原先設定的等級。"
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "zhTW")
if L then
	L.rune = "獸人符文"
	L.chaosbringer = "煉獄火混亂使者"
	L.rez = "守墓者瑞茲"
	L.erduval = "厄爾多瓦"
	L.varah = "角鷹獸之王瓦拉"
	L.seacaller = "潮鱗喚海者"
	L.custodian = "深海守衛"
	L.dresanoth = "卓薩諾斯"
	L.stalker = "恐怖潛獵者"
	L.darjah = "督軍達爾嘉"
	L.sentry = "守護者哨衛"
	L.acolyte = "鬼魅侍僧"
	L.ryul = "暗淡者萊由"
	L.countermeasure = "防禦反制系統"
end
