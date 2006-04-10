

BigWigs = AceAddon:new({
	name          = "BigWigs",
	description   = "Boss Mods with Timex bars.",
	version       = "0",
	releaseDate   = "12-11-2005",
	aceCompatible = 102,
	author        = "Tekkub",
	email 		    = "tekkub@gmail.com",
	category      = "inventory",
	cmd           = AceChatCmd:new({"/bw", "/BigWigs"}, {}),

	modules = {},
	enablezones = {},
	enablemobs  = {},
	bars = {},

	color = {
		Red    = {1, 0, 0}, Orange = {1, 0.5, 0}, Yellow = {1, 1, 0},
		Green  = {0, 1, 0}, LtBlue = {0, 1, 1},   Blue   = {0, 0, 1},
		Purple = {1, 0, 1}, White  = {1, 1, 1},   Black  = {0, 0, 0},
	},

	loc = {
		ModuleEnable = "%s mod enabled",
		TargetEnable = "Target monitoring enabled",
		TargetDisable = "Target monitoring disabled",

		MC = "Molten Core",
		BWL = "Blackwing Lair",
		Onyxia = "Onyxia's Lair",
		ZG = "Zul'Gurub",
		AQ20 = "Ruins of Ahn'Qiraj",
		AQ40 = "Ahn'Qiraj",
	},

--	sendtoraid = true,
--	sendtoraidsay = true,
})


function BigWigs:Initialize()
end


function BigWigs:Enable()
	self:RegisterEvent("BIGWIGS_BAR_START")
	self:RegisterEvent("BIGWIGS_BAR_CANCEL")
	self:RegisterEvent("BIGWIGS_MESSAGE")
	self:RegisterEvent("BIGWIGS_DELAYEDMESSAGE_START")
	self:RegisterEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL")
	self:RegisterEvent("BIGWIGS_BAR_SETCOLOR")
	self:RegisterEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START")
	self:RegisterEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
end


function BigWigs:Disable()
end


-------------------------------
--      Module Handling      --
-------------------------------

function BigWigs:RegisterModule(module)
	if not module or not module.name then return end
	self.modules[module.name] = module

	if module.zonename and self.loc[module.zonename] then
		self.enablezones[self.loc[module.zonename]] = true
	end

	local t = module.enabletrigger
	if type(t) == "string" then self.enablemobs[t] = module.name
	elseif type(t) == "table" then
		for _,mob in pairs(t) do self.enablemobs[mob] = module.name end
	end
	self:ZONE_CHANGED_NEW_AREA()
end


function BigWigs:EnableModule(module)
	local m = self.modules[module]
	if m and m.disabled then
		m:Enable()
		self:TriggerEvent("BIGWIGS_MESSAGE", string.format(self.loc.ModuleEnable, m.loc.bossname or "??"), "LtBlue", true)
	end
end


function BigWigs:ZONE_CHANGED_NEW_AREA()
	if self.enablezones[GetRealZoneText()] then
		self.monitoring = true
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.TargetEnable, "LtBlue", true)
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	elseif self.monitoring then
		self.monitoring = nil
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.TargetDisable, "LtBlue", true)
		self:UnregisterEvent("PLAYER_TARGET_CHANGED")
		self:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	end
end


function BigWigs:UPDATE_MOUSEOVER_UNIT()
	local module = UnitName("mouseover") and not UnitIsCorpse("mouseover") and not UnitIsDead("mouseover") and self.enablemobs[UnitName("mouseover")]
	if module then self:EnableModule(module) end
end


function BigWigs:PLAYER_TARGET_CHANGED()
	local module = UnitName("target") and not UnitIsCorpse("target") and not UnitIsDead("target") and self.enablemobs[UnitName("target")]
	if module then self:EnableModule(module) end
end


function BigWigs:GetColor(color)
	local c = (type(color) == "string" and self.color[color]) or color
	if type(c) == "table" then
		if c[1] then return c[1], c[2], c[3]
		elseif c.r and c.g and c.b then return c.r, c.g, c.b end
	end
end


function BigWigs:BIGWIGS_BAR_START(text, time, bar, color, texture)
	if not text or not time then return end

	local red, green, blue = self:GetColor(color)
	local id = "BigWigsBar "..text
	TimexBar:Get(id)
	TimexBar:SetText(id, text)
	TimexBar:SetTexture(id, texture)
	TimexBar:SetColor(id, red or 0, green or 0, blue or 0)
	TimexBar:SetPoint(id, "TOP", "BigWigsAnchorFrame", "TOP", 0, ((bar or 0) * (-15) + 5))
	self.bars[text] = TimexBar:Start(id, time)
end


function BigWigs:BIGWIGS_BAR_CANCEL(text)
	if not text then return end

	TimexBar:Stop("BigWigsBar "..text)
	self.bars[text] = nil
end


function BigWigs:BIGWIGS_BAR_DELAYEDSETCOLOR_START(text, time, color)
	if not text or not time then return end
	self:debug(string.format("BIGWIGS_BAR_DELAYEDSETCOLOR | %s | %s | %s", text, time, type(color) == "string" and color or type(color)))
	Timex:AddSchedule("BIGWIGS_BAR_DELAYEDSETCOLOR "..text..time, time, nil, nil, "BIGWIGS_BAR_SETCOLOR", text, color)
end


function BigWigs:BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL(text, time)
	if not text or not time then return end
	Timex:DeleteSchedule("BIGWIGS_BAR_DELAYEDSETCOLOR "..text..time)
end


function BigWigs:BIGWIGS_BAR_SETCOLOR(text, color)
	if not text or not self.bars[text] then return end
	self:debug(string.format("BIGWIGS_BAR_SETCOLOR | %s | %s", text, type(color) == "string" and color or type(color)))

	local red, green, blue = self:GetColor(color)
	local bar = getglobal(self.bars[text].."StatusBar")
	if bar then bar:SetStatusBarColor(red or 0, green or 0, blue or 0) end
--	TimexBar:SetColor("BigWigsBar "..text, red or 1, green or 1, blue or 1)
end


function BigWigs:BIGWIGS_MESSAGE(text, color, noraidsay)
	if not text then return end
	if self.sendtoraid then SendChatMessage("<BigWigs> "..text, "RAID") end
	if not noraidsay and self.sendtoraidsay and CT_RA_AddMessage then CT_RA_AddMessage("MS " .. text) end
end


function BigWigs:BIGWIGS_DELAYEDMESSAGE_START(text, time, color, noraidsay)
	if not text or not time then return end
	Timex:AddNamedSchedule("BIGWIGS_DELAYEDMESSAGE "..text, time, nil, nil, "BIGWIGS_MESSAGE", text, color, noraidsay)
end


function BigWigs:BIGWIGS_DELAYEDMESSAGE_CANCEL(text)
	if not text then return end
	Timex:DeleteSchedule("BIGWIGS_DELAYEDMESSAGE "..text)
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigs:RegisterForLoad()
