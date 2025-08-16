--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Soulbinder Naazindhri", 2810, 2685)
if not mod then return end
mod:RegisterEnableMob(233816) -- Soulbinder Naazindhri
mod:SetEncounterID(3130)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local soulCallingCount = 1
local soulfrayAnnihilationCount = 1
local mysticLashCount = 1
local arcaneExpulsionCount = 1
local soulfireConvergenceCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.voidblade_ambush = "Ambush" -- Short for Voidblade Ambush
	L.soulfray_annihilation = "Lines" -- Lines that shoot out an orb along that path
	L.soulfray_annihilation_single = "Line" -- Single from Lines
	L.remaining_adds = "Remaining Adds" -- All remaining adds from Soul Calling spawn
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnRegister()
	self:SetSpellRename(1225582, CL.adds) -- Soul Calling (Adds)
	self:SetSpellRename(1227048, L.voidblade_ambush) -- Voidblade Ambush (Ambush)
	self:SetSpellRename(1227276, L.soulfray_annihilation) -- Soulfray Annihilation (Lines)
	self:SetSpellRename(1223859, CL.knockback) -- Arcane Expulsion (Knockback)
	self:SetSpellRename(1225616, CL.orbs) -- Soulfire Convergence (Orbs)
end

local soulfrayAnnihilationMarkerMapTable = {4, 6, 3} -- Green, Blue, Diamond (wm order)
local soulfrayAnnihilationMarker = mod:AddMarkerOption(true, "player", soulfrayAnnihilationMarkerMapTable[1], 1227276, unpack(soulfrayAnnihilationMarkerMapTable))
function mod:GetOptions()
	return {
		1225582, -- Soul Calling
			-- Shadowguard Assassin
				{1227048, "NAMEPLATE", "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Voidblade Ambush, using 1227048 as 1227049 has no good tooltip info
			-- Unbound Mage
				1227052, -- Void Volley
			1227848, -- Essence Implosion
		{1227276, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Soulfray Annihilation
		soulfrayAnnihilationMarker,
		{1223859, "CASTBAR", "CASTBAR_COUNTDOWN"}, -- Arcane Expulsion
		{1225616, "SAY", "SAY_COUNTDOWN", "ME_ONLY_EMPHASIZE"}, -- Soulfire Convergence
			1226827, -- Soulrend Orb
		{1241100, "TANK"}, -- Mystic Lash
		1242086, -- Arcane Energy
	},{
		[1242086] = "mythic", -- Arcane Energy
	},
	{
		[1227848] = L.remaining_adds, -- Essence Implosion (Remaining Adds)
		[1225582] = CL.adds, -- Soul Calling (Adds)
		[1227048] = L.voidblade_ambush, -- Voidblade Ambush (Ambush)
		[1227276] = L.soulfray_annihilation, -- Soulfray Annihilation (Lines)
		[1223859] = CL.knockback, -- Arcane Expulsion (Knockback)
		[1225616] = CL.orbs, -- Soulfire Convergence (Orbs)
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "SoulCalling", 1225582)
	self:Log("SPELL_CAST_START", "Soulweave", 1219040, 1219053, 1239988)
	self:Log("SPELL_CAST_SUCCESS", "VoidbladeAmbush", 1227049)
	self:Log("SPELL_AURA_APPLIED", "VoidbladeAmbushTargetApplied", 1227049)
	self:Death("ShadowguardAssassinDeath", 237897) -- Shadowguard Assassin
	self:Log("SPELL_CAST_START", "VoidVolley", 1227052)
	self:Log("SPELL_AURA_APPLIED", "VoidVolleyApplied", 1227052)
	self:Log("SPELL_CAST_SUCCESS", "SoulfrayAnnihilation", 1227276)
	self:Log("SPELL_AURA_APPLIED", "SoulfrayAnnihilationApplied", 1227276)
	self:Log("SPELL_AURA_REMOVED", "SoulfrayAnnihilationRemoved", 1227276)
	self:Log("SPELL_CAST_START", "MysticLash", 1241100)
	self:Log("SPELL_AURA_APPLIED", "MysticLashApplied", 1237607)
	self:Log("SPELL_CAST_START", "ArcaneExpulsion", 1223859, 1242088)
	self:Log("SPELL_CAST_SUCCESS", "SoulfireConvergence", 1225616)
	self:Log("SPELL_AURA_APPLIED", "SoulfireConvergenceApplied", 1225626)
	self:Log("SPELL_AURA_APPLIED", "SoulrendOrbApplied", 1226827)

	-- Mythic
	self:Log("SPELL_AURA_APPLIED", "ArcaneEnergyDamage", 1242086)
	self:Log("SPELL_PERIODIC_DAMAGE", "ArcaneEnergyDamage", 1242086)
	self:Log("SPELL_PERIODIC_MISSED", "ArcaneEnergyDamage", 1242086)
end

function mod:OnEngage()
	soulCallingCount = 1
	soulfrayAnnihilationCount = 1
	mysticLashCount = 1
	arcaneExpulsionCount = 1
	soulfireConvergenceCount = 1

	self:Bar(1241100, self:Mythic() and 5 or 6.0, CL.count:format(self:SpellName(1241100), mysticLashCount)) -- Mystic Lash
	self:Bar(1225582, self:Mythic() and 13.0 or 14.0, CL.count:format(CL.adds, soulCallingCount)) -- Soul Calling
	self:Bar(1227276, self:Mythic() and 26.0 or 20.0, CL.count:format(L.soulfray_annihilation, soulfrayAnnihilationCount)) -- Soulfray Annihilation
	self:Bar(1225616, self:Mythic() and 18.0 or 32.0, CL.count:format(CL.orbs, soulfireConvergenceCount)) -- Soulfire Convergence
	self:Bar(1223859, self:Mythic() and 41.0 or 42.0, CL.count:format(CL.knockback, arcaneExpulsionCount)) -- Arcane Expulsion
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:SoulCalling(args)
	self:StopBar(CL.count:format(CL.adds, soulCallingCount))
	self:Message(args.spellId, "cyan", CL.count:format(CL.adds, soulCallingCount))
	self:PlaySound(args.spellId, "long") -- Unbound Souls/Binding Machines inc
	soulCallingCount = soulCallingCount + 1
	self:Bar(args.spellId, 150.0, CL.count:format(CL.adds, soulCallingCount))
end

do
	local prev = 0
	function mod:Soulweave(args)
		if args.time - prev > 2 then
			self:Bar(1227848, 101, CL.count:format(L.remaining_adds, soulCallingCount - 1))
		end
	end
end

function mod:VoidbladeAmbush(args)
	self:Nameplate(1227048, 12.2, args.sourceGUID)
end

function mod:VoidbladeAmbushTargetApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(1227048, nil, L.voidblade_ambush)
		self:PlaySound(1227048, "warning", nil, args.destName) -- position yourself
		self:Say(1227048, L.voidblade_ambush, nil, "Ambush")
		self:SayCountdown(1227048, 4) -- XXX 3 is tooltip on wowhead, changed?
	end
end

function mod:ShadowguardAssassinDeath(args)
	self:ClearNameplate(args.destGUID)
end

function mod:VoidVolley(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo and ready then -- kick
		self:Message(args.spellId, "orange")
		self:PlaySound(args.spellId, "alarm")
	end
end

function mod:VoidVolleyApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm", nil, args.destName) -- dot on you
	end
end

do
	local playerList = {}
	function mod:SoulfrayAnnihilation(args)
		self:StopBar(CL.count:format(L.soulfray_annihilation, soulfrayAnnihilationCount))
		self:Message(args.spellId, "yellow", CL.count:format(L.soulfray_annihilation, soulfrayAnnihilationCount))
		soulfrayAnnihilationCount = soulfrayAnnihilationCount + 1
		local cd = soulfrayAnnihilationCount % 3 == 1 and 70.0 or 40.0
		if self:Mythic() then
			cd = soulfrayAnnihilationCount % 3 == 1 and 76.1 or 37.0
		elseif self:Heroic() then
			cd = soulfrayAnnihilationCount % 3 == 1 and 69.0 or soulfrayAnnihilationCount % 3 == 2 and 41.0 or 40.0
		end
		self:Bar(args.spellId, cd, CL.count:format(L.soulfray_annihilation, soulfrayAnnihilationCount))
		playerList = {}
	end

	function mod:SoulfrayAnnihilationApplied(args)
		local count = #playerList + 1
		playerList[count] = args.destName
		local icon = self:GetOption(soulfrayAnnihilationMarker) and soulfrayAnnihilationMarkerMapTable[count] or nil
		if self:Me(args.destGUID) then
			local englishText = "Line"
			local sayText = icon and CL.rticon:format(L.soulfray_annihilation_single, icon) or L.soulfray_annihilation_single
			local englishSayText = icon and CL.rticon:format(englishText, icon) or englishText
			self:PersonalMessage(args.spellId, nil, L.soulfray_annihilation)
			self:PlaySound(args.spellId, "warning", nil, args.destName) -- move
			self:Say(args.spellId, sayText, nil, englishSayText)
			self:SayCountdown(args.spellId, 6, icon)
		end
		if icon then
			self:CustomIcon(soulfrayAnnihilationMarker, args.destName, icon)
		end
	end

	function mod:SoulfrayAnnihilationRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		self:CustomIcon(soulfrayAnnihilationMarker, args.destName)
	end
end

function mod:MysticLash(args)
	self:StopBar(CL.count:format(args.spellName, mysticLashCount))
	self:Message(args.spellId, "purple", CL.count:format(args.spellName, mysticLashCount))
	self:PlaySound(args.spellId, "alert") -- Current tank warning?
	mysticLashCount = mysticLashCount + 1
	local cd = mysticLashCount % 4 == 1 and 32.0 or mysticLashCount % 4 == 0 and 38.0 or 40.0
	if self:Mythic() then
		cd = mysticLashCount % 4 == 1 and 31.0 or mysticLashCount % 4 == 2 and 41.0 or mysticLashCount % 4 == 3 and 38.0 or 40.0
	end
	self:Bar(args.spellId, cd, CL.count:format(args.spellName, mysticLashCount))
end

function mod:MysticLashApplied(args)
	local amount = args.amount or 1
	if amount % 2 == 1 then -- multiple stacks during cast?
		self:StackMessage(1241100, "purple", args.destName, args.amount, 4)
		if self:Me(args.destGUID) then
			self:PlaySound(1241100, "alarm", nil, args.destName)
		elseif self:Tank() and amount > 4 then
			self:PlaySound(1241100, "warning") -- taunt?
		end
	end
end

function mod:ArcaneExpulsion()
	self:StopBar(CL.count:format(CL.knockback, arcaneExpulsionCount))
	self:Message(1223859, "orange", CL.count:format(CL.knockback, arcaneExpulsionCount))
	self:PlaySound(1223859, "warning")
	self:CastBar(1223859, 4, CL.count:format(CL.knockback, arcaneExpulsionCount))
	arcaneExpulsionCount = arcaneExpulsionCount + 1
	local cd = arcaneExpulsionCount % 3 == 1 and 46.0 or arcaneExpulsionCount % 3 == 0 and 64.0 or 40.0
	if self:Mythic() then
		cd = arcaneExpulsionCount % 3 == 1 and 45.0 or arcaneExpulsionCount % 3 == 0 and 67.0 or 38.0
	end
	self:Bar(1223859, cd, CL.count:format(CL.knockback, arcaneExpulsionCount))
end

function mod:SoulfireConvergence(args)
	self:StopBar(CL.count:format(CL.orbs, soulfireConvergenceCount))
	self:Message(args.spellId, "orange", CL.count:format(CL.orbs, soulfireConvergenceCount)) -- XXX TargetsMessage?
	soulfireConvergenceCount = soulfireConvergenceCount + 1
	local cd = soulfireConvergenceCount % 3 == 1 and 45 or soulfireConvergenceCount % 3 == 0 and 65 or 40
	if self:Mythic() then
		cd = soulfireConvergenceCount % 3 == 1 and 75.0 or soulfireConvergenceCount % 3 == 2 and 37.0 or 38.1
	elseif self:Heroic() then
		local timers = {41.0, 44.8, 24.0, 16.0, 24.0}
		local timerModCount = soulfireConvergenceCount % 5
		cd = timers[timerModCount+1]
	end
	self:Bar(args.spellId, cd, CL.count:format(CL.orbs, soulfireConvergenceCount))
end
function mod:SoulfireConvergenceApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(1225616, nil, CL.orbs)
		self:PlaySound(1225616, "warning", nil, args.destName) -- move
		self:Say(1225616, CL.orbs, nil, "Orbs")
		self:SayCountdown(1225616, 5, nil, 3)
	end
end

function mod:SoulrendOrbApplied(args)
	if self:Me(args.destGUID) then
		self:PersonalMessage(args.spellId)
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

do
	local prev = 0
	function mod:ArcaneEnergyDamage(args)
		if self:Me(args.destGUID) and args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "underyou", nil, args.destName)
			self:PersonalMessage(args.spellId, "underyou")
		end
	end
end
