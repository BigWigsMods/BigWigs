
local L = BigWigs:NewBossLocale("Algalon the Observer", "koKR")
if L then
	L.phase = "단계"
	L.phase_desc = "단계 변경을 알립니다."
	L.engage_warning = "1 단계"
	L.phase2_warning = "곧 2단계"
	L.phase_bar = "%d 단계"
	L.engage_trigger = "^너희 행동은 비논리적이다."

	L.punch_message = "위상의 주먹 %2$dx : %1$s"
	L.smash_message = "곧 우주의 강타!"
	L.blackhole_message = "검은 구멍 폭발 %dx 소환"
	L.bigbang_bar = "다음 대폭발"
	L.bigbang_soon = "곧 대폭발!"

	L.end_trigger = "나는 창조주의 불길이 씻어내린 세상을 보았다."
end

L = BigWigs:NewBossLocale("Auriaya", "koKR")
if L then
	L.engage_trigger = "내버려두는 편이 나았을 텐데!"

	L.fear_warning = "곧 공포!"
	L.fear_message = "공포 시전!"
	L.fear_bar = "~공포 대기시간"

	L.swarm_message = "수호자의 무리"
	L.swarm_bar = "~무리 대기시간"

	L.defender = "수호 야수"
	L.defender_desc = "수호 야수의 남은 생명 횟수를 알립니다."
	L.defender_message = "수호 야수 (생명: %d/9)!"

	L.sonic_bar = "~음파 대기시간"
end

L = BigWigs:NewBossLocale("Freya", "koKR")
if L then
	L.engage_trigger1 = "어떻게 해서든 정원을 수호해야 한다!"
	L.engage_trigger2 = "장로여, 내게 힘을 나눠다오!"

	L.phase = "단계"
	L.phase_desc = "단계 변화를 알립니다."
	L.phase2_message = "2 단계 !"

	L.wave = "웨이브"
	L.wave_desc = "웨이브에 대해 알립니다."
	L.wave_bar = "다음 웨이브"
	L.conservator_trigger = "이오나여, 당신의 종이 도움을 청합니다!"
	L.detonate_trigger = "정령의 무리가 너희를 덮치리라!"
	L.elementals_trigger = "얘들아, 날 도와라!"
	L.tree_trigger = "|cFF00FFFF생명의 어머니의 선물|r이 자라기 시작합니다!"
	L.conservator_message = "수호자 소환"
	L.detonate_message = "폭발 덩굴손 소환"
	L.elementals_message = "정령 3 소환"

	L.tree = "이오나의 선물"
	L.tree_desc = "프레이야의 이오나의 선물 소환을 알립니다."
	L.tree_message = "이오나의 선물 소환"

	L.fury_message = "격노"
	L.fury_other = "자연의 격노: %s!"

	L.tremor_warning = "곧 지진!"
	L.tremor_bar = "~다음 지진"
	L.energy_message = "당신은 불안정한 힘!"
	L.sunbeam_message = "태양 광선!"
	L.sunbeam_bar = "~다음 태양 광선"

	L.end_trigger = "내게서 그의 지배력이 걷혔다. 다시 온전한 정신을 찾았도다. 영웅들이여, 고맙다."
end

L = BigWigs:NewBossLocale("Hodir", "koKR")
if L then
	L.engage_trigger = "침입자는 쓴맛을 보게 될 게다!"

	L.cold = "매서운 추위(업적)"
	L.cold_desc = "매서운 추위 2중첩이상을 알립니다."
	L.cold_message = "매서운 추위 x%d - 이동!"

	L.flash_warning = "순간 빙결 시전!"
	L.flash_soon = "5초 후 순간 빙결"

	L.hardmode = "도전 모드 시간"
	L.hardmode_desc = "도전 모드의 시간을 표시합니다."

	L.end_trigger = "드디어... 드디어 그의 손아귀를... 벗어나는구나."
