@echo off
echo BUILDING CARTRIP TO NG (DEBUG)
cd ..
lime build html5 -debug -Dng
echo DELETING OLD ZIP
cd export
del CarTrip_NG_DEBUG.zip
echo ZIPPING CARTRIP
7z a -tzip -r CarTrip_NG_DEBUG debug/html5/bin
echo DONE
pause