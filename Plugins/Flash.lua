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
		local fade1 = flasher:CreateAnimation("Alpha")
		fade1:SetDuration(0.2)
		fade1:SetChange(1)
		fade1:SetOrder(1)
		local fade2 = flasher:CreateAnimation("Alpha")
		fade2:SetDuration(0.2)
		fade2:SetChange(-1)
		fade2:SetOrder(2)
		local fade3 = flasher:CreateAnimation("Alpha")
		fade3:SetDuration(0.2)
		fade3:SetChange(1)
		fade3:SetOrder(3)
		local fade4 = flasher:CreateAnimation("Alpha")
		fade4:SetDuration(0.2)
		fade4:SetChange(-1)
		fade4:SetOrder(4)

		shaker = CreateFrame("Frame"):CreateAnimationGroup()
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
		flasher:Stop()
		local r, g, b = colors:GetColor("flashshake", module, key)
		flashFrame:SetBackdropColor(r, g, b, 0.8)
		flashFrame:SetAlpha(0)
		flashFrame:Show()
		flasher:Play()
	end
	if not WorldFrame:IsProtected() and BigWigs.db.profile.shake then
		shaker:Stop()
		shaker.count = 0
		shaker:Play()
	end
end