end

L = BigWigs:NewBossLocale("Ignis the Furnace Master", "koKR")
if L then
	L.engage_trigger = "건방진 젖먹이들이! 세상을 되찾는 데 쓸 무기를 네놈들의 피로 담금질하겠다!"	--check

	L.construct_message = "피조물 활성화!"
	L.construct_bar = "다음 피조물"
	L.brittle_message = "피조물 부서지는 몸!"
	L.flame_bar = "~분출 대기시간"
	L.scorch_message = "당신은 불태우기!"
	L.scorch_soon = "약 5초 후 불태우기!"
	L.scorch_bar = "다음 불태우기"
	L.slagpot_message = "용암재 단지: %s"
end

L = BigWigs:NewBossLocale("The Iron Council", "koKR")
if L then
	L.engage_trigger1 = "무쇠 평의회가 그리 쉽게 무너질 것 같으냐, 침입자들아!"
	L.engage_trigger2 = "남김없이 쓸어버려야 속이 시원하겠군."
	L.engage_trigger3 = "세상에서 가장 큰 모기건 세상에서 가장 위대한 영웅이건, 너흰 어차피 필멸의 존재야."

	L.overload_message = "6초 후 과부하!"
	L.death_message = "당신은 죽음의 룬!"
	L.summoning_message = "소환의 룬 - 곧 정령 등장!"

	L.chased_other = "%s 추적 중!"
	L.chased_you = "당신을 추적 중!"

	L.overwhelm_other = "압도적인 힘: %s"

	L.shield_message = "룬의 보호막!"

	L.council_dies = "%s 죽음"
end

L = BigWigs:NewBossLocale("Kologarn", "koKR")
if L then
	L.arm = "팔 죽음"
	L.arm_desc = "왼팔 & 오른팔의 죽음을 알립니다."
	L.left_dies = "왼팔 죽음"
	L.right_dies = "오른팔 죽음"
	L.left_wipe_bar = "왼팔 재생성"
	L.right_wipe_bar = "오른팔 재생성"

	L.shockwave = "충격파"
	L.shockwave_desc = "다음 충격파에 대하여 알립니다."
	L.shockwave_trigger = "망각!"

	L.eyebeam = "안광 집중"
	L.eyebeam_desc = "안광 집중의 대상이된 플레이어를 알립니다."
	L.eyebeam_trigger = "콜로간이 당신에게 안광을 집중합니다!"
	L.eyebeam_message = "안광 집중: %s"
	L.eyebeam_bar = "~안광 집중"
	L.eyebeam_you = "당신에게 안광 집중!"
	L.eyebeam_say = "저 안광 집중요!"

	L.eyebeamsay = "안광 일반 대화"
	L.eyebeamsay_desc = "안광 집중의 대상시 일반 대화로 알립니다."

	L.armor_message = "방어구 씹기 x%2$d: %1$s"
end

L = BigWigs:NewBossLocale("Flame Leviathan", "koKR")
if L then
	L.engage_trigger = "^적대적인 존재 감지."
	L.engage_message = "%s 전투 시작!"

	L.pursue = "추격"
	L.pursue_desc = "플레이어에게 거대 화염전차의 추적을 알립니다."
	L.pursue_trigger = "([^%s]+)|1을;를; 쫓습니다.$"
	L.pursue_other = "%s 추격!"

	L.shutdown_message = "시스템 작동 정지!"
end

