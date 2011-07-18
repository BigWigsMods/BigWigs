
local L = BigWigs:NewBossLocale("Atramedes", "zhCN")
if not L then return end
if L then
	L.ground_phase = "地面阶段"
	L.ground_phase_desc = "当艾卓曼德斯着陆时发出警报。"
	L.air_phase = "空中阶段"
	L.air_phase_desc = "当艾卓曼德斯起飞时发出警报。"

	L.air_phase_trigger = "对，跑吧！每跑一步你的心跳都会加快。这心跳声轰亮如雷……震耳欲聋。你逃不掉的！"

	L.obnoxious_soon = "即将 喧闹恶鬼！"

	L.searing_soon = "10秒后，灼热烈焰！"
	L.sonicbreath_cooldown = "<音波吐息>"
end

L = BigWigs:NewBossLocale("Chimaeron", "zhCN")
if L then
	L.bileotron_engage = "The Bile-O-Tron springs to life and begins to emit a foul smelling substance."

	L.next_system_failure = "<下一系统故障>"
	L.break_message = "破坏%2$dx：>%1$s<！"

	L.phase2_message = "即将 至死方休阶段！"

	L.warmup = "热身"
	L.warmup_desc = "热身计时器。"
end

L = BigWigs:NewBossLocale("Magmaw", "zhCN")
if L then
	-- heroic
	L.blazing = "Skeleton Adds"
	L.blazing_desc = "当召唤Blazing Bone Construct时发出警报。"
	L.blazing_message = "即將 Blazing Bone Construct！"
	L.blazing_bar = "<下一Blazing Bone Construct>"

	L.armageddon = "末日降临"
	L.armageddon_desc = "当头部阶段施放末日降临时发出警报。"

	L.phase2 = "第二階段"
	L.phase2_desc = "當第二階段時顯示距離檢查。"
	L.phase2_message = "第二階段！"
	L.phase2_yell = "Inconceivable! You may actually defeat my lava worm! Perhaps I can help... tip the scales."

	-- normal
	L.pillar_of_flame_cd = "<烈焰火柱>"

	L.slump = "扑倒（骑乘）"
	L.slump_desc = "当熔喉扑倒并暴露时发出警报。"
	L.slump_bar = "<下一骑乘>"
	L.slump_message = "嘿，快骑上它！"
	L.slump_trigger = "%s slumps forward, exposing his pincers!"

	L.infection_message = ">你< 寄生感染！"

	L.expose_trigger = "头部"
	L.expose_message = "头部暴露！"

	L.spew_bar = "<下一熔岩喷涌>"
	L.spew_warning = "即將 熔岩喷涌！"

	L.mangle_bar = "裂伤：>%s<！"
	L.mangle_cooldown = "<下一裂伤>"
end

L = BigWigs:NewBossLocale("Maloriak", "zhCN")
if L then
	--heroic
	L.sludge = "黑暗污泥"
	L.sludge_desc = "当你站在黑暗污泥上面时发出警报。"
	L.sludge_message = ">你< 黑暗污泥！"

	--normal
	L.final_phase = "最终阶段"
	L.final_phase_soon = "即将 最终阶段！"

	L.release_aberration_message = ">%s< 畸变怪剩余！"
	L.release_all = ">%s< 释放畸变怪！"

	L.flashfreeze = "<快速冻结>"
	L.next_blast = "<灼热爆破>"
	L.jets_bar = "<下一熔岩喷射>"

	L.phase = "阶段"
	L.phase_desc = "当进入不同阶段时发出警报。"
	L.next_phase = "下一阶段！"
	L.green_phase_bar = "<绿色阶段>"

	L.red_phase_trigger = "Mix and stir, apply heat..."
	L.red_phase_emote_trigger = "红色" --verify
	L.red_phase = "|cFFFF0000红色|r阶段！"
	L.blue_phase_trigger = "How well does the mortal shell handle extreme temperature change? Must find out! For science!"
	L.blue_phase_emote_trigger = "蓝色" --verify
	L.blue_phase = "|cFF809FFE蓝色|r阶段！"
	L.green_phase_trigger = "This one's a little unstable, but what's progress without failure?"
	L.green_phase_emote_trigger = "绿色" --verify
	L.green_phase = "|cFF33FF00绿色|r阶段！"
	L.dark_phase_trigger = "Your mixtures are weak, Maloriak! They need a bit more... kick!"
	L.dark_phase_emote_trigger = "黑色" --verify
	L.dark_phase = "|cFF660099黑色|r阶段！"
end

L = BigWigs:NewBossLocale("Nefarian", "zhCN")
if L then
	L.phase = "阶段"
	L.phase_desc = "当进入不同阶段时发出警报。"

	L.discharge_bar = "<闪电倾泻 冷却>"

	L.phase_two_trigger = "诅咒你们，凡人！你们丝毫不尊重他人财产的行为必须受到严厉处罚！"

	L.phase_three_trigger = "我一直在尝试扮演好客的主人，可你们就是不肯受死！该卸下伪装了……杀光你们！"

	L.crackle_trigger = "The air crackles with electricity!"
	L.crackle_message = "即将 通电！"

	L.shadowblaze_message = ">你< 暗影爆燃！"

	L.onyxia_power_message = "即将 电荷过载！"

	L.chromatic_prototype = "原型多彩龙人" -- 3 adds name
end

L = BigWigs:NewBossLocale("Omnotron Defense System", "zhCN")
if L then
	L.nef = "维克多·奈法里奥斯勋爵"
	L.nef_desc = "当维克多·奈法里奥斯勋爵施放技能时发出警报。"

	L.pool = "奥术反冲"

	L.switch = "转换"
	L.switch_desc = "当转换时发出警报。"
	L.switch_message = ">%s< %s！"

	L.next_switch = "<下一转换>"

	-- not using these but lets not just remove them yet who knows what will 4.0.6 break
	--L.nef_trigger1 = "Were you planning on using Toxitron's chemicals to damage the other constructs? Clever plan, let me ruin that for you."
	--L.nef_trigger2 = "Stupid Dwarves and your fascination with runes! Why would you create something that would help your enemy?"

	L.nef_next = "<下一暗影灌注>"

	L.acquiring_target = "获取目标"

	L.bomb_message = ">你< 毒液炸弹追击！"
	L.cloud_message = ">你< 化学云雾！"
	L.protocol_message = "毒液炸弹！"

	L.iconomnotron = "标记激活首领"
	L.iconomnotron_desc = "为激活的首领打上主团队标记。（需要权限）"
end

