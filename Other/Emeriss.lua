------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.0")("Emeriss")
local L = AceLibrary("AceLocale-2.0"):new("BigWigs"..boss)

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {

	cmd = "emeriss",
	
	noxious_cmd = "noxious",
	noxious_name = "Noxious breath alert",
	noxious_desc = "Warn for noxious breath",
	
	volatileyou_cmd = "volatileyou",
	volatileyou_name = "Voltile infection on you alert",
	volatileyou_desc = "Warn for volatile infection on you",
	
	volatileother_cmd = "volatileother",
	volatileother_name = "Volatile infection on others alert",
	volatileother_desc = "Warn for volatile infection on others",

	trigger1 = "^([^%s]+) ([^%s]+) afflicted by Volatile Infection",
	trigger2 = "afflicted by Noxious Breath",

	warn1 = "You are afflicted by Volatile Infection!",
	warn2 = " is afflicted by Volatile Infection!",
	warn3 = "5 seconds until Noxious Breath!",
	warn4 = "Noxious Breath - 30 seconds till next!",

	isyou = "You",
	isare = "are",

	bar1text = "Noxious Breath",	
	
} end )

L:RegisterTranslations("zhCN", function() return {
	noxious_name = "毒性吐息警报",
	noxious_desc = "毒性吐息警报",
	
	volatileyou_name = "玩家快速传染警报",
	volatileyou_desc = "你中了快速传染时发出警报",
	
	volatileother_name = "队友快速传染警报",
	volatileother_desc = "队友中了快速传染时发出警报",
	
	trigger1 = "^(.+)受(.+)了快速传染效果",
	trigger2 = "受到了毒性吐息效果的影响。",

	warn1 = "你中了快速传染！",
	warn2 = "中了快速传染！",
	warn3 = "5秒后发动毒性吐息！",
	warn4 = "毒性吐息 - 30秒后再次发动",

	isyou = "你",
	isare = "到",

	bar1text = "毒性吐息",
} end )

L:RegisterTranslations("koKR", function() return {
	trigger1 = "(.*)대지의 오염에 걸렸습니다.",
	trigger2 = "에메리스의 산성 숨결에 의해",

	warn1 = "당신은 대지의 오염에 걸렸습니다!",
	warn2 = "님이 대지의 오염에 걸렸습니다!",
	warn3 = "5초후 산성 숨결!",
	warn4 = "산성 숨결 - 30초후 재시전!",

	isyou = "",
	whopattern = "(.+)|1이;가; ",

	bar1text = "산성 숨결",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

BigWigsEmeriss = BigWigs:NewModule(boss)
BigWigsEmeriss.zonename = { AceLibrary("AceLocale-2.0"):new("BigWigs")("Outdoor Raid Bosses Zone"), AceLibrary("Babble-Zone-2.0")("Blasted Lands"), AceLibrary("Babble-Zone-2.0")("Duskwood"), AceLibrary("Babble-Zone-2.0")("The Hinterlands"), AceLibrary("Babble-Zone-2.0")("Feralas") }
BigWigsEmeriss.enabletrigger = boss
BigWigsEmeriss.toggleoptions = {"noxious", "volatileyou", "volatileother", "bosskill"}
BigWigsEmeriss.revision = tonumber(string.sub("$Revision$", 12, -3))

------------------------------
--      Initialization      --
------------------------------

function BigWigsEmeriss:OnEnable()
	self:RegisterEvent("BigWigs_Message")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

if (GetLocale() == "koKR") then
	function BigWigsEmeriss:Event( msg )
		if (not self.prior and string.find(msg, L"trigger2")) then
			self.prior = true
			if self.db.profile.noxious then 
				self:TriggerEvent("BigWigs_Message", L"warn4", "Red")
				self:ScheduleEvent("BigWigs_Message", 25, L"warn3", "Red")
				self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 30, 1, "Interface\\Icons\\Spell_Shadow_LifeDrain02", "Yellow", "Orange", "Red")
			end
		else
			local _,_, EPlayer = string.find(msg, L"trigger1")
			if (EPlayer) then
				if (EPlayer == L"isyou" ) then
					if self.db.profile.volatileyou then self:TriggerEvent("BigWigs_Message", L"warn1", "Red", true) end
				else
					local _,_, EWho = string.find(EPlayer, L"whopattern")
					if self.db.profile.volatileother then 
						self:TriggerEvent("BigWigs_Message", EWho .. L"warn2", "Yellow")
						self:TriggerEvent("BigWigs_SendTell", EWho, L"warn1")
					end
				end
			end
		end
	end
else
	function BigWigsEmeriss:Event( msg )
		if (not self.prior and string.find(msg, L"trigger2")) then
			self.prior = true
			if self.db.profile.noxious then 
				self:TriggerEvent("BigWigs_Message", L"warn4", "Red")
				self:ScheduleEvent("BigWigs_Message", 25, L"warn3", "Red")
				self:TriggerEvent("BigWigs_StartBar", self, L"bar1text", 30, 1, "Interface\\Icons\\Spell_Shadow_LifeDrain02", "Yellow", "Orange", "Red")
			end			
		else
			local _,_, EPlayer, EType = string.find(msg, L"trigger1")
			if (EPlayer and EType) then
				if (EPlayer == L"isyou" and EType == L"isare") then
					if self.db.profile.volatileyou then self:TriggerEvent("BigWigs_Message", L"warn1", "Red", true) end
				else
					if self.db.profile.volatileother then
						self:TriggerEvent("BigWigs_Message", EPlayer .. L"warn2", "Yellow")
						self:TriggerEvent("BigWigs_SendTell", EPlayer, L"warn1")
					end
				end
			end
		end
	end
end

function BigWigsEmeriss:BigWigs_Message(text)
	if text == L"warn3" then self.prior = nil end
end
