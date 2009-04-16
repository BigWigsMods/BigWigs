----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Kologarn"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32930
mod.toggleoptions = {"grip", "shockwave", "eyebeam", "arm", -1, "icon", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local pName = UnitName("player")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Kologarn",

	arm = "Arm dies",
	arm_desc = "Warn for Left & Right Arm dies.",
	left_trigger = "Just a scratch!",
	right_trigger = "Only a flesh wound!",
	left_dies = "Left Arm dies",
	right_dies = "Right Arm dies",
	left_wipe_bar = "Respawn Left Arm",
	right_wipe_bar = "Respawn Right Arm",

	grip = "Stone Grip",
	grip_desc = "Warn who has Stone Grip.",
	grip_message = "Stone Grip: %s",

	shockwave = "Shockwave",
	shockwave_desc = "Warn when the next Shockwave is coming.",
	shockwave_trigger = "Oblivion!",

	eyebeam = "Focused Eyebeam",
	eyebeam_desc = "Warn who gets Focused Eyebeam.",
	eyebeam_message = "Eyebeam: %s",
	eyebeam_you = "Eyebeam on You!",

	icon = "Icon",
	icon_desc = "Place a Raid Target Icon on players with Focused Eyebeam. (requires promoted or higher)",
} end )

L:RegisterTranslations("koKR", function() return {
	arm = "팔 죽음",
	arm_desc = "왼쪽 & 오른쪽 팔의 죽음을 알립니다.",
	left_trigger = "긁힌 정도지!",
	right_trigger = "얕은 상처야!",
	left_dies = "왼쪽 팔 죽음",
	right_dies = "오른쪽 팔 죽음",
	left_wipe_bar = "왼쪽 팔 재생성",
	right_wipe_bar = "오른쪽 팔 재생성",

	grip = "바위 손아귀",
	grip_desc = "바위 손아귀에 걸린 플레이어를 알립니다.",
	grip_message = "바위 손아귀: %s",

	shockwave = "충격파",
	shockwave_desc = "다음 충격파에 대하여 알립니다.",
	shockwave_trigger = "망각!",

	eyebeam = "안광 집중",
	eyebeam_desc = "안광 집중의 대상이된 플레이어를 알립니다.",
	eyebeam_message = "안광 집중: %s",
	eyebeam_you = "당신은 안광 집중!",

	icon = "전술 표시",
	icon_desc = "안광 집중 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",
} end )

L:RegisterTranslations("frFR", function() return {
	arm = "Mort des bras",
	arm_desc = "Prévient quand le bras gauche et/ou droit meurt.",
	left_trigger = "C'est juste une égratignure !", -- à vérifier
	right_trigger = "Une blessure superficielle !", -- à vérifier
	left_dies = "Bras gauche éliminé",
	right_dies = "Bras droit éliminé",
	left_wipe_bar = "Réapp. bras gauche",
	right_wipe_bar = "Réapp. bras droit",

	grip = "Poigne de pierre",
	grip_desc = "Prévient quand un joueur subit les effets d'une Poigne de pierre.",
	grip_message = "Poigne de pierre : %s",

	shockwave = "Onde de choc",
	shockwave_desc = "Prévient quand la prochaine Onde de choc arrive.",
	shockwave_trigger = "OUBLI !",

	eyebeam = "Rayon de l'oeil focalisé",
	eyebeam_desc = "Prévient quand un joueur est ciblé par un Rayon de l'oeil.",
	eyebeam_message = "Rayon de l'oeil : %s",
	eyebeam_you = "Rayon de l'oeil sur vous !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Rayon de l'oeil focalisé (nécessite d'être assistant ou mieux).",
} end )

L:RegisterTranslations("zhCN", function() return {
--[[
	arm = "手臂死亡",
	arm_desc = "当左右手臂死亡时发出警报。",
	left_trigger = "Just a scratch!",
	right_trigger = "Only a flesh wound!",
	left_dies = "左臂死亡！",
	right_dies = "右臂死亡！",
	left_wipe_bar = "<左臂重生>",
	right_wipe_bar = "<右臂重生>",

	grip = "岩石之握",
	grip_desc = "当玩家中了岩石之握时发出警报。",
	grip_message = "岩石之握：>%s<！",

	shockwave = "震荡波",
	shockwave_desc = "当震荡波到来前发出警报。",
	shockwave_trigger = "Oblivion!",

	eyebeam = "Focused Eyebeam",
	eyebeam_desc = "当玩家中了Focused Eyebeam时发出警报。",
	eyebeam_message = "Eyebeam：>%s<！",
	eyebeam_you = ">你< Eyebeam！",

	icon = "团队标记",
	icon_desc = "为中了Focused Eyebeam的队员打上团队标记。（需要权限）",
]]
} end )

L:RegisterTranslations("zhTW", function() return {
	arm = "手臂死亡",
	arm_desc = "當左右手臂死亡時發出警報。",
--	left_trigger = "Just a scratch!",
--	right_trigger = "Only a flesh wound!",
	left_dies = "左臂死亡！",
	right_dies = "右臂死亡！",
	left_wipe_bar = "<左臂重生>",
	right_wipe_bar = "<右臂重生>",

	grip = "堅石之握",
	grip_desc = "當玩家中了堅石之握時發出警報。",
	grip_message = "堅石之握：>%s<！",

	shockwave = "震攝波",
	shockwave_desc = "當震攝波到來前發出警報。",
--	shockwave_trigger = "Oblivion!",

	eyebeam = "集束目光",
	eyebeam_desc = "當玩家中了集束目光時發出警報。",
	eyebeam_message = "集束目光：>%s<！",
	eyebeam_you = ">你< 集束目光！",

	icon = "團隊標記",
	icon_desc = "為中了集束目光的隊員打上團隊標記。（需要權限）",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Grip", 64290, 64292)
	self:AddCombatListener("SPELL_SUMMON", "Eyebeam", 63343, 63701)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Grip(player, spellID)
	if db.grip then
		local msg = L["grip_message"]:format(player)
		self:IfMessage(msg, "Attention", spellID)
		self:Bar(msg, 10, spellID)
	end
end

function mod:Eyebeam(_, _, source)
	if db.eyebeam then
		local other = L["eyebeam_message"]:format(source)
		if source == pName then
			self:LocalMessage(L["eyebeam_you"], "Personal", nil, "Long")
			self:WideMessage(other)
		else
			self:IfMessage(other, "Urgent", 63976)
		end
		self:Bar(other, 10, 63976)
		self:Icon(source, "icon")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	--2062, looks like a Arms :)
	if msg == L["left_trigger"] and db.arm then
		self:Message(L["left_dies"], "Attention")
		self:Bar(L["left_wipe_bar"], 60, 2062)
	elseif msg == L["right_trigger"] and db.arm then
		self:Message(L["right_dies"], "Attention")
		self:Bar(L["right_wipe_bar"], 60, 2062)
	elseif msg == L["shockwave_trigger"] and db.shockwave then
		self:Message(L["shockwave"], "Attention")
		self:Bar(L["shockwave"], 21, 63982)
	end
end
