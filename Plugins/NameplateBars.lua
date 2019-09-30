local candy = LibStub("LibCandyBar-3.0")
local media = LibStub("LibSharedMedia-3.0")
local colors, barsPlugin

local FONT = media.MediaType and media.MediaType.FONT or "font"
local STATUSBAR = media.MediaType and media.MediaType.STATUSBAR or "statusbar"
local UnitGUID, UnitIsPlayer = UnitGUID, UnitIsPlayer

local findUnitByGUID
do
	local unitTable = {
		"nameplate1", "nameplate2", "nameplate3", "nameplate4", "nameplate5", "nameplate6", "nameplate7", "nameplate8", "nameplate9", "nameplate10",
		"nameplate11", "nameplate12", "nameplate13", "nameplate14", "nameplate15", "nameplate16", "nameplate17", "nameplate18", "nameplate19", "nameplate20",
		"nameplate21", "nameplate22", "nameplate23", "nameplate24", "nameplate25", "nameplate26", "nameplate27", "nameplate28", "nameplate29", "nameplate30",
		"nameplate31", "nameplate32", "nameplate33", "nameplate34", "nameplate35", "nameplate36", "nameplate37", "nameplate38", "nameplate39", "nameplate40",
	}
	local unitTableCount = #unitTable
	findUnitByGUID = function(id)
		for i = 1, unitTableCount do
			local unit = unitTable[i]
			local guid = UnitGUID(unit)
			if guid and not UnitIsPlayer(unit) then
				if guid == id then return unit end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("NameplateBars")
if not plugin then return end

local bars = {}

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
        if not next(bars[guid]) then
            bars[guid] = nil
        else
			plugin:RearrangeBars(guid)
		end
    end
end)

function plugin:StartBar(key, guid, time, text, icon, expirationTime)
    local unit = findUnitByGUID(guid)
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
    self:StartBar(key, guid, time, text, icon)
    self:RearrangeBars(guid)
end

function plugin:BigWigs_StopNameplateBar(_, module, text, guid)
    if not bars[guid] or not bars[guid][text] then return end
	bars[guid][text]:Stop()
    self:RearrangeBars(guid)
end

do
    local function order(bars)
        local barTexts = {}
        for text, _ in pairs(bars) do
            barTexts[#barTexts+1] = text
        end
        table.sort(barTexts, function(a, b)
            return bars[a].remaining < bars[b].remaining
        end)
        return barTexts
    end

    function plugin:RearrangeBars(guid)
        local unit = findUnitByGUID(guid)
		if not unit then return end
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
        local unitBars = bars[guid]
        if nameplate and unitBars and bars[guid] then
            local sorted = order(bars[guid])
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
    local unitBars = bars[guid]
    if not unitBars then return end
    for text, bar in next, unitBars do
		local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
		bar:Show()
        bar:SetParent(nameplate)
    end
    self:RearrangeBars(guid)
end

function plugin:NAME_PLATE_UNIT_REMOVED(_, unit)
    local guid = UnitGUID(unit)
    local unitBars = bars[guid]
    if not unitBars then return end

    for _, bar in next, unitBars do
        bar:SetParent(nil)
		bar:Hide()
		bar:ClearAllPoints()
    end
end
