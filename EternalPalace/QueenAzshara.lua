
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Queen Azshara", 2164, 2361)
if not mod then return end
mod:RegisterEnableMob(152910, 153059, 153060) -- Queen Azshara, Aethanel, Cyranus
mod.engageId = 2299
mod.respawnTime = 20

--------------------------------------------------------------------------------
-- Local
--

local stage = 1
local detonationCount = 1
local portalCount = 1
local drainedSoulList = {}
local hiddenDrainedSoulList = {}
local soulDuration = 110
local fails = 0
local hulkKillTime = 0
local burstCount = 1
local piercingCount = 1
local myrmidonCount = 1
local portalTimersMythic = {26.6, 50.3, 43, 56}
local piercingTimersMythic = {51.6, 56, 49}
local overloadCount = 1

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L[299249] = "SOAK Orbs"
	L[299251] = "AVOID Orbs"
	L[299254] = "HUG Others"
	L[299255] = "Stand ALONE"
	L[299252] = "Keep MOVING"
	L[299253] = "Stand STILL"
	L.hugSay = "HUG %s"
	L.hugNoMoveSay = "HUG %s, I can't move"
	L.avoidSay = "AVOID %s"
	L.yourDecree = "Decree: %s"
	L.yourDecree2 = "Decree: %s & %s"
	L.hulk_killed = "%s killed - %.1f sec"
	L.fails_message = "%s (%d Sanction stack fails)"
	L.reversal = "Reversal"
	L.greater_reversal = "Reversal (Greater)"
	L.you_die = "You die"
	L.you_die_message = "You will die in %s sec"

	L.custom_off_repeating_decree_chat = "Repeating Decree Chat"
	L.custom_off_repeating_decree_chat_desc = "Spam the words 'HUG me' in yell chat, or 'AVOID me' in say chat, while you have |cff71d5ff[Queen's Decree]|r. Maybe they'll help you if they see the chat bubble."
	L.custom_off_repeating_decree_chat_icon = 299250
end

--------------------------------------------------------------------------------
-- Initialization
--

local arcaneBurstMarker = mod:AddMarkerOption(false, "player", 1, 303657, 1, 2, 3) -- Arcane Burst
function mod:GetOptions()
	return {
		"stages",
		"berserk",
		300074, -- Pressure Surge
		{298569, "INFOBOX"}, -- Drained Soul
		297937, -- Painful Memories
		297934, -- Longing
		297912, -- Torment
		297907, -- Cursed Heart
		298121, -- Lightning Orbs
		297972, -- Chain Lightning
		{298014, "TANK_HEALER"}, -- Cold Blast
		{298021, "TANK_HEALER"}, -- Ice Shard
		{298756, "ME_ONLY"}, -- Serrated Edge
		{301078, "SAY", "SAY_COUNTDOWN", "FLASH"}, -- Charged Spear
		-20480, -- Overzealous Hulk
		298531, -- Ground Pound
		300428, -- Infuriated
		298787, -- Arcane Orbs
		{299094, "SAY", "FLASH", "PULSE"}, -- Beckon
		{299250, "SAY"}, -- Queen's Decree
		"custom_off_repeating_decree_chat",
		302999, -- Arcane Vulnerability
		-20408, -- Azshara's Devoted
		-20410, -- Azshara's Indomitable
		{304475, "TANK"}, -- Arcane Jolt
		300519, -- Arcane Detonation
		297371, -- Reversal of Fortune
		{303657, "SAY", "SAY_COUNTDOWN"}, -- Arcane Burst
		arcaneBurstMarker,
		-20355, -- Loyal Myrmidon
		{300492, "SAY", "FLASH"}, -- Static Shock
		300620, -- Crystalline Shield
		297372, -- Greater Reversal of Fortune
		300768, -- Piercing Gaze
		{300743, "TANK"}, -- Void Touched
		303986, -- Nether Portal
		301431, -- Overload
		{300866, "ME_ONLY", "FLASH", "COUNTDOWN"}, -- Essence of Azeroth
		300877, -- System Shock
		300478, -- Divide and Conquer
	},{
		["stages"] = "general",
		[297937] = -20250, -- Stage One: Cursed Lovers
		[298121] = -20261, -- Aethanel
		[298756] = -20266, -- Cyranus
		[-20480] = CL.adds, -- Cyranus
		[298787] = -20450, -- Queen Azshara
		[299250] = CL.intermission, -- Intermission One: Queen's Decree
		[302999] = -20323, -- Stage Two: Hearts Unleashed
		[-20355] = -20340, -- Stage Three: Song of the Tides
		[300768] = -20361, -- Stage Four: My Palace Is a Prison
		[300478] = "mythic",
	},{
		[297371] = L.reversal, -- Reversal of Fortune (Reversal)
		[297372] = L.greater_reversal, -- Greater Reversal of Fortune (Reversal (Greater))
		[300866] = L.you_die, -- Essence of Azeroth (You die)
	}
