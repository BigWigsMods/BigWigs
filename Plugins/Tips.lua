-- XXX The tip window needs a "Show tips next raid" checkbox that can be toggled off,
-- XXX but I don't know where to put it without making the window look overcrowded and crappy ><

-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("Tip of the Raid")
if not plugin then return end

local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

-------------------------------------------------------------------------------
-- Options
--

local colorize = nil
do
	local r, g, b
	colorize = setmetatable({}, { __index =
		function(self, key)
			if not r then r, g, b = GameFontNormal:GetTextColor() end
			self[key] = "|cff" .. string.format("%02x%02x%02x", r * 255, g * 255, b * 255) .. key .. "|r"
			return self[key]
		end
	})
end

plugin.defaultDB = {
	show = true,
	automatic = true,
	manual = true,
	chat = false,
}

local function get(info) return plugin.db.profile[info[#info]] end
local function set(info, value) plugin.db.profile[info[#info]] = value end
local function disable() return not plugin.db.profile.show end

plugin.subPanelOptions = {
	key = "Big Wigs: Tips",
	name = L["Tip of the Raid"],
	options = {
		type = "group",
		name = L["Tips"],
		get = get,
		set = set,
		args = {
			description = {
				type = "description",
				name = L["Tip of the raid will show by default when you zone in to a raid instance, you are not in combat, and your raid group has more than 9 players in it. Only one tip will be shown per session, typically.\n\nHere you can tweak how to display that tip, either using the pimped out window (default), or outputting it to chat. If you play with officers who overuse the |cffff4411/sendtip command|r, you might want to show them in chat frame instead!"],
				order = 1,
				width = "full",
				fontSize = "medium",
			},
			header = {
				type = "description",
				name = " ",
				order = 2,
				width = "full",
			},
			show = {
				type = "toggle",
				name = colorize[L["Enable"]],
				desc = L["If you don't want to see any tips, ever, you can toggle them off here. Tips sent by your raid officers will also be blocked by this, so be careful."],
				order = 3,
				width = "full",
				descStyle = "inline",
			},
			separator = {
				type = "description",
				name = " ",
				order = 10,
				width = "full",
			},
			automatic = {
				type = "toggle",
				name = colorize[L["Automatic tips"]],
				desc = L["If you don't want to see the awesome tips we have, contributed by some of the best PvE players in the world, pop up when you zone in to a raid instance, you can disable this option."],
				order = 11,
				width = "full",
				disabled = disable,
			},
			manual = {
				type = "toggle",
				name = colorize[L["Manual tips"]],
				desc = L["Raid officers have the ability to show manual tips with the /sendtip command. If you have an officer who spams these things, or for some other reason you just don't want to see them, you can disable it with this option."],
				order = 12,
				width = "full",
				disabled = disable,
			},
			separator2 = {
				type = "description",
				name = " ",
				order = 20,
				width = "full",
			},
			chat = {
				type = "toggle",
				name = colorize[L["Output to chat frame"]],
				desc = L["By default the tips will be shown in their own, awesome window in the middle of your screen. If you toggle this, however, the tips will ONLY be shown in your chat frame as pure text, and the window will never bother you again."],
				order = 21,
				width = "full",
				descStyle = "inline",
				disabled = disable,
			},
		},
	},
}

-------------------------------------------------------------------------------
-- Tips
--

local footers = {
	"Premonition @ Sen'jin US\n|cff9999ffwww.premoguild.com|r",
	"Big Wigs Developer\n|cff9999ffwowace.com/projects/big-wigs|r",
	"Ensidia @ Lightning's Blade EU\n|cff9999ffwww.ensidia.com|r",
}

------------[[
-- READ ME:
-- You are NOT ALLOWED to put in your own tips (in the mainline BigWigs repository)
-- without first asking Rabbit!
-- Locally you can do whatever you want, of course. Or in a branch.
-------------------------------------------------------------------------------------]]

local tips = {
	"Calebv#HUNTER#Everyone likes beer, but you need to know your limit. You might have fun while you are intoxicated, but your fellow raiders might not enjoy dragging a drunken slacker through an instance.#3",
	"Calebv#HUNTER#Use Macros/Addons oriented for your class/role, be familiar with the addons you use to get the best performance. But on the other hand don't only rely on addons, sometimes they can bug, especially when a new major content patch comes.#3",
	"Calebv#HUNTER#If you see someone who is about to take unnecessary damage, ie: void zone, aggroing adds, don't hesitate to call out his name. Especially if the person tends to be slow to react.#3",
	"Mek#SHAMAN#Not everyone in your raid will be of the same standard. However if some players are significantly worse and drag your raid down then it will demotivate your best players. This is something you want to avoid at all costs.#3",
	"Mek#SHAMAN#Surviving is the most important thing when you are raiding, especially on new content. You can't DPS when you are face down on the floor so focus on staying alive and not the DPS meter.#3",
	"Mek#SHAMAN#Always organise your raid groups in a similar structure whenever you raid. This means that your healers will become instinctively familiar where certain parts of the raid usually sit in their frame.#3",
	"Mek#SHAMAN#Try to avoid having only one player for one raid spot. If a player becomes too comfortable in their spot and takes it for granted, they will naturally slack. Players who know they must compete for their raid spot will always play better.#3",
	"Buzzkill#WARLOCK#When you're nearing the enrage timer on a boss, don't panic, keep calm and stick to your assigned duties.#3",
	"Buzzkill#WARLOCK#There is nothing more important in the raid than staying alive, do not sacrifice survivability and risk a wipe for higher numbers on the meters.#3",
	"Buzzkill#WARLOCK#When trying a new boss, always try every ability and trick your class has to offer. You never know what might work and help you to a faster kill.#3",
	"Buzzkill#WARLOCK#If you think you can do something better than the assigned person, do it. Anyone can press the rotation, only few can stay calm when important stuff has to be done.#3",
	"Buzzkill#WARLOCK#If you have an idea about how to solve a problem in an encounter, speak out no matter how ridiculous it sounds, sometimes the craziest strategies are the best.#3",
	"Buzzkill#WARLOCK#When you think someone is playing badly, speak out and try to get him replaced, bad players will not only lower results, but also morale of the whole raid.#3",
	"Buzzkill#WARLOCK#Don't be afraid to use unorthodox approaches just because the majority doesn't think it's viable. If you're sure in what you're doing, results will come. (but may vary:))#3",
	"Buzzkill#WARLOCK#Synergy in the group is the first and most important step towards a successfull raid setup. Make sure everyone gets every buff they realistically can.#3",
	"Buzzkill#WARLOCK#Avoid bringing a \"lesser\" player just because he plays an overpowered class in a given fight. A better skilled player might offer much more than just pure numbers.#3",
	"Buzzkill#WARLOCK#Always compete with your fellow raiders, healthy competition will help all of your performances and improve the raid as a whole.#3",
	"Buzzkill#WARLOCK#Swap special duties in encounters between classmates, everyone should be versed in everything, you never know what you'll have to do in the next fight.#3",
	"Buzzkill#WARLOCK#Assign items to people that deserve it the most and will benefit from it the most during progress. Fair distribution might seem nice, but it doesn't always favor important players in the raid.#3",
	"Buzzkill#WARLOCK#Don't be afraid to dish out criticism when someone makes a mistake, but be ready to accept it yourself.#3",
	"Buzzkill#WARLOCK#Familiarise yourself with everyones duties in the raid, you never know when you'll have to jump in and help on someones assigment.#3",
	"Buzzkill#WARLOCK#Be informed about every aspect, mechanic and a debuff of a fight, there is nothing more important than knowing what you're up against at all times.#3",
	"Buzzkill#WARLOCK#Scroll out your camera to max range via macro and be observant of things happening around you. Anticipating something might not only vastly improve your performance, but can also save your life.#3",
	"Munken#HUNTER#Remember this is just a game. Dont forget your family and friends. Keep in touch!#3",
	"Eoy#PRIEST#Don't give up. Many first kills have happened very late in the night after several hours of wiping to stupid things.#3",
	"Hams#WARLOCK#When you wipe the raid don't start a 10 minute excuse about how you made a mistake, but admit the mistake and shut up.#3",
	"Siiri#DEATHKNIGHT#Don't be afraid to speak up on ventrilo, but keep it relevant during a boss fight. Swearing or making grunts when you die will just make people nervous, and make a salvageable kill much less likely.#3",
	"Implied#SHAMAN#We are what we do repeatedly, practice makes perfect. Excellence, therefore, is not an act; but a habit.#3",

	"Cheesycraft#MAGE#Think about all the abilities and talents available to your class before a fight. A player can often gain a tremendous advantage through the use of less commonly thought of abilities and talents.#1",
	"Cheesycraft#MAGE#You gotta pay the cost to be the boss. Gold should never be a limiting factor in improving your character!#1",
	"Cheesycraft#MAGE#While defensive talents and abilities may not seem useful, you are only productive for as long as you live. Survival is critical!#1",
	"Cheesycraft#MAGE#We all love purples, but always keep the groups best interest in mind. Sometimes it's better to let someone else get that bigger upgrade.#1",
	"Cheesycraft#MAGE#Strive to improve. Being the best in your guild is great, but there is always room for improvement!#1",
	"Zaroua#PALADIN#It's better to get yelled at for announcing that you need to go AFK than to get yelled at for wiping the raid by going AFK without telling anyone.#1",
	"Vallkor#HUNTER#It's good to ask questions if you are unsure about something, unless it was answered minutes before you asked.#1",
	"Vallkor#HUNTER#Making sure your combat log is readily accessible and easy to browse is crucial in figuring out \"what went wrong?\".#1",
	"Nessala#ROGUE#Don't wait until the ready check to Eat, Buff, Eat, Buff and then Eat again.#1",
	"Nessala#ROGUE#Don't stand next to an RP'ing mob if you have less than 25k armor, you never know who he is going to take that first swing at.#1",
	"Nessala#ROGUE#Unless it is using the wrong rank of a spell 2+ months into the expansion... then it is deny > deny > DV.#1",
	"Shift#SHAMAN#Don't stand in fire or fire-like things.#1",
	"Xav#WARRIOR#Standing next to the tank when he or she is tanking mobs is not a good idea. Most mobs have cleaves or frontal breath-like attacks that will quickly kill your character.#1",
	"Devium#DEATHKNIGHT#Whenever you die, take some time to look through your combat log and figure out why you died. This makes you able to change your play for next time.#1",
	"Devium#DEATHKNIGHT#The first time you encounter something, try all of your abilities out. Snares, stuns, silences, crowd controls, you never know which obscure ability could make a difference.#1",
	"Psamtik#MAGE#Avoid going berserk when the error of one of your fellow raiders causes the raid to wipe, particularly if you are not absolutely certain that you will never make the same mistake.#1",
	"Psamtik#MAGE#\"Ought\" implies \"can\" - it is irrational to expect more out of a player than experience and/or gear permits.#1",
	"Psamtik#MAGE#Treat farm content with respect, or you are most likely going to be in for a long, stultifying night.#1",
	"Psamtik#MAGE#It's just a game, of course, but that's no excuse for mediocrity.#1",
	"Siiz#MAGE#Play for your guild, not yourself.#1",
	"Descretoria#DEATHKNIGHT#Everyone messes up sometimes! It's better to own up to your mistakes and move on than to try hiding them for any reason.#1",
	"Descretoria#DEATHKNIGHT#After a wipe don't try to lay blame or point fingers, just focus on what you can do both individually and as a group to prevent a wipe in the future.#1",
	"Pinch#ROGUE#If you're going to stand in the fire, make sure you ask your healers if they are comfortable with it first!#1",
	"Kyridel#HUNTER#Raid frames aren't just for healers! Knowing what's happening to your raid is important for everyone.#1",
	"Kyridel#HUNTER#Consistency is key! Dodging void zones 9 times out of 10 usually isn't good enough.#1",
	"Darthn#DRUID#Don't worry about your gear when applying to a guild. Experience goes a long way.#1",
	"Darthn#DRUID#Mods are helpful for the game but you should be able to play without them in case a patch breaks them all.#1",
	"Darthn#DRUID#A clean UI makes it much easier to see void zones/flame patches/cosmic smashes/etc.#1",
	"Darthn#DRUID#You should have all your \"Oh sh*t\" buttons keybound for optimal response time.#1",
	"Darthn#DRUID#Threat meters should be a part of every DPS UI.#1",
	"Darthn#DRUID#If you have over 450 days played, you should go outside... the sun doesn't hurt much contrary to what someone in game has told you!#1",

	"Rabbit##Turn off warnings and bars for encounter events that you do not care about. That way you won't be spammed, and you can concentrate more on what matters.#2",
	"Rabbit##Remember which sound goes with which message during an encounter. Then, next time, you won't even have to look at the messages.#2",
	"Rabbit##Move the bars around. At least get the non-emphasized ones out of the way - they are mostly useless.#2",
	"Rabbit##/bwcb 15m Raid break!#2",
	"Rabbit##/bwlcb 20m Oven warm, put in pizza!#2",
	"Rabbit##You can open the proximity monitor manually with /proximity <range>. Can be useful on new fights or if you use a special strategy for a encounter.#2",
	"Rabbit##If a raid officer is spamming you with tip windows, you can make them output to the chat frame or turn them off completely. Just visit the 'Customize ...' section under the Big Wigs interface options!#2",
	"Rabbit##Sometimes you'll want to remove a bar from the screen while in combat, so you can focus more on some other ability. You can configure the click-actions of bars in the Big Wigs interface options.#2",
	"Rabbit##Flash and Shake is a great way to really make you act fast on something. But not if it happens for 5 different abilities in a fight! Remember to adjust your Big Wigs per-boss settings.#2",
	"Rabbit##Boss mods are only useful if you take the time to adjust the per-boss settings to suit your needs. I really can't stress this enough. Right-click the Big Wigs LDB plugin while buffing up for a boss fight and look through the options.#2",
}

-------------------------------------------------------------------------------
-- Tip window
--

local showTip = nil
do
	local window, editbox, header, text, footer = nil, nil, nil, nil, nil
	local coolButton = nil
	local function getURL() return select(3, footer:GetText():find("cff9999ff(.*)|r")) end
	local function textChanged(self)
		self:SetText(getURL())
		self:HighlightText()
	end
	local function hideEditbox()
		if not editbox then return end
		editbox:Hide()
		footer:Show()
	end
	local function footerClicked(self)
		local url = getURL()
		if not url then return end
		if not editbox then
			editbox = CreateFrame("EditBox", nil, self, "InputBoxTemplate")
			editbox:SetPoint("BOTTOM", self)
			editbox:SetPoint("TOP", self)
			editbox:SetPoint("LEFT", window, "LEFT", 22, 0)
			editbox:SetPoint("RIGHT", window, "RIGHT", -18, 0)
			editbox:Hide()
			editbox:SetFontObject("GameFontHighlight")
			editbox:SetScript("OnEscapePressed", editbox.ClearFocus)
			editbox:SetScript("OnEnterPressed", editbox.ClearFocus)
			editbox:SetScript("OnEditFocusLost", hideEditbox)
			editbox:SetScript("OnEditFocusGained", editbox.HighlightText)
			editbox:SetScript("OnTextChanged", textChanged)
		end
		editbox:SetText(url)
		editbox:Show()
		footer:Hide()
	end
	local function closeWindow()
		hideEditbox()
		window:Hide()
	end

	local function createTipFrame()
		window = CreateFrame("Frame", nil, UIParent)
		window:SetWidth(260)
		window:SetHeight(220)
		window:SetPoint("CENTER")
		window:SetMovable(true)
		window:EnableMouse(true)
		window:SetClampedToScreen(true)
		window:RegisterForDrag("LeftButton")
		window:SetScript("OnDragStart", window.StartMoving)
		window:SetScript("OnDragStop", window.StopMovingOrSizing)

		local titlebg = window:CreateTexture(nil, "BACKGROUND")
		titlebg:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Title-Background")
		titlebg:SetPoint("TOPLEFT", 9, -6)
		titlebg:SetPoint("BOTTOMRIGHT", window, "TOPRIGHT", -28, -24)

		local dialogbg = window:CreateTexture(nil, "BACKGROUND")
		dialogbg:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
		dialogbg:SetPoint("TOPLEFT", 8, -24)
		dialogbg:SetPoint("BOTTOMRIGHT", -6, 8)
		dialogbg:SetVertexColor(0, 0, 0, .75)

		local topleft = window:CreateTexture(nil, "BORDER")
		topleft:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		topleft:SetWidth(64)
		topleft:SetHeight(64)
		topleft:SetPoint("TOPLEFT")
		topleft:SetTexCoord(0.501953125, 0.625, 0, 1)

		local topright = window:CreateTexture(nil, "BORDER")
		topright:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		topright:SetWidth(64)
		topright:SetHeight(64)
		topright:SetPoint("TOPRIGHT")
		topright:SetTexCoord(0.625, 0.75, 0, 1)

		local top = window:CreateTexture(nil, "BORDER")
		top:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		top:SetHeight(64)
		top:SetPoint("TOPLEFT", topleft, "TOPRIGHT")
		top:SetPoint("TOPRIGHT", topright, "TOPLEFT")
		top:SetTexCoord(0.25, 0.369140625, 0, 1)

		local bottomleft = window:CreateTexture(nil, "BORDER")
		bottomleft:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		bottomleft:SetWidth(64)
		bottomleft:SetHeight(64)
		bottomleft:SetPoint("BOTTOMLEFT")
		bottomleft:SetTexCoord(0.751953125, 0.875, 0, 1)

		local bottomright = window:CreateTexture(nil, "BORDER")
		bottomright:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		bottomright:SetWidth(64)
		bottomright:SetHeight(64)
		bottomright:SetPoint("BOTTOMRIGHT")
		bottomright:SetTexCoord(0.875, 1, 0, 1)

		local bottom = window:CreateTexture(nil, "BORDER")
		bottom:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		bottom:SetHeight(64)
		bottom:SetPoint("BOTTOMLEFT", bottomleft, "BOTTOMRIGHT")
		bottom:SetPoint("BOTTOMRIGHT", bottomright, "BOTTOMLEFT")
		bottom:SetTexCoord(0.376953125, 0.498046875, 0, 1)

		local left = window:CreateTexture(nil, "BORDER")
		left:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		left:SetWidth(64)
		left:SetPoint("TOPLEFT", topleft, "BOTTOMLEFT")
		left:SetPoint("BOTTOMLEFT", bottomleft, "TOPLEFT")
		left:SetTexCoord(0.001953125, 0.125, 0, 1)

		local right = window:CreateTexture(nil, "BORDER")
		right:SetTexture("Interface\\PaperDollInfoFrame\\UI-GearManager-Border")
		right:SetWidth(64)
		right:SetPoint("TOPRIGHT", topright, "BOTTOMRIGHT")
		right:SetPoint("BOTTOMRIGHT", bottomright, "TOPRIGHT")
		right:SetTexCoord(0.1171875, 0.2421875, 0, 1)

		local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", 2, 1)
		close:SetScript("OnClick", closeWindow)

		local title = window:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		title:SetAllPoints(titlebg)
		title:SetJustifyH("CENTER")
		title:SetText("Tip of the Raid")

		header = window:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		header:SetPoint("TOPLEFT", 16, -32)
		header:SetPoint("TOPRIGHT", -16, -32)
		header:SetJustifyH("LEFT")

		local nextButton = CreateFrame("Button", nil, window)
		nextButton:SetPoint("BOTTOMLEFT", 16, 16)
		nextButton:SetWidth(16)
		nextButton:SetHeight(16)
		nextButton:SetScript("OnClick", function() plugin:RandomTip() end)
		nextButton:SetNormalTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Up")
		nextButton:SetPushedTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Down")
		nextButton:SetHighlightTexture("Interface\\Buttons\\UI-GroupLoot-Dice-Highlight")

		coolButton = CreateFrame("Button", "BWTipCloseButton", window, "UIPanelButtonTemplate2")
		coolButton:SetPoint("BOTTOMLEFT", nextButton, "BOTTOMRIGHT", 4, 0)
		coolButton:SetPoint("RIGHT", window, "RIGHT", -16, 0)
		coolButton:SetHeight(22)
		coolButton:SetScript("OnClick", closeWindow)
		coolButton:SetText(L["Cool!"])

		footer = window:CreateFontString(nil, "ARTWORK", "GameFontDisable")
		footer:SetPoint("BOTTOMLEFT", nextButton, "TOPLEFT", 0, 10)
		footer:SetPoint("BOTTOMRIGHT", coolButton, "TOPRIGHT", 0, 6)
		footer:SetShadowColor(0, 0, 0, 0)
		footer:SetShadowOffset(1.5, -1.5)

		local button = CreateFrame("Button", nil, window)
		button:SetAllPoints(footer)
		button:SetScript("OnClick", footerClicked)
		button:SetScript("OnEnter", function() footer:SetShadowColor(0.2, 0.2, 1, 0.6) end)
		button:SetScript("OnLeave", function() footer:SetShadowColor(0, 0, 0, 0) end)

		text = window:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		text:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -4)
		text:SetPoint("BOTTOMRIGHT", footer, "TOPRIGHT", 0, 4)
		text:SetJustifyH("LEFT")
		text:SetJustifyV("TOP")
	end

	function showTip(h, t, f)
		if plugin.db.profile.chat then
			print(h)
			print(t)
			if f then print(f) end
		else
			if not window then createTipFrame() end
			header:SetText(h)
			text:SetText(t)
			if f then
				footer:SetText(f)
				footer:Show()
			else
				footer:Hide()
			end
			window:Show()
		end
	end
end

-- /script BigWigs:GetPlugin("Tip of the Raid"):RandomTip()

-------------------------------------------------------------------------------
-- Plugin init
--

local neverShowTip = nil
if select(2, IsInInstance()) == "raid" then
	local standalone = (select(1, ...)) == "BigWigs" and nil or true
	-- This doesn't work when we LoD, since the plugins aren't loaded until we zone in anyway.
	if not standalone then
		-- We logged in to a raid, let's never show the tip automatically this session.
		neverShowTip = true
	elseif standalone and (GetTime() - _G.BIGWIGS_LOADER_TIME) < 10 then
		-- Jesus christ this is hacky.
		-- So, if we are loaded now and it's less than 10 seconds since Loader.lua
		-- fired up, we won't show a tip this session.
		-- No idea if 10 seconds is enough either anyway.
		neverShowTip = true
	end
end

local function check()
	if not InCombatLockdown() and GetNumRaidMembers() > 9 and select(2, IsInInstance()) == "raid" then
		plugin:UnregisterEvent("PLAYER_REGEN_ENABLED")
		plugin:UnregisterEvent("RAID_ROSTER_UPDATE")
		plugin:UnregisterEvent("PLAYER_ENTERING_WORLD")
		if plugin.db.profile.show and plugin.db.profile.automatic then
			plugin:RandomTip()
		end
	end
end

function plugin:OnPluginEnable()
	if not neverShowTip then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", check)
		self:RegisterEvent("RAID_ROSTER_UPDATE", check)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", check)
	end
	self:RegisterEvent("CHAT_MSG_ADDON")
end

-------------------------------------------------------------------------------
-- Events
--

function plugin:CHAT_MSG_ADDON(event, prefix, message, distribution, sender)
	if prefix ~= "BWTIP" or not self.db.profile.manual then return end
	if not UnitIsRaidOfficer(sender) then return end
	self:ShowTip(message)
end

-------------------------------------------------------------------------------
-- API
--

do
	local headerFormat = L["|cff%s%s|r says:"]
	local DEVELOPER_COLOR = { -- XXX Find a better color, this one looks crap!
		r = 0.4,
		g = 0.7,
		b = 0.4,
	}
	function plugin:RandomTip(input)
		self:ShowTip(tips[input or math.random(1, #tips)])
	end

	function plugin:ShowTip(tipString)
		local player, class, text, footerInput = strsplit("#", tipString, 4)
		if not player or not text then return end
		local c = RAID_CLASS_COLORS[class] or DEVELOPER_COLOR
		local header = headerFormat:format(string.format("%02x%02x%02x", c.r * 255, c.g * 255, c.b * 255), player)
		local footer = nil
		if tonumber(footerInput) then
			footer = footers[tonumber(footerInput)]
		elseif type(footerInput) == "string" and footerInput:trim():len() > 0 then
			footer = footerInput
		end
		showTip(header, text, footer)
	end
end

-------------------------------------------------------------------------------
-- Slash command
--

SlashCmdList.BigWigs_TipOfTheRaid = function(input)
	if not plugin:IsEnabled() then BigWigs:Enable() end
	plugin:RandomTip()
end
SLASH_BigWigs_TipOfTheRaid1 = "/raidtip"
SLASH_BigWigs_TipOfTheRaid2 = "/tipoftheraid"

local pName = UnitName("player")
local _, pClass = UnitClass("player")
SlashCmdList.BigWigs_SendRaidTip = function(input)
	input = input:trim()
	if not UnitInRaid("player") or not IsRaidOfficer() or (not tonumber(input) and #input < 10) then
		print(L["Usage: /sendtip <index|\"Custom tip\">"])
		print(L["You must be an officer in the raid to broadcast a tip."])
		return
	end
	if not plugin:IsEnabled() then BigWigs:Enable() end
	if tonumber(input) then
		local index = tonumber(input)
		if tips[index] then
			SendAddonMessage("BWTIP", tips[index], "RAID")
		else
			print(L["Tip index out of bounds, accepted indexes range from 1 to %d."]:format(#tips))
		end
	else
		local guildName = IsInGuild() and (GetGuildInfo("player")) or ""
		local tip = pName .. "#" .. pClass .. "#" .. input .. "#" .. guildName
		SendAddonMessage("BWTIP", tip, "RAID")
	end
end
SLASH_BigWigs_SendRaidTip1 = "/sendtip"

