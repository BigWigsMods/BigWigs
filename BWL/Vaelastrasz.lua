BigWigsVaelastrasz = AceAddon:new({
	name          = "BigWigsVaelastrasz",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "BWL",
	enabletrigger = GetLocale() == "koKR" and "타락한 밸라스트라즈"
		or GetLocale() == "deDE" and "Vaelastrasz der Verdorbene" 
		or "Vaelastrasz the Corrupt",

	loc = GetLocale() == "koKR" and {
		bossname = "타락한 밸라스트라즈",
		disabletrigger = "밸라스트라즈|1이;가; 죽었습니다.",

		trigger1 = "(.*)불타는 아드레날린에 걸렸습니다.",

		whopattern = "(.+)|1이;가; ", 
		you = "",		

		warn1 = "당신은 불타는 아드레날린에 걸렸습니다!",
		warn2 = "님이 불타는 아드레날린에 걸렸습니다!",
		bosskill = "타락의 벨라스트라즈를 물리쳤습니다!",		
	} 
		or GetLocale() == "deDE" and 
	{
		bossname = "Vaelastrasz der Verdorbene",
		disabletrigger = "Vaelastrasz der Verdorbene stirbt.",

		trigger1 = "^(.*)von Brennendes Adrenalin betroffen",

		you = "Ihr seid ",
		are = "seid",
		whopattern = "([^%s]+) ([^%s]+) ",

		warn1 = "Du brennst!",
		warn2 = " brennt!",
		bosskill = "Vaelastrasz der Verdorbene wurde besiegt!",
	}	
		or 
	{
		bossname = "Vaelastrasz the Corrupt",
		disabletrigger = "Vaelastrasz the Corrupt dies.",

		trigger1 = "^(.*)afflicted by Burning Adrenaline",

		you = "You are ",
		are = "are",
		whopattern = "([^%s]+) ([^%s]+) ", 

		warn1 = "You are burning!",
		warn2 = " is burning!",
		bosskill = "Vaelastrasz the Corrupt has been defeated!",
	},
})

function BigWigsVaelastrasz:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsVaelastrasz:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsVaelastrasz:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsVaelastrasz:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

--[[
function BigWigsVaelastrasz:Event()
	local _,_, EPlayer, EType = string.find(arg1, self.loc.trigger1)
	if (EPlayer and EType) then
		if (EPlayer == self.loc.you and EType == self.loc.are) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
		else
			self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn2, "Yellow")
		end
	end
end]] 

function BigWigsVaelastrasz:Event()
	local _,_, EPlayer = string.find(arg1, self.loc.trigger1)
	if (EPlayer) then
		if (EPlayer == self.loc.you) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
		else
			local _,_, EWho = string.find(EPlayer, self.loc.whopattern)
			self:TriggerEvent("BIGWIGS_MESSAGE", EWho .. self.loc.warn2, "Yellow")
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsVaelastrasz:RegisterForLoad()