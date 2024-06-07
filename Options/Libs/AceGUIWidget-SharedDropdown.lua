-- soooooo hacky, AceGUIWidget-DropDown with a single shared pullout!
-- removes the extra overhead when loading many LSM (or whatever) dropdowns in a layout
-- uses the last :SetList as the pullout for _every_ SharedDropdown, GOOD LUCK EVERYONE

local AceGUI = LibStub("AceGUI-3.0")

-- Lua APIs
local select, pairs, ipairs, type, tostring = select, pairs, ipairs, type, tostring
local tsort = table.sort

-- WoW APIs
local UIParent, CreateFrame = UIParent, CreateFrame
local _G = _G

local function fixlevels(parent, ...)
	local i = 1
	local child = select(i, ...)
	while child do
		child:SetFrameLevel(parent:GetFrameLevel() + 1)
		fixlevels(child, child:GetChildren())
		i = i + 1
		child = select(i, ...)
	end
end

do
	local widgetType = "SharedDropdown"
	local widgetVersion = 1

	--[[ Static data ]]--

	local _pullout = AceGUI:Create("Dropdown-Pullout")
	_pullout:SetCallback("OnOpen", function(this)
		local self = this.userdata.obj

		local value = self.value
		for i, item in this:IterateItems() do
			item:SetValue(item.userdata.value == value)
		end

		self.open = true
		self:Fire("OnOpened")
	end)
	_pullout:SetCallback("OnClose", function(this)
		local self = this.userdata.obj
		self.open = nil
		self:Fire("OnClosed")
	end)

	--[[ UI event handler ]]--

	local function Control_OnEnter(this)
		this.obj.button:LockHighlight()
		this.obj:Fire("OnEnter")
	end

	local function Control_OnLeave(this)
		this.obj.button:UnlockHighlight()
		this.obj:Fire("OnLeave")
	end

	local function Dropdown_OnHide(this)
		local self = this.obj
		if self.open then
			_pullout:Close()
		end
	end

	local function Dropdown_TogglePullout(this)
		local self = this.obj
		_pullout.userdata.obj = self

		if self.open then
			self.open = nil
			_pullout:Close()
			AceGUI:ClearFocus()
		else
			self.open = true
			_pullout.frame:SetFrameLevel(self.frame:GetFrameLevel() + 1)
			fixlevels(_pullout.frame, _pullout.frame:GetChildren())
			_pullout:SetWidth(self.pulloutWidth or self.frame:GetWidth())
			_pullout:Open("TOPLEFT", self.frame, "BOTTOMLEFT", 0, self.label:IsShown() and -2 or 0)
			_pullout.scrollStatus.scrollvalue = 0
			_pullout.scrollStatus.offset = 0
			_pullout:FixScroll()
			AceGUI:SetFocus(self)
		end
	end

	local function OnItemValueChanged(this, event, checked)
		local self = _pullout.userdata.obj

		if checked then
			self:SetValue(this.userdata.value)
			self:Fire("OnValueChanged", this.userdata.value)
		else
			this:SetValue(true)
		end
		if self.open then
			_pullout:Close()
		end
	end

	--[[ Exported methods ]]--

	-- exported, AceGUI callback
	local function OnAcquire(self)
		self:SetHeight(44)
		self:SetWidth(200)
		self:SetLabel()
		self:SetPulloutWidth(nil)
		self.list = {}
	end

	-- exported, AceGUI callback
	local function OnRelease(self)
		if self.open then
			_pullout:Close()
		end

		self:SetText("")
		self:SetDisabled(false)

		self.value = nil
		self.list = nil
		self.open = nil

		self.frame:ClearAllPoints()
		self.frame:Hide()
	end

	-- exported
	local function SetDisabled(self, disabled)
		self.disabled = disabled
		if disabled then
			self.text:SetTextColor(0.5, 0.5, 0.5)
			self.button:Disable()
			self.button_cover:Disable()
			self.label:SetTextColor(0.5, 0.5, 0.5)
		else
			self.button:Enable()
			self.button_cover:Enable()
			self.label:SetTextColor(1, 0.82, 0)
			self.text:SetTextColor(1, 1, 1)
		end
	end

	-- exported
	local function ClearFocus(self)
		if self.open then
			_pullout:Close()
		end
	end

	-- exported
	local function SetText(self, text)
		self.text:SetText(text or "")
	end

	-- exported
	local function SetLabel(self, text)
		if text and text ~= "" then
			self.label:SetText(text)
			self.label:Show()
			self.dropdown:SetPoint("TOPLEFT", self.frame, "TOPLEFT" ,-15, -14)
			self:SetHeight(40)
			self.alignoffset = 26
		else
			self.label:SetText("")
			self.label:Hide()
			self.dropdown:SetPoint("TOPLEFT", self.frame ,"TOPLEFT", -15, 0)
			self:SetHeight(26)
			self.alignoffset = 12
		end
	end

	-- exported
	local function SetValue(self, value)
		self:SetText(self.list[value] or "")
		self.value = value
	end

	-- exported
	local function GetValue(self)
		return self.value
	end

	local function AddListItem(self, value, text, itemType)
		if not itemType then itemType = "Dropdown-Item-Toggle" end
		local exists = AceGUI:GetWidgetVersion(itemType)
		if not exists then error(("The given item type, %q, does not exist within AceGUI-3.0"):format(tostring(itemType)), 2) end

		local item = AceGUI:Create(itemType)
		item:SetText(text)
		-- item.userdata.obj = self
		item.userdata.value = value
		item:SetCallback("OnValueChanged", OnItemValueChanged)
		_pullout:AddItem(item)
	end

	local sortlist = {}
	local function sortTbl(x,y)
		local num1, num2 = tonumber(x), tonumber(y)
		if num1 and num2 then -- numeric comparison, either two numbers or numeric strings
			return num1 < num2
		else -- compare everything else tostring'ed
			return tostring(x) < tostring(y)
		end
	end
	-- exported
	local function SetList(self, list, order, itemType)
		self.list = list or {}
		if list and self.list == _pullout.list and #list == #self.list then return end
		_pullout.list = self.list
		_pullout:Clear()
		if not list then return end

		if type(order) ~= "table" then
			for v in pairs(list) do
				sortlist[#sortlist + 1] = v
			end
			tsort(sortlist, sortTbl)

			for i, key in ipairs(sortlist) do
				AddListItem(self, key, list[key], itemType)
				sortlist[i] = nil
			end
		else
			for i, key in ipairs(order) do
				AddListItem(self, key, list[key], itemType)
			end
		end
	end

	-- exported
	local function SetPulloutWidth(self, width)
		self.pulloutWidth = width
	end

	--[[ Constructor ]]--

	local function Constructor()
		local count = AceGUI:GetNextWidgetNum(widgetType)
		local frame = CreateFrame("Frame", nil, UIParent)
		local dropdown = CreateFrame("Frame", "AceGUI30SharedDropdown" .. count, frame, "UIDropDownMenuTemplate")

		local self = {}
		self.type = widgetType
		self.frame = frame
		self.dropdown = dropdown
		self.count = count
		frame.obj = self
		dropdown.obj = self

		self.OnRelease = OnRelease
		self.OnAcquire = OnAcquire

		self.ClearFocus = ClearFocus

		self.SetText  = SetText
		self.SetValue = SetValue
		self.GetValue = GetValue
		self.SetList = SetList
		self.SetLabel = SetLabel
		self.SetDisabled = SetDisabled
		self.SetPulloutWidth = SetPulloutWidth

		self.alignoffset = 26

		frame:SetScript("OnHide", Dropdown_OnHide)

		dropdown:ClearAllPoints()
		dropdown:SetPoint("TOPLEFT", frame, "TOPLEFT", -15, 0)
		dropdown:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 17, 0)
		dropdown:SetScript("OnHide", nil)

		local left = _G[dropdown:GetName() .. "Left"]
		local middle = _G[dropdown:GetName() .. "Middle"]
		local right = _G[dropdown:GetName() .. "Right"]

		middle:ClearAllPoints()
		right:ClearAllPoints()

		middle:SetPoint("LEFT", left, "RIGHT", 0, 0)
		middle:SetPoint("RIGHT", right, "LEFT", 0, 0)
		right:SetPoint("TOPRIGHT", dropdown, "TOPRIGHT", 0, 17)

		local button = _G[dropdown:GetName() .. "Button"]
		self.button = button
		button.obj = self
		button:SetScript("OnEnter", Control_OnEnter)
		button:SetScript("OnLeave", Control_OnLeave)
		button:SetScript("OnClick", Dropdown_TogglePullout)

		local button_cover = CreateFrame("BUTTON", nil, self.frame)
		self.button_cover = button_cover
		button_cover.obj = self
		button_cover:SetPoint("TOPLEFT", self.frame, "BOTTOMLEFT", 0, 25)
		button_cover:SetPoint("BOTTOMRIGHT", self.frame, "BOTTOMRIGHT")
		button_cover:SetScript("OnEnter", Control_OnEnter)
		button_cover:SetScript("OnLeave", Control_OnLeave)
		button_cover:SetScript("OnClick", Dropdown_TogglePullout)

		local text = _G[dropdown:GetName() .. "Text"]
		self.text = text
		text.obj = self
		text:ClearAllPoints()
		text:SetPoint("RIGHT", right, "RIGHT" ,-43, 2)
		text:SetPoint("LEFT", left, "LEFT", 25, 2)

		local label = frame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
		label:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
		label:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
		label:SetJustifyH("LEFT")
		label:SetHeight(18)
		label:Hide()
		self.label = label

		AceGUI:RegisterAsWidget(self)
		return self
	end

	AceGUI:RegisterWidgetType(widgetType, Constructor, widgetVersion)
end
