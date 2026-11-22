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

local MAX_WORDS = 100
local function IsValidWord(word)
	return type(word) == "string" and word == word:lower() and word ~= "" and word == word:trim()
end

local function HasMatchingWord(wordList, lowerMessage)
	for i = 1, #wordList do
		if wordList[i] == lowerMessage then
			return true
		end
	end
	return false
end

--------------------------------------------------------------------------------
-- Saved Settings
--

local db
do
	local globalDefaults = {
		wordsFriendly = {},
		wordsOther = {},
	}

	db = BigWigsLoader.db:RegisterNamespace("AutoInvite", {global = globalDefaults})

	local function ValidateWordList(tbl)
		if not next(tbl) then return end
		local seen = {}
		local valid = {}
		local dirty = false
		local count = 0
		local maxIndex = 0
		for entry, word in next, tbl do
			if type(entry) ~= "number" or entry < 1 or entry > MAX_WORDS or entry ~= math.floor(entry) or not IsValidWord(word) or seen[word] then
				dirty = true
			else
				seen[word] = true
				count = count + 1
				valid[count] = word
				if entry > maxIndex then
					maxIndex = entry
				end
			end
		end
		if dirty or maxIndex ~= count then
			table.sort(valid)
			return valid -- Return cleaned table
		end
		-- The table didn't need cleaned, but make sure its alphabetical
		table.sort(tbl)
	end

	for k, v in next, db.global do
		if not globalDefaults[k] then
			db.global[k] = nil
		elseif type(v) ~= "table" then
			db.global[k] = {}
		else
			local cleaned = ValidateWordList(v)
			if cleaned then
				db.global[k] = cleaned
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Widgets & Events
--

