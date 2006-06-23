
local zones = {}
local options = {}
local dewdrop = DewdropLib:GetInstance("1.0")
local tablet = TabletLib:GetInstance("1.0")


BigWigsOptions = FuBarPlugin:GetInstance("1.2"):new({
	name          = "FuBar - BigWigs",
	description   = "Options menu for BigWigs",
	version       = 0,
	releaseDate   = "2006-04-06",
	aceCompatible = 103,
	category      = "interface",
	author        = "Tekkub Stoutwrithe",
	db            = AceDatabase:new("BigWigsFubarDB"),
	cmd           = AceChatCmd:new({}, {}),

	hasIcon = "Interface\\Icons\\INV_Misc_Orb_05",
})


function BigWigsOptions:Initialize()
	self:RegisterEvent("BIGWIGS_REGISTER_MODULE")
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", module)
end


function BigWigsOptions:Enable()
end


function BigWigsOptions:Disable()
	self:UnregisterAllEvents()
end


function BigWigsOptions:BIGWIGS_REGISTER_MODULE(module)
	if module.toggleoptions then
		if not zones[module.zonename] then zones[module.zonename] = {} end
		zones[module.zonename][module.bossname] = module
	end
end


function BigWigsOptions:MenuSettings(level, value)
	if level == 1 then self:Menu1(level, value)
	elseif level == 2 then self:Menu2(level, value)
	elseif level == 3 then self:Menu3(level, value) end
end


function BigWigsOptions:Menu1(level, value)
	for i,v in pairs(zones) do
		dewdrop:AddLine("text", i, "value", v, "hasArrow", true)
	end
end


function BigWigsOptions:Menu2(level, value)
	if type(value) ~= "table" then return end

	for i,v in pairs(value) do
		dewdrop:AddLine("text", i, "value", v, "hasArrow", true)
	end
end


function BigWigsOptions:Menu3(level, value)
	if type(value) ~= "table" then return end

	for i,v in pairs(value.toggleoptions) do
		dewdrop:AddLine("text", v, "func", value.TogOpt, "arg1", value, "arg2", i, "checked", not value:GetOpt(i))
	end
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsOptions:RegisterForLoad()
