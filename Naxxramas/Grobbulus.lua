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
	trigger1 = "^([^%s]+) ([^%s]+) von Mutagene Injektion betroffen",

	you = "Ihr",
	are = "seid",

	warn1 = "Ihr seid verseucht!",
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
				self:TriggerEvent("BigWigs_Message", L"warn1", "Red", true)
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
				self:TriggerEvent("BigWigs_Message", L"warn1", "Red", true)
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
