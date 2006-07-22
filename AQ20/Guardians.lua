local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsGuardians = AceAddon:new({
	name          = "BigWigsGuardians",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Ruins of Ahn'Qiraj"),
	enabletrigger = bboss("Anubisath Guardian"),
	bossname = bboss("Anubisath Guardian"),

	toggleoptions = GetLocale() == "koKR" and {
		notBosskill = "보스 사망",
		notSummon = "소환 경고",
		notPlagueYou = "자신에게 역병",
		notPlagueOther = "다른 사람에게 역병",
		notExplode = "폭발 경고",	
		notEnrage = "분노 경고",
	} or {
		notBosskill = "Boss death",
		notSummon = "Summon warnings",
		notPlagueYou = "Plague on you",
		notPlagueOther = "Plague on others",
		notExplode = "Explode warning",	
		notEnrage = "Enrage warning",
	},

	optionorder = {"notPlagueYou", "notPlagueOther", "notSummon", "notExplode", "notEnrage", "notBosskill"},



	loc = GetLocale() == "koKR" and {
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
		or GetLocale() == "deDE" and
	{
		disabletrigger = "Besch\195\188tzer des Anubisath stirbt.",
		bosskill = "Besch\195\188tzer des Anubisath wurde besiegt.",

		explodetrigger = "Besch\195\188tzer des Anubisath bekommt 'Explodieren'.",
		explodewarn = "Explodiert! Weg von ihm!",
		enragetrigger = "Besch\195\188tzer des Anubisath bekommt 'Wutanfall'.",
		enragewarn = "Enraged!",
		summonguardtrigger = "Besch\195\188tzer des Anubisath wirkt Schwarmwache des Anubisath beschw\195\182ren.",
		summonguardwarn = "Schwarmwache beschworen",
		summonwarriortrigger = "Besch\195\188tzer des Anubisath wirkt Krieger des Anubisath beschw\195\182ren.",
		summonwarriorwarn = "Krieger beschworen",
		plaguetrigger = "^([^%s]+) ([^%s]+) von Seuche betroffen%.$",
		plaguewarn = " hat die Seuche!",
		plaguewarnyou = "Du hast die Seuche!",
		plagueyou = "Du",
		plagueare = "bist",
	} 
    or 
	{
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
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
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
        if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
        self:Disable()
    end
end

function BigWigsGuardians:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (not self:GetOpt("notExplode") and arg1 == self.loc.explodetrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.explodewarn, "Red")
	elseif (not self:GetOpt("notEnrage") and arg1 == self.loc.enragetrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Red")
	end
end

function BigWigsGuardians:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (not self:GetOpt("notSummon") and arg1 == self.loc.summonguardtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.summonguardwarn, "Yellow")
	elseif (not self:GetOpt("notSummon") and arg1 == self.loc.summonwarriortrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.summonwarriorwarn, "Yellow")
	end
end

if ( GetLocale() == "koKR" ) then
	function BigWigsGuardians:checkPlague()
		local _,_,Player = string.find(arg1, self.loc.plaguetrigger)
		if (Player) then
			if (Player == self.loc.plagueyou) then
				if not self:GetOpt("notPlagueYou") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.plaguewarnyou, "Red", true) end
			else
				_, _, Player = string.find(Player, self.loc.whopattern)
				if not self:GetOpt("notPlagueOther") then
					self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.plaguewarn, "Yellow")
					self:TriggerEvent("BIGWIGS_SENDTELL", Player, self.loc.plaguetell)
				end
			end
		end
	end
else
	function BigWigsGuardians:checkPlague()
		local _,_,Player, Type = string.find(arg1, self.loc.plaguetrigger)
		if (Player and Type) then
			if (Player == self.loc.plagueyou and Type == self.loc.plagueare) then
				if not self:GetOpt("notPlagueYou") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.plaguewarnyou, "Red", true) end
			else
				if not self:GetOpt("notPlagueOther") then
					self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.plaguewarn, "Yellow")
					self:TriggerEvent("BIGWIGS_SENDTELL", Player, self.loc.plaguetell)
				end
			end
		end
	end
end

--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsGuardians:RegisterForLoad()