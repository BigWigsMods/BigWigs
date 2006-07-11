local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsThekal = AceAddon:new({
	name          = "BigWigsThekal",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Zul'Gurub"),
	enabletrigger = bboss("High Priest Thekal"),
	bossname = bboss("High Priest Thekal"),

	toggleoptions = {
		notTigers = "Warn on incoming tigers",
		notHeal = "Show heal interrupt warnings",
		notBosskill = "Boss death",
	},

	optionorder = { "notTigers", "notHeal", "notBosskill" },

	loc = {
		trigger1 = "High Priest Thekal performs Summon Zulian Guardians.",
		trigger2 = "Zealot Lor'Khan begins to cast Great Heal.",
		warn1 = "Incoming Tigers!",
		warn2 = "Lor'Khan Casting Heal - Interrupt it!",

		disabletrigger = "High Priest Thekal dies.",

		bosskill = "High Priest Thekal has been defeated!",
	},
})

function BigWigsThekal:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsThekal:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsThekal:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsThekal:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if arg1 == self.loc.disabletrigger then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsThekal:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (arg1 == self.loc.trigger1) and not self:GetOpt("notTigers") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Yellow")
	elseif (arg1 == self.loc.trigger2) and not self:GetOpt("notHeal") then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Orange")
	end
end

--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsThekal:RegisterForLoad()