local Metro = Metrognome:GetInstance("1")
local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsLoatheb = AceAddon:new({
	name          = "BigWigsLoatheb",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Naxxramas"),
	enabletrigger = bboss("Loatheb"),
	bossname = bboss("Loatheb"),

	toggleoptions = {
		notBosskill = "Boss death",
		notDoomWarn = "Warn on impending doom",
		notDoom5Sec = "Warn 5 seconds before impending doom",
		notDoomBar = "Show Inevitable Doom bar",
		notEnrageSoon = "Enrage soon warning",
		notEnrageWarn = "Enrage warning",
	},

	optionorder = {"notDoomWarn", "notDoom5Sec", "notDoomBar", "notEnrageSoon","notEnrageWarn", "notBosskill"},

	loc = {
		disabletrigger = "Loatheb dies.",		
		bosskill = "Loatheb has been defeated!",

		doombar = "Inevitable Doom",
		doomwarn = "Inevitable Doom",
		doomwarn5sec = "Inevitable Doom in 5 seconds",
		
		doomtrigger = "^([^%s]+) is afflicted by Inevitable Doom.",

		you = "You",
		are = "are",
	},
})

function BigWigsLoatheb:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsLoatheb:Enable()
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
	self:RegisterEvent("BIGWIGS_SYNC_LOATHEBSTART")
	self:RegisterEvent("BIGWIGS_SYNC_LOATHEBDOOM")
	
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "LOATHEBSTART", 10)
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "LOATHEBDOOM", 10)
	Metro:Register("BigWigs_Loatheb_CheckWipe", self.PLAYER_REGEN_ENABLED, 2, self)	
end

function BigWigsLoatheb:Disable()
	self.disabled = true
	self.enrageannounced = nil
	self:UnregisterAllEvents()

	Metro:Unregister("BigWigs_Loatheb_CheckWipe")
end


function BigWigsLoatheb:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green") end
		self:Disable()
	end
end

function BigWigsLoatheb:Event()
	-- web spray warning
	if string.find(arg1, self.loc.doomtrigger) then
		if not self.doomtime or (time() - self.doomtime > 8) then
			self.doomtime = time()
			self:TriggerEvent("BIGWIGS_SYNC_SEND", "LOATHEBDOOM")
		end
	end
end

function BigWigsLoatheb:Scan()
	if (UnitName("target") == self.bossname and UnitAffectingCombat("target")) then
		return true
	elseif (UnitName("playertarget") == self.bossname and UnitAffectingCombat("playertarget")) then
		return true
	else
		local i
		for i = 1, GetNumRaidMembers(), 1 do
			if (UnitName("raid"..i.."target") == self.bossname and UnitAffectingCombat("raid"..i.."target")) then
				return true
			end
		end
	end
	return false
end

function BigWigsLoatheb:PLAYER_REGEN_DISABLED()
	local go = self:Scan()
	if (go) then
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "LOATHEBSTART")
	end
end

function BigWigsLoatheb:PLAYER_REGEN_ENABLED()
	local go = self:Scan()
	local _,_,running,_ = Metro:Status("BigWigs_Loatheb_CheckWipe")
	if (not go) then
		self:Disable()
		Metro:Stop("BigWigs_Loatheb_CheckWipe")
	elseif (not running) then
		Metro:Start("BigWigs_Loatheb_CheckWipe")
	end
end

function BigWigsLoatheb:BIGWIGS_SYNC_LOATHEBSTART()
	if not self:GetOpt("notDoomBar") then
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.doombar, 120, 2, "Red", "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
	end
	if not self:GetOpt("notDoomWarn") then
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.doomwarn5sec, 115);
	end
end

function BigWigsLoatheb:BIGWIGS_SYNC_LOATHEBDOOM()
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE", self.loc.doomwarn);
	if not self:GetOpt("notDoomBar") then
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.doombar, 30, 2, "Red", "Interface\\Icons\\Spell_Shadow_NightOfTheDead")
	end
	if not self:GetOpt("notDoomWarn") then
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.doomwarn5sec, 25);
	end
end


function BigWigsLoatheb:CHAT_MSG_MONSTER_EMOTE()
	if (not self:GetOpt("notEnrageWarn") and arg1 == self.loc.enragetrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Red")
	end
end

function BigWigsLoatheb:UNIT_HEALTH()
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
BigWigsLoatheb:RegisterForLoad()
