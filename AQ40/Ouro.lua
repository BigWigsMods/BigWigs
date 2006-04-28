BigWigsOuro = AceAddon:new({
	name          = "BigWigsOuro",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = "Ouro",

	loc = {
		bossname = "Ouro",
		disabletrigger = "Ouro dies.",

		sweeptrigger = "Ouro begins to cast Sweep",
		sweepannounce = "Sweep!",
		sweepwarn = "5 seconds until Sweep! GET OUT",
		sweepbartext = "Sweep",

		sandblasttrigger = "Ouro begins to cast Sand Blast",
		sandblastannounce = "Incoming Sand Blast!",
		sandblastwarn = "5 seconds until Sand Blast",
		sandblastbartext = "Sand Blast",

		emergetrigger = "Dirt Mound casts Summon Ouro Scarabs.",
		emergeannounce = "Ouro has emerged! Kill them bugs!",
		emergewarn1 = "15 seconds until Ouro submerges!",
		emergebartext = "Ouro submerge",

		berserksoonwarn = "Berserk Soon - Get Ready!",
		bosskill = "Ouro has been defeated!",
	},
})

function BigWigsOuro:Initialize()
	self.disabled = true
	self.berserkannounced = nil
	BigWigs:RegisterModule(self)
end

function BigWigsOuro:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsOuro:Disable()
	self.disabled = true
	self.berserkannounced = nil
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.sweepbartext)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.sandblastbartext)
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.emergebartext)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.sweepwarn)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.sandblastwarn)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.emergewarn)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.sweepbartext, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.sweepbartext, 15)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.sandblastbartext, 5)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.sandblastbartext, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.emergebartext, 30)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.emergebartext, 40)
end

function BigWigsOuro:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsOuro:UNIT_HEALTH()
	if (UnitName(arg1) == self.loc.bossname) then
		local health = UnitHealth(arg1)
		if (health > 20 and health <= 23) then
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.berserksoonwarn, "Red")
			self.berserkannounced = true
		elseif (health > 30 and self.berserkannounced) then
			self.berserkannounced = nil
		end
	end
end

function BigWigsOuro:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.sweeptrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.sweepannounce, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.sweepwarn, 15, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.sweepbartext, 20, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SoulBurn")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sweepbartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sweepbartext, 15, "Red")
	elseif (string.find(arg1, self.loc.sandblasttrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.sandblastannounce, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.sandblastwarn, 15, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.sandblastbartext, 20, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SoulBurn")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sandblastbartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.sandblastbartext, 15, "Red")
	elseif (string.find(arg1, self.loc.emergetrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.emergeannounce, "Red")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.emergewarn, 15, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.emergebartext, 20, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SoulBurn")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.emergebartext, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.emergebartext, 15, "Red")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsOuro:RegisterForLoad()