end

do
	local function initInfoBox(self)
		soulDuration = self:LFR() and 60 or 110
		for unit in self:IterateGroup() do
			local _, _, _, tarInstanceId = UnitPosition(unit)
			local name = self:UnitName(unit)
			if name and tarInstanceId == 2164 and not self:Tank(unit) then
				drainedSoulList[name] = {0, 0, soulDuration}
			end
		end
	end

	function mod:OnBossEnable()
		self:Log("SPELL_CAST_SUCCESS", "AddsSpawn", 181089) -- Encounter Event (They used the wrong spell and implemented it weirdly)
		self:RegisterEvent("RAID_BOSS_WHISPER")
		self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
		self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1", "boss2", "boss3", "boss4", "boss5")
		self:Log("SPELL_DAMAGE", "PressureSurge", 300074)
		self:Log("SPELL_AURA_APPLIED", "DrainedSoulApplied", 298569)
		self:Log("SPELL_AURA_APPLIED_DOSE", "DrainedSoulApplied", 298569)
		self:Log("SPELL_AURA_REMOVED", "DrainedSoulRemoved", 298569)

		-- Stage 1
		self:Log("SPELL_CAST_START", "PainfulMemories", 297937)
		self:Log("SPELL_CAST_START", "Longing", 297934)
		self:Log("SPELL_AURA_APPLIED", "Torment", 297912)

		-- Aethane
		self:Log("SPELL_CAST_START", "LightningOrbs", 298121)
		self:Log("SPELL_CAST_START", "ChainLightning", 297972)
		self:Log("SPELL_CAST_START", "ColdBlast", 298014)
		self:Log("SPELL_AURA_APPLIED", "ColdBlastApplied", 298014)
		self:Log("SPELL_AURA_APPLIED_DOSE", "ColdBlastApplied", 298014)
		self:Log("SPELL_CAST_START", "IceShard", 298021)

		-- Cyranus
		self:Log("SPELL_AURA_APPLIED", "SerratedEdgeApplied", 298756)
		self:Log("SPELL_AURA_APPLIED_DOSE", "SerratedEdgeApplied", 298756)
		self:Log("SPELL_CAST_SUCCESS", "ChargedSpear", 301078)
		self:Log("SPELL_AURA_APPLIED", "ChargedSpearApplied", 301078)

		-- Overzealous Hulk
		self:Log("SPELL_CAST_SUCCESS", "GroundPound", 298531)
		self:Log("SPELL_AURA_APPLIED", "Infuriated", 300428)
		self:Death("HulkDeath", 153064)

		-- Queen Azshara
		self:Log("SPELL_CAST_SUCCESS", "Beckon", 299094, 302141, 303797, 303799) -- Stage 1, Stage 2, Stage 3, Stage 4

		-- Intermission
		self:Log("SPELL_CAST_START", "QueensDecree", 299250)
		self:Log("SPELL_AURA_APPLIED", "PersonalDecrees", 299249, 299251, 299254, 299255, 299252, 299253) -- Suffer!, Obey!, Stand Together!, Stand Alone!, March!, Stay!
		self:Log("SPELL_AURA_REMOVED", "PersonalDecreesRemoved", 299254, 299255) -- Stand Together!, Stand Alone!
		self:Log("SPELL_AURA_APPLIED", "Sanction", 299276) -- Sanction
		self:Log("SPELL_AURA_APPLIED_DOSE", "Sanction", 299276) -- Sanction

		-- Stage 2
		self:Log("SPELL_CAST_SUCCESS", "ReversalOfFortune", 297371)
		self:Log("SPELL_AURA_APPLIED", "ArcaneMasteryApplied", 300502)
		self:Log("SPELL_AURA_APPLIED", "ArcaneVulnerabilityApplied", 302999)
		self:Log("SPELL_AURA_APPLIED_DOSE", "ArcaneVulnerabilityApplied", 302999)
		self:Log("SPELL_CAST_SUCCESS", "ArcaneJolt", 304475)

		self:Log("SPELL_CAST_START", "ArcaneDetonation", 300519)
		self:Log("SPELL_CAST_SUCCESS", "ArcaneBurstApplied", 303657)
		self:Log("SPELL_AURA_REMOVED", "ArcaneBurstRemoved", 303657)

		-- Stage 3
		self:Log("SPELL_AURA_APPLIED", "StaticShock", 300492)
		self:Log("SPELL_AURA_APPLIED", "CrystallineShield", 300620)
		self:Log("SPELL_CAST_SUCCESS", "GreaterReversalOfFortune", 297372)

		-- Stage 4
		self:Log("SPELL_CAST_SUCCESS", "NetherPortal", 303986)
		self:Log("SPELL_CAST_SUCCESS", "PiercingGaze", 300768)
		self:Log("SPELL_CAST_SUCCESS", "VoidTouchedSuccess", 300743)
		self:Log("SPELL_AURA_APPLIED", "VoidTouchedApplied", 300743)
		self:Log("SPELL_AURA_APPLIED_DOSE", "VoidTouchedApplied", 300743)
		self:Log("SPELL_CAST_START", "Overload", 301431)
		self:Log("SPELL_AURA_APPLIED", "EssenceofAzerothApplied", 300866)
		self:Log("SPELL_AURA_REMOVED", "EssenceofAzerothRemoved", 300866)
		self:Log("SPELL_AURA_APPLIED", "SystemShockApplied", 300877)

		-- Ground Effects
		self:Log("SPELL_AURA_APPLIED", "NetherPortalDamage", 303981) -- Nether Portal
		self:Log("SPELL_PERIODIC_DAMAGE", "NetherPortalDamage", 303981)
		self:Log("SPELL_PERIODIC_MISSED", "NetherPortalDamage", 303981)

		self:Log("SPELL_AURA_APPLIED", "GroundDamage", 297907) -- Cursed Heart
		self:Log("SPELL_PERIODIC_DAMAGE", "GroundDamage", 297907)
		self:Log("SPELL_PERIODIC_MISSED", "GroundDamage", 297907)

		initInfoBox(self)
	end

	function mod:OnEngage()
		stage = 1
		portalCount = 1
		detonationCount = 1
		drainedSoulList = {}
		hiddenDrainedSoulList = {}
		self:RegisterEvent("UNIT_FLAGS")

		self:CDBar(297937, 14.2) -- Painful Memories
		self:CDBar(298121, 18.5) -- Lightning Orbs
		self:Bar(299094, 49.5) -- Beckon
		self:Berserk(840)
		if self:Mythic() then
			self:Bar(300478, 32.5) -- Divide and Conquer
			self:Bar(298787, 57.5) -- Arcane Orbs
			self:CDBar(-20480, 27.5, nil, "achievement_boss_nagabruteboss") -- Overzealous Hulk
		else
			self:Bar(298787, 65) -- Arcane Orbs
			self:CDBar(-20480, self:Easy() and 41 or 35, nil, "achievement_boss_nagabruteboss") -- Overzealous Hulk
		end

		initInfoBox(self)
		self:OpenInfo(298569, self:SpellName(298569)) -- Drained Soul
		self:SetInfoBarsByTable(298569, drainedSoulList, true) -- Drained Soul
	end
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:UNIT_FLAGS(_, unit) -- Hide dead people
	local name = self:UnitName(unit)
	if UnitIsDead(unit) then
		if drainedSoulList[name] then
			hiddenDrainedSoulList[name] = drainedSoulList[name]
			drainedSoulList[name] = nil
			self:SetInfoBarsByTable(298569, drainedSoulList, true)
		end
	else
		if hiddenDrainedSoulList[name] then
			drainedSoulList[name] = hiddenDrainedSoulList[name]
			hiddenDrainedSoulList[name] = nil
			self:SetInfoBarsByTable(298569, drainedSoulList, true)
		end
	end
