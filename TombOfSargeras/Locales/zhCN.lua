local L = BigWigs:NewBossLocale("Harjatan the Bludger", "zhCN")
if not L then return end
if L then
	L.custom_on_fixate_plates = "敌对姓名板凝视图标"
	L.custom_on_fixate_plates_desc = "当你被凝视时在目标姓名板上显示一个图标。\n需要使用敌对姓名板。此功能当前只支持 KuiNameplates。"
end

L = BigWigs:NewBossLocale("Demonic Inquisition", "zhCN")
if L then
	L.custom_on_fixate_plates = "敌对姓名板凝视图标"
	L.custom_on_fixate_plates_desc = "当你被凝视时在目标姓名板上显示一个图标。\n需要使用敌对姓名板。此功能当前只支持 KuiNameplates。"

	L.infobox_title_prisoners = "%d 囚徒"

	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "恶魔审判庭一些技能会因为施放或被打断其它技能而延迟。当启用此选项，这些技能条将总是显示在屏幕上。"
end

L = BigWigs:NewBossLocale("Mistress Sassz'ine", "zhCN")
if L then
	L.inks_fed_count = "墨汁（%d/%d）"
	L.inks_fed = "喂食墨汁：%s" -- %s = List of players
end

L = BigWigs:NewBossLocale("The Desolate Host", "zhCN")
if L then
	L.infobox_players = "玩家"
	L.armor_remaining = "%s 剩余（%d）" -- Bonecage Armor Remaining (#)
	L.custom_on_mythic_armor = "在史诗难度下忽略复活的圣殿骑士的骨牢护甲"
	L.custom_on_mythic_armor_desc = "如果你不是负责复活的圣殿骑士的坦克，保持此选项启用来忽略提示和计数复活的圣殿骑士的骨牢护甲。"
	L.custom_on_armor_plates = "敌对姓名板的骨牢护甲"
	L.custom_on_armor_plates_desc = "当复活的圣殿骑士有骨牢护甲时在姓名板上显示图标。\n需要使用敌对姓名板。此功能当前只支持 KuiNameplates。"
	L.tormentingCriesSay = "哀嚎" -- Tormenting Cries (short say)
end

L = BigWigs:NewBossLocale("Maiden of Vigilance", "zhCN")
if L then
	L.infusionChanged = "灌注>改变<：%s"
	L.sameInfusion = "相同灌注：%s"
	L.fel = "邪能"
	L.light = "光明"
	L.felHammer = "邪能锤" -- Better name for "Hammer of Obliteration"
	L.lightHammer = "圣光锤" -- Better name for "Hammer of Creation"
	L.absorb = "吸收"
	L.absorb_text = "%s （|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒 (|cff%s%.0f%%|r)" -- s = seconds
	L.stacks = "层数"
end

L = BigWigs:NewBossLocale("Fallen Avatar", "zhCN")
if L then
	L.touch_impact = "萨格拉斯之触冲击" -- Touch of Sargeras Impact (short)

	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "堕落的化身下次会随机施放冷却完毕的技能。当启用此选项，这些技能条将总是显示在屏幕上。"

	L.energy_leak = "能量泄漏"
	L.energy_leak_desc = "当第一阶段首领能量泄漏时显示警报。"
	L.energy_leak_msg = "能量泄漏！（%d）"

	L.warmup_trigger = "你们眼前的躯壳曾承载过萨格拉斯的力量" -- The husk before you was once a vessel for the might of Sargeras. But this temple itself is our prize. The means by which we will reduce your world to cinders!

	L.absorb = "吸收"
	L.absorb_text = "%s （|cff%s%.0f%%|r）"
	L.cast = "施放"
	L.cast_text = "%.1f秒 (|cff%s%.0f%%|r)" -- s = seconds
end

L = BigWigs:NewBossLocale("Kil'jaeden", "zhCN")
if L then
	L.singularityImpact = "奇点冲击"
	L.obeliskExplosion = "方尖碑爆炸"
	L.obeliskExplosion_desc = "方尖碑爆炸计时器"

	L.darkness = "千魂" -- Shorter name for Darkness of a Thousand Souls (238999)
	L.reflectionErupting = "映像：爆发" -- Shorter name for Shadow Reflection: Erupting (236710)
	L.reflectionWailing = "映像：哀嚎" -- Shorter name for Shadow Reflection: Wailing (236378)
	L.reflectionHopeless = "映像：绝望" -- Shorter name for Shadow Reflection: Hopeless (237590)

	L.rupturingKnock = "断裂奇点击退"
	L.rupturingKnock_desc = "显示击退计时器"

	L.meteorImpact_desc = "陨石雨降落计时器"

	L.shadowsoul = "千魂生命值追踪"
	L.shadowsoul_desc = "在信息盒显示当前5个千魂增援当前生命值。"

	L.custom_on_track_illidan = "自动追踪人形生物"
	L.custom_on_track_illidan_desc = "如果你是猎人或者野性德鲁伊，此选项将自动启用追踪人型生物以便于追踪到伊利丹。"

	L.custom_on_zoom_in = "自动缩放迷你地图"
	L.custom_on_zoom_in_desc = "此功能将设置迷你地图缩放等级为4以便于更快追踪伊利丹，并将在此阶段结束后恢复到你之前设置的等级。"
end

L = BigWigs:NewBossLocale("Tomb of Sargeras Trash", "zhCN")
if L then
	L.rune = "兽人符文"
	L.chaosbringer = "地狱火混沌使者"
	L.rez = "守墓人瑞兹"
	L.erduval = "艾杜瓦尔"
	L.varah = "角鹰兽领主瓦拉"
	L.seacaller = "潮鳞海歌者"
	L.custodian = "海底监察者"
	L.dresanoth = "德萨诺斯"
	L.stalker = "恐怖追猎者"
	L.darjah = "督军达加尔"
	L.sentry = "守护者哨兵"
	L.acolyte = "幽灵助祭"
	L.ryul = "消逝者鲁尔"
	L.countermeasure = "防御性反制机关"
end
