
local L = BigWigs:NewBossLocale("Protectors of the Endless", "zhTW")
if not L then return end
if L then
	L.under = "%s 在%s腳下!"
	L.heal = "%s 治療"
end

L = BigWigs:NewBossLocale("Tsulong", "zhTW")
if L then
	L.engage_yell = "你不屬於這裡!我必須保護這些水...我將驅逐你，或是殺了你!"
	L.kill_yell = "謝謝你，陌生人。我重獲自由了。"

	L.phases = "階段"
	L.phases_desc = "當階段改變時警告."

	L.sunbeam_spawn = "新的陽光！"
end

L = BigWigs:NewBossLocale("Lei Shi", "zhTW")
if L then
	L.hp_to_go = "還剩%d%%"

	L.special = "下次特殊技能"
	L.special_desc = "警告下次特殊技能"
end

L = BigWigs:NewBossLocale("Sha of Fear", "zhTW")
if L then
	L.fading_soon = "%s 快要隱沒"

	L.swing = "揮動"
	L.swing_desc = "計算先前攻擊揮動的次數。"

	L.throw = "投擲！"
	L.ball_dropped = "球掉落了！"
	L.ball_you = "你有球！"
	L.ball = "球"

	L.cooldown_reset = "你的CD已經被重置！"

	L.ability_cd = "技能冷卻"
	L.ability_cd_desc = "嘗試與猜測在浮現之後技能的使用順序。"

	L.strike_or_spout = "襲擊或水魄"
	L.huddle_or_spout_or_strike = "畏縮或水魄或襲擊"
end

