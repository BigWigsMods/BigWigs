if not GetNumGroupMembers then return end
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Stone Guard", 896, 679)
if not mod then return end
mod:RegisterEnableMob(60051, 60043, 59915) --Cobalt Jade Jasper

--------------------------------------------------------------------------------
-- Locals
--

local cobaltMine = (GetSpellInfo(129424))
local jasperChainsTargets = mod:NewTargetList()

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:NewLocale("enUS", true)
if L then
	L.overload = "Overload" -- maybe should use a spellId that says exactly "Overload"
	L.overload_desc = "Warning for all types of overloads."
	L.overload_icon = 77222 -- overload like icon
end
L = mod:GetLocale()

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		{"ej:5772", "FLASHSHAKE", "SAY"}, {130395, "FLASHSHAKE", "PROXIMITY"},
		"overload", "berserk", "bosskill",
	}, {
		["ej:5772"] = "ej:5771",
		[130395] = "ej:5774",
		overload = "general",
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:Log("SPELL_AURA_APPLIED", "JasperChainsApplied", 130395)
	self:Log("SPELL_AURA_REMOVED", "JasperChainsRemoved", 130395)
	self:Emote("Overload", L["overload"])

	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Death("Win", 60051) -- they share HP
end

function mod:OnEngage(diff)

	self:Berserk(360) -- assume

end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Overload(msg, boss)
	self:Message("overload", msg:format(boss), "Important", L["overload_icon"], "Alarm")
end

do
	local scheduled = nil
	local function jasperChains(spellName)
		mod:TargetMessage(130395, spellName, jasperChainsTargets, "Attention", 130395, "Info")
		scheduled = nil
	end
	function mod:JasperChainsApplied(player, _, _, _, spellName)
		jasperChainsTargets[#jasperChainsTargets + 1] = player
		if UnitIsUnit(player, "player") then
			self:FlashShake(130395)
			-- this is kind of a reverse proximity now, it should help to know when you are actually close as you are supposed to be
			self:OpenProximity(10, 130395)
		end
		if not scheduled then
			scheduled = true
			self:ScheduleTimer(jasperChains, 0.1, spellName)
		end
	end
end

function mod:JasperChainsRemoved(player, _, _, _, spellName)
	if UnitIsUnit("player", player) then
		self:LocalMessage(130395, CL["you"]:format(spellName), "Personal", 130395)
		self:CloseProximity(130395)
	end
end

do
	local prev = 0
	function mod:UNIT_SPELLCAST_SUCCEEDED(_, _, spellName, _, _, spellId)
		if spellName == cobaltMine then
			local t = GetTime()
			if t-prev > 5 then
				prev = t
				local player
				for i=1, 4 do
					if UnitName("boss"..i) == "Cobalt Guardian" then
						player = UnitExists("boss"..i.."target")
						if player then
							-- still does not work, gives tank as target all the time
							player = UnitName("boss"..i.."target")
						end
					end
				end
				if player then
					if UnitIsUnit("player", player) then
						self:FlashShake("ej:5772")
						self:Say("ej:5772", CL["say"]:format(spellName))
						self:Bar("ej:5772", ("%s (%s)"):format(spellName, player), 3, spellId) -- so you can get super emphasize countdown before explosion
					end
					self:TargetMessage("ej:5772", spellName, player, "Urgent", spellId, "Alarm")
				end
				--self:Bar("ej:5772", spellName, 11, spellId) -- this is the cooldown on the spell, it is too frequent to be useful
			end
		end
	end
end


