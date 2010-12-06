local L = BigWigs:NewBossLocale("Al'Akir", "deDE")
if L then

end

local L = BigWigs:NewBossLocale("Conclave of Wind", "deDE")
if L then
	L.gather_strength = "%s sammelt Kraft"
	
	L.full_power = "Volle Kraft"
	L.full_power_desc = "Warnt, wenn der Boss volle Kraft erreicht hat und seine Spezialfähigkeiten wirkt."
	--L.gather_strength_emote = "%s begins to gather strength from the remaining Wind Lords!"
	
	L.wind_chill = "%sx Windkühle auf DIR!"
end
