@ECHO off
TITLE NadekoBot Installer
::Define locations/alias
SET root=%~dp0
::SET wget=%~dp0\wget\wget.exe
::SET githubssl=%~dp0\wget\DigiCertSHA2ExtendedValidationServerCA.crt

::Initial startup prompts
ECHO Welcome to NadekoBot 1.9+ 32bit.
ECHO.
ECHO 1.Install/Update NadekoBot
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
timeout /t 2 >nul
::Checks that both git and dotnet are installed
::i totally didn't steal this from kwoth's original script
dotnet --version >nul 2>&1 || GOTO :dotnet
git --version >nul 2>&1 || GOTO :git

IF EXIST NadekoBot\ (BREAK) ELSE (GOTO install2)
TITLE Updating NadekoBot...
git pull 
ECHO.
ECHO Operation completed.
TITLE Operation complete.
GOTO End

:install2
TITLE Installing NadekoBot...
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
::don't know why but the script shuts itself at this point
GOTO End

:dependency
:initial
::Start youtube-dl installation
ECHO Option 3 selected.
GOTO youtube-dl
youtube-dl --version >nul 2>&1 || GOTO :youtube-dl
ffmpeg -version >nul 2>&1 || GOTO :ffmpeg
::dir "\
ECHO Dependencies are already installed.


:youtube-dl
::Start youtube-dl installation
@ECHO on
cd\
mkdir youtube-dl
cd youtube-dl
ECHO Downloading youtube-dl...
powershell -Command "wget https://yt-dl.org/downloads/2017.12.14/youtube-dl.exe -OutFile 'youtube-dl.exe'" 
::setx path "%path%;D:\youtube-dl"
::DANGEROUS - Do not uncomment this yet! Still working on a workaround.
ECHO youtube-dl installed.
::GOTO dependency

:ffmpeg
::Start ffmpeg installation
ECHO Downloading ffmpeg...
::TODO
ECHO FFmpeg installed. 
::GOTO dependency

:redis
::Start redis installation and services
ECHO Starting redis installation...
echo You can specify the installation folder of redis.
SET /P "redisfolder=Path To Folder (leave blank to install to C:\Program Files):"
IF EXIST "%redisfolder%" GOTO :customredis
:normalredis
ECHO Selected C:\Program Files as installation folder.
mkdir "C:\Program Files\Redis"
cd "C:\Program Files\Redis"
GOTO redisdownload
:customredis
ECHO Selected %redisfolder% as installation folder.
mkdir "%redisfolder%\Redis"
cd "%redisfolder%\Redis"
GOTO redisdownload

:redisdownload
powershell -Command "wget 'https://raw.githubusercontent.com/MaybeGoogle/NadekoFiles/master/x86 Prereqs/redis-server.exe' -OutFile 'redis-server.exe'"
:redisdownloadcont
ECHO Redis downloaded. Installing as service...
::@ECHO on
redis-server.exe --service-install
ECHO.
ECHO Redis installed as service. 
ECHO At this stage, you should restart your computer; otherwise music will absolutely not work.
ECHO.
ECHO Press 1 to restart now, or press 2 if you plan to restart later.
CHOICE /c 12

IF ERRORLEVEL 2 GOTO :End
IF ERRORLEVEL 1 GOTO :restartpc

GOTO End
:already


:credentials
ECHO.


GOTO End
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

:missing
TITLE NadekoBot not installed.
ECHO.
ECHO You haven't downloaded NadekoBot yet!
ECHO Download dependencies (if you haven't already), download NadekoBot, and set-up credentials before you run this option!
GOTO End
::Misc
:permissions
ECHO.
ECHO The operation failed because the script wasn't run as administrator. 
ECHO Right click on the script, then click "Run as administrator".
PAUSE
GOTO exit
:restartpc
CLS
ECHO.
ECHO Are you absolutely sure? This will close all running applications, and you may lose any unsaved data.
ECHO.
ECHO 1.Yes, restart now.
ECHO 2.No, restart later.

CHOICE /c 12
IF ERRORLEVEL 2 GOTO End
IF ERRORLEVEL 1 SHUTDOWN -r

:exit
exit


:End
::should reopen the script again
pause
CLS
CALL NadekoInstaller.bat
