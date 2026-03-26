local L, BigWigsLoader, BigWigsAPI
do
	local _, tbl = ...
	BigWigsAPI = tbl.API
	L = BigWigsAPI:GetLocale("BigWigs")
	BigWigsLoader = tbl.loaderPublic
end

--------------------------------------------------------------------------------
-- Locals
--

local ProfileUtils = {}

--------------------------------------------------------------------------------
-- Saved Settings
--

local db
do
	local globalDefaults = {
		wordsFriendly = {},
		wordsOther = {},
	}

	db = BigWigsLoader.db:RegisterNamespace("AutoInvite", {profile = {}, global = globalDefaults}) -- XXX temp 12.0.1

	ProfileUtils.ValidateMainSettings = function()
		db.profile.wordsFriendly = nil -- XXX temp 12.0.1
		db.profile.wordsOther = nil -- XXX temp 12.0.1

		for k, v in next, db do
			local defaultType = type(globalDefaults[k])
			if defaultType == "nil" then
				db.global[k] = nil
			elseif type(v) ~= defaultType then
				db.global[k] = globalDefaults[k]
			end

			for entry, word in next, db.global.wordsFriendly do
				if type(entry) ~= "number" or type(word) ~= "string" or word ~= word:lower() or word == "" or word:find("^ +$") then
					db.global.wordsFriendly = {}
					break
				end
			end
			for entry, word in next, db.global.wordsOther do
				if type(entry) ~= "number" or type(word) ~= "string" or word ~= word:lower() or word == "" or word:find("^ +$") then
					db.global.wordsOther = {}
					break
				end
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Widgets & Events
--

