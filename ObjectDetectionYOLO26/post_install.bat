@echo off
REM post_install.bat - Final boundary model structure and file verifications

:: CodeProject passes "post-install" as %1, validating this call context
if "%1" NEQ "post-install" exit /b 0

setlocal enabledelayedexpansion

echo ============================================================
echo [YOLO26] Starting Combined Models Verification
echo ============================================================

echo ======================================================== > "%~dp0logs\Post_Install.log"
echo      ObjectDetectionYOLO26 Post-Install Verification     >> "%~dp0logs\Post_Install.log"
echo ======================================================== >> "%~dp0logs\Post_Install.log"
echo Initializing dynamic post-extraction structural scan... >> "%~dp0logs\Post_Install.log"

set "CRITICAL_FAILURE=0"
set "ASSETS_DIR=%~dp0assets"
set "CUSTOM_DIR=%~dp0custom-models"

:: --------------------------------------------------------
:: PHASE 1: ASSETS DIRECTORY SCAN
:: --------------------------------------------------------
echo [YOLO26] Running assets folder verification scan...
echo Scanning target location: %ASSETS_DIR% >> "%~dp0logs\Post_Install.log"

if not exist "%ASSETS_DIR%" (
    echo [ERROR] Expected core assets directory is completely missing. >> "%~dp0logs\Post_Install.log"
    set "CRITICAL_FAILURE=1"
) else (
    set "assets_count=0"
    pushd "%ASSETS_DIR%"
    for %%i in (*.pt) do (
        set /a assets_count+=1
        echo Verified local weight allocation: %%i >> "%~dp0logs\Post_Install.log"
    )
    popd
    
    echo Total compiled core weights discovered: !assets_count! >> "%~dp0logs\Post_Install.log"
    rem Expecting both Detection and Segmentation weights to be extracted here
    if !assets_count! LSS 2 (
        echo [ERROR] Asset file threshold not met. Missing weight payloads. >> "%~dp0logs\Post_Install.log"
        set "CRITICAL_FAILURE=1"
    )
)

:: --------------------------------------------------------
:: PHASE 2: CUSTOM-MODELS DIRECTORY SCAN
:: --------------------------------------------------------
echo [YOLO26] Running custom-models folder verification scan...
echo Scanning target location: %CUSTOM_DIR% >> "%~dp0logs\Post_Install.log"

if not exist "%CUSTOM_DIR%" (
    echo [ERROR] Expected custom-models directory is completely missing. >> "%~dp0logs\Post_Install.log"
    set "CRITICAL_FAILURE=1"
) else (
    set "custom_count=0"
    pushd "%CUSTOM_DIR%"
    for %%i in (*.pt) do (
        set /a custom_count+=1
        echo Verified custom weight allocation: %%i >> "%~dp0logs\Post_Install.log"
    )
    popd
    
    echo Total compiled custom weights discovered: !custom_count! >> "%~dp0logs\Post_Install.log"
    if !custom_count! LSS 1 (
        echo [ERROR] Custom weights directory contains no verified PyTorch payloads. >> "%~dp0logs\Post_Install.log"
        set "CRITICAL_FAILURE=1"
    )
)

:: --------------------------------------------------------
:: PHASE 3: CLEANUP HELPER AND ANOMALY ESCALATION
:: --------------------------------------------------------
if "%CRITICAL_FAILURE%"=="1" (
    echo ======================================================
    echo [YOLO26] ERROR: Critical model weights are missing or corrupt!
    echo ======================================================
    echo CRITICAL ANOMALY DETECTED: Triggering module protection cleanup fallback... >> "%~dp0logs\Post_Install.log"
    
    rem If the directories are present but broken/empty, purge them to avoid lockouts
    if exist "%ASSETS_DIR%" (
        echo Purging damaged assets allocation zone... >> "%~dp0logs\Post_Install.log"
        del /q /f "%ASSETS_DIR%\*.pt" 2>> "%~dp0logs\debug.log"
    )
    if exist "%CUSTOM_DIR%" (
        echo Purging damaged custom allocation zone... >> "%~dp0logs\Post_Install.log"
        del /q /f "%CUSTOM_DIR%\*.pt" 2>> "%~dp0logs\debug.log"
    )
    
    echo Post-install sequence aborted due to structural failure. >> "%~dp0logs\Post_Install.log"
    exit /b 1
)

echo [YOLO26] Post-install models download and folder integrity checks passed.
echo SUCCESS: All target runtime directories verified. Passing execution context over to engine core. >> "%~dp0logs\Post_Install.log"
exit /b 0
