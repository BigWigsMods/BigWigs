local L = BigWigs:NewBossLocale("Cho'gall", "zhTW")
if L then
	--heroic
	L.orders = "Shadow/Flame Orders"
	L.orders_desc = "Warning for Shadow/Flame Orders"

	--normal
	L.worship_cooldown = "~Worship"

	L.phase_one = "階段一"
	L.phase_two = "階段二"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "zhTW")
if L then
	L.phase_switch = "階段變換"
	L.phase_switch_desc = "當階段變換時發出警報。"

	L.engulfingmagic_say = ">我< 侵噬魔法！"

	L.devouringflames_cooldown = "即將 吞噬烈焰"

	L.valiona_trigger = "Theralion, I will engulf the hallway. Cover their escape!"

	L.twilight_shift = "暮光變換%2$dx：>%1$s<！"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "zhTW")
if L then

end

L = BigWigs:NewBossLocale("Sinestra", "zhTW")
if L then

end

L = BigWigs:NewBossLocale("Ascendant Council", "zhTW")
if L then
	L.static_overload_say = ">我< 靜電超載！"
	L.gravity_core_say = ">我< 重力之核！"
	L.health_report = "%s is at %d%% health, switch soon!"
	L.switch = "轉換"
	L.switch_desc = "當階段首領轉換時發出警報。"
	
	L.lightning_rod_say = ">我< 聚雷針！"

	L.switch_trigger = "We will handle them!"

	L.quake_trigger = "The ground beneath you rumbles ominously...."
	L.thundershock_trigger = "The surrounding air crackles with energy...."

	L.searing_winds_message = "Get Searing Winds!"
	L.grounded_message = "Get Grounded!"

	L.last_phase_trigger = "BEHOLD YOUR DOOM!"
end