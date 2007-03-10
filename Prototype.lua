--------------------------------
--      Module Prototype      --
--------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs")
local BB = AceLibrary("Babble-Boss-2.2")

BigWigs.modulePrototype.core = BigWigs
BigWigs.modulePrototype.debugFrame = ChatFrame5
BigWigs.modulePrototype.revision = 1 -- To be overridden by the module!

function BigWigs.modulePrototype:OnInitialize()
	-- Unconditionally register, this shouldn't happen from any other place
	-- anyway.
	self.core:RegisterModule(self.name, self)
end

function BigWigs.modulePrototype:IsBossModule()
	return self.zonename and self.enabletrigger and true
end

function BigWigs.modulePrototype:GenericBossDeath(msg)
	if msg == string.format(UNITDIESOTHER, self:ToString()) then
		if self.db.profile.bosskill then self:TriggerEvent("BigWigs_Message", string.format(L["%s has been defeated"], self:ToString()), "Bosskill", nil, "Victory") end
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		if self:IsDebugging() then
			self:LevelDebug(1, "Boss dead, disabling.")
		end
		self.core:ToggleModuleActive(self, false)
	end
end

local function populateScanTable(mod)
	if type(mod.scanTable) == "table" then return end
	local x = mod.enabletrigger
	if type(x) == "string" then x = {x} end
	mod.scanTable = {}
	for k, v in pairs(x) do
		rawset(mod.scanTable, #mod.scanTable + 1, v)
	end
	local a = mod.wipemobs
	if a then
		if type(a) == "string" then a = {a} end
		for k,v in pairs(a) do rawset(mod.scanTable, #mod.scanTable + 1, v) end
	end
end

function BigWigs.modulePrototype:Scan()
	if not self.scanTable then populateScanTable(self) end

	if UnitExists("target") and UnitAffectingCombat("target") then
		local target = UnitName("target")
		for _, mob in pairs(self.scanTable) do
			if target == mob then
				return true
			end
		end
	end

	if UnitExists("focus") and UnitAffectingCombat("focus") then
		local target = UnitName("focus")
		for _, mob in pairs(self.scanTable) do
			if target == mob then
				return true
			end
		end
	end

	local num = GetNumRaidMembers()
	for i = 1, num do
		local raidUnit = string.format("raid%starget", i)
		if UnitExists(raidUnit) and UnitAffectingCombat(raidUnit) then
			local target = UnitName(raidUnit)
			for _, mob in ipairs(self.scanTable) do
				if target == mob then
					return true
				end
			end
		end
	end
	return false
end

function BigWigs.modulePrototype:GetEngageSync()
	return "BossEngaged"
end

-- Really not much of a validation, but at least it validates that the sync is
-- remotely related to the module :P
function BigWigs.modulePrototype:ValidateEngageSync(sync, rest)
	if type(sync) ~= "string" or type(rest) ~= "string" then return false end
	if sync ~= self:GetEngageSync() then return false end
	local boss = BB:HasReverseTranslation(rest) and BB:GetReverseTranslation(rest) or rest
	if not self.scanTable then populateScanTable(self) end
	for _, mob in pairs(self.scanTable) do
		local translated = BB:HasReverseTranslation(mob) and BB:GetReverseTranslation(mob) or mob
		if translated == rest or mob == rest then return true end
	end
	return boss == self:ToString() or rest == self:ToString()
end

function BigWigs.modulePrototype:CheckForEngage()
	local go = self:Scan()
	local running = self:IsEventScheduled(self:ToString().."_CheckStart")
	if go then
		if self:IsDebugging() then
			self:LevelDebug(1, "Scan returned true, engaging.")
		end
		self:CancelScheduledEvent(self:ToString().."_CheckStart")
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		local moduleName = BB:HasReverseTranslation(self:ToString()) and BB:GetReverseTranslation(self:ToString()) or self:ToString()
		self:TriggerEvent("BigWigs_SendSync", self:GetEngageSync().." "..moduleName)
	elseif not running then
		self:ScheduleRepeatingEvent(self:ToString().."_CheckStart", self.CheckForEngage, .5, self)
	end
end

function BigWigs.modulePrototype:CheckForWipe()
	local running = self:IsEventScheduled(self:ToString().."_CheckWipe")
	if IsFeignDeath() then
		if not running then
			self:ScheduleRepeatingEvent(self:ToString().."_CheckWipe", self.CheckForWipe, 2, self)
		end
		return
	end

	local go = self:Scan()
	if not go then
		if self:IsDebugging() then
			self:LevelDebug(1, "Rebooting module.")
		end
		if type(self.scanTable) == "table" then
			for k in pairs(self.scanTable) do
				self.scanTable[k] = nil
			end
		end
		self.scanTable = nil
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		self:TriggerEvent("BigWigs_RebootModule", self)
	elseif not running then
		self:ScheduleRepeatingEvent(self:ToString().."_CheckWipe", self.CheckForWipe, 2, self)
	end
end

function BigWigs.modulePrototype:IsRegistered()
	return self.registered
end

-- Shortcuts for common actions.

function BigWigs.modulePrototype:Message(text, priority, ...)
	self:TriggerEvent("BigWigs_Message", text, priority, ...)
end

function BigWigs.modulePrototype:DelayedMessage(delay, text, priority, ...)
	return self:ScheduleEvent("BigWigs_Message", delay, text, priority, ...)
end

function BigWigs.modulePrototype:Bar(text, length, icon, ...)
	self:TriggerEvent("BigWigs_StartBar", self, text, length, "Interface\\Icons\\" .. icon, ...)
end

function BigWigs.modulePrototype:Sync(sync)
	self:TriggerEvent("BigWigs_SendSync", sync)
end

function BigWigs.modulePrototype:Whisper(player, text)
	self:TriggerEvent("BigWigs_SendTell", player, text)
end

function BigWigs.modulePrototype:Icon( player )
	self:TriggerEvent("BigWigs_SetRaidIcon", player )
end