local popupFrame = BigWigsLoader.isRetail and CreateFrame("Frame", nil, UIParent, "PortraitFrameTexturedBaseTemplate") or CreateFrame("Frame")
do
	local throttle = {}
	local delayedInvite = {}
	local invitesBlocked = false
	local SendChatMessage = BigWigsLoader.SendChatMessage
	local Ambiguate = BigWigsLoader.Ambiguate
	local myClient = WOW_PROJECT_ID
	local issecretvalue = issecretvalue or function() end -- XXX 12.0 compat
	popupFrame:SetScript("OnEvent", function(self, event, message, sender, _, _, _, flag, _, _, _, _, _, guid, bnSenderID)
		if event == "GROUP_LEFT" then
			if not IsInGroup() then
				invitesBlocked = false
				throttle = {}
				delayedInvite = {}
			end
		else
			if issecretvalue(message) or (IsInGroup() and not UnitIsGroupLeader("player") and not UnitIsGroupAssistant("player")) then -- C_PartyInfo.CanInvite is an alternative, but XXX [Mainline:✓ MoP:✗ Wrath:✗ Vanilla:✗]
				return -- Message is secret or we don't have invite permission
			elseif event == "CHAT_MSG_WHISPER" then
				local trimmedPlayer = Ambiguate(sender, "none")
				if flag == "GM" or flag == "DEV" or UnitInRaid(trimmedPlayer) or UnitInParty(trimmedPlayer) or guid == BigWigsLoader.UnitGUID("player") then
					return -- Player is GM/DEV or already in our group, return
				elseif not throttle[sender] or (GetTime() - throttle[sender]) > 1 then
					throttle[sender] = GetTime()
					message = message:lower()
					local dbToUse
					if C_BattleNet.GetGameAccountInfoByGUID(guid) or IsGuildMember(guid) or C_FriendList.IsFriend(guid) then
						dbToUse = db.global.wordsFriendly
					else
						dbToUse = db.global.wordsOther
					end
					for i = 1, #dbToUse do
						if dbToUse[i] == message then
							if IsInRaid() then
								if C_PartyInfo.IsPartyFull() then
									throttle[sender] = throttle[sender] + 10
									SendChatMessage(L.whisperToPlayerMyGroupIsFull, "WHISPER", nil, sender)
								else
									BigWigsLoader.Print(L.keywordDetectedInvitingPlayer:format(sender))
									C_PartyInfo.InviteUnit(sender)
								end
							else
								if C_PartyInfo.IsPartyFull() then
									if not invitesBlocked then
										if not next(delayedInvite) then
											popupFrame:Show()
										end
										delayedInvite[sender] = true
									else
										throttle[sender] = throttle[sender] + 10
										SendChatMessage(L.whisperToPlayerMyGroupIsFull, "WHISPER", nil, sender)
									end
								else
									BigWigsLoader.Print(L.keywordDetectedInvitingPlayer:format(sender))
									C_PartyInfo.InviteUnit(sender)
								end
							end
						end
					end
				end
			elseif event == "CHAT_MSG_BN_WHISPER" and not BNIsSelf(bnSenderID) then
				if not throttle[bnSenderID] or (GetTime() - throttle[bnSenderID]) > 1 then
					throttle[bnSenderID] = GetTime()
					local index = BNGetFriendIndex(bnSenderID)
					local gameAccs = C_BattleNet.GetFriendNumGameAccounts(index)
					for i=1, gameAccs do
						local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(index, i)
						if gameAccountInfo.clientProgram == "WoW" and gameAccountInfo.wowProjectID == myClient and gameAccountInfo.isInCurrentRegion and gameAccountInfo.realmID > 0
						and (BigWigsLoader.isRetail or (gameAccountInfo.realmID == GetRealmID() and gameAccountInfo.factionName == UnitFactionGroup("player"))) then -- Classic is more restrictive than retail
							local player = gameAccountInfo.characterName
							local realmName = gameAccountInfo.realmName -- Short name "ServerOne"
							local realmDisplayName = gameAccountInfo.realmDisplayName -- Full name "Server One"
							if realmName and realmDisplayName and player then
								if realmDisplayName ~= GetRealmName() then
									sender = player .. "-" .. realmName
								end
								if not UnitInRaid(sender) and not UnitInParty(sender) then -- Player is not already in our group
									message = message:lower()
									for num = 1, #db.global.wordsFriendly do
										if db.global.wordsFriendly[num] == message then
											if IsInRaid() then
												if C_PartyInfo.IsPartyFull() then
													throttle[bnSenderID] = throttle[bnSenderID] + 10
													BNSendWhisper(bnSenderID, L.whisperToPlayerMyGroupIsFull)
												else
													BigWigsLoader.Print(L.keywordDetectedInvitingPlayer:format(sender))
													C_PartyInfo.InviteUnit(sender)
												end
											else
												if C_PartyInfo.IsPartyFull() then
													if not invitesBlocked then
														if not next(delayedInvite) then
															popupFrame:Show()
														end
														delayedInvite[sender] = bnSenderID
													else
														throttle[bnSenderID] = throttle[bnSenderID] + 10
														BNSendWhisper(bnSenderID, L.whisperToPlayerMyGroupIsFull)
													end
												else
													BigWigsLoader.Print(L.keywordDetectedInvitingPlayer:format(sender))
													C_PartyInfo.InviteUnit(sender)
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end)

	popupFrame:SetFrameStrata("DIALOG")
	popupFrame:SetFixedFrameStrata(true)
	popupFrame:SetFrameLevel(305)
	popupFrame:SetFixedFrameLevel(true)
	popupFrame:SetSize(400, 110)
	popupFrame:SetPoint("CENTER")

	local text = popupFrame:CreateFontString(nil, nil, "GameFontGreenLarge")
	text:SetSize(380, 0)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("TOP")
	text:SetNonSpaceWrap(true)
	text:SetText(L.groupIsFullConvertToRaid)

	if BigWigsLoader.isRetail then
		popupFrame:SetTitle("BigWigs")
		popupFrame:SetTitleOffsets(0, 0)
		popupFrame:SetBorder("HeldBagLayout")
		popupFrame:SetPortraitTextureSizeAndOffset(38, -5, 0)
		popupFrame:SetPortraitTextureRaw("Interface\\AddOns\\BigWigs\\Media\\Icons\\minimap_raid.tga")

		text:SetPoint("TOP", 0, -40)
	else
		local border = CreateFrame("Frame", nil, popupFrame, "DialogBorderOpaqueTemplate")
		border:SetAllPoints(popupFrame)

		text:SetPoint("TOP", 0, -16)
	end

	local buttonYes = CreateFrame("Button", nil, popupFrame, BigWigsLoader.isRetail and "SharedButtonTemplate" or "UIPanelButtonTemplate")
	buttonYes:SetSize(128, 32)
	buttonYes:SetPoint("RIGHT", popupFrame, "BOTTOM", -6, 28)
	buttonYes:SetScript("OnClick", function(self)
		self:GetParent():Hide()
		invitesBlocked = false
		if C_PartyInfo.ConvertToRaid then
			C_PartyInfo.ConvertToRaid() -- XXX [Mainline:✓ MoP:✗ Wrath:✗ Vanilla:✗]
		else
			ConvertToRaid()
		end
		BigWigsLoader.CTimerAfter(1.5, function() -- Hopefully long enough for the game to recognize you are now in a raid, before trying to invite others
			local timer = nil
			timer = BigWigsLoader.CTimerNewTicker(0.2, function() -- Throttle
				local playerName = next(delayedInvite)
				if not playerName then
					timer:Cancel()
					timer = nil
					delayedInvite = {}
					return
				end

				delayedInvite[playerName] = nil
				BigWigsLoader.Print(L.keywordDetectedInvitingPlayer:format(playerName))
				C_PartyInfo.InviteUnit(playerName)
			end)
		end)
	end)
	buttonYes:SetText(L.yes)
	local buttonNo = CreateFrame("Button", nil, popupFrame, BigWigsLoader.isRetail and "SharedButtonTemplate" or "UIPanelButtonTemplate")
	buttonNo:SetSize(128, 32)
	buttonNo:SetPoint("LEFT", buttonYes, "RIGHT", 12, 0)
	local InChatMessagingLockdown = C_ChatInfo.InChatMessagingLockdown or function() end -- XXX 12.0 compat
	buttonNo:SetScript("OnClick", function(self)
		self:GetParent():Hide()
		invitesBlocked = true
		local timer = nil
		timer = BigWigsLoader.CTimerNewTicker(0.5, function() -- Throttle
			local playerName, isBnet = next(delayedInvite)
			if not playerName or InChatMessagingLockdown() then
				timer:Cancel()
				timer = nil
				delayedInvite = {}
				return
			end

			if type(isBnet) == "number" then
				BNSendWhisper(isBnet, L.whisperToPlayerMyGroupIsFull)
			else
				SendChatMessage(L.whisperToPlayerMyGroupIsFull, "WHISPER", nil, playerName)
			end
		end)
	end)
	buttonNo:SetText(L.no)

	popupFrame:Hide()
