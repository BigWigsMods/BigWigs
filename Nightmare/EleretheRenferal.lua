
--------------------------------------------------------------------------------
-- TODO List:
-- - All the timers
-- - Mythic abilitys
-- - 212993 Shimmering Feather is not in the combat log

--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Elerethe Renferal", 1520, 1744)
if not mod then return end
mod:RegisterEnableMob(106087)
mod.engageId = 1876
mod.respawnTime = 30

--------------------------------------------------------------------------------
-- Locals
--

local twistingShadowsCount = 1
local webOfPainTargets = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.isLinkedWith = "%s is linked with %s"
	L.yourLink = "You are linked with %s"
	L.yourLinkShort = "Linked with %s"

	L.custom_off_webofpain_marker = "Web of Pain marker"
	L.custom_off_webofpain_marker_desc = "Mark Web of Pain targets with {rt1}{rt2}{rt3}{rt4}, requires promoted or leader. The tanks will be marked with {rt1} and {rt2}. The other targets with {rt3} and {rt4}."
	L.custom_off_webofpain_marker_icon = 1

end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		--[[ Spider Form ]]--
		215300, -- Web of Pain
		"custom_off_webofpain_marker",
		212364, -- Feeding Time
		214348, -- Vile Ambush
		{215443, "SAY", "FLASH"}, -- Necrotic Venom

		--[[ Roc Form ]]--
		212707, -- Gathering Clouds
		210948, -- Dark Storm
		{210864, "SAY", "FLASH"}, -- Twisting Shadows
		210547, -- Razor Wing
		{215582, "TANK"}, -- Raking Talons
		218124, -- Violent Winds (mythic)

		--[[ General ]]--
		"stages",
		213124, -- Venomous Pool
		"berserk",
	},{
		[215300] = -13259, -- Spider Form
		[212707] = -13263, -- Roc Form
		["stages"] = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", nil, "boss1")

	--[[ Spider Form ]]--
	self:Log("SPELL_AURA_APPLIED", "WebOfPainApplied", 215300) -- 215307 is applied to the other player
	self:Log("SPELL_AURA_REMOVED", "WebOfPainRemoved", 215300)
	self:Log("SPELL_CAST_SUCCESS", "VileAmbush", 214348)
	self:Log("SPELL_CAST_SUCCESS", "NecroticVenom", 215443)

	--[[ Roc Form ]]--
	self:Log("SPELL_CAST_START", "GatheringCloudsStart", 212707)
	self:Log("SPELL_CAST_START", "DarkStorm", 210948)
	self:Log("SPELL_CAST_SUCCESS", "TwistingShadows", 210864)
	self:Log("SPELL_CAST_START", "RazorWing", 210547)
	self:Log("SPELL_CAST_START", "RakingTalons", 215582)
	self:Log("SPELL_CAST_START", "ViolentWinds", 218124)

	--[[ General ]]--
	self:Log("SPELL_CAST_START", "StartDebuffScan", 215443, 210864) -- Necrotic Venom, Twisting Shadows
	self:Log("SPELL_AURA_APPLIED", "PoolDamage", 213124, 215489)
	self:Log("SPELL_AURA_APPLIED_DOSE", "PoolDamage", 213124, 215489)
	self:Log("SPELL_PERIODIC_DAMAGE", "PoolDamage", 213124, 215489)
	self:Log("SPELL_PERIODIC_MISSED", "PoolDamage", 213124, 215489)
end

function mod:OnEngage()
	twistingShadowsCount = 1

	self:Bar(215300, 6) -- Web of Pain
	self:Bar(212364, 16) -- Feeding Time
	self:Bar("stages", 91, -13263, "inv_ravenlordmount") -- Roc Form

	wipe(webOfPainTargets)
end

function mod:OnBossDisable()
	for player,_ in pairs(webOfPainTargets) do
		SetRaidTarget(player, 0)
	end
	wipe(webOfPainTargets)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

local function timeToTransform(self)
	local spiderFormIn = self:BarTimeLeft(-13259) -- Spider Form
	return spiderFormIn > 0 and spiderFormIn or self:BarTimeLeft(-13263) -- Roc Form
end

-- Blizzard made us write this awesome function due to a lack of SPELL_AURA_APPLIED events
-- Necrotic Venom: 215443
-- Twisting Shadows: 210864
do
	local scheduled, players, list = nil, {}, mod:NewTargetList()
	local key, spellName = 0, ""

	function mod:UNIT_AURA(_, unit) -- XXX get Blizz to fix this
		if UnitDebuff(unit, spellName) then
			local guid = UnitGUID(unit)
			if not players[guid] then
				players[guid] = true
				list[#list+1] = self:UnitName(unit)
				if unit == "player" then
					self:Message(key, "Personal", "Long", CL.you:format(spellName)) -- SetOption:215443,210864:::
					self:Flash(key)
					self:Say(key)

					local _, _, _, _, _, _, expires = UnitDebuff(unit, spellName)
					local remaining = expires-GetTime()
					self:Bar(key, remaining, CL.you:format(spellName))
					self:SayCountdown(key, remaining)
				else
					if scheduled then
						self:CancelTimer(scheduled)
						scheduled = nil
					end
					if #list == 2 then
						self:TargetMessage(key, list, "Urgent", "Warning") -- SetOption:215443,210864:Urgent:Warning:
					else
						scheduled = self:ScheduleTimer("TargetMessage", 0.5, key, list, "Urgent", "Warning") -- SetOption:215443,210864:Urgent:Warning:
					end
				end
			end
		end
	end

	function mod:StartDebuffScan(args)
		key, spellName = args.spellId, args.spellName
		wipe(players)
		self:RegisterEvent("UNIT_AURA")
		self:ScheduleTimer("UnregisterEvent", 5, "UNIT_AURA")
	end

	function mod:NecroticVenom(args)
		if timeToTransform(self) > 26 then -- skips the one before the transformation
			self:Bar(args.spellId, 22)
		end
	end

	function mod:TwistingShadows(args)
		twistingShadowsCount = twistingShadowsCount + 1
		local next = twistingShadowsCount == 2 and 40 or twistingShadowsCount == 4 and 33 or 22
		if timeToTransform(self) > next then
			self:CDBar(args.spellId, next)
		end
	end
end

--[[ Spider Form ]]--
function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, _, _, spellId)
	if spellId == 212364 then -- Feeding Time, there is also 214305, fires about 1.2s later
		self:Message(spellId, "Important", "Info")
		self:Bar(214348, 8.2) -- Vile Ambush
		if timeToTransform(self) > 51 then
			self:Bar(spellId, 51)
		end
	elseif spellId == 226039 then -- Bird Transform => Roc Form
		self:Message("stages", "Neutral", "Info", -13263, "inv_ravenlordmount") -- Roc Form
		twistingShadowsCount = 1
		self:CDBar(210864, 8) -- Twisting Shadows
		self:CDBar(212707, 15.7) -- Gathering Clouds
		self:Bar(210948, 27) -- Dark Storm
		self:Bar(215582, self:Mythic() and 63 or 53) -- Raking Talons
		self:Bar(210547, self:Mythic() and 70 or 60) -- Razor Wing
		if self:Mythic() then
			self:Bar(218124, 53) -- Violent Winds
		end
		self:Bar("stages", 134, -13259, "inv_spidermount") -- Spider Form
	elseif spellId == 226055 then -- Spider Transform => Spider Form
		self:Message("stages", "Neutral", "Info", -13259, "inv_spidermount") -- Spider Form
		self:Bar(215300, 6) -- Web of Pain
		self:Bar(212364, 16) -- Feeding Time
		self:Bar("stages", 97, -13263, "inv_ravenlordmount") -- Roc Form
	end
end

function mod:WebOfPainApplied(args)
	if self:Me(args.destGUID) then
		self:Message(args.spellId, "Personal", "Warning", L.yourLink:format(self:ColorName(args.sourceName)))
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		local remaining = expires-GetTime()
		self:Bar(args.spellId, remaining, L.yourLinkShort:format(self:ColorName(args.sourceName)))
	elseif self:Me(args.sourceGUID) then
		self:Message(args.spellId, "Personal", "Warning", L.yourLink:format(self:ColorName(args.destName)))
		local _, _, _, _, _, _, expires = UnitDebuff("player", args.spellName)
		local remaining = expires-GetTime()
		self:Bar(args.spellId, remaining, L.yourLinkShort:format(self:ColorName(args.destName)))
	elseif not self:CheckOption(args.spellId, "ME_ONLY") then
		self:Message(args.spellId, "Attention", nil, L.isLinkedWith:format(self:ColorName(args.sourceName), self:ColorName(args.destName)))
	end
	if self:GetOption("custom_off_webofpain_marker") then -- TODO
		webOfPainTargets[args.sourceName] = true
		webOfPainTargets[args.destName] = true
		if self:Tank(args.sourceName) or self:Tank(args.destName) then -- Tank link
			SetRaidTarget(args.sourceName, 1)
			SetRaidTarget(args.destName, 2)
		else -- Other link
			SetRaidTarget(args.sourceName, 3)
			SetRaidTarget(args.destName, 4)
		end
	end
end

function mod:WebOfPainRemoved(args)
	if self:GetOption("custom_off_webofpain_marker") then -- TODO
		SetRaidTarget(args.sourceName, 0)
		webOfPainTargets[args.sourceName] = nil
		SetRaidTarget(args.destName, 0)
		webOfPainTargets[args.destName] = nil
	end
end

function mod:VileAmbush(args)
	self:Message(args.spellId, "Attention", "Alarm")
end

function mod:GatheringCloudsStart(args)
	self:Message(args.spellId, "Attention", "Long", CL.casting:format(args.spellName))
	self:CastBar(args.spellId, 10.5) -- 2.5s cast + 8s duration = 10.5s total
end

--[[ Roc Form ]]--

function mod:DarkStorm(args)
	self:Message(args.spellId, "Neutral", "Info")
end


function mod:RazorWing(args)
	self:Message(args.spellId, "Important", "Alarm")
	self:CastBar(args.spellId, 4.5)
	if timeToTransform(self) > 32.9 then
		self:Bar(args.spellId, 32.9)
	end
end

function mod:RakingTalons(args)
	self:Message(args.spellId, "Attention", "Long")
	if timeToTransform(self) > 32.9 then
		self:Bar(args.spellId, 32.9)
	end
end

function mod:ViolentWinds(args)
	self:Message(args.spellId, "Urgent", "Info")
	self:CastBar(args.spellId, 6)
	if timeToTransform(self) > 39 then
		self:Bar(args.spellId, 39)
	end
end

--[[ General ]]--
do
	local prev = 0
	function mod:PoolDamage(args)
		local t = GetTime()
		if self:Me(args.destGUID) and t-prev > 1.5 then
			prev = t
			self:Message(213124, "Personal", "Alert", CL.underyou:format(args.spellName))
		end
	end
end