end

do
	local prev = 0
	function mod:AddsSpawn(args)
		if args.time - prev > 2 then
			prev = args.time
			if self:MobId(args.sourceGUID) == 153064 then -- Overzealous Hulk
				self:Message2(-20480, "cyan", self:SpellName(-20480), "achievement_boss_nagabruteboss")
				self:PlaySound(-20480, "long")
				hulkKillTime = GetTime()
				self:CDBar(-20480, self:Mythic() and 63 or self:Easy() and 85 or 59, nil, "achievement_boss_nagabruteboss")
			elseif self:MobId(args.sourceGUID) == 154240 then -- Azshara's Devoted
				self:Message2(-20408, "yellow", self:SpellName(-20408), "inv_misc_nagamale")
				self:PlaySound(-20408, "long")
			elseif self:MobId(args.sourceGUID) == 155354 then -- Azshara's Indomitable
				self:Message2(-20410, "yellow", self:SpellName(-20410), "achievement_boss_nagacentaur")
				self:PlaySound(-20410, "long")
			elseif self:MobId(args.sourceGUID) == 154565 then -- Loyal Myrmidon
				self:Message2(-20355, "yellow", self:SpellName(-20355), "inv_misc_nagamale")
				self:PlaySound(-20355, "long")
				myrmidonCount = myrmidonCount + 1
				if myrmidonCount < 4 then -- only 3 Myrmidons spawn maximum in Mythic, more in other difficulties unconfirmed
					self:CDBar(-20355, myrmidonCount == 3 and 50 or 60, nil, "inv_misc_nagamale")
				end
			end
		end
	end
