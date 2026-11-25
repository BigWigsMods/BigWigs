local _, addonTbl = ...

RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN") -- We don't need to participate in role polls

do
	local LibSpec = LibStub("LibSpecialization")
	local IsInGroup, GetTime = IsInGroup, GetTime
	local InCombatLockdown, UnitAffectingCombat = InCombatLockdown, UnitAffectingCombat
	local UnitGroupRolesAssigned, UnitSetRole = UnitGroupRolesAssigned, UnitSetRole
	local isForever, UnitLevel = addonTbl.isForever, addonTbl.loaderPublic.UnitLevel

	local frame = CreateFrame("Frame")
	local prevTime, prevRole = 0, nil
	local function UpdateMyRole()
		if IsInGroup(1) and not IsInGroup(2) then
			if isForever and UnitLevel("player") <= 30 then return end
			local _, role = LibSpec.MySpecialization()
			if role and UnitGroupRolesAssigned("player") ~= role then
				if InCombatLockdown() or UnitAffectingCombat("player") then
					frame:RegisterEvent("PLAYER_REGEN_ENABLED")
					return
				end
				local t = GetTime()
				if role ~= prevRole or t - prevTime > 1 then
					if UnitSetRole("player", role) then
						prevTime = t
						prevRole = role
					end
				end
			end
		end
	end
	LibSpec.RegisterPlayerSpecChange({}, UpdateMyRole)

	frame:SetScript("OnEvent", function(self, event)
		if event == "GROUP_FORMED" then
			prevTime, prevRole = 0, nil
		elseif event == "PLAYER_REGEN_ENABLED" then
			self:UnregisterEvent(event)
		end
		UpdateMyRole()
	end)
	frame:RegisterEvent("GROUP_FORMED")
	-- Just in case we changed roles in an instance group, left, but still in a home group, do another check
	frame:RegisterEvent("GROUP_LEFT")
end

local L = addonTbl.API:GetLocale("BigWigs")
addonTbl.API.RegisterToolOptions("AutoRole", function() return {
	type = "group",
	name = L.autoRoleTitle,
	order = 7,
	args = {
		explainer = {
			type = "description",
			name = L.autoRoleExplainer,
			order = 0,
			width = "full",
			fontSize = "large",
		},
	},
} end)
