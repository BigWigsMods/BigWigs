BigWigsBuru = AceAddon:new({
	name          = "BigWigsBuru",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ20",
	enabletrigger = GetLocale() == "koKR" and "먹보 부루"
		or GetLocale() == "zhCN" and "吞咽者布鲁"
		or "Buru the Gorger",

	loc = GetLocale() == "koKR" and {
		bossname = "먹보 부루",
		disabletrigger = "먹보 부루|1이;가; 죽었습니다.",
		bosskill = "먹보 부루를 물리쳤습니다.",

		watchtrigger = "(.+)|1을;를; 노려봅니다!",
		watchwarn = "님을 노려봅니다!",
		you = UnitName("player"),
		watchtell = "당신을 주시합니다!",
	}
		or GetLocale() == "zhCN" and
	{
		bossname = "吞咽者布鲁",
		disabletrigger = "吞咽者布鲁死亡了。",
		bosskill = "吞咽者布鲁被击败了！",

		watchtrigger = "凝视着(.+)！",
		watchwarn = "被布鲁盯上了！",
		watchwarnyou = "你被布鲁盯上了！放风筝吧！",
		you = "你",
	}
		or
	{
		bossname = "Buru the Gorger",
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
			self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.watchwarnyou, "Red", true)
		else
			self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.watchwarn, "Yellow")
			self:TriggerEvent("BIGWIGS_SENDTELL", Player, self.loc.watchwarnyou)
		end
	end
end

function BigWigsBuru:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory")
		self:Disable()
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsBuru:RegisterForLoad()