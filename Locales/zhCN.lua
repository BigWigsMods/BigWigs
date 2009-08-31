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
	
-- Prototype.lua common words
L.you = ">你< %s！"
L.other = "%s：>%s<！"

L.enrage_start = "%s激活 - %d分后激怒！"
L.enrage_end = "%s已激怒！"
L.enrage_min = "%d分后激怒！"
L.enrage_sec = "%d秒后激怒！"
L.enrage = "激怒"

L.berserk_start = "%s激活 - 将在%d分后狂暴！"
L.berserk_end = "%s已狂暴！"
L.berserk_min = "%d分后狂暴！"
L.berserk_sec = "%d秒后狂暴！"
L.berserk = "狂暴"
