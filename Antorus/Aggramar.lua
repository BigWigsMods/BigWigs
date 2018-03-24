--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Aggramar", 1712, 1984)
if not mod then return end
mod:RegisterEnableMob(121975)
mod.engageId = 2063
mod.respawnTime = 25

--------------------------------------------------------------------------------
-- Locals
--

local stage = 1
local techniqueStarted = nil
local comboTime = 0
local foeBreakerCount = 1
local flameRendCount = 1
local nextIntermissionSoonWarning = 0
local comboSpells = {}
local comboCastEnd = 0
local currentCombo = nil
local comboSpellLookup = {
	[245458] = {color = "|cff00fff9", castTime = mod:Easy() and 3.5 or 2.75}, -- Foe Breaker
	[245463] = {color = "|cffffff00", castTime = mod:Easy() and 3.5 or 2.75}, -- Flame Rend
	[245301] = {color = "|cffffa000", castTime = 6}, -- Searing Tempest
}
for id,_ in pairs(comboSpellLookup) do
	comboSpellLookup[id].name = mod:SpellName(id)
	local _, _, icon = GetSpellInfo(id)
	comboSpellLookup[id].icon = icon
end

local blazeTick = 1
local blazeOnMe = nil
local blazeProxList = {}

local wave = 0
local waveEmberCounter = 0
local mobCollector = {}
local waveCollector = {}
local emberAddMarks = {}
local currentEmberWave = 1
local trackingEmber = nil
local waveTimeCollector = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.cast_text = "|cff00ff00%.1fs"
	L.wave_cleared = "Wave %d Cleared!"

	L.track_ember = "Ember of Taeshalach Tracker"
	L.track_ember_desc = "Display messages for each Ember of Taeshalach death."
	L.track_ember_icon = 245911 -- Wrought in Flame icon

	L.custom_off_ember_marker = CL.marker:format(mod:SpellName(-15903))
	L.custom_off_ember_marker_desc = "Mark Ember of Taeshalach with {rt1}{rt2}{rt3}{rt4}{rt5}, requires promoted or leader.\n|cff33ff99Mythic: This will only mark adds in the current wave and above 45 energy.|r"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		"berserk",
		"custom_off_ember_marker",
		"track_ember",
		245911, -- Wrought in Flame

		--[[ Stage One: Wrath of Aggramar ]]--
		{245990, "TANK"}, -- Taeshalach's Reach
		{245994, "SAY", "FLASH", "PROXIMITY"}, -- Scorching Blaze
		{244693, "SAY"}, -- Wake of Flame
		{244688, "INFOBOX"}, -- Taeshalach Technique
		245458, -- Foe Breaker
		245463, -- Flame Rend
		245301, -- Searing Tempest

		--[[ Stage Two: Champion of Sargeras ]]--
		245983, -- Flare

		--[[ Stage Three: The Avenger ]]--
		246037, -- Empowered Flare

		--[[ Mythic ]]--
		{254452, "SAY", "FLASH", "PROXIMITY"}, -- Ravenous Blaze
		255058, -- Empowered Flame Rend
		255061 -- Empowered Searing Tempest
	},{
		["stages"] = "general",
		[245990] = -15794, -- Stage One: Wrath of Aggramar
		[245983] = -15858, -- Stage Two: Champion of Sargeras
		[246037] = -15860, -- Stage Three: The Avenger
		[254452] = "mythic",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ Stage One: Wrath of Aggramar ]]--
	self:Log("SPELL_AURA_APPLIED", "TaeshalachsReach", 245990)
	self:Log("SPELL_AURA_APPLIED_DOSE", "TaeshalachsReach", 245990)
	self:Log("SPELL_AURA_APPLIED", "ScorchingBlaze", 245994)
	self:Log("SPELL_AURA_REMOVED", "ScorchingBlazeRemoved", 245994)
	self:Log("SPELL_CAST_START", "WakeofFlame", 244693)
	self:Log("SPELL_CAST_START", "FoeBreaker", 245458, 255059)
	self:Log("SPELL_CAST_SUCCESS", "FoeBreakerSuccess", 245458, 255059)
	self:Log("SPELL_CAST_START", "FlameRend", 245463, 255058) -- Normal, Empowered
	self:Log("SPELL_CAST_SUCCESS", "FlameRendSuccess", 245463, 255058)
	self:Log("SPELL_CAST_START", "SearingTempest", 245301, 255061) -- Normal, Empowered
	self:Log("SPELL_CAST_SUCCESS", "SearingTempestSuccess", 245301, 255061)

	--[[ Intermission: Fires of Taeshalach ]]--
	self:Log("SPELL_AURA_APPLIED", "CorruptAegis", 244894)
	self:Log("SPELL_AURA_REMOVED", "CorruptAegisRemoved", 244894)
	self:Log("SPELL_CAST_SUCCESS", "BlazingEruption", 244912) -- Add dying

	--[[ Mythic ]]--
	self:Log("SPELL_AURA_APPLIED", "RavenousBlaze", 254452)
	self:Log("SPELL_AURA_REMOVED", "RavenousBlazeRemoved", 254452)
