local L = BigWigs:NewBossLocale("Cho'gall", "zhTW")
if L then
	--heroic
	L.orders = "暗影/烈焰之令"
	L.orders_desc = "當施放暗影/烈焰之令時發出警報。"

	--normal
	L.worship_cooldown = "<信奉>"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "zhTW")
if L then
	L.phase_switch = "階段"
	L.phase_switch_desc = "當進入不同階段時發出警報。"

	L.engulfingmagic_say = ">我< 侵噬魔法！"
	L.engulfingmagic_cooldown = "<侵噬魔法>"

	L.devouringflames_cooldown = "<吞噬烈焰>"

	L.valiona_trigger = "瑟拉里恩，我的火會淹沒整個通道。擋住他們的退路!"

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
	L.health_report = "%s生命值>%d%%<，快轉換！"
	L.switch = "轉換"
	L.switch_desc = "當首領轉換時發出警報。"

	L.lightning_rod_say = ">我< 聚雷針！"

	L.switch_trigger = "We will handle them!"

	L.quake_trigger = "The ground beneath you rumbles ominously...."
	L.thundershock_trigger = "The surrounding air crackles with energy...."

	L.searing_winds_message = "獲得旋風！"
	L.grounded_message = "獲得禁錮！"

	L.last_phase_trigger = "BEHOLD YOUR DOOM!"
end