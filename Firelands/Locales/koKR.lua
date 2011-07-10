local L = BigWigs:NewBossLocale("Beth'tilac", "koKR")
if not L then return end
if L then
	L.devastate_message = "그을리는 유린 #%d!"
	L.devastate_bar = "~다음 그을리는 유린"
	L.drone_bar = "다음 잿그물 수거미"
	L.drone_message = "곧 잿그물 수거미!"
	L.kiss_message = "입맞춤"
end

L = BigWigs:NewBossLocale("Lord Rhyolith", "koKR")
if L then
	L.molten_message = "보스 공격 증가 x%d !"
	L.armor_message = "흑요석 갑옷 - %d%%"
	L.armor_gone_message = "흑요석 갑옷 사라짐!"
	L.phase2_soon_message = "곧 2 단계!"
	L.stomp_message = "진탕 발길! 발구르기! 발구르기!"
	L.stomp_warning = "Next Stomp"
	L.big_add_message = "큰 쫄 등장!"
	L.small_adds_message = "곧 작은 쫄 등장!"
end

L = BigWigs:NewBossLocale("Alysrazor", "koKR")
if L then
	L.tornado_trigger = "이 하늘은 나의 것이다!"
	L.claw_message = "타오르는 발톱 x%2$d : %1$s"
	L.fullpower_soon_message = "곧 최대 힘!"
	L.halfpower_soon_message = "곧 4 단계!"
	L.encounter_restart = "최대 힘! 다시 단계 반복..."
	L.no_stacks_message = "당신은 깃털이 없습니다. 생각을 가지세요..."
	L.moonkin_message = "헛짓은 그만~! 깃털을 주우세요!"

	L.worm_emote = "녹아내린 알이 부화하려고 합니다!"
	L.phase2_soon_emote = "알리스라조르가 빠른 속도로 원을 그리며 날아다닙니다!"
	L.phase2_emote = "99794" -- Fiery Vortex spell ID used in the emote
	L.phase3_emote = "99432" -- Burns Out spell ID used in the emote
	L.phase4_emote = "99922" -- Re-Ignites spell ID used in the emote
	L.restart_emote = "99925" -- Full Power spell ID used in the emote
end

L = BigWigs:NewBossLocale("Shannox", "koKR")
if L then
	L.safe = "%s 안전함"
	L.immolation_trap = "얼굴 강타 : %s!"
	L.crystaltrap = "수정 감옥 덫"
end

L = BigWigs:NewBossLocale("Baleroc", "koKR")
if L then
	L.torment_message = "고통 x%2$d : %1$s"
	L.blade = "~칼날"
	L.shard_message = "곧 고문의 파편!"
	L.focus_message = "당신의 주시 대상 - 고문 x%d !"
	L.countdown_bar = "다음 고리"
	L.link_message = "고리 연결"
end

L = BigWigs:NewBossLocale("Majordomo Staghelm", "koKR")
if L then
	L.seed_explosion = "곧 씨앗 폭발!"
	L.seed_bar = "당신은 폭발!"
	L.adrenaline_message = "아드레날린 x%d!"
end

L = BigWigs:NewBossLocale("Ragnaros", "koKR")
if L then
	L.seed_explosion = "씨앗 폭발!"
	L.intermission = "휴식"
	L.sons_left = "자손 %d 마리 남음"
	L.engulfing_close = "가까운 지역에 %s"
	L.engulfing_middle = "중간 지역에 %s"
	L.engulfing_far = "먼 지역에 %s"
end

