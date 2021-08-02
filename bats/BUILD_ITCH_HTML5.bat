@echo off
echo BUILDING CARTRIP TO ITCH
cd ..
lime build html5 -final
echo DELETING OLD ZIP
cd export/final/html5/bin
del CarTrip_ITCH.zip
echo ZIPPING CARTRIP
7z a -tzip -r CarTrip_ITCH -xr!*.zip
echo PUBLISHING ON ITCH
butler push CarTrip_ITCH.zip henoob/cartrip:html
echo DONE
pause