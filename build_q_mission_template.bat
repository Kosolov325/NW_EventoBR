@echo off
python process_init.py
python process_global_variables.py
python process_mission_tmps.py
@del *.pyc
echo.
echo ______________________________
echo.
echo Script processing has ended.
echo Press any key to exit. . .
pause>nul