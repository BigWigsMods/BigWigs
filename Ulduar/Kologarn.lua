----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Kologarn"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 0	--Unknown
mod.toggleoptions = {"arm", "grip", "shockwave", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local db = nil

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
		
	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Grip", 64290, 64292)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	
	db = self.db.profile
	
	BigWigs:Print(L["log"])
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Grip(player, spellID)
	if db.grip then
		self:IfMessage(L["grip_message"]:format(player), "Attention", spellID)
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
