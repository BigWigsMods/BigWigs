local L = BigWigs:NewBossLocale("Vigilant Guardian", "koKR")
if not L then return end
if L then
	 L.sentry = "탱 쫄"
	 L.materium = "작은 쫄"
	 L.shield = "역장" -- Global locale canidate?
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
	L.cosmic_shift_mythic = "넉백: %s"
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

	L.remnant_active = "잔재 활성화"
end

L = BigWigs:NewBossLocale("Halondrus the Reclaimer", "koKR")
if L then
	L.seismic_tremors = "지진 진동 + 티끌 생성"
	L.earthbreaker_missiles = "투사체"
	L.crushing_prism = "분광경"
	L.prism = "분광경"

	 L.bomb_dropped = "폭탄 떨어트림"

	L.custom_on_stop_timers = "항상 능력 바 표시"
	L.custom_on_stop_timers_desc = "할론드루스의 기술들은 미뤄질수 있습니다. 이 옵션을 활성화하면, 미뤄진 능력들의 바가 화면에 남아있습니다."
end

L = BigWigs:NewBossLocale("Lords of Dread", "koKR")
if L then
	L.unto_darkness = "광역기 페이즈"
	L.cloud_of_carrion = "부패의 구름"
	L.empowered_cloud_of_carrion = "아픈 부패의 구름" -- Empowered Cloud of Carrion
	L.manifest_shadows = "쫄"
	L.leeching_claws = "전방기 (말가)"
	L.infiltration_of_dread = "어몽어스"
	L.infiltration_removed = " %.1f초만에 임포스터 컷!" -- "Imposters found in 1.1s" s = seconds
	L.fearful_trepidation = "공포"
	L.slumber_cloud = "수면 구름"
	L.anguishing_strike = "전방기 (킨테사)"

	--L.custom_on_repeating_biting_wound = "Repeating Biting Wound"
	--L.custom_on_repeating_biting_wound_desc = "Repeating Biting Wound say messages with icons {rt7} to make it more visible."
end

L = BigWigs:NewBossLocale("Rygelon", "koKR")
if L then
	L.celestial_collapse = "준항성"
	L.manifest_cosmos = "핵"
	L.stellar_shroud = "치유량 흡수"
	L.knock = "주변 넉백" -- Countdown knockbacking other players nearby. Knock 3, Knock 2, Knock 1
end

L = BigWigs:NewBossLocale("The Jailer", "koKR")
if L then
	L.rune_of_damnation_countdown = "초읽기"
	L.rune_of_damnation_countdown_desc = "저주의 룬에 걸린사람들을 위한 초읽기"
	L.jump = "뛰엇!"

	--L.relentless_domination = "Domination"
	L.chains_of_oppression = "고핀 사슬"
	L.unholy_attunement = "수정탑"
	--L.shattering_blast = "Tank Blast"
	L.rune_of_compulsion = "정배 룬"
	--L.desolation = "Azeroth Soak"
	L.chains_of_anguish = "산개 사슬"
	L.chain = "사슬"
	L.chain_target = " %s 에게 사슬!"
	L.chains_remaining = "%d/%d 사슬 파괴 완료"
	L.rune_of_domination = "같이 맞아주기"

	--L.final = "Final %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	-- L.azeroth_health = "Azeroth Health"
	-- L.azeroth_health_desc = "Azeroth Health Warnings"

	-- L.azeroth_new_health_plus = "Azeroth Health: +%.1f%% (%d)"
	-- L.azeroth_new_health_minus = "Azeroth Health: -%.1f%%  (%d)"

	-- L.mythic_blood_soak_stage_1 = "Stage 1 Blood Soak timings"
	-- L.mythic_blood_soak_stage_2 = "Stage 2 Blood Soak timings"
	-- L.mythic_blood_soak_stage_3 = "Stage 3 Blood Soak timings"
	-- L.mythic_blood_soak_stage_1_desc = "Show a bar for timings when healing azeroth is at a good time, used by Echo on their first kill"
	-- L.mythic_blood_soak_bar = "Heal Azeroth"

	-- L.floors_open = "Floors Open"
	-- L.floors_open_desc = "Time until the floors opens up and you can fall into opened holes."

	-- L.mythic_dispel_stage_4 = "Dispel Timers"
	-- L.mythic_dispel_stage_4_desc = "Timers for when to do dispels in the last stage, used by Echo on their first kill"
	-- L.mythic_dispel_bar = "Dispels"
end