end

function mod:HulkDeath()
	local seconds = math.floor((GetTime() - hulkKillTime) * 100)/100
	self:Message2(-20480, "cyan", L.hulk_killed:format(self:SpellName(-20480), seconds), "achievement_boss_nagabruteboss")
	self:PlaySound(-20480, "info")
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, msg)
	if msg:find("298787", nil, true) then -- Arcane Orbs
		self:Message2(298787, "yellow")
		self:PlaySound(298787, "alert")
		self:Bar(298787, 60)
	elseif msg:find("300522", nil, true) then -- Divides
		self:Message2(300478, "orange")
		self:PlaySound(300478, "warning")
		self:Bar(300478, stage == 4 and 86 or stage == 3 and 59.9 or 65)
		self:CastBar(300478, stage == 4 and 45 or 30)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, spellId)
	if spellId == 302034 then -- Adjure // 2nd Intermission Start / Stage 3
		stage = 3
		self:PlaySound("stages", "long")
		self:Message2("stages", "green", CL.intermission, false)
		fails = 0

		self:ScheduleTimer("EndIntermission", 27) -- To display fails/notify stage 3 starts

		self:StopBar(-20410) -- Azshara's Indomitable
		self:StopBar(-20408) -- Azshara's Devoted

		self:StopBar(304475) -- Arcane Jolt
		self:StopBar(299094) -- Beckon
		self:StopBar(303657) -- Arcane Burst
		self:StopBar(L.reversal) -- Reversal of Fortune
		self:StopBar(CL.count:format(self:SpellName(300519), detonationCount)) -- Arcane Detonation
		self:StopBar(300478) -- Divide and Conquer

		detonationCount = 1
		myrmidonCount = 1

		self:Bar(299250, 4) -- Decrees
		self:CDBar(-20355, 30, nil, "inv_misc_nagamale") -- Loyal Myrmidon
		self:Bar("stages", 34.3, CL.active, "achievement_boss_seawitch") -- Sisters attackable
		self:Bar(304475, self:Mythic() and 31 or 36) -- Arcane Jolt
		self:Bar(301078, 45.5) -- Charged Spear
		self:Bar(299094, 48.5) -- Beckon
		self:Bar(300519, 59.5, CL.count:format(self:SpellName(300519), detonationCount)) -- Arcane Detonation
		self:Bar(303657, self:Mythic() and 71 or 90) -- Arcane Burst
		self:Bar(297372, 80, L.greater_reversal) -- Greater Reversal of Fortune
		if self:Mythic() then
			self:Bar(300478, 44.3) -- Divide and Conquer
			self:Bar("stages", 210, CL.stage:format(4), "achievement_boss_azshara")
		end
	elseif spellId == 302860 then -- Queen Azshara (Stage 4)
		stage = 4
		self:PlaySound("stages", "long")
		self:Message2("stages", "cyan", CL.stage:format(stage), false)

		self:StopBar(-20355) -- Loyal Myrmidon
		self:StopBar(304475) -- Arcane Jolt
		self:StopBar(299094) -- Beckon
		self:StopBar(303657) -- Arcane Burst
		self:StopBar(L.greater_reversal) -- Greater Reversal of Fortune
		self:StopBar(CL.count:format(self:SpellName(300519), detonationCount)) -- Arcane Detonation
		self:StopBar(300478) -- Divide and Conquer
		self:StopBar(CL.stage:format(4))
		portalCount = 1
		piercingCount = 1
		overloadCount = 1

		self:Bar(300743, self:Mythic() and 12.5 or 12) -- Void Touched
		self:Bar(301431, self:Mythic() and 14.2 or 17, CL.count:format(self:SpellName(301431), overloadCount)) -- Overload
		self:Bar(303986, self:Mythic() and portalTimersMythic[portalCount] or 24) -- Nether Portal
		self:Bar(300768, self:Mythic() and 51.6 or 44) -- Piercing Gaze
		self:Bar(299094, self:Mythic() and 72.8 or 68.5) -- Beckon
		self:Bar(297372, 64, L.greater_reversal) -- Greater Reversal of Fortune
		if self:Mythic() then
			self:Bar(300478, 39.2) -- Divide and Conquer
		end
	end
