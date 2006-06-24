local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsBaronGeddon = AceAddon:new({
	name = "BigWigsBaronGeddon",
	cmd = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Molten Core"),
	enabletrigger = bboss("Baron Geddon"),
	bossname = bboss("Baron Geddon"),

	toggleoptions = {
		notYouBomb = "Warn when you are the bomb",
		notElseBomb = "Warn when others are the bomb",
		notIcon = "Put a Skull icon on the person who's the bomb. (Requires promoted or higher)",
		notBosskill = "Boss death",
	},

	loc = GetLocale() == "deDE" and
	{
		disabletrigger = "Baron Geddon stirbt.",

		trigger1 = "^([^%s]+) ([^%s]+) betroffen von Lebende Bombe",

		you = "Ihr",
		are = "seid",

		warn1 = "Du bist die Bombe!",
		warn2 = " ist die Bombe!",
	}
		or GetLocale() == "koKR" and
	{
		disabletrigger = "남작 게돈|1이;가; 죽었습니다.",

		trigger1 = "^(.*)살아있는 폭탄에 걸렸습니다.",
		whopattern = "(.+)|1이;가; ",

		you = "",
		are = "은",

		warn1 = "당신은 폭탄입니다!",
		warn2 = "님이 폭탄입니다!",
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger = "迦顿男爵死亡了。",

		trigger1 = "^(.+)受(.+)了活化炸弹",

		you = "你",
		are = "到",

		warn1 = "你是炸弹人！向着夕阳奔跑吧！",
		warn2 = "是炸弹人！向着夕阳奔跑吧！",
	}
		or
	{
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
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
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
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

if (GetLocale() == "koKR") then
	function BigWigsBaronGeddon:Event()
		local _, _, EPlayer = string.find(arg1, self.loc.trigger1)
		if (EPlayer) then
			if (EPlayer == self.loc.you and not self:GetOpt("notYouBomb")) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
			elseif (not self:GetOpt("notElseBomb")) then
				local _, _, EWho = string.find(EPlayer, self.loc.whopattern)
				self:TriggerEvent("BIGWIGS_MESSAGE", EWho .. self.loc.warn2, "Yellow")
				self:TriggerEvent("BIGWIGS_SENDTELL", EWho, self.loc.warn1)
			end

			if (not self:GetOpt("notIcon")) then
				for i=1,GetNumRaidMembers() do
					if UnitName("raid"..i) == EPlayer then
						SetRaidTargetIcon("raid"..i, 8)
					end
				end
			end
		end
	end
else
	function BigWigsBaronGeddon:Event()
		local _, _, EPlayer, EType = string.find(arg1, self.loc.trigger1)
		if (EPlayer and EType) then
			if (EPlayer == self.loc.you and EType == self.loc.are and not self:GetOpt("notYouBomb")) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
			elseif (not self:GetOpt("notElseBomb")) then
				self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn2, "Yellow")
				self:TriggerEvent("BIGWIGS_SENDTELL", EPlayer, self.loc.warn1)
			end

			if (not self:GetOpt("notIcon")) then
				for i=1, GetNumRaidMembers() do
					if UnitName("raid"..i) == EPlayer then
						SetRaidTargetIcon("raid"..i, 8)
					end
				end
			end
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsBaronGeddon:RegisterForLoad()