local _, addonTbl = ...
local L = addonTbl.API:NewLocale("BigWigs: Common", "zhCN")
if not L then return end

-- Prototype.lua common words
L.you = "你：%s"
L.you_icon = "|T13700%2$d:0|t你：%1$s"
L.underyou = "%s在你脚下"
L.aboveyou = "%s在你面前"
L.other = "%s：%s"
L.onboss = "首领：%s"
L.buff_boss = "首领增益：%s"
L.buff_other = "%s获得增益：%s"
L.magic_buff_boss = "首领魔法增益: %s" -- Magic buff on BOSS: SPELL_NAME
L.magic_buff_other = "%s获得魔法增益: %s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s：%s"
L.stack = "%3$s：%1$d层%2$s" -- "5x SPELL_NAME on PLAYER_OR_NPC" showing how many stacks of a buff/debuff are on a player or NPC
L.stackyou = "你：%d层%s" -- "5x SPELL_NAME on YOU" showing how many stacks of a buff/debuff are on you
L.stackboss = "首领：%d层%s" -- "5x SPELL_NAME on BOSS" showing how many stacks of a buff/debuff are on the boss
L.stack_gained = "获得 %d层" -- "Gained 5x" for situations where we show how many stacks of a buff were gained since last time a message showed
L.cast = "<施放：%s>"
L.casting = "正在施放：%s"
L.soon = "即将：%s"
L.count = "%s（%d）"
L.count_amount = "%s（%d/%d）"
L.count_icon = "%s（%d|T13700%d:0|t）"
L.count_rticon = "%s（%d{rt%d}）"
L.rticon = "%s（{rt%d}）"
L.near = "%s在你附近"
L.on_group = "队伍：%s" -- spell on group
L.boss = "首领"
L.plus = "%s + %s" -- Spell 1 + Spell 2
L.extra = "%s（%s）" -- SPELL_NAME (short spell name or extra information)

L.phase = "第%d阶段"
L.stage = "第%d阶段"  -- SCENARIO_STAGE 对齐暴雪本地化
L.wave = "第%d波" -- e.g. "Wave 1" (Waves of adds)
L.wave_count = "第%d波次，共%d波次" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "普通模式"
L.heroic = "英雄模式"
L.mythic = "史诗模式"
L.hard = "困难模式"
L.active = "激活" -- When a boss becomes active, after speech finishes
L.ready = "就绪" -- When a player is ready to do something
L.dead = "死亡" -- When a player is dead
L.general = "通用" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.health = "血量" -- The health of an NPC
L.health_percent = "%d%% 血量" -- "10% Health" The health percentage of an NPC
L.energy = "能量"
L.energy_percent = "%d%% 能量" -- "80% Energy" The energy percentage of an NPC
L.door_open = "开门" -- When a door is open, usually after a speech from an NPC
L.gate_open = "开门" -- When a gate is open, usually after a speech from an NPC
L.threat = "威胁"

L.remaining = "剩余：%d" -- 5 remaining
L.duration = "%s持续%s秒" -- Spell for 10 seconds
L.over = "%s结束" -- Spell Over
L.removed = "%s移除" -- Spell Removed
L.removed_from = "%2$s已移除%1$s" -- Spell removed from Player
L.removed_by = "%s被%s移除" -- Spell removed by Player
L.removed_after = "%s移除，用时 %.1f 秒" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "即将：%s" -- Spell Incoming
L.interrupted = "已打断%s" -- Spell Interrupted
L.interrupted_by = "%2$s已打断%1$s" -- Spell interrupted by Player
L.interruptible = "可打断" -- when a spell is interruptible
L.no = "缺少：%s" -- No Spell
L.intermission = "转阶段"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s取消" -- Spell Cancelled
L.you_die = "你会死亡" -- You will die
L.you_die_sec = "%d秒后死亡" -- "You die in 15 sec" (sec = seconds)
L.next_ability = "下个技能" -- We don't know what ability will be next, we only know when it will happen (showing a bar)
L.boss_landing = "%s正在着陆" -- "NPC_NAME is landing" Used when a flying NPC/dragon/boss is landing
L.landing = "着陆" -- Used when a flying NPC/dragon/boss is landing
L.flying_available = "可以起飞"  --改为简短提示
L.bosses_too_close = "首领距离过近" -- When 2 or more bosses are too close to each other, buffing each other with a shield, extra damage, etc.
L.keep_moving = "保持移动" -- An ability that forces you to keep moving or you will take damage
L.stand_still = "禁止移动" -- An ability that forces you to stand still or you will take damage
L.safe_to_stop = "停止移动" -- When an ability that forces you to keep moving fades from you, allowing you to stop moving
L.safe_to_move = "可以移动" -- When an ability to forces you to stand still fades from you, allowing you to move again
L.safe = "安全" -- You are safe from a bad ability
L.unsafe = "危险" -- You are unsafe (in danger) of a bad ability

