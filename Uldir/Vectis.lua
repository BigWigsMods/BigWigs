
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Vectis", 1861, 2166)
if not mod then return end
mod:RegisterEnableMob(134442)
mod.engageId = 2134
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local omegaList = {}
local omegaMarker = {false, false, false, false}
local omegaIconMax = mod:Mythic() and 4 or 3
local omegaCountMythic = 0
local omegaMythicPreventIconsByGroup = false
local omegaMythicIconTracker = {}
local pathogenBombCount = 1
local contagionCount = 1
local immunosuppressionCount = 1
local nextLiquify = 0
local lingeringInfectionList = {}
local lingeringInfectionStacks = 0
local omegaVectorDuration = nil

local nameList = {}
local UpdateInfoBox

--------------------------------------------------------------------------------
-- Initialization
--

local omegaVectorMarker = mod:AddMarkerOption(false, "player", 1, 265143, 1, 2, 3, 4) -- Omega Vector
function mod:GetOptions()
	return {
		{265143, "SAY_COUNTDOWN"}, -- Omega Vector
		omegaVectorMarker,
		{265127, "INFOBOX"}, -- Lingering Infection
		{265178, "TANK"}, -- Evolving Affliction
		267242, -- Contagion
		{265212, "SAY", "ICON"}, -- Gestate
		265206, -- Immunosuppression
		265217, -- Liquefy
		266459, -- Plague Bomb
		-- Mythic
		{274990, "FLASH", "PROXIMITY"}, -- Bursting Lesions
	},{
		[265143] = "general",
		[274990] = CL.mythic,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_AURA_APPLIED", "OmegaVectorApplied", 265129, 265143) -- Normal, Heroic
	self:Log("SPELL_AURA_REMOVED", "OmegaVectorRemoved", 265129, 265143) -- Normal, Heroic
	self:Log("SPELL_AURA_APPLIED", "LingeringInfection", 265127)
	self:Log("SPELL_AURA_APPLIED_DOSE", "LingeringInfection", 265127)
	self:Log("SPELL_CAST_SUCCESS", "EvolvingAffliction", 265178)
	self:Log("SPELL_AURA_APPLIED", "EvolvingAfflictionApplied", 265178)
	self:Log("SPELL_AURA_APPLIED_DOSE", "EvolvingAfflictionApplied", 265178)
	self:Log("SPELL_CAST_START", "Contagion", 267242)
	self:Log("SPELL_CAST_SUCCESS", "Gestate", 265209)
	self:Log("SPELL_AURA_REMOVED", "GestateRemoved", 265212)
	self:Log("SPELL_CAST_START", "Immunosuppression", 265206)
	self:Death("PlagueAmalgamDeath", 135016)
	self:Log("SPELL_CAST_START", "Liquefy", 265217)
	self:Log("SPELL_AURA_REMOVED", "LiquefyRemoved", 265217)
	self:Log("SPELL_CAST_SUCCESS", "PlagueBomb", 266459)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "BurstingLesionsApplied", 274990)
	self:Log("SPELL_AURA_REMOVED", "BurstingLesionsRemoved", 274990)
end

