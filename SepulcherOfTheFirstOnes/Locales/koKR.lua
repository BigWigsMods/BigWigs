local L = BigWigs:NewBossLocale("Artificer Xy'mox v2", "koKR")
if not L then return end
if L then
	 L.traps = "덫" -- Stasis Trap
	 L.sparknova = "초광속 불꽃 회오리" -- Hyperlight Sparknova
	 L.relocation = "탱 폭탄" -- Glyph of Relocation
	 L.wormholes = "차원 균열" -- Interdimensional Wormholes
	 L.wormhole = "차원 균열" -- Interdimensional Wormhole
	 L.rings = "%d 페이즈 고리" -- Forerunner Rings // Added P1, P2, P3 etc to help identify what rings
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
	 L.protoform_cascade = "전방 조심"
	 L.cosmic_shift = "넉백"
	 L.unstable_mote = "티끌"
	 L.mote = "티끌"

	 L.custom_on_nameplate_fixate = "시선고정 네임플레이트 아이콘"
	 L.custom_on_nameplate_fixate_desc = "본인에게 시선고정된 수집 자동기계의 네임플레이트에 아이콘을 표시합니다.\n\n적 네임플레이트 활성화 및 지원하는 네임플레이트 애드온이 필요함(KuiNameplates, Plater)."
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
	 L.beacon_of_hope = "봉화"
end

L = BigWigs:NewBossLocale("Skolex, the Insatiable Ravener", "koKR")
if L then
	 L.tank_combo_desc = "기력 100일때 균열 아귀/난도질 타이머."
end
