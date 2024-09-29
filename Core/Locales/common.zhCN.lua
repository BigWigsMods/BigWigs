local L = BigWigsAPI:NewLocale("BigWigs: Common", "zhCN")
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
L.stack = "%3$s：%1$d层%2$s"
L.stackyou = "你：%d层%s"
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

L.phase = "阶段：%d"
L.stage = "阶段：%d"
L.wave = "第%d波" -- e.g. "Wave 1" (Waves of adds)
L.wave_count = "第%d波，共%d波" -- Wave 1 of 3 (Usually waves of adds)
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
L.door_open = "门开了" -- When a door is open, usually after a speech from an NPC
L.gate_open = "门开了" -- When a gate is open, usually after a speech from an NPC
L.threat = "威胁"
L.energy = "能量"

L.remaining = "剩余：%d" -- 5 remaining
L.duration = "%s持续 %s 秒" -- Spell for 10 seconds
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
L.intermission = "阶段转换"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s取消" -- Spell Cancelled
L.you_die = "你将死亡" -- You will die
L.you_die_sec = "你将在%d秒后死亡" -- "You die in 15 sec" (sec = seconds)
L.next_ability = "下个技能" -- We don't know what ability will be next, we only know when it will happen (showing a bar)
L.landing = "%s 正在着陆" -- "NPC_NAME is landing" Used when a flying NPC/dragon/boss is landing
L.flying_available = "可以起飞"  --改为简短提示

-- Add related
L.add_spawned = "增援出现" -- singular
L.adds_spawned = "增援出现" -- plural
L.adds_spawned_count = "%d 增援出现" -- 1 add spawned / 2 adds spawned
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
L.mob_remaining = "%s已击杀，剩余 %d"

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

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%1$s激活 - %3$d分后%2$s"
L.custom_start_s = "%1$s激活 - %3$d秒后%2$s"
L.custom_end = "%s - %s"
L.custom_min = "%2$d分后%1$s"
L.custom_sec = "%2$d秒后%1$s"

L.focus_only = "|cffff0000只警报焦点目标。|r "
L.trash = "小怪"
L.affixes = "词缀" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "%s标记"
L.marker_player_desc = "标记受到%s影响的玩家为%s，需要权限。" -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "标记%s为%s，需要权限。" -- Mark NPC_NAME with SKULL_ICON
L.marker_npc_aura_desc = "标记受到'%s'影响的 NPC 为%s，需要权限。" -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON

-- Ability where two players have to move close to each other
L.link = "连接"
L.link_with = "与%s连接"
L.link_with_icon = "与|T13700%d:0|t%s连接"
L.link_with_rticon = "{rt%d}与%s连接"
L.link_both = "%s和%s连接"
L.link_both_icon = "|T13700%d:0|t%s和|T13700%d:0|t%s连接"
L.link_removed = "连接已移除"
L.link_say_option_name = "重复“连接”信息"
L.link_say_option_desc = "已重复喊话方式来发送信息，说明正在与谁连接。"

-- Abbreviated numbers
L.amount_one = "%.2f亿" -- Billions 1,000,000,000
L.amount_two = "%.1f万" -- Millions 1,000,000
L.amount_three = "%d千" -- Thousands 1,000
L.seconds = "%.1f秒" -- 1.1 seconds

-- Directions
L.top = "上"
L.up = "向上"
L.middle = "中"
L.down = "向下"
L.bottom = "下"
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

-- Schools
L.fire = "火焰"
L.frost = "冰霜"
L.shadow = "暗影"
L.nature = "自然"
L.arcane = "奥术"

-- Autotalk
L.autotalk = "自动与NPC对话"
L.autotalk_boss_desc = "自动选择NPC对话选项，使首领战开始。"
L.autotalk_generic_desc = "自动选择使你进入地下城下一阶段的NPC对话选项。"

-- Common ability name replacements
L.absorb = "吸收" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "治疗吸收盾" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "治疗吸收盾" -- Plural of L.heal_absorb
L.tank_combo = "坦克连击" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "激光" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "激光" -- Plural of L.lasers
L.beam = "射线" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "射线" -- Plural of L.beam
L.bomb = "炸弹" -- Used for debuffs that make players explode
L.bombs = "炸弹" -- Plural of L.bomb
L.explosion = "爆炸" -- When the explosion from a bomb-like ability will occur
L.fixate = "锁定" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "击退" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.pushback = "推开" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "陷阱" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "流星" -- This one will probably only ever be used for actual meteors
L.shield = "护盾" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "传送" -- A boss/add/etc teleported somewhere
L.fear = "恐惧" -- For abilities that cause you to flee in fear
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
L.curse = "诅咒" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "诅咒" -- Plural of L.curse
L.disease = "疾病" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.poison = "中毒" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.spirit = "精魂" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "精魂" -- Plural of L.spirit
L.tornado = "旋风" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "旋风" -- Plural of L.tornado
L.frontal_cone = "正面技能" -- Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.fear = "恐惧" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.mark = "印记" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "印记" -- Plural of L.marks
L.mind_control = "精神控制" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "精神控制" -- Short version of Mind Control, mainly for bars
L.soak = "分摊" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "分摊" -- Plural of L.soak
L.spell_reflection = "法术反射" -- Any ability that reflects spells
L.parasite = "寄生" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.rooted = "定身" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
L.dodge = "躲开" -- When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.health_drain = "吸血" -- Any ability that drains health from the player
L.smash = "重击" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.spike = "尖刺" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "尖刺" -- Plural of L.spike
L.waves = "波浪" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean
