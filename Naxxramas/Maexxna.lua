local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsMaexxna = AceAddon:new({
	name          = "BigWigsMaexxna",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Maexxna"),
	bossname = bboss("Maexxna"),

	toggleoptions = {
		notBosskill = "Boss death",
		notStart = "Start warning",
		notSpray = "Web Spray warning",
		notSpray10Sec = "Web Spray 10-sec warning",
		notSprayBar = "Web Spray timerbar",
		notEnrageSoon = "Enrage soon warning",
		notEnrageWarn = "Enrage warning",
	},

	optionorder = {"notStart", "notSpray", "notSpray10Sec", "notSprayBar", "notEnrageSoon","notEnrageWarn", "notBosskill"},

	loc = { 
		disabletrigger = "Maexxna dies.",		
		bosskill = "Maexxna has been defeated!",

		webwraptrigger = "(.*) (.*) afflicted by Web Wrap.",
		webspraytrigger = "is afflicted by Web Spray.",

		enragetrigger = "Maexxna gains Enrage.",

		startwarn = "Maexxna engaged! 40 seconds until Web Spray!",
		webwrapwarn = "%s is all wrapped up!",
		webwrapyouwarn = "You are all wrapped up!",
		webspraywarn10sec = "10 seconds until Web Spray!",
		webspraywarn = "Web Spray! 40 seconds until next!",
		enragewarn = "Enrage - Give it all you got!",
		enragesoonwarn = "Enrage Soon - Get Ready!",

		webspraybar = "Web Spray",

		you = "You",
		are = "are",
	},
})

function BigWigsMaexxna:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsMaexxna:Enable()
	self.disabled = nil
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
end

function BigWigsMaexxna:Disable()
	self.disabled = true
	self.enrageannounced = nil
	self:UnregisterAllEvents()
end

function BigWigsMaexxna:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green") end
		self:Disable()
	end
end

function BigWigsMaexxna:Event()
	-- web spray warning
	if string.find(arg1, self.loc.webspraytrigger) then
		if not webspraytime or (time() - webspraytime > 8) then
			webspraytime = time()
			if not self:GetOpt("notSpray") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.webspraywarn, "Red") end
			if not self:GetOpt("notSpray10Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.webspraywarn10sec, 30, "Yellow") end
			if not self:GetOpt("notSprayBar") then self:TriggerEvent("BIGWIGS_BAR_START", self.loc.webspraybar, 40, 1, "Yellow", "Interface\\Icons\\Ability_Ensnare") end
		end
	end

	-- let people know when people get wrapped up
	-- this might be too spammy, since I don't know the fight, so I disabled it. -Ammo
--	local _,_, EPlayer, EType = string.find(arg1, self.loc.trigger3)
--	if (EPlayer and EType) then
--		if (EPlayer == self.loc.you and EType == self.loc.are) then
--			if not self:TriggerEvent("BIGWIGS_MESSAGE", string.format(self.loc.webwrapwarn, UnitName("player")), "Red", true)
--		else
--			self:TriggerEvent("BIGWIGS_MESSAGE", string.format(self.loc.webwrapwarn, EPlayer), "Yellow")
--			self:TriggerEvent("BIGWIGS_SENDTELL", EPlayer, self.loc.webwrapyouwarn)
--		end
--	end

end

function BigWigsMaexxna:PLAYER_REGEN_ENABLED()
	self:Disable()
end

function BigWigsMaexxna:PLAYER_REGEN_DISABLED()
	-- see if anyone's targetting the silly spider
	local foundboss = nil
	for i = 1,40 do
		local unit = "raid"..i.."target"
		if( UnitExists(unit) and
				UnitName(unit) and not UnitIsCorpse(unit) and
				not UnitIsDead(unit) and
				UnitName(unit) == self.bossname) then
			foundboss = TRUE
		end
	end

	if foundboss then
		if not self:GetOpt("notStart") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.startwarn, "Orange") end
		if not self:GetOpt("notSpray10Sec") then self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.webspraywarn10sec, 30, "Yellow") end
		if not self:GetOpt("notSprayBar") then self:TriggerEvent("BIGWIGS_BAR_START", self.loc.webspraybar, 40, 1, "Yellow", "Interface\\Icons\\Ability_Ensnare") end
	end
end

function BigWigsMaexxna:CHAT_MSG_MONSTER_EMOTE()
	if (not self:GetOpt("notEnrageWarn") and arg1 == self.loc.enragektrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragekwarn, "Red")
	end
end

function BigWigsMaexxna:UNIT_HEALTH()
	if (UnitName(arg1) == self.bossname) then
		local health = UnitHealth(arg1)
		if (health > 30 and health <= 33) then
			if not self:GetOpt("notEnrageSoon") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragesoonwarn, "Red") end
			self.enrageannounced = true
		elseif (health > 40 and self.enrageannounced) then
			self.enrageannounced = nil
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsMaexxna:RegisterForLoad()