local popupFrame = BigWigsLoader.isModern and CreateFrame("Frame", nil, UIParent, "PortraitFrameTexturedBaseTemplate") or CreateFrame("Frame", nil, UIParent)
local ResetState
do
	local delayedInvite = {}
	local invitesBlocked = false
	local throttle = {}
	local activeTimer = nil
	local SendChatMessage = BigWigsLoader.SendChatMessage
	local SendBattleNetMessage = BigWigsLoader.SendBattleNetMessage
	local InviteUnit = C_PartyInfo.InviteUnit
	local InviteFriend = C_BattleNet.InviteFriend
	local IsGUIDInGroup = C_PartyInfo.IsGUIDInGroup
	local IsPartyFull = C_PartyInfo.IsPartyFull
	local AllowedToDoPartyConversion = C_PartyInfo.AllowedToDoPartyConversion -- XXX [Mainline:✓ MoP:✗ Wrath:✗ Vanilla:✗]
	local ConvertToRaid = C_PartyInfo.ConvertToRaid or ConvertToRaid -- XXX [Mainline:✓ MoP:✗ Wrath:✗ Vanilla:✗]
	local InChatMessagingLockdown = C_ChatInfo.InChatMessagingLockdown

	local function CancelActiveTimer()
		if activeTimer then
			activeTimer:Cancel()
			activeTimer = nil
		end
	end

	function ResetState()
		CancelActiveTimer()
		popupFrame:Hide()
		invitesBlocked = false
		throttle = {}
		delayedInvite = {}
	end

	local function WhisperPlayerThatMyGroupIsFull(playerName, bnSenderID)
		if bnSenderID then
			SendBattleNetMessage(bnSenderID, L.whisperToPlayerMyGroupIsFull)
		else
			SendChatMessage(L.whisperToPlayerMyGroupIsFull, "WHISPER", nil, playerName)
		end
	end

	local function InvitePlayer(guid, playerName, gameAccountID)
		delayedInvite[guid] = nil
		throttle[guid] = GetTime() + 2
		BigWigsLoader.Print(L.keywordDetectedInvitingPlayer:format(playerName))
		if gameAccountID then
			InviteFriend(gameAccountID)
		else
			InviteUnit(playerName)
		end
	end

	do
		local myClient = WOW_PROJECT_ID
		local myGUID = BigWigsLoader.UnitGUID("player")
		local issecretvalue = issecretvalue
		local IsGameAccountOnSameRealm = C_BattleNet.IsGameAccountOnSameRealm -- XXX [Standard:✗ Forever:✓ MoP:✗ Wrath:✗ TBC:✗ Vanilla:✗]

		local function IsSameRealm(gameAccountInfo)
			if IsGameAccountOnSameRealm then
				return IsGameAccountOnSameRealm(gameAccountInfo.gameAccountID)
			end
			return gameAccountInfo.realmID == GetRealmID()
		end

		local function QueueOrInvite(guid, playerName, bnSenderID, gameAccountID, suppressFullReply)
			if IsPartyFull(1) then -- LE_PARTY_CATEGORY_HOME = 1
				if IsInRaid(1) or (AllowedToDoPartyConversion and not AllowedToDoPartyConversion(true)) then
					throttle[guid] = GetTime() + 10
					if not suppressFullReply then
						WhisperPlayerThatMyGroupIsFull(playerName, bnSenderID)
					end
					return true
				elseif not invitesBlocked then
					if not next(delayedInvite) and not activeTimer then
						popupFrame:Show()
					end
					if bnSenderID then
						delayedInvite[guid] = { name = playerName, bnSenderID = bnSenderID, gameAccountID = gameAccountID }
					elseif not delayedInvite[guid] then
						delayedInvite[guid] = { name = playerName, gameAccountID = gameAccountID }
					end
					throttle[guid] = GetTime() + 2
				else
					throttle[guid] = GetTime() + 5
					if not suppressFullReply then
						WhisperPlayerThatMyGroupIsFull(playerName, bnSenderID)
					end
					return true
				end
			else
				InvitePlayer(guid, playerName, gameAccountID)
			end
			return false
		end

		popupFrame:SetScript("OnEvent", function(_, event, message, sender, _, _, _, flag, _, _, _, _, _, guid, bnSenderID)
			if event == "GROUP_LEFT" then
				if not IsInGroup(1) then -- LE_PARTY_CATEGORY_HOME = 1
					ResetState()
				end
			elseif event == "GROUP_ROSTER_UPDATE" then
				if not UnitIsGroupLeader("player", 1) or IsInRaid(1) or not IsPartyFull(1) then -- LE_PARTY_CATEGORY_HOME = 1
					popupFrame:Hide()
					delayedInvite = {}
				end
			else
				if issecretvalue(message) or (IsInGroup(1) and not UnitIsGroupLeader("player", 1) and not UnitIsGroupAssistant("player", 1)) then
					return -- Message is secret or we don't have invite permission
				elseif event == "CHAT_MSG_WHISPER" then
					if flag == "GM" or flag == "DEV" or not guid or guid == myGUID or IsGUIDInGroup(guid, 1) then
						return -- Player is GM/DEV, missing GUID, self, or already in our group
					elseif not throttle[guid] or GetTime() > throttle[guid] then
						local lowerMessage = message:lower()
						local bnetInfo = C_BattleNet.GetGameAccountInfoByGUID(guid)
						local isMatched
						if bnetInfo or IsGuildMember(guid) or C_FriendList.IsFriend(guid) then
							isMatched = HasMatchingWord(db.global.wordsFriendly, lowerMessage)
						else
							isMatched = HasMatchingWord(db.global.wordsOther, lowerMessage)
						end
						if isMatched then
							QueueOrInvite(guid, sender, nil, bnetInfo and bnetInfo.gameAccountID)
						end
					end
				elseif event == "CHAT_MSG_BN_WHISPER" and not BNIsSelf(bnSenderID) then
					local lowerMessage = message:lower()
					if not HasMatchingWord(db.global.wordsFriendly, lowerMessage) then
						return
					end
					local index = BNGetFriendIndex(bnSenderID)
					if not index then
						return
					end
					local gameAccs = C_BattleNet.GetFriendNumGameAccounts(index)
					local repliedFull = false
					for i = 1, gameAccs do
						local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(index, i)
						if gameAccountInfo and gameAccountInfo.clientProgram == "WoW" and gameAccountInfo.wowProjectID == myClient and gameAccountInfo.isInCurrentRegion then
							local hasRealmInfo = gameAccountInfo.hasRealmInfo
							if hasRealmInfo == nil then
								hasRealmInfo = gameAccountInfo.realmID and gameAccountInfo.realmID > 0
							end
							local playerGuid = gameAccountInfo.playerGuid
							local gameAccountID = gameAccountInfo.gameAccountID
							if hasRealmInfo and playerGuid and gameAccountID
							and (BigWigsLoader.isRetail or (IsSameRealm(gameAccountInfo) and gameAccountInfo.factionName == UnitFactionGroup("player"))) -- Classic & Forever are more restrictive than retail
							and (not throttle[playerGuid] or GetTime() > throttle[playerGuid])
							and not IsGUIDInGroup(playerGuid, 1) then -- Player is not already in our group
								local player = gameAccountInfo.characterName
								if player and player ~= "" then
									local realmName = gameAccountInfo.realmName -- Short name "ServerOne"
									local realmDisplayName = gameAccountInfo.realmDisplayName -- Full name "Server One"
									if realmName and realmName ~= "" and realmDisplayName and realmDisplayName ~= "" and realmDisplayName ~= GetRealmName() then
										player = player .. "-" .. realmName
									end
									if QueueOrInvite(playerGuid, player, bnSenderID, gameAccountID, repliedFull) then
										repliedFull = true
									end
								end
							end
						end
					end
				end
			end
		end)
	end

	popupFrame:SetFrameStrata("DIALOG")
	popupFrame:SetFixedFrameStrata(true)
	popupFrame:SetFrameLevel(305)
	popupFrame:SetFixedFrameLevel(true)
	popupFrame:SetSize(400, BigWigsLoader.isModern and 130 or 110)
	popupFrame:SetPoint("CENTER")
	popupFrame:EnableMouse(true)

	local text = popupFrame:CreateFontString(nil, nil, "GameFontGreenLarge")
	text:SetSize(380, 0)
	text:SetJustifyH("CENTER")
	text:SetJustifyV("TOP")
	text:SetNonSpaceWrap(true)
	text:SetText(L.groupIsFullConvertToRaid)

	if BigWigsLoader.isModern then
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

	local function InviteNext()
		if not IsInRaid(1) or (not UnitIsGroupLeader("player", 1) and not UnitIsGroupAssistant("player", 1)) or IsPartyFull(1) then
			CancelActiveTimer()
			delayedInvite = {}
			return false
		end
		local guid, info = next(delayedInvite)
		while guid and IsGUIDInGroup(guid, 1) do
			delayedInvite[guid] = nil
			guid, info = next(delayedInvite)
		end
		if not guid then
			CancelActiveTimer()
			delayedInvite = {}
			return false
		end

		InvitePlayer(guid, info.name, info.gameAccountID)
		if not next(delayedInvite) then
			CancelActiveTimer()
			delayedInvite = {}
			return false
		end
		return true
	end

	local function StartInviting()
		activeTimer = nil
		if InviteNext() then
			activeTimer = BigWigsLoader.CTimerNewTicker(0.2, InviteNext) -- Throttle
		end
	end

	local buttonYes = CreateFrame("Button", nil, popupFrame, BigWigsLoader.isModern and "SharedButtonTemplate" or "UIPanelButtonTemplate")
	buttonYes:SetSize(128, 32)
	buttonYes:SetPoint("RIGHT", popupFrame, "BOTTOM", -6, 28)
	buttonYes:SetScript("OnClick", function(self)
		self:GetParent():Hide()
		invitesBlocked = false
		CancelActiveTimer()
		if not IsInRaid(1) then
			if not UnitIsGroupLeader("player", 1) or (AllowedToDoPartyConversion and not AllowedToDoPartyConversion(true)) then
				delayedInvite = {}
				return
			end
			ConvertToRaid()
			activeTimer = BigWigsLoader.CTimerNewTimer(1.5, StartInviting) -- Hopefully long enough for the game to recognize you are now in a raid, before trying to invite others
		else
			StartInviting()
		end
	end)
	buttonYes:SetText(L.yes)
	local buttonNo = CreateFrame("Button", nil, popupFrame, BigWigsLoader.isModern and "SharedButtonTemplate" or "UIPanelButtonTemplate")
	buttonNo:SetSize(128, 32)
	buttonNo:SetPoint("LEFT", buttonYes, "RIGHT", 12, 0)
	buttonNo:SetScript("OnClick", function(self)
		self:GetParent():Hide()
		invitesBlocked = true
		CancelActiveTimer()
		local toNotify = delayedInvite
		delayedInvite = {}
		local function NotifyNext()
			if InChatMessagingLockdown() then
				CancelActiveTimer()
				return false
			end
			local guid, info = next(toNotify)
			if not guid then
				CancelActiveTimer()
				return false
			end
			toNotify[guid] = nil
			local now = GetTime()
			throttle[guid] = now + 5
			if info.bnSenderID then
				for nextGuid, nextInfo in next, toNotify do
					if nextInfo.bnSenderID == info.bnSenderID then
						toNotify[nextGuid] = nil
						throttle[nextGuid] = now + 5
					end
				end
			end
			WhisperPlayerThatMyGroupIsFull(info.name, info.bnSenderID)
			if not next(toNotify) then
				CancelActiveTimer()
				return false
			end
			return true
		end
		if NotifyNext() then
			activeTimer = BigWigsLoader.CTimerNewTicker(0.5, NotifyNext) -- Throttle
		end
	end)
	buttonNo:SetText(L.no)

	popupFrame:Hide()
	popupFrame:SetScript("OnShow", function(self)
		self:RegisterEvent("GROUP_ROSTER_UPDATE")
	end)
	popupFrame:SetScript("OnHide", function(self)
		self:UnregisterEvent("GROUP_ROSTER_UPDATE")
	end)
