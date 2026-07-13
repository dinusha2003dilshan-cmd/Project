@echo off
setlocal
cd /d "%~dp0\.."
set "CP=target\classes;target\smart-boys-fashion\WEB-INF\lib\mysql-connector-j-8.3.0.jar"
java -cp "%CP%" com.smartboys.util.SchemaRunner database\schema.sql "jdbc:mysql://localhost:3306/smartboysdb?useSSL=false&serverTimezone=UTC" root ""
echo SCHEMA_RUN_EXIT=%ERRORLEVEL%
endlocal