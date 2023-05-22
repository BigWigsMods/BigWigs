local L = BigWigs:NewBossLocale("Eranog", "koKR")
if not L then return end
if L then
	 L.custom_on_nameplate_fixate = "시선 고정 네임플레이트 아이콘"
	 L.custom_on_nameplate_fixate_desc = "당신에게 시선이 고정된 타라세크의 네임플레이트에 아이콘을 표시합니다.\n\n 네임플레이트를 지원하는 애드온(KuiNameplates, Plater)을 사용하고 적 네임플레이트가 활성화된 상태여야함."

	 L.molten_cleave = "전방기"
	 L.incinerating_roar = "포효"
	 L.molten_spikes = "쐐기"
	 L.collapsing_army = "쫄 소환"
	 L.greater_flamerift = "신화 쫄"
	 L.leaping_flames = "불꽃"
end

L = BigWigs:NewBossLocale("Terros", "koKR")
if L then
	 L.rock_blast = "같이 맞아주기"
	 L.resonating_annihilation = "절멸 - 잔해 조심"
	 L.awakened_earth = "기둥 생성"
	 L.shattering_impact = "충격 - 잔해 조심"
	 L.concussive_slam = "탱커 조심"
	 L.infused_fallout = "낙진"

	 --L.custom_on_repeating_fallout = "Repeating Infused Fallout"
	 --L.custom_on_repeating_fallout_desc = "Repeating Infused Fallout say messages with icon {rt7} to find a partner."
end

L = BigWigs:NewBossLocale("The Primal Council", "koKR")
if L then
	 L.primal_blizzard = "눈보라" -- Primal Blizzard
	 L.earthen_pillars = "기둥" -- Earthen Pillars
	 L.meteor_axes = "도끼" -- Meteor Axes
	 L.meteor_axe = "도끼" -- Singular
	 L.meteor_axes_melee = "근딜 도끼"
	 L.meteor_axes_ranged = "원딜 도끼"
	 L.conductive_marks = "표식" -- Conductive Marks
	 L.conductive_mark = "표식" -- Singular

	 -- L.skipped_cast = "Skipped %s (%d)"
end

L = BigWigs:NewBossLocale("Sennarth, The Cold Breath", "koKR")
if L then
	 L.ascend = "올라감"
	 L.ascend_desc = "세나스가 얼어붙은 절벽쪽으로 올라갑니다."
	 L.chilling_blast = "산개"
	 L.freezing_breath = "쫄 브레스"
	 L.webs = "거미줄"
	 L.web = "거미줄"
	 L.gossamer_burst = "낙사 조심"
	 L.repelling_burst = "넉백"
end

L = BigWigs:NewBossLocale("Dathea, Ascended", "koKR")
if L then
	 L.conductive_marks = "표식"
	 L.conductive_mark = "표식"
	 L.raging_burst = "회오리 생성"
	 L.cyclone = "당기기"
	 L.crosswinds = "회오리 재배치"
end

