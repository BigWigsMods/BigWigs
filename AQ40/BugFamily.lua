BigWigsBugFamily = AceAddon:new({
	name          = "BigWigsBugFamily",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = GetLocale() == "koKR" and { "군주 크리", "공주 야우즈", "벰" } 
		or { "Lord Kri", "Princess Yauj", "Vem" },

	loc = GetLocale() == "koKR" and {
		bossname = "벌레 무리 - 군주 크리, 공주 야우즈, 벰",
		disabletrigger1 = "군주 크리|1이;가; 죽었습니다.",
		disabletrigger2 = "공주 야우즈|1이;가; 죽었습니다.",
		disabletrigger3 = "벰|1이;가; 죽었습니다.",
		bosskill = "벌레 무리 중 하나를 물리쳤습니다!",

		healtrigger = "공주 야우즈|1이;가; 상급 치유|1을;를; 시전합니다.",
		healwarn = "치유 시전 - 시전 방해!",	
	} or { 
		bossname = "Bug Family - Lord Kri, Princess Yauj and Vem",
		disabletrigger1 = "Lord Kri dies.",
		disabletrigger2 = "Princess Yauj dies.",
		disabletrigger3 = "Vem dies.",
		bosskill = "The Bug Family has been defeated!",

		healtrigger = "Princess Yauj begins to cast Great Heal.",
		healwarn = "Casting heal - interrupt it!",

		feartrigger = "is afflicted by Fear%.",
    fearstatus = false,
    fearbar = "AE Fear",
    fearwarn1 = "AE Fear! Next in 20 Seconds!",
    fearwarn2 = "AE Fear in 5 Seconds!",
	},
})

function BigWigsBugFamily:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsBugFamily:Enable()
	self.disabled = nil
	self.deaths = 0
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE","FearEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE","FearEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE","FearEvent")
	self:RegisterEvent("BIGWIGS_MESSAGE","FearEvent")
end

function BigWigsBugFamily:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsBugFamily:FearEvent(msgtxt)
    if (msgtxt) then
        if ( self.fearstatus and msgtxt == self.loc.fearwarn2) then
            self.fearstatus = false
        end
    else
        if (not self.fearstatus and string.find(arg1, self.loc.feartrigger)) then
            self.fearstatus = true
        self:TriggerEvent("BIGWIGS_BAR_START", self.loc.fearbar, 20, 2, "Green", "Interface\\Icons\\Spell_Shadow_Possession")
            self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.fearbar, 10, "Yellow")
            self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.fearbar, 15, "Red")
            self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.fearwarn1, "Red")
            self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.fearwarn2, 15, "Orange")
        end
    end
end

function BigWigsBugFamily:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger1
	or arg1 == self.loc.disabletrigger2
	or arg1 == self.loc.disabletrigger3) then
		self.deaths = self.deaths + 1
		if ( self.deaths == 3 ) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
			self:Disable()
		end
	end
end

function BigWigsBugFamily:PLAYER_REGEN_ENABLED()
	self.deaths = 0
end

function BigWigsBugFamily:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (arg1 == self.loc.healtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.healwarn, "Orange")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsBugFamily:RegisterForLoad()