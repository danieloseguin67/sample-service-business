@echo off
echo Setting up Service Business website in IIS...
echo.
echo This script will:
echo 1. Create an IIS website named "service-business"
echo 2. Set it to run on port 8082
echo 3. Configure it to serve the Angular application
echo.
echo Prerequisites:
echo - Run this as Administrator
echo - IIS must be installed and enabled
echo - URL Rewrite Module must be installed
echo.
pause

REM Check if running as administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: This script must be run as Administrator!
    echo Right-click on this file and select "Run as administrator"
    pause
    exit /b 1
)

REM Execute the PowerShell script
powershell.exe -ExecutionPolicy Bypass -File "setup-iis.ps1"

pause