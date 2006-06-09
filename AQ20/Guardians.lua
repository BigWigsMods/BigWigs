BigWigsGuardians = AceAddon:new({
	name          = "BigWigsGuardians",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "AQ20",
	enabletrigger = GetLocale() == "koKR" and "아누비사스 감시자"
		or GetLocale() == "zhCN" and "阿努比萨斯守卫者"
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
		
		plaguetrigger = "(.*)역병에 걸렸습니다.", 
		plaguewarn = "님이 역병에 걸렸습니다. 피하세요!",
		plagueyou = "",	
		whopattern = "(.+)|1이;가; "
	} 
		or GetLocale() == "zhCN" and 
	{
		bossname = "阿努比萨斯守卫者",
		disabletrigger = "阿努比萨斯守卫者死亡了。",
		bosskill = "阿努比萨斯守卫者被击败了！",

		explodetrigger = "阿努比萨斯守卫者获得了爆炸的效果。",
		explodewarn = "即将爆炸！近战躲开！",
		enragetrigger = "阿努比萨斯守卫者获得了狂怒的效果。",
		enragewarn = "进入狂怒状态！",
		summonguardtrigger = "阿努比萨斯守卫者施放了召唤阿努比萨斯虫群卫士。",
		summonguardwarn = "虫群卫士已被召唤出来",
		summonwarriortrigger = "阿努比萨斯守卫者施放了召唤阿努比萨斯战士。",
		summonwarriorwarn = "阿努比萨斯战士已被召唤出来",		
		plaguetrigger = "^(.+)受(.+)了瘟疫效果的影响。$",
		plaguewarn = "受到瘟疫的影响！快躲开！",
		plaguewarnyou = "你受到瘟疫的影响！快跑开！",
		plagueyou = "你",
		plagueare = "到",
	}
		or 
	{
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
		plaguetrigger = "^([^%s]+) ([^%s]+) afflicted by Plague%.$",
		plaguewarn = " has the Plague! Keep away!",
		plaguewarnyou = "You got the Plague!",
		plagueyou = "You",
		plagueare = "are",
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
	self:UnregisterAllEvents()
end

function BigWigsGuardians:CHAT_MSG_COMBAT_HOSTILE_DEATH()
    if (arg1 == self.loc.disabletrigger) then
        self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
        self:Disable()
    end
end

function BigWigsGuardians:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (arg1 == self.loc.explodetrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.explodewarn, "Red")
	elseif (arg1 == self.loc.enragetrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Red")
	end
end

function BigWigsGuardians:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (arg1 == self.loc.summonguardtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.summonguardwarn, "Yellow")
	elseif (arg1 == self.loc.summonwarriortrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.summonwarriorwarn, "Yellow")
	end
end

if ( GetLocale() == "koKR" ) then
	function BigWigsGuardians:checkPlague()
		local _,_,Player = string.find(arg1, self.loc.plaguetrigger)
		if (Player) then
			if (Player == self.loc.plagueyou) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.plaguewarnyou, "Red", true)
			else
				Player = string.find(Player, self.loc.whopattern)
				self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.plaguewarn, "Yellow")
				self:TriggerEvent("BIGWIGS_SENDTELL", Player, self.loc.plaguetell)
			end
		end
	end
else
	function BigWigsGuardians:checkPlague()
		local _,_,Player, Type = string.find(arg1, self.loc.plaguetrigger)
		if (Player and Type) then
			if (Player == self.loc.plagueyou and Type == self.loc.plagueare) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.plaguewarnyou, "Red", true)
			else
				self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.plaguewarn, "Yellow")
				self:TriggerEvent("BIGWIGS_SENDTELL", Player, self.loc.plaguetell)
			end
		end
	end
end

--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsGuardians:RegisterForLoad()