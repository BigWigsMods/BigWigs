local L = BigWigs:NewBossLocale("Maut", "zhCN")
if not L then return end
if L then
	L.stage2_over = "第2阶段结束 - %.1f秒"
end

L = BigWigs:NewBossLocale("Shad'har the Insatiable", "zhCN")
if L then
	L.custom_on_stop_timers = "总是显示技能条"
	L.custom_on_stop_timers_desc = "夏德哈下次会随机释放非冷却技能。当此选项启用，这些技能条将保留在屏幕上。"
end

L = BigWigs:NewBossLocale("Drest'agath", "zhCN")
if L then
	L.adds_desc = "德雷阿佳丝之眼、触须和喉警报和消息。"

	L.eye_killed = "眼已击杀！"
	L.tentacle_killed = "触须已击杀！"
	L.maw_killed = "喉已击杀！"
end

L = BigWigs:NewBossLocale("Il'gynoth, Corruption Reborn", "zhCN")
if L then
	L.custom_on_fixate_plates = "敌对姓名板凝视图标"
	L.custom_on_fixate_plates_desc = "当你被凝视时在目标姓名板上显示一个图标。\n需要使用敌对姓名板。此功能目前只支持 KuiNameplates。"
end

L = BigWigs:NewBossLocale("Vexiona", "zhCN")
if L then
	L.killed = "%s已击杀"
end

L = BigWigs:NewBossLocale("Ra-den the Despoiled", "zhCN")
if L then
	L.essences = "精华"
	L.essences_desc = "莱登周期性从其他领域汲取精华。不同种类的精华能够赋予莱登不同的能量。"
end

L = BigWigs:NewBossLocale("Carapace of N'Zoth", "zhCN")
if L then
	L.player_membrane = "玩家外膜" -- In stage 3
	L.boss_membrane = "首领外膜" -- In stage 3
end

L = BigWigs:NewBossLocale("N'Zoth, the Corruptor", "zhCN")
if L then
	L.realm_switch = "领域已转换" -- When you leave the Mind of N'zoth

	L.custom_on_repeating_paranoia_say = "重复妄念喊话"
	L.custom_on_repeating_paranoia_say_desc = "当你中了妄念后在聊天中重复喊话避免闲杂人等靠近。"

	L.gateway_yell = "警告：心之秘室被侵入。出现敌对实体。" -- Yelled by MOTHER to trigger mythic only stage
	L.gateway_open = "传送门打开！"

	L.laser_left = "激光（左侧）"
	L.laser_right = "激光（右侧）"
end
