local L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "zhCN")
if not L then return end
if L then
	L.traps = "陷阱" -- Stasis Trap
	L.sparknova = "火花新星" -- Hyperlight Sparknova
	L.relocation = "坦克炸弹" -- Glyph of Relocation
	L.wormholes = "虫洞" -- Interdimensional Wormholes
	L.wormhole = "虫洞" -- Interdimensional Wormhole
	L.rings = "法环 %d 阶段" -- Forerunner Rings // Added P1, P2, P3 etc to help identify what rings
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "zhCN")
if L then
	L.staggering_barrage = "弹幕" -- Staggering Barrage
	L.domination_core = "小怪" -- Domination Core
	L.obliteration_arc = "连奏" -- Obliteration Arc

	L.disintergration_halo = "光环" -- Disintegration Halo
	L.rings_x = "光环 x%d"
	L.rings_enrage = "光环 (激怒)"
	L.ring_count = "光环 (%d/%d)"

	L.shield_removed = "%s 在 %.1fs 移除" -- "Shield removed after 1.1s" s = seconds
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "zhCN")
if L then
	L.necrotic_ritual = "仪式"
	L.runecarvers_deathtouch = "死亡之触"
	L.windswept_wings = "啸风"
	L.wild_stampede = "践踏"
	L.withering_seeds = "种子"
	L.hand_of_destruction = "毁灭之手"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "zhCN")
if L then
	L.protoform_cascade = "正面"
	L.cosmic_shift = "推开"
	L.unstable_mote = "微粒"
	L.mote = "微粒"

	L.custom_on_nameplate_fixate = "被征用姓名板图标"
	L.custom_on_nameplate_fixate_desc = "在征用自动体姓名板上显示你是被征用.\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates，Plater）。"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "zhCN")
if L then
	L.custom_off_repeating_blasphemy = "渎神之光"
	L.custom_off_repeating_blasphemy_desc = "中了渎神之光说带有图标 {rt1}、{rt3} 的消息,找到匹配项来消除你的减益。"

	L.kingsmourne_hungers = "王之哀伤"
	L.blasphemy = "标记"
	L.befouled_barrier = "屏障"
	L.wicked_star = "邪恶"
	L.domination_word_pain = "DW:痛"
	L.army_of_the_dead = "大军"
	L.grim_reflections = "黑暗镜像"
	L.march_of_the_damned = "阶段"
	L.dire_blasphemy = "标记"
	L.beacon_of_hope = "信标"

	L.remnant_active = "剩余活跃"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "zhCN")
if L then
	L.tank_combo_desc = "显示 裂隙之吼/撕裂 满100能量释放的计时器"
end

L = BigWigs:NewBossLocale("Vigilant Guardian", "zhCN")
if L then
	L.sentry = "卫士小怪"
	L.materium = "小怪"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "zhCN")
if L then
	L.seismic_tremors = "微尘 + 震颤" -- Seismic Tremors
	L.earthbreaker_missiles = "飞弹" -- Earthbreaker Missiles
	L.crushing_prism = "棱镜" -- Crushing Prism
	L.prism = "棱镜"

	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "黑伦度斯可能延迟它的技能。启用此选项后,这些技能将保留在您的屏幕上。"
end
