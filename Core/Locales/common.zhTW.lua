local L = BigWigsAPI:NewLocale("BigWigs: Common", "zhTW")
if not L then return end

-- Prototype.lua common words
L.you = "你：%s"
L.you_icon = "|T13700%2$d:0|t你：%1$s"
L.underyou = "%s在你腳下"
L.aboveyou = "%s在你面前"
L.other = "%s：%s"
L.onboss = "首領%s"
L.buff_boss = "首領增益：%s"
L.buff_other = "%s獲得增益：%s"
L.magic_buff_boss = "首領魔法增益：%s" -- Magic buff on BOSS: SPELL_NAME
L.magic_buff_other = "%s獲得魔法增益：%s" -- Magic buff on NPC_NAME: SPELL_NAME
L.on = "%s：%s"
L.stack = "%3$s：%1$d層%2$s"
L.stackyou = "你：%d層%s"
L.cast = "<施放：%s>"
L.casting = "正在施放：%s"
L.soon = "即將：%s"
L.count = "%s（%d）"
L.count_amount = "%s（%d/%d）"
L.count_icon = "%s（%d|T13700%d:0|t）"
L.count_rticon = "%s（%d{rt%d}）"
L.rticon = "%s（{rt%d}）"
L.near = "%s在你附近"
L.on_group = "團隊：%s" -- spell on group
L.boss = "首領"
L.plus = "%s + %s" -- Spell 1 + Spell 2
L.extra = "%s（%s）" -- SPELL_NAME (short spell name or extra information)

L.phase = "階段%d"
L.stage = "階段%d"
L.wave = "第 %d 波" -- e.g. "Wave 1" (Waves of adds)
L.wave_count = "第 %d/%d 波" -- Wave 1 of 3 (Usually waves of adds)
L.normal = "普通模式"
L.heroic = "英雄模式"
L.mythic = "傳奇難度"
L.hard = "困難模式"
L.active = "開戰" -- When a boss becomes active, after speech finishes
L.ready = "準備完成" -- When a player is ready to do something
L.dead = "死亡" -- When a player is dead
L.general = "通用" -- General settings, i.e. things that apply to normal, heroic and mythic mode.
L.health = "生命值" -- The health of an NPC
L.health_percent = "%d%% 生命值" -- "10% Health" The health percentage of an NPC
L.door_open = "開門" -- 小的門 When a door is open, usually after a speech from an NPC
L.gate_open = "開門" -- 大的門 When a gate is open, usually after a speech from an NPC
L.threat = "威脅"
L.energy = "能量"

L.remaining = "剩餘 %d" -- 5 remaining
L.duration = "%s持續 %s 秒" -- Spell for 10 seconds
L.over = "%s結束" -- Spell Over
L.removed = "%s移除" -- Spell Removed
L.removed_from = "%2$s已移除%1$s" -- Spell removed from Player 自玩家身上清除 語句不順 應該是 %2$s身上的%1$s已移除 或 %2$s的%1$s被清除
L.removed_by = "%s被%s移除" -- Spell removed by Player 法術被玩家清除
L.removed_after = "%s移除，用時 %.1f 秒" -- "Spell removed after 1.1s" (s = seconds)
L.incoming = "即將：%s" -- Spell Incoming
L.interrupted = "已打斷%s" -- Spell Interrupted
L.interrupted_by = "%2$s已打斷%1$s" -- Spell interrupted by Player
L.interruptible = "可打斷" -- when a spell is interruptible
L.no = "缺少%s" -- No Spell
L.intermission = "階段轉換"
L.percent = "%d%% - %s" -- 20% - Spell
L.cancelled = "%s取消" -- Spell Cancelled
L.you_die = "你將死亡" -- You will die
L.you_die_sec = "你將在%d秒後死亡" -- "You die in 15 sec" (sec = seconds)
L.next_ability = "下個技能" -- We don't know what ability will be next, we only know when it will happen (showing a bar)
L.landing = "%s即將著陸" -- "NPC_NAME is landing" Used when a flying NPC/dragon/boss is landing 即將著陸、正在降落
L.flying_available = "可以飛行"

-- Add related
L.add_spawned = "增援出現" -- singular 小怪OR增援，開發者要求用增援
L.adds_spawned = "增援出現" -- plural
L.adds_spawned_count = "%d名增援出現" -- 1 add spawned / 2 adds spawned
L.add_spawning = "增援出現" -- singular 小怪正在出現/小怪出現/小怪已出現，中文沒有英文那麼明確的時態和單複數之別
L.adds_spawning = "增援出現" -- plural
L.spawned = "%s已重生"
L.spawning = "%s出現"
L.next_add = "下一波小怪"
L.add_killed = "小怪已擊殺（%d/%d）"
L.add_remaining = "小怪已擊殺，剩餘 %d"
L.add = "增援"
L.adds = "增援"
L.big_add = "大型增援" -- singular
L.big_adds = "大型增援" -- plural
L.small_add = "小型增援" -- singular
L.small_adds = "小型增援" -- plural

