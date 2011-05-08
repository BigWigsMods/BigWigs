
local L = BigWigs:NewBossLocale("Cho'gall", "zhTW")
if not L then return end
if L then
	L.orders = "形態轉換"
	L.orders_desc = "當丘加利改變暗影/烈焰之令形態時發出警報。"

	L.worship_cooldown = "<信奉>"

	L.adherent_bar = "<腐化中的擁護者：#%d>"
	L.adherent_message = "即将 腐化中的擁護者：>%d<！"
	L.ooze_bar = "<聚集古神之血：%d>"
	L.ooze_message = "即將 聚集古神之血：>%d<！"

	L.tentacles_bar = "<暗色觸鬚出現>"
	L.tentacles_message = "大量暗色觸鬚！"

	L.sickness_message = ">你< 快要嘔吐了!"
	L.blaze_message = ">你< 燃炎！"
	L.crash_say = ">我< 腐化轟擊！"

	L.fury_bar = "<下一丘加利之怒>"
	L.fury_message = "丘加利之怒！"
	L.first_fury_soon = "即將 丘加利之怒！"
	L.first_fury_message = "85% - 開始丘加利之怒！"

	L.unleashed_shadows = "釋放暗影！"

	L.phase2_message = "第二階段！"
	L.phase2_soon = "即將 第二階段！"
end

L = BigWigs:NewBossLocale("Valiona and Theralion", "zhTW")
if L then
	L.phase_switch = "階段轉換"
	L.phase_switch_desc = "當進入不同階段時發出警報。"

	L.phase_bar = "<%s落地>"
	L.breath_message = "即將 深呼吸！"
	L.dazzling_message = "即將！暮光之境！"

	L.blast_message = "暮光衝擊！"
	L.engulfingmagic_say = ">我< 侵噬魔法！"
	L.engulfingmagic_cooldown = "<侵噬魔法>"

	L.devouringflames_cooldown = "<吞噬烈焰>"

	L.valiona_trigger = "瑟拉里恩，我的火會淹沒整個通道。擋住他們的退路!"
	L.win_trigger = "至少...有瑟拉里恩陪葬..."

	L.twilight_shift = "暮光變換%2$dx：>%1$s<！"
end

L = BigWigs:NewBossLocale("Halfus Wyrmbreaker", "zhTW")
if L then
	L.paralysis_bar = "<下一麻痹>"
	L.strikes_message = "致死打擊%2$dx：>%1$s<！"

	L.breath_message = "即將 灼燒之息！"
	L.breath_bar = "<灼燒之息>"

	L.engage_yell = "Cho'gall will have your heads"
end

L = BigWigs:NewBossLocale("Sinestra", "zhTW")
if L then
	L.whelps = "暮光雏龙"
	L.whelps_desc = "當每波暮光雏龙到來時發出警報。"

	L.slicer_message = "可能火息術目標！"

	L.egg_vulnerable = "集中火力攻擊！"

	L.whelps_trigger = "Feed, children!  Take your fill from their meaty husks!"
	L.omelet_trigger = "You mistake this for weakness?  Fool!"

	L.phase13 = "第一和第三階段"
	L.phase = "階段"
	L.phase_desc = "當進入不同階段時發出警報。"
end

L = BigWigs:NewBossLocale("Ascendant Council", "zhTW")
if L then
	L.static_overload_say = ">我< 靜電超載！"
	L.gravity_core_say = ">我< 重力之核！"
	L.health_report = "%s生命值>%d%%<，即將階段轉換！"
	L.switch = "轉換"
	L.switch_desc = "當首領轉換時發出警報。"

	L.shield_up_message = "火焰之禦 出現!"
	L.shield_down_message = "火焰之禦 消失！"
	L.shield_bar = "<下一火焰之禦>"

	L.switch_trigger = "我們會解決他們!"

	L.thundershock_quake_soon = "约10秒後，%s！"

	L.quake_trigger = "你腳下的地面開始不祥地震動起來...."
	L.thundershock_trigger = "四周的空氣爆出能量霹啪作響聲音...."

	L.thundershock_quake_spam = ">%s< %d！"

	L.last_phase_trigger = "令人印象深刻的表現..."
end

