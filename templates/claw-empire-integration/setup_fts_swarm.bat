@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo   FTS Swarm Setup - Agent Workspace Generator
echo ========================================================
echo.
echo This script will create the 9 OpenClaw agent workspaces
echo and inject the custom FTS identities and rules.
echo.

set "OC_DIR=%USERPROFILE%\.openclaw"

echo 1. Creating Agent Workspaces...
call openclaw agents add orchestrator --workspace "%OC_DIR%\workspace-orchestrator"
call openclaw agents add security_architect --workspace "%OC_DIR%\workspace-security_architect"
call openclaw agents add sub1 --workspace "%OC_DIR%\workspace-sub1"
call openclaw agents add sub2 --workspace "%OC_DIR%\workspace-sub2"
call openclaw agents add sub3 --workspace "%OC_DIR%\workspace-sub3"
call openclaw agents add data_engineer --workspace "%OC_DIR%\workspace-data_engineer"
call openclaw agents add reviewer --workspace "%OC_DIR%\workspace-reviewer"
call openclaw agents add test_automation --workspace "%OC_DIR%\workspace-test_automation"
call openclaw agents add compliance_auditor --workspace "%OC_DIR%\workspace-compliance_auditor"

echo.
echo 2. Injecting Shared Rules (USER.md)...
set "SHARED_DIR=%~dp0..\samples\shared"
for %%A in (orchestrator security_architect sub1 sub2 sub3 data_engineer reviewer test_automation compliance_auditor) do (
    copy /y "%SHARED_DIR%\USER.md" "%OC_DIR%\workspace-%%A\USER.md" >nul
)

echo.
echo 3. Injecting Role-Specific Rules and Identities...
set "SAMPLES_DIR=%~dp0..\samples"
for %%A in (orchestrator security_architect sub1 sub2 sub3 data_engineer reviewer test_automation compliance_auditor) do (
    copy /y "%SAMPLES_DIR%\%%A\SOUL.md" "%OC_DIR%\workspace-%%A\SOUL.md" >nul
    copy /y "%SAMPLES_DIR%\%%A\AGENTS.md" "%OC_DIR%\workspace-%%A\AGENTS.md" >nul
    copy /y "%SAMPLES_DIR%\%%A\IDENTITY.md" "%OC_DIR%\workspace-%%A\IDENTITY.md" >nul
    copy /y "%SAMPLES_DIR%\%%A\TOOLS.md" "%OC_DIR%\workspace-%%A\TOOLS.md" >nul
)

echo.
echo 4. Registering Identities...
for %%A in (orchestrator security_architect sub1 sub2 sub3 data_engineer reviewer test_automation compliance_auditor) do (
    call openclaw agents set-identity --workspace "%OC_DIR%\workspace-%%A" --from-identity
)

echo.
echo ========================================================
echo   Success! 9-Agent FTS Swarm workspaces are ready.
echo   Check your 'openclaw.json' to ensure models are set.
echo ========================================================
pause
