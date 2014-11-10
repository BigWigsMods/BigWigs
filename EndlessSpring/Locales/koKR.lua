
local L = BigWigs:NewBossLocale("Protectors of the Endless", "koKR")
if not L then return end
if L then
	L.under = "%s 아래 %s!"
	L.heal = "%s 치유"
end

L = BigWigs:NewBossLocale("Tsulong", "koKR")
if L then
	L.engage_yell = "여긴 너희가 있을 곳이 아니다! 이 물은 보호해야 해... 물러서지 않겠다면 처치해주마!"
	L.kill_yell = "고맙다, 이방인이여. 날 자유롭게 해줘서."

	L.phases = "단계"
	L.phases_desc = "단계 변경을 경고합니다."

	L.sunbeam_spawn = "새로운 태양 광선!"
end

L = BigWigs:NewBossLocale("Lei Shi", "koKR")
if L then
	L.hp_to_go = "%d%% 이동"

	L.special = "다음 특별한 능력" -- 숨기, 저리 가!
	L.special_desc = "다음 특별한 능력을 경고합니다."

	L.custom_off_addmarker = "수호병 공격대 아이콘"
	L.custom_off_addmarker_desc = "Marks Animated Protectors during Lei Shi's Protect, requires promoted or leader.\n|cFFFF0000Only 1 person in the raid should have this enabled to prevent marking conflicts.|r\n|cFFADFF2FTIP: If the raid has chosen you to turn this on, quickly mousing over all of the Protectors is the fastest way to mark them.|r"
end

L = BigWigs:NewBossLocale("Sha of Fear", "koKR")
if L then
	L.fading_soon = "곧 %s 사라짐"

	L.swing = "Swing"
	L.swing_desc = "Counts the swings preceeding Thrash."

	L.throw = "Throw!"
	L.ball_dropped = "Ball dropped!"
	L.ball_you = "당신에게 빛 전달!"
	L.ball = "빛 전달"

	L.cooldown_reset = "당신의 재사용 대기시간이 최기화되었습니다!"

	L.ability_cd = "능력 재사용 대기시간 바"
	L.ability_cd_desc = "다음 가능한 능력을 표시합니다."

	L.strike_or_spout = "집념의 일격이나 혼비백산" -- Strike or Spout
	L.huddle_or_spout_or_strike = "혼비백산이나 집념의 일격이나 용오름" -- Huddle or Spout or Strike

	--L.custom_off_huddle = "Huddle marker"
	--L.custom_off_huddle_desc = "To help healing assignments, mark the people who have huddle in terror on them with {rt1}{rt2}{rt3}{rt4}{rt5}{rt6}, requires promoted or leader."
end

