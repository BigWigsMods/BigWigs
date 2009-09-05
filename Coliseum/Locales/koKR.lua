local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Anub'arak", "koKR")
if L then
	L.engage_message = "전투 시작"
	L.engage_trigger = "여기가 네 무덤이 되리라!"
	
	L.unburrow_trigger = "땅속에서 모습을 드러냅니다!"
	L.burrow_trigger = "땅속으로 숨어버립니다!"
	L.burrow = "소멸"
	L.burrow_desc = "아눕아락의 소멸 기술에 대하여 타이머등으로 알립니다."
	L.burrow_cooldown = "다음 소멸"
	L.burrow_soon = "곧 소멸"
	
	L.icon = "전술 표시"
	L.icon_desc = "소멸 단계에 추격 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)"

	L.chase = "추격"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Northrend Beasts", "koKR")
if L then
	L.engage_trigger = "폭풍우 봉우리의 가장 깊고 어두운 동굴에서 온, 꿰뚫는 자 고르목일세! 영웅들이여, 전투에 임하게!"
	L.jormungars_trigger = "마음을 굳게 하게, 영웅들이여. 두 배의 공포, 산성아귀와 공포비늘이 투기장으로 들어온다네!"
	L.icehowl_trigger = "소개하는 순간 공기마저 얼어붙게 하는 얼음울음이 다음 상대일세! 죽거나 죽이거나, 선택하게 용사들이여!"
	L.boss_incoming = "%s 곧 등장"

	-- Gormok
	L.snobold = "스노볼트"
	L.snobold_desc = "스노볼트가 누구의 머리위에 있는지를 알립니다."
	L.snobold_message = "스노볼트: %s!"
	L.impale_message = "꿰뚫기 x%2$d: %1$s"
	L.firebomb_message = "당신은 불 폭탄!"

	-- Jormungars
	L.spew = "산성/용암 내뿜기"
	L.spew_desc = "산성/용암 내뿜기를 알립니다."
	
	L.slime_message = "당신은 진흙 웅덩이!"
	L.burn_spell = "불타는 담즙"
	L.toxin_spell = "마비 독"

	-- Icehowl
	L.butt_bar = "~박치기 대기시간"
	L.charge = "사나운 돌진"
	L.charge_desc = "사나운 돌진의 대상 플레이어를 알립니다."
	L.charge_trigger = "([^%s]+)|1을;를; 노려보며 큰 소리로 울부짖습니다.$"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Faction Champions", "koKR")
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

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Jaraxxus", "koKR")
if L then
	L.engage = "전투 시작"
	L.engage_trigger = "불타는 군단의 에레다르 군주, 자락서스 님이 상대해주마!"
	L.engage_trigger1 = "황천으로 사라져라!"

	L.incinerate_message = "살점 소각"
	L.incinerate_other = "살점 소각: %s"
	L.incinerate_bar = "~살점 소각 대기시간"

	L.legionflame_message = "군단 불꽃"
	L.legionflame_other = "군단 불꽃 : %s!"
	L.legionflame_bar = "~군단 불꽃 대기시간"

	L.icon = "전술 표시"
	L.icon_desc = "불꽃 군단 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)"

	L.netherportal_bar = "~황천 차원문 대기시간"
	L.netherpower_bar = "~황천의 힘 대기시간"
end

local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs: Twin Val'kyr", "koKR")
if L then
	L.engage_trigger1 = "어둠의 주인님을 받들어. 리치 왕을 위하여. 너희에게. 죽음을. 안기리라."

	L.vortex_or_shield_cd = "소용돌이/방패 대기시간"

	L.vortex = "소용돌이"
	L.vortex_desc = "쌍둥이의 소용돌이 시전을 알립니다."

	L.shield = "어둠/빛의 방패"
	L.shield_desc = "어둠/빛의 방패를 알립니다."

	L.touch = "어둠/빛의 손길"
	L.touch_desc = "어둠/빛의 손길을 알립니다."
end