end

function mod:OnEngage()
	stage = 1
	techniqueStarted = nil
	comboTime = GetTime() + 35
	foeBreakerCount = 1
	flameRendCount = 1
	wipe(comboSpells)
	comboSpellLookup[245458].castTime = self:Easy() and 3.5 or 2.75 -- Foe Breaker
	comboSpellLookup[245463].castTime = self:Easy() and 3.5 or 2.75 -- Flame Rend

	blazeTick = 1
	blazeOnMe = nil
	wipe(blazeProxList)

	wipe(mobCollector)
	wipe(waveCollector)
	wipe(waveTimeCollector)
	wave = 0
	currentEmberWave = 1
	trackingEmber = nil

	if self:Mythic() then
		self:Bar(254452, 4.8) -- Ravenous Blaze
		self:Berserk(540)
	else
		self:Bar(245994, 8) -- Scorching Blaze
	end
	self:Bar(244693, self:Mythic() and 10.5 or 5.5) -- Wake of Flame
	self:Bar(244688, self:Mythic() and 14.5 or 35) -- Taeshalach Technique

	nextIntermissionSoonWarning = 82 -- happens at 80%
	self:RegisterUnitEvent("UNIT_HEALTH_FREQUENT", nil, "boss1")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local updateInfoBox
do
	local nextSpell = "|cff00ff00"
	local spellUsed = "|cffaaaaaa"
	local texture = "|T%s:15:15:0:0:64:64:4:60:4:60|t"
	local castTime = "%.1fs"

	local mythicCombos = {
		[245463] = { -- Flame Rend first
			[245458] = {245463, 245458, 245458, 245301, 245463}, -- Flame Rend, Foe Breaker, Foe Breaker, Searing Tempest, Flame Rend
			[245301] = {245463, 245301, 245458, 245458, 245463}, -- Flame Rend, Searing Tempest, Foe Breaker, Foe Breaker, Flame Rend
		},
		[245458] = { -- Foe Breaker first
			[245463] = {245458, 245463, 245301, 245458, 245463}, -- Foe Breaker, Flame Rend, Searing Tempest, Foe Breaker, Flame Rend
			[245301] = {245458, 245301, 245463, 245458, 245463}, -- Foe Breaker, Searing Tempest, Flame Rend, Foe Breaker, Flame Rend
		},
	}

	function updateInfoBox(self, newSpell)
		local comboCount = #comboSpells

		if not currentCombo then
			if self:LFR() then -- Always the same combo
				currentCombo = {245463, 245463, 245463, 245463, 245301} -- Flame Rend, Flame Rend, Flame Rend, Flame Rend, Searing Tempest
			elseif not self:Mythic() then -- Always the same combo
				currentCombo = {245458, 245463, 245458, 245463, 245301} -- Foe Breaker, Flame Rend, Foe Breaker, Flame Rend, Searing Tempest
			elseif comboCount >= 2 then -- We know the combo after the first 2 casts
				currentCombo = mythicCombos[comboSpells[1]][comboSpells[2]]
			end
		end

		local t = comboCastEnd - GetTime() -- Cast time left for current combo spell

		if newSpell then -- Spell got cast, so update spell names and colors
			for i=1,5 do
				local spell = currentCombo and comboSpellLookup[currentCombo[i]] or comboSpellLookup[comboSpells[i]]
				if currentCombo or comboSpells[i] then
					local color = comboCount == i and t > 0 and nextSpell or comboCount >= i and spellUsed or spell.color
					self:SetInfo(244688, i*2, texture:format(spell.icon) .. color .. spell.name)
				else
					self:SetInfo(244688, i*2, "")
				end
			end
		end

		local castPos = max(comboCount*2-1, 1)
		self:SetInfo(244688, castPos, t > 0 and nextSpell..castTime:format(t) or "")
		self:SetInfoBar(244688, castPos, t > 0 and t/comboSpellLookup[comboSpells[comboCount]].castTime or 0)
		if t > 0 then
			self:ScheduleTimer(updateInfoBox, 0.05, self)
		elseif comboCount*2+1 < 10 then -- Current spell done, set arrows for next spell
			self:SetInfo(244688, comboCount*2+1, nextSpell..">>")
		end
	end
