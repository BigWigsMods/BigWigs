local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsGrobbulus = AceAddon:new({
	name          = "BigWigsGrobbulus",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Grobbulus"),
	bossname = bboss("Grobbulus"),

	toggleoptions = GetLocale() == "koKR" and {
		notYouInjected = "자신의 돌연변이 경고",
		notElseInjected = "다른 사람의 돌연변이 경고",
		notIcon = "돌연변이에게 해골 표시(승급 필요)",
		notBosskill = "보스 사망 알림",
	} or { 
		notYouInjected = "Warn when you are injected",
		notElseInjected = "Warn when others are injected",
		notIcon = "Put a Skull icon on the person who's injected. (Requires promoted or higher)",
		notBosskill = "Boss death",
	},

	optionorder = {"notYouInjected", "notElseInjected", "notIcon", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		disabletrigger = "그라불루스|1이;가; 죽었습니다.",

		trigger1 = "(.*)돌연변이 유발에 걸렸습니다.",

		whopattern = "(.+)|1이;가; ",
		you = "",
		are = "are",

		warn1 = "당신은 돌연변이 유발에 걸렸습니다.",
		warn2 = " 님이 돌연변이 유발에 걸렸습니다.",
		bosskill = "그라불루스를 물리쳤습니다!",
	} or {
		disabletrigger = "Grobbulus dies.",

		trigger1 = "^([^%s]+) ([^%s]+) afflicted by Mutating Injection",

		you = "You",
		are = "are",

		warn1 = "You are injected!",
		warn2 = " is Injected!",
		bosskill = "Grobbulus has been defeated!",
	},
})

function BigWigsGrobbulus:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsGrobbulus:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsGrobbulus:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsGrobbulus:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if (not self:GetOpt("notBosskill")) then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

if GetLocale() == "koKR" then 
	function BigWigsGrobbulus:Event()
		local _, _, EPlayer = string.find(arg1, self.loc.trigger1)
		if (EPlayer) then
			if (EPlayer == self.loc.you and not self:GetOpt("notYouInjected")) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
			elseif (not self:GetOpt("notElseInjected")) then 
				_, _, EPlayer = string.find(EPlayer, self.loc.whopattern)
				self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn2, "Yellow")
				self:TriggerEvent("BIGWIGS_SENDTELL", EPlayer, self.loc.warn1)
			end
			if (not self:GetOpt("notIcon")) then
				if EPlayer == self.loc.you then
					EPlayer = UnitName('player')
				end
				for i=1, GetNumRaidMembers() do
					if UnitName("raid"..i) == EPlayer then
						SetRaidTargetIcon("raid"..i, 8)
					end
				end
			end
		end
	end
else
	function BigWigsGrobbulus:Event()
		local _, _, EPlayer, EType = string.find(arg1, self.loc.trigger1)
		if (EPlayer and EType) then
			if (EPlayer == self.loc.you and EType == self.loc.are and not self:GetOpt("notYouInjected")) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true)
			elseif (not self:GetOpt("notElseInjected")) then 
				self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn2, "Yellow")
				self:TriggerEvent("BIGWIGS_SENDTELL", EPlayer, self.loc.warn1)
			end
			if (not self:GetOpt("notIcon")) then
				if EPlayer == self.loc.you then
					EPlayer = UnitName('player')
				end
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
BigWigsGrobbulus:RegisterForLoad()
