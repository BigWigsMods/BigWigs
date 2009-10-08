local L = LibStub("AceLocale-3.0"):NewLocale("Big Wigs", "zhCN")

if not L then return end

-- Core.lua
L["%s enabled"] = "%s已启用"
L["%s has been defeated"] = "%s被击败了！"     -- "<boss> has been defeated"

L.bosskill = "首领死亡"
L.bosskill_desc = "首领被击杀时显示提示信息。"
L.berserk = "狂暴"
L.berserk_desc = "当首领进入狂暴状态时发出警报。"

L.already_registered = "|cffff0000警告：|r |cff00ff00%s|r（|cffffff00%s|r）在 Big Wigs 中已经存在模块，但存在模块仍试图重新注册。可能由于更新失败的原因，通常表示您有两份模块拷贝在您插件的文件夹中。建议删除所有 Big Wigs 文件夹并重新安装。"

-- Loader / Options.lua
L["You are running an official release of Big Wigs %s (revision %d)"] = "你所使用的 Big Wigs %s 为官方正式版（修订号%d）"
L["You are running an ALPHA RELEASE of Big Wigs %s (revision %d)"] = "你所使用的 Big Wigs %s 为“α测试版”（修订号%d）"
L["You are running a source checkout of Big Wigs %s directly from the repository."] = "你所使用的 Big Wigs %s 为从源直接检出的。"
L["There is a new release of Big Wigs available. You can visit curse.com, wowinterface.com, wowace.com or use the Curse Updater to get the new release."] = "有新的 Big Wigs 正式版可用。你可以访问 Curse.com，wowinterface.com，wowace.com 或使用 Curse 更新器来更新到新的正式版。"

 -- XXX Our tooltip sucks, I want these things gone and automated!
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them."] = "|cffeda55f点击|r图标重置所有运行中的模块。|cffeda55fAlt-点击|r可以禁用所有首领模块。"
L["Active boss modules:"] = "激活首领模块："
L["All running modules have been reset."] = "所有运行中的模块都已重置。"
L["Big Wigs is currently disabled."] = "Big Wigs 已被禁用。"
L["|cffeda55fClick|r to enable."] = "|cffeda55f点击|r启用。"
L["|cffeda55fClick|r to reset all running modules. |cffeda55fAlt-Click|r to disable them. |cffeda55fCtrl-Alt-Click|r to disable Big Wigs completely."] = "|cffeda55f点击|r重置所有运行中的模块。|cffeda55fAlt-点击|r禁用所有首领模块。|cffeda55fCtrl-Alt-点击|r禁用 Big Wigs 所有功能。"
L["All running modules have been disabled."] = "所有运行中的模块都已禁用。"

L["There are people in your group with older versions or without Big Wigs. You can get more details with /bwv."] = "在你队伍里使用旧版本或没有使用 Big Wigs。你可以用 /bwv 获得详细内容。"
L["Up to date:"] = "已更新："
L["Out of date:"] = "过期："
L["No Big Wigs 3.0:"] = "没有 Big Wigs 3.0："

