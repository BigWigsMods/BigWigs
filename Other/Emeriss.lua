local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsEmeriss = AceAddon:new({
	name          = "BigWigsEmeriss",
	cmd           = AceChatCmd:new({}, {}),

	zonename = { BabbleLib:GetInstance("Zone 1.2")("Duskwood"), BabbleLib:GetInstance("Zone 1.2")("The Hinterlands"),
			BabbleLib:GetInstance("Zone 1.2")("Ashenvale"), BabbleLib:GetInstance("Zone 1.2")("Feralas") },

	enabletrigger = bboss("Emeriss"),
	bossname = bboss("Emeriss"),

	toggleoptions = {
		notNoxious = "Noxious breath warning",
		notNoxious5Sec = "Noxious breath 5-sec warning",
		notNoxiusBar = "Noxious breath timerbar",
		notVolatileYou = "Volatile infection on you warning",
		notVolatileOther = "Volatile infection on others warning",
		notBosskill = "Boss death",
	},

	optionorder = {"notNoxious", "notNoxious5Sec", "notNoxiousBar", "notVolatileYou", "notVolatileOther", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		disabletrigger = "에메리스|1이;가; 죽었습니다.",

		trigger1 = "(.*)대지의 오염에 걸렸습니다.",
		trigger2 = "에메리스의 산성 숨결에 의해",

		warn1 = "당신은 대지의 오염에 걸렸습니다!",
		warn2 = "님이 대지의 오염에 걸렸습니다!",
		warn3 = "5초후 산성 숨결!",
		warn4 = "산성 숨결 - 30초후 재시전!",
		bosskill = "에메리스를 물리쳤습니다!",

		isyou = "",
		whopattern = "(.+)|1이;가; ",

		bar1text = "산성 숨결",
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger = "艾莫莉丝死亡了。",

		trigger1 = "^(.+)受(.+)了快速传染效果",
		trigger2 = "受到了毒性吐息效果的影响。",

		warn1 = "你中了快速传染！",
		warn2 = "中了快速传染！",
		warn3 = "5秒后发动毒性吐息！",
		warn4 = "毒性吐息 - 30秒后再次发动",
		bosskill = "艾莫莉丝被击败了！",

		isyou = "你",
		isare = "到",

		bar1text = "毒性吐息",
	}
		or
	{
		disabletrigger = "Emeriss dies.",

		trigger1 = "^([^%s]+) ([^%s]+) afflicted by Volatile Infection",
		trigger2 = "afflicted by Noxious Breath",

		warn1 = "You are afflicted by Volatile Infection!",
		warn2 = " is afflicted by Volatile Infection!",
		warn3 = "5 seconds until Noxious Breath!",
		warn4 = "Noxious Breath - 30 seconds till next!",
		bosskill = "Emeriss has been defeated!",

		isyou = "You",
		isare = "are",

		bar1text = "Noxious Breath",
	},
})

function BigWigsEmeriss:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsEmeriss:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsEmeriss:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar1text, 20)
	self.prior = nil
end

function BigWigsEmeriss:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

if (GetLocale() == "koKR") then
	function BigWigsEmeriss:Event()
		if (not self.prior and string.find(arg1, self.loc.trigger2)) then
			self.prior = true
			if not self:GetOpt("notNoxious") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red") end
			if not self:GetOpt("notNoxious5Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 25, "Red") end
			if not self:GetOpt("notNoxiousBar") then
				self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 30, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_LifeDrain02")
				self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
				self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
			end
		else
			local _,_, EPlayer = string.find(arg1, self.loc.trigger1)
			if (EPlayer) then
				if (EPlayer == self.loc.isyou ) then
					if not self:GetOpt("notVolatileYou") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true) end
				else
					local _,_, EWho = string.find(EPlayer, self.loc.whopattern)
					if not self:GetOpt("notVolatileOther") then 
						self:TriggerEvent("BIGWIGS_MESSAGE", EWho .. self.loc.warn2, "Yellow")
						self:TriggerEvent("BIGWIGS_SENDTELL", EWho, self.loc.warn1)
					end
				end
			end
		end
	end
else
	function BigWigsEmeriss:Event()
		if (not self.prior and string.find(arg1, self.loc.trigger2)) then
			self.prior = true
			if not self:GetOpt("notNoxious") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red") end
			if not self:GetOpt("notNoxious5Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 25, "Red") end
			if not self:GetOpt("notNoxiousBar") then
				self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 30, 1, "Yellow", "Interface\\Icons\\Spell_Shadow_LifeDrain02")
				self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
				self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
			end
		else
			local _,_, EPlayer, EType = string.find(arg1, self.loc.trigger1)
			if (EPlayer and EType) then
				if (EPlayer == self.loc.isyou and EType == self.loc.isare) then
					if not self:GetOpt("notVolatileYou") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red", true) end
				else
					if not self:GetOpt("notVolatileOther") then
						self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn2, "Yellow")
						self:TriggerEvent("BIGWIGS_SENDTELL", EPlayer, self.loc.warn1)
					end
				end
			end
		end
	end
end

function BigWigsLucifron:BIGWIGS_MESSAGE(text)
	if text == self.loc.warn3 then self.prior = nil end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsEmeriss:RegisterForLoad()