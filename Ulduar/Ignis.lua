----------------------------------
--      Module Declaration      --
----------------------------------

local boss = BB["Ignis the Furnace Master"]
local mod = BigWigs:New(boss, "$Revision$")
if not mod then return end
mod.zonename = BZ["Ulduar"]
mod.enabletrigger = boss
mod.guid = 33118
mod.toggleOptions = {62488, 62382, 62680, 62546, 62717, "bosskill"}
mod.consoleCmd = "Ignis"

------------------------------
--      Are you local?      --
------------------------------

local db = nil
local pName = UnitName("player")
local spawnTime = 30

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)

L:RegisterTranslations("enUS", function() return {
	engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!",

	construct_message = "Add incoming!",
	construct_bar = "Next add",
	brittle_message = "Construct is Brittle!",
	flame_bar = "~Jets cooldown",
	scorch_message = "Scorch on you!",
	scorch_soon = "Scorch in ~5sec!",
	scorch_bar = "Next Scorch",
	slagpot_message = "Slag Pot: %s",
} end )

L:RegisterTranslations("ruRU", function() return {
	engage_trigger = "Дерзкие глупцы! Ваша кровь закалит оружие, которым был завоеван этот мир!",

	construct_message = "Задействовать создание!",
	construct_bar = "Следующее создание",
	brittle_message = "Создание подверглось Ломкости!",
	flame_bar = "~перезарядка струи",
	scorch_message = "Ожог на ВАС!",
	scorch_soon = "Ожог через ~5сек!",
	scorch_bar = "Следующий Ожог",
	slagpot_message = "Захвачен в ковш: %s",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "건방진 젖먹이들이! 세상을 되찾는 데 쓸 무기를 네놈들의 피로 담금질하겠다!",	--check

	construct_message = "피조물 활성화!",
	construct_bar = "다음 피조물",
	brittle_message = "피조물 부서지는 몸!",
	flame_bar = "~분출 대기시간",
	scorch_message = "당신은 불태우기!",
	scorch_soon = "약 5초 후 불태우기!",
	scorch_bar = "다음 불태우기",
	slagpot_message = "용암재 단지: %s",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Chiots insolents ! Les lames qui serviront à reconquérir ce monde seront trempées dans votre sang !",

	construct_message = "Assemblage activé !",
	construct_bar = "Prochain Assemblage",
	brittle_message = "Un Assemblage est devenu Fragile !",
	flame_bar = "~Recharge Flots",
	scorch_message = "Brûlure sur VOUS !",
	scorch_soon = "Brûlure dans ~5 sec. !",
	scorch_bar = "Prochaine Brûlure",
	slagpot_message = "Marmite : %s",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Ihr anmaßenden Wichte! Euer Blut wird die Waffen härten, mit denen diese Welt erobert wird!",

	construct_message = "Konstrukt aktiviert!",
	construct_bar = "Nächstes Konstrukt",
	brittle_message = "Konstrukt ist spröde!",
	flame_bar = "~Flammenstrahlen",
	scorch_message = "Versengen auf DIR!",
	scorch_soon = "Versengen in ~5 sek!",
	scorch_bar = "Nächstes Versengen",
	slagpot_message = "Schlackentopf: %s!",
} end )

L:RegisterTranslations("zhCN", function() return {
--	engage_trigger = "Insolent whelps! Your blood will temper the weapons used to reclaim this world!",

	construct_message = "即将 铁铸像！",
	construct_bar = "<下一铸像>",
	brittle_message = "铁铸像 - 脆弱！",
	flame_bar = "<烈焰喷射 冷却>",
	scorch_message = ">你< 灼烧！",
	scorch_soon = "约5秒后，灼烧！",
	scorch_bar = "<下一灼烧>",
	slagpot_message = "熔渣炉：>%s<！",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "傲慢的小傢伙!你們的鮮血將會用來淬鍊重奪世界的武器!",

	construct_message = "即將 鐵之傀儡！",
	construct_bar = "<下一鐵之傀儡>",
	brittle_message = "鐵之傀儡 - 脆裂！",
	flame_bar = "<烈焰噴洩 冷卻>",
	scorch_message = ">你< 灼燒！",
	scorch_soon = "約5秒後，灼燒！",
	scorch_bar = "<下一灼燒>",
	slagpot_message = "熔渣之盆：>%s<！",
} end )


------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:AddCombatListener("SPELL_CAST_START", "Construct", 62488)
	self:AddCombatListener("SPELL_CAST_SUCCESS", "ScorchCast", 62546, 63474)
	self:AddCombatListener("SPELL_CAST_START", "Jets", 62680, 63472)
	self:AddCombatListener("SPELL_DAMAGE", "Scorch", 62548, 63475)
	self:AddCombatListener("SPELL_AURA_APPLIED", "SlagPot", 62717, 63477)
	self:AddCombatListener("SPELL_AURA_APPLIED", "Brittle", 62382)
	self:AddCombatListener("UNIT_DIED", "BossDeath")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	db = self.db.profile
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Brittle(_, spellId)
	self:IfMessage(L["brittle_message"], "Positive", spellId)
end

function mod:Construct()
	self:IfMessage(L["construct_message"], "Important", "Interface\\Icons\\INV_Misc_Statue_07")
	self:Bar(L["construct_bar"], spawnTime, "INV_Misc_Statue_07")
end

function mod:ScorchCast(_, spellId, _, _, spellName)
	self:IfMessage(spellName, "Attention", spellId)
	self:Bar(L["scorch_bar"], 25, spellId)
	self:DelayedMessage(20, L["scorch_soon"], "Urgent", nil, nil, nil, spellId)
end

do
	local last = nil
	function mod:Scorch(player, spellId)
		if player == pName then
			local t = GetTime()
			if not last or (t > last + 4) then
				self:LocalMessage(L["scorch_message"], "Personal", spellId, last and nil or "Alarm")
				last = t
			end
		end
	end
end

function mod:SlagPot(player, spellId_, _, spellName)
	self:TargetMessage(spellName, player, "Important", spellId)
	self:Bar(L["slagpot_message"]:format(player), 10, spellId)
end

do
	local _, class = UnitClass("player")
	local function isCaster()
		local power = UnitPowerType("player")
		if power ~= 0 then return end
		if class == "PALADIN" then
			local _, _, points = GetTalentTabInfo(1)
			-- If a paladin has less than 20 points in Holy, he's not a caster.
			-- And so it shall forever be, said the Lord.
			if points < 20 then return end
		end
		return true
	end

	function mod:Jets(_, spellId, _, _, spellName)
		local caster = isCaster()
		local color = caster and "Personal" or "Attention"
		local sound = caster and "Long" or nil
		self:IfMessage(spellName, color, spellId, sound)
		self:Bar(L["flame_bar"], 25, spellId)
		if caster then self:Bar(spellName, 2.7, spellId) end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		spawnTime = GetRaidDifficulty() == 1 and 40 or 30
		if self:GetOption(62680) then
			self:Bar(L["flame_bar"], 21, 62680)
		end
		if self:GetOption(62488) then
			self:Bar(L["construct_bar"], 10, "INV_Misc_Statue_07")
		end
	end
end

