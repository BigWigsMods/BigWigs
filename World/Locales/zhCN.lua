local L = BigWigs:NewBossLocale("Azuregos", "zhCN")
if not L then return end
if L then
        L.bossName = "艾索雷葛斯"
	
	L.teleport = "传送警报"
	L.teleport_desc = "传送警报"
	L.teleport_trigger = "来吧，小子。面对我！"
	L.teleport_message = "传送发动！"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "zhCN")
if L then
	L.bossName = "卡扎克"
	
        L.supreme = "无敌"
	L.supreme_name = "无敌警报"
	L.supreme_desc = "无敌警报"
	L.engage_trigger = "为了燃烧军团！为了基尔加丹！"
	L.engage_message = "卡扎克已激活 - 3分钟后无敌！"
	L.supreme1min = "1分钟后无敌！"
	L.supreme30sec = "30秒后无敌！"
	L.supreme10sec = "10秒后无敌！"
	L.bartext = "无敌模式"
end
