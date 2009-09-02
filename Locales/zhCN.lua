local L = LibStub("AceLocale-3.0"):NewLocale("BigWigs", "zhCN")

if not L then return end

-- Core.lua
L["%s has been defeated"] = "%s被击败了！"     -- "<boss> has been defeated"
L["%s have been defeated"] = "%s被击败了！"    -- "<bosses> have been defeated"
L["Bosses"] = "首领模块"
L["Options for bosses in %s."] = "%s首领模块选项。" -- "Options for bosses in <zone>"
L["Options for %s (r%d)."] = "%s首领模块版本（r%d）。"     -- "Options for <boss> (<revision>)"
L["Plugins"] = "插件"
L["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = "插件是 Big Wigs 最关键的核心 - 比如信息显示，记时条以及其他必要的功能。"
L["Extras"] = "附加功能"
L["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = "附加功能是第三方捆绑插件，是 Big Wigs 功能的一个增强。"
L["Active"] = "激活"
L["Activate or deactivate this module."] = "激活或关闭此模块。"
L["Reboot"] = "重置"
L["Reboot this module."] = "重置此模块。"
L["Options"] = "选项"
L["Minimap icon"] = "迷你地图图标"
L["Toggle show/hide of the minimap icon."] = "开启或关闭迷你地图图标。"
L["Advanced"] = "高级"
L["You shouldn't really need to touch these options, but if you want to tweak them then you're welcome to do so!"] = "并不需要去修改这些选项，但如果想进行调整我们欢迎这样做！"
L["Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n\n|cffff0000Note that some (!) of these options do not work at the moment. Please don't file bug reports for things concerning the Big Wigs interface right now, come talk to us on IRC instead.|r\n"] = "欢迎使用 Big Wigs，戏弄各个首领。请系好安全带，吃吃花生并享受这次旅行。它不会吃了你的孩子，但会协助你的团队与新的首领准备战斗如同享受饕餮大餐一样。\n\n|cffff0000注意有(!)的选项现在没有作用。请现在不要为 Big Wigs 插件出错相关打小报告，另用 IRC 来和我们谈谈。|r\n"
L["Configure ..."] = "配置…"
L["Closes the interface options window and lets you configure displays for things like bars and messages."] = "关闭插件选项窗口并配置显示项，如计时条、信息。"
L["Whisper warnings |cffff0000(!)|r"] = "密语警报|cffff0000(!)|r"
L["Toggles whether you will send a whisper notification to fellow players about certain boss encounter abilities that affect them personally. Think 'bomb'-type effects and such."] = "打开或关闭你对其他队员的首领战斗技能密语警报功能，想想类似“炸弹”类的技能。"
L["Raid icons |cffff0000(!)|r"] = "团队标记|cffff0000(!)|r"
L["Some boss modules use raid icons to mark players in your group that are of special interest to your raid. Things like 'bomb'-type effects and mind control are examples of this. If you turn this off, you won't mark anyone. Note that you need to be promoted to assistant or be the raid leader in order to set these raid icons."] = "有些首领模块使用团队标记来为某些中了特定技能的队员打上标记。想想类似“炸弹”类或心灵控制的技能。如果你关闭此功能，你将不会给队员打标记。请注意你必须被提升到团队领袖或助理才可使用此标记功能。"
L["Sound |cffff0000(!)|r"] = "音效|cffff0000(!)|r"
L["Some boss messages come with warning sounds of different kinds. Some people find it easier to just listen for these sounds after they've learned which sound goes with which message, instead of reading the actual message on screen."] = "有些首领警报信息出现时伴随着不同的音效。有些人更容易在听到何种音效后发现何种警报，而不是阅读屏幕上的实际警报信息。"
L["\n\n\n|cffccccccMooses don't appreciate being prodded with long pointy sticks.\nContact us on #wowace. [Ammo] and Rabbit can service all your needs.|r"] = "\n\n\n|cffcccccc麋鹿并不喜欢被标枪戳到。\n在 #wowace 上联系我们 [Ammo] 和 Rabbit 可以为你服务。|r"
L["Customize ..."] = "自定义…"

L["Toggles whether or not the boss module should warn about %s."] = "打开或关闭%s的首领模块报警。"
L.bosskill = "首领死亡"
L.bosskill_desc = "首领被击杀时显示提示信息。"
L.enrage = "激怒"
L.enrage_desc = "首领进入激怒状态时发出警报。"
L.berserk = "狂暴"
L.berserk_desc = "当首领进入狂暴状态时发出警报。"

L["Load"] = "加载"
L["Load All"] = "加载所有"
L["Load all %s modules."] = "加载所有%s模块。"

L.already_registered = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%d|r）在 Big Wigs 中已经存在首领模块，但存在（版本 |cffffff00%d|r）模块仍试图重新注册。可能由于更新失败的原因，通常表示您有两份模块拷贝在您的插件文件夹中。建议您删除所有 Big Wigs 文件夹并重新全新安装。"

-- Options.lua
L["|cff00ff00Module running|r"] = "|cff00ff00首领模块运行中|r"
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them."] = "你可以|cffeda55f点击|r图标重置所有运行中的模块；\n或者|cffeda55fAlt-点击|r可以禁用所有首领模块；\n或者 |cffeda55fCtrl-Alt-点击|r 可以禁用 Big Wigs 所有功能。"
L["Active boss modules:"] = "激活首领模块："
L["All running modules have been reset."] = "所有运行中的模块都已重置。"
L["Menu"] = "目录"
L["Menu options."] = "目录选项。"


