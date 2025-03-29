std = "lua51"
max_line_length = false
codes = true
exclude_files = {
	"**/Libs",
}
files["**/Init_Vanilla.lua"].ignore = {
	"113/C_Seasons",
}
files["**/Locales/frFR_common.lua"].ignore = {
	"113/UnitSex",
}
files["**/Loader.lua"].ignore = {
	"113/date",
	"113/geterrorhandler",

	"113/Ambiguate",
	"113/BasicMessageDialog",
	"113/C_AddOns",
	"113/C_ChatInfo",
	"113/C_CVar",
	"113/C_EventUtils",
	"113/C_Item",
	"113/C_Map",
	"11[23]/C_PartyInfo",
	"113/C_Spell",
	"113/C_UnitAuras",
	"113/GetBuildInfo",
	"113/GetCurrentRegion",
	"113/GetNumGroupMembers",
	"113/GetRealmID",
	"113/IsPublicTestClient",
	"113/PlaySoundFile",
	"113/securecallfunction",
	"113/SendChatMessage",
	"113/SetRaidTarget",
	"113/TimerTracker",
	"113/UnitDetailedThreatSituation",
	"113/UnitInPartyIsAI",
	"113/UnitThreatSituation",
	"113/UnitGUID",
	"113/UnitIsDeadOrGhost",
	"113/UnitNameUnmodified",
	"113/UnitSex",
	"113/UnitTokenFromGUID",

	-- Slash handling
	"111/SLASH_BigWigs1",
	"111/SLASH_BigWigs2",
	"111/SLASH_BigWigsVersion1",
	"11[23]/SlashCmdList",
	"11[23]/hash_SlashCmdList",
}
files["**/AutoRole.lua"].ignore = {
	"113/RolePollPopup",
	"113/UnitGroupRolesAssigned",
	"113/UnitNameUnmodified",
	"113/UnitSetRole",
}
files["**/Core/BossPrototype.lua"].ignore = {
	"113/C_Item",
	"113/C_NamePlate",
	"113/C_UIWidgetManager",
	"113/C_UnitAuras",
	"113/GetNumGroupMembers",
	"113/GetRaidTargetIndex",
	"113/TranscriptIgnore",
	"113/Transcriptor",
	"113/UnitIsInteractable",
	"113/UnitGroupRolesAssigned",
}
files["**/Core/BossPrototype_Classic.lua"].ignore = {
	"113/C_Item",
	"113/C_NamePlate",
	"113/C_UIWidgetManager",
	"113/C_UnitAuras",
	"113/GetNumGroupMembers",
	"113/GetRaidTargetIndex",
	"113/GetTalentInfo",
	"113/GetTalentTabInfo",
	"113/TranscriptIgnore",
	"113/Transcriptor",
	"113/UnitIsInteractable",
	"113/UnitGroupRolesAssigned",
}
files["**/Core/Core.lua"].ignore = {
	"111/BigWigs",
	"113/C_EventUtils",
	"113/geterrorhandler",
	"113/UnitIsCorpse",
}
files["**/Core/PluginPrototype.lua"].ignore = {
	"113/GetNumGroupMembers",
}
files["**/Plugins/AltPower.lua"].ignore = {
	"113/GetNumGroupMembers",
	"113/UnitGroupRolesAssigned",
}
files["**/Plugins/AutoReply.lua"].ignore = {
	"113/BNGetFriendIndex",
	"113/BNIsSelf",
	"113/BNSendWhisper",
	"113/C_BattleNet",
	"113/C_FriendList",
}
files["**/Plugins/Nameplates.lua"].ignore = {
	"113/C_NamePlate",
}
files["**/Plugins/BossBlock.lua"].ignore = {
	"113/AlertFrame",
	"112/BigWigs",
	"113/C_ContentTracking",
	"113/C_CVar",
	"113/C_EventToastManager",
	"113/C_Item",
	"113/C_TalkingHead",
	"113/GetDetailedItemLevelInfo",
	"113/GetFramesRegisteredForEvent",
	"113/GetTrackedAchievements",
	"113/Questie_BaseFrame",
	"113/QuestWatchFrame",
	"113/RaidBossEmoteFrame_OnEvent",
	"113/TooltipDataProcessor",
	"113/UIErrorsFrame",
	"113/WatchFrame",
	"113/ZoneTextFrame",
}
files["**/Plugins/Countdown.lua"].ignore = {
	"113/GetCurrentRegion",
}
files["**/Plugins/Proximity.lua"].ignore = {
	"113/GetNumGroupMembers",
	"113/GetRaidTargetIndex",
	"113/GetServerExpansionLevel", -- Classic support
	"113/UnitInPhase", -- Classic support
}
files["**/Plugins/Pull.lua"].ignore = {
	"113/C_EventUtils",
	"113/GetPlayerInfoByGUID",
	"113/UnitGroupRolesAssigned",
}
files["**/Plugins/RaidIcon.lua"].ignore = {
	"113/GetRaidTargetIndex",
}
files["**/Plugins/Victory.lua"].ignore = {
	"113/BossBanner",
}
files["**/Plugins/*.lua"].ignore = {
	"112/SlashCmdList",
	"111/SLASH_.*", -- slash handlers
}
files["**/Options/Options.lua"].ignore = {
	"113/C_UI",
}
files["**/Locales/*.lua"].ignore = {
	"542", -- Empty if branch
}
files["gen_option_values.lua"].ignore = {
	"113/arg", -- We use global arg in the parser
}
ignore = {
	"113/BigWigs",
	"212/self",
	"1/[A-Z][A-Z][A-Z0-9_]+", -- three letter+ constants
	"2",
	"4",
}
not_globals = {
	"arg", -- arg is a standard global, so without this it won't error when we typo "args" in a module
}
globals = {
	-- wow std api
	"abs",
	"bit",
	"ceil",
	"cos",
	"debugstack",
	"exp",
	"floor",
	"format",
	"gmatch",
	"gsub",
	"hooksecurefunc",
	"ldexp",
	"max",
	"min",
	"mod",
	"rad",
	"random",
	"scrub",
	"sin",
	"sort",
	"sqrt",
	"strbyte",
	"strchar",
	"strcmputf8i",
	"strconcat",
	"strfind",
	"string.join",
	"strjoin",
	"strlen",
	"strlenutf8",
	"strlower",
	"strmatch",
	"strrep",
	"strrev",
	"strsplit",
	"strsub",
	"strtrim",
	"strupper",
	"table.wipe",
	"tan",
	"time",
	"tinsert",
	"tremove",

	-- framexml
	"tContains",

	-- Vanilla
	"GetTalentTabInfo",

	-- everything else
	"BigWigs3DB",
	"BigWigsAPI",
	"BigWigsIconDB",
	"BigWigsLoader",
	"BigWigsOptions",
	"BigWigsStatsDB",
	"BigWigsKrosusFirstBeamWasLeft", -- Legion/Nighthold/Krosus.lua
	"C_EncounterJournal",
	"C_GossipInfo",
	"C_Minimap", -- Legion/TombOfSargeras/Kiljaeden.lua
	"C_ModifiedInstance", -- 3x Affixes.lua in BigWigs_Shadowlands
	"C_RaidLocks",
	"C_ScenarioInfo", -- LittleWigs
	"C_Timer",
	"ChatFrame_ImportListToHash",
	"ChatTypeInfo",
	"CheckInteractDistance",
	"CinematicFrame_CancelCinematic",
	"CombatLogGetCurrentEventInfo",
	"CreateFrame",
	"EJ_GetCreatureInfo",
	"EJ_GetEncounterInfo",
	"ElvUI",
	"FlashClientIcon",
	"GameFontHighlight",
	"GameFontNormal",
	"GameTooltip",
	"GameTooltip_Hide",
	"GetDifficultyInfo",
	"GetFramesRegisteredForEvent",
	"GetInstanceInfo",
	"GetLocale",
	"GetPartyAssignment",
	"GetPlayerFacing",
	"GetProfessionInfo",
	"GetProfessions",
	"GetRaidRosterInfo", -- Classic/AQ40/Cthun.lua
	"GetRealmName",
	"GetRealZoneText",
	"GetSpecializationInfoByID",
	"GetSubZoneText",
	"GetTime",
	"GetUnitSpeed", -- Dragonflight/Amirdrassil/TindralSageswift.lua
	"InCombatLockdown",
	"IsAltKeyDown",
	"IsControlKeyDown",
	"IsEncounterInProgress",
	"IsGuildMember",
	"IsInGroup",
	"IsInRaid",
	"IsLoggedIn",
	"IsMounted", -- Dragonflight/Amirdrassil/TindralSageswift.lua
	"IsPartyLFG",
	"IsPlayerSpell",
	"IsSpellKnown",
	"LFGDungeonReadyPopup",
	"LibStub",
	"LoggingCombat",
	"MovieFrame",
	"ObjectiveTrackerFrame",
	"PlayerHasToy",
	"PlaySound",
	"RaidBossEmoteFrame",
	"RaidNotice_AddMessage",
	"RaidWarningFrame",
	"SecondsToTime",
	"StopSound",
	"TalkingHeadFrame",
	"Tukui",
	"UIParent",
	"UIWidgetManager",
	"UnitAffectingCombat",
	"UnitAura",
	"UnitCanAttack",
	"UnitCastingInfo",
	"UnitClass",
	"UnitExists",
	"UnitFactionGroup",
	"UnitGetTotalAbsorbs",
	"UnitHealth",
	"UnitHealthMax",
	"UnitInParty",
	"UnitInRaid",
	"UnitInVehicle",
	"UnitIsConnected",
	"UnitIsDead",
	"UnitIsEnemy", -- Multiple old modules
	"UnitIsFriend", -- MoP/SiegeOfOrgrimmar/TheFallenProtectors.lua
	"UnitIsGroupAssistant",
	"UnitIsGroupLeader",
	"UnitIsPlayer",
	"UnitIsUnit",
	"UnitLevel",
	"UnitPhaseReason",
	"UnitPosition",
	"UnitPower",
	"UnitPowerMax",
	"UnitPowerType", -- Multiple old modules
	"UnitRace",
	"Minimap", -- Legion/TombOfSargeras/Kiljaeden.lua
}
