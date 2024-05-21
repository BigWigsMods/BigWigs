local _, mod = ...
RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN") -- We don't need to participate in role polls

local frame = CreateFrame("Frame")
local IsInGroup, IsPartyLFG, GetSpecialization, GetSpecializationRole = IsInGroup, IsPartyLFG, GetSpecialization, GetSpecializationRole
local InCombatLockdown, UnitAffectingCombat, GetTime = InCombatLockdown, UnitAffectingCombat, GetTime
local UnitGroupRolesAssigned, UnitSetRole = UnitGroupRolesAssigned, UnitSetRole

local prev = 0
frame:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent(event)
	end

	if IsInGroup() and not IsPartyLFG() then
		if mod.isRetail then
			local tree = GetSpecialization()
			if not tree then return end -- No spec selected
			local role = GetSpecializationRole(tree)
			if role and UnitGroupRolesAssigned("player") ~= role then
				if InCombatLockdown() or UnitAffectingCombat("player") then
					self:RegisterEvent("PLAYER_REGEN_ENABLED")
					return
				end
				-- ACTIVE_TALENT_GROUP_CHANGED fires twice when changing spec, leaving the talent tree, and entering the new tree. We throttle this to prevent a double role chat message.
				-- It should only fire once when joining a group (triggered from GROUP_FORMED)
				local t = GetTime()
				if (t-prev) > 2 then
					prev = t
					UnitSetRole("player", role)
				end
			end
		else
			local mySpec = nil
			local highestPoints = 0
			for i = 1, 3 do
				local _, _, _, _, pointsSpent = GetTalentTabInfo(i)
				if pointsSpent > highestPoints then
					highestPoints = pointsSpent
					mySpec = i
				end
			end
			if mySpec then
				local tabRole1, tabRole2 = GetTalentTreeRoles(mySpec)
				if tabRole2 then
					RolePollPopup:RegisterEvent("ROLE_POLL_BEGIN")
					local _, _, id = UnitClass("player")
					if id ~= 11 then
						print("BigWigs: Error ".. tostring(id))
					end
				elseif tabRole1 then
					RolePollPopup:UnregisterEvent("ROLE_POLL_BEGIN")
					UnitSetRole("player", tabRole1)
				end
			end
		end
	end
end)
frame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
frame:RegisterEvent("GROUP_FORMED")
