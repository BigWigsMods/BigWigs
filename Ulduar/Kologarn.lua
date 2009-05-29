----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Kologarn"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 32930
mod.toggleoptions = {"grip", "shockwave", "eyebeam", "arm", "armor", "bosskill"}

------------------------------
--      Are you local?      --
------------------------------

local started = nil
local db = nil
local grip = mod:NewTargetList()
local pName = UnitName("player")
local crunch = GetSpellInfo(63355)

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	cmd = "Kologarn",

	arm = "Arm dies",
	arm_desc = "Warn for Left & Right Arm dies.",
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
	eyebeam_message = "Eyebeam Incoming!",
	eyebeam_bar = "~Eyebeam",
	eyebeam_you = "Eyebeam on YOU!",

	armor = "Crunch Armor",
	armor_desc = "Warn when someone has 2 or more stacks of Crunch Armor.",
	armor_message = "%2$dx Crunch on %1$s",
} end )

L:RegisterTranslations("koKR", function() return {
	arm = "팔 죽음",
	arm_desc = "왼팔 & 오른팔의 죽음을 알립니다.",
	left_dies = "왼팔 죽음",
	right_dies = "오른팔 죽음",
	left_wipe_bar = "왼팔 재생성",
	right_wipe_bar = "오른팔 재생성",

	grip = "바위 손아귀",
	grip_desc = "바위 손아귀에 걸린 플레이어를 알립니다.",
	grip_message = "바위 손아귀: %s",

	shockwave = "충격파",
	shockwave_desc = "다음 충격파에 대하여 알립니다.",
	shockwave_trigger = "망각!",

	eyebeam = "안광 집중",
	eyebeam_desc = "안광 집중의 대상이된 플레이어를 알립니다.",
	eyebeam_message = "안광 집중!",
	eyebeam_bar = "~안광 집중",
	eyebeam_you = "당신은 안광 집중!",

	armor = "방어구 씹기",
	armor_desc = "방어구 씹기 중첩이 2이상이 된 플레이어를 알립니다.",
	armor_message = "방어구 씹기 x%2$d: %1$s",
} end )

L:RegisterTranslations("frFR", function() return {
	arm = "Mort des bras",
	arm_desc = "Prévient quand le bras gauche et/ou droit meurt.",
	left_dies = "Bras gauche éliminé",
	right_dies = "Bras droit éliminé",
	left_wipe_bar = "Réapparition du bras gauche",
	right_wipe_bar = "Réapparition du bras droit",

	grip = "Poigne de pierre",
	grip_desc = "Prévient quand un joueur subit les effets d'une Poigne de pierre.",
	grip_message = "Poigne de pierre : %s",

	shockwave = "Onde de choc",
	shockwave_desc = "Prévient quand la prochaine Onde de choc arrive.",
	shockwave_trigger = "OUBLI !",

	eyebeam = "Rayon de l'oeil focalisé",
	eyebeam_desc = "Prévient quand un Rayon de l'oeil est incanté.",
	eyebeam_message = "Arrivée d'un Rayon de l'oeil !",
	eyebeam_bar = "~Prochain Rayon de l'oeil",
	eyebeam_you = "Rayon de l'oeil sur VOUS !",

	armor = "Broie armure",
	armor_desc = "Prévient quand un joueur a 2 cumuls ou plus de Broie armure.",
	armor_message = "%2$dx broyages d'armure sur %1$s",
} end )

L:RegisterTranslations("deDE", function() return {
	arm = "Arm stirbt",
	arm_desc = "Warnung und Timer für das Sterben des linken & rechten Arms.",
	left_dies = "Linker Arm stirbt!",
	right_dies = "Rechter Arm stirbt!",
	left_wipe_bar = "Neuer linker Arm",
	right_wipe_bar = "Neuer rechter Arm",

	grip = "Steinerner Griff",
	grip_desc = "Warnt, wer von Steinerner Griff betroffen ist.",
	grip_message = "Griff: %s!",

	shockwave = "Schockwelle",
	shockwave_desc = "Timer für die Schockwelle.",
	shockwave_trigger = "AUSLÖSCHUNG!",

	eyebeam = "Fokussierter Augenstrahl",
	eyebeam_desc = "Warnt, wenn du von Fokussierter Augenstrahl betroffen bist.",
	eyebeam_message = "Augenstrahl!",
	eyebeam_bar = "~Augenstrahl",
	eyebeam_you = "Augenstrahl auf DIR!",
	
	armor = "Rüstung zermalmen",
	armor_desc = "Warnt, wenn ein Spieler von 2 oder mehr Stapel von Rüstung zermalmen betroffen ist.",
	armor_message = "%2$dx Rüstung zermalmen: %1$s!",
} end )

L:RegisterTranslations("zhCN", function() return {
	arm = "手臂死亡",
	arm_desc = "当左右手臂死亡时发出警报。",
	left_dies = "左臂死亡！",
	right_dies = "右臂死亡！",
	left_wipe_bar = "<左臂重生>",
	right_wipe_bar = "<右臂重生>",

	grip = "岩石之握",
	grip_desc = "当玩家中了岩石之握时发出警报。",
	grip_message = "岩石之握：>%s<！",

	shockwave = "震荡波",
	shockwave_desc = "当震荡波到来前发出警报。",
--	shockwave_trigger = "Oblivion!",

	eyebeam = "Focused Eyebeam",
	eyebeam_desc = "当玩家中了Focused Eyebeam时发出警报。",
	eyebeam_message = "Eyebeam：>%s<！",
	eyebeam_bar = "<Eyebeam>",
	eyebeam_you = ">你< Eyebeam！",

	armor = "粉碎护甲",
	armor_desc = "当玩家中了2层或更多粉碎护甲时发出警报。",
	armor_message = "粉碎护甲%2$d层：>%1$s<！",
} end )