end
function mod:EndIntermission()
	self:Message2("stages", "cyan", L.fails_message:format(CL.stage:format(stage), fails), false)
	self:PlaySound("stages", "long")
end

-- General
do
	local prev = 0
	function mod:PressureSurge(args)
		local t = GetTime()
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:DrainedSoulApplied(args)
	if not drainedSoulList[args.destName] then
		drainedSoulList[args.destName] = {args.amount or 1, GetTime()+soulDuration, soulDuration}
	else
		drainedSoulList[args.destName][1] = args.amount or 1
		drainedSoulList[args.destName][2] = GetTime()+soulDuration
	end
	self:SetInfoBarsByTable(args.spellId, drainedSoulList, true)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 2 == 0 or amount > 5 then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			if amount > 3 then
				self:PlaySound(args.spellId, amount > 6 and "warning" or "alarm", nil, args.destName)
			end
		end
	end
end

function mod:DrainedSoulRemoved(args)
	if self:Tank(args.destName) then
		drainedSoulList[args.destName] = nil
		hiddenDrainedSoulList[args.destName] = nil
	else
		if self:Me(args.destGUID) then
			self:PersonalMessage(args.spellId, false, CL.removed:format(args.spellName))
			self:PlaySound(args.spellId, "warning", nil, args.destName)
		end
		if hiddenDrainedSoulList[args.destName] then -- Support for Mythic, you keep the debuff after death
			hiddenDrainedSoulList[args.destName][1] = 0
			hiddenDrainedSoulList[args.destName][2] = 0
		else
			drainedSoulList[args.destName][1] = 0
			drainedSoulList[args.destName][2] = 0
		end
	end
	self:SetInfoBarsByTable(args.spellId, drainedSoulList, true)
end

