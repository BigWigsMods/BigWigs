local L = BigWigs:NewBossLocale("Vigilant Guardian", "koKR")
if not L then return end
if L then
	L.sentry = "탱 쫄"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "koKR")
if L then
	--L.custom_on_stop_timers = "Always show ability bars"
	--L.custom_on_stop_timers_desc = "Skolex can delay its abilities. When this option is enabled, the bars for those abilities will stay on your screen."

	L.tank_combo_desc = "기력 100일때 균열 아귀/난도질 타이머."
end

L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "koKR")
if L then
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
	L.obliteration_arc = "절멸" -- Obliteration Arc

	L.disintergration_halo = "후광" -- Disintegration Halo
	L.rings_x = "후광 x%d"
	L.rings_enrage = "후광 (광폭)"
	L.ring_count = "후광 (%d/%d)"

	L.custom_on_ring_timers = "개별 후광 타이머"
	L.custom_on_ring_timers_desc = "분해의 후광은 고리를 한 세트로 생성합니다. 이 옵션은 각각 고리가 언제 퍼지기 시작하는지 보여줍니다. 분해의 후광의 설정을 사용함."
end

L = BigWigs:NewBossLocale("Prototype Pantheon", "koKR")
if L then
	L.necrotic_ritual = "괴저 의식"
	L.runecarvers_deathtouch = "죽음의 손길"
	L.windswept_wings = "바람"
	L.wild_stampede = "쇄도"
	L.withering_seeds = "씨앗"
	L.hand_of_destruction = "파괴의 손"
	--L.nighthunter_marks_additional_desc = "|cFFFF0000Marking with a priority for melee on the first markers and using their raid group position as secondary priority.|r"
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

	L.harmonic = "밀기"
	L.melodic = "당기기"
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
	L.ephemeral_fissure = "균열"

	L.bomb_dropped = "폭탄 떨어트림"

	L.custom_on_stop_timers = "항상 능력 바 표시"
	L.custom_on_stop_timers_desc = "할론드루스의 기술들은 미뤄질수 있습니다. 이 옵션을 활성화하면, 미뤄진 능력들의 바가 화면에 남아있습니다."
end

L = BigWigs:NewBossLocale("Lords of Dread", "koKR")
if L then
	L.unto_darkness = "광역기 페이즈"
	L.cloud_of_carrion = "부패의 구름"
	L.empowered_cloud_of_carrion = "아픈 부패의 구름" -- Empowered Cloud of Carrion
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

	L.final = "이번 페이즈 마지막 %s" -- Final Unholy Attunement/Domination (last spell of a stage)

	L.azeroth_health = "아제로스 체력"
	L.azeroth_health_desc = "아제로스 체력 경고"

	L.azeroth_new_health_plus = "아제로스 체력: +%.1f%% (%d)"
	L.azeroth_new_health_minus = "아제로스 체력: -%.1f%%  (%d)"

	L.mythic_blood_soak_stage_1 = "1페이즈 피 흡수 타이밍"
	L.mythic_blood_soak_stage_2 = "2페이즈 피 흡수 타이밍"
	L.mythic_blood_soak_stage_3 = "3페이즈 피 흡수 타이밍"
	L.mythic_blood_soak_stage_1_desc = "아제로스를 힐할수 있는 좋은 타이밍이 언제인지 보이기. 에코가 첫킬 당시 사용."
	L.mythic_blood_soak_bar = "아제로스 힐"

	L.floors_open = "바닥 열림"
	L.floors_open_desc = "떨어질 수 있게 바닥이 다시 열리기까지의 시간."

	L.mythic_dispel_stage_4 = "해제 타이머"
	L.mythic_dispel_stage_4_desc = "마지막 페이즈에 해제 타이밍- 에코가 첫킬 당시 사용."
	L.mythic_dispel_bar = "해제"
end
