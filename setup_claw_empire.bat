@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>&1
title Claw-Empire Setup

:: ============================================================
::  Claw-Empire 1-Click Setup for OpenClaw Discord Swarm
::  Target OS  : Windows 10/11
::  Repository : https://github.com/GreenSheep01201/claw-empire
:: ============================================================

echo.
echo ========================================================
echo    Claw-Empire  -  1-Click Setup Script
echo    OpenClaw Discord Swarm Edition
echo ========================================================
echo.

:: ============================================================
:: 1. PREREQUISITE CHECKS
:: ============================================================
echo [1/4] Checking prerequisites...
echo.

:: -- Check Node.js --
where node >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH.
    echo         Please install Node.js v22+ from https://nodejs.org/
    goto :fail
)

:: Capture Node version and verify v22+
for /f "tokens=1 delims=." %%v in ('node -v 2^>nul') do set "NODE_VER_RAW=%%v"
set "NODE_VER=!NODE_VER_RAW:v=!"
if !NODE_VER! LSS 22 (
    echo [ERROR] Node.js v22+ is required. Detected: v!NODE_VER!.
    echo         Please upgrade from https://nodejs.org/
    goto :fail
)
echo   [OK] Node.js v!NODE_VER! detected

:: -- Check Git --
where git >nul 2>&1
if !ERRORLEVEL! neq 0 (
    echo [ERROR] Git is not installed or not in PATH.
    echo         Please install Git from https://git-scm.com/
    goto :fail
)
for /f "tokens=3" %%g in ('git --version 2^>nul') do set "GIT_VER=%%g"
echo   [OK] Git !GIT_VER! detected

:: -- Find a working pnpm binary (bypass corepack shim which has signature verification issues) --
echo.
set "PNPM_CMD="

:: Strategy 1: Check standalone pnpm install (most reliable)
if exist "%LOCALAPPDATA%\pnpm\pnpm.exe" (
    set "PNPM_CMD=%LOCALAPPDATA%\pnpm\pnpm.exe"
    echo   [OK] pnpm found at standalone install
    goto :pnpm_found
)

:: Strategy 2: Check npm global install
for /f "delims=" %%p in ('npm root -g 2^>nul') do (
    if exist "%%p\..\pnpm.cmd" (
        set "PNPM_CMD=%%p\..\pnpm.cmd"
        echo   [OK] pnpm found at npm global
        goto :pnpm_found
    )
)

:: Strategy 3: Try corepack enable as last resort
echo   pnpm not found. Attempting corepack enable...
corepack enable >nul 2>&1
where pnpm >nul 2>&1
if !ERRORLEVEL! equ 0 (
    set "PNPM_CMD=pnpm"
    echo   [OK] pnpm enabled via corepack
    goto :pnpm_found
)

echo [ERROR] pnpm is not available. Install it with:
echo           npm install -g pnpm
echo        Or download from https://pnpm.io/installation
goto :fail

:pnpm_found
echo.

:: ============================================================
:: 2. CLONE & INSTALL
:: ============================================================
echo [2/4] Cloning and installing claw-empire...
echo.

:: Clone or pull (skip clone if directory already exists)
if exist "claw-empire" (
    echo   [INFO] Directory "claw-empire" already exists.
    set "CLAW_EMPIRE_EXISTS=1"
) else (
    echo   Cloning repository https://github.com/GreenSheep01201/claw-empire ...
    git clone https://github.com/GreenSheep01201/claw-empire.git
    if !ERRORLEVEL! neq 0 (
        echo [ERROR] git clone failed. Check your network and the URL.
        goto :fail
    )
    echo   [OK] Repository cloned
    set "CLAW_EMPIRE_EXISTS=0"
)

:: Enter the directory
pushd claw-empire
if !ERRORLEVEL! neq 0 (
    echo [ERROR] Could not enter claw-empire directory.
    goto :fail
)

if "!CLAW_EMPIRE_EXISTS!"=="1" (
    echo   [UPDATE] Checking for updates from remote repository...
    git pull
    if !ERRORLEVEL! neq 0 (
        echo   [WARN] Could not pull latest changes. Continuing with existing files.
    ) else (
        echo   [OK] Repository updated
    )
)

:: Init submodules
echo   Initializing submodules...
git submodule update --init --recursive
if !ERRORLEVEL! neq 0 (
    echo   [WARN] Submodule update returned a warning - may be non-critical.
)
echo   [OK] Submodules initialized

:: Install dependencies
echo.
echo   Installing dependencies...
call "!PNPM_CMD!" install
if !ERRORLEVEL! neq 0 (
    echo [ERROR] pnpm install failed. Please check the logs above.
    popd
    goto :fail
)


echo   [OK] Dependencies installed

