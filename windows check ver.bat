systeminfo | findstr /B /C:"OS Name" >ver.txt
findstr "Microsoft Windows 7" ver.txt && GOTO win7
:winnot
echo is not win 7
pause
exit
:win7
echo is win 7
PAUSE
exit