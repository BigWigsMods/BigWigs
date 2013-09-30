local L = BigWigs:NewBossLocale("The Stone Guard", "koKR")
if not L then return end
if L then
	L.petrifications = "석화"
	L.petrifications_desc = "우두머리가 언제 석화를 시작하는지 경고합니다."

	L.overload = "과부화"
	L.overload_desc = "모든 유형의 과부화를 경고합니다."
end

L = BigWigs:NewBossLocale("Feng the Accursed", "koKR")
if L then
	L.engage_yell = "영혼을 내놓아라, 밀멸자여! 죽은 자들의 환대를 거절하지 마라!"

	L.phase_lightning_trigger = "오 위대한 영혼이여! 내게 대지의 힘을 부여하라!"
	L.phase_flame_trigger = "오 고귀한 자여! 나와 함께 발라내자! 뼈에서 살을!"
	L.phase_arcane_trigger = "오 세기의 현자여! 내게 비전의 지혜를 불어넣어라!"
	L.phase_shadow_trigger = "과거의 위대한 영웅들이여! 너희의 방패를 빌려다오!"


	L.phase_lightning = "번개 채찍 단계!"
	L.phase_flame = "불타는 창 단계!"
	L.phase_arcane = "비전 충격 단계!"
	L.phase_shadow = "(영웅) 어둠의 연소 단계!"

	L.phase_message = "곧 새로운 단계!"
	L.shroud_message = "역전의 장막"
	L.shroud_can_interrupt = "%2$s|1으로;로; %1$s|1을;를; 방해 할 수 있습니다!"
	L.barrier_message = "무효화의 장벽!"
	L.barrier_cooldown = "무효화의 장벽 대기시간"

	-- Tanks
	L.tank = "방어 전담 경고"
	L.tank_desc = "번개 채찍, 불타는 창, 비전 충격, 어둠의 연소 중첩 수를 표시합니다. (영웅)"
	L.lash_message = "번개 채찍"
	L.spear_message = "불타는 창"
	L.shock_message = "비전 충격"
	L.burn_message = "어둠의 연소"
end

L = BigWigs:NewBossLocale("Gara'jal the Spiritbinder", "koKR")
if L then
	L.engage_yell = "죽을 시간이다!"

	L.totem_message = "토템 (%d)"
	L.shadowy_message = "공격 (%d)"
	L.banish_message = "탱커 추방"
end

L = BigWigs:NewBossLocale("The Spirit Kings", "koKR")
if L then
	L.bosses = "우두머리"
	L.bosses_desc = "우리머리 활성화를 경고합니다."

	L.shield_removed = "방패 제거! (%s)"
	L.casting_shields = "방패 시전"
	L.casting_shields_desc = "모든 우두머리들의 방패 시전을 경고합니다."
end

L = BigWigs:NewBossLocale("Elegon", "koKR")
if L then
	L.engage_yell = "방어 모드로 전환. 안전 장치 해제."

	L.last_phase = "마지막 단계"
	L.overcharged_total_annihilation = "과충전 %d!"

	L.floor = "바닥 떨어짐"
	L.floor_desc = "바닥에 언제 떨어지는지 경고합니다."
	L.floor_message = "바닥에서 나오세요!"

	L.adds = "추가" --Adds
	L.adds_desc = "Warnings for when a Celestial Protector is about to spawn."
end

L = BigWigs:NewBossLocale("Will of the Emperor", "koKR")
if L then
	L.enable_zone = "무한의 제련소"

	L.heroic_start_trigger = "도관을 파괴하자" -- 도관을 파괴하자 |cFFFF0000|Hspell:116779|h[Titan Gas]|h|r가 방으로 새어 나옵니다!
	L.normal_start_trigger = "기계가 윙윙거리며" -- 기계가 윙윙거리며 동작하기 시작합니다! 아래층으로 가십시오!

	L.rage_trigger = "황제의 분노가 문 언덕에 울려퍼진다."
	L.strength_trigger = "황제의 힘이 벽감에 나타납니다!"
	L.courage_trigger = "황제의 용기가 벽감에 나타납니다!"
	L.bosses_trigger = "거대한 모구 조형체 둘이 큰 벽감에 나타납니다!"
	L.gas_trigger = "고대 모구 기계가 부서집니다!"
	L.gas_overdrive_trigger = "고대 모구 기계가 폭주합니다!"

	L.target_only = "|cFFFF0000이 경고는 당신이 대상으로 삼고 있는 우두머리만 표시합니다.|r "

	L.combo_message = "%s: 곧 연타공격!"
end

