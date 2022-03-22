-------------------------------------------------------------------------------
--  Module Declaration
--

local mod, CL = BigWigs:NewBoss("Nalorakk", 568, 187)
if not mod then return end
mod:RegisterEnableMob(23576)
mod.engageId = 1190
mod:SetRespawnTime(30)

-------------------------------------------------------------------------------
--  Localization
--

local L = mod:GetLocale()
if L then
	L.troll_message = "Troll Form"
	L.troll_trigger = "Make way for da Nalorakk!"
	L.bear_trigger = "You call on da beast, you gonna get more dan you bargain for!"
end

-------------------------------------------------------------------------------
--  Initialization
--

function mod:GetOptions()
	return {
		"stages",
		42398, -- Deafening Roar
		"berserk",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:Log("SPELL_AURA_APPLIED", "DeafeningRoar", 42398)
end

function mod:OnEngage()
	self:Berserk(600)
	self:Bar("stages", 45, 7090, "ability_hunter_pet_bear") -- 7090 = Bear Form
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:CHAT_MSG_MONSTER_YELL(_, msg)
	if msg == L.troll_trigger then
		self:MessageOld("stages", "red", nil, L.troll_message, "achievement_character_troll_male")
		self:Bar("stages", 45, 7090, "ability_hunter_pet_bear") -- 7090 = Bear Form
	elseif msg == L.bear_trigger then
		self:MessageOld("stages", "red", nil, 7090, "ability_hunter_pet_bear") -- 7090 = Bear Form
		self:Bar("stages", 30, L.troll_message, "achievement_character_troll_male")
	end
end

do
	local playerList = mod:NewTargetList()
	function mod:DeafeningRoar(args)
		playerList[#playerList+1] = args.destName
		if #playerList == 1 then
			self:ScheduleTimer("TargetMessageOld", 0.3, args.spellId, playerList, "yellow", "info", nil, nil, true)
		end
	end
end
