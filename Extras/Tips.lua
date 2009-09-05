----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewBoss("Tip of the Raid", "$Revision$")
if not mod then return end
mod.external = true

----------------------------
--   Are you local?       --
----------------------------

local L = LibStub("AceLocale-3.0"):GetLocale("BigWigs:Extras")

local compress = LibStub("LibCompress")
local AceGUI = LibStub("AceGUI-3.0")

------------------------------
--      Initialization      --
------------------------------

local tip1 = "Calebv says:#While you don't need to rant and rage over each minor error, don't let repeated screwups be ignored. No one likes \"that guy\" who doesn't care enough to pay attention and causes wipes to the same stuff each week -- say something to him.\n#<Ensidia> @ Matheridon EU - www.ensidia.com\nCalebv says:#While you don't need to rant and rage over each minor error, don't let repeated screwups be ignored. No one likes \"that guy\" who doesn't care enough to pay attention and causes wipes to the same stuff each week -- say something to him.\n#<Ensidia> @ Matheridon EU - www.ensidia.com\nCalebv says:#While you don't need to rant and rage over each minor error, don't let repeated screwups be ignored. No one likes \"that guy\" who doesn't care enough to pay attention and causes wipes to the same stuff each week -- say something to him.\n#<Ensidia> @ Matheridon EU - www.ensidia.com\nCalebv says:#While you don't need to rant and rage over each minor error, don't let repeated screwups be ignored. No one likes \"that guy\" who doesn't care enough to pay attention and causes wipes to the same stuff each week -- say something to him.\n#<Ensidia> @ Matheridon EU - www.ensidia.com\n"

