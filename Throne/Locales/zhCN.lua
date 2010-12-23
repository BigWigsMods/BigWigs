local L = BigWigs:NewBossLocale("Al'Akir", "zhCN")
if L then
	L.windburst = (GetSpellInfo(87770))

	L.phase_change = "阶段转换"
	L.phase_change_desc = "当进入不同阶段是发出警报。"
	L.phase_message = "第%d阶段！"

	L.feedback_message = "%dx Feedback"

	L.you = ">你< %s！"
end

local L = BigWigs:NewBossLocale("Conclave of Wind", "zhCN")
if L then
	L.gather_strength = "%s is Gathering Strength"

	L.full_power = "Full Power"
	L.full_power_desc = "Warning for when the bosses reach full power and start to cast the special abilities."
	L.gather_strength_emote = "%s begins to gather strength from the remaining Wind Lords!"

	L.wind_chill = "YOU have %s stacks of Wind Chill"
end
