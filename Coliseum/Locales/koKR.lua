local L = BigWigs:NewBossLocale("Anub'arak", "koKR")
if L then
	L.engage_message = "전투 시작"
	L.engage_trigger = "여기가 네 무덤이 되리라!"

	L.unburrow_trigger = "땅속에서 모습을 드러냅니다!"
	L.burrow_trigger = "땅속으로 숨어버립니다!"
	L.burrow = "소멸"
	L.burrow_desc = "아눕아락의 등장과 소멸, 소환 되어 추가되는 벌레들을 알립니다."
	L.burrow_cooldown = "다음 소멸"
	L.burrow_soon = "곧 소멸"

	L.nerubian_message = "곧 땅무지 추가!"
	L.nerubian_burrower = "땅무지 추가"

	L.shadow_soon = "약 5초 후 어둠의 일격!"

	L.freeze_bar = "~다음 얼음 베기"
	L.pcold_bar = "~다음 냉기 관통"

	L.chase = "추격"
end

L = BigWigs:NewBossLocale("The Beasts of Northrend", "koKR")
if L then
	L.enable_trigger = "어서 오게, 용사들이여! 은빛십자군의 부름에 담대히 응한 모두를 환영하네! 바로 이곳, 십자군 원형경기장에서 제군들은 엄청난 도전에 마주칠 걸세. 혹독한 원형경기장에서 살아남는 자는 은빛십자군의 일원이 되어 얼음왕관 성채로 진군해 나갈 걸세."
	L.wipe_trigger = "비극이야..."

	L.engage_trigger = "폭풍우 봉우리의 가장 깊고 어두운 동굴에서 온, 꿰뚫는 자 고르목일세! 영웅들이여, 전투에 임하게!"
	L.jormungars_trigger = "마음을 단단히 먹게, 영웅들이여. 두 배의 공포, 산성아귀와 공포비늘이 투기장으로 들어온다네!"
	L.icehowl_trigger = "다음은, 소개하는 순간 공기마저 얼어붙게 하는 얼음울음일세! 죽이지 않으면 죽을 걸세, 용사들이여!"
	L.boss_incoming = "곧 %s 등장"

	-- Gormok
	L.snobold = "스노볼트"
	L.snobold_desc = "스노볼트가 누구의 머리위에 있는지를 알립니다."
	L.snobold_message = "스노볼트 추가"
	L.impale_message = "꿰뚫기 %2$dx : %1$s"
	L.firebomb_message = "당신은 불 폭탄!"

	-- Jormungars
	L.submerge = "잠수"
	L.submerge_desc = "요르문가르의 다음 잠수에 대한 타이머를 표시합니다."
	L.spew = "산성/용암 내뿜기"
	L.spew_desc = "산성/용암 내뿜기를 알립니다."
	L.sprays = "분사"
	L.sprays_desc = "다음 화염과 마비액 분사에 대한 타이머를 표시합니다."
	L.slime_message = "당신은 진흙 웅덩이!"
	L.burn_spell = "불타는 담즙"
	L.toxin_spell = "마비 독"
	L.spray = "~다음 분사"

	-- Icehowl
	L.butt_bar = "~박치기 대기시간"
	L.charge = "사나운 돌진"
	L.charge_desc = "사나운 돌진의 대상 플레이어를 알립니다."
	L.charge_trigger = "([^%s]+)|1을;를; 노려보며 큰 소리로 울부짖습니다.$"
	L.charge_say = "저에게 돌진해요!"

	L.bosses = "보스 등장"
	L.bosses_desc = "보스들 등장을 알립니다."
end

L = BigWigs:NewBossLocale("Faction Champions", "koKR")
if L then
	L.enable_trigger = "다음 전투는 은빛십자군에서 가장 센 기사들을 상대해야 하네... 그들을 이겨야만 자신의 가치를 인정받을 걸세."
	L.defeat_trigger = "상처뿐인 승리로군."

	L["Shield on %s!"] = "기사무적: %s!"
	L["Bladestorming!"] = "칼날폭풍!"
	L["Hunter pet up!"] = "냥꾼 야수 소환!"
	L["Felhunter up!"] = "지옥사냥개 소환!"
	L["Heroism on champions!"] = "용사 영웅심!"
	L["Bloodlust on champions!"] = "용사 피의 욕망!"
end

L = BigWigs:NewBossLocale("Lord Jaraxxus", "koKR")
if L then
	L.enable_trigger = "보이지도 않는 노움 주제에! 그렇게 까불더니 무덤을 파는구나!"

	L.engage = "전투 시작"
	L.engage_trigger = "불타는 군단의 에레다르 군주, 자락서스 님이 상대해주마!"
	L.engage_trigger1 = "황천으로 사라져라!"

	L.adds = "차원문과 화산"
	L.adds_desc = "자락서스의 차원문과 화산 소환에 대한 알림과 타이머를 표시합니다."

	L.incinerate_message = "살점 소각"
	L.incinerate_other = "살점 소각: %s!"
	L.incinerate_bar = "~살점 소각 대기시간"
	L.incinerate_safe = "%s 안전함 :)"

	L.legionflame_message = "군단 불꽃"
	L.legionflame_other = "군단 불꽃 : %s!"
	L.legionflame_bar = "~군단 불꽃 대기시간"

	L.infernal_bar = "화산 소환"
	L.netherportal_bar = "~황천 차원문 대기시간"
	L.netherpower_bar = "~황천의 힘 대기시간"

	L.kiss_message = "당신에게 키스!"
	L.kiss_interrupted = "차단함!"
end

L = BigWigs:NewBossLocale("The Twin Val'kyr", "koKR")
if L then
	L.engage_trigger1 = "어둠의 주인님을 받들어. 리치 왕을 위하여. 너희에게. 죽음을. 안기리라."

	L.vortex_or_shield_cd = "소용돌이/방패 대기시간"
	L.next = "다음 소용돌이 또는 방패"
	L.next_desc = "다음 소용돌이 또는 방패에 대해 알립니다."

	L.vortex = "소용돌이"
	L.vortex_desc = "쌍둥이의 소용돌이 시전을 알립니다."

	L.shield = "어둠/빛의 방패"
	L.shield_desc = "어둠/빛의 방패를 알립니다."
	L.shield_half_message = "방패 강도 50%!"
	L.shield_left_message = "%d%% 강도 남음"

	L.touch = "어둠/빛의 손길"
	L.touch_desc = "어둠/빛의 손길을 알립니다."
end