function compressTest()
	local lzw = compress:CompressLZW(tip1)
	local huff = compress:CompressHuffman(tip1)
	print("Uncompressed size: " .. #tip1)
	print("LZW size: " .. #lzw)
	print("Huff size: " .. #huff)
	--print(huff)
end

local function createTipFrame()
	local f = CreateFrame("Frame", nil, UIParent)
	f:SetWidth(240)
	f:SetHeight(175)
	f:SetPoint("CENTER", UIParent, "CENTER")
	f:SetMovable(true)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	
	local titlebg = f:CreateTexture(nil, "BACKGROUND")
	titlebg:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Title-Background]])
	titlebg:SetPoint("TOPLEFT", 9, -6)
	titlebg:SetPoint("BOTTOMRIGHT", f, "TOPRIGHT", -28, -24)
	
	local dialogbg = f:CreateTexture(nil, "BACKGROUND")
	dialogbg:SetTexture([[Interface\Tooltips\UI-Tooltip-Background]])
	dialogbg:SetPoint("TOPLEFT", 8, -24)
	dialogbg:SetPoint("BOTTOMRIGHT", -6, 8)
	dialogbg:SetVertexColor(0, 0, 0, .75)
	
	local topleft = f:CreateTexture(nil, "BORDER")
	topleft:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	topleft:SetWidth(64)
	topleft:SetHeight(64)
	topleft:SetPoint("TOPLEFT")
	topleft:SetTexCoord(0.501953125, 0.625, 0, 1)
	
	local topright = f:CreateTexture(nil, "BORDER")
	topright:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	topright:SetWidth(64)
	topright:SetHeight(64)
	topright:SetPoint("TOPRIGHT")
	topright:SetTexCoord(0.625, 0.75, 0, 1)
	
	local top = f:CreateTexture(nil, "BORDER")
	top:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	top:SetHeight(64)
	top:SetPoint("TOPLEFT", topleft, "TOPRIGHT")
	top:SetPoint("TOPRIGHT", topright, "TOPLEFT")
	top:SetTexCoord(0.25, 0.369140625, 0, 1)
	
	local bottomleft = f:CreateTexture(nil, "BORDER")
	bottomleft:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	bottomleft:SetWidth(64)
	bottomleft:SetHeight(64)
	bottomleft:SetPoint("BOTTOMLEFT")
	bottomleft:SetTexCoord(0.751953125, 0.875, 0, 1)
	
	local bottomright = f:CreateTexture(nil, "BORDER")
	bottomright:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	bottomright:SetWidth(64)
	bottomright:SetHeight(64)
	bottomright:SetPoint("BOTTOMRIGHT")
	bottomright:SetTexCoord(0.875, 1, 0, 1)
	
	local bottom = f:CreateTexture(nil, "BORDER")
	bottom:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	bottom:SetHeight(64)
	bottom:SetPoint("BOTTOMLEFT", bottomleft, "BOTTOMRIGHT")
	bottom:SetPoint("BOTTOMRIGHT", bottomright, "BOTTOMLEFT")
	bottom:SetTexCoord(0.376953125, 0.498046875, 0, 1)
	
	local left = f:CreateTexture(nil, "BORDER")
	left:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	left:SetWidth(64)
	left:SetPoint("TOPLEFT", topleft, "BOTTOMLEFT")
	left:SetPoint("BOTTOMLEFT", bottomleft, "TOPLEFT")
	left:SetTexCoord(0.001953125, 0.125, 0, 1)
	
	local right = f:CreateTexture(nil, "BORDER")
	right:SetTexture([[Interface\PaperDollInfoFrame\UI-GearManager-Border]])
	right:SetWidth(64)
	right:SetPoint("TOPRIGHT", topright, "BOTTOMRIGHT")
	right:SetPoint("BOTTOMRIGHT", bottomright, "TOPRIGHT")
	right:SetTexCoord(0.1171875, 0.2421875, 0, 1)
	
	local close = CreateFrame("Button", nil, f, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", 2, 1)
	close:SetScript("OnClick", function(self, button) f:Hide() end)
	
	local title = f:CreateFontString(nil, "ARTWORK")
	title:SetFontObject(GameFontNormal)
	title:SetPoint("TOPLEFT", 12, -8)
	title:SetPoint("TOPRIGHT", -32, -8)
	title:SetText("Tip of the Raid")
	
	local titlebutton = CreateFrame("Button", nil, f)
	titlebutton:SetPoint("TOPLEFT", titlebg)
	titlebutton:SetPoint("BOTTOMRIGHT", titlebg)
	titlebutton:RegisterForDrag("LeftButton")
	titlebutton:SetScript("OnDragStart", function()
		f.moving = true
		f:StartMoving()
	end)
	titlebutton:SetScript("OnDragStop", function()
		f.moving = nil
		f:StopMovingOrSizing()
	end)
	
	local frame = AceGUI:Create("SimpleGroup")
	frame:SetLayout("List")
	frame:SetWidth(216) -- set width so flow layout fricking works
	frame:SetPoint("TOPLEFT", f, "TOPLEFT", 12, -32)
	frame:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -12, 12)
	frame.frame:SetParent(f)
	
	local from = AceGUI:Create("Label")
	from:SetText("Calebv says:")
	from:SetFontObject(GameFontNormalLarge)
	local r, g, b = GameFontNormalLarge:GetTextColor()
	from:SetColor(r, g, b)
	from:SetFullWidth(true)
	
	local text = AceGUI:Create("Label")
	text:SetText("While you don't need to rant and rage over each minor error, don't let repeated screwups be ignored. No one likes \"that guy\" who doesn't care enough to pay attention and causes wipes to the same stuff each week -- say something to him.\n")
	text:SetFontObject(GameFontNormal)
	text:SetFullWidth(true)
	
	local sub = AceGUI:Create("Label")
	sub:SetText("<Ensidia> @ Matheridon EU - www.ensidia.com\n")
	sub:SetFontObject(GameFontDisableSmall)
	local r, g, b = GameFontDisableSmall:GetTextColor()
	sub:SetColor(r, g, b)
	sub:SetFullWidth(true)

	local cool = AceGUI:Create("Button")
	cool:SetText("Cool!")
	cool:SetCallback("OnClick", function() f:Hide() end)
	cool:SetFullWidth(true)

	frame:AddChildren(from, text, sub, cool)
	frame.frame:Show()
	f:Show()
end

function mod:OnRegister()
	createTipFrame()
end

function mod:OnBossEnable()

end


