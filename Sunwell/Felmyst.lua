------------------------------
--      Are you local?      --
------------------------------

local boss = BB["Felmyst"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

local started = nil
local pName = UnitName("player")
local db = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Felmyst",
} end )

--[[
	Sunwell modules are PTR beta, as so localization is not supportd in any way
	This gives the authors the freedom to change the modules in way that
	can potentially break localization.
	Feel free to localize, just be aware that you may need to change it frequently.
]]--

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = BZ["Sunwell Plateau"]
mod.enabletrigger = boss
mod.toggleoptions = {"bosskill"}
mod.revision = tonumber(("$Revision$"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	started = nil

	self:AddCombatListener("SPELL_MISSED", "BurnResist", 45141)
	self:AddCombatListener("SPELL_CAST_START", "Meteor", 45150)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Burn", 46394)
	self:AddCombatListener("SPELL_AURA_REMOVED", "BurnRemove", 46394)
	self:AddCombatListener("SPELL_DAMAGE", "Stomp", 45185)
	self:AddCombatListener("UNIT_DIED", "GenericBossDeath")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:Throttle(300, "BrutallusBurn", "BrutallusBurnJump") --remove after brut is disabled on ptr

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Burn(player, spellID)
	if db.burn then
		local other = L["burn_other"]:format(player)
		if player == pName then
			self:Message(L["burn_you"], "Personal", true, "Alert", nil, spellID)
			self:Message(other, "Attention", nil, nil, true)
		else
			self:Message(other, "Attention", nil, nil, nil, spellID)
		end
		self:Bar(other, 60, spellID)
	end
end

function mod:Meteor()
	if db.meteor then
		self:Bar(L["meteor_bar"], 12, 45150)
	end
end

function mod:BurnRemove(player)
	if db.burn then
		self:TriggerEvent("BigWigs_StopBar", self, L["burn_other"]:format(player))
	end
end

function mod:BurnResist(player)
	if db.burnresist then
		self:Message(L["burn_resist"]:format(player), "Positive", nil, nil, nil, 45141)
	end
end

function mod:Stomp(player, spellID)
	if db.stomp then
		self:Message(L["stomp_message"]:format(player), "Urgent", nil, nil, nil, spellID)
		self:DelayedMessage(25, L["stomp_warning"], "Attention")
		self:Bar(L["stomp_bar"], 30, spellID)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if db.burn then
			self:Bar(L["burn_bar"], 20, 45141)
			self:DelayedMessage(15, L["burn_message"], "Attention")
		end
		if db.enrage then
			self:Enrage(360)
		end
	end
end
