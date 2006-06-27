local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsBuru = AceAddon:new({
	name          = "BigWigsBuru",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Ruins of Ahn'Qiraj"),
	enabletrigger = bboss("Buru the Gorger"),
	bossname = bboss("Buru the Gorger"),

	toggleoptions = GetLocale() == "koKR" and {
		notBosskill = "보스 사망",
		notWatchYou = "자신을 노려볼 때 경고",
		notWatchOther = "다른 사람을 노려볼 때 경고",
		notIcon = "노려보는 사람에게 해골 표시. (승급 필요)",
	} or {
		notBosskill = "Boss death",
		notWatchYou = "You're being watched warning",
		notWatchOther = "Others being watched warning",
		notIcon = "Put a Skull icon on the person who's watched. (Requires promoted or higher)",
	},

	optionorder = {"notWatchYou", "notWatchOther", "notIcon", "notBosskill"},


	loc = GetLocale() == "koKR" and {
		disabletrigger = "먹보 부루|1이;가; 죽었습니다.",
		bosskill = "먹보 부루를 물리쳤습니다.",

		watchtrigger = "(.+)|1을;를; 노려봅니다!",
		watchwarn = "님을 노려봅니다!",
		you = UnitName("player"),
		watchtell = "당신을 주시합니다!",
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger = "吞咽者布鲁死亡了。",
		bosskill = "吞咽者布鲁被击败了！",

		watchtrigger = "凝视着(.+)！",
		watchwarn = "被布鲁盯上了！",
		watchwarnyou = "你被布鲁盯上了！放风筝吧！",
		you = "你",
	}
		or
	{
		disabletrigger = "Buru the Gorger dies.",
		bosskill = "Buru the Gorger has been defeated.",

		watchtrigger = "sets eyes on (.+)!",
		watchwarn = " is being watched!",
		watchwarnyou = "You are being watched! Kite!",
		you = "You",
	},
})

function BigWigsBuru:Initialize()
    self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsBuru:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
end

function BigWigsBuru:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsBuru:CHAT_MSG_MONSTER_EMOTE()
	local _, _, Player = string.find(arg1, self.loc.watchtrigger)
	if (Player) then
		if (Player == self.loc.you) then
			Player = UnitName("player")
			if not self:GetOpt("notWatchYou") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.watchwarnyou, "Red", true) end
		else
			if not self:GetOpt("notWatchOther") then 
				self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.watchwarn, "Yellow")
				self:TriggerEvent("BIGWIGS_SENDTELL", Player, self.loc.watchwarnyou)
			end
		end

		if not self:GetOpt("notIcon") then
			for i=1, GetNumRaidMembers() do
				if UnitName("raid"..i) == Player then
					SetRaidTargetIcon("raid"..i, 8)
				end
			end
		end
	end
end

function BigWigsBuru:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end 
		self:Disable()
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsBuru:RegisterForLoad()