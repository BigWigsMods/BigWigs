------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Grobbulus")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "grobbulus",
	
	youinjected_cmd = "youinjected",
	youinjected_name = "You're injected Alert",
	youinjected_desc = "Warn when you're injected",
	
	otherinjected_cmd = "otherinjected",
	otherinjected_name = "Others injected Alert",
	otherinjected_desc = "Warn when others are injected",

	icon_cmd = "icon",
	icon_name = "Place Icon",
	icon_desc = "Place a skull icon on an injected person. (Requires promoted or higher)",

	trigger1 = "^([^%s]+) ([^%s]+) afflicted by Mutating Injection",

	you = "You",
	are = "are",

	warn1 = "You are injected!",
	warn2 = " is Injected!",
} end )

L:RegisterTranslations("deDE", function() return {
	cmd = "grobbulus",
	
	youinjected_cmd = "youinjected",
	youinjected_name = "Du bist verseucht",
	youinjected_desc = "Warnung, wenn Du von Mutierende Injektion betroffen bist.",
	
	otherinjected_cmd = "otherinjected",
	otherinjected_name = "X ist verseucht",
	otherinjected_desc = "Warnung, wenn andere Spieler von Mutierende Injektion betroffen sind.",

	icon_cmd = "icon",
	icon_name = "Symbol",
	icon_desc = "Platziert ein Symbol \195\188ber dem Spieler, der von Mutierende Injektion betroffen ist. (Ben\195\182tigt Anf\195\188hrer oder Bef\195\182rdert Status.)",

	trigger1 = "^([^%s]+) ([^%s]+) von Mutierende Injektion betroffen",

	you = "Ihr",
	are = "seid",

	warn1 = "Du bist verseucht!",
	warn2 = " ist verseucht!",
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 = "(.*)돌연변이 유발에 걸렸습니다.",

	whopattern = "(.+)|1이;가; ",
	you = "",
	are = "are",

	warn1 = "당신은 돌연변이 유발에 걸렸습니다.",
	warn2 = " 님이 돌연변이 유발에 걸렸습니다.",
} end )

L:RegisterTranslations("zhCN", function() return {
	youinjected_name = "玩家变异注射警报",
	youinjected_desc = "你中了变异注射时发出警报",
	
	otherinjected_name = "队友变异注射警报",
	otherinjected_desc = "队友中了变异注射时发出警报",

	icon_name = "标记图标",
	icon_desc = "在中了变异注射的队友头上标记骷髅图标（需要助理或领袖权限）",

	trigger1 = "^(.+)受(.+)了变异注射",

	you = "你",
	are = "到",

	warn1 = "你中变异注射了！",
	warn2 = "中变异注射了！",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsGrobbulus = BigWigs:NewModule(boss)
BigWigsGrobbulus.zonename = AceLibrary("Babble-Zone-2.0")("Naxxramas")
BigWigsGrobbulus.enabletrigger = boss
BigWigsGrobbulus.toggleoptions = {"youinjected", "otherinjected", "icon", "bosskill"}
BigWigsGrobbulus.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsGrobbulus:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "InjectEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "InjectEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "InjectEvent")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

if GetLocale() == "koKR" then 
	function BigWigsGrobbulus:InjectEvent( msg )
		local _, _, eplayer = string.find(msg, L"trigger1")
		if (eplayer) then
			if self.db.profile.youinjected and eplayer == L"you" then
				self:TriggerEvent("BigWigs_Message", L"warn1", "Red", true, "Alarm")
			elseif self.db.profile.otherinjected then
				_, _, eplayer = string.find(eplayer, L"whopattern")
				self:TriggerEvent("BigWigs_Message", eplayer .. L"warn2", "Yellow")
				self:TriggerEvent("BigWigs_SendTell", eplayer, L"warn1")
			end
			if self.db.profile.icon then
				if eplayer == L"you" then	eplayer = UnitName('player') end
				self:TriggerEvent("BigWigs_SetRaidIcon", eplayer)
			end
		end
	end
else
	function BigWigsGrobbulus:InjectEvent( msg )
		local _, _, eplayer, etype = string.find(msg, L"trigger1")
		if eplayer and etype then
			if self.db.profile.youinjected and eplayer == L"you" and etype == L"are" then
				self:TriggerEvent("BigWigs_Message", L"warn1", "Red", true, "Alarm")
			elseif self.db.profile.otherinjected then 
				self:TriggerEvent("BigWigs_Message", eplayer .. L"warn2", "Yellow")
				self:TriggerEvent("BigWigs_SendTell", eplayer, L"warn1")
			end
			if self.db.profile.icon then
				if eplayer == L"you" then eplayer = UnitName('player') end
				self:TriggerEvent("BigWigs_SetRaidIcon", eplayer )
			end
		end
	end
end 
