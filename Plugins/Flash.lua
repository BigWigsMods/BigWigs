--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:NewPlugin("Flash")
if not mod then return end

--------------------------------------------------------------------------------
-- Locals
--

local flashFrame, pulseFrame
local flasher, pulser

-------------------------------------------------------------------------------
-- Initialization
--

do
	flashFrame = UIParent:CreateTexture()
	flashFrame:SetAllPoints(UIParent)
	flashFrame:SetAlpha(0)
	flashFrame:SetColorTexture(0, 0, 1, 0.6)
	flashFrame:Hide()

	flasher = flashFrame:CreateAnimationGroup()
	flasher:SetScript("OnFinished", function() flashFrame:Hide() end)

	local fade1 = flasher:CreateAnimation("Alpha")
	fade1:SetDuration(0.2)
	fade1:SetFromAlpha(0)
	fade1:SetToAlpha(1)
	fade1:SetOrder(1)
	local fade2 = flasher:CreateAnimation("Alpha")
	fade2:SetDuration(0.2)
	fade2:SetFromAlpha(1)
	fade2:SetToAlpha(0)
	fade2:SetOrder(2)
	local fade3 = flasher:CreateAnimation("Alpha")
	fade3:SetDuration(0.2)
	fade3:SetFromAlpha(0)
	fade3:SetToAlpha(1)
	fade3:SetOrder(3)
	local fade4 = flasher:CreateAnimation("Alpha")
	fade4:SetDuration(0.2)
	fade4:SetFromAlpha(1)
	fade4:SetToAlpha(0)
	fade4:SetOrder(4)

	pulseFrame = UIParent:CreateTexture()
	pulseFrame:SetPoint("CENTER", UIParent, "CENTER")
	pulseFrame:SetSize(100,100)
	pulseFrame:SetAlpha(0.5)
	pulseFrame:SetTexture(132337) -- Interface\\Icons\\ability_warrior_charge
	pulseFrame:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	pulseFrame:Hide()

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

function mod:OnPluginEnable()
	if not BigWigsLoader.isRetail then
		self:RegisterMessage("BigWigs_Flash")
		self:RegisterMessage("BigWigs_Pulse")
	end
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function mod:BigWigs_Flash(event, module, key)
	flasher:Stop()
	flashFrame:SetAlpha(0)
	flashFrame:Show()
	flasher:Play()
end

function mod:BigWigs_Pulse(event, _, _, icon)
	pulser:Stop()
	pulseFrame:SetTexture(icon or 134400) -- Interface\\Icons\\INV_Misc_QuestionMark
	pulseFrame:Show()
	pulser:Play()
end

