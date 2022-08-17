std = "lua51"
max_line_length = false
codes = true
exclude_files = {
	"**/Libs",
}
only = {
	"011", -- syntax
	"1", -- globals
}
files["**/Loader.lua"].ignore = {
	"113/C_ChatInfo",
	"113/SendChatMessage",
	"113/SetRaidTarget",
	"113/UnitDetailedThreatSituation",
	"113/UnitGUID",
	"113/UnitName",
}
files["**/Core/BossPrototype.lua"].ignore = {
	"113/TranscriptIgnore",
	"113/Transcriptor",
}
ignore = {
	"11/SLASH_.*", -- slash handlers
	"1/[A-Z][A-Z][A-Z0-9_]+", -- three letter+ constants
}
globals = {
	-- wow std api
	"abs",
	"acos",
	"asin",
	"atan",
	"atan2",
	"bit",
	"ceil",
	"cos",
	"date",
	"debuglocals",
	"debugprofilestart",
	"debugprofilestop",
	"debugstack",
	"deg",
	"difftime",
	"exp",
	"fastrandom",
	"floor",
	"forceinsecure",
	"foreach",
	"foreachi",
	"format",
	"frexp",
	"geterrorhandler",
	"getn",
	"gmatch",
	"gsub",
	"hooksecurefunc",
	"issecure",
	"issecurevariable",
	"ldexp",
	"log",
	"log10",
	"max",
	"min",
	"mod",
	"rad",
	"random",
	"scrub",
	"securecall",
	"seterrorhandler",
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
	"getprinthandler",
	"hash_SlashCmdList",
	"setprinthandler",
	"tContains",
	"tDeleteItem",
	"tInvert",
	"tostringall",

	-- everything else
	"AlertFrame",
	"Ambiguate",
	"BasicMessageDialog",
	"BackdropTemplateMixin",
	"BigWigs",
	"BigWigsClassicDB",
	"BigWigsAnchor",
	"BigWigsAPI",
	"BigWigsEmphasizeAnchor",
	"BigWigsIconClassicDB",
	"BigWigsLoader",
	"BigWigsOptions",
	"BigWigsStatsClassicDB",
	"BNGetFriendGameAccountInfo",
	"BNGetFriendIndex",
	"BNGetGameAccountInfoByGUID",
	"BNGetNumFriendGameAccounts",
	"BNIsSelf",
	"BNSendWhisper",
	"C_BattleNet",
	"C_ChatInfo",
	"C_FriendList",
	"C_Map",
	"C_NamePlate",
	"C_Spell",
	"C_Timer",
	"C_UIWidgetManager",
	"ChatFrame_ImportAllListsToHash",
	"ChatTypeInfo",
	"CheckInteractDistance",
	"CinematicFrame_CancelCinematic",
	"CombatLogGetCurrentEventInfo",
	"CombatLog_String_GetIcon",
	"CreateFrame",
	"ElvUI",
	"EnableAddOn",
	"FlashClientIcon",
	"GameFontHighlight",
	"GameFontNormal",
	"GameTooltip",
	"GameTooltip_Hide",
	"GetAddOnDependencies",
	"GetAddOnEnableState",
	"GetAddOnInfo",
	"GetAddOnMetadata",
	"GetAddOnOptionalDependencies",
	"GetBuildInfo",
	"GetCurrentRegion",
	"GetCVar",
	"GetFramesRegisteredForEvent",
	"GetGossipActiveQuests",
	"GetGossipAvailableQuests",
	"GetGossipOptions",
	"GetGossipText",
	"GetInstanceInfo",
	"GetItemCount",
	"GetLocale",
	"GetNumAddOns",
	"GetNumGossipActiveQuests",
	"GetNumGossipAvailableQuests",
	"GetNumGroupMembers",
	"GetPartyAssignment",
	"GetPlayerFacing",
	"GetProfessionInfo",
	"GetRaidRosterInfo",
	"GetRaidTargetIndex",
	"GetRealmName",
	"GetRealZoneText",
	"GetServerExpansionLevel",
	"GetSpellCooldown",
	"GetSpellDescription",
	"GetSpellInfo",
	"GetSpellLink",
	"GetSpellTexture",
	"GetSubZoneText",
	"GetTalentInfo",
	"GetTalentTabInfo",
	"GetTime",
	"InCombatLockdown",
	"IsAddOnLoaded",
	"IsAddOnLoadOnDemand",
	"IsAltKeyDown",
	"IsControlKeyDown",
	"IsEncounterInProgress",
	"IsGuildMember",
	"IsInGroup",
	"IsInRaid",
	"IsItemInRange",
	"IsLoggedIn",
	"IsSpellKnown",
	"IsTestBuild",
	"LibStub",
	"LoadAddOn",
	"LoggingCombat",
	"MovieFrame",
	"PlaySound",
	"PlaySoundFile",
	"RaidBossEmoteFrame",
	"RaidNotice_AddMessage",
	"RaidWarningFrame",
	"SecondsToTime",
	"SelectGossipOption",
	"SendChatMessage",
	"SetCVar",
	"SlashCmdList",
	"StopSound",
	"Tukui",
	"UIErrorsFrame",
	"UIParent",
	"UnitAffectingCombat",
	"UnitAura",
	"UnitCanAttack",
	"UnitClass",
	"UnitExists",
	"UnitFactionGroup",
	"UnitGroupRolesAssigned",
	"UnitHealth",
	"UnitHealthMax",
	"UnitInParty",
	"UnitInPhase",
	"UnitInRaid",
	"UnitIsConnected",
	"UnitIsCorpse",
	"UnitIsDead",
	"UnitIsDeadOrGhost",
	"UnitIsEnemy",
	"UnitIsFriend",
	"UnitIsGroupAssistant",
	"UnitIsGroupLeader",
	"UnitIsPlayer",
	"UnitIsUnit",
	"UnitLevel",
	"UnitPlayerControlled",
	"UnitPosition",
	"UnitPower",
	"UnitPowerMax",
	"UnitPowerType",
	"UnitRace",
	"UnitSetRole",
	"UnitSex",
}
