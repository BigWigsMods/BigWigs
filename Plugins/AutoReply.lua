-------------------------------------------------------------------------------
-- Module Declaration
--

local plugin = BigWigs:NewPlugin("AutoReply")
if not plugin then return end

-------------------------------------------------------------------------------
-- Database
--

plugin.defaultDB = {
	disabled = true,
	mode = 2,
}

--------------------------------------------------------------------------------
-- Locals
--

local SendChatMessage, GetTime = BigWigsLoader.SendChatMessage, GetTime
local L = BigWigsAPI:GetLocale("BigWigs: Plugins")
plugin.displayName = L.autoReply
local curDiff = 0
local curModule = nil
local throttle = {}

-------------------------------------------------------------------------------
-- Options
--

plugin.pluginOptions = {
	name = L.autoReply,
	desc = L.autoReplyDesc,
	type = "group",
	get = function(info)
		return plugin.db.profile[info[#info]]
	end,
	set = function(info, value)
		local entry = info[#info]
		plugin.db.profile[entry] = value
	end,
	args = {
		heading = {
			type = "description",
			name = L.autoReplyDesc.. "\n\n",
			order = 0,
			width = "full",
			fontSize = "medium",
		},
		disabled = {
			type = "toggle",
			name = L.disabled,
			width = "full",
			order = 1,
		},
		mode = {
			type = "select",
			name = "Reponse Type",
			order = 2,
			values = {
				L.autoReplyBasic,
				L.autoReplyNormal:format(EJ_GetEncounterInfo(464)), -- Hogger
				L.autoReplyAdvanced:format(EJ_GetEncounterInfo(464), GetDifficultyInfo(2), 12, 20),
				L.autoReplyExtreme:format(EJ_GetEncounterInfo(464), GetDifficultyInfo(2), 12, 20, L.healthFormat:format(EJ_GetEncounterInfo(464), 42)),
			},
			width = "full",
			style = "radio",
		},
	},
}

--------------------------------------------------------------------------------
-- Initialization
--

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_OnBossEngage")
	self:RegisterMessage("BigWigs_OnBossWin")
	self:RegisterMessage("BigWigs_OnBossWipe", "BigWigs_OnBossWin")
end

-------------------------------------------------------------------------------
-- Event Handlers
--

function plugin:BigWigs_OnBossEngage(event, module, difficulty)
	if not self.db.profile.disabled and module and module.journalId then
		curDiff = difficulty
		curModule = module
		throttle = {}
		self:RegisterEvent("CHAT_MSG_WHISPER")
	end
end

function plugin:BigWigs_OnBossWin(event, module)
	if not self.db.profile.disabled and module and module.journalId then
		curDiff = 0
		curModule = nil
		self:UnregisterEvent("CHAT_MSG_WHISPER")
	end
end

do
	local units = {"boss1", "boss2", "boss3", "boss4", "boss5"}
	function plugin:CHAT_MSG_WHISPER(event, msg, sender)
		if curDiff > 0 then
			if not throttle[sender] or GetTime() - throttle[sender] > 10 then
				throttle[sender] = GetTime()
				local mode = self.db.profile.mode
				local msg
				if mode == 2 then
					msg = L.autoReplyNormal:format(curModule.displayName) -- In combat with encounterName
				elseif mode == 3 then
					local _, _, _, instanceId = UnitPosition("player")
					local playersTotal, playersAlive = 0, 0
					for unit in curModule:IterateGroup() do
						local _, _, _, tarInstanceId = UnitPosition(unit)
						if tarInstanceId == instanceId then
							playersTotal = playersTotal + 1
							if not UnitIsDeadOrGhost(unit) then
								playersAlive = playersAlive + 1
							end
						end
					end
					-- In combat with encounterName, difficulty, playersAlive
					msg = L.autoReplyAdvanced:format(curModule.displayName, GetDifficultyInfo(curDiff), playersAlive, playersTotal)
				elseif mode == 4 then
					local _, _, _, instanceId = UnitPosition("player")
					local playersTotal, playersAlive = 0, 0
					for unit in curModule:IterateGroup() do
						local _, _, _, tarInstanceId = UnitPosition(unit)
						if tarInstanceId == instanceId then
							playersTotal = playersTotal + 1
							if not UnitIsDeadOrGhost(unit) then
								playersAlive = playersAlive + 1
							end
						end
					end
					local totalHp = ""
					for i = 1, 5 do
						local unit = units[i]
						local hp = UnitHealth(unit)
						local name = UnitName(unit)
						if hp > 0 then
							hp = hp / UnitHealthMax(unit)
							if totalHp == "" then
								totalHp = L.healthFormat:format(name, hp*100)
							else
								totalHp = totalHp .. ", " .. L.healthFormat:format(name, hp*100)
							end
						end
					end
					-- In combat with encounterName, difficulty, playersAlive, bossHealth
					msg = L.autoReplyExtreme:format(curModule.displayName, GetDifficultyInfo(curDiff), playersAlive, playersTotal, totalHp)
				else
					msg = L.autoReplyBasic -- In combat
				end
				SendChatMessage("[BigWigs] ".. msg, "WHISPER", nil, sender)
			end
		end
	end
end
