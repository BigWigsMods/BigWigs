local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsAyamiss = AceAddon:new({
	name          = "BigWigsAyamiss",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Ruins of Ahn'Qiraj"),
	enabletrigger = bboss("Ayamiss the Hunter"),
	bossname = bboss("Ayamiss the Hunter"),

	toggleoptions = GetLocale() == "koKR" and {
		notBosskill = "보스 사망",
		notSacrifice = "마비 경고",
	} or {
		notBosskill = "Boss death",
		notSacrifice = "Sacrifice warning",
	},

	optionorder = {"notSacrifice", "notBosskill"},

	loc = GetLocale() == "koKR" and {
		disabletrigger = "사냥꾼 아야미스|1이;가; 죽었습니다.",
		bosskill = "사냥꾼 아야미스를 물리쳤습니다.",

		sacrificetrigger = "(.*)마비에 걸렸습니다.",
		sacrificewarn = "님이 마비에 걸렸습니다!",

		you = "",
		whopattern = "(.+)|1이;가; ",
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger = "狩猎者阿亚米斯死亡了。",
		bosskill = "狩猎者阿亚米斯被击败了！",

		sacrificetrigger = "^(.+)受(.+)了麻痹效果的影响。",
		sacrificewarn = "成为祭品了！",
		you = "你",
		are = "到",
	}
		or GetLocale() == "deDE" and
	{
		disabletrigger = "Ayamiss der J\195\164ger stirbt.",
		bosskill = "Ayamiss wurde besiegt.",

		sacrificetrigger = "^([^%s]+) ([^%s]+) von Paralisieren betroffen",
		sacrificewarn = " wird geopfert!",
		you = "Ihr",
		are = "seid",
	}
    or 
	{
		disabletrigger = "Ayamiss the Hunter dies.",
		bosskill = "Ayamiss the Hunter has been defeated.",

		sacrificetrigger = "^([^%s]+) ([^%s]+) afflicted by Paralyze",
		sacrificewarn = " is being Sacrificed!",
		you = "You",
		are = "are",
	},
})

function BigWigsAyamiss:Initialize()
    self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsAyamiss:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH" )
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkSacrifice")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkSacrifice")
end

function BigWigsAyamiss:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsAyamiss:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

if (GetLocale() == "koKR") then
	function BigWigsAyamiss:checkSacrifice()
		local _, _, Player = string.find(arg1, self.loc.sacrificetrigger)
		if (Player) then
			if (Player == self.loc.you) then
				Player = UnitName("player")
			else
				_, _, Player = string.find(Player, self.loc.whopattern) 
			end
			if not self:GetOpt("notSacrifice") then self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.sacrificewarn, "Red") end
		end
	end
else
	function BigWigsAyamiss:checkSacrifice()
		local _, _, Player, Type = string.find(arg1, self.loc.sacrificetrigger)
		if (Player and Type) then
			if (Player == self.loc.you and Type == self.loc.are) then
				Player = UnitName("player")
			end
			if not self:GetOpt("notSacrifice") then self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.sacrificewarn, "Red") end
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsAyamiss:RegisterForLoad()