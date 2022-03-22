-------------------------------------------------------------------------------
--  Module Declaration
--

local mod, CL = BigWigs:NewBoss("Jan'alai", 568, 188)
if not mod then return end
mod:RegisterEnableMob(23578)
mod:SetEncounterID(1191)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
--  Locals
--

local castCollector = {}

-------------------------------------------------------------------------------
--  Initialization
--

function mod:GetOptions()
	return {
		43962, -- Summon Amani'shi Hatcher
		{43140, "ICON"}, -- Flame Breath (this is the aura debuff spellid)
		42630, -- Fire Bomb
		8599, -- Enrage
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")

	self:Log("SPELL_CAST_START", "FlameBreath", 43140) -- This is the actual cast spellid
	self:Log("SPELL_CAST_SUCCESS", "FlameBreathSuccess", 43140)
end

function mod:OnEngage()
	castCollector = {}
	self:RegisterEvent("UNIT_HEALTH")
	self:CDBar(43962, 12, 43962, "achievement_character_troll_male") -- Amani'shi Hatchers
	self:Bar(8599, 300) -- Enrage (Fake id)
	self:Berserk(600)
end

-------------------------------------------------------------------------------
--  Event Handlers
--

do
	local function printTarget(self, player)
		self:TargetMessageOld(43140, player, "red", "alert")
		self:PrimaryIcon(9431407497, player)
	end
	function mod:FlameBreath(args)
		self:GetUnitTarget(printTarget, 0.4, args.sourceGUID)
	end
	function mod:FlameBreathSuccess()
		self:PrimaryIcon(43140)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, castGUID, spellId)
	if spellId == 43962 and not castCollector[castGUID] then -- Summon Amani'shi Hatcher
		castCollector[castGUID] = true
		self:MessageOld(43962, "yellow", "long", 43962, "achievement_character_troll_male")
		self:CDBar(43962, 92, 43962, "achievement_character_troll_male")
	elseif spellId == 43098 and not castCollector[castGUID] then -- Teleport to Center (to cast Fire Bombs)
		castCollector[castGUID] = true
		self:MessageOld(42630, "orange", "info", CL.incoming:format(self:SpellName(42630)))
		self:Bar(42630, 12)
	end
end

function mod:UNIT_HEALTH(event, unit)
	if self:MobId(self:UnitGUID(unit)) == 23578 then
		local hp = self:GetHealth(unit)
		if hp > 36 and hp < 40 then
			self:UnregisterEvent(event)
			self:MessageOld(43962, "yellow", nil, CL.soon:format(self:SpellName(43144)), false) -- Hatch All Eggs Soon
		end
	end
end