L = BigWigs:NewBossLocale("Mimiron", "koKR")
if L then
	L.phase = "단계"
	L.phase_desc = "단계 변화를 알립니다."
	L.engage_warning = "1 단계"
	L.engage_trigger = "^시간이 없어, 친구들!"
	L.phase2_warning = "곧 2 단계"
	L.phase2_trigger = "^멋지군!"
	L.phase3_warning = "곧 3 단계"
	L.phase3_trigger = "^고맙다, 친구들!"
	L.phase4_warning = "곧 4 단계"
	L.phase4_trigger = "^예비 시험은 이걸로 끝이다"
	L.phase_bar = "%d 단계"

	L.hardmode = "도전 모드 시간"
	L.hardmode_desc = "도전 모드의 시간을 표시합니다."
	L.hardmode_trigger = "^아니, 대체 왜 그런 짓을 한 게지?"
	L.hardmode_message = "도전 모드 활성화!"
	L.hardmode_warning = "폭발!"

	L.plasma_warning = "플라스마 폭발 시전!"
	L.plasma_soon = "곧 플라스마!"
	L.plasma_bar = "다음 플라스마"

	L.shock_next = "다음 충격파"

	L.laser_soon = "회전 가속!"
	L.laser_bar = "레이저 탄막"

	L.magnetic_message = "공중 지휘기! 극딜!"

	L.suppressant_warning = "곧 화염 억제!"

	L.fbomb_soon = "잠시후 서리 폭탄 가능!"
	L.fbomb_bar = "다음 서리 폭탄"

	L.bomb_message = "폭발로봇 소환!"

	L.end_trigger = "^내가 계산을 좀 잘못한 것 같군"
end

L = BigWigs:NewBossLocale("Razorscale", "koKR")
if L then
	L.phase = "단계"
	L.phase_desc = "칼날비늘의 단계 변경을 알립니다."
	L.ground_trigger = "움직이세요! 오래 붙잡아둘 순 없을 겁니다!"
	L.ground_message = "칼날비늘 묶임!"
	L.air_trigger = "저희에게 잠깐 포탑을 설치할 시간을 주세요."
	L.air_trigger2 = "불꽃이 꺼졌어요! 포탑을 재설치합시다!"
	L.air_message = "이륙!"
	L.phase2_trigger = "%s|1이;가; 완전히 땅에 내려앉았습니다!"
	L.phase2_message = "2 단계!"
	L.phase2_warning = "곧 2 단계!"
	L.stun_bar = "기절"

	L.breath_trigger = "%s|1이;가; 숨을 깊게 들이쉽니다."
	L.breath_message = "화염 숨결!"
	L.breath_bar = "~숨결 대기시간"

	L.flame_message = "당신은 파멸의 불길!"

	L.harpoon = "작살 포탑"
	L.harpoon_desc = "작살 포탑의 준비를 알립니다."
	L.harpoon_message = "작살 포탑 (%d)"
	L.harpoon_trigger = "작살 포탑이 준비되었습니다!"
	L.harpoon_nextbar = "다음 작살 (%d)"
end

L = BigWigs:NewBossLocale("Thorim", "koKR")
if L then
	L.phase = "단계"
	L.phase_desc = "단계 변화를 알립니다."
	L.phase1_message = "1 단계 시작"
	L.phase2_trigger = "침입자라니! 감히 내 취미 생활을 방해하는 놈들은 쓴맛을 단단히... 잠깐... 너는..."
	L.phase2_message = "2 단계 - 6분 15초 후 광폭화!"
	L.phase3_trigger = "건방진 젖먹이 같으니... 감히 여기까지 기어올라와 내게 도전해? 내 손으로 쓸어버리겠다!"
	L.phase3_message = "3 단계 - 토림 전투시작!"

	L.hardmode = "도전 모드 시간"
	L.hardmode_desc = "도전 모드의 시간을 표시합니다."
	L.hardmode_warning = "도전 모드 종료"

	L.shock_message = "당신은 번개 충격! 이동!"
	L.barrier_message = "거인 - 룬문자 방벽!"

	L.detonation_say = "저 폭탄이에요! 피하세요!"

	L.charge_message = "충전 (%d)!"
	L.charge_bar = "충전 (%d)"

	L.strike_bar = "혼란의 일격 대기시간"

	L.end_trigger = "무기를 거둬라! 내가 졌다!"
end

