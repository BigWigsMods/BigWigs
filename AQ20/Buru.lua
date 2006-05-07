BigWigsBuru = AceAddon:new({
	name          = "BigWigsBuru",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ20",
	enabletrigger = GetLocale() == "koKR" and "먹보 부루"
		or "Buru the Gorger",

	loc = GetLocale() == "koKR" and {
		bossname = "먹보 부루",
		disabletrigger = "먹보 부루|1이;가; 죽었습니다.",
		bosskill = "먹보 부루를 물리쳤습니다.",

		watchtrigger = ""(.+)%|1을;를; 노려봅니다!",
		watchwarn = "님을 노려봅니다!",
		you = UnitName("player"),	
	} or {
		bossname = "Buru the Gorger",
		disabletrigger = "Buru the Gorger dies.",
		bosskill = "Buru the Gorger has been defeated.",

		watchtrigger = "sets eyes on (.+)!",
		watchwarn = " is being watched!",
		you = "You",
	},
})


function BigWigsBuru:Initialize()
    self.disabled = true
    BigWigs:RegisterModule(self)
end

function BigWigsBuru:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH" )
end


function BigWigsBuru:Disable()
	self.disabled = true
	self:UnregisterEvent("CHAT_MSG_MONSTER_EMOTE")
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH" )
end

function BigWigsBuru:CHAT_MSG_MONSTER_EMOTE()
	local _, _, player = string.find(arg1, self.loc.watchtrigger);
	if( player ) then	
		local text = ""
		if( player == self.loc.you ) then
			text = UnitName("player")
		else
			text = player
		end
		text = text .. self.loc.watchwarn
		self:TriggerEvent("BIGWIGS_MESSAGE", text, "Red")
	end
end

function BigWigsBuru:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if ( arg1 == self.loc.disabletrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end


--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsBuru:RegisterForLoad()
