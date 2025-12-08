@echo off
echo ================================
echo 🔧 Building chatAssistant JavaScript...
echo ================================

REM Paths
set SRC=src
set DIST=dist
set OUT=%DIST%\chatAssistant.min.js

REM Ensure dist exists
if not exist %DIST% (
    echo Creating dist folder...
    mkdir %DIST%
)

REM Remove old bundled file
if exist %OUT% del %OUT%

echo Creating new bundle: %OUT%
echo /* Chatpot Bundle - Auto Generated */ > %OUT%
echo /* Build Time: %DATE% %TIME% */ >> %OUT%
echo. >> %OUT%


REM Enforce module order (critical!)
echo Adding: chatPrompt.js
type %SRC%\chatPrompt.js >> %OUT%
echo. >> %OUT%

REM Enforce module order (critical!)
echo Adding: chatSession.js
type %SRC%\chatSession.js >> %OUT%
echo. >> %OUT%

echo Adding: chatMessage.js
type %SRC%\chatMessage.js >> %OUT%
echo. >> %OUT%

echo Adding: chatProjects.js
type %SRC%\chatProjects >> %OUT%
echo. >> %OUT%

 

echo ================================
echo 🚀 Chatpot bundle built!
echo 📦 Output: %OUT%
echo ================================

pause