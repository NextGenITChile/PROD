@if (@CodeSection == @Batch) @then
@echo off & setlocal

SET "SUFFIX=TVT"
SET "MASTER=10.251.212.10,10.251.212.11,10.251.212.12"

echo "Desinstalar Salt Minion anterior"
echo "-----------------------"
echo "Proceso tomará 30 segundos..."
echo.
start /wait "" "C:\Program Files\Salt Project\Salt\uninst.exe" /S /delete-root-dir
timeout /t 30 /nobreak >nul

echo "Eliminando configuraciones previas"
echo "-----------------------"
echo.
msiexec /X Salt-Minion-3007.1-Py3-AMD64.msi /norestart /quiet REMOVE_CONFIG=1

echo "Limpieza de directorios"
echo "-----------------------"
echo.
rmdir /s /q "C:\ProgramData\Salt Project\Salt\conf\pki\minion"
 
FOR /F "tokens=*" %%i IN ('hostname') DO SET HOSTNAME=%%i
 
for /f "delims=" %%I in ('cscript /nologo /e:JScript "%~f0" "%HOSTNAME%"') do set "HOSTNAME_UPPER=%%~I"
 
SET MINION_ID=%SUFFIX%_%HOSTNAME_UPPER%
echo El MINION_ID es: %MINION_ID%
echo "-----------------------"
echo.
echo "Instalación Salt Minion 3007.1"
echo "-----------------------"
echo.
msiexec /i Salt-Minion-3007.1-Py3-AMD64.msi /norestart /quiet MASTER=%MASTER% START_MINION=1 MINION_ID="%MINION_ID%"
goto :EOF
 
@end // end Batch / begin JScript hybrid
WSH.Echo(WSH.Arguments(0).toUpperCase());