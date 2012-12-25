
local L = BigWigs:NewBossLocale("Protectors of the Endless", "zhCN")
if not L then return end
if L then
	L.under = "%s under %s!"
	L.heal = "%s 开始治疗！"
end

L = BigWigs:NewBossLocale("Tsulong", "zhCN")
if L then
	L.engage_yell = "你不属于这里！我必须保护水流……我要驱逐李，要不就杀死你！"
	L.kill_yell = "谢谢你，陌生人。我自由了。"

	L.phases = "阶段转换"
	L.phases_desc = "阶段转换时报警。"

	L.sunbeam_spawn = "新阳光！"
end

L = BigWigs:NewBossLocale("Lei Shi", "zhCN")
if L then
	L.hp_to_go = "%d%% 结束"
	L.end_hide = "显形"

	L.special = "下一次特殊技能"
	L.special_desc = "警告下一次特殊技能"
end

L = BigWigs:NewBossLocale("Sha of Fear", "zhCN")
if L then
	L.fading_soon = "%s fading soon"

	L.swing = "Swing"
	L.swing_desc = "Counts the swings preceeding Thrash."

	L.throw = "Throw!"
	L.ball_dropped = "Ball dropped!"
	L.ball_you = "You have the ball!"
	L.ball = "Ball"

	L.cooldown_reset = "Your cooldowns have been reset!"

	L.ability_cd = "Ability cooldown"
	L.ability_cd_desc = "Try and guess in which order abilities will be used after an Emerge."

	L.huddle_or_spout = "Huddle or Spout"
	L.huddle_or_strike = "Huddle or Strike"
	L.strike_or_spout = "Strike or Spout"
	L.huddle_or_spout_or_strike =  "Huddle or Spout or Strike"
end

