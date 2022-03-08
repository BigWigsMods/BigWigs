local L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "zhTW")
if not L then return end
if L then
	L.traps = "陷阱" -- Stasis Trap
	L.sparknova = "火花新星" -- Hyperlight Sparknova
	L.relocation = "坦克炸彈" -- Glyph of Relocation
	L.wormholes = "蟲洞" -- Interdimensional Wormholes
	L.wormhole = "蟲洞" -- Interdimensional Wormhole
	L.rings = "第 %d 道環" -- Forerunner Rings // Added P1, P2, P3 etc to help identify what rings
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "zhTW")
if L then
	L.staggering_barrage = "彈幕" -- Staggering Barrage
	L.domination_core = "小怪" -- Domination Core
	-- L.obliteration_arc = "Arc" -- Obliteration Arc

	L.disintergration_halo = "輝環" -- Disintegration Halo
	-- L.rings_x = "Rings x%d"
	L.rings_enrage = "輝環（軟狂暴）"
	L.ring_count = "輝環（%d/%d）"

	L.shield_removed = "%s 移除，用時 %.1f 秒" -- "Shield removed after 1.1s" s = seconds
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "zhTW")
if L then
	L.necrotic_ritual = "死靈儀式"
	L.runecarvers_deathtouch = "死亡之觸"
	L.windswept_wings = "疾風"
	L.wild_stampede = "奔竄"
	L.withering_seeds = "種子"
	L.hand_of_destruction = "群拉" -- 毀滅之手群拉
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "zhTW")
if L then
	-- L.protoform_cascade = "Frontal"
	L.cosmic_shift = "擊退"
	L.unstable_mote = "微粒"
	L.mote = "微粒"

	L.custom_on_nameplate_fixate = "鎖定名條圖示"
	-- L.custom_on_nameplate_fixate_desc = "Show an icon on the nameplate on Acquisitions Automa that are fixed on you.\n\n需要開啟敵方名條，並使用支援此功能的名條插件（如KuiNameplates, Plater）"。"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "zhTW")
if L then
	-- L.custom_off_repeating_blasphemy = "Repeating Blasphemy"
	-- L.custom_off_repeating_blasphemy_desc = "Repeating Blasphemy say messages with icons {rt1}, {rt3} to find matches to remove your debuffs."

	L.kingsmourne_hungers = "王之哀傷"
	L.blasphemy = "印記"
	L.befouled_barrier = "屏障"
	L.wicked_star = "星星"
	L.domination_word_pain = "御言術痛"
	L.army_of_the_dead = "大軍"
	L.grim_reflections = "幻影"
	L.march_of_the_damned = "影牆"
	L.dire_blasphemy = "印記"
	L.beacon_of_hope = "信標"

	-- L.remnant_active = "Remnant Active"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "zhTW")
if L then
	L.tank_combo_desc = "達到 100 能量時，為撕裂與裂喉顯示施放計時條。"
end
