@echo off

cd ..
rmdir /s /q BigWigs_AQ20
rmdir /s /q BigWigs_AQ40
rmdir /s /q BigWigs_Azeroth
rmdir /s /q BigWigs_BWL
rmdir /s /q BigWigs_MC
rmdir /s /q BigWigs_ZG
rmdir /s /q BigWigs_SC
rmdir /s /q BigWigs_Naxxramas
rmdir /s /q BigWigs_Karazhan
rmdir /s /q BigWigs_Outland
rmdir /s /q BigWigs_Extras
rmdir /s /q BigWigs_Plugins
rmdir /s /q BigWigs_TheEye

rmdir /s /q BigWigs_Other

cd BigWigs

move AQ20 ..\BigWigs_AQ20
move AQ40 ..\BigWigs_AQ40
move BWL ..\BigWigs_BWL
move MC ..\BigWigs_MC
move Naxxramas ..\BigWigs_Naxxramas
move Karazhan ..\BigWigs_Karazhan
move ZG ..\BigWigs_ZG
move SC ..\BigWigs_SC
move Azeroth ..\BigWigs_Azeroth
move Outland ..\BigWigs_Outland
move Extras ..\BigWigs_Extras
move Plugins ..\BigWigs_Plugins
move TheEye ..\BigWigs_TheEye