L:RegisterTranslations("zhTW", function() return {
	arm = "手臂死亡",
	arm_desc = "當左右手臂死亡時發出警報。",
	left_dies = "左臂死亡！",
	right_dies = "右臂死亡！",
	left_wipe_bar = "<左臂重生>",
	right_wipe_bar = "<右臂重生>",

	grip = "堅石之握",
	grip_desc = "當玩家中了堅石之握時發出警報。",
	grip_message = "堅石之握：>%s<！",

	shockwave = "震攝波",
	shockwave_desc = "當震攝波到來前發出警報。",
	shockwave_trigger = "滅亡吧!",

	eyebeam = "集束目光",
	eyebeam_desc = "當玩家中了集束目光時發出警報。",
	eyebeam_message = "集束目光：>%s<！",
	eyebeam_bar = "<集束目光>",
	eyebeam_you = ">你< 集束目光！",

	armor = "粉碎護甲",
	armor_desc = "當玩家中了2層或更多粉碎護甲時發出警報。",
	armor_message = "粉碎護甲%2$d層：>%1$s<！",
} end )

L:RegisterTranslations("ruRU", function() return {
	arm = "Уничтожение рук",
	arm_desc = "Сообщать о смерти левой и правой руки.",
	left_dies = "Левая рука уничтожена",
	right_dies = "Правая рука уничтожена",
	left_wipe_bar = "Восcтaновление левой руки",
	right_wipe_bar = "Восcтaновление правой руки",

	grip = "Каменная хватка",
	grip_desc = "Сообщать кто попал под воздействие Каменной хватки.",
	grip_message = "Хватка: %s",

	shockwave = "Ударная волна",
	shockwave_desc = "Сообщает о грядущей Ударной волне.",
	shockwave_trigger = "ЗАБВЕНИЕ!",

	eyebeam = "Сосредоточенный взгляд",
	eyebeam_desc = "Сообщать кто попал под воздействие Сосредоточенный взгляд.",
	eyebeam_message = "Взгляд!",
	eyebeam_bar = "~Взгляд",
	eyebeam_you = "Взгляд на ВАС!",
	
	armor = "Хруст доспеха",
	armor_desc = "Сообщать если кто получил 2 или больше эффекта Хруста доспеха.",
	armor_message = "%2$dx Хруста на |3-5(%1$s)",
} end )

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_AURA_APPLIED", "Grip", 64290, 64292)
	self:AddCombatListener("SPELL_DAMAGE", "EyebeamHit", 63976, 63346, 63368)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "Armor", 63355, 64002)
	self:AddCombatListener("UNIT_DIED", "Deaths")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Armor(player)
	if db.armor then
		local _, _, icon, stack = UnitDebuff(player, crunch)
		if stack and stack > 1 then
			self:TargetMessage(L["armor_message"], player, "Urgent", icon, "Info", stack)
		end
	end
end

local function gripWarn()
	mod:TargetMessage(L["grip_message"], grip, "Attention", 64292, "Alert")
	mod:Bar(L["grip"], 10, 64292)
end

function mod:Grip(player, spellID)
	if db.grip then
		grip[#grip + 1] = player
		self:ScheduleEvent("BWgripeWarn", gripWarn, 0.2)
	end
end

do
	local last = nil
	function mod:EyebeamHit(player)
		if db.eyebeam and player == pName then
			if not last or (GetTime() > last + 4) then
				self:LocalMessage(L["eyebeam_you"], "Personal", nil, "Long")
				last = GetTime()
			end
		end
	end
end

local eyebeamTrigger = GetSpellInfo(63342)
function mod:UNIT_SPELLCAST_SUCCEEDED(_, spell)
	if spell == eyebeamTrigger and db.eyebeam then
		self:IfMessage(L["eyebeam_message"], "Urgent", 63976)
		self:Bar(L["eyebeam"], 11, 63976)
		self:Bar(L["eyebeam_bar"], 20, 63976)
	end
end

function mod:Deaths(_, guid)
	guid = tonumber((guid):sub(-12,-7),16)
	local d = GetCurrentDungeonDifficulty() or 1
	if guid == 32933 then
		self:IfMessage(L["left_dies"], "Attention")
		self:Bar(L["left_wipe_bar"], d == 1 and 40 or 50, 2062) --2062, looks like a Arms :)
	elseif guid == 32934 then
		self:IfMessage(L["right_dies"], "Attention")
		self:Bar(L["right_wipe_bar"], d == 1 and 40 or 50, 2062) --2062, looks like a Arms :)
	elseif guid == self.guid then
		self:BossDeath(nil, guid)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["shockwave_trigger"] and db.shockwave then
		self:IfMessage(L["shockwave"], "Attention", 63982)
		self:Bar(L["shockwave"], 21, 63982)
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then 
			self:UnregisterEvent("PLAYER_REGEN_DISABLED") 
		end
	end
end

