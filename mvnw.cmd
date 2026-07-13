@echo off
REM Lightweight Maven wrapper for Windows: downloads Maven distribution on first run.
setlocal
set MAVEN_VERSION=3.9.6
set WRAPPER_DIR=%~dp0.mvn\wrapper
set MAVEN_DIR=%WRAPPER_DIR%\apache-maven-%MAVEN_VERSION%

if not exist "%MAVEN_DIR%\bin\mvn.cmd" (
  echo Maven not present locally; downloading Apache Maven %MAVEN_VERSION%...
  powershell -NoProfile -ExecutionPolicy Bypass -Command "if(-not (Test-Path '%WRAPPER_DIR%')){ New-Item -ItemType Directory -Path '%WRAPPER_DIR%' | Out-Null }; Invoke-WebRequest -Uri 'https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip' -OutFile '%WRAPPER_DIR%\\apache-maven-%MAVEN_VERSION%.zip' -UseBasicParsing; Expand-Archive -Path '%WRAPPER_DIR%\\apache-maven-%MAVEN_VERSION%.zip' -DestinationPath '%WRAPPER_DIR%' -Force; Remove-Item '%WRAPPER_DIR%\\apache-maven-%MAVEN_VERSION%.zip' -Force"
  if %errorlevel% neq 0 (
    echo Failed to download/expand Maven. Please install Maven manually and re-run.
    exit /b 1
  )
)

"%MAVEN_DIR%\bin\mvn.cmd" %*
