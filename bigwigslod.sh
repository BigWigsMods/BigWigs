#/bin/bash

cd ..
rm -rf BigWigs_SC
rm -rf BigWigs_Karazhan
rm -rf BigWigs_Outland
rm -rf BigWigs_Extras
rm -rf BigWigs_Plugins
rm -rf BigWigs_TheEye
rm -rf BigWigs_BlackTemple
rm -rf BigWigs_Hyjal
rm -rf BigWigs_ZulAman
rm -rf BigWigs_Sunwell

cd BigWigs

mv Karazhan ../BigWigs_Karazhan
mv SC ../BigWigs_SC
mv Outland ../BigWigs_Outland
mv Extras ../BigWigs_Extras
mv Plugins ../BigWigs_Plugins
mv TheEye ../BigWigs_TheEye
mv BlackTemple ../BigWigs_BlackTemple
mv Hyjal ../BigWigs_Hyjal
mv ZulAman ../BigWigs_ZulAman
mv Sunwell ../BigWigs_Sunwell

rm -rf modules.xml