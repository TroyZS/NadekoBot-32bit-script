@ECHO off
TITLE NadekoBot Installer
::Define locations/alias
SET root=%~dp0
SET nadeko=%~dp0\NadekoBot\src\NadekoBot
SET drive=%~d0

::::::Check for OS (Windows 7 incompatible)::::::
ECHO Checking windows version...
systeminfo | findstr /B /C:"OS Name" >ver.txt
findstr "7" ver.txt >nul && GOTO :win7
findstr "8" ver.txt >nul && ECHO Windows 8/8.1 detected.
findstr "10" ver.txt >nul && ECHO Windows 10 detected.
ECHO Proceeding with script...
del ver.txt
timeout /t 2 >nul

::::::Initial startup prompts::::::
:startup
  CLS
  ECHO Welcome to NadekoBot 1.9+ 32bit.
  ECHO.
  ECHO 1.Install/Update NadekoBot
  ECHO 2.Run NadekoBot (Normally)
  ECHO 3.Install Dependencies (Redis, FFmpeg, and youtube-dl)
  ECHO 4.Setup credentials.json (make sure you've downloaded Nadeko first!)
  ECHO 5.Exit
  ::TODO implement auto run/restart?
  ::TODO implement auto install everything
  ECHO.
  ECHO.
  ECHO Recommended order for a new install is [1], [3], [4], then [2].

  ECHO.
  ECHO Make sure you are running this script as Administrator!
  ECHO.
  %drive%
  cd %root%

  CHOICE /c 12345 /m "Choose [1] to Download, [2] to Run, or [5] to Exit."

::Reading choice, goto section. apparently it needs to go backwards. huh.
  IF ERRORLEVEL 5 GOTO :exit
  IF ERRORLEVEL 4 GOTO :credentials
  IF ERRORLEVEL 3 GOTO :dependency
  IF ERRORLEVEL 2 GOTO :run
  IF ERRORLEVEL 1 GOTO :update

::::::Choice sections::::::
::[1]
:update
  ECHO.
  ECHO Option 1 selected.
  timeout /t 2 >nul
  ::Checks that both git and dotnet are installed
  ::i totally didn't steal this from kwoth's original script
  dotnet --version >nul 2>&1 || GOTO :dotnet
  git --version >nul 2>&1 || GOTO :git
  IF EXIST NadekoBot\ (BREAK) ELSE (GOTO :install)
  TITLE Updating NadekoBot...
  ECHO Existing installation detected, updating...
  cd NadekoBot\
  git pull
  ECHO.
  ECHO Operation completed.
  TITLE Operation complete.
  GOTO End

  :install
    TITLE Installing NadekoBot...
    ECHO No existing installation found, downloading NadekoBot...
    git clone https://github.com/Kwoth/NadekoBot.git
    ECHO.
    ECHO Downloaded.
    GOTO End

::[2]
:run
	ECHO.
	ECHO Option 2 selected.
	redis-server --service-start
	IF EXIST NadekoBot\ (BREAK) ELSE (GOTO missing)
	ECHO Running NadekoBot...
	TITLE Running NadekoBot...
	:autorun
	CD %root%\NadekoBot && dotnet restore
	CD %nadeko% && dotnet build --configuration Release
	dotnet run -c Release
	GOTO :autorun
	ECHO.
	ECHO NadekoBot stopped.
	GOTO End

::[3]
:dependency
	::Start youtube-dl installation
	ECHO Option 3 selected.
	::@ECHO ON
	youtube-dl --version >nul 2>&1 || GOTO :youtube-dl
	ffmpeg -version >nul 2>&1 || GOTO :ffmpeg
	ECHO FFmpeg and youtube-dl are installed.
  pause
	GOTO 32bitmusic
	::ECHO Dependencies are already installed.


	:youtube-dl
    ::Start youtube-dl installation
    ECHO Downloading youtube-dl...
	  cd %root%/NadekoBot/src/NadekoBot
    powershell -Command "wget https://yt-dl.org/downloads/2017.12.14/youtube-dl.exe -OutFile 'youtube-dl.exe'"
    ECHO Downloaded.
	  ECHO.
    GOTO dependency

	:ffmpeg
    ::Start ffmpeg installation
    ECHO Downloading ffmpeg...
  	SET ffmpegzip=ffmpeg-3.4.1-win32-static
	%drive%
  	cd %root%/NadekoBot/src/NadekoBot
  	powershell -Command "wget https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-3.4.1-win32-static.zip -OutFile '%nadeko%\%ffmpegzip%.zip'"
  	powershell -Command "Expand-Archive -Path %nadeko%\%ffmpegzip%.zip -DestinationPath %nadeko%"
  	del %ffmpegzip%.zip
  	move %nadeko%\%ffmpegzip%\bin\ffmpeg.exe
  	rmdir /s /q %ffmpeg%
    ECHO Downloaded.
  	ECHO.
    GOTO dependency

  :32bitmusic
  	::Acquire required 32-bit files for music
  	ECHO Removing 64bit versions...
  	cd %nadeko%
  	del libsodium.dll
  	del opus.dll
  	ECHO.
  	ECHO Downloading 32bit files...
  	powershell -Command "wget 'https://github.com/MaybeGoogle/NadekoFiles/raw/master/x86 Prereqs/NadekoBot_Music/libsodium.dll' -OutFile %nadeko%\libsodium.dll"
  	powershell -Command "wget 'https://github.com/MaybeGoogle/NadekoFiles/raw/master/x86 Prereqs/NadekoBot_Music/opus.dll' -OutFile %nadeko%\opus.dll"
  	ECHO Downloaded.

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
	   redis-server.exe --service-start
    ::ECHO.
    ::ECHO Redis installed as service.
    ::ECHO At this stage, you should restart your computer; otherwise music will absolutely not work.
    ::ECHO Due to the way how registry edits work, you'll need to restart your computer in order for them to take effect. If you don't, music will not work for the remainder of this computer's session.
	   ::ECHO.
    ::ECHO Press 1 to restart now, or press 2 if you plan to restart later.
    ::CHOICE /c 12

    ::IF ERRORLEVEL 2 GOTO :End
    ::IF ERRORLEVEL 1 GOTO :restartpc
	   ECHO Redis installed as service and started.

    GOTO End
  :already
    ::TODO
    ::what was this supposed to be again?


::[4]
:credentials
  ::Prompt user.
  ECHO.
  CLS
  ECHO Beginning credentials.json creation. This is only necessary when you run NadekoBot for the first time. Press [y] if you're ready to continue, or [n] to exit.

  CHOICE /c yn /m "[y] to continue, [n] to exit.

  IF ERRORLEVEL 2 GOTO :End
  IF ERRORLEVEL 1 ECHO Continuing credentials.json setup.
  timeout /t 2 >nul
  ::Begin credentials setup.
  CLS
  CD %nadeko%
  MOVE credentials.json credentials.json.bak

  ECHO Please enter your bot client ID:
  SET /p "botid="
  ECHO Saved %botid% as bot's client ID.
  ECHO.
  ECHO.

  ECHO Please enter your bot token. (This is NOT your bot secret!):
  SET /p "token="
  ECHO Saved %token% as bot token.
  ECHO.
  ECHO.

  ECHO Please enter your own ID. (can be found by pinging yourself and adding a \ before the @.):
  SET /p "ownerid="
  ECHO Saved %ownerid% as owner ID.
  ECHO.
  ECHO.

  ECHO Please enter your Google API Key. (Refer to the JSON setup guide.):
  SET /p "googleapikey="
  ECHO Saved %googleapikey% as Google API key.
  ECHO.
  ECHO.

  ECHO Please enter your LoL API Key. (Just press [Enter] to skip.):
  SET /p "lolapikey="
  ECHO Saved %lolapikey% as LoL API key.
  ECHO.
  ECHO.

  ECHO Please enter your Mashape API Key. (Just press [Enter] to skip.):
  SET /p "mashapeapikey="
  ECHO Saved %mashapeapikey% as Mashape API key..
  ECHO.
  ECHO.

  ECHO Please enter your osu! API Key. (Just press [Enter] to skip.):
  SET /p "osuapikey="
  ECHO Saved %osuapikey% as osu! API key..
  ECHO.
  ECHO.

    ECHO Please enter your Cleverbot API Key. (Just press [Enter] to skip.):
  SET /p "cleverbot="
  ECHO Saved %cleverbot% as official cleverbot API key.
  ECHO.
  ECHO.

  ECHO Writing changes to file...
  ::Begin pushing values to credentials.
  >credentials.json ECHO {
  >>credentials.json ECHO   "ClientId": %botid%,
  ::unneeded
  ::>>credentials.json ECHO   "BotId": %token%,
  >>credentials.json ECHO   "Token": "%token%",
  >>credentials.json ECHO   "OwnerIds": [
  >>credentials.json ECHO     %ownerid%
  >>credentials.json ECHO   ],
  >>credentials.json ECHO   "LoLApiKey": "%lolapikey%",
  >>credentials.json ECHO   "GoogleApiKey": "%googleapikey%",
  >>credentials.json ECHO   "MashapeKey": "%mashapeapikey%",
  >>credentials.json ECHO   "OsuApiKey": "%osuapikey%",
  >>credentials.json ECHO   "CleverbotApiKey": "%cleverbot%",
  ::unneeded
  ::>>credentials.json ECHO   "PatreonAccessToken": "%patreonapikey%",
  >>credentials.json ECHO   "Db": null,
  >>credentials.json ECHO   "TotalShards": 1,
  >>credentials.json ECHO 	"ShardRunCommand": "dotnet",
  >>credentials.json ECHO 	"ShardRunArguments": "run -c Release -- {0} {1}",
  >>credentials.json ECHO }

  ECHO Credentials setup completed.
  ::TODO
  GOTO End

::[5]
:exit
  exit


::Misc
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
    EXIT
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
	:win7
  	TITLE Incompatibility found.
  	ECHO.
  	ECHO Windows 7 is not supported by NadekoBot!
  	ECHO This is because web sockets aren't available on Windows 7. Blame Microsoft.
  	ECHO.
  	ECHO You have a couple of choices here:
  	ECHO.
  	ECHO 1.Use Docker Toolbox, a program similar to a virtual machine.
  	ECHO 2.Install a different OS (such as Windows 10 or Linux)
  	ECHO 3.Rent a VPS (Virtual Private Server), which has the added benefit of not needing to keep your own computer on all the time.
  	ECHO.
  	ECHO.
  	ECHO


	CHOICE /c 123

:End
  ::should reopen the script again
  pause
  CLS
  GOTO :startup
  ::fix shut up script pls