L = BigWigs:NewBossLocale("General Vezax", "koKR")
if L then
	L.engage_trigger = "^너희의 파멸은 새로운 고통의 시대를 열 것이다!"

	L.surge_message = "어둠 쇄도 (%d)!"
	L.surge_cast = "쇄도 시전 (%d)!"
	L.surge_bar = "쇄도 %d"

	L.animus = "사로나이트 원혼"
	L.animus_desc = "사로나이트 원혼 소환을 알립니다."
	L.animus_trigger = "사로나이트 증기가 한 덩어리가 되어 맹렬하게 소용돌이치며, 무시무시한 형상으로 변화합니다!"
	L.animus_message = "원혼 소환!"

	L.vapor = "사로나이트 증기"
	L.vapor_desc = "사로나이트 증기 소환을 알립니다."
	L.vapor_message = "사로나이트 증기 (%d)!"
	L.vapor_bar = "다음 증기 %d/6"
	L.vapor_trigger = "가까운 사로나이트 증기 구름이 합쳐집니다!"

	L.vaporstack = "증기 중첩"
	L.vaporstack_desc = "사로나이트 증기 5중첩이상을 알립니다."
	L.vaporstack_message = "증기 x%d 중첩!"

	L.crash_say = "저 어둠 붕괴요!"

	L.mark_message = "징표"
	L.mark_message_other = "얼굴 없는 자의 징표: %s"
end

L = BigWigs:NewBossLocale("XT-002 Deconstructor", "koKR")
if L then
	L.exposed_warning = "잠시 후 심장 노출!"
	L.exposed_message = "심장 노출 - 로봇들 추가!"

	L.gravitybomb_other = "중력 폭탄: %s!"

	L.lightbomb_other = "빛의 폭탄: %s!"

	L.tantrum_bar = "~땅울림 대기시간"
end

L = BigWigs:NewBossLocale("Yogg-Saron", "koKR")
if L then
	L["Crusher Tentacle"] = "분쇄의 촉수"
	L["The Observation Ring"] = "관찰 지구"

	L.phase = "단계"
	L.phase_desc = "단계 변화를 알립니다."
	L.engage_warning = "1 단계"
	L.engage_trigger = "^짐승의 대장을 칠 때가 곧 다가올 거예요"
	L.phase2_warning = "2 단계"
	L.phase2_trigger = "^나는, 살아 있는 꿈이다"
	L.phase3_warning = "3 단계"
	L.phase3_trigger = "^죽음의 진정한 얼굴을 보아라"

	L.portal = "차원문"
	L.portal_desc = "차원문을 알립니다."
	L.portal_trigger = "%s의 마음속으로 가는 차원문이 열립니다!"
	L.portal_message = "차원문 열림!"
	L.portal_bar = "다음 차원문"

	L.fervor_cast_message = "%s 에게 사라의 열정 시전!"
	L.fervor_message = "사라의 열정: %s!"

	L.sanity_message = "당신의 이성 위험!"

	L.weakened = "기절"
	L.weakened_desc = "기절 상태를 알립니다."
	L.weakened_message = "%s 기절!"
	L.weakened_trigger = "환상이 부서지며, 중앙에 있는 방으로 가는 길이 열립니다!"

	L.madness_warning = "5초 후 광기 유발!"
	L.malady_message = "병든 정신: %s"

	L.tentacle = "촉수 소환"
	L.tentacle_desc = "촉수 소환을 알립니다."
	L.tentacle_message ="분쇄의 촉수(%d)"

	L.link_warning = "당신은 두뇌의 고리!"

	L.gaze_bar = "~시선 대기시간"
	L.empower_bar = "~강화 대기시간"

	L.guardian_message = "수호자 소환 %d!"

	L.empowericon_message = "암흑 강화 사라짐!"

	L.roar_warning = "5초 후 포효!"
	L.roar_bar = "다음 포효"
end
