BigWigsEbonroc = AceAddon:new({
	name          = "BigWigsEbonroc",
	cmd           = AceChatCmd:new({}, {}),

	zonename = "BWL",
	enabletrigger = GetLocale() == "koKR" and "에본로크"
		or GetLocale() == "deDE" and "Schattenschwinge" 
		or "Ebonroc",

	loc = GetLocale() == "koKR" and {
		bossname = "에본로크",
		disabletrigger = "에본로크|1이;가; 죽었습니다.",		
		
		trigger1 = "에본로크|1이;가; 폭풍 날개|1을;를; 시전합니다.",
		trigger2 = "에본로크|1이;가; 암흑의 불길|1을;를; 시전합니다.",
		trigger3 = "^(.*)에본로크의 그림자에 걸렸습니다.",

		you = "",
		are = "are",
		whopattern = "(.+)|1이;가; ", 

		warn1 = "에본로크가 폭풍 날개를 시전합니다!",
		warn2 = "30초후 폭풍 날개!",
		warn3 = "3초후 폭풍 날개!",
		warn4 = "암흑의 불길 경고!",
		warn5 = "당신은 에본로크의 그림자에 걸렸습니다!",
		warn6 = "님이 에본로크의 그림자에 걸렸습니다!",
		bosskill = "에본로크를 물리쳤습니다!",

		bar1text = "폭풍 날개",
	
	} 
		or GetLocale() == "deDE" and 
	{
		bossname = "Schattenschwinge",
		disabletrigger = "Schattenschwinge stirbt.",
	
		trigger1 = "Schattenschwinge beginnt Fl\195\188gelsto\195\159 zu wirken.",
		trigger2 = "Schattenschwinge beginnt Schattenflamme zu wirken.",
		trigger3 = "^([^%s]+) ([^%s]+) betroffen von Schattenschwinges Schatten",
		
		you = "Ihr",
		are = "seid",	
	
		warn1 = "Schattenschwinge beginnt Fl\195\188gelsto\195\159 zu wirken!",
		warn2 = "30 Sekunden bis zum n\195\164chsten Fl\195\188gelsto\195\159!",
		warn3 = "3 Sekunden bis Schattenschwinge Fl\195\188gelsto\195\159 zaubert!",
		warn4 = "Schattenflamme kommt!",
		warn5 = "Du hast Schattenschwinges Schatten!",
		warn6 = " hat Schattenschwinges Schatten!",
		bosskill = "Schattenschwinge wurde besiegt!",
			
		bar1text = "Fluegelgelstoss",
	} 
		or 
	{
		bossname = "Ebonroc",
		disabletrigger = "Ebonroc dies.",

		trigger1 = "Ebonroc begins to cast Wing Buffet",
		trigger2 = "Ebonroc begins to cast Shadow Flame.",
		trigger3 = "^([^%s]+) ([^%s]+) afflicted by Shadow of Ebonroc",

		you = "You",
		are = "are",

		warn1 = "Ebonroc begins to cast Wing Buffet!",
		warn2 = "30 seconds till next Wing Buffet!",
		warn3 = "3 seconds before Ebonroc casts Wing Buffet!",
		warn4 = "Shadow Flame incoming!",
		warn5 = "You have Shadow of Ebonroc!",
		warn6 = " has Shadow of Ebonroc!",
		bosskill = "Ebonroc has been defeated!",

		bar1text = "Wing Buffet",
	},
})

function BigWigsEbonroc:Initialize()
	self.disabled = true
	BigWigs:RegisterModule(self)
end

function BigWigsEbonroc:Enable()
	self.disabled = nil
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")
	self:RegisterEvent("BIGWIGS_MESSAGE")
end

function BigWigsEbonroc:Disable()
	self.disabled = true
	self:UnregisterAllEvents()
	self:TriggerEvent("BIGWIGS_BAR_CANCEL", self.loc.bar1text)
	self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_CANCEL", self.loc.warn3)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 10)
	self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_CANCEL", self.loc.bar2text, 20)
end

function BigWigsEbonroc:CHAT_MSG_COMBAT_HOSTILE_DEATH()
	if (arg1 == self.loc.disabletrigger) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.bosskill, "Green")
		self:Disable()
	end
end

function BigWigsEbonroc:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE()
	if (string.find(arg1, self.loc.trigger1)) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn1, "Red")
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn2, "Yellow")
		self:TriggerEvent("BIGWIGS_DELAYEDMESSAGE_START", self.loc.warn3, 29, "Red")
		self:TriggerEvent("BIGWIGS_BAR_START", self.loc.bar1text, 32, 1, "Yellow", "Interface\\Icons\\Spell_Fire_SelfDestruct")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 10, "Orange")
		self:TriggerEvent("BIGWIGS_BAR_DELAYEDSETCOLOR_START", self.loc.bar1text, 20, "Red")
	elseif (arg1 == self.loc.trigger2) then
		self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn4, "Red")
	end
end

if ( GetLocale() == "koKR" ) then 
	function BigWigsEbonroc:Event()
		local _,_, EPlayer = string.find(arg1, self.loc.trigger3)
		if (EPlayer) then
			if (EPlayer == self.loc.you) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red", true)
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red", true)
			else
				local _,_, EWho = string.find(EPlayer, self.loc.whopattern)
				self:TriggerEvent("BIGWIGS_MESSAGE", EWho .. self.loc.warn6, "Yellow")
			end
		end
	end
else	
	function BigWigsEbonroc:Event()
		local _,_, EPlayer, EType = string.find(arg1, self.loc.trigger3)
		if (EPlayer and EType) then
			if (EPlayer == self.loc.you and EType == self.loc.are) then
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red", true)
				self:TriggerEvent("BIGWIGS_MESSAGE", self.loc.warn5, "Red", true)
			else
				self:TriggerEvent("BIGWIGS_MESSAGE", EPlayer .. self.loc.warn6, "Yellow")
			end
		end
	end
end
--------------------------------
--      Load this bitch!      --
--------------------------------
BigWigsEbonroc:RegisterForLoad()