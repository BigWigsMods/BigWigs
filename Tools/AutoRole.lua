RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN") -- We don't need to participate in role polls

local LibSpec = LibStub("LibSpecialization")
local myName = UnitNameUnmodified("player")

local frame = CreateFrame("Frame")
local IsInGroup, IsPartyLFG = IsInGroup, IsPartyLFG
local InCombatLockdown, UnitAffectingCombat = InCombatLockdown, UnitAffectingCombat
local UnitGroupRolesAssigned, UnitSetRole = UnitGroupRolesAssigned, UnitSetRole

local function UpdateMyRole()
	local _, role = LibSpec.MySpecialization()
	if IsInGroup() and not IsPartyLFG() and UnitGroupRolesAssigned("player") ~= role then
		if InCombatLockdown() or UnitAffectingCombat("player") then
			frame:RegisterEvent("PLAYER_REGEN_ENABLED")
			return
		end
		UnitSetRole("player", role)
	end
end
LibSpec.RegisterPlayerSpecChange({}, UpdateMyRole)

frame:SetScript("OnEvent", function(self, event)
	if event == "GROUP_FORMED" then
		UpdateMyRole()
	else -- PLAYER_REGEN_ENABLED
		self:UnregisterEvent(event)
		UpdateMyRole()
	end
end)
frame:RegisterEvent("GROUP_FORMED")

local _, addonTbl = ...
local L = addonTbl.API:GetLocale("BigWigs")
addonTbl.API.RegisterToolOptions("AutoRole", {
	type = "group",
	name = L.autoRoleTitle,
	args = {
		explainer = {
			type = "description",
			name = L.autoRoleExplainer,
			order = 0,
			width = "full",
			fontSize = "large",
		},
	},
})
