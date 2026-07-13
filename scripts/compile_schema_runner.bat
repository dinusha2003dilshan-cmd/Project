@echo off
setlocal
cd /d "%~dp0\.."
set "JAR=%USERPROFILE%\.m2\repository\com\mysql\mysql-connector-j\8.3.0\mysql-connector-j-8.3.0.jar"
echo JAR=%JAR%
if not exist target\schemarunner mkdir target\schemarunner
if exist "%JAR%" (
    javac -cp "%JAR%" -d target\schemarunner scripts\SchemaRunner.java
    echo COMPILE_EXIT=%ERRORLEVEL%
) else (
    echo JAR missing: %JAR%
    exit /b 1
)
endlocal