end

local function updateProximity(self)
	local spellId = self:Mythic() and 254452 or 245994
	local range = self:Mythic() and blazeTick * 5 or 4 -- Mythic: 5/10/15/20yd (via 254458, 254459, 254460, 254461)

	if blazeOnMe then
		self:OpenProximity(spellId, range)
	elseif #blazeProxList > 0 then
		self:OpenProximity(spellId, range, blazeProxList)
	else
		self:CloseProximity(spellId)
	end
end

function mod:UNIT_HEALTH_FREQUENT(unit)
	local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100
	if hp < nextIntermissionSoonWarning then
		self:Message("stages", "Positive", nil, CL.soon:format(CL.intermission), false)
		nextIntermissionSoonWarning = nextIntermissionSoonWarning - 40
		if nextIntermissionSoonWarning < 40 or self:LFR() then -- only 1 intermission in LFR
			self:UnregisterUnitEvent("UNIT_HEALTH_FREQUENT", unit)
		end
	end
end

function mod:BlazingEruption(args) -- Add Death/Raid Explosion
	if (self:GetOption("track_ember") or self:GetOption("custom_off_ember_marker")) and trackingEmber then
		-- Remove the ember from marks list and wave List
		if self:GetOption("custom_off_ember_marker") then
			for key,guid in pairs(emberAddMarks) do
				if guid == args.sourceGUID then
					emberAddMarks[key] = nil
				end
			end
		end

		if mobCollector[args.sourceGUID] then
			waveCollector[mobCollector[args.sourceGUID]][args.sourceGUID] = nil -- Check which wave the add was from, incase its from an earlier wave
		end

		waveEmberCounter = 0
		if waveCollector[currentEmberWave] then
			for _ in next, waveCollector[currentEmberWave] do -- Count how many embers are left in this wave
				waveEmberCounter = waveEmberCounter + 1
			end
		end
		if waveEmberCounter > 0 then
			self:Message("track_ember", "Neutral", "Info", CL.mob_remaining:format(self:SpellName(-16686), waveEmberCounter), false)
		elseif currentEmberWave then -- Next wave time!
			self:Message("track_ember", "Neutral", "Info", L.wave_cleared:format(currentEmberWave), false)
			self:StopBar(CL.count:format(self:SpellName(245911), currentEmberWave))
			if not self:Mythic() or not waveTimeCollector[currentEmberWave+1] then -- Always 1 wave in heroic, or we are out of current waves.
				self:UnregisterTargetEvents()
				trackingEmber = nil
			else -- Start the new wave timer
				local emberTimer = floor(waveTimeCollector[currentEmberWave+1] - GetTime())
				self:CDBar(245911, emberTimer, CL.count:format(self:SpellName(245911), currentEmberWave+1)) -- Wrought in Flame (x)
			end
			currentEmberWave = currentEmberWave + 1
		end
	end
end

