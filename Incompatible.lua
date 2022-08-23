
local function sysprint(msg)
	print("|cff33ff99BigWigs|r: "..msg)
end

local bwFrame = CreateFrame("Frame")
bwFrame:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	C_Timer.After(0, function() -- Timers aren't fully functional until 1 frame after loading is done
		C_Timer.After(2, function()
			sysprint("|cffff0000WARNING!|r You've installed the wrong version of BigWigs.")
			if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
				sysprint("You are playing on |cffffff00Retail|r, but have installed BigWigs for |cffffff00Classic|r.")
			elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
				sysprint("You are playing on |cffffff00Classic|r, but have installed BigWigs for |cffffff00Burning Crusade Classic|r.")
			else
				sysprint("You are playing on |cffffff00Burning Crusade Classic|r, but have installed BigWigs for |cffffff00original Classic|r.")
			end
			sysprint("We recommend avoiding unofficial addon updaters, and using the official CurseForge app to avoid such issues.")
		end)
	end)
end)
bwFrame:RegisterEvent("LOADING_SCREEN_DISABLED")
