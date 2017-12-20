@ECHO off
TITLE NadekoBot Installer


::Initial startup prompts
ECHO Welcome to NadekoBot 1.9+ 32bit.
ECHO.
ECHO 1.Install NadekoBot
ECHO 2.Run NadekoBot
ECHO 3.Install Dependencies (Redis, FFmpeg, and youtube-dl)
ECHO 4.Setup credentials.json (make sure you've downloaded Nadeko first!)
ECHO 5.Exit 

ECHO.
ECHO Make sure you are running this script as Administrator!
ECHO.

CHOICE /c 12345 /m "Choose [1] to Download, [2] to Run, or [5] to Exit."

::apparently it needs to go backwards. huh.
IF ERRORLEVEL 5 GOTO :exit
IF ERRORLEVEL 4 GOTO :credentials
IF ERRORLEVEL 3 GOTO :dependency
IF ERRORLEVEL 2 GOTO :run
IF ERRORLEVEL 1 GOTO :install

::Choice sections
:install
ECHO.
ECHO Option 1 selected.

timeout /t 5
::Checks that both git and dotnet are installed
::i totally didn't steal this from kwoth's original script
dotnet --version >nul 2>&1 || GOTO :dotnet
git --version >nul 2>&1 || GOTO :git

git clone https://github.com/Kwoth/NadekoBot.git

GOTO End

:run
ECHO.
ECHO Option 2 selected.
IF EXIST NadekoBot\ (BREAK) ELSE (GOTO missing)

ECHO Running NadekoBot...
CD NadekoBot\src\NadekoBot\
dotnet run -c Release
ECHO.
ECHO NadekoBot stopped.
GOTO End

:dependency
ECHO Option 3 selected.



::service should do shit by itself
redis-server.exe --service-install
redis-server.exe --service-start
GOTO End

:credentials
ECHO.



::Missing stuff
:dotnet
ECHO.
TITLE Missing dotnet!
ECHO dotnet not found (or installed incorrectly). Double-check to see if it's installed correctly.
ECHO.
ECHO The script will now exit.
PAUSE
EXIT

:git
ECHO.
TITLE Missing git!
ECHO git not found (or was installed incorrectly). Double-check to see if it's installed correctly.
ECHO.
ECHO The script will now exit.
PAUSE
EXIT

::Misc
:missing
TITLE NadekoBot not installed.
ECHO.
ECHO You haven't downloaded NadekoBot yet!
ECHO Download dependencies (if you haven't already), download NadekoBot, and set-up credentials before you run this option!
GOTO End

:exit
exit


:End
::should reopen the script again
pause
CLS
CALL NadekoInstaller.bat
