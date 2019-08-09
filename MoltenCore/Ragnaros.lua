
--------------------------------------------------------------------------------
-- Module declaration
--

local mod, CL = BigWigs:NewBoss("Ragnaros ", 409, 1528) -- Space is intentional to prevent conflict with Ragnaros from Firelands
if not mod then return end
mod:RegisterEnableMob(11502)
mod.toggleOptions = {"submerge", "emerge", 20566}

--------------------------------------------------------------------------------
-- Locals
--

local sonsdead = 0

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.engage_trigger = "NOW FOR YOU,"
	L.submerge_trigger = "COME FORTH,"

	L.knockback_message = "Knockback!"
	L.knockback_bar = "Knockback"

	L.submerge = "Submerge"
	L.submerge_desc = "Warn for Ragnaros' submerge."
	L.submerge_icon = "misc_arrowdown"
	L.submerge_message = "Ragnaros down for 90 sec!"
	L.submerge_bar = "Submerge"

	L.emerge = "Emerge"
	L.emerge_desc = "Warn for Ragnaros' emerge."
	L.emerge_icon = "misc_arrowlup"
	L.emerge_message = "Ragnaros emerged, 3 mins until submerge!"
	L.emerge_bar = "Emerge"
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnBossEnable()
	--self:Yell("Engage", L.engage_trigger)
	--self:Yell("Submerge", L.submerge_trigger)

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_CAST_SUCCESS", "Knockback", 20566)

 	self:RegisterUnitEvent("UNIT_TARGETABLE_CHANGED", nil, "boss1")
	self:Death("Win", 11502)
	self:Death("SonDeaths", 12143)
end

function mod:OnEngage()
	sonsdead = 0
	self:Bar("submerge", 180, L.submerge_bar, "misc_arrowdown")
	self:Message("submerge", "yellow", nil, CL.custom_min:format(L.submerge, 3), "misc_arrowdown")
	self:DelayedMessage("submerge", 60, "yellow", CL.custom_min:format(L.submerge, 2))
	self:DelayedMessage("submerge", 120, "yellow", CL.custom_min:format(L.submerge, 1))
	self:DelayedMessage("submerge", 150, "yellow", CL.custom_sec:format(L.submerge, 30))
	self:DelayedMessage("submerge", 170, "orange", CL.custom_sec:format(L.submerge, 10), false, "Alarm")
	self:DelayedMessage("submerge", 175, "orange", CL.custom_sec:format(L.submerge, 5), false, "Alarm")
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Knockback(args)
	self:Message(args.spellId, "red", nil, L.knockback_message)
	self:Bar(args.spellId, 28, L.knockback_bar)
end

function mod:Emerge()
	sonsdead = 10 -- Block this firing again if sons are killed after he emerges
	self:Message("emerge", "yellow", "Long", L.emerge_message, "misc_arrowlup")
	self:Bar("submerge", 180, L.submerge_bar, "misc_arrowdown")
	self:DelayedMessage("submerge", 60, "yellow", CL.custom_min:format(L.submerge, 2))
	self:DelayedMessage("submerge", 120, "yellow", CL.custom_min:format(L.submerge, 1))
	self:DelayedMessage("submerge", 150, "yellow", CL.custom_sec:format(L.submerge, 30))
	self:DelayedMessage("submerge", 170, "orange", CL.custom_sec:format(L.submerge, 10), false, "Alarm")
	self:DelayedMessage("submerge", 175, "orange", CL.custom_sec:format(L.submerge, 5), false, "Alarm")
end

function mod:Submerge()
	sonsdead = 0 -- reset counter
	self:StopBar(L.knockback_bar)
	self:Message("submerge", "yellow", "Long", L.submerge_message, "misc_arrowdown")
	self:Bar("emerge", 90, L.emerge_bar, "misc_arrowlup")
	self:DelayedMessage("emerge", 30, "yellow", CL.custom_sec:format(L.emerge, 60))
	self:DelayedMessage("emerge", 60, "yellow", CL.custom_sec:format(L.emerge, 30))
	self:DelayedMessage("emerge", 80, "orange", CL.custom_sec:format(L.emerge, 10), false, "Alarm")
	self:DelayedMessage("emerge", 85, "orange", CL.custom_sec:format(L.emerge, 5), false, "Alarm")
end

function mod:SonDeaths()
	sonsdead = sonsdead + 1
	if sonsdead < 9 then
		self:Message("emerge", "green", nil, CL.add_killed:format(sonsdead, 8), "spell_fire_elemental_totem")
	end
	if sonsdead == 8 then
		self:StopBar(L.emerge_bar)
		self:CancelDelayedMessage(CL.custom_sec:format(L.emerge, 60))
		self:CancelDelayedMessage(CL.custom_sec:format(L.emerge, 30))
		self:CancelDelayedMessage(CL.custom_sec:format(L.emerge, 10))
		self:CancelDelayedMessage(CL.custom_sec:format(L.emerge, 5))
	end
end

function mod:UNIT_TARGETABLE_CHANGED(_, unit)
	if UnitCanAttack("player", unit) then
		self:Emerge()
	else
		self:Submerge()
	end
end

