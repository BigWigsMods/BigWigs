-- USE THIS CALLBACK TO SKIN THIS WINDOW! NO NEED FOR UGLY HAX! E.g.
-- local name, addon = ...
-- if BigWigsLoader then
-- 	BigWigsLoader.RegisterMessage(addon, "BigWigs_FrameCreated", function(event, frame, name) print(name.." frame created.") end)
-- end

local _, tbl = ...
local LoaderPublic = tbl.loaderPublic

local db
do
	local defaults = {
		useMaster = true
	}
	db = LoaderPublic.db:RegisterNamespace("LFGTimer", {profile = defaults})
	local function ValidateSettings()
		for k, v in next, db.profile do
			local defaultType = type(defaults[k])
			if defaultType == "nil" then
				db.profile[k] = nil
			elseif type(v) ~= defaultType then
				db.profile[k] = defaults[k]
			end
		end
	end
	ValidateSettings()
	LoaderPublic.RegisterMessage({}, "BigWigs_ProfileUpdate", ValidateSettings)
end

do
	local PlaySound, StopSound, GetTime = PlaySound, StopSound, GetTime

	local timerBar = CreateFrame("StatusBar", nil, LFGDungeonReadyPopup)
	timerBar:SetPoint("TOP", LFGDungeonReadyPopup, "BOTTOM", 0, -5)

	local tex = timerBar:CreateTexture()
	tex:SetTexture(137012) -- Interface\\TargetingFrame\\UI-StatusBar
	timerBar:SetStatusBarTexture(tex)
	timerBar:SetSize(190, 9)
	timerBar:SetStatusBarColor(1, 0.1, 0)

	local bg = timerBar:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints(timerBar)
	bg:SetColorTexture(0, 0, 0, 0.7)

	local spark = timerBar:CreateTexture(nil, "ARTWORK", nil, 1)
	spark:SetTexture(130877) -- Interface\\CastingBar\\UI-CastingBar-Spark
	spark:SetSize(32, 32)
	spark:SetBlendMode("ADD")
	spark:SetPoint("LEFT", tex, "RIGHT", -15, 0)

	local border = timerBar:CreateTexture(nil, "ARTWORK", nil, 2)
	border:SetTexture(130874) -- Interface\\CastingBar\\UI-CastingBar-Border
	border:SetSize(256, 64)
	border:SetPoint("TOP", timerBar, 0, 28)

	timerBar.text = timerBar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	timerBar.text:SetPoint("CENTER", timerBar, "CENTER")
	timerBar.text:SetJustifyH("LEFT")
	timerBar.text:SetWordWrap(false)
	timerBar.text:SetWidth(timerBar.text:GetUnboundedStringWidthForText("BigWigs: 40.0") + 4)

	local durationObject = C_DurationUtil.CreateDuration()
	local durationBinding = C_DurationUtil.CreateDurationTextBinding()
	-- Enum.StatusBarInterpolation.Immediate = 0 | Enum.StatusBarTimerDirection.RemainingTime = 1
	timerBar:SetTimerDuration(durationObject, 0, 1)
	local formatter = C_StringUtil.CreateNumericRuleFormatter()
	formatter:SetBreakpoints({
		{ threshold = 0, format = "BigWigs: %.1f" },
	})
	durationBinding:SetFormatter(formatter)
	durationBinding:SetFontString(timerBar.text)
	durationBinding:SetDuration(durationObject)
	durationBinding:SetExpiredText("BigWigs: 0.0")
	durationBinding:SetZeroDurationText("BigWigs: 0.0")
	durationBinding:SetEnabled(false)

	local frameCreated
	timerBar:SetScript("OnEvent", function(self, event)
		if event == "LFG_PROPOSAL_SHOW" then
			-- Play in Master for those that have SFX off or very low.
			-- Using false as third arg to avoid the "only one of each sound at a time" throttle.
			if db.profile.useMaster then
				local _, id = PlaySound(8960, "Master", false) -- SOUNDKIT.READY_CHECK
				if id and C_CVar.GetCVarBool("Sound_EnableSFX") then -- The Blizz sound plays over SFX
					StopSound(id-1) -- Should work most of the time to stop the blizz sound
				end
			end

			if LFGDungeonReadyPopup:IsShown() then
				if not frameCreated then
					frameCreated = true
					LoaderPublic:SendMessage("BigWigs_FrameCreated", self, "QueueTimer")
				end

				if self:IsShown() then
					durationObject:SetTimeFromStart(GetTime(), 40)
					durationBinding:SetEnabled(true)
					durationBinding:UpdateFontString()
					self:RegisterEvent("LFG_PROPOSAL_DONE")
					self:RegisterEvent("LFG_PROPOSAL_FAILED")
					self:RegisterEvent("LFG_PROPOSAL_SUCCEEDED")
				end
			end
		else -- LFG_PROPOSAL_DONE, LFG_PROPOSAL_FAILED, LFG_PROPOSAL_SUCCEEDED
			self:UnregisterEvent("LFG_PROPOSAL_DONE")
			self:UnregisterEvent("LFG_PROPOSAL_FAILED")
			self:UnregisterEvent("LFG_PROPOSAL_SUCCEEDED")
			durationBinding:SetEnabled(false)
			durationObject:Reset()
			durationBinding:UpdateFontString()
		end
	end)
	timerBar:RegisterEvent("LFG_PROPOSAL_SHOW")
end

local L = tbl.API:GetLocale("BigWigs")
tbl.API.RegisterToolOptions("LFGTimer", function() return {
	type = "group",
	name = L.lfgTimerTitle,
	order = 6,
	get = function(info)
		return db.profile[info[#info]]
	end,
	set = function(info, value)
		db.profile[info[#info]] = value
	end,
	args = {
		explainer = {
			type = "description",
			name = L.lfgTimerExplainer,
			order = 0,
			width = "full",
			fontSize = "large",
		},
		useMaster = {
			type = "toggle",
			name = L.lfgUseMaster,
			desc = L.lfgUseMasterDesc:format(L.sfx),
			order = 1,
			width = "full",
		},
	},
} end)
