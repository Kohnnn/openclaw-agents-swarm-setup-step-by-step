@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul 2>&1
title Claw-Empire

:: ============================================================
::  Claw-Empire Daily Launcher
::  Starts pnpm dev:local with required environment fixes:
::    1. NODE_OPTIONS=--experimental-sqlite  (Node v22 requirement)
::    2. Uses native pnpm.exe (bypasses broken corepack shim)
:: ============================================================

cd /d "%~dp0claw-empire"
if !ERRORLEVEL! neq 0 (
    echo [ERROR] Could not enter claw-empire directory.
    echo         Run setup_claw_empire.bat first.
    pause
    exit /b 1
)

:: Use native pnpm to bypass corepack signature verification bug
set "PNPM_CMD="
if exist "%LOCALAPPDATA%\pnpm\pnpm.exe" (
    set "PNPM_CMD=%LOCALAPPDATA%\pnpm\pnpm.exe"
) else (
    set "PNPM_CMD=pnpm"
)

:: Enable Node.js experimental SQLite (required for node:sqlite builtin on Node v22)
set "NODE_OPTIONS=--experimental-sqlite"

echo.
echo ========================================================
echo    Claw-Empire  -  Starting dev:local server
echo    UI will be at: http://127.0.0.1:8800
echo ========================================================
echo.

call "!PNPM_CMD!" dev:local