function mod:OnEngage()
	omegaList = {}
	lingeringInfectionList = {}
	lingeringInfectionStacks = 0
	omegaMarker = {false, false, false, false}
	contagionCount = 1
	omegaVectorDuration = nil
	omegaIconMax = self:Mythic() and 4 or 3
	omegaCountMythic = 0
	omegaMythicIconTracker = {}
	omegaMythicPreventIconsByGroup = false

	self:Bar(267242, 20.5, CL.count:format(self:SpellName(267242), contagionCount)) -- Contagion
	self:Bar(265212, 10) -- Gestate

	nextLiquify = GetTime() + 90
	self:Bar(265217, 90) -- Liquefy

	self:OpenInfo(265127, self:SpellName(265127), "TEMP") -- Lingering Infection
	nameList = {}
	for unit in self:IterateGroup() do
		nameList[#nameList+1] = self:UnitName(unit)
	end
	UpdateInfoBox()
end

--------------------------------------------------------------------------------
-- Event Handlers
--

do
	local function sortFunc(x,y)
		local px, py = lingeringInfectionList[x] or -1, lingeringInfectionList[y] or -1
		if px == py then
			return x > y
		else
			return px > py
		end
	end
	local tsort = table.sort

	function UpdateInfoBox()
		tsort(nameList, sortFunc)
		for i = 1, 20 do
			local n = nameList[i]
			local result = lingeringInfectionList[n]
			if i % 2 == 0 then
				if result then
					local icon = GetRaidTargetIndex(n)
					mod:SetInfo(265127, i+19, (icon and ("  |T13700%d:0|t"):format(icon) or "  ") .. mod:ColorName(n))
					mod:SetInfo(265127, i+20, result)
					local vector = omegaList[n] and omegaList[n][1]
					if vector then
						local t = GetTime()
						local elap = t - vector
						local duration = omegaVectorDuration or 10
						local remaining = duration - elap
						if IsItemInRange(63427, n) then -- Worgsaw, 8yd
							mod:SetInfoBar(265127, i+19, remaining/duration, 0, 0, 1)
						else
							mod:SetInfoBar(265127, i+19, remaining/duration)
						end
					else
						mod:SetInfoBar(265127, i+19, 0)
					end
				else
					mod:SetInfo(265127, i+19, "")
					mod:SetInfo(265127, i+20, "")
					mod:SetInfoBar(265127, i+19, 0)
				end
			else
				if result then
					local icon = GetRaidTargetIndex(n)
					mod:SetInfo(265127, i, (icon and ("|T13700%d:0|t"):format(icon) or "") .. mod:ColorName(n))
					mod:SetInfo(265127, i+1, result)
					local vector = omegaList[n] and omegaList[n][1]
					if vector then
						local t = GetTime()
						local elap = t - vector
						local duration = omegaVectorDuration or 10
						local remaining = duration - elap
						if IsItemInRange(37727, n) then -- Ruby Acorn, 5yd
							mod:SetInfoBar(265127, i, remaining/duration, 0, 0, 1)
						else
							mod:SetInfoBar(265127, i, remaining/duration)
						end
					else
						mod:SetInfoBar(265127, i, 0)
					end
				else
					mod:SetInfo(265127, i, "")
					mod:SetInfo(265127, i+1, "")
					mod:SetInfoBar(265127, i, 0)
				end
			end
		end

		if mod.isEngaged then
			mod:SimpleTimer(UpdateInfoBox, 0.1)
		end
	end
end

function mod:OmegaVectorApplied(args)
	if not lingeringInfectionList[args.destName] then
		lingeringInfectionList[args.destName] = 0
	end

	if not omegaList[args.destName] then
		local t = GetTime()
		omegaList[args.destName] = {t}
		if not omegaVectorDuration then
			local _, _, _, expires = self:UnitDebuff(args.destName, args.spellId)
			if expires then -- Safety
				local duration = expires-t
				if duration > 9 then -- Safety
					omegaVectorDuration = duration
				end
			end
		end
	else
		local count = #omegaList[args.destName]
		local t = GetTime()
		omegaList[args.destName][count+1] = t
	end

	local icon
	for i = 1, omegaIconMax do
		-- If 2 debuffs on a player always mark with the one expiring first
		if omegaMarker[i] == args.destName and not icon then
			icon = i
		elseif not omegaMarker[i] then
			omegaMarker[i] = args.destName
			if not icon then
				icon = i
			end
			break
		end
	end

	if self:Mythic() and not omegaMythicPreventIconsByGroup then -- We *try* to restrict markers to specific groups on mythic
		omegaCountMythic = omegaCountMythic + 1
		if omegaCountMythic > 4 then -- First 4 random applications
			local index = UnitInRaid(args.destName)
			if omegaCountMythic < 9 then -- Between application 5-8 is when we scan what icon will be assigned to what group
				if not index then -- Something went wrong
					omegaMythicPreventIconsByGroup = true
				elseif index < 6 then -- Group 1
					if omegaMythicIconTracker[1] then -- Something went wrong or not using group tactic
						omegaMythicPreventIconsByGroup = true
					else
						omegaMythicIconTracker[1] = icon
					end
				elseif index < 11 then -- Group 2
					if omegaMythicIconTracker[2] then -- Something went wrong or not using group tactic
						omegaMythicPreventIconsByGroup = true
					else
						omegaMythicIconTracker[2] = icon
					end
				elseif index < 16 then -- Group 3
					if omegaMythicIconTracker[3] then -- Something went wrong or not using group tactic
						omegaMythicPreventIconsByGroup = true
					else
						omegaMythicIconTracker[3] = icon
					end
				else -- Group 4
					if omegaMythicIconTracker[4] then -- Something went wrong or not using group tactic
						omegaMythicPreventIconsByGroup = true
					else
						omegaMythicIconTracker[4] = icon
					end
				end
			else -- Application 9 or above, we can now set icon by group
				if not index then
					-- Fall back to normal icon setting
				elseif index < 6 then -- Group 1
					icon = omegaMythicIconTracker[1]
				elseif index < 11 then -- Group 2
					icon = omegaMythicIconTracker[2]
				elseif index < 16 then -- Group 3
					icon = omegaMythicIconTracker[3]
				else -- Group 4
					icon = omegaMythicIconTracker[4]
				end
			end
		end
	end

	if self:GetOption(omegaVectorMarker) and icon then
		SetRaidTarget(args.destName, icon)
	end

	if self:Me(args.destGUID) then
		self:PersonalMessage(265143, nil, icon and CL.count_icon:format(args.spellName, icon, icon) or nil)
		self:PlaySound(265143, "alarm")
		self:SayCountdown(265143, omegaVectorDuration or 10, icon) -- duration based on raid size
	end
end

function mod:OmegaVectorRemoved(args)
	tremove(omegaList[args.destName], 1)

	local icon, found = 0, false
	for i = 1, omegaIconMax do
		if omegaMarker[i] == args.destName then
			if found then
				icon = i
				break
			else
				found = true
				omegaMarker[i] = false
			end
		end
	end

	if self:GetOption(omegaVectorMarker) then
		-- Either remove the mark or update it to the next debuff
		SetRaidTarget(args.destName, self:Mythic() and 0 or icon)
	end

	if self:Me(args.destGUID) and icon == 0 then
		self:CancelSayCountdown(265143)
	end
end

function mod:LingeringInfection(args)
	local amount = args.amount or 1
	lingeringInfectionList[args.destName] = amount
	self:SetInfoByTable(args.spellId, lingeringInfectionList)
	if self:Mythic() and self:Me(args.destGUID) then -- Check if we have to warn for high stacks in Mythic
		lingeringInfectionStacks = amount
		if amount >= 6 then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			self:PlaySound(args.spellId, "warning")
		end
	end
end

function mod:EvolvingAffliction(args)
	if nextLiquify > GetTime() + 8.5 then
		self:Bar(args.spellId, 8.5)
	end
end

function mod:EvolvingAfflictionApplied(args)
	self:StackMessage(args.spellId, args.destName, args.amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:Contagion(args)
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, contagionCount))
	self:PlaySound(args.spellId, "alarm")
	contagionCount = contagionCount + 1
	local timer = 23.1 -- up to 24.6s
	if nextLiquify > GetTime() + timer then
		self:CDBar(args.spellId, timer, CL.count:format(args.spellName, contagionCount))
	end
	if self:Mythic() and lingeringInfectionStacks >= 6 then -- No special effects under 6 stacks and below Mythic difficulty
		self:OpenProximity(274990, 5) -- Bursting Lesions
	end