-- Mob related
L.killed = "%s已擊殺"
L.mob_killed = "%s已擊殺（%d/%d）"
L.mob_remaining = "%s已擊殺，剩餘 %d"

-- NPCs for follower dungeons
L.garrick = "蓋瑞克船長" -- AI paladin tank (NPC 209057)
L.garrick_short = "*蓋瑞克"
L.meredy = "美芮迪‧漢茲威爾" -- AI mage dps (NPC 209059)
L.meredy_short = "*美芮迪"
L.shuja = "秀嘉‧嚴斧" -- AI shaman dps (NPC 214390)
L.shuja_short = "*秀嘉"
L.crenna = "『大地之女』克蘭娜" -- AI druid healer (NPC 209072)
L.crenna_short = "*克蘭娜"
L.austin = "奧斯汀‧哈克斯沃" -- AI hunter dps (NPC 209065)
L.austin_short = "*奧斯汀"

-- Localizers note:
-- The default mod:Berserk(600) uses spell ID 26662 to get the Berserk name
L.custom_start = "%1$s參戰 - %3$d分後%2$s"
L.custom_start_s = "%1$s參戰 - %3$d秒後%2$s"
L.custom_end = "%s - %s"
L.custom_min = "%2$d分後%1$s"
L.custom_sec = "%2$d秒後%1$s"

L.focus_only = "|cffff0000只限專注目標。|r "
L.trash = "小怪"
L.affixes = "詞綴" -- Seasonal affixes for raids and mythic+ dungeons

-- Common raid marking locale
L.marker = "%s標記"
L.marker_player_desc = "將受到%s影響的玩家標記為%s，需要權限。" -- Mark players affected by 'SPELL_NAME' with SKULL_ICON
L.marker_npc_desc = "標記%s為%s，需要權限。" -- Mark NPC_NAME with SKULL_ICON
L.marker_npc_aura_desc = "將受到%s影響的 NPC 標記為%s，需要權限。" -- Mark NPCs affected by 'SPELL_NAME' with SKULL_ICON

-- Ability where two players have to move close to each other
L.link = "連結"
L.link_with = "與%s連結"
L.link_with_icon = "與|T13700%d:0|t%s連結"
L.link_with_rticon = "{rt%d}與%s連結"
L.link_both = "%s和%s連結"
L.link_both_icon = "|T13700%d:0|t%s和|T13700%d:0|t%s連結"
L.link_removed = "連結移除"
L.link_say_option_name = "重覆「連結」喊話"
L.link_say_option_desc = "不停地喊話你和誰連結了。" -- 可能需要再改

-- Abbreviated numbers
L.amount_one = "%.2f億" -- Billions 1,000,000,000
L.amount_two = "%.1f萬" -- Millions 1,000,000
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
L.north = "北方"
L.north_east = "東北"
L.east = "東方"
L.south_east = "東南"
L.south = "南方"
L.south_west = "西南"
L.west = "西方"
L.north_west = "西北"

-- Schools
L.fire = "火焰"
L.frost = "冰霜"
L.shadow = "暗影"
L.nature = "自然"
L.arcane = "秘法"

-- Autotalk
L.autotalk = "自動與 NPC 對話"
L.autotalk_boss_desc = "自動選擇開始首領戰鬥的對話選項。"
L.autotalk_generic_desc = "自動選擇使地城進入下一階段的對話選項。"

