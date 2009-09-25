----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewPlugin("Broadcast")
if not plugin then return end

------------------------------
--      Are you local?      --
------------------------------

local output = "*** %s ***"
local L = LibStub("AceLocale-3.0"):GetLocale("Big Wigs: Plugins")

------------------------------
--      Initialization      --
------------------------------

function plugin:OnPluginEnable()
	self:RegisterMessage("BigWigs_Message")
end

function plugin:BigWigs_Message(msg, color, noraidsay)
	if not msg or noraidsay or not BigWigs.db.profile.broadcast then return end

	local inRaid = UnitInRaid("player")
	-- In a 5-man group, everyone can use the raid warning channel.
	if inRaid and not IsRaidLeader() then
		return
	elseif GetNumPartyMembers() == 0 and not inRaid then
		return
	end

	local clean = msg:gsub("(|c%x%x%x%x%x%x%x%x)", ""):gsub("(|r)", "")
	local o = output:format(clean)
	if BigWigs.db.profile.useraidchannel then
		SendChatMessage(o, inRaid and "RAID" or "PARTY")
	else
		SendChatMessage(o, "RAID_WARNING")
	end
end

