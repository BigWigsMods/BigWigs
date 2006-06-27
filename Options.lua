
local zones, modules = {}, {}
local sortzone, sortmodule, sortboss = {}, {}, {}
local needsort = false
local dewdrop = DewdropLib:GetInstance("1.0")
local tablet = TabletLib:GetInstance("1.0")


BigWigsOptions = FuBarPlugin:GetInstance("1.2"):new({
	name          = "FuBar - BigWigs",
	description   = GetAddOnMetadata("BigWigs", "Notes"),
	version       = string.sub(GetAddOnMetadata("BigWigs", "X-Build"), 12, -3),
	releaseDate   = string.sub(GetAddOnMetadata("BigWigs", "X-ReleaseDate"), 8, 18),
	author        = GetAddOnMetadata("BigWigs", "Author"),
	email   	    = GetAddOnMetadata("BigWigs", "X-Email"),
	website       = GetAddOnMetadata("BigWigs", "X-Website"),
	category      = GetAddOnMetadata("BigWigs", "X-Category"),

	aceCompatible = 103,
	db            = AceDatabase:new("BigWigsFubarDB"),
	cmd           = AceChatCmd:new({}, {}),

	hideWithoutStandby = true,
	hasIcon = "Interface\\Icons\\INV_Misc_Orb_05",
	hasNoText  = true,
	defaultMinimapPosition = 180,

	loc = {
		running = "|cff00ff00Module running|r",
	},
})


function BigWigsOptions:Initialize()
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end


function BigWigsOptions:Enable()
	self:RegisterEvent("BIGWIGS_REGISTER_MODULE")
end


function BigWigsOptions:Disable()
	self:UnregisterAllEvents()
end


function BigWigsOptions:BIGWIGS_REGISTER_MODULE(module)
	if module.toggleoptions and module.zonename and module.bossname then
		if not zones[module.zonename] then
			table.insert(sortzone, module.zonename)
			zones[module.zonename] = {}
		end
		zones[module.zonename][module.bossname] = module
		table.insert(sortboss, module.bossname)
		needsort = true
	elseif module.MenuSettings then
		modules[module.loc.menutitle] = module
		table.insert(sortmodule, module.loc.menutitle)
		needsort = true
	end
end


function BigWigsOptions:MenuSettings(level, value)
	if level == 1 then self:Menu1(level, value)
	elseif level == 2 then self:Menu2(level, value)
	elseif level == 3 then self:Menu3(level, value) end
end


function BigWigsOptions:Menu1(level, value)
	if needsort then
		table.sort(sortzone)
		table.sort(sortboss)
		table.sort(sortmodule)
		needsort = false
	end

	for _,i in pairs(sortmodule) do
		dewdrop:AddLine("text", i, "value", modules[i], "hasArrow", true)
	end

	if table.getn(sortmodule) > 0 then dewdrop:AddLine() end

	for _,i in pairs(sortzone) do
		dewdrop:AddLine("text", i, "value", zones[i], "hasArrow", true)
	end

end


function BigWigsOptions:Menu2(level, value)
	if type(value) ~= "table" then return end

	if value.MenuSettings then
		value:MenuSettings(level, value)
		return
	end

	if needsort then
		table.sort(sortzone)
		table.sort(sortboss)
		table.sort(sortmodule)
		needsort = false
	end

	for _,i in pairs(sortboss) do
		local v = value[i]
		if v then
			local en = not v.disabled
			dewdrop:AddLine("text", i, "value", v, "hasArrow", true, "checked", en, "func", en and v.Disable or v.Enable, "arg1", v)
		end
	end
end


function BigWigsOptions:Menu3(level, value)
	if type(value) ~= "table" then return end

	if not value.disabled then
		dewdrop:AddLine("text", self.loc.running)
		dewdrop:AddLine()
	end

	if value.optionorder then
		for _,i in pairs(value.optionorder) do
			local v = value.toggleoptions[i]
			dewdrop:AddLine("text", v, "func", value.TogOpt, "arg1", value, "arg2", i, "checked", not value:GetOpt(i))
		end
	else
		for i,v in pairs(value.toggleoptions) do
			dewdrop:AddLine("text", v, "func", value.TogOpt, "arg1", value, "arg2", i, "checked", not value:GetOpt(i))
		end
	end
end


--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsOptions:RegisterForLoad()
