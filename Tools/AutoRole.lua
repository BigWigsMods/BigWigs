RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN") -- We don't need to participate in role polls

local LibSpec = LibStub("LibSpecialization")
local myName = UnitNameUnmodified("player")
local canChangeRole = false

local frame = CreateFrame("Frame")
local IsInGroup, IsPartyLFG = IsInGroup, IsPartyLFG
local InCombatLockdown, UnitAffectingCombat = InCombatLockdown, UnitAffectingCombat
local UnitGroupRolesAssigned, UnitSetRole = UnitGroupRolesAssigned, UnitSetRole

local LibSpecTable = {}
LibSpec.RegisterGroup(LibSpecTable, function(_, role, _, player)
	if canChangeRole and myName == player and IsInGroup() and not IsPartyLFG() and UnitGroupRolesAssigned("player") ~= role then
		canChangeRole = false
		if InCombatLockdown() or UnitAffectingCombat("player") then
			frame:RegisterEvent("PLAYER_REGEN_ENABLED")
			return
		end
		UnitSetRole("player", role)
	end
end)

LibSpec.RegisterPlayerSpecChange(LibSpecTable, function()
	canChangeRole = true
end)

frame:SetScript("OnEvent", function(self, event)
	if event == "GROUP_FORMED" then
		canChangeRole = true
	else
		self:UnregisterEvent(event)
		if IsInGroup() and not IsPartyLFG() then
			local _, role = LibSpec:MySpecialization()
			if UnitGroupRolesAssigned("player") ~= role then
				UnitSetRole("player", role)
			end
		end
	end
end)
frame:RegisterEvent("GROUP_FORMED")

local _, addonTbl = ...
local L = addonTbl.API:GetLocale("BigWigs")
addonTbl.API.SetToolOptionsTable("AutoRole", {
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
