--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Kil'jaeden", 580, 1596)
if not mod then return end
mod:RegisterEnableMob(25315, 25588) -- Kil'jaeden, Hand of the Deceiver
mod:SetAllowWin(true)
mod:SetEncounterID(729)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local playerList = mod:NewTargetList()
local sinister1 = false
local sinister2 = false
local handDeathCount = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.bomb_cast = "Incoming Big Bomb"
	L.bomb_nextbar = "Possible Bomb"
	L.bomb_warning = "Possible Bomb in ~10sec"

	L.orb = "Shield Orb"
	L.orb_desc = "Warn when a Shield Orb is shadowbolting."
	L.orb_icon = 45680
	L.orb_shooting = "Orb Alive - Shooting People!"

	L.shield_up = "Shield is UP!"
	L.deceiver_dies = "Deceiver #%d Killed"

	L.blueorb = "Dragon Orb"
	L.blueorb_desc = "Warns on Blue Dragonflight Orb spawns."
	L.blueorb_icon = 23018
	L.blueorb_message = "Blue Dragonflight Orb ready!"

	L.kalec_yell = "I will channel my powers into the orbs! Be ready!"
	L.kalec_yell2 = "I have empowered another orb! Use it quickly!"
	L.kalec_yell3 = "Another orb is ready! Make haste!"
	L.kalec_yell4 = "I have channeled all I can! The power is in your hands!"
	L.phase3_trigger = "I will not be denied! This world shall fall!"
	L.phase4_trigger = "Do not harbor false hope. You cannot win!"
	L.phase5_trigger = "Ragh! The powers of the Sunwell turn against me! What have you done? What have you done?!"
end

--------------------------------------------------------------------------------
-- Initialization
--

local fireBloomMarker = mod:AddMarkerOption(false, "player", 1, 45641, 1, 2, 3, 4, 5) -- Fire Bloom
function mod:GetOptions()
	return {
		"stages",
		"proximity",
		45892, -- Sinister Reflection
		45848, -- Shield of the Blue
		"orb",
		{45641, "SAY"}, -- Fire Bloom
		fireBloomMarker,
		45885, -- Shadow Spike
		45737, -- Flame Dart
		"blueorb",
		46605, -- Darkness of a Thousand Souls
	},nil,{
		[46605] = CL.bomb, -- Darkness of a Thousand Souls (Bomb)
	}
end

function mod:OnBossEnable()
	handDeathCount = 0 -- Engage is a little slow
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:Log("SPELL_CAST_SUCCESS", "FelfirePortal", 46875) -- Hack to engage the module because ENCOUNTER_START doesn't fire until stage 2

	self:Log("SPELL_CAST_SUCCESS", "SinisterReflection", 45892)
	self:Log("SPELL_CAST_SUCCESS", "ShieldOfTheBlue", 45848)
	self:Log("SPELL_DAMAGE", "ShadowBoltDamage", 45680)
	self:Log("SPELL_MISSED", "ShadowBoltDamage", 45680)
	self:Log("SPELL_AURA_APPLIED", "FireBloom", 45641)
	self:Log("SPELL_AURA_APPLIED", "ShadowSpike", 45885)
	self:Log("SPELL_CAST_START", "ShadowSpikeCast", 46680)

	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Death("HandOfTheDeceiverDeaths", 25588) -- Hand of the Deceiver
	self:Death("Win", 25315)
end

function mod:OnEngage()
	handDeathCount = 0
	sinister1 = false
	sinister2 = false
	self:SetStage(1)
	table.wipe(playerList)

	self:MessageOld("stages", "cyan", "info", CL.stage:format(1), false)

	self:RegisterEvent("UNIT_HEALTH")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:FelfirePortal()
	if not self:IsEngaged() then
		self:Engage()
	end
end

function mod:SinisterReflection(args)
	self:CancelDelayedMessage(L.bomb_warning)
	self:StopBar(L.bomb_nextbar)
	self:MessageOld(args.spellId, "yellow")

	self:Bar(45737, 57) -- Flame Dart
	if self:GetStage() == 2 or self:GetStage() == 3 then
		self:Bar("blueorb", 37, L.blueorb, L.blueorb_icon)
	elseif self:GetStage() == 4 then
		self:Bar("blueorb", 45, L.blueorb, L.blueorb_icon)
	end
