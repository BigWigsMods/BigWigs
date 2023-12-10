std = "lua51"
max_line_length = false
codes = true
exclude_files = {
	"**/Libs",
}
files["**/Loader.lua"].ignore = {
	"113/Ambiguate",
	"113/BasicMessageDialog",
	"113/C_AddOns",
	"113/C_ChatInfo",
	"113/C_CVar",
	"113/C_Map",
	"112/C_PartyInfo",
	"113/EnableAddOn",
	"113/GetAddOnInfo",
	"113/GetCurrentRegion",
	"113/securecallfunction",
	"113/SendChatMessage",
	"113/SetRaidTarget",
	"113/UnitDetailedThreatSituation",
	"113/UnitGUID",
	"113/UnitName",
	"11[13]/BigWigsClassicDB",
	"11[13]/BigWigsStatsClassicDB",

	-- Slash handling
	"111/SLASH_BigWigs1",
	"111/SLASH_BigWigs2",
	"111/SLASH_BigWigsVersion1",
	"11[23]/SlashCmdList",
	"11[23]/hash_SlashCmdList",
}
files["**/AutoRole.lua"].ignore = {
	"113/GetSpecialization",
	"113/GetSpecializationRole",
	"113/RolePollPopup",
	"113/UnitGroupRolesAssigned",
	"113/UnitSetRole",
}
files["**/Core/BossPrototype.lua"].ignore = {
	"113/TranscriptIgnore",
	"113/Transcriptor",
	"113/UnitTokenFromGUID",
	"113/C_UnitAuras",
	"113/UnitGroupRolesAssigned",
}
files["**/Core/BossPrototype_Classic.lua"].ignore = {
	".+", -- Temp file for classic
}
files["**/Core/Core.lua"].ignore = {
	"111/BigWigs",
	"113/geterrorhandler",
}
files["**/Plugins/AltPower.lua"].ignore = {
	"113/UnitGroupRolesAssigned",
}
files["**/Plugins/AutoReply.lua"].ignore = {
	"113/BNGetFriendIndex",
	"113/BNIsSelf",
	"113/BNSendWhisper",
	"113/C_BattleNet",
	"113/C_FriendList",
}
files["**/Plugins/Bars.lua"].ignore = {
	"113/C_NamePlate",
}
files["**/Plugins/BossBlock.lua"].ignore = {
	"113/AlertFrame",
	"112/BigWigs",
	"113/C_ContentTracking",
	"113/C_CVar",
	"113/C_TalkingHead",
	"113/RaidBossEmoteFrame_OnEvent",
	"113/TooltipDataProcessor",
}
files["**/Plugins/Countdown.lua"].ignore = {
	"113/GetCurrentRegion",
}
files["**/Plugins/Proximity.lua"].ignore = {
	"113/GetServerExpansionLevel", -- Classic support
	"113/UnitInPhase", -- Classic support
}
files["**/Plugins/Pull.lua"].ignore = {
	"113/UnitGroupRolesAssigned",
}
files["**/Plugins/Victory.lua"].ignore = {
	"113/BossBanner",
}
files["**/Plugins/*.lua"].ignore = {
	"112/SlashCmdList",
	"111/SLASH_.*", -- slash handlers
}
files["**/Options/Options.lua"].ignore = {
	"113/C_Spell",
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
	"date",
	"debugstack",
	"deg",
	"exp",
	"floor",
	"format",
	"frexp",
	"getn",
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
	"tDeleteItem",

	-- everything else
	"BigWigs3DB",
	"BigWigsAnchor",
	"BigWigsAPI",
	"BigWigsEmphasizeAnchor",
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
	"C_Scenario",
	"C_Timer",
	"ChatFrame_ImportListToHash",
	"ChatTypeInfo",
	"CheckInteractDistance",
	"CinematicFrame_CancelCinematic",
	"CombatLogGetCurrentEventInfo",
	"CombatLog_String_GetIcon",
	"CreateFrame",
	"EJ_GetCreatureInfo",
	"EJ_GetEncounterInfo",
	"ElvUI",
	"FlashClientIcon",
	"GameFontHighlight",
	"GameFontNormal",
	"GameTooltip",
	"GameTooltip_Hide",
	"GetAddOnDependencies",
	"GetAddOnOptionalDependencies",
	"GetBuildInfo",
	"GetDifficultyInfo",
	"GetFramesRegisteredForEvent",
	"GetInstanceInfo",
	"GetItemCount",
	"GetLocale",
	"GetNumAddOns",
	"GetNumGroupMembers",
	"GetPartyAssignment",
	"GetPlayerFacing",
	"GetProfessionInfo",
	"GetProfessions",
	"GetRaidRosterInfo", -- Classic/AQ40/Cthun.lua
	"GetRaidTargetIndex",
	"GetRealmName",
	"GetRealZoneText",
	"GetSpecializationInfoByID",
	"GetSpellCooldown",
	"GetSpellDescription",
	"GetSpellInfo",
	"GetSpellLink",
	"GetSpellTexture",
	"GetSubZoneText",
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
	"IsPartyLFG",
	"IsPlayerSpell",
	"IsSpellKnown",
	"LFGDungeonReadyPopup",
	"LibStub",
	"LoadAddOn",
	"LoggingCombat",
	"MovieFrame",
	"ObjectiveTrackerFrame",
	"PlayerHasToy",
	"PlaySound",
	"PlaySoundFile",
	"RaidBossEmoteFrame",
	"RaidNotice_AddMessage",
	"RaidWarningFrame",
	"SecondsToTime",
	"StopSound",
	"TalkingHeadFrame",
	"Tukui",
	"UIErrorsFrame",
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
	"UnitIsCorpse",
	"UnitIsDead",
	"UnitIsDeadOrGhost",
	"UnitIsEnemy", -- Multiple old modules
	"UnitIsFriend", -- MoP/SiegeOfOrgrimmar/TheFallenProtectors.lua
	"UnitIsGroupAssistant",
	"UnitIsGroupLeader",
	"UnitIsPlayer",
	"UnitIsUnit",
	"UnitLevel",
	"UnitPhaseReason",
	"UnitPlayerControlled",
	"UnitPosition",
	"UnitPower",
	"UnitPowerMax",
	"UnitPowerType", -- Multiple old modules
	"UnitRace",
	"UnitSex",
	"UnitThreatSituation", -- Cataclysm/Bastion/Sinestra.lua
	"Minimap", -- Legion/TombOfSargeras/Kiljaeden.lua
}