-- Stage 1
do
	local prev = 0
	function mod:PainfulMemories(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message2(args.spellId, "orange")
			self:PlaySound(args.spellId, "long")
			self:CDBar(297934, 65) -- Longing
		end
	end

	function mod:Longing(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message2(args.spellId, "orange")
			self:PlaySound(args.spellId, "long")
			self:CDBar(297937, 20) -- Painful Memories
		end
	end
end

do
	local prev = 0
	function mod:Torment(args)
		local t = GetTime()
		if t-prev > 1.5 then
			prev = t
			self:Message2(args.spellId, "red")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

-- Aethane
function mod:LightningOrbs(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 18.5)
end

function mod:ChainLightning(args)
	local canDo, ready = self:Interrupter(args.sourceGUID)
	if canDo then
		self:Message2(args.spellId, "orange")
		if ready then
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:ColdBlast(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 11)
end

function mod:ColdBlastApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	if amount == 3 then
		self:PlaySound(args.spellId, "warning", nil, args.destName)
	end
end

function mod:IceShard(args)
	self:Message2(args.spellId, "purple")
	self:PlaySound(args.spellId, "warning")
end

-- Cyranus
function mod:SerratedEdgeApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:ChargedSpear(args)
	self:CDBar(args.spellId, self:Mythic() and (stage == 3 and 15 or 18) or stage == 3 and 13.5 or 40)
end

function mod:ChargedSpearApplied(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "alert", nil, args.destName)
	if self:Me(args.destGUID) then
		self:Flash(args.spellId)
		self:Say(args.spellId)
		self:SayCountdown(args.spellId, self:Mythic() and 3 or 5)
	end
end

-- Overzealous Hulk
function mod:GroundPound(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "alarm")
end

function mod:Infuriated(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
end

-- Queen Azshara
function mod:Beckon(args)
	self:Message2(299094, "yellow")
	self:CDBar(299094, self:Mythic() and (stage == 1 and 45 or stage == 3 and 35 or stage == 4 and 98 or 80) or (stage > 2 and 70 or 85)) -- XXX Stage 4 unkown timer
end

function mod:RAID_BOSS_WHISPER(_, msg)
	if msg:find("299094", nil, true) then -- Beckon
		self:PersonalMessage(299094)
		self:PlaySound(299094, "Alarm")
		self:Flash(299094)
		self:Say(299094)
	end
end

-- Intermission
function mod:QueensDecree(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "long")
	self:StopBar(297937) -- Painful Memories
	self:StopBar(298014) -- Cold Blast
	self:StopBar(297934) -- Longing
	self:StopBar(298121) -- Lightning Orbs
	self:StopBar(299094) -- Beckon
	self:StopBar(298787) -- Arcane Orbs
	self:StopBar(-20480) -- Overzealous Hulk
	self:StopBar(301078) -- Charged Spear
	self:StopBar(300478) -- Divide and Conquer
	fails = 0
	self:CDBar("stages", 29.2, CL.active, "achievement_boss_azshara") -- Azshara active
	self:CDBar("stages", 36.2, CL.intermission, 299250) -- Queens Decree
end

do
	local decreeTimer = nil
	local debuffs = {}
	local function announce()
		if #debuffs == 2 then
			mod:PersonalMessage(299250, false, L.yourDecree2:format(debuffs[1], debuffs[2]))
		else
			mod:PersonalMessage(299250, false, L.yourDecree:format(debuffs[1]))
		end
		mod:PlaySound(299250, "alarm")
		debuffs = {}
	end

	function mod:PersonalDecrees(args)
		if self:Me(args.destGUID) then
			debuffs[#debuffs+1] = L[args.spellId]
			if #debuffs == 1 then
				self:SimpleTimer(announce, 0.1)
			end
			if args.spellId == 299254 then -- Stand Together!
				self:Yell2(299250, args.spellName)
				if #debuffs == 1 then
					if self:GetOption("custom_off_repeating_decree_chat") and not self:LFR() then
						decreeTimer = self:ScheduleRepeatingTimer(SendChatMessage, 2, L.hugSay:format(args.destName), "YELL")
					end
				elseif debuffs[1] == L[299253] then -- Stay!
					if self:GetOption("custom_off_repeating_decree_chat") and not self:LFR() then -- Stand Together! & Stay!
						if decreeTimer then self:CancelTimer(decreeTimer) end
						decreeTimer = self:ScheduleRepeatingTimer(SendChatMessage, 2, L.hugNoMoveSay:format(args.destName), "YELL")
					end
				end
			elseif args.spellId == 299255 then -- Stand Alone!
				self:Say(299250, args.spellName)
				if self:GetOption("custom_off_repeating_decree_chat") and not self:LFR() then
					decreeTimer = self:ScheduleRepeatingTimer(SendChatMessage, 2, L.avoidSay:format(args.destName), "SAY")
				end
			elseif args.spellId == 299253 and debuffs[1] == L[299254] then -- Stay! & Stand Together!
				if self:GetOption("custom_off_repeating_decree_chat") and not self:LFR() then
					if decreeTimer then self:CancelTimer(decreeTimer) end
					decreeTimer = self:ScheduleRepeatingTimer(SendChatMessage, 2, L.hugNoMoveSay:format(args.destName), "YELL")
				end
			end
		end
	end

	function mod:PersonalDecreesRemoved(args)
		if decreeTimer and self:Me(args.destGUID) then
			self:CancelTimer(decreeTimer)
			decreeTimer = nil
		end
	end
end

function mod:Sanction(args)
	fails = fails+1
end

-- Stage 2
function mod:ReversalOfFortune(args)
	self:PlaySound(args.spellId, "long")
	self:Message2(args.spellId, "cyan", L.reversal)
	self:CastBar(args.spellId, 30, L.reversal)
	self:CDBar(args.spellId, 80, L.reversal)
end

function mod:ArcaneMasteryApplied(args)
	stage = 2
	self:PlaySound("stages", "long")
	self:Message2("stages", "cyan", L.fails_message:format(CL.stage:format(stage), fails), false)
	detonationCount = 1
	burstCount = 1

	self:Bar(304475, 4) -- Arcane Jolt
	self:Bar(299094, 12.8) -- Beckon
	self:Bar(303657, self:Mythic() and 43 or 40) -- Arcane Burst
	self:Bar(297371, self:Mythic() and 55.8 or 56, L.reversal) -- Reversal of Fortune
	self:Bar(300519, self:Mythic() and 67.8 or 62.9, CL.count:format(self:SpellName(300519), detonationCount)) -- Arcane Detonation
	self:Bar(-20408, 23, nil, "inv_misc_nagamale") -- Azshara's Devoted
	self:Bar(-20410, self:Mythic() and 103.5 or 93.5, nil, "achievement_boss_nagacentaur") -- Azshara's Indomitable
	if self:Mythic() then
		self:Bar(300478, 33) -- Divide and Conquer
	end
end

function mod:ArcaneVulnerabilityApplied(args)
	if self:Me(args.destGUID) then
		local amount = args.amount or 1
		if amount % 5 == 0 then
			self:StackMessage(args.spellId, args.destName, amount, "blue")
			if amount > 19 then
				self:PlaySound(args.spellId, "alarm")
			end
		end
	end
end

function mod:ArcaneJolt(args)
	self:Message2(args.spellId, "cyan")
	self:PlaySound(args.spellId, "info")
	self:CDBar(args.spellId, 6.1)
end

function mod:ArcaneDetonation(args)
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, detonationCount))
	self:PlaySound(args.spellId, "warning")
	self:CastBar(args.spellId, self:Mythic() and 4 or self:Heroic() and 5 or 6, CL.count:format(args.spellName, detonationCount)) -- Mythic 4s, Heroic 5s, Normal/LFR 6s
	detonationCount = detonationCount + 1
	if self:Mythic() and stage == 3  and detonationCount < 4 then
		local cd = detonationCount == 2 and 70 or 50 -- 59, 70, 50 / Stage end
		self:CDBar(args.spellId, cd, CL.count:format(args.spellName, detonationCount))
	elseif stage == 2 or not self:Mythic() then
		self:CDBar(args.spellId, 75, CL.count:format(args.spellName, detonationCount))
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:ArcaneBurstApplied(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			burstCount = burstCount + 1
			self:Bar(303657, self:Mythic() and (burstCount == 3 and 60 or 45) or 70)
		end
		if self:Me(args.destGUID) then
			self:Say(args.spellId)
			self:SayCountdown(args.spellId, self:Mythic() and 15 or 30)
			self:PlaySound(args.spellId, "warning")
		end
		self:TargetsMessage(args.spellId, "yellow", playerList)
		if self:GetOption(arcaneBurstMarker) then
			SetRaidTarget(args.destName, #playerList)
		end
	end

	function mod:ArcaneBurstRemoved(args)
		if self:Me(args.destGUID) then
			self:CancelSayCountdown(args.spellId)
		end
		if self:GetOption(arcaneBurstMarker) then
			SetRaidTarget(args.destName, 0)
		end
	end
end

-- Stage 3
function mod:StaticShock(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alert", nil, args.destName)
		self:Flash(args.spellId)
		self:Say(args.spellId)
	end
end

function mod:CrystallineShield(args)
	self:TargetMessage2(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "long", nil, args.destName)
end

function mod:GreaterReversalOfFortune(args)
	self:PlaySound(args.spellId, "long")
	self:Message2(args.spellId, "cyan", L.greater_reversal)
	self:CastBar(args.spellId, 30, L.greater_reversal)
	self:CDBar(args.spellId, self:Mythic() and (stage == 4 and 81 or 90) or 70, L.greater_reversal)
end

-- Stage 4
do
	local prev = 0
	function mod:NetherPortal(args)
		local t = args.time
		if t-prev > 2 then
			prev = t
			self:Message2(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
			portalCount = portalCount + 1
			self:Bar(args.spellId, self:Mythic() and portalTimersMythic[portalCount] or portalCount == 2 and 40 or portalCount == 3 and 44 or 35) -- XXX Make a Table for more data
		end
	end
end

function mod:PiercingGaze(args)
	self:Message2(args.spellId, "orange")
	self:PlaySound(args.spellId, "long")
	piercingCount = piercingCount + 1
	self:Bar(args.spellId, self:Mythic() and piercingTimersMythic[piercingCount] or 45)
end

function mod:VoidTouchedSuccess(args)
	self:CDBar(args.spellId, 7.5)
end

function mod:VoidTouchedApplied(args)
	local amount = args.amount or 1
	self:StackMessage(args.spellId, args.destName, amount, "purple")
	self:PlaySound(args.spellId, amount > 2 and "warning" or "alert", nil, args.destName)
end

function mod:Overload(args)
	self:Message2(args.spellId, "red", CL.count:format(args.spellName, overloadCount))
	self:PlaySound(args.spellId, "warning")
	overloadCount = overloadCount + 1
	self:CDBar(args.spellId, self:Mythic() and 55 or 45, CL.count:format(args.spellName, overloadCount))
end

function mod:EssenceofAzerothApplied(args)
	if self:Me(args.destGUID) then
		local t = self:Mythic() and 25 or 40
		self:PersonalMessage(args.spellId, false, L.you_die_message:format(t))
		self:PlaySound(args.spellId, "alert", nil, args.destName)
		self:Flash(args.spellId)
		self:Bar(args.spellId, t, L.you_die)
	else
		self:TargetMessage2(args.spellId, "yellow", args.destName)
	end
end

function mod:EssenceofAzerothRemoved(args)
	if self:Me(args.destGUID) then
		self:StopBar(L.you_die)
	end
end

function mod:SystemShockApplied(args)
	self:TargetMessage2(args.spellId, "cyan", args.destName)
	if self:Me(args.destGUID) then
		self:PlaySound(args.spellId, "alarm", nil, args.destName)
	end
end

do
	local prev = 0
	function mod:NetherPortalDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(303986, "alarm")
				self:PersonalMessage(303986, "underyou")
			end
		end
	end
end

do
	local prev = 0
	function mod:GroundDamage(args)
		if self:Me(args.destGUID) then
			local t = args.time
			if t-prev > 2 then
				prev = t
				self:PlaySound(args.spellId, "alarm")
				self:PersonalMessage(args.spellId, "underyou")
			end
		end
	end
end
