
local L = BigWigs:NewBossLocale("Al'Akir", "zhCN")
if not L then return end
if L then
	L.stormling = "风暴火花"
	L.stormling_desc = "当召唤风暴火花时发出警报。"
	L.stormling_message = "即将 风暴火花！"
	L.stormling_bar = "<下一风暴火花>"
	L.stormling_yell = "暴风啊！到我的身边来！"

	L.acid_rain = "酸雨：>%d<！"

	L.phase3_yell = "够了！我不会再容忍下去了！"

	L.phase = "阶段转换"
	L.phase_desc = "当进入不同阶段时发出警报。"

	L.cloud_message = "闪电云层！"
	L.feedback_message = "%dx 回馈！"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "zhCN")
if L then
	L.gather_strength = "%s即将获得全部力量！"

	L.storm_shield = "风暴护盾"
	L.storm_shield_desc = "当风暴护盾吸收伤害时发出警报。"

	L.full_power = "全部能量"
	L.full_power_desc = "当首领获得全部能量并开始施放特殊技能时发出警报。"
	L.gather_strength_emote = "%s开始从剩下的风领主身上获得力量！"

	L.wind_chill = ">你< %sx风寒！"
end