L = BigWigs:NewBossLocale("Kurog Grimtotem", "koKR")
if L then
	 -- Types
	 L.damage = "피해를 주는 능력"
	 L.damage_desc = "넴드가 어떤 제단에 있는지 모를 때에 피해를 주는 능력들(마그마 폭발, 살을 에는 추위, 좁혀드는 대지, 번개 충돌)에 대한 타이머 표시."
	 L.damage_bartext = "%s [데미지]" -- {Spell} [Dmg]

	 L.avoid = "피해야 하는 능력"
	 L.avoid_desc = "넴드가 어떤 제단에 있는지 모를 때에 피해야 하는 능력들 (녹아내린 파열, 혹한의 기류, 분출하는 기반암, 충격의 파열)에 대한 타이머 표시."
	 L.avoid_bartext = "%s [피하기]" -- {Spell} [Avoid]

	 L.ultimate = "궁극기"
	 L.ultimate_desc = "넴드가 어떤 제단에 있는지 모를 때에 궁극기들 (이글거리는 살육, 절대 영점, 지진 파열, 천둥번개)에 대한 타이머 표시 ."
	 L.ultimate_bartext = "%s [궁극기]" -- {Spell} [Ult]

	 L.add_bartext = "%s [추가 몹]" -- "{Spell} [Add]"

	L.Fire = "화염"
	L.Frost = "냉기"
	L.Earth = "대지"
	L.Storm = "폭풍"

	 -- 불
	 L.magma_burst = "웅덩이 생성"
	 L.molten_rupture = "웨이브 조심"
	 L.searing_carnage = "살육"
	  L.raging_inferno = "불지옥 바닥 밟기"

	 -- 냉기
	 L.biting_chill = "추위 도트"
	 L.frigid_torrent = "구슬 방출"
	 L.absolute_zero = "같이 맞아주기"
	 L.absolute_zero_melee = "근딜 나눠맞기"
	 L.absolute_zero_ranged = "원딜 나눠맞기"

	 -- 대지
	 L.enveloping_earth = "치유 흡수"
	 L.erupting_bedrock = "지진 넉백"

	 -- 폭풍
	 L.lightning_crash = "번개 충돌"
	 L.thundering_strike = "맞아주기"

	 -- 일반
	 L.primal_attunement = "미니 광폭"

	 -- Stage 2
	 L.violent_upheaval = "기둥 "
end

L = BigWigs:NewBossLocale("Broodkeeper Diurna", "koKR")
if L then
	 L.eggs_remaining = "알 %d 개 남음!"
	 L.broodkeepers_bond = "알 남아있음"
	 L.greatstaff_of_the_broodkeeper = "대지팡이"
	 L.greatstaffs_wrath = "레이저"
	 L.clutchwatchers_rage = "분노"
	 L.rapid_incubation = "급속 배양"
	 L.icy_shroud = "치유량 흡수 껍질"
	 L.broodkeepers_fury = "분노"
	 L.frozen_shroud = "속박"
	  L.detonating_stoneslam = "탱커 나눠맞기"
end

L = BigWigs:NewBossLocale("Raszageth the Storm-Eater", "koKR")
if L then
	-- L.lighting_devastation_trigger = "deep breath" -- Raszageth takes a deep breath...

	-- Stage One: The Winds of Change
	-- L.hurricane_wing = "Pushback"
	-- L.volatile_current = "Sparks"
	-- L.thunderous_blast = "Blast"
	-- L.lightning_breath = "Breath"
	-- L.lightning_strikes = "Strikes"
	-- L.electric_scales = "Raid Damage"
	-- L.electric_lash = "Lash"
	-- Intermission: The Primalist Strike
	-- L.lightning_devastation = "Breath"
	-- L.shattering_shroud = "Heal Absorb"
	-- Stage Two: Surging Power
	-- L.absorb_text = "%s (%.0f%%)"
	-- L.stormsurge = "Absorb Shield"
	-- L.stormcharged = "Positive or Negative"
	-- L.positive = "Positive"
	-- L.negative = "Negative"
	-- L.focused_charge = "Damage Buff"
	-- L.tempest_wing = "Storm Wave"
	-- L.fulminating_charge = "Charges"
	-- L.fulminating_charge_debuff = "Charge"
	-- Intermission: The Vault Falters
	-- L.storm_break = "Teleport"
	-- L.ball_lightning = "Balls"
	-- Stage Three: Storm Incarnate
	-- L.magnetic_charge = "Pull Charge"

	-- L.custom_on_repeating_stormcharged = "Repeating Positive or Negative"
	-- L.custom_on_repeating_stormcharged_desc = "Repeating Positive or Negative say messages with icons {rt1}, {rt3} to find matches to remove your debuffs."

	-- L.skipped_cast = "Skipped %s (%d)"

	-- L.custom_off_raidleader_devastation = "Lighting Devastation: Leader Mode"
	-- L.custom_off_raidleader_devastation_desc = "Show a bar for the Lighting Devastation (Breath) on the other side as well."
	-- L.breath_other = "%s [Opposite]" -- Breath on opposite platform
end

L = BigWigs:NewBossLocale("Vault of the Incarnates Trash", "koKR")
if L then

end
