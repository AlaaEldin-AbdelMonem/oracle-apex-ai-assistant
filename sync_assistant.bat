@echo off
echo --- Syncing Oracle APEX AI Assistant ---
:: Ensure we are in the correct folder
cd /d %~dp0

echo [1/2] Pulling latest changes from GitHub...
git pull origin main

echo [2/2] Preparing to upload your changes...
git add .
set /p msg="Enter change description (commit message): "
git commit -m "%msg%"
git push origin main

echo --- Sync Complete! ---
pause