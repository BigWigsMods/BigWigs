BigWigsGuardians = AceAddon:new({
	name          = "BigWigsGuardians",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ40",
	enabletrigger = GetLocale() == "koKR" and "아누비사스 감시자"
		or "Anubisath Guardian",

	loc = GetLocale() == "koKR" and {
		bossname = "아누비사스 감시자",
		disabletrigger = "아누비사스 감시자|1이;가; 죽었습니다.",
		bosskill = "아누비사스 감시자를 물리쳤습니다.",

		explodetrigger = "아누비사스 감시자|1이;가; 폭파 효과를 얻었습니다.",
		explodewarn = "폭파! 피하세요!",
		enragetrigger = "아누비사스 감시자|1이;가; 분노 효과를 얻었습니다.",
		enragewarn = "분노!",
		summonguardtrigger = "아누비사스 감시자|1이;가; 아누비사스 감시병 소환|1을;를; 시전합니다.",
		summonguardwarn = "감시병 소환",
		summonwarriortrigger = "아누비사스 감시자|1이;가; 아누비사스 전사 소환|1을;를; 시전합니다.",
		summonwarriorwarn = "전사 소환",		
		
		plaguetrigger = "^(.*)역병에 걸렸습니다%.$", 
		plaguewarn = "님이 역병에 걸렸습니다. 피하세요!",
		plagueyou = "",	
		whopattern = "(.+)%|1이;가; "
	} or {
		bossname = "Anubisath Guardian",
		disabletrigger = "Anubisath Guardian dies.",
		bosskill = "Anubisath Guardian has been defeated.",

		explodetrigger = "Anubisath Guardian gains Explode.",
		explodewarn = "Exploding! Run away!",
		enragetrigger = "Anubisath Guardian gains Enrage.",
		enragewarn = "Enraged!",
		summonguardtrigger = "Anubisath Guardian casts Summon Anubisath Swarmguard.",
		summonguardwarn = "Swarmguard Summoned",
		summonwarriortrigger = "Anubisath Guardian casts Summon Anubisath Warrior.",
		summonwarriorwarn = "Warrior Summoned",
		plaguetrigger = "^(.*)afflicted by Plague%.$",
		plaguewarn = " has the Plague! Keep away!",
		plagueyou = "You are ",
		whopattern = "([^%s]+) ([^%s]+) "
	},
})

function BigWigsGuardians:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsGuardians:Enable()
	self.disabled = nil
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkPlague")
end


function BigWigsGuardians:Disable()
	self.disabled = true
	self:UnregisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:UnregisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE")
	self:UnregisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE")
	
end

function BigWigsGuardians:CHAT_MSG_COMBAT_HOSTILE_DEATH()
    if ( arg1 == self.loc.disabletrigger ) then
        self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
        self:Disable()
    end
end


function BigWigsGuardians:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if( arg1 == self.loc.explodetrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.explodewarn, "Red" )
	elseif( arg1 == self.loc.enragetrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Red")
	end
end

function BigWigsGuardians:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if( arg1 == self.loc.summonguardtrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.summonguardwarn, "Yellow" )
	elseif( arg1 == self.loc.summonwarriortrigger ) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.summonwarriorwarn, "Yellow")
	end
end

function BigWigsGuardians:checkPlague()
	if( arg1 ) then
		local _,_,player = string.find( arg1, self.loc.plaguetrigger )
		if( player ) then
			local text = ""
			if( player == self.loc.plagueyou ) then
				text = UnitName("player")
			else
				text = string.find( player, self.loc.whopattern )
			end
			text = text .. self.loc.plaguewarn
			self:TriggerEvent("BIGWIGS_MESSAGE", text, "Red")
		end
	end
end

--------------------------------
--			Load this bitch!			--
--------------------------------
BigWigsGuardians:RegisterForLoad()
