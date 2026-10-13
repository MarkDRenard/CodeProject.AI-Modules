@echo off
rem CodeProject.AI Module Installation Script for Windows
if "%1" NEQ "install" (
    echo This script must be launched via CodeProject Server core setup protocols.
    goto:eof
)

rem Initialize Local Logging Frameworks with Debug Capture
if not exist "%~dp0logs" (
    mkdir "%~dp0logs"
)

echo ======================================================== > "%~dp0logs\Setup.log"
echo         ObjectDetectionYOLO26 Automated Template         >> "%~dp0logs\Setup.log"
echo ======================================================== >> "%~dp0logs\Setup.log"
echo Initializing environment diagnostics run... >> "%~dp0logs\Setup.log"

echo Installing dependencies for ObjectDetectionYOLO26...

echo ========================================================
echo         Installing Python 3.12 GPU Requirements        
echo ========================================================

set "LOCAL_VENV=%~dp0bin\windows\python312\venv"

echo Target Environment Path: %LOCAL_VENV% >> "%~dp0logs\Setup.log"

echo Step 1: Upgrading local pip context... >> "%~dp0logs\Setup.log"
"%LOCAL_VENV%\Scripts\python.exe" -m pip install --upgrade pip >> "%~dp0logs\Setup.log" 2>> "%~dp0logs\debug.log"

echo Step 2: Processing core package matrix compilation... >> "%~dp0logs\Setup.log"
"%LOCAL_VENV%\Scripts\python.exe" -m pip install -r "%~dp0requirements.txt" >> "%~dp0logs\Setup.log" 2>> "%~dp0logs\debug.log"

:: Downloader for YOLO26 models
setlocal enabledelayedexpansion

echo ========================================================
echo          Executing YOLO26 Model Provisioning        
echo ========================================================
echo ======================================================== >> "%~dp0logs\Setup.log"
echo         Executing YOLO26 Model Download Tasks            >> "%~dp0logs\Setup.log"
echo ======================================================== >> "%~dp0logs\Setup.log"

:: Step 1: Dynamically establish CodeProject's root by navigating up from \modules\ObjectDetectionYOLO26
pushd "%~dp0..\.."
set "CPAI_ROOT=%CD%"
popd

echo CodeProject Engine Root Path Resolved to: %CPAI_ROOT% >> "%~dp0logs\Setup.log"

:: Step 2: Establish the target folder where CodeProject expects the .zip payload
set "TARGET_DIR=%CPAI_ROOT%\downloads\modules\assets\ObjectDetectionYOLO26"
echo Destination Assets Target Path: %TARGET_DIR% >> "%~dp0logs\Setup.log"

:: Step 3: Ensure the target directory exists
if not exist "%TARGET_DIR%" (
    echo [YOLO26] Creating missing absolute asset download path...
    echo [YOLO26] Creating directory: %TARGET_DIR% >> "%~dp0logs\Setup.log"
    mkdir "%TARGET_DIR%" 2>> "%~dp0logs\debug.log"
)

:: Step 4: Define the case-specific download payload array
set "ZIP_LIST[0]=Detection-yolo26-pt.zip"
set "ZIP_LIST[1]=Segmentation-yolo26-pt.zip"
set "ZIP_LIST[2]=Custom-yolo26-pt.zip"

:: URL Reconstruction Components
set "GH_BASE=https://github.com"
set "GH_USER=MarkDRenard"
set "GH_REPO=YOLO26-models"
set "GH_VER=v1.1.1"

:: Step 5: Process loop sequence for payload deployment
for /L %%i in (0,1,2) do (
    set "ZIP_NAME=!ZIP_LIST[%%i]!"
    set "FULL_ZIP_PATH=%TARGET_DIR%\!ZIP_NAME!"
    
    rem Assembles the exact, complete download link on the fly without breaking filters
    set "RELEASE_URL=%GH_BASE%/%GH_USER%/%GH_REPO%/releases/download/%GH_VER%/!ZIP_NAME!"
    
    echo Checking asset deployment status: !ZIP_NAME!...
    echo Checking asset deployment status: !ZIP_NAME!... >> "%~dp0logs\Setup.log"
    
    if not exist "!FULL_ZIP_PATH!" (
        echo [YOLO26] Downloading !ZIP_NAME! from GitHub...
        echo [YOLO26] Target Destination: !FULL_ZIP_PATH! >> "%~dp0logs\Setup.log"
        echo Executing network fetch from unique URL: !RELEASE_URL! >> "%~dp0logs\Setup.log"
        
        :: -L handles GitHub redirection, -S and -f ensure clean error catching
        curl -L -f -S -o "!FULL_ZIP_PATH!" "!RELEASE_URL!" >> "%~dp0logs\Setup.log" 2>> "%~dp0logs\debug.log"
        
        if !errorlevel! EQU 0 (
            echo [YOLO26] !ZIP_NAME! successfully staged.
            echo SUCCESS: !ZIP_NAME! downloaded and verified. >> "%~dp0logs\Setup.log"
        ) else (
            echo [ERROR] Download failed for !ZIP_NAME!. Check logs\debug.log for network trace.
            echo CRITICAL FAILURE: Download failed for !ZIP_NAME! with curl exit code !errorlevel! >> "%~dp0logs\Setup.log"
            echo [ERROR] curl failed to retrieve payload from: !RELEASE_URL! >> "%~dp0logs\debug.log"
            echo -------------------------------------------------------- >> "%~dp0logs\debug.log"
        )
    ) else (
        echo [YOLO26] !ZIP_NAME! already present in download directory. Skipping.
        echo VERIFIED: !ZIP_NAME! package already cached locally. Skipping network operations. >> "%~dp0logs\Setup.log"
    )
)

echo ObjectDetectionYOLO26 module installation and Pytorch models downloads complete. >> "%~dp0logs\Setup.log"
echo ObjectDetectionYOLO26 module installation complete.