do
	function mod:EmberAddScanner(_, unit)
		local guid = UnitGUID(unit)
		local mobID = self:MobId(guid)
		if mobID == 122532 and not mobCollector[guid] then
			mobCollector[guid] = wave -- store which wave the add is from incase it dies early
			waveCollector[wave][guid] = true
		end
		if self:GetOption("custom_off_ember_marker") then
			if mobID == 122532 and waveCollector[currentEmberWave] and (not self:Mythic() or UnitPower(unit, 3) > 45) then -- Mark all above 45 energy or everything below Mythic
				if waveCollector[currentEmberWave][guid] then
					for i = 1, 5 do -- Use only 5 marks, leaving 6, 7, 8 for raid use purposes
						if not emberAddMarks[i] and not GetRaidTargetIndex(unit) then -- Don't re-mark the same add and re-use marks
							SetRaidTarget(unit, i)
							emberAddMarks[i] = guid
							break
						end
					end
				end
			end
		end
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 244688 then -- Taeshalach Technique
		techniqueStarted = true
		foeBreakerCount = 1
		flameRendCount = 1
		wipe(comboSpells)
		currentCombo = nil
		comboTime = GetTime() + 60.8
		self:Bar(spellId, 60.8)
		self:OpenInfo(244688, self:SpellName(244688)) -- Taeshalach Technique
		if not self:Mythic() then -- Random Combo in Mythic
			if not self:LFR() then
				self:Bar(245463, self:Normal() and 5 or 4, CL.count:format(self:SpellName(244033), flameRendCount)) -- Flame Rend
			end
			self:Bar(245301, self:Easy() and 19.9 or 15.7) -- Searing Tempest
		end
	elseif spellId == 244792 then -- Burning Will of Taeshalach, end of Taeshalach Technique but also casted in intermission
		if techniqueStarted then -- Check if he actually ends the combo, instead of being in intermission
			techniqueStarted = nil
			self:CloseInfo(244688)

			if self:Mythic() then
				self:Bar(254452, stage == 1 and 4 or 21.3) -- Ravenous Blaze
			else
				self:CDBar(245994, 4) -- Scorching Blaze
			end
			if stage == 1 then
				self:Bar(244693, 5) -- Wake of Flame
			elseif stage == 2 then
				self:Bar(245983, self:Mythic() and 6.6 or 9) -- Flare
			elseif stage == 3 then
				self:Bar(246037, self:Mythic() and 7.7 or 9) -- Empowered Flare
			end
		end
	elseif spellId == 245983 then -- Flare
		self:Message(spellId, "Important", "Warning")
		if comboTime > GetTime() + 15.8 and not self:Mythic() then
			self:Bar(spellId, 15.8)
		end
	elseif spellId == 246037 then -- Empowered Flare
		self:Message(spellId, "Important", "Warning")
		-- Start tracking new ember wave (mythic)
		if self:Mythic() then
			wave = wave + 1
			waveCollector[wave] = {}
			waveTimeCollector[wave] = (GetTime() + (self:Mythic() and 165 or 180))
			if not trackingEmber and (self:GetOption("track_ember") or self:GetOption("custom_off_ember_marker")) then
				self:RegisterTargetEvents("EmberAddScanner") -- Adds spawning
				trackingEmber = true
				local emberTimer = floor(waveTimeCollector[wave] - GetTime())
				self:CDBar(245911, emberTimer, CL.count:format(self:SpellName(245911), currentEmberWave)) -- Wrought in Flame (x)
			end
		end
		if comboTime > GetTime() + 16.2 and not self:Mythic() then
			self:Bar(spellId, 16.2) -- Assume mythic CD
		end
	end
end

--[[ Stage One: Wrath of Aggramar ]]--
function mod:TaeshalachsReach(args)
	local amount = args.amount or 1
	if amount % 3 == 0 or amount > 7 then
		self:StackMessage(args.spellId, args.destName, amount, "Important", amount > 7 and "Alarm") -- Swap on 8+
	end
end

do
	local scheduled = nil

	local function warn(self, spellId)
		if not blazeOnMe then
			self:Message(spellId, "Important")
		end
		scheduled = nil
	end

	function mod:ScorchingBlaze(args)
		if self:Me(args.destGUID) then
			blazeOnMe = true
			self:TargetMessage(args.spellId, args.destName, "Important", "Warning")
			self:Say(args.spellId)
		end
		if not scheduled then
			scheduled = self:ScheduleTimer(warn, 0.3, self, args.spellId)
			if comboTime > GetTime() + 7.3 then
				self:CDBar(args.spellId, 7.3)
			end
		end
		updateProximity(self)
	end

	function mod:ScorchingBlazeRemoved(args)
		if self:Me(args.destGUID) then
			blazeOnMe = nil
		end
		tDeleteItem(blazeProxList, args.destName)
		updateProximity(self)
	end
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(244693, name, "Attention", "Alert", nil, nil, true)
		if self:Me(guid) then
			self:Say(244693)
		end
	end
	function mod:WakeofFlame(args)
		self:GetBossTarget(printTarget, 0.7, args.sourceGUID)
		local cooldown = self:Mythic() and 12.1 or 24
		if comboTime > GetTime() + cooldown then
			self:Bar(args.spellId, cooldown)
		end
	end
end