-- Common ability name replacements
L.absorb = "吸收" -- Used for shield-like abilities that absorb damage or healing
L.heal_absorb = "治療吸收盾" -- Used for shield-like abilities that absorb healing only
L.heal_absorbs = "治療吸收盾" -- Plural of L.heal_absorb
L.tank_combo = "坦克連擊" -- Used for tank swap mechanics where the boss casts a sequence of tank buster attacks
L.laser = "雷射" -- Used for abilities that act like a laser. Usually from the boss to a player, or, from the boss to a specific area
L.lasers = "雷射" -- Plural of L.lasers
L.beam = "射線" -- Similar to "Laser" (a beam from boss to player/boss to area) but can be used to better describe certain abilities that don't look like a Laser
L.beams = "射線" -- Plural of L.beam
L.bomb = "炸彈" -- Used for debuffs that make players explode
L.bombs = "炸彈" -- Plural of L.bomb
L.explosion = "爆炸" -- When the explosion from a bomb-like ability will occur
L.fixate = "鎖定" -- Used when a boss or add is chasing/fixated on a player
L.knockback = "擊退" -- Used when an ability knocks players away from a certain point, like a "smash" type ability that knocks you back 10 meters
L.pushback = "推開" -- Used when an ability slowly and continually pushes a player away, like winds gradually pushing you away over time
L.traps = "陷阱" -- Used for abilities that act like traps on the floor e.g. move into it and something bad happens like you die, or are rooted, etc.
L.meteor = "隕石" -- This one will probably only ever be used for actual meteors
L.shield = "護盾" -- Abilities that absorb damage/healing creating a "shield" around the boss/player e.g. "Shield on boss" or "Shield remaining"
L.teleport = "傳送" -- A boss/add/etc teleported somewhere
L.fear = "恐懼" -- For abilities that cause you to flee in fear
L.breath = "吐息" -- When a boss breathes fire/frost/etc on to a player or the raid e.g. a Dragon breathing fire on everyone
L.roar = "咆哮" -- When a boss opens their mouth to let out a loud roar, sometimes used to inflict damage on the raid
L.leap = "跳躍" -- When a boss leaps through the air from one location to another location, or from a location to a player, etc
L.charge = "衝鋒" -- When a boss select a new target and charges at it quickly, in the same way someone playing a warrior can charge at a target
L.full_energy = "滿能量" -- When a boss reaches full/maximum energy, usually the boss will cast something big and powerful when this happens
L.weakened = "虛弱" -- When a boss becomes weakened and sometimes takes extra damage, usually the "hit all your cooldowns" part of the fight
L.immune = "免疫" -- When a boss becomes immune to all damage and you can no longer hurt it
L.stunned = "昏迷" -- When a boss becomes stunned and cannot cast abilities or move
L.pool = "水池" -- A pool or puddle on the ground, usually something bad that you should avoid standing in
L.pools = "水池" -- Plural of L.pool
L.totem = "圖騰" -- A totem, usually summoned by a boss, the same thing that shamans summon
L.totems = "圖騰" -- Plural of L.totem
L.portal = "傳送" -- A portal somewhere, usually leading to a different location
L.portals = "傳送" -- Plural of L.portal
L.rift = "裂隙" -- Can be used in a similar way as a portal e.g. "Time Rift" but can also be used as a debuff/pool underneath you that you need to run through to remove/despawn it e.g. "Dread Rift"
L.rifts = "裂隙" -- Plural of L.rift
L.orb = "寶珠" -- A ball/sphere object usually moving and you need to avoid it
L.orbs = "寶珠" -- Plural for L.orb
L.curse = "詛咒" -- Any curse-type dispellable debuff, or debuffs called "Curse of XYZ", etc.
L.curses = "詛咒" -- Plural of L.curse
L.disease = "疾病" -- Any disease-type dispellable debuff, or debuffs called "Disease of XYZ", etc.
L.poison = "毒" -- Any poison-type dispellable debuff, or debuffs called "Poison of XYZ", etc.
L.spirit = "靈魂" -- Sometimes a boss will summon spirits, similar to ghosts, but not exactly, although you might have the same word for both. e.g. "Spirits of X" or "Wild Spirits"
L.spirits = "靈魂" -- Plural of L.spirit
L.tornado = "旋風" -- 'A tornado is a violently rotating column of air that is in contact with both the surface of the Earth and a cloud' - Wikipedia
L.tornadoes = "旋風" -- Plural of L.tornado
L.frontal_cone = "正面技能" -- 正面衝擊 Usually a bad Area-of-Effect ability cast by the boss in a cone/triangle/pizza shape in front of them, don't stand in front of the boss!
L.fear = "恐懼術" -- Similar to a warlock or priest ability, when a boss casts a fear on a player or multiple players, that makes them run around out of control
L.mark = "標記" -- Short name for abilites with "Mark" in the name, for example "Mark of Death" or "Toxic Mark" or "Mark of Frost" etc.
L.marks = "標記" -- Plural of L.marks
L.mind_control = "精神控制" -- Any kind of Mind Control ability, where a player loses control of their character
L.mind_control_short = "精神控制" -- Short version of Mind Control, mainly for bars
L.soak = "分攤" -- Abilities you have to stand in on purpose to soak the damage, like a sponge soaks water. Commonly for abilities that split damage between everyone standing in them.
L.soaks = "分攤" -- Plural of L.soak
L.spell_reflection = "法術反射" -- Any ability that reflects spells
L.parasite = "寄生" -- Any ability where a parasite is involved e.g. "Parasitic Infection", "Parasitic Growth", etc
L.rooted = "被定身" -- Any ability that roots you in place, preventing you from moving

-- Common ability name replacements A-Z
L.dodge = "躲開" -- 躲開/躲避/閃避/躲圈? When you need to continually run around to dodge abilities, like missiles landing on the ground under you
L.health_drain = "吸血" -- Any ability that drains health from the player 吸血類的技能，就是術士的吸取生命那種直接吸血的法術
L.smash = "重擊" -- Short for any ability with the name "smash" in it e.g. "Darkrift Smash" or "Seismic Smash" or "Arcing Smash"
L.spike = "尖刺" -- Short for any ability with the name "spike" in it e.g. "Glacial Spike" or "Fel Spike" or "Volatile Spike"
L.spikes = "尖刺" -- Plural of L.spike
L.waves = "波浪" -- Multiple waves of a bad ability coming from a boss, like waves in the ocean