-- Add related
L.add_spawned = "增援出现" -- singular
L.adds_spawned = "增援出现" -- plural
L.adds_spawned_count = "%d增援出现" -- 1 add spawned / 2 adds spawned
L.add_spawning = "增援出现" -- singular
L.adds_spawning = "增援出现" -- plural
L.spawned = "%s已刷新"
L.spawning = "%s出现"
L.next_add = "下一波增援"
L.add_killed = "增援已击杀（%d/%d）"
L.add_remaining = "增援已击杀，剩余 %d"
L.add = "增援"
L.adds = "增援"
L.big_add = "大型增援" -- singular
L.big_adds = "大型增援" -- plural
L.small_add = "小型增援" -- singular
L.small_adds = "小型增援" -- plural

-- Mob related
L.killed = "%s已击杀"
L.mob_killed = "%s已击杀（%d/%d）"
L.mob_remaining = "%s已击杀，剩余%d"

-- NPCs for follower dungeons
L.garrick = "嘉里克船长" -- AI paladin tank (NPC 209057)
L.garrick_short = "*嘉里克"
L.meredy = "梅瑞迪·寻涌" -- AI mage dps (NPC 209059)
L.meredy_short = "*梅瑞迪"
L.shuja = "修加·恐斧" -- AI shaman dps (NPC 214390)
L.shuja_short = "*修加"
L.crenna = "科蕾娜·大地之女" -- AI druid healer (NPC 209072)
L.crenna_short = "*科蕾娜"
L.austin = "奥斯汀·哈克斯沃斯" -- AI hunter dps (NPC 209065)
L.austin_short = "*奥斯汀"
L.breka = "督军布雷卡·恐斧" -- AI warrior tank (NPC 215517)
L.breka_short = "*布雷卡"
L.henry = "亨利·嘉里克" -- AI priest healer (NPC 215011)
L.henry_short = "*亨利"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%1$s激活 - %3$d分后%2$s"
L.custom_start_s = "%1$s激活 - %3$d秒后%2$s"
L.custom_end = "%s - %s"
L.custom_min = "%2$d分后%1$s"
L.custom_sec = "%2$d秒后%1$s"

L.focus_only = "|cffff0000仅焦点目标。|r "
L.trash = "小怪"
L.affixes = "词缀" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "%s标记"
L.marker_player_desc = "将受到%s影响的玩家标记为%s，需要权限。" -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "将%s标记为%s，需要权限。" -- Mark NPC_NAME with SKULL_ICON
L.marker_npc_aura_desc = "将受到%s影响的NPC标记为%s，需要权限。" -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON
L.disabled = "禁用"
L.none = "无"
L.markers = "标记" -- Plural of marker

-- Ability where two players have to move close to each other
L.link = "连接"
L.link_with = "与%s连接"
L.link_with_icon = "与|T13700%d:0|t%s连接"
L.link_with_rticon = "{rt%d}与%s连接"
L.link_both = "%s与%s连接"
L.link_both_icon = "|T13700%d:0|t%s与|T13700%d:0|t%s连接"
L.link_removed = "连接已移除"
L.link_say_option_name = "重复“连接”信息"
L.link_say_option_desc = "以重复喊话方式来发送信息，说明正在与谁连接。"

-- Abbreviated numbers
L.amount_one = "%.2f亿" -- Billions 1,000,000,000
L.amount_two = "%.1f万" -- Millions 1,000,000
L.amount_three = "%d千" -- Thousands 1,000
L.seconds = "%.1f秒" -- 1.1 seconds

-- Directions
L.top = "上"
L.top_right = "右上"
L.top_left = "左上"
L.up = "向上"
L.middle = "中"
L.down = "向下"
L.bottom = "下"
L.bottom_right = "右下"
L.bottom_left = "左下"
L.left = "左"
L.right = "右"
L.north = "北"
L.north_east = "东北"
L.east = "东"
L.south_east = "东南"
L.south = "南"
L.south_west = "西南"
L.west = "西"
L.north_west = "西北"

-- Sizes
L.small = "小"
L.medium = "中"
L.large = "大"

-- Schools
L.fire = "火焰"
L.frost = "冰霜"
L.shadow = "暗影"
L.nature = "自然"
L.arcane = "奥术"

-- Autotalk
L.autotalk = "自动与NPC对话"
L.autotalk_boss_desc = "自动选择NPC对话选项以开启首领战。"
L.autotalk_generic_desc = "自动选择NPC对话选项以进入下一阶段。"
L.autotalk_notice = "自动与NPC %s 交互。"