end

--------------------------------------------------------------------------------
-- Options Table
--

local function RegisterEvents()
	local hasFriendly = next(db.global.wordsFriendly)
	local hasOther = next(db.global.wordsOther)
	if hasFriendly or hasOther then
		popupFrame:RegisterEvent("CHAT_MSG_WHISPER")
		popupFrame:RegisterEvent("GROUP_LEFT")
		if hasFriendly then
			popupFrame:RegisterEvent("CHAT_MSG_BN_WHISPER")
		else
			popupFrame:UnregisterEvent("CHAT_MSG_BN_WHISPER")
		end
	else
		popupFrame:UnregisterEvent("CHAT_MSG_WHISPER")
		popupFrame:UnregisterEvent("CHAT_MSG_BN_WHISPER")
		popupFrame:UnregisterEvent("GROUP_LEFT")
		ResetState()
	end
end
RegisterEvents()

local function CreateWordListConfig(key)
	return {
		input = {
			type = "input",
			get = function() return "" end,
			set = function(_, text)
				table.insert(db.global[key], text)
				table.sort(db.global[key])
				RegisterEvents()
			end,
			name = L.addWords,
			order = 1,
			width = "full",
			usage = L.invalidWordWarning,
			disabled = function() return #db.global[key] >= MAX_WORDS end,
			validate = function(_, text)
				local words = db.global[key]
				return #words < MAX_WORDS and IsValidWord(text) and not HasMatchingWord(words, text)
			end,
		},
		remove = {
			type = "select",
			name = L.removeWords,
			order = 2,
			values = function() return db.global[key] end,
			set = function(_, value)
				table.remove(db.global[key], value)
				RegisterEvents()
			end,
			width = "full",
			disabled = function() return not next(db.global[key]) end,
		},
	}
end

BigWigsAPI.RegisterToolOptions("AutoInvite", function() return {
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
			args = CreateWordListConfig("wordsFriendly"),
		},
		other = {
			name = L.everyoneElse,
			type = "group",
			order = 2,
			args = CreateWordListConfig("wordsOther"),
		},
	},
} end)