-- Options.lua
-- XXX Perhaps option descriptions should be in key form, so it's
-- XXX L.iconDesc = .. instead of L["Bla bla bla ...
L["Customize ..."] = "自定义…"
L["Welcome to Big Wigs, where the boss encounters roam. Please fasten your seatbelt, eat peanuts and enjoy the ride. It will not eat your children, but it will assist you in preparing that new boss encounter as a 7-course dinner for your raid group.\n"] = "欢迎使用 Big Wigs 戏弄各个首领。请系好安全带，吃吃花生并享受这次旅行。它不会吃了你的孩子，但会协助你的团队与新的首领进行战斗就如同享受饕餮大餐一样。"
L["Configure ..."] = "配置…"
L["Closes the interface options window and lets you configure displays for things like bars and messages.\n\nIf you want to customize more behind-the-scenes things, you can expand Big Wigs in the left tree and find the 'Customize ...' subsection."] = "关闭插件选项窗口并配置显示项，如计时条、信息。\n\n如果需要自定义更多幕后时间，你可以展开左侧 Big Wigs 找到“自定义…”小项进行设置。"
L["Sound"] = "音效"
L["Messages might come with a sound. Some people find it easier to listen for these after they've learned which sound goes with which message, as opposed to reading the actual messages.\n\n|cffff4411Even when off, the default raid warning sound might be played by incoming raid warnings from other players. That sound, however, is different from the sounds we use.|r"] = "信息出现时伴随着音效。有些人更容易在听到何种音效后发现何种警报，而不是阅读的实际信息。\n\n|cffff4411即使被关闭，默认的团队警报音效可能会随其它玩家的团队警报出现，那些声音与这里用的不同。|r"
L["Blizzard warnings"] = "暴雪警报"
L["Blizzard provides their own messages for some abilities on some encounters. In our opinion, these messages are both way too long and descriptive. We try to produce smaller, more fitting messages that do not interfere with the gameplay, and that don't tell you specifically what to do.\n\n|cffff4411When off, Blizzards warnings will not be shown in the middle of the screen, but they will still show in your chat frame.|r"] = "暴雪提供了他们自己的警报信息。我们认为，这些信息太长和复杂。我们试着简化这些消息而不打扰游戏的乐趣，并不需要你做什么。\n\n|cffff4411当关闭时，暴雪警报将不会再屏幕中间显示，但是仍将显示在聊天框体内。|r"
L["Flash and shake"] = "闪屏/震动"
L["Certain abilities are important enough to need your full attention. When these abilities affect you Big Wigs can flash and shake the screen.\n\n|cffff4411If you are playing with the nameplates turned on the shaking function will not work due to Blizzard restrictions, the screen will only flash then.|r"] = "某些重要的技能需要你相当的注意力。当这些技能出现时 Big Wigs 可以闪烁和震动屏幕。\n\n|cffff4411如果开启了暴雪的姓名板选项，屏幕只会闪烁而震动功能将不会工作。|r"
L["Raid icons"] = "团队标记"
L["Some encounter scripts use raid icons to mark players that are of special interest to your group. For example 'bomb'-type effects and mind control. If you turn this off, you won't mark anyone.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "团队中有些首领模块使用团队标记来为某些中了特定技能的队员打上标记。例如类似“炸弹”类或心灵控制的技能。如果你关闭此功能，你将不会给队员打标记。\n\n|cffff4411只有团队领袖或被提升为助理时才可以这么做！|r"
L["Whisper warnings"] = "密语警报"
L["Send a whisper notification to fellow players about certain encounter abilities that affect them. Think 'bomb'-type effects and such.\n\n|cffff4411Only applies if you're either the group leader or promoted!|r"] = "发送给其它队员的首领战斗技能密语警报功能，例如类似“炸弹”类的技能。\n\n|cffff4411只有团队领袖或被提升为助理时才可以这么做！|r"
L["Broadcast"] = "广播"
L["Broadcast all messages from Big Wigs to the raid warning channel.\n\n|cffff4411Only applies if you are raid leader/officer or in a 5-man party!|r"] = "Big Wigs 广播所有信息到团队警报频道。\n\n|cffff4411只有团队领袖及助理或在5人小队时才可以这么做！|r"
L["Raid channel"] = "团队频道"
L["Use the raid channel instead of raid warning for broadcasting messages."] = "使用团队频道而不是团队警报广播信息。"
L["Minimap icon"] = "迷你地图图标"
L["Toggle show/hide of the minimap icon."] = "打开或关闭迷你地图图标。"
L["Configure"] = "配置"
L["Test"] = "测试"
L["Reset positions"] = "重置位置"
L["Options for %s."] = "%s选项。"

L["BAR"] = "计时条"
L["MESSAGE"] = "信息"
L["SOUND"] = "音效"
L["ICON"] = "标记"
L["PROXIMITY"] = "近距离"
L["WHISPER"] = "密语"
L["SAY"] = "说"
L["FLASHSHAKE"] = "闪屏/震动"
L["PING"] = "点击地图"
L["EMPHASIZE"] = "醒目"
L["MESSAGE_desc"] = "大多数遇到技能出现一个或多个信息时 Big Wigs 将在屏幕上显示。如果禁用此选项，没有信息附加选项，如果有，将会被显示。"
L["BAR_desc"] = "当遇到某些技能时计时条将会适当显示。如果这个功能伴随着你想要隐藏的计时条，禁用此选项。"
L["FLASHSHAKE_desc"] = "一些技能可能比其它更加重要。如果想这些技能即将出现或发动时闪屏和震动，选中此选项。"
L["ICON_desc"] = "Big Wigs 可以根据技能用图标标记人物。这将使他们更容易被辨认。"
L["WHISPER_desc"] = "当一些技能足够重要时 Big Wigs 将发送密语给受到影响的人。"
L["SAY_desc"] = "聊天泡泡容易辨认。Big Wigs 将使用说的信息方式通知给附近的人告诉他们你中了什么技能。"
L["PING_desc"] = "有时所在位置也很重要，Big Wigs 将点击迷你地图通知大家你位于何处。"
L["EMPHASIZE_desc"] = "启用这些将特别醒目所相关遇到技能的任何信息或计时条。信息将被放大，计时条将会闪烁并有不同的颜色，技能即将出现时会使用计时音效，基本上你会发现它。"
L["Advanced options"] = "高级选项"
L["<< Back"] = "<< 返回"

L["About"] = "关于"
L["Main Developers"] = "主要开发"
L["Maintainers"] = "维护"
L["License"] = "许可"
L["Website"] = "网站"
L["Contact"] = "联系方式"
L["See license.txt in the main Big Wigs folder."] = "查看 license.txt 位于 Big Wigs 主文件夹。"
L["irc.freenode.net in the #wowace channel"] = "#wowace 频道位于 irc.freenode.net"
L["Thanks to the following for all their help in various fields of development"] = "感谢他们在各个领域的开发与帮助"
