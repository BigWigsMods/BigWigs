local L = BigWigs:NewBossLocale("Cho'gall", "koKR")
if L then
	--heroic
	L.orders = "그림자/불꽃의 명령"
	L.orders_desc = "그림자/불꽃의 명령에 대해 알립니다."

	--normal
	L.worship_cooldown = "~개종"

	L.phase_one = "1 단계"
	L.phase_two = "2 단계"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "koKR")
if L then
	L.phase_switch = "단계 전환"
	L.phase_switch_desc = "단계 전환을 알립니다."

	L.engulfingmagic_say = "나에게 사로잡힌 마법!"
	L.engulfingmagic_cooldown = "다음 사로잡힌 마법"

	L.devouringflames_cooldown = "다음 파멸의 불길"

	L.valiona_trigger = "테랄리온, 내가 전당에 불을 뿜겠다. 놈들의 퇴로를 막아라!"

	L.twilight_shift = "황혼 이동 x%2$d : %1$s"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "koKR")
if L then

end

L = BigWigs:NewBossLocale("Sinestra", "koKR")
if L then

end

L = BigWigs:NewBossLocale("Ascendant Council", "koKR")
if L then
	L.static_overload_say = "나에게 전화 과부하!"
	L.gravity_core_say = "나에게 중력 핵!"
	L.health_report = "%s의 체력 -%d%%-, 곧 전환!"
	L.switch = "전환"
	L.switch_desc = "보스의 전환을 알립니다."

	L.lightning_rod_say = "나아게 벼락 막대!"

	L.switch_trigger = "우리가 상대하겠다!"

	L.quake_trigger = "발밑의 땅이 불길하게 우르릉거립니다..."
	L.thundershock_trigger = "주변의 공기가 에너지로 진동합니다..."

	L.searing_winds_message = "소용돌이에 올라타세요!"
	L.grounded_message = "땅에 착지하세요!"

	L.phase = "단계"
	L.phase_desc = "단계 변화를 알립니다."
	L.last_phase_trigger = "꽤나 인상적이었다만..."	--지금 넣은 트리거가 더 좋아보임. 실제 트리거 = "네놈들의 종말을 맞이해라!"
	L.last_phase_message = "마지막 단계"
end