end

function mod:ShieldOfTheBlue(args)
	self:MessageOld(args.spellId, "orange", "info", L.shield_up)
end

do
	local prev = 0
	function mod:ShadowBoltDamage(args)
		local t = args.time
		if t-prev > 10 then
			prev = t
			self:MessageOld("orb", "yellow", "alert", L.orb_shooting, L.orb_icon)
		end
	end
end

function mod:FireBloom(args)
	playerList[#playerList+1] = args.destName
	if #playerList == 1 then
		self:Bar(args.spellId, 20)
		self:ScheduleTimer("TargetMessageOld", 0.3, args.spellId, playerList, "red", "warning")
	end
	if self:Me(args.destGUID) then
		self:Say(args.spellId)
	end
	self:CustomIcon(fireBloomMarker, args.destName, #playerList)
end

function mod:ShadowSpike(args)
	self:TargetBar(args.spellId, 10, args.destName)
end

function mod:ShadowSpikeCast(args)
	self:CastBar(45885, 28.7)
	self:MessageOld(45885, "yellow", nil, CL.casting:format(args.spellName))
end

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 25315 then
		local health = self:GetHealth(unit)
		if not sinister1 and health > 86 and health <= 88 then
			sinister1 = true
			self:MessageOld(45892, "yellow", nil, CL.soon:format(self:SpellName(45892)), false) -- Sinister Reflection
		elseif not sinister2 and health > 56 and health <= 58 then
			sinister2 = true
			self:MessageOld(45892, "yellow", nil, CL.soon:format(self:SpellName(45892)), false)
		elseif health <= 28 then
			if health > 26 then
				self:MessageOld(45892, "yellow", nil, CL.soon:format(self:SpellName(45892)), false)
			end
			self:UnregisterEvent(event)
		end
	end
end

function mod:HandOfTheDeceiverDeaths()
	handDeathCount = handDeathCount + 1
	if handDeathCount == 3 then
		self:SetStage(2)
		local text = CL.stage:format(2)
		self:MessageOld("stages", "cyan", "info", text, false)
		self:Bar("stages", 10, text, "Spell_Shadow_Charm")
		self:OpenProximity("proximity", 10)
	else
		self:MessageOld("stages", "cyan", "info", L.deceiver_dies:format(handDeathCount), false)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(_, _, unit)
	if unit == self.displayName then
		self:Bar(46605, 8, CL.explosion) -- Darkness of a Thousand Souls
		self:MessageOld(46605, "orange", "long", L.bomb_cast)
		if self:GetStage() == 3 or self:GetStage() == 4 then
			self:Bar(46605, 46, L.bomb_nextbar)
			self:DelayedMessage(46605, 36, "yellow", L.bomb_warning, false)
		elseif self:GetStage() == 5 then
			self:Bar(46605, 25, L.bomb_nextbar)
			self:DelayedMessage(46605, 15, "yellow", L.bomb_warning, false)
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg == L.kalec_yell or msg == L.kalec_yell2 or msg == L.kalec_yell3 then
		self:Bar(46605, 40, L.bomb_nextbar)
		self:DelayedMessage(46605, 30, "yellow", L.bomb_warning, false)
		self:MessageOld("blueorb", "yellow", nil, L["blueorb_message"], L.blueorb_icon)
	elseif msg == L.kalec_yell4 then
		self:Bar(46605, 13, L.bomb_nextbar)
		self:DelayedMessage(46605, 3, "yellow", L.bomb_warning, false)
		self:MessageOld("blueorb", "yellow", nil, L["blueorb_message"], L.blueorb_icon)
	elseif msg == L.phase3_trigger then
		self:SetStage(3)
		self:MessageOld("stages", "cyan", "info", CL.stage:format(3), false)
	elseif msg == L.phase4_trigger then
		self:SetStage(4)
		self:MessageOld("stages", "cyan", "info", CL.stage:format(4), false)
	elseif msg == L.phase5_trigger then
		self:SetStage(5)
		self:MessageOld("stages", "cyan", "info", CL.stage:format(5), false)
	end
end
