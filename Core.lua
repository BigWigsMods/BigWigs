
local tekteck = TekTechEmbed:GetInstance("1")
local sv


BigWigs = AceAddon:new({
	name          = "BigWigs",
	description   = GetAddOnMetadata("BigWigs", "Notes"),
	version       = string.sub(GetAddOnMetadata("BigWigs", "X-Build"), 12, -3),
	releaseDate   = string.sub(GetAddOnMetadata("BigWigs", "X-ReleaseDate"), 8, 18),
	author        = GetAddOnMetadata("BigWigs", "Author"),
	email   	    = GetAddOnMetadata("BigWigs", "X-Email"),
	website       = GetAddOnMetadata("BigWigs", "X-Website"),
	category      = GetAddOnMetadata("BigWigs", "X-Category"),

	aceCompatible = 103,
	cmd           = AceChatCmd:new({"/bw", "/BigWigs"}, {}),
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
		Naxxramas = "Naxxramas",
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
		Naxxramas = "Naxxramas",
	} or GetLocale() == "zhCN" and {
		ModuleEnable = "%s模块已开启",
		TargetEnable = "目标监视已开启",
		TargetDisable = "目标监视已关闭",

		MC = "熔火之心",
		BWL = "黑翼之巢",
		Onyxia = "奥妮克西亚的巢穴",
		ZG = "祖尔格拉布",
		AQ20 = "安其拉废墟",
		AQ40 = "安其拉",
		Ashenvale = "灰谷",
		Azshara = "艾萨拉",
		Duskwood = "暮色森林",
		Feralas = "菲拉斯",
		Hinterlands = "辛特兰",
		Naxxramas = "Naxxramas",
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
		Naxxramas = "Naxxramas",
	},
})


function BigWigs:Initialize()
	if not BigWigsDB then BigWigsDB = {} end
	sv = BigWigsDB
end


function BigWigs:Enable()
	self:RegisterEvent("BIGWIGS_REGISTER_MODULE")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	self:TriggerEvent("BIGWIGS_SYNC_THROTTLE", "ENABLEMODULE", 10)
end


function BigWigs:Disable()
	self:UnregisterAllEvents()
end


-------------------------------
--      Module Handling      --
-------------------------------

local bw = BigWigs
local get = function(self, a1,a2,a3,a4,a5,a6,a7,a8,a9) return tekteck:TableGetVal(sv, self.name, a1,a2,a3,a4,a5,a6,a7,a8,a9) end
local set = function(self, val,a1,a2,a3,a4,a5,a6,a7,a8,a9) tekteck:TableSetVal(sv, val, self.name, a1,a2,a3,a4,a5,a6,a7,a8,a9) end
local tog = function(self, a1,a2,a3,a4,a5,a6,a7,a8,a9)
	local x
	if not get(self, a1,a2,a3,a4,a5,a6,a7,a8,a9) then x = true end
	set(self, x, a1,a2,a3,a4,a5,a6,a7,a8,a9)
	return x
end


function BigWigs:RegisterModule(module)
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", module)
end


function BigWigs:BIGWIGS_REGISTER_MODULE(module)
	assert(module, "No module passed")
	assert(module.name, "Module has no name element")

	self.modules[module.name] = module

	module.GetOpt, module.SetOpt, module.TogOpt = get, set, tog
	if module.cmdOptions then
		module.cmdOptions.handler = module
		table.insert(self.cmd.options, module.cmdOptions)
	end

	local z = module.zonename

	if type(z) == "string" then
		self.enablezones[self.loc[z] or z] = true
	elseif type(z) == "table" then
		for _,zone in pairs(z) do self.enablezones[self.loc[zone] or zone] = true end
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
		self:TriggerEvent("BIGWIGS_MESSAGE", string.format(self.loc.ModuleEnable, m.loc.bossname or m.bossname or "??"), "LtBlue", true)
		self:TriggerEvent("BIGWIGS_SYNC_SEND", "ENABLEMODULE " .. (m.loc.bossname or m.bossname or "??" ) )
	end
end

function BigWigs:BIGWIGS_SYNC_ENABLEMODULE( module, nick )
	if ( module ) then self:EnableModule(module) end
end


function BigWigs:ZONE_CHANGED_NEW_AREA()
	if self.enablezones[GetRealZoneText()] then
		self.monitoring = true
--~~ 		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.TargetEnable, "LtBlue", true, false)
		self:RegisterEvent("PLAYER_TARGET_CHANGED")
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	elseif self.monitoring then
		self.monitoring = nil
--~~ 		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.TargetDisable, "LtBlue", true, false)
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


function BigWigs:Test()
	self:TriggerEvent("BIGWIGS_TEST")
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigs:RegisterForLoad()
