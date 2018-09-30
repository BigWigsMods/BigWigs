local L = BigWigs:NewBossLocale("MOTHER", "koKR")
if not L then return end
if L then
	L.sideLaser = "(측면) 레이저" -- short for: (location) Uldir Defensive Beam
	L.upLaser = "(천장) 레이저"
	L.mythic_beams = "레이저"
end

L = BigWigs:NewBossLocale("Zek'voz, Herald of N'zoth", "koKR")
if L then
	L.surging_darkness_eruption = "어둠 폭발 (%d)"
	L.mythic_adds = "신화 쫄 생성"
	L.mythic_adds_desc = "신화 쫄 생성 타이머 표시(실리시드 전사와 네루비안 공허술사가 동시에 나올 때)."
end

L = BigWigs:NewBossLocale("Zul", "koKR")
if L then
	L.crawg_msg = "크로그" -- Short for '피에 굶지린 크로그'
	L.crawg_desc = "크로그 생성 타이머 및 경고 표시."

	L.bloodhexer_msg = "혈사술사" -- Short for '나즈마니 혈사술사'
	L.bloodhexer_desc = "혈사술사 생성 타이머 및 경고 표시."

	L.crusher_msg = "분쇄자" -- Short for '나즈마니 분쇄자'
	L.crusher_desc = "분쇄자 생성 타이머 및 경고 표시."

	L.custom_off_decaying_flesh_marker = "부패하는 육신 표시기"
	L.custom_off_decaying_flesh_marker_desc = "부패하는 육신 걸린 적 병력 {rt8}로 표시, 부공격대장이나 공격대장 권한 필요."
end

L = BigWigs:NewBossLocale("Mythrax the Unraveler", "koKR")
if L then
	L.destroyer_cast = "%s (느라퀴 파괴자)" -- npc id: 139381
	L.xalzaix_returned = "잘자익스의 각성!" -- npc id: 138324
	L.add_blast = "쫄 광선"
	L.boss_blast = "넴드 광선"
end

L = BigWigs:NewBossLocale("G'huun", "koKR")
if L then
	L.orbs_deposited = "구슬 반납 (%d/3) - %.1f 초"
	L.orb_spawning = "구슬 생성"
	L.orb_spawning_side = "구슬 생성 (%s)"
	L.left = "왼쪽"
	L.right = "오른쪽"

	--L.custom_on_fixate_plates = "Fixate icon on Enemy Nameplate"
	--L.custom_on_fixate_plates_desc = "Show an icon on the target nameplate that is fixating on you.\nRequires the use of Enemy Nameplates. This feature is currently only supported by KuiNameplates."
end
