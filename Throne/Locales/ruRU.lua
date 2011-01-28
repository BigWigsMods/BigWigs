
local L = BigWigs:NewBossLocale("Al'Akir", "ruRU")
if not L then return end
if L then
	L.phase3_yell = "Äîâîëüíî! Ìåíÿ íè÷òî íå â ñèëàõ ñäåðæèâàòü!"

	L.phase = "Ñìåíà ôàç"
	L.phase_desc = "Ñîîáùàòü î ñìåíå ôàç."

	L.cloud_message = "Ãðîçîâûå îáëàêà!"
	L.feedback_message = "%dx Îòâåòíàÿ ðåàêöèÿ"
end

L = BigWigs:NewBossLocale("Conclave of Wind", "ruRU")
if L then
	L.gather_strength = "%s áëèçîê ê îáðèòåíèþ îáñîëþòíîé ñèëû!"

	L.storm_shield = GetSpellInfo(95865)
	L.storm_shield_desc = "Ùèò ïîãëîùåíèÿ óðîíà"

	L.full_power = "Ïîëíàÿ ñèëà"
	L.full_power_desc = "Ñîîáùàåò êîãäà áîññ äîñòèãàåò ïîëíîé ñèëû è íà÷èíàåò ïðèìåíÿòü ñïåöèàëüíûå ñïîñîáíîñòè."
	L.gather_strength_emote = "%s íà÷èíàåò âáèðàòü ñèëó îñòàâøèõñÿ âëàäûê âåòðà!"

	L.wind_chill = "Íà ÂÀÑ %s ñòàêîâ Õîëîäíîãî âåòðà"
end

