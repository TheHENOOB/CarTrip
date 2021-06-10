@echo off
echo BUILDING CARTRIP TO NG (DEBUG)
cd ..
lime build html5 -debug -Dng
echo DELETING OLD ZIP
cd export/debug/html5/bin
del CarTrip_NG_DEBUG.zip
echo ZIPPING CARTRIP
7z a -tzip -r CarTrip_NG_DEBUG
echo DONE
pause