end

--------------------------------------------------------------------------------
-- Options Table
--

local function UpdateWidgets()
	if next(db.global.wordsFriendly) or next(db.global.wordsOther) then
		popupFrame:RegisterEvent("CHAT_MSG_WHISPER")
		popupFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")
		popupFrame:RegisterEvent("GROUP_LEFT")
	else
		popupFrame:UnregisterEvent("CHAT_MSG_WHISPER")
		popupFrame:UnregisterEvent("CHAT_MSG_BN_WHISPER")
		popupFrame:UnregisterEvent("GROUP_LEFT")
	end
end

BigWigsAPI.RegisterToolOptions("AutoInvite", {
	type = "group",
	childGroups = "tab",
	order = 5,
	name = L.autoInviteTitle,
	args = {
		explainer = {
			type = "description",
			name = L.autoInviteDesc,
			order = 0,
			width = "full",
			fontSize = "large",
		},
		friendly = {
			name = L.guildAndFriends,
			type = "group",
			order = 1,
			args = {
				input = {
					type = "input",
					get = function() return "" end,
					set = function(_, text)
						table.insert(db.global.wordsFriendly, text)
						table.sort(db.global.wordsFriendly)
						UpdateWidgets()
					end,
					name = L.addWords,
					order = 1,
					width = "full",
					usage = L.invalidWordWarning,
					validate = function(_, text)
						local lowerCaseText = text:lower()
						if lowerCaseText ~= text or lowerCaseText == "" or lowerCaseText:find("^ +$") then
							return false
						end
						for i = 1, #db.global.wordsFriendly do
							if db.global.wordsFriendly[i] == text then
								return false
							end
						end
						return true
					end,
				},
				remove = {
					type = "select",
					name = L.removeWords,
					order = 2,
					values = function() return db.global.wordsFriendly end,
					set = function(_, value)
						table.remove(db.global.wordsFriendly, value)
						UpdateWidgets()
					end,
					width = "full",
					disabled = function() return not next(db.global.wordsFriendly) end,
				},
			},
		},
		other = {
			name = L.everyoneElse,
			type = "group",
			order = 2,
			args = {
				input = {
					type = "input",
					get = function() return "" end,
					set = function(_, text)
						table.insert(db.global.wordsOther, text)
						table.sort(db.global.wordsOther)
						UpdateWidgets()
					end,
					name = L.addWords,
					order = 1,
					width = "full",
					usage = L.invalidWordWarning,
					validate = function(_, text)
						local lowerCaseText = text:lower()
						if lowerCaseText ~= text or lowerCaseText == "" or lowerCaseText:find("^ +$") then
							return false
						end
						for i = 1, #db.global.wordsOther do
							if db.global.wordsOther[i] == text then
								return false
							end
						end
						return true
					end,
				},
				remove = {
					type = "select",
					name = L.removeWords,
					order = 2,
					values = function() return db.global.wordsOther end,
					set = function(_, value)
						table.remove(db.global.wordsOther, value)
						UpdateWidgets()
					end,
					width = "full",
					disabled = function() return not next(db.global.wordsOther) end,
				},
			},
		},
	},
})

--------------------------------------------------------------------------------
-- Login
--

do
	local function UpdateProfile()
		ProfileUtils.ValidateMainSettings()
		UpdateWidgets()
	end
	local loginFrame = CreateFrame("Frame")
	loginFrame:SetScript("OnEvent", function(self, event)
		self:UnregisterEvent(event)
		self:SetScript("OnEvent", nil)
		UpdateProfile()
		BigWigsLoader.RegisterMessage(loginFrame, "BigWigs_ProfileUpdate", UpdateProfile)
	end)
	loginFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
end
