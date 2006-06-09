BIGWIGS_CMD_OPT = GetLocale() == "koKR" and {
	{
		option	= "잠금",
		desc	= "타이머 바와 메시지를 고정시키거나 풀어줌.",
		method	= "SlashLock",		
	},
	{
		option	= "테스트",
		desc	= "시험용 바와 메시지를 출력.",
		method	= "SlashTest",		
	},	
	{
		option	= "크기",
		desc	= "메시지 및 바 크기를 변경.", 
		method  = "SlashScale",
		input	= "true", 
	}
} 
	or GetLocale() == "zhCN" and
{	
	{
		option	= "lock",
		desc	= "锁定/解锁计时条与信息框体。",
		method	= "SlashLock",		
	},
	{
		option	= "test",
		desc	= "显示测试信息与计时条。",
		method	= "SlashTest",		
	},	
	{
		option	= "scale",
		desc	= "设置计时条与信息框体的缩放大小。", 
		method  = "SlashScale",
		input	= "true",
	}
}
	or
{	
	{
		option	= "lock",
		desc	= "Lock/unlock bar and message frame.",
		method	= "SlashLock",		
	},
	{
		option	= "test",
		desc	= "Shows the test message and bar.",
		method	= "SlashTest",		
	},	
	{
		option	= "scale",
		desc	= "Set the scale of TimerBar and Message.", 
		method  = "SlashScale",
		input	= "true",
	}
}

BigWigs = AceAddon:new({
	name          = "BigWigs",
	description   = "Boss Mods with Timex bars.",
	version       = "0",
	build         = tonumber(string.sub("$Revision$", 12, -3)),
	releaseDate   = string.sub("$Date$", 8, 17),
	aceCompatible = 102,
	author        = "Tekkub Stoutwrithe",
	email 		    = "tekkub@gmail.com",
	category      = "inventory",
	cmd           = AceChatCmd:new(
										{"/bw", "/BigWigs"}, 
										BIGWIGS_CMD_OPT
									),
	db            = AceDatabase:new("BigWigsDB"),

	modules = {},
	enablezones = {},
	enablemobs  = {},

	color = {
		Red    = {1, 0, 0}, Orange = {1, 0.5, 0}, Yellow = {1, 1, 0},
		Green  = {0, 1, 0}, LtBlue = {0, 1, 1},   Blue   = {0, 0, 1},
		Purple = {1, 0, 1}, White  = {1, 1, 1},   Black  = {0, 0, 0},
	},

	loc = GetLocale() == "deDE" and {
		ModuleEnable = "%s mod aktiviert",
		TargetEnable = "Ziel\195\188berwachung aktiviert",
		TargetDisable = "Ziel\195\188berwachung deaktiviert",

		MC = "Geschmolzener Kern",
		BWL = "Pechschwingenhort",
		Onyxia = "Onyxias Hort",
		ZG = "Zul'Gurub",
		AQ20 = "Ruinen von Ahn'Qiraj",
		AQ40 = "Ahn'Qiraj",
		Ashenvale = "Ashenvale",
		Azshara = "Azshara",
		Duskwood = "Duskwood", 
		Feralas = "Feralas",
		Hinterlands = "Das Hinterland", 
	} or GetLocale() == "koKR" and {
		ModuleEnable = "%s 모듈을 시작",
		TargetEnable = "타겟 확인 시작",
		TargetDisable = "타겟 확인 꺼짐",

		MC = "화산 심장부",
		BWL = "검은날개 둥지",		
		Onyxia = "오닉시아의 둥지",
		ZG = "줄구룹",
		AQ20 = "안퀴라즈 폐허",
		AQ40 = "안퀴라즈", 	
		Ashenvale = "잿빛 골짜기",
		Azshara = "아즈샤라",
		Duskwood = "그늘숲", 
		Feralas = "페랄라스",
		Hinterlands = "저주받은 땅", 
	} or {
		ModuleEnable = "%s mod enabled",
		TargetEnable = "Target monitoring enabled",
		TargetDisable = "Target monitoring disabled",

		MC = "Molten Core",
		BWL = "Blackwing Lair",
		Onyxia = "Onyxia's Lair",
		ZG = "Zul'Gurub",
		AQ20 = "Ruins of Ahn'Qiraj",
		AQ40 = "Ahn'Qiraj",
		Ashenvale = "Ashenvale",
		Azshara = "Azshara",
		Duskwood = "Duskwood", 
		Feralas = "Feralas",
		Hinterlands = "The Hinterlands", 
	},
})