end

function mod:Gestate(args)
	local timer = 25
	if nextLiquify > GetTime() + timer then
		self:CDBar(265212, timer)
	end
	if self:Me(args.destGUID) then
		self:PlaySound(265212, "alert")
		self:Say(265212)
	end
	self:TargetMessage2(265212, "orange", args.destName)
	self:PrimaryIcon(265212, args.destName)
	immunosuppressionCount = 1
	self:CDBar(265206, 6, CL.count:format(self:SpellName(265206), immunosuppressionCount)) -- Immunosuppression
end

function mod:GestateRemoved(args)
	self:PrimaryIcon(args.spellId)
end

function mod:Immunosuppression(args)
	self:Message2(args.spellId, "orange", CL.count:format(args.spellName, immunosuppressionCount))
	self:PlaySound(args.spellId, "alarm")
	immunosuppressionCount = immunosuppressionCount + 1
	self:Bar(args.spellId, 9.7, CL.count:format(args.spellName, immunosuppressionCount))
end

function mod:PlagueAmalgamDeath()
	self:StopBar(CL.count:format(self:SpellName(265206), contagionCount))
end

function mod:Liquefy(args)
	self:Message2(args.spellId, "cyan", CL.intermission)
	self:PlaySound(args.spellId, "long")
	self:CastBar(args.spellId, 33)

	self:StopBar(265209) -- Gestate
	self:StopBar(CL.count:format(self:SpellName(267242), contagionCount)) -- Contagion
	self:StopBar(265178) -- Evolving Affliction

	pathogenBombCount = 1
	self:Bar(266459, 13.5) -- Plague Bomb
end

function mod:LiquefyRemoved(args)
	self:Message2(args.spellId, "cyan", CL.over:format(CL.intermission))
	self:PlaySound(args.spellId, "info")

	self:CDBar(265178, 8.5) -- Evolving Affliction, up to 10s
	self:Bar(267242, 24.3, CL.count:format(self:SpellName(267242), contagionCount)) -- Contagion
	self:Bar(265212, 15) -- Gestate

	nextLiquify = GetTime() + 93
	self:Bar(args.spellId, 93)
end

function mod:PlagueBomb(args)
	self:Message2(args.spellId, "red")
	self:PlaySound(args.spellId, "warning")
	pathogenBombCount = pathogenBombCount + 1
	if pathogenBombCount < 3 then
		self:Bar(args.spellId, 12.2)
	end
end

function mod:BurstingLesionsApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "warning")
		self:OpenProximity(args.spellId, 5)
		self:Flash(args.spellId)
	end
end

function mod:BurstingLesionsRemoved(args)
	if self:Me(args.destGUID) then
		self:CloseProximity(args.spellId)
	end
end
