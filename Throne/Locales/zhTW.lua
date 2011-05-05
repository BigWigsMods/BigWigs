
local L = BigWigs:NewBossLocale("Al'Akir", "zhTW")
if not L then return end
if L then
	L.stormling = "小風暴"
	L.stormling_desc = "當召喚小風暴時發出警報。"
	L.stormling_message = "即將 小風暴！"
	L.stormling_bar = "<下一小風暴>"
	L.stormling_yell = "風暴啊!我召喚你們來我身邊!"

	L.acid_rain = "酸雨 （%d）！"

	L.phase3_yell = "夠了!我不要再被束縛住了!"

	L.phase = "階段轉換"
	L.phase_desc = "當進入不同階段時發出警報。"

	L.cloud_message = "落雷之雲！"
	L.feedback_message = "%dx 回饋！"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "zhTW")
if L then
	L.gather_strength = "%正在聚集力量！"

	L.storm_shield = "風暴之盾"
	L.storm_shield_desc = "當風暴之盾吸收傷害時發出警報。"

	L.full_power = "滿能量"
	L.full_power_desc = "當首領獲得滿能量並開始施放特殊技能時發出警報。"
	L.gather_strength_emote = "%s開始從剩下的風之王那裡取得力量!"

	L.wind_chill = ">你< %sx風寒冷卻！"
end

