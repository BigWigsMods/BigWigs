@echo off

cd ..
rmdir /s /q BigWigs_SC
rmdir /s /q BigWigs_Karazhan
rmdir /s /q BigWigs_Outland
rmdir /s /q BigWigs_Extras
rmdir /s /q BigWigs_Plugins
rmdir /s /q BigWigs_TheEye

rmdir /s /q BigWigs_Other

cd BigWigs

move Karazhan ..\BigWigs_Karazhan
move SC ..\BigWigs_SC
move Outland ..\BigWigs_Outland
move Extras ..\BigWigs_Extras
move Plugins ..\BigWigs_Plugins
move TheEye ..\BigWigs_TheEye
