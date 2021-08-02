@echo off
echo BUILDING CARTRIP TO NG
cd ..
lime build html5 -final -Dng
echo DELETING OLD ZIP
cd export/final/html5/bin
del CarTrip_NG.zip
echo ZIPPING CARTRIP
7z a -tzip -r CarTrip_NG -xr!*.zip
echo OPENING EXPLORER
explorer .
echo DONE
pause