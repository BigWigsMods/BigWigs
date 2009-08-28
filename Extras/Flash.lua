--------------------------------------------------------------------------------
-- Module Declaration
--

local mod = BigWigs:New("Flash", "$Revision$")
if not mod then return end

--------------------------------------------------------------------------------
-- Locals
--

-- Frames
local flasher = nil
local shaker = nil

-- Shake properties
local shaking = nil
local SHAKE_DURATION = 0.8
local SHAKE_X = 10
local SHAKE_Y = 10

--------------------------------------------------------------------------------
-- Options
--

mod.external = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("BigWigs_Message")
end

------------------------------
--      Shaking             --
------------------------------

local originalPoints = nil
local function startShake()
	if not shaking then
		-- store old worldframe positions, we need them all, people have frame modifiers for it etc.
		if not originalPoints then
			originalPoints = {}
			for i = 1, WorldFrame:GetNumPoints() do
				table.insert(originalPoints, {WorldFrame:GetPoint(i)})
			end
		end
		shaking = SHAKE_DURATION -- don't think we want to make this a setting.
		shaker:Show()
	end
end

local function shakeOnUpdate(frame, elapsed)
	shaking = shaking - elapsed
	local x, y = 0, 0 -- Resets to original position if we're supposed to stop.
	if shaking <= 0 then -- stop shaking
		shaking = nil
		shaker:Hide()
	else
		x = math.random(-SHAKE_X,SHAKE_X)
		y = math.random(-SHAKE_Y,SHAKE_Y)
	end
	WorldFrame:ClearAllPoints()
	for i, v in ipairs(originalPoints) do
		WorldFrame:SetPoint(v[1], v[2], v[3], v[4] + x, v[5] + y)
	end
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_Message(msg, color)
	if color and color == "Personal" then
		if not flasher then --frame creation
			flasher = CreateFrame("Frame", "BWFlash", UIParent)
			flasher:SetFrameStrata("BACKGROUND")
			flasher:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",})
			flasher:SetBackdropColor(0,0,1,0.55)
			flasher:SetAllPoints( UIParent)
			flasher:SetScript("OnShow", function (self)
				self.elapsed = 0
				self:SetAlpha(0)
			end)
			flasher:SetScript("OnUpdate", function (self, elapsed)
				elapsed = self.elapsed + elapsed
				if elapsed >= 0.8 then
					self:Hide()
					self:SetAlpha(0)
					return
				end
				local alpha = elapsed % 0.4
				if elapsed > 0.2 then
					alpha = 0.4 - alpha
				end
				self:SetAlpha(alpha * 5)
				self.elapsed = elapsed
			end)
			flasher:Hide()
		end
		flasher:Show()

		if not WorldFrame:IsProtected() then
			if not shaker then
				shaker = CreateFrame("Frame", "BWShaker", UIParent)
				shaker:Hide()
				shaker:SetScript("OnUpdate", shakeOnUpdate)
			end
			startShake()
		end
	end
end

