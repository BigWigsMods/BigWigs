local L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "zhCN")
if not L then return end
if L then
	L.traps = "陷阱" -- Stasis Trap
	L.sparknova = "火花新星" -- Hyperlight Sparknova
	L.relocation = "坦克炸弹" -- Glyph of Relocation
	L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "虫洞" -- Interdimensional Wormholes
	L.wormhole = "虫洞" -- Interdimensional Wormhole
	L.rings = "法环 %d 阶段" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "zhCN")
if L then
	L.staggering_barrage = "弹幕" -- Staggering Barrage
	L.domination_core = "小怪" -- Domination Core
	L.obliteration_arc = "湮灭" -- Obliteration Arc

	L.disintergration_halo = "光环" -- Disintegration Halo
	L.rings_x = "光环 x%d"
	L.rings_enrage = "光环 (激怒)"
	L.ring_count = "光环 (%d/%d)"

	L.shield_removed = "%s 在 %.1fs 移除" -- "Shield removed after 1.1s" s = seconds
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "zhCN")
if L then
	L.necrotic_ritual = "死灵仪式"
	L.runecarvers_deathtouch = "死亡之触"
	L.windswept_wings = "啸风"
	L.wild_stampede = "兽群"
	L.withering_seeds = "种子"
	L.hand_of_destruction = "毁灭之手"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "zhCN")
if L then
	L.protoform_cascade = "散射"
	L.cosmic_shift = "击退"
	L.unstable_mote = "微粒"
	L.mote = "微粒"

	L.custom_on_nameplate_fixate = "被征用姓名板图标"
	L.custom_on_nameplate_fixate_desc = "在目标是你的自动体的姓名板上显示图标.\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates，Plater）。"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "zhCN")
if L then
	L.custom_off_repeating_blasphemy = "重复渎神之光"
	L.custom_off_repeating_blasphemy_desc = "以{rt1}和{rt3} 说话两种渎神之光印记,方便你快速地找到相反印记的队友，并消除自身印记"

	L.kingsmourne_hungers = "王之哀伤"
	L.blasphemy = "标记"
	L.befouled_barrier = "屏障"
	L.wicked_star = "邪恶之星"
	L.domination_word_pain = "御言术:痛"
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
	L.sentry = "卫士"
	L.materium = "哨兵"
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
