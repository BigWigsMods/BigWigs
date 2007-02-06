@echo off

cd ..
rmdir /s /q BigWigs_AQ20
rmdir /s /q BigWigs_AQ40
rmdir /s /q BigWigs_Azeroth
rmdir /s /q BigWigs_BWL
rmdir /s /q BigWigs_MC
rmdir /s /q BigWigs_ZG
rmdir /s /q BigWigs_Naxxramas
rmdir /s /q BigWigs_Karazhan
rmdir /s /q BigWigs_Outland
rmdir /s /q BigWigs_Extras
rmdir /s /q BigWigs_Plugins

rmdir /s /q BigWigs_Other

cd BigWigs

move AQ20\AQ20.toc AQ20\BigWigs_AQ20.toc
move AQ40\AQ40.toc AQ40\BigWigs_AQ40.toc
move BWL\BWL.toc BWL\BigWigs_BWL.toc
move MC\MC.toc MC\BigWigs_MC.toc
move Naxxramas\Naxxramas.toc Naxxramas\BigWigs_Naxxramas.toc
move Karazhan\Karazhan.toc Karazhan\BigWigs_Karazhan.toc
move ZG\ZG.toc ZG\BigWigs_ZG.toc
move Azeroth\Azeroth.toc Azeroth\BigWigs_Azeroth.toc
move Outland\Outland.toc Outland\BigWigs_Outland.toc
move Extras\Extras.toc Extras\BigWigs_Extras.toc
move Plugins\Plugins.toc Plugins\BigWigs_Plugins.toc

move AQ20 ..\BigWigs_AQ20
move AQ40 ..\BigWigs_AQ40
move BWL ..\BigWigs_BWL
move MC ..\BigWigs_MC
move Naxxramas ..\BigWigs_Naxxramas
move Karazhan ..\BigWigs_Karazhan
move ZG ..\BigWigs_ZG
move Azeroth ..\BigWigs_Azeroth
move Outland ..\BigWigs_Outland
move Extras ..\BigWigs_Extras
move Plugins ..\BigWigs_Plugins

