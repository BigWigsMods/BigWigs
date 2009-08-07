--------------------------------------------------------------------------------
-- Module Declaration
--

local boss = BB["Gormok the Impaler"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Trial of the Crusader"]	--need the add name translated, maybe add to BabbleZone.
mod.otherMenu = "The Argent Coliseum"
mod.enabletrigger = boss
mod.guid = 34796
mod.toggleoptions = {"stomp", "impale", "firebomb", "bosskill"}

--------------------------------------------------------------------------------
-- Locals
--
local db = nil
local pName = UnitName("player")
local impale = GetSpellInfo(67477)
local count

--------------------------------------------------------------------------------
-- Localization
--

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
L:RegisterTranslations("enUS", function() return {
	cmd = "Gormok",

	impale = "Impale",
	impale_desc = "Warn when someone has 2 or more stacks of Impale.",
	impale_message = "%2$dx Impale on %1$s",

	stomp = "Staggering Stomp",
	stomp_desc = "Warn when Gormok casts Staggering Stomp.",
	stomp_message = "Stomp %d!",
	stomp_warning = "Stomp in 5sec!",
	stomp_bar = "Stomp %d",

	firebomb = "Fire Bomb",
	firebomb_desc = "Warn when you are in a Fire Bomb.",
	firebomb_message = "Fire Bomb on you!",
} end)
L:RegisterTranslations("koKR", function() return {
	impale = "꿰뚫기",
	impale_desc = "꿰뚫기 중첩이 2이상이 된 플레이어를 알립니다.",
	impale_message = "꿰뚫기 x%2$d: %1$s",

	stomp = "진동의 발구르기",
	stomp_desc = "고르목의 진동의 발구르기 시전을 알립니다.",
	stomp_message = "발구르기 (%d)!",
	stomp_warning = "5초 후 발구르기!",
	stomp_bar = "~다음 발구르기(%d)",

	firebomb = "불 폭탄",
	firebomb_desc = "자신이 불 폭탄에 걸렸을 때 알립니다.",
	firebomb_message = "당신은 불 폭탄!",
} end)
L:RegisterTranslations("frFR", function() return {
	impale = "Empaler",
	impale_desc = "Prévient quand quelqu'un a 2 cumuls ou plus d'Empaler.",
	impale_message = "%2$dx Empaler sur %1$s",

	stomp = "Piétinement ahurissant",
	stomp_desc = "Prévient quand Gormok incante un Piétinement ahurissant.",
	stomp_message = "Piétinement %d !",
	stomp_warning = "Piétinement dans 5 sec. !",
	stomp_bar = "Piétinement %d",

	firebomb = "Bombe incendiaire",
	firebomb_desc = "Prévient quand vous vous trouvez sur une Bombe incendiaire.",
	firebomb_message = "Bombe incendiaire en dessous de VOUS !",
} end)
L:RegisterTranslations("deDE", function() return {
	impale = "Pfähler",
	impale_desc = "Warnt, wenn jemand 2 oder mehr Stapel von Pfählen hat.",
	impale_message = "%2$dx Pfählen auf %1$s",
	
	stomp = "Erschütterndes Stampfen",
	stomp_desc = "Warnt, wenn Gormok Erschütterndes Stampfen wirkt.",
	stomp_message = "Stampfen %d!",
	stomp_warning = "Stampfen in 5 sek!",
	stomp_bar = "Stampfen %d",
	
	firebomb = "Feuerbombe",
	firebomb_desc = "Warnt, wenn du in einer Feuerbombe stehst.",
	firebomb_message = "Feuerbombe auf DIR!",
} end)
L:RegisterTranslations("zhCN", function() return {
-[[
	impale = "Impale",
	impale_desc = "当玩家中了2层或更多Impale时发出警报。",
	impale_message = "%2$dx Impale：>%1$s<！",

	stomp = "Staggering Stomp",
	stomp_desc = "当 Gormok 施放Staggering Stomp时发出警报。",
	stomp_message = "Staggering Stomp：>%d<！",
	stomp_warning = "5秒后，Staggering Stomp！",
	stomp_bar = "<Staggering Stomp：%d>",

	firebomb = "Fire Bomb",
	firebomb_desc = "当你中了Fire Bomb时发出警报。",
	firebomb_message = ">你< Fire Bomb！",
-]]
} end)
L:RegisterTranslations("zhTW", function() return {
	impale = "刺穿",
	impale_desc = "當玩家中了2層或更多刺穿時發出警報。",
	impale_message = "%2$dx 刺穿：>%1$s<！",

	stomp = "驚恐踐踏",
	stomp_desc = "當Gormok施放驚恐踐踏時發出警報。",
	stomp_message = "驚恐踐踏：>%d<！",
	stomp_warning = "5秒後，驚恐踐踏！",
	stomp_bar = "<驚恐踐踏：%d>",

	firebomb = "燃燒彈",
	firebomb_desc = "當你中了燃燒彈時發出警報。",
	firebomb_message = ">你< 燃燒彈！",
} end)
L:RegisterTranslations("ruRU", function() return {
} end)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:OnEnable()
	self:AddCombatListener("SPELL_DAMAGE", "FireBomb", 67472, 66317)
	self:AddCombatListener("SPELL_AURA_APPLIED_DOSE", "Impale", 67477, 66331)
	self:AddCombatListener("SPELL_CAST_START", "Stomp", 67647, 66330)
	self:AddCombatListener("UNIT_DIED", "BossDeath")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	db = self.db.profile
	count = 1
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Impale(player, spellID)
	if db.impale then
		local _, _, icon, stack = UnitDebuff(player, impale)
		if stack and stack > 1 then
			self:TargetMessage(L["impale_message"], player, "Urgent", icon, "Info", stack)
		end
	end
end

function mod:Stomp(_, spellID)
	if db.stomp then
		self:IfMessage(L["stomp_message"]:format(count), "Attention", spellID, "Long")
		count = count + 1
		self:Bar(L["stomp_bar"]:format(count), 21, spellID)
		self:DelayedMessage(16, L["stomp_warning"], "Attention")
	end
end

do
	local last = nil
	function mod:FireBomb(player, spellID)
		if player == pName and db.firebomb then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(L["firebomb_message"], "Personal", spellID, last and nil or "Alarm")
				last = t
			end
		end
	end
end