-- GUI notes
L.intermissionOnly = "仅转阶段" -- A note to explain that a specific ability only happens during the intermission stage of a boss fight
L.stage1Only = "仅第1阶段" -- A note to explain that a specific ability only happens during stage 1 of a boss fight
L.stage2Only = "仅第2阶段"
L.stage3Only = "仅第3阶段"

-- GUI notes for renames
L.generalNote = "通用说明文本"
L.timerNote = "计时条中显示的文本"
L.castTimerNote = "施法计时条中显示的文本"
L.messageCastOverNote = "施法结束时显示的消息文本"
L.messageCastStartNote = "施法开始时显示的消息文本"
L.messageNote = "消息中显示的文本"
L.messageOnYouNote = "技能点名你时显示的消息"
L.timerOnYouNote = "技能点名你时计时条中显示的文本"
L.mythicOnlyNote = "史诗难度下显示的文本"
L.otherDifficultiesNote = "其他难度下显示的文本"

-- GUI notes for debuffs
L.debuffFailureNote = "机制失败时受到的减益效果"
L.debuffFailureMoveFromExplosionNote = "未能脱离爆炸范围时会受到此效果"
L.preDebuffNote = "主要减益来临前的预警效果"
L.mainDebuffNote = "受到的主要减益效果"
L.postDebuffNote = "|cFFFFFFFF%s|r结束后，此效果便会触发" -- This debuff will apply to you after OTHER_DEBUFF expires
L.debuffUnderYouNote = "处于危险区域内会受到减益效果" -- Usually when a player is standing in a pool of something bad, a debuff will apply to them
L.debuffDotAfterCastNote = "首领施放 |cFFFFFFFF%s|r 后，此效果将持续造成伤害" -- This debuff is a damage over time effect after the boss finishes casting SPELL_NAME
L.debuffPossibleAfterCastNote = "首领施放 |cFFFFFFFF%s|r 后，你可能会受到此效果" -- This debuff might apply to you after the boss finishes casting SPELL_NAME
L.debuffWalkIntoObjectNote = "主动触碰 |cFFFFFFFF%s|r 会受到此效果" -- This debuff will apply to you if you purposely walk into the OBJECT_NAME (e.g. trap, mine, bomb)
L.debuffAddsCast = "此效果由 |cFFFFFFFF%s|r 施加" -- This debuff is applied to you by NPC_NAME

