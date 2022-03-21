local L = BigWigs:NewBossLocale("Vigilant Guardian", "koKR")
if not L then return end
if L then
	-- L.sentry = "Tank Add"
	-- L.materium = "Small Adds"
	-- L.shield = "Shield" -- Global locale canidate?
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "koKR")
if L then
	 L.tank_combo_desc = "기력 100일때 균열 아귀/난도질 타이머."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "koKR")
if L then
	L.traps = "덫" -- Stasis Trap
	L.sparknova = "초광속 불꽃 회오리" -- Hyperlight Sparknova
	L.relocation = "탱 폭탄" -- Glyph of Relocation
	--L.relocation_count = "%s S%d (%d)" -- Tank Bomb S1 (1) // Tank Bomb (stage)(count)
	L.wormholes = "차원 균열" -- Interdimensional Wormholes
	L.wormhole = "차원 균열" -- Interdimensional Wormhole
	L.rings = "%d 페이즈 고리" -- Rings S1 // Forerunner Rings Stage 1/2/3/4
end

L = BigWigs:NewBossLocale("Dausegne, the Fallen Oracle", "koKR")
if L then
	L.staggering_barrage = "탄막" -- Staggering Barrage
	L.domination_core = "쫄" -- Domination Core
	L.obliteration_arc = "절멸" -- Obliteration Arc

	L.disintergration_halo = "후광" -- Disintegration Halo
	L.rings_x = "후광 x%d"
	L.rings_enrage = "후광 (광폭)"
	L.ring_count = "후광 (%d/%d)"

	--L.custom_on_ring_timers = "Individual Halo Timers"
	--L.custom_on_ring_timers_desc = "Disintegration Halo triggers a set of rings, this will show bars for when each of the rings starts moving. Uses settings from Disintegration Halo."

	L.shield_removed = "%s %.1f초 후 제거됨" -- "Shield removed after 1.1s" s = seconds
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "koKR")
if L then
	L.necrotic_ritual = "괴저 의식"
	L.runecarvers_deathtouch = "죽음의 손길"
	L.windswept_wings = "바람"
	L.wild_stampede = "쇄도"
	L.withering_seeds = "씨앗"
	L.hand_of_destruction = "파괴의 손"
end

L = BigWigs:NewBossLocale("Lihuvim, Principal Architect", "koKR")
if L then
	L.protoform_cascade = "구슬 조심"
	L.cosmic_shift = "넉백"
	--L.cosmic_shift_mythic = "Shift: %s"
	L.unstable_mote = "불안정한 티끌"
	L.mote = "티끌"

	L.custom_on_nameplate_fixate = "시선고정 네임플레이트 아이콘"
	L.custom_on_nameplate_fixate_desc = "본인에게 시선고정된 수집 자동기계의 네임플레이트에 아이콘을 표시합니다.\n\n적 네임플레이트 활성화 및 지원하는 네임플레이트 애드온이 필요함(KuiNameplates, Plater)."

	--L.harmonic = "Push"
	--L.melodic = "Pull"
end

L = BigWigs:NewBossLocale("Anduin Wrynn", "koKR")
if L then
	L.custom_off_repeating_blasphemy = "신성 모독 계속 알림"
	L.custom_off_repeating_blasphemy_desc = "신성 모독 걸렸을 때 자동으로 {rt1}, {rt3} 를 표시해서 짝을 찾아 디버프 없애기."

	L.kingsmourne_hungers = "사자한"
	L.blasphemy = "징표"
	L.befouled_barrier = "치유량 흡수 방벽"
	L.wicked_star = "부메랑"
	L.domination_word_pain = "고통"
	L.army_of_the_dead = "사군"
	L.grim_reflections = "공포 쫄"
	L.march_of_the_damned = "행진"
	L.dire_blasphemy = "징표"

	--L.remnant_active = "Remnant Active"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "koKR")
if L then
	--L.seismic_tremors = "Motes + Tremors"
	--L.earthbreaker_missiles = "Missiles"
	--L.crushing_prism = "Prisms"
	--L.prism = "Prism"

	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Halondrus can delay its abilities. When this option is enabled, the bars for those abilities will stay on your screen."
end

L = BigWigs:NewBossLocale("Lords of Dread", "koKR")
if L then
	--L.unto_darkness = "AoE Phase"
	--L.cloud_of_carrion = "Carrion"
	--L.manifest_shadows = "Adds"
	--L.leeching_claws = "Frontal (M)"
	--L.infiltration_of_dread = "Among Us"
	--L.fearful_trepidation = "Fears"
	--L.slumber_cloud = "Clouds"
	--L.anguishing_strike = "Frontal (K)"
end

L = BigWigs:NewBossLocale("Rygelon", "koKR")
if L then
	--L.celestial_collapse = "Quasars"
	--L.manifest_cosmos = "Cores"
	--L.stellar_shroud = "Heal Absorb"
end

L = BigWigs:NewBossLocale("The Jailer", "koKR")
if L then
	--L.rune_of_damnation_countdown = "Countdown"
	--L.rune_of_damnation_countdown_desc = "Countdown for the players who are affected by Rune of Damnation"
	--L.jump = "Jump In"

	--L.chain = "Chain"
	--L.rune = "Rune"

	--L.chain_target = "Chaining %s!"
	--L.chains_remaining = "%d/%d Chains Broken"

	--L.chains_of_oppression = "Pull Chains"
	--L.unholy_attunement = "Pylons"
	--L.chains_of_anguish = "Spread Chains"
	--L.rune_of_compulsion = "Charms"
	--L.rune_of_domination = "Group Soaks"
end
