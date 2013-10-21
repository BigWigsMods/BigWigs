
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

	L.custom_off_addmarker = "保衛者標記"
	L.custom_off_addmarker_desc = "當蕾希被保護時標記復生的保衛者，需要權限。\n|cFFFF0000團隊中只有1名應該啟用此選項以防止標記衝突。|r\n|cFFADFF2F提示：如果團隊選擇你用來標記保衛者，滑鼠懸停快速劃過全部保衛者是最快的標記方式。|r"
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

	L.custom_off_huddle = "恐懼畏縮標記"
	L.custom_off_huddle_desc = "幫助治療分配，使用 {rt1}{rt2}{rt3}{rt4}{rt5}{rt6} 標記玩家受到因畏惧而蜷缩，需要權限。"
end