function mod:FoeBreaker(args)
	self:Message(245458, "Attention", "Alert", CL.count:format(args.spellName, foeBreakerCount))
	foeBreakerCount = foeBreakerCount + 1
	comboSpells[#comboSpells+1] = 245458
	comboCastEnd = GetTime() + (self:Easy() and 3.5 or 2.75)
	if foeBreakerCount == 2 and not self:Mythic() then -- Random Combo in Mythic
		self:Bar(args.spellId, self:Easy() and 10.1 or 7.5, CL.count:format(args.spellName, foeBreakerCount))
	end
	updateInfoBox(self, true)
end

function mod:FoeBreakerSuccess()
	comboCastEnd = 0
	updateInfoBox(self, true)
end

function mod:FlameRend(args)
	self:Message(args.spellId, "Important", "Alarm", CL.count:format(args.spellName, flameRendCount))
	flameRendCount = flameRendCount + 1
	comboSpells[#comboSpells+1] = 245463
	comboCastEnd = GetTime() + (self:Easy() and 3.5 or 2.75)
	if self:LFR() and flameRendCount < 5 then
		self:Bar(args.spellId, 5, CL.count:format(args.spellName, flameRendCount))
	elseif flameRendCount == 2 and not self:Mythic() then -- Random Combo in Mythic
		self:Bar(args.spellId, self:Normal() and 10.2 or 7.5, CL.count:format(args.spellName, flameRendCount))
	end
	updateInfoBox(self, true)
end

function mod:FlameRendSuccess()
	comboCastEnd = 0
	updateInfoBox(self, true)
end

function mod:SearingTempest(args)
	self:Message(args.spellId, "Urgent", "Warning")
	self:CastBar(args.spellId, 6)
	comboSpells[#comboSpells+1] = 245301
	comboCastEnd = GetTime() + 6
	updateInfoBox(self, true)
end

function mod:SearingTempestSuccess(args)
	comboCastEnd = 0
	updateInfoBox(self, true)
end

--[[ Intermission: Fires of Taeshalach ]]--
function mod:CorruptAegis()
	techniqueStarted = nil -- End current technique
	self:CloseInfo(244688)
	self:Message("stages", "Neutral", "Long", CL.intermission, false)
	self:StopBar(245994) -- Scorching Blaze
	self:StopBar(244693) -- Wake of Flame
	self:StopBar(244688) -- Taeshalach Technique
	self:StopBar(245458, CL.count:format(self:SpellName(245458), foeBreakerCount)) -- Foe Breaker
	self:StopBar(245463, CL.count:format(self:SpellName(245463), flameRendCount)) -- Flame Rend
	self:StopBar(245301) -- Searing Tempest
	self:StopBar(245983) -- Flare


	-- Reset all saved variables
	wipe(mobCollector)
	wipe(waveCollector)
	wipe(waveTimeCollector)
	wipe(emberAddMarks)
	currentEmberWave = 1
	wave = 1
	waveCollector[wave] = {}

	if not trackingEmber and (self:GetOption("track_ember") or self:GetOption("custom_off_ember_marker")) then
		self:RegisterTargetEvents("EmberAddScanner") -- Adds spawning
		trackingEmber = true
	end
	waveTimeCollector[wave] = GetTime() + (self:Mythic() and 165 or 180)
	self:CDBar(245911, self:Mythic() and 165 or 180, CL.count:format(self:SpellName(245911), wave)) -- Wrought in Flame (x)
end

function mod:CorruptAegisRemoved()
	stage = stage + 1
	comboTime = GetTime() + 37.5
	self:Message("stages", "Neutral", "Long", CL.stage:format(stage), false)

	if self:Mythic() then
		self:Bar(254452, 23) -- Ravenous Blaze
	else
		self:CDBar(245994, 6) -- Scorching Blaze
	end
	self:Bar(244688, 37.5) -- Taeshalach Technique
	if stage == 2 then
		self:Bar(245983, self:Mythic() and 8.4 or 10.5) -- Flare
	elseif stage == 3 then
		self:Bar(246037, self:Mythic() and 8.4 or 10) -- Empowered Flare
	end
end

--[[ Mythic ]]--
do
	local playerList, scheduled = mod:NewTargetList(), nil

	local function addBlazeTick(self)
		blazeTick = blazeTick + 1
		if blazeTick >= 4 then
			self:CancelTimer(scheduled)
		end
		updateProximity(self)
	end

	function mod:RavenousBlaze(args)
		if self:Me(args.destGUID) then
			blazeOnMe = true
			self:Flash(args.spellId)
			self:Say(args.spellId)
		end
		playerList[#playerList+1] = args.destName
		blazeProxList[#blazeProxList+1] = args.destName
		if #playerList == 1 then
			local cooldown = stage == 1 and 23.1 or 60.1 -- this cooldown should only trigger in stage 1+
			if comboTime > GetTime() + cooldown then
				self:CDBar(args.spellId, cooldown)
			end
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, playerList, "Important", "Warning")
			blazeTick = 1
			scheduled = self:ScheduleRepeatingTimer(addBlazeTick, 2, self)
		end
		updateProximity(self)
	end

	function mod:RavenousBlazeRemoved(args)
		if self:Me(args.destGUID) then
			blazeOnMe = nil
		end
		tDeleteItem(blazeProxList, args.destName)
		updateProximity(self)
	end
end
