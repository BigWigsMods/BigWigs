local bboss = BabbleLib:GetInstance("Boss 1.2")

BigWigsDefenders = AceAddon:new({
	name          = "BigWigsDefenders",
	cmd           = AceChatCmd:new({}, {}),

	zonename = BabbleLib:GetInstance("Zone 1.2")("Temple of Ahn'Qiraj"),
	enabletrigger = bboss("Anubisath Defender"),
	bossname = bboss("Anubisath Defender"),

	toggleoptions = {
		notBosskill = "Boss death",
		notSummonWarn = "Summon warnings",
		notPlagueYou = "Plague on you",
		notPlagueOther = "Plague on others",
		notThunderclap = "Thunderclap warning",
		notExplode = "Explode warning",	
		notEnrage = "Enrage warning",
	},

	optionorder = {"notPlagueYou", "notPlagueOther", "notSummonWarn", "notThunderclap", "notExplode", "notEnrage", "notBosskill"},


	loc = GetLocale() == "koKR" and {
		disabletrigger = "아누비사스 문지기|1이;가; 죽었습니다.",
		bosskill = "아누비사스 문지기를 물리쳤습니다.",

		explodetrigger = "아누비사스 문지기|1이;가; 폭파 효과를 얻었습니다.",
		explodewarn = "폭파! 떨어지세요!",
		enragetrigger = "아누비사스 문지기|1이;가; 분노 효과를 얻었습니다.",
		enragewarn = "분노 돌입!",
		summonguardtrigger = "아누비사스 문지기|1이;가; 아누비사스 감시병 소환|1을;를; 시전합니다.",
		summonguardwarn = "감시병 소환",
		summonwarriortrigger = "아누비사스 문지기|1이;가; 아누비사스 전사 소환|1을;를; 시전합니다.",
		summonwarriorwarn = "전사 소환",

		plaguetrigger = "(.*)역병에 걸렸습니다.",
		plaguewarn = "님은 역병에 걸렸습니다. 피하세요",
		plagueyouwarn = "당신은 역병에 걸렸습니다! 떨어지세요!",
		
		plagueyou = "",
		plagueare = "are",
		whopattern = "(.+)|1이;가; ",
		
		thunderclaptrigger = "아누비사스 문지기|1이;가; 천둥벼락|1으로;로; (.+)에게 (%d+)의", 
		thunderclapwarn = "천둥벼락! - 멀리 떨어지세요",		
			
		-- 암흑 폭풍, = 몹에 가까이 붙으세요. 
		-- 천둥벼락, = 몹에서 떨어지세요. 
		-- 유성 = 뭉치세요. 		
	}
		or GetLocale() == "zhCN" and
	{
		disabletrigger = "阿努比萨斯防御者死亡了。",
		bosskill = "阿努比萨斯防御者被击败了！",

		explodetrigger = "阿努比萨斯防御者获得了爆炸的效果。",
		explodewarn = "即将爆炸！近战躲开！",
		enragetrigger = "阿努比萨斯防御者获得了狂怒的效果。",
		enragewarn = "进入狂怒状态！",
		summonguardtrigger = "阿努比萨斯防御者施放了召唤阿努比萨斯虫群卫士。",
		summonguardwarn = "虫群卫士已被召唤出来",
		summonwarriortrigger = "阿努比萨斯防御者施放了召唤阿努比萨斯战士。",
		summonwarriorwarn = "阿努比萨斯战士已被召唤出来",
		plaguetrigger = "^(.+)受(.+)了瘟疫效果的影响。$",
		plaguewarn = "受到瘟疫的影响！快躲开！",
		plagueyouwarn = "你受到瘟疫的影响！快跑开！",
		plagueyou = "你",
		plagueare = "到",
		thunderclaptrigger = "^阿努比萨斯防御者的雷霆一击击中(.+)造成%d+点伤害。",
		thunderclapwarn = "雷霆一击发动！",
	}
		or
	{
		disabletrigger = "Anubisath Defender dies.",
		bosskill = "Anubisath Defender has been defeated.",

		explodetrigger = "Anubisath Defender gains Explode.",
		explodewarn = "Exploding! Run away!",
		enragetrigger = "Anubisath Defender gains Enrage.",
		enragewarn = "Enraged!",
		summonguardtrigger = "Anubisath Defender casts Summon Anubisath Swarmguard.",
		summonguardwarn = "Swarmguard Summoned",
		summonwarriortrigger = "Anubisath Defender casts Summon Anubisath Warrior.",
		summonwarriorwarn = "Warrior Summoned",
		plaguetrigger = "^([^%s]+) ([^%s]+) afflicted by Plague%.$",
		plaguewarn = " has the Plague! Keep away!",
		plagueyouwarn = "You got the plague! Run away!",
		plagueyou = "You",
		plagueare = "are",
		thunderclaptrigger = "^Anubisath Defender's Thunderclap hits ([^%s]+) for %d+%.",
		thunderclapwarn = "Thunderclap!",
	},
})

function BigWigsDefenders:Initialize()
	self.disabled = true
	self:TriggerEvent("BIGWIGS_REGISTER_MODULE", self)
end

function BigWigsDefenders:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "checkPlague")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "Thunderclap")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "Thunderclap")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "Thunderclap")
end

function BigWigsDefenders:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
end

function BigWigsDefenders:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		if not self:GetOpt("notBosskill") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green", nil, "Victory") end
		self:Disable()
	end
end

function BigWigsDefenders:CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS()
	if (not self:GetOpt("notExplode") and arg1 == self.loc.explodetrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.explodewarn, "Red")
	elseif (not self:GetOpt("notEnrage") and arg1 == self.loc.enragetrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.enragewarn, "Red")
	end
end

function BigWigsDefenders:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_BUFF()
	if (not self:GetOpt("notSummon") and arg1 == self.loc.summonguardtrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.summonguardwarn, "Yellow")
	elseif (not self:GetOpt("notSummon") and arg1 == self.loc.summonwarriortrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.summonwarriorwarn, "Yellow")
	end
end

if (GetLocale() == "koKR") then
	function BigWigsDefenders:checkPlague()
		local _,_, Player = string.find(arg1, self.loc.plaguetrigger)
		if (Player) then
			if (Player == self.loc.plagueyou) then
				if not self:GetOpt("notPlagueYou") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.plagueyouwarn, "Red", true) end
			else
				local _,_, Who = string.find(Player, self.loc.whopattern)
				if not self:GetOpt("notPlagueOther") then
					self:TriggerEvent("BIGWIGS_MESSAGE", Who .. self.loc.plaguewarn, "Yellow")
					self:TriggerEvent("BIGWIGS_SENDTELL", Who, self.loc.plagueyouwarn)
				end
			end
		end
	end
else
	function BigWigsDefenders:checkPlague()
		local _,_, Player, Type = string.find(arg1, self.loc.plaguetrigger)
		if (Player and Type) then
			if (Player == self.loc.plagueyou and Type == self.loc.plagueare) then
				if not self:GetOpt("notPlagueYou") then self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.plagueyouwarn, "Red", true) end
			else
				if not self:GetOpt("notPlagueOther") then
					self:TriggerEvent("BIGWIGS_MESSAGE", Player .. self.loc.plaguewarn, "Yellow")
					self:TriggerEvent("BIGWIGS_SENDTELL", Player, self.loc.plagueyouwarn)
				end
			end
		end
	end
end

function BigWigsDefenders:Thunderclap()
	if (not self:GetOpt("notThunderclap") and string.find(arg1, self.loc.thunderclaptrigger)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.thunderclapwarn, "Yellow")
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsDefenders:RegisterForLoad()