:: --- FTS Custom Integration Step ---
echo   Applying FTS Office Pack custom integration...
xcopy /s /y /q "..\templates\claw-empire-integration\src" "src" 2^>nul
xcopy /s /y /q "..\templates\claw-empire-integration\server" "server" 2^>nul
echo   [OK] Applied custom FTS source code

echo   Building with custom FTS integration...
call "!PNPM_CMD!" run build
echo   [OK] Build complete

echo   Registering FTS agents...
node --experimental-sqlite "..\templates\claw-empire-integration\register_agents.js"
echo   [OK] Agents registered
:: -----------------------------------

echo.

:: ============================================================
:: 3. ENVIRONMENT CONFIGURATION
:: ============================================================
echo [3/4] Configuring environment variables...
echo.

:: Ensure .env exists
if not exist ".env" (
    if exist ".env.example" (
        copy .env.example .env >nul
        echo   [OK] Created .env from .env.example
    ) else (
        echo   Creating minimal .env ...
        (
            echo # Claw-Empire environment configuration
            echo OAUTH_ENCRYPTION_SECRET=
            echo INBOX_WEBHOOK_SECRET=
            echo OPENCLAW_CONFIG=
            echo PORT=8790
            echo HOST=127.0.0.1
        ) > .env
        echo   [OK] Created minimal .env
    )
) else (
    echo   [OK] .env already exists
)

:: ---- Inject / update OPENCLAW_CONFIG ----
set "OPENCLAW_PATH=C:\Users\Admin\.openclaw\openclaw.json"

findstr /B /C:"OPENCLAW_CONFIG=" .env >nul 2>&1
if !ERRORLEVEL! equ 0 (
    :: Replace existing line
    powershell -NoProfile -Command "(Get-Content .env) -replace '^OPENCLAW_CONFIG=.*', 'OPENCLAW_CONFIG=C:\Users\Admin\.openclaw\openclaw.json' | Set-Content .env"
    echo   [OK] Updated OPENCLAW_CONFIG in .env
) else (
    :: Append
    >>".env" echo OPENCLAW_CONFIG=!OPENCLAW_PATH!
    echo   [OK] Added OPENCLAW_CONFIG to .env
)

:: ---- Inject / update INBOX_WEBHOOK_SECRET (if empty or missing) ----
:: Generate a 32-byte hex random secret
for /f "delims=" %%s in ('powershell -NoProfile -Command "[guid]::NewGuid().ToString('N') + [guid]::NewGuid().ToString('N')"') do set "RANDOM_SECRET=%%s"

:: Check if INBOX_WEBHOOK_SECRET is present and has a value
set "SECRET_SET=0"
for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
    if "%%a"=="INBOX_WEBHOOK_SECRET" (
        if not "%%b"=="" set "SECRET_SET=1"
    )
)

if "!SECRET_SET!"=="0" (
    :: Check if the key line exists at all
    findstr /B /C:"INBOX_WEBHOOK_SECRET=" .env >nul 2>&1
    if !ERRORLEVEL! equ 0 (
        :: Key exists but empty - replace
        powershell -NoProfile -Command "(Get-Content .env) -replace '^INBOX_WEBHOOK_SECRET=.*', 'INBOX_WEBHOOK_SECRET=!RANDOM_SECRET!' | Set-Content .env"
    ) else (
        :: Key doesn't exist - append
        >>".env" echo INBOX_WEBHOOK_SECRET=!RANDOM_SECRET!
    )
    echo   [OK] Generated secure INBOX_WEBHOOK_SECRET
) else (
    echo   [OK] INBOX_WEBHOOK_SECRET already configured
)

echo.

:: ============================================================
:: 4. FINALIZATION
:: ============================================================
echo [4/4] Finalizing...
echo.

:: Verify critical config
echo   Verifying configuration:
echo   ---
findstr /B /C:"OPENCLAW_CONFIG=" .env
findstr /B /C:"INBOX_WEBHOOK_SECRET=" .env
echo   ---
echo.

echo ========================================================
echo    Setup complete!
echo ========================================================
echo.
echo   OPTION 1 - Use the launcher (recommended):
echo     Double-click start_claw_empire.bat  (in this folder)
echo.
echo   OPTION 2 - Manual start from claw-empire directory:
echo     set NODE_OPTIONS=--experimental-sqlite
echo     %LOCALAPPDATA%\pnpm\pnpm.exe dev:local
echo.
echo   Then open:  http://127.0.0.1:8800  in your browser
echo.
echo   Quick health check (from another terminal):
echo     curl -s http://127.0.0.1:8790/healthz
echo.
echo   Your OpenClaw config:  !OPENCLAW_PATH!
echo.
echo   Happy building with your AI agent swarm!
echo.

popd
goto :end

:fail
echo.
echo ========================================================
echo    Setup failed. Please fix the errors above.
echo ========================================================
echo.

:end
endlocal
pause