function BigWigs:Initialize()
	if not BigWigsDB then BigWigsDB = {} end
		self.sv = BigWigsDB
end


function BigWigs:Enable()
	if ( self:GetOpt("nScale") ) then self:SetScale( self:GetOpt("nScale") ) end		
	self:TogOpt("bLock") 	self:SlashLock() 
	
	self:RegisterEvent("BIGWIGS_BAR_START")
	self:RegisterEvent("BIGWIGS_BAR_CANCEL")
	self:RegisterEvent("BIGWIGS_DELAYEDMESSAGE_START")
	self:RegisterEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL")
	self:RegisterEvent("BIGWIGS_BAR_SETCOLOR")
	self:RegisterEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START")
	self:RegisterEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
end


function BigWigs:Disable()	
	self:UnregisterAllEvents()
end


-------------------------------
--      Module Handling      --
-------------------------------

function BigWigs:RegisterModule(module)

	if not module or not module.name then return end
	self.modules[module.name] = module

	local z = module.zonename

	if type(z) == "string" then
		if self.loc[z] then self.enablezones[self.loc[z]] = true end
	elseif type(z) == "table" then
		for _,zone in pairs(z) do self.enablezones[self.loc[zone]] = true end
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


---------------------------
--      Test method      --
---------------------------

function BigWigs:Test()
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar", 15, 1, "Green", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_MESSAGE", "Test", "Green")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", "OMG Bear!", 5, "Yellow")
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", "*RAWR*", 10, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 5, "Yellow")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 7, "Orange")
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", "Test Bar", 10, "Red")

	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 2", 6, 2, "Green", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 3", 7, 3, "Yellow", "Interface\\Icons\\Spell_Nature_ResistNature")
	self:TriggerEvent("BIGWIGS_BAR_START", "Test Bar 4", 7, 4, "Red", "Interface\\Icons\\Spell_Nature_ResistNature")
end


------------------------------
--      Delay Handlers      --
------------------------------

function BigWigs:BIGWIGS_BAR_DELAYEDSETCOLOR_START(text, time, color)
	if not text or not time then return end
	self:debug(string.format("BIGWIGS_BAR_DELAYEDSETCOLOR | %s | %s | %s", text, time, type(color) == "string" and color or type(color)))
	Timex:AddSchedule("BIGWIGS_BAR_DELAYEDSETCOLOR "..text..time, time, nil, nil, "BIGWIGS_BAR_SETCOLOR", text, color)
end


function BigWigs:BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL(text, time)
	if not text or not time then return end
	Timex:DeleteSchedule("BIGWIGS_BAR_DELAYEDSETCOLOR "..text..time)
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
--      Interface Handler     --
--------------------------------
function BigWigs:SetScale(nScale)	
	if ( nScale and nScale >= 0.25 and nScale <= 5 ) then					
		-- 55 is height of BigWigsAnchorFrame 
		-- local yOfM = 55 - ( 55 * nScale ) 
		-- BigWigsTextFrame:SetPoint("TOP", BigWigsAnchorFrame, "BOTTOM", 0, yOfM)
		BigWigsTextFrame:SetScale(nScale)
		
		self:SetOpt("nScale", nScale)
		self.cmd:result( format("Scale is set to %s", nScale ) )		
	end
end

--------------------------------
--        Slash Handler       --
--------------------------------
function BigWigs:SlashLock()
	if ( self:TogOpt("bLock") ) then 
		BW_BarAnchorButton:Show()
		BW_MsgAnchorButton:Show()
	else
		BW_BarAnchorButton:Hide()
		BW_MsgAnchorButton:Hide()
	end	
end
function BigWigs:SlashTest()
	self:Test()	
end
function BigWigs:SlashScale(ScaleValue)
	local args = ace.ParseWords(ScaleValue)
	scale = tonumber(args[1])

	self:SetScale(scale)
end


--------------------------------
--      Utility Function      --
--------------------------------
function BigWigs:GetOpt(OptName) 
	return self.db:get(self.profilePath,OptName) 
end
function BigWigs:SetOpt(OptName, OptVal)
	self.db:set(self.profilePath,OptName,OptVal) 
end
function BigWigs:TogOpt(OptName) 
	return self.db:toggle(self.profilePath,OptName) 
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigs:RegisterForLoad()
