local L = BigWigs:NewBossLocale("Vigilant Guardian", "zhCN")
if not L then return end
if L then
	L.sentry = "哨兵"
	L.materium = "素材"
	L.shield = "核心" -- Global locale canidate?
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "zhCN")
if L then
	L.tank_combo_desc = "显示 裂隙之吼与撕裂 满100能量释放的计时器"
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "zhCN")
if L then
	L.traps = "陷阱" -- Stasis Trap
	L.sparknova = "火花新星" -- Hyperlight Sparknova
	L.relocation = "坦克炸弹" -- Glyph of Relocation
	L.relocation_count = "%s :阶段%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "虫洞" -- Interdimensional Wormholes
	L.wormhole = "虫洞" -- Interdimensional Wormhole
	L.rings = "第 %d 阶段法环" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "zhCN")
if L then
	L.staggering_barrage = "分摊" -- Staggering Barrage
	L.domination_core = "小怪" -- Domination Core
	L.obliteration_arc = "弹幕" -- Obliteration Arc

	L.disintergration_halo = "光环" -- Disintegration Halo
	L.rings_x = "光环 x%d"
	L.rings_enrage = "光环 (激怒)"
	L.ring_count = "光环 (%d/%d)"

	L.custom_on_ring_timers = "衰变光环计时条"
	L.custom_on_ring_timers_desc = "使用衰变光环设置：这是显示衰变光环在触发能量环时,开始移动的计时条。"

	L.shield_removed = "%s 在 %.1fs 移除" -- "Shield removed after 1.1s" s = seconds
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "zhCN")
if L then
	L.necrotic_ritual = "死灵仪式"
	L.runecarvers_deathtouch = "死亡之触"
	L.windswept_wings = "啸风"
	L.wild_stampede = "兽群"
	L.withering_seeds = "种子"
	L.hand_of_destruction = "群拉"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "zhCN")
if L then
	L.protoform_cascade = "炸弹"
	L.cosmic_shift = "击退"
	L.cosmic_shift_mythic = "击退: %s"
	L.unstable_mote = "微粒"
	L.mote = "微粒"

	L.custom_on_nameplate_fixate = "被征用姓名板图标"
	L.custom_on_nameplate_fixate_desc = "在目标是你的自动体的姓名板上显示图标。\n\n需要使用敌对姓名板和支持姓名板的插件（KuiNameplates,Plater）。"

	L.harmonic = "谐波 (推离)"
	L.melodic = "旋律 (拉近)"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "zhCN")
if L then
	L.seismic_tremors = "微尘 + 震颤" -- Seismic Tremors
	L.earthbreaker_missiles = "飞弹" -- Earthbreaker Missiles
	L.crushing_prism = "棱镜" -- Crushing Prism
	L.prism = "棱镜"

	L.bomb_dropped = "炸弹掉落"

	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "黑伦度斯可能延迟它的技能。启用此选项后，这些技能将保留在您的屏幕上。"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "zhCN")
if L then
	L.custom_off_repeating_blasphemy = "重复渎神之光"
	L.custom_off_repeating_blasphemy_desc = "以{rt1}和{rt3} 重覆说话两种渎神之光印记，方便你快速地找到相反印记的队友，并消除自身印记。"

	L.kingsmourne_hungers = "王之哀伤"
	L.blasphemy = "标记"
	L.befouled_barrier = "屏障"
	L.wicked_star = "邪恶之星"
	L.domination_word_pain = "御言术:痛"
	L.army_of_the_dead = "大军"
	L.grim_reflections = "黑暗镜像"
	L.march_of_the_damned = "阶段"
	L.dire_blasphemy = "标记"

	L.remnant_active = "陨落君王"
end

L = BigWigs:NewBossLocale("Lords of Dread", "zhCN")
if L then
	L.unto_darkness = "AoE 阶段"-- Unto Darkness
	L.cloud_of_carrion = "腐臭" -- Cloud of Carrion
	L.empowered_cloud_of_carrion = "强化腐臭" -- Empowered Cloud of Carrion
	L.manifest_shadows = "小怪" -- Manifest Shadows
	L.leeching_claws = "正面顺劈 (玛)" -- Leeching Claws
	L.infiltration_of_dread = "抓內鬼" -- Infiltration of Dread
	L.infiltration_removed = "内鬼发现，用时 %.1f 秒" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "爆裂恐惧" -- Fearful Trepidation
	L.slumber_cloud = "迷雾" -- Slumber Cloud
	L.anguishing_strike = "正面顺劈 (金)" -- Anguishing Strike

	L.custom_on_repeating_biting_wound = "重复啃噬伤口"
	L.custom_on_repeating_biting_wound_desc = "以团队标记 {rt7} 重覆说话啃噬伤口，以使其显得更明显。"
end

L = BigWigs:NewBossLocale("Rygelon", "zhCN")
if L then
	L.celestial_collapse = "类星体" -- Celestial Collapse
	L.manifest_cosmos = "宇宙核心" -- Manifest Cosmos
	L.stellar_shroud = "吸收治疗量" -- Stellar Shroud
	L.knock = "击退" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "zhCN")
if L then
	L.rune_of_damnation_countdown = "倒计时"
	L.rune_of_damnation_countdown_desc = "为受到咒罚符文影响的玩家倒计时。"
	L.jump = "跳入"

	L.relentless_domination = "统御"
	L.chains_of_oppression = "压迫之链"
	L.unholy_attunement = "晶塔"
	L.shattering_blast = "坦克炸弹"
	L.rune_of_compulsion = "心控"
	--L.desolation = "Azeroth Soak"
	L.chains_of_anguish = "痛苦之链"
	L.chain = "锁链"
	L.chain_target = "锁链 %s!"
	L.chains_remaining = "%d/%d 锁链碎裂"
	L.rune_of_domination = "团队分摊"

	--L.final = "Final %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "艾泽拉斯血量"
	L.azeroth_health_desc = "艾泽拉斯血量警告"

	L.azeroth_new_health_plus = "艾泽拉斯: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "艾泽拉斯: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "第一阶段输血计时条"
	L.mythic_blood_soak_stage_2 = "第二阶段输血计时条"
	L.mythic_blood_soak_stage_3 = "第三阶段输血计时条"
	-- L.mythic_blood_soak_stage_1_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill"
	L.mythic_blood_soak_bar = "治疗艾泽拉斯"

	L.floors_open = "地板开启"
	-- L.floors_open_desc = "Time until the floors opens up and you can fall into opened holes."

	L.mythic_dispel_stage_4 = "驱散计时条"
	-- L.mythic_dispel_stage_4_desc = "Timers for when to do dispels in the last stage, used by Echo on their first kill"
	L.mythic_dispel_bar = "驱散"
end
