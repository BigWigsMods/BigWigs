if not IsTestBuild() then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Stone Legion Generals", 2296, 2425)
if not mod then return end
mod:RegisterEnableMob(
	165318, -- General Kaal
	170323) -- General Grashaal
mod.engageId = 2417
--mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

--------------------------------------------------------------------------------
-- Initialization
--

local stoneShattererMarker = mod:AddMarkerOption(false, "player", 1, 334765, 1, 2, 3, 4) -- Stone Shatterer
local petrificationMarker = mod:AddMarkerOption(false, "player", 5, 334541, 5, 6, 7) -- Curse of Petrification
function mod:GetOptions()
	return {
		--[[ General Kaal ]]--
		329636, -- Basalt Form
		333387, -- Wicked Blade
		334765, -- Stone Shatterer
		stoneShattererMarker,
		334929, -- Serrated Swipe

		--[[ General Grashaal ]]--
		329808, -- Granite Form
		{339164, "SAY"}, -- Reverberating Leap
		337643, -- Unstable Footing
		334498, -- Seismic Upheaval
		{334541, "SAY", "SAY_COUNTDOWN"}, -- Curse of Petrification
		petrificationMarker,
		{339690, "TANK"}, -- Stone Breaker's Combo
		{339728, "TANK"}, -- Pulverize

		--[[ Stone Legion Goliath ]]--
		337741, -- Breath of Corruption
	}, {
		[329636] = -22284, -- General Kaal
		[329808] = -22288, -- General Grashaal
		[337741] = -22389, -- Stone Legion Goliath
	}
end

function mod:OnBossEnable()
	--[[ General (pun intended) ]]--
	self:Log("SPELL_AURA_APPLIED", "GroundDamage", 337643) -- Unstable Footing
	self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 337643)
	self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 337643)

	--[[ General Kaal ]]--
	self:Log("SPELL_AURA_APPLIED", "BasaltForm", 329636)
	self:Log("SPELL_CAST_START", "WickedBlade", 333387)
	self:Log("SPELL_CAST_START", "StoneShatterer", 334765)
	self:Log("SPELL_AURA_APPLIED", "StoneShattererApplied", 334765)
	self:Log("SPELL_AURA_REMOVED", "StoneShattererRemoved", 334765)
	self:Log("SPELL_CAST_START", "SerratedSwipe", 334929)

	--[[ General Grashaal ]]--
	self:Log("SPELL_AURA_APPLIED", "GraniteForm", 329808)
	self:Log("SPELL_CAST_START", "ReverberatingLeap", 339164, 334009, 334004) -- TODO: remove unused
	self:Log("SPELL_CAST_START", "SeismicUpheaval", 334498)
	self:Log("SPELL_AURA_APPLIED", "CurseOfPetrificationApplied", 334541)
	self:Log("SPELL_AURA_REMOVED", "CurseOfPetrificationRemoved", 334541)
	self:Log("SPELL_CAST_START", "StoneBreakersCombo", 339690)
	self:Log("SPELL_CAST_START", "Pulverize", 339728)

	--[[ Stone Legion Goliath ]]--
	self:Log("SPELL_CAST_START", "BreathOfCorruption", 337741)

end

function mod:OnEngage()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

--[[ General (pun intended) ]]--
do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 1.5 then
				prev = t
				self:PersonalMessage(args.spellId, "underyou")
				self:PlaySound(args.spellId, "alarm")
			end
		end
	end
end

--[[ General Kaal ]]--
function mod:BasaltForm(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
end

function mod:WickedBlade(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end

function mod:StoneShatterer(args)
	self:Message2(args.spellId, "orange", CL.casting:format(args.spellName))
	--self:Bar(args.spellId, 42)
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}

	function mod:StoneShattererApplied(args)
		local count = #playerIcons+1
		playerList[count] = args.destName
		playerIcons[count] = count
		if count == 1 then
			--self:CDBar(args.spellId, 40)
		end

		if self:Dispeller("magic") then
			self:PlaySound(args.spellId, "alarm", nil, playerList)
		elseif self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end

		if self:GetOption(stoneShattererMarker) then
			SetRaidTarget(args.destName, count)
		end

		self:TargetsMessage(args.spellId, "orange", playerList, self:Mythic() and 4 or 3, nil, nil, nil, playerIcons)
	end

	function mod:StoneShattererRemoved(args)
		if self:GetOption(stoneShattererMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

function mod:SerratedSwipe(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 42)
end



--[[ General Grashaal ]]--
function mod:GraniteForm(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(339164)
		end
		self:TargetMessage2(339164, "red", player)
		self:PlaySound(339164, "warning")
	end

	function mod:ReverberatingLeap(args)
		self:GetUnitTarget(printTarget, 0.3, args.sourceGUID)
	end
end

function mod:SeismicUpheaval(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 42)
end

do
	local playerList, playerIcons = mod:NewTargetList(), {}

	function mod:CurseOfPetrificationApplied(args)
		local count = #playerIcons+1
		playerList[count] = args.destName
		playerIcons[count] = count + 4
		if count == 1 then
			--self:CDBar(args.spellId, 40)
		end

		if self:Dispeller("magic") then
			self:PlaySound(args.spellId, "alarm", nil, playerList)
		elseif self:Me(args.destGUID) then
			self:PlaySound(args.spellId, "alarm")
		end

		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, 10)
		end

		if self:GetOption(stoneShattererMarker) then
			SetRaidTarget(args.destName, playerIcons[count])
		end

		self:TargetsMessage(args.spellId, "orange", playerList, self:Mythic() and 4 or 3, nil, nil, nil, playerIcons)
	end

	function mod:CurseOfPetrificationRemoved(args)
		if self:GetOption(stoneShattererMarker) then
			SetRaidTarget(args.destName, 0)
		end
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
	end
end

function mod:StoneBreakersCombo(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "long")
	--self:Bar(args.spellId, 42)
end

function mod:Pulverize(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "info")
	--self:Bar(args.spellId, 42)
end

--[[ Stone Legion Goliath ]]--
function mod:BreathOfCorruption(args)
	self:Message2(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	--self:Bar(args.spellId, 42)
end
