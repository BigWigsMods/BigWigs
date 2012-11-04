--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewPlugin("Flash")
if not mod then return end

--------------------------------------------------------------------------------
-- Locals
--

local flashFrame = nil

local originalPoints = nil
local flasher = nil
local shaker = nil

local colors = nil

-------------------------------------------------------------------------------
-- Initialization
--

function mod:OnPluginEnable()
	colors = BigWigs:GetPlugin("Colors")
	self:RegisterMessage("BigWigs_FlashShake")

	if not flashFrame then
		flashFrame = CreateFrame("Frame", nil, UIParent)
		flashFrame:SetFrameStrata("BACKGROUND")
		flashFrame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
		flashFrame:SetAllPoints(UIParent)
		flashFrame:SetAlpha(0)
		flashFrame:Hide()

		flasher = flashFrame:CreateAnimationGroup()
		flasher:SetScript("OnLoop", function(frame)
			frame.count = frame.count + 1
			if frame.count > 3 then
				frame:Stop()
				flashFrame:Hide()
				frame.count = nil
			end
		end)
		flasher:SetLooping("BOUNCE")
		local fade = flasher:CreateAnimation("Alpha")
		fade:SetDuration(0.2)
		fade:SetChange(1)

		shaker = flashFrame:CreateAnimationGroup()
		shaker:SetScript("OnLoop", function(frame)
			local x, y = 0, 0
			frame.count = frame.count + 1
			if frame.count > 15 then
				frame:Stop()
				frame.count = nil
			else
				x, y = math.random(-10,10), math.random(-10,10)
			end
			WorldFrame:ClearAllPoints()
			for i, v in next, originalPoints do
				WorldFrame:SetPoint(v[1], v[2], v[3], v[4] + x, v[5] + y)
			end
		end)
		shaker:SetLooping("REPEAT")
		local timer = shaker:CreateAnimation()
		timer:SetDuration(0.05)

		originalPoints = {}
		for i = 1, WorldFrame:GetNumPoints() do
			originalPoints[i] = {WorldFrame:GetPoint(i)}
		end
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BigWigs_FlashShake(event, module, key)
	if BigWigs.db.profile.flash then
		local r, g, b = colors:GetColor("flashshake", module, key)
		flashFrame:SetBackdropColor(r, g, b, 0.55)
		flashFrame:Show()
		flasher.count = 0
		flasher:Play()
	end
	if not WorldFrame:IsProtected() and BigWigs.db.profile.shake then
		shaker.count = 0
		shaker:Play()
	end
end

