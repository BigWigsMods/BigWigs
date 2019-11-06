local L = BigWigs:NewBossLocale("Azuregos", "zhTW")
if not L then return end
if L then
	L.teleport = "傳送警報"
	L.teleport_desc = "傳送警報"
	L.teleport_trigger = "來吧，小子。面對我！"
	L.teleport_message = "傳送發動！"
end

L = BigWigs:NewBossLocale("Lord Kazzak", "zhTW")
if L then
	L.supreme = "無敵警報"
	L.supreme_desc = "無敵警報"
	L.engage_trigger = "為了軍團！為了基爾加德！"
	L.engage_message = "卡札克已開始攻擊 - 3分鐘後無敵！"
	L.supreme1min = "1分鐘後無敵！"
	L.supreme30sec = "30秒後無敵！"
	L.supreme10sec = "10秒後無敵！"
	L.bartext = "上帝模式"
end
