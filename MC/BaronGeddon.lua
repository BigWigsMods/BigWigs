BigWigsBaronGeddon = AceAddon:new({
	name          = "BigWigsBaronGeddon",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "MC",
	enabletrigger = GetLocale() == "koKR" and "남작 게돈" 
		or "Baron Geddon",

	loc = GetLocale() == "deDE" and
	{	
		bossname = "Baron Geddon",
		disabletrigger = "Baron Geddon stirbt.",

		trigger1 = "^([^%s]+) ([^%s]+) betroffen von Lebende Bombe",

		you = "Ihr",
		are = "seid",

		warn1 = "Du bist die Bombe!",
		warn2 = " ist die Bombe!",
	} 
		or GetLocale() == "koKR" and 
	{
		bossname = "남작 게돈",
		disabletrigger = "남작 게돈|1이;가; 죽었습니다.",

		trigger1 = "^(.*)살아있는 폭탄에 걸렸습니다.",
		whopattern = "(.+)|1이;가; ",

		you = "",
		are = "은",

		warn1 = "당신은 폭탄입니다!",
		warn2 = "님이 폭탄입니다!",	
	} 
		or 
	{
		bossname = "Baron Geddon",
		disabletrigger = "Baron Geddon dies.",

		trigger1 = "^([^%s]+) ([^%s]+) afflicted by Living Bomb",

		you = "You",
		are = "are",

		warn1 = "You are the bomb!",
		warn2 = " is the bomb!",
	},
})

function BigWigsBaronGeddon:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsBaronGeddon:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsBaronGeddon:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsBaronGeddon:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

if (GetLocale() == "koKR") then
	function BigWigsBaronGeddon:Event()
		local _, _, EPlayer = string.find(arg1, self.loc.trigger1)
		if (EPlayer) then
			if (EPlayer == self.loc.you) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
			else
				local _, _, EWho = string.find(EPlayer, self.loc.whopattern)
				self:TriggerEvent("BIGWIGS_MESSAGE", EWho .. self.loc.warn2, "Yellow")
			end
		end
	end
else
	function BigWigsBaronGeddon:Event()
		local _, _, EPlayer, EType = string.find(arg1, self.loc.trigger1)
		if (EPlayer and EType) then
			if (EPlayer == self.loc.you and EType == self.loc.are) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
			else
				self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn2, "Yellow")
			end
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsBaronGeddon:RegisterForLoad()