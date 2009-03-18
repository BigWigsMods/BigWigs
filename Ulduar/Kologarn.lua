----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Kologarn"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32930
mod.toggleoptions = {"arm", "grip", "shockwave", "eyebeam", "icon", "bosskill"}

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
	
	eyebeam = "Focused Eyebeam",
	eyebeam_desc = "Warn who gets Focused Eyebeam.",
	eyebeam_message = "Eyebeam: %s",
	eyebeam_you = "Eyebeam on You!",
	
	icon = "Icon",
	icon_desc = "Place a Raid Target Icon on players with Focused Eyebeam. (requires promoted or higher)",
		
	log = "|cffff0000"..boss.."|r: This boss needs data, please consider turning on your /combatlog or transcriptor and submit the logs.",
} end )

L:RegisterTranslations("koKR", function() return {
	arm = "팔 죽음",
	arm_desc = "왼쪽 & 오른쪽 팔의 죽음을 알립니다.",
	--left_trigger = "Just a scratch!",
	--right_trigger = "Only a flesh wound!",
	left_dies = "왼쪽 팔 죽음",
	right_dies = "오른쪽 팔 죽음",
	left_wipe_bar = "왼쪽 팔 재생성",
	right_wipe_bar = "오른쪽 팔 재생성",
	
	grip = "바위 손아귀",
	grip_desc = "바위 손아귀에 걸린 플레이어를 알립니다.",
	grip_message = "바위 손아귀: %s",
	
	shockwave = "충격파",
	shockwave_desc = "다음 충격파에 대하여 알립니다.",
	--shockwave_trigger = "Oblivion!",
	
	eyebeam = "안광 집중",
	eyebeam_desc = "안광 집중의 대상이된 플레이어를 알립니다.",
	eyebeam_message = "안광 집중: %s",
	eyebeam_you = "당신은 안광 집중!",
	
	icon = "전술 표시",
	icon_desc = "안광 집중 대상이된 플레이어에게 전술 표시를 지정합니다. (승급자 이상 권한 필요)",

	log = "|cffff0000"..boss.."|r: 해당 보스의 데이터가 필요합니다. 채팅창에 /전투기록 , /대화기록 을 입력하여 기록된 데이터나 transcriptor로 저장된 데이터 보내주시기 바랍니다.",
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
