
local L = BigWigs:NewBossLocale("Cho'gall", "zhCN")
if not L then return end
if L then
	L.orders = "形态转换"
	L.orders_desc = "当Cho'gall改变Shadow/Flame Orders形态时发出警报。"

	L.crash_say = ">我< Corrupting Crash！"
	L.worship_cooldown = "<Worship>"
	L.adherent_bar = "<Corrupting Adherent：#%d>"
	L.adherent_message = "即将 Corrupting Adherent：>%d<！"
	L.ooze_bar = "<聚集上古之神的血：%d>"
	L.ooze_message = "即将聚集上古之神的血：>%d<！"
	L.tentacles_bar = "<Darkened Creations出现>"
	L.tentacles_message = "大量Darkened Creations！"
	L.sickness_message = ">你< 快要呕吐了!"
	L.fury_bar = "<下一Fury of Cho'gall>"
	L.fury_message = "Fury of Cho'gall！"

	L.phase2_message = "第二阶段"
	L.phase2_soon = "即将 第二阶段！"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "zhCN")
if L then
	L.phase_switch = "阶段转换"
	L.phase_switch_desc = "当进入不同阶段时发出警报。"

	L.phase_bar = "<%s落地>"
	L.breath_message = "即将 深呼吸！"
	L.dazzling_message = "即将 Twilight Realm！"

	L.blast_message = "Falling Blast"
	L.engulfingmagic_say = ">我< Engulfing Magic！"
	L.engulfingmagic_cooldown = "<Engulfing Magic>"

	L.devouringflames_cooldown = "<Devouring Flame>"

	L.valiona_trigger = "Theralion, I will engulf the hallway. Cover their escape!"

	L.twilight_shift = "Twilight Shift%2$dx：>%1$s<！"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "zhCN")
if L then
	L.paralysis_bar = "<下一麻痹>"

	L.strikes_message = "致死打击%2$dx：>%1$s<！"
end

L = BigWigs:NewBossLocale("Sinestra", "zhCN")
if L then
	L.egg_vulnerable = "Omelet time!"

	L.omelet_trigger = "You mistake this for weakness?  Fool!"

	L.phase13 = "第一和第三阶段"
	L.phase = "阶段"
	L.phase_desc = "当进入不同阶段时发出警报。"
end

L = BigWigs:NewBossLocale("Ascendant Council", "zhCN")
if L then
	L.static_overload_say = ">我< Overload！"
	L.gravity_core_say = ">我< Gravity！"
	L.health_report = "%s生命值>%d%%<，即将阶段转换！"
	L.switch = "转换"
	L.switch_desc = "当首领Switches时发出警报。"

	L.shield_up_message = "Aegis of Flame 出现！"
	L.shield_bar = "<下一Aegis of Flame>"

	L.switch_trigger = "We will handle them!"

	L.thundershock_quake_soon = "约10秒后，%s！"

	L.quake_trigger = "The ground beneath you rumbles ominously...."
	L.thundershock_trigger = "The surrounding air crackles with energy...."

	L.searing_winds_message = "即将 雷霆震荡！"
	L.grounded_message = "即将 地震！"

	L.last_phase_trigger = "An impressive display..."
end

