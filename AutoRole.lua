RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN") -- We don't need to participate in role polls

local LibSpec = LibStub("LibSpecialization")
local myName = UnitNameUnmodified("player")

local frame = CreateFrame("Frame")
local IsInGroup, IsPartyLFG = IsInGroup, IsPartyLFG
local InCombatLockdown, UnitAffectingCombat = InCombatLockdown, UnitAffectingCombat
local UnitGroupRolesAssigned, UnitSetRole = UnitGroupRolesAssigned, UnitSetRole

LibSpec:Register(frame, function(_, role, _, player)
	if myName == player and IsInGroup() and not IsPartyLFG() and UnitGroupRolesAssigned("player") ~= role then
		if InCombatLockdown() or UnitAffectingCombat("player") then
			frame:RegisterEvent("PLAYER_REGEN_ENABLED")
			return
		end
		UnitSetRole("player", role)
	end
end)

frame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	if IsInGroup() and not IsPartyLFG() then
		local _, role = LibSpec:MySpecialization()
		if UnitGroupRolesAssigned("player") ~= role then
			UnitSetRole("player", role)
		end
	end
end)
