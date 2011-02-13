
local L = BigWigs:NewBossLocale("Al'Akir", "zhCN")
if not L then return end
if L then
	L.stormling = "Stormling adds"
	L.stormling_desc = "Summons Stormling."
	L.stormling_message = "Stormling incoming!"
	L.stormling_bar = "Next stormling"
	L.stormling_yell = "Storms! I summon you to my side!"

	L.acid_rain = "Acid Rain (%d)"

	L.phase3_yell = "Enough! I will no longer be contained!"

	L.phase = "阶段转换"
	L.phase_desc = "当进入不同阶段是发出警报。"

	L.cloud_message = "Franklin would be proud!"
	L.feedback_message = "%dx Feedback"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "zhCN")
if L then
	L.gather_strength = "%s is Gathering Strength"

	L.storm_shield = "Storm shield"
	L.storm_shield_desc = "Absorption Shield"

	L.full_power = "Full Power"
	L.full_power_desc = "Warning for when the bosses reach full power and start to cast the special abilities."
	L.gather_strength_emote = "%s begins to gather strength from the remaining Wind Lords!"

	L.wind_chill = "%sx Wind Chill on YOU!"
end

