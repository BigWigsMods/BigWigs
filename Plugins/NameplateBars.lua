local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")
local colors, barsPlugin

local FONT = media.MediaType and media.MediaType.FONT or "font"
local STATUSBAR = media.MediaType and media.MediaType.STATUSBAR or "statusbar"

--------------------------------------------------------------------------------
-- Module Declaration
--

-- TEMP
local findTargetByGUID
do
	local unitTable = {
		"nameplate1", "nameplate2", "nameplate3", "nameplate4", "nameplate5", "nameplate6", "nameplate7", "nameplate8", "nameplate9", "nameplate10",
		"nameplate11", "nameplate12", "nameplate13", "nameplate14", "nameplate15", "nameplate16", "nameplate17", "nameplate18", "nameplate19", "nameplate20",
		"nameplate21", "nameplate22", "nameplate23", "nameplate24", "nameplate25", "nameplate26", "nameplate27", "nameplate28", "nameplate29", "nameplate30",
		"nameplate31", "nameplate32", "nameplate33", "nameplate34", "nameplate35", "nameplate36", "nameplate37", "nameplate38", "nameplate39", "nameplate40",
	}
	local unitTableCount = #unitTable
	findTargetByGUID = function(id)
		local isNumber = type(id) == "number"
		for i = 1, unitTableCount do
			local unit = unitTable[i]
			local guid = UnitGUID(unit)
			--if not guid then return end -- no more nameplates
			if guid and not UnitIsPlayer(unit) then
				if isNumber then
					local _, _, _, _, _, mobId = strsplit("-", guid)
					guid = tonumber(mobId)
				end
				if guid == id then return unit end
			end
		end
	end
end
-- end TEMP

local plugin = BigWigs:NewPlugin("NameplateBars")
if not plugin then return end

local bars = {}
local timers = {}

function plugin:OnPluginEnable()
	colors = BigWigs:GetPlugin("Colors")
	barsPlugin = BigWigs:GetPlugin("Bars")

    self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
    self:RegisterMessage("BigWigs_StartNameplateBar")
    self:RegisterMessage("BigWigs_StopNameplateBar")
end

candy:RegisterCallback("LibCandyBar_Stop", function(_, bar)
    local guid = bar:Get("bigwigs:guid")
    if guid then
		barsPlugin.currentBarStyler.BarStopped(bar)
        bars[guid][bar:GetLabel()] = nil
		timers[guid][bar:GetLabel()] = nil
        if not next(bars[guid]) then
            bars[guid] = nil
			timers[guid] = nil
        end
		-- TODO delete from table when bars are not active
		plugin:RearrangeBars(guid)
    end
end)

function plugin:StartBar(key, guid, time, text, icon, expirationTime)
    local unit = findTargetByGUID(guid)
    local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
    if nameplate then
		local db = barsPlugin.db.profile
		if not bars[guid] then bars[guid] = {} end
        local bar = bars[guid][text] or candy:New(media:Fetch(STATUSBAR, db.texture), nameplate:GetWidth(), 16)

		bar.candyBarBackground:SetVertexColor(colors:GetColor("barBackground", module, key))
		bar:SetColor(colors:GetColor("barColor", module, key))
		bar:SetTextColor(colors:GetColor("barText", module, key))
		bar:SetShadowColor(colors:GetColor("barTextShadow", module, key))
		bar.candyBarLabel:SetJustifyH(db.alignText)
		bar.candyBarDuration:SetJustifyH(db.alignTime)
		local flags = nil
		if db.monochrome and db.outline ~= "NONE" then
			flags = "MONOCHROME," .. db.outline
		elseif db.monochrome then
			flags = "MONOCHROME"
		elseif db.outline ~= "NONE" then
			flags = db.outline
		end
		local f = media:Fetch(FONT, db.fontName)
		bar.candyBarLabel:SetFont(f, db.fontSize, flags)
		bar.candyBarDuration:SetFont(f, db.fontSize, flags)
        bar:SetLabel(text)
		bar:SetTimeVisibility(db.time)
		bar:SetLabelVisibility(db.text)
		bar:SetIcon(db.icon and icon or nil)
		bar:SetIconPosition(db.iconPosition)
		bar:SetFill(db.fill)
        bar:SetDuration(expirationTime and expirationTime - GetTime() or time)
        bar:Start(time)
		bar:Set("bigwigs:key", key)
        bar:Set("bigwigs:guid", guid)
		barsPlugin.currentBarStyler.ApplyStyle(bar)
        bars[guid][text] = bar
		self:RearrangeBars(guid)
    end
end

function plugin:BigWigs_StartNameplateBar(_, module, key, text, time, icon, guid)
    if not timers[guid] then timers[guid] = {} end
    timers[guid][text] = {
		key = key,
        duration = time,
        expirationTime = GetTime() + time,
        text = text,
		icon = icon,
    }
    self:StartBar(key, guid, time, text, icon)
    self:RearrangeBars(guid)
end

function plugin:BigWigs_StopNameplateBar(_, module, text, guid)
    if not timers[guid] or not timers[guid][text] then return end
    timers[guid][text] = nil
	bars[guid][text]:Stop()
	bars[guid][text] = nil
    self:RearrangeBars(guid)
end

do
    local function order(timers)
        local barTexts = {}
        for text, _ in pairs(timers) do
            barTexts[#barTexts+1] = text
        end
        table.sort(barTexts, function(a, b)
            return timers[a].expirationTime < timers[b].expirationTime
        end)
        return barTexts
    end

    function plugin:RearrangeBars(guid)
        local unit = findTargetByGUID(guid)
		if not unit then return end
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
        local unitBars = bars[guid]
        if nameplate and unitBars and timers[guid] then
            local sorted = order(timers[guid])
            for i, text in ipairs(sorted) do
                local bar = unitBars[text]
                bar:ClearAllPoints()
				bar:SetParent(nameplate)
                bar:SetPoint("BOTTOM", nameplate, "TOP", 0, 20 * i)
            end
        end
    end
end

function plugin:NAME_PLATE_UNIT_ADDED(_, unit)
    local guid = UnitGUID(unit)
    local unitTimers = timers[guid]
    if not unitTimers then return end
    for text, timer in next, unitTimers do
        self:StartBar(timer.key, guid, timer.duration, timer.text, timer.icon, timer.expirationTime)
    end
    self:RearrangeBars(guid)
end

function plugin:NAME_PLATE_UNIT_REMOVED(_, unit)
    local guid = UnitGUID(unit)
    local unitBars = bars[guid]
    if not unitBars then return end

    for _, bar in next, unitBars do
        bar:Stop()
    end
    bars[guid] = nil
end
