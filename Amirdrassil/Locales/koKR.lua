local L = BigWigs:NewBossLocale("Gnarlroot", "koKR")
if not L then return end
if L then
	L.tortured_scream = "비명"
end

L = BigWigs:NewBossLocale("Igira the Cruel", "koKR")
if L then
	L.blistering_spear = "창"
	L.blistering_spear_single = "창"
	L.blistering_torment = "사슬"
	L.twisting_blade = "칼날"
	L.marked_for_torment = "고문"
end

L = BigWigs:NewBossLocale("Volcoross", "koKR")
if L then
	L.custom_off_all_scorchtail_crash = "모든 시전 보이기"
	L.custom_off_all_scorchtail_crash_desc = "당신의 방향만이 아닌 모든 방향에서의 불꽃꼬리 충돌의 타이머와 메시지를 표시합니다."

	L.flood_of_the_firelands_single_wait = "대기" -- Wait 3, Wait 2, Wait 1 countdown before soak debuff is applied
	L.scorchtail_crash = "꼬리치기"
	L.serpents_fury = "불꽃"
	L.coiling_flames_single = "불꽃"
end

L = BigWigs:NewBossLocale("Council of Dreams", "koKR")
if L then
	L.agonizing_claws_debuff = "{421022} (디버프)"

	L.custom_off_combined_full_energy = "전체 기력 바 결합 (신화 난이도 전용)"
	L.custom_off_combined_full_energy_desc = "우두머리가 최대 기력으로 사용하는 능력을 동시에 시전하는 경우에만 하나의 막대로 결합합니다."

	L.special_mechanic_bar = "%s [궁극기] (%d)"

	L.constricting_thicket = "덤불"
	L.poisonous_javelin = "투창"
	L.song_of_the_dragon = "노래"
	L.polymorph_bomb = "오리"
	L.polymorph_bomb_single = "오리"
end

L = BigWigs:NewBossLocale("Larodar, Keeper of the Flame", "koKR")
if L then
	L.custom_on_repeating_yell_smoldering_suffocation = "질식 시 체력 상황 외치기 반복"
	L.custom_on_repeating_yell_smoldering_suffocation_desc = "이글거리는 질식으로 당신의 체력이 75% 밑으로 떨어질 경우, 외치기를 반복합니다."

	L.blazing_coalescence_on_player_note = "당신이 먹었을 때"
	L.blazing_coalescence_on_boss_note = "우두머리가 먹었을 때"

	L.scorching_roots = "뿌리"
	L.charred_brambles = "치유 가능한 뿌리"
	L.blazing_thorns = "이글거리는 가시" -- Spiral of Thorns
end

L = BigWigs:NewBossLocale("Nymue, Weaver of the Cycle", "koKR")
if L then
	L.mythic_add_death = "% 죽음"

	L.continuum = "선 새로 생김"
	L.surging_growth = "새로운 바닥 밟기"
	L.ephemeral_flora = "빨간 바닥 밟기"
	L.viridian_rain = "데미지 + 폭탄"
	L.threads = "베틀" -- From the spell description of Impending Loom (429615) "threads of energy"
end

L = BigWigs:NewBossLocale("Smolderon", "koKR")
if L then
	L.brand_of_damnation = "탱커랑 같이맞기"
	L.lava_geysers = "용암 분출"
end

L = BigWigs:NewBossLocale("Tindral Sageswift, Seer of the Flame", "koKR")
if L then
	L.seed_soaked = "씨앗 밟기"
	L.all_seeds_soaked = "씨앗 완료!"

	L.blazing_mushroom = "버섯"
	L.fiery_growth = "해제"
	L.mass_entanglement = "휘감기"
	L.incarnation_moonkin = "달빛야수 형태"
	L.incarnation_tree_of_flame = "나무 형태"
	L.flaming_germination = "씨앗"
	L.flare_bomb = "깃털"
	L.too_close_to_edge = "가장자리에 너무 가까움"
	L.taking_damage_from_edge = "가장자리에서 피해를 입음"
	L.flying_available = "비행 가능"

	L.fly_time = "비행 시간"
	L.fly_time_desc = "사잇단계 동안 다른 단상으로 이동하는 데 걸린 시간을 보여줍니다."
	L.fly_time_msg = "비행 시간: %.2f" -- Fly Time: 32.23
end

L = BigWigs:NewBossLocale("Fyrakk the Blazing", "koKR")
if L then
	L.spirits_trigger = "칼도레이의 영혼"

	L.fyralaths_bite = "정면"
	L.fyralaths_bite_mythic = "정면"
	L.darkflame_shades = "망령"
	L.darkflame_cleave = "같이 맞기"

	L.incarnate_intermission = "공중에 뜸" -- 현신

	L.incarnate = "현신"
	L.molten_gauntlet = "시련" -- 타오르는 시련
	L.mythic_debuffs = "우리" -- Shadow Cage & Molten Eruption

	L.greater_firestorm_shortened_bar = "상급 화염폭풍" -- G for Greater
	L.greater_firestorm_message_full = "상급 화염폭풍"
	L.eternal_firestorm_shortened_bar = "영원한 화염폭풍" -- E for Eternal
	L.eternal_firestorm_message_full = "영원한 화염폭풍"

	--L.eternal_firestorm_swirl = "Eternal Firestorm Pools"
	--L.eternal_firestorm_swirl_desc = "Show timers for when the Eternal Firestorm will spawn the pools that you need to avoid standing in."

	--L.flame_orb = "Flame Orb"
	--L.shadow_orb = "Shadow Orb"
	--L.orb_message_flame = "You are Flame"
	--L.orb_message_shadow = "You are Shadow"
end
