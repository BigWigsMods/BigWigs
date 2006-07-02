local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsJindo = AceAddon:new({
	name          = "BigWigsJindo",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Zul'Gurub"),
	enabletrigger = bboss("Jin'do the Hexxer"),
	bossname = bboss("Jin'do the Hexxer"),

	toggleoptions = {
		notBrainWash = "Announce brainwash totems",
		notHealing = "Announce healing totems",
		notBosskill = "Boss death",
	},

	optionorder = { "notBrainWash", "notHealing", "notBosskill" },

	loc = {
		disabletrigger = "Jin'do the Hexxer dies.",

		triggerbrainwash = "Jin'do the Hexxer casts Summon Brain Wash Totem.",
		triggerhealing = "Jin'do the Hexxer casts Powerful Healing Ward.",

		warnbrainwash = "Brain Wash Totem!",
		warnhealing = "Healing Totem!",

		bosskill = "Jin'do the Hexxer has been defeated!",
	},
})

function BigWigsJindo:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsJindo:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsJindo:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsJindo:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsJindo:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if arg1 == self.loc.triggerbrainwash and not self:GetOpt("notBrainWash") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warnbrainwash, "Orange")
	elseif arg1 == self.loc.triggerhealing and not self:GetOpt("notHealing") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warnhealing, "Red" )
	end 
end

--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsJindo:RegisterForLoad()