-- Common ability name replacements
L.absorb = "吸收盾" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "治疗吸收盾" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "治疗吸收盾" -- Plural of L.heal_absorb
L.laser = "激光" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "激光" -- Plural of L.lasers
L.beam = "射线" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "射线" -- Plural of L.beam
L.bomb = "炸弹" -- Used for debuffs that make players explode
L.bombs = "炸弹" -- Plural of L.bomb
L.explosion = "爆炸" -- When the explosion from a bomb-like ability will occur
L.explosions = "爆炸" -- Plural of L.explosion
L.knockback = "击退" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.knockbacks = "击退" -- Plural of L.knockback
L.pushback = "推开" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "陷阱" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "流星" -- This one will probably only ever be used for actual meteors
L.shield = "护盾" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "传送" -- A boss/add/etc teleported somewhere
L.breath = "吐息" -- When a boss breathes fire/frost/etc on to a player or the raid e.g. a Dragon breathing fire on everyone
L.roar = "咆哮" -- When a boss opens their mouth to let out a loud roar, sometimes used to inflict damage on the raid
L.leap = "跳跃" -- When a boss leaps through the air from one location to another location, or from a location to a player, etc
L.charge = "冲锋" -- When a boss select a new target and charges at it quickly, in the same way someone playing a warrior can charge at a target
L.full_energy = "满能量" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
L.weakened = "虚弱" -- When a boss becomes weakened and sometimes takes extra damage, usually the "hit all your cooldowns" part of the fight
L.immune = "免疫" -- When a boss becomes immune to all damage and you can no longer hurt it
L.stunned = "昏迷" -- When a boss becomes stunned and cannot cast abilities or move
L.pool = "水池" -- A pool or puddle on the ground, usually something bad that you should avoid standing in
L.pools = "水池" -- Plural of L.pool
L.totem = "图腾" -- A totem, usually summoned by a boss, the same thing that shamans summon
L.totems = "图腾" -- Plural of L.totem
L.portal = "传送门" -- A portal somewhere, usually leading to a different location
L.portals = "传送门" -- Plural of L.portal
L.rift = "裂隙" -- Can be used in a similar way as a portal e.g. "Time Rift" but can also be used as a debuff/pool underneath you that you need to run through to remove/despawn it e.g. "Dread Rift"
L.rifts = "裂隙" -- Plural of L.rift
L.orb = "宝珠" -- A ball/sphere object usually moving and you need to avoid it
L.orbs = "宝珠" -- Plural for L.orb
L.spirit = "精魂" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "精魂" -- Plural of L.spirit
L.tornado = "旋风" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "旋风" -- Plural of L.tornado
L.frontal_cone = "正面技能" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.mark = "印记" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "印记" -- Plural of L.marks
L.mind_control = "精神控制" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "精神控制" -- Short version of Mind Control, mainly for bars
L.spell_reflection = "法术反射" -- Any ability that reflects spells
L.rooted = "定身" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
L.arrow = "箭矢" -- Any type of ability that looks like an arrow, or has "arrow" in the name. Like an archer's arrow.
L.arrows = "箭矢" -- Plural of L.arrow
L.ball = "球" -- A ball, like a football, basketball, etc
L.balls = "球" -- Plural of L.ball
L.blind = "致盲" -- Any ability that blinds or disorientates you. Usually an ability a boss casts and you need to turn away from the boss or it will blind you.
L.chakram = "飞轮" -- Short for any ability with the name "Chakram" in it e.g. "Wind Chakram" (1258152) or "Solar Chakram" (186046)
L.dodge = "躲开" -- When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.enrage = "激怒" -- Any enrage buff that can be removed by players using abilities like Soothe (Druid), Tranquilizing Shot (Hunter) and Shiv (Rogue)
L.fear = "恐惧" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.fixate = "锁定" -- Used when a boss or add is chasing/fixated on a player
L.fixates = "锁定" -- Plural of L.fixate
L.group_damage = "群体伤害" -- Any ability that causes damage to every player in the 5 player group 也可以称“AOE”
L.health_drain = "吸血" -- Any ability that drains health from the player
L.madness = "疯狂" -- Any ability that contains the word "Madness" in it e.g. "Rift Madness" (1264756) or "Burning Madness" (307013)
L.parasite = "寄生" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.parasites = "寄生" -- Plural of L.parasite
L.pull_in = "拉扯" -- An ability that pulls you in towards the boss against your will
L.quills = "飞羽" -- Short for any ability with the name "Quills" in it e.g. "Searing Quills" (159382) or "Infused Quills" (1242260)
L.raid_damage = "群体伤害" -- Any ability that causes damage to every player in the raid 也可以称“AOE”
L.smash = "重击" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.soak = "分摊" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "分摊" -- Plural of L.soak
L.spike = "尖刺" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "尖刺" -- Plural of L.spike
L.spread = "分散" -- An ability that forces you to spread out away from other players, or you might damage them
L.stomp = "践踏" -- Short for any ability with the name "Stomp" in it e.g. "Cryostomp" (1261847) or "Powerful Stomp" (296691)
L.tentacle = "触手" -- Used for bosses that summon tentacles
L.tentacles = "触手" -- Plural of L.tentacle
L.waves = "波浪" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean
L.whelp = "雏龙" -- Short for Whelpling, a baby dragonkin (Dragon Whelp)
L.whelps = "雏龙" -- Plural of L.whelp

-- Debuff-related spell renames
L.debuffs = "减益"  -- 减益效果
L.fire_debuffs = "火焰减益"  -- “火焰减益效果”长删“效果”

-- Dispel-related spell renames
L.curse = "诅咒" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "诅咒" -- Plural of L.curse
L.disease = "疾病" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.dispel = "驱散" -- General term for any debuff that is dispellable
L.dispels = "驱散" -- Plural of L.dispel
L.poison = "中毒" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.bleed = "流血" -- Any bleed-type debuff
L.bleeds = "流血" -- Plural of L.bleed

-- Clearing-related spell renames (when you get a buff that allows you to clear/cleanse/remove other objects in the world, like pools on the ground, traps, or bombs)
L.clear_bombs = "清除炸弹"
L.clear_pools = "清除水渍"

-- Interrupt-related spell renames
L.interrupts = "打断" -- General term used when a player needs to interrupt a spell being cast
L.kick = "打断" -- General term used when a player needs to interrupt a spell being cast, named after spell "Kick" (1766) from the Rogue class
L.kicks = "打断" -- Plural of L.kick

-- Tank-related spell renames
L.tank_bomb = "坦克炸弹" -- Similar to L.bomb but only applies to tanks
L.tank_combo = "连击坦克" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.tank_debuff = "坦克减益" -- Used for debuffs that only apply to tanks, usually an indicator that you need to taunt
L.tank_frontal = "坦克正面" -- Similar to L.frontal_cone but only applies to tanks
L.tank_hit = "命中坦克" -- An attack that will only target the tank, usually a spell that does a lot of heavy damage to the tank
L.tank_knockback = "坦克击退" -- Similar to L.knockback but only applies to tanks"
L.tank_soak = "坦克分摊" -- Similar to L.soak but only applies to tanks
L.tank_grip = "拉拽坦克" -- When a boss grapples the tank towards them. We use "Grip" because of the Death Knight ability "Death Grip" (49576) but you can use "Grapple" if it makes more sense
