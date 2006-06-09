BigWigsVaelastrasz = AceAddon:new({
	name          = "BigWigsVaelastrasz",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "BWL",
	enabletrigger = GetLocale() == "koKR" and "타락한 밸라스트라즈"
		or GetLocale() == "deDE" and "Vaelastrasz der Verdorbene" 
		or GetLocale() == "zhCN" and "堕落的瓦拉斯塔兹" 
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

		trigger1 = "^([^%s]+) ([^%s]+) von Brennendes Adrenalin betroffen",

		you = "Ihr",
		are = "seid",

		warn1 = "Du brennst!",
		warn2 = " brennt!",
		bosskill = "Vaelastrasz der Verdorbene wurde besiegt!",
	}	
		or GetLocale() == "zhCN" and
	{
		bossname = "堕落的瓦拉斯塔兹",
		disabletrigger = "堕落的瓦拉斯塔兹死亡了。",

		trigger1 = "^(.+)受(.+)了燃烧刺激",

		you = "你",
		are = "到",

		warn1 = "你在燃烧！",
		warn2 = "在燃烧！",
		bosskill = "堕落的瓦拉斯塔兹被击败了！",
	}
		or 
	{
		bossname = "Vaelastrasz the Corrupt",
		disabletrigger = "Vaelastrasz the Corrupt dies.",

		trigger1 = "^([^%s]+) ([^%s]+) afflicted by Burning Adrenaline",

		you = "You",
		are = "are",

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

if (GetLocale() == "koKR") then
	function BigWigsVaelastrasz:Event()
		local _, _, EPlayer = string.find(arg1, self.loc.trigger1)
		if (EPlayer) then
			if (EPlayer == self.loc.you) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
			else
				local _, _, EWho = string.find(EPlayer, self.loc.whopattern)
				self:TriggerEvent("BIGWIGS_MESSAGE", EWho .. self.loc.warn2, "Yellow")
				self:TriggerEvent("BIGWIGS_SENDTELL", EWho, self.loc.warn1)
			end
		end
	end
else
	function BigWigsVaelastrasz:Event()
		local _, _, EPlayer, EType = string.find(arg1, self.loc.trigger1)
		if (EPlayer and EType) then
			if (EPlayer == self.loc.you and EType == self.loc.are) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
			else
				self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn2, "Yellow")
				self:TriggerEvent("BIGWIGS_SENDTELL", EPlayer, self.loc.warn1)
			end
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsVaelastrasz:RegisterForLoad()