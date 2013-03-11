--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewPlugin("Flash")
if not mod then return end

--------------------------------------------------------------------------------
-- Locals
--

local flashFrame, pulseFrame = nil, nil
local flasher, pulser = nil, nil
local colors = nil

-------------------------------------------------------------------------------
-- Initialization
--

function mod:OnPluginEnable()
	colors = BigWigs:GetPlugin("Colors")
	self:RegisterMessage("BigWigs_Flash")
	self:RegisterMessage("BigWigs_Pulse")

	if not flashFrame then
		flashFrame = CreateFrame("Frame", nil, UIParent)
		flashFrame:SetFrameStrata("BACKGROUND")
		flashFrame:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
		flashFrame:SetAllPoints(UIParent)
		flashFrame:SetAlpha(0)
		flashFrame:Hide()

		flasher = flashFrame:CreateAnimationGroup()
		flasher:SetScript("OnFinished", function() flashFrame:Hide() end)

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

		pulseFrame = CreateFrame("Frame", nil, UIParent)
		pulseFrame:SetPoint("CENTER", UIParent, "CENTER")
		pulseFrame:SetSize(100,100)
		pulseFrame:SetAlpha(0.5)
		pulseFrame:Hide()
		pulseFrame.tex = pulseFrame:CreateTexture(nil, "ARTWORK")
		pulseFrame.tex:SetTexCoord(0.07, 0.93, 0.07, 0.93)
		pulseFrame.tex:SetAllPoints(pulseFrame)
		pulseFrame.tex:SetTexture("Interface\\Icons\\ability_warrior_charge")

		pulser = pulseFrame:CreateAnimationGroup()
		pulser:SetScript("OnFinished", function() pulseFrame:Hide() end)

		local pulse1 = pulser:CreateAnimation("Scale")
		pulse1:SetDuration(0.25)
		pulse1:SetScale(2.5,2.5)
		pulse1:SetOrder(1)
		pulse1:SetEndDelay(0.4)
		local pulse2 = pulser:CreateAnimation("Scale")
		pulse2:SetDuration(0.25)
		pulse2:SetScale(0.2,0.2)
		pulse2:SetOrder(2)
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BigWigs_Flash(event, module, key)
	if BigWigs.db.profile.flash then
		flasher:Stop()
		local r, g, b = colors:GetColor("flash", module, key)
		flashFrame:SetBackdropColor(r, g, b, 0.8)
		flashFrame:SetAlpha(0)
		flashFrame:Show()
		flasher:Play()
	end
end

function mod:BigWigs_Pulse(event, module, key, icon)
	pulser:Stop()
	pulseFrame.tex:SetTexture(icon)
	pulseFrame:Show()
	pulser:Play()
end

