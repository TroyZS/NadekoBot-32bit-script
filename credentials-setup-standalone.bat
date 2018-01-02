:credentials
  ::Prompt user.
  ECHO.
  CLS
  ECHO Beginning credentials.json creation. This is only necessary when you run NadekoBot for the first time. Press [y] if you're ready to continue, or [n] to exit.

  CHOICE /c yn /m "[y] to continue, [n] to exit.

  IF ERRORLEVEL 2 EXIT
  IF ERRORLEVEL 1 ECHO Continuing credentials.json setup.
  timeout /t 2 >nul
  ::Begin credentials setup.
  CLS
  ::CD %nadeko%
  ::MOVE credentials.json credentials.json.bak

  ECHO Please enter your bot client ID:
  SET /p "botid="
  ECHO Saved "%botid%" as bot's client ID.
  ECHO.
  ECHO.

  ECHO Please enter your bot token. (This is NOT your bot secret!):
  SET /p "token="
  ECHO Saved "%token%" as bot token.
  ECHO.
  ECHO.

  ECHO Please enter your own ID. (can be found by pinging yourself and adding a \ before the @.):
  SET /p "ownerid="
  ECHO Saved "%ownerid%" as owner ID.
  ECHO.
  ECHO.

  ECHO Please enter your Google API Key. (Refer to the JSON setup guide.):
  SET /p "googleapikey="
  ECHO Saved "%googleapikey%" as Google API key.
  ECHO.
  ECHO.

  ECHO Please enter your LoL API Key. (Just press [Enter] to skip.):
  SET /p "lolapikey="
  ECHO Saved "%lolapikey%" as LoL API key.
  ECHO.
  ECHO.

  ECHO Please enter your Mashape API Key. (Just press [Enter] to skip.):
  SET /p "mashapeapikey="
  ECHO Saved "%mashapeapikey%" as Mashape API key..
  ECHO.
  ECHO.

  ECHO Please enter your osu! API Key. (Just press [Enter] to skip.):
  SET /p "osuapikey="
  ECHO Saved "%osuapikey%" as osu! API key..
  ECHO.
  ECHO.

    ECHO Please enter your Cleverbot API Key. (Just press [Enter] to skip.):
  SET /p "cleverbot="
  ECHO Saved "%cleverbot%" as official cleverbot API key.
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
  
  ECHO.
  ECHO.
  ECHO Saved. 
  ECHO Please move the generated credentials.json into your system folder.
  PAUSE
  EXIT