@echo off

setlocal

set PATH=%PATH%;\programasEnRed\util

set host=192.168.2.1
set csPath=/atcanet/desarrollo/scripts/bash/csExtract

if "%1" == "x" goto extract
if "%1" == "X" goto extract

rexecpb  %host%  -l guest  -p atcanet  %csPath%  %*
goto end


:extract

set tempFile=%TEMP%\cse$567

echo Usuario:
cinput %tempFile%
set /P csUserName= < %tempFile%
del %tempFile%
echo .

if "%csUserName%" == "" goto :usage

echo Contrase¤a:
cinput --noecho %tempFile%
set /P csPassword= < %tempFile%
del %tempFile%
echo .

if "%csPassword%" == "" goto :usage


echo user: %csUserName%
echo pass: %csPassword%

set csDir=/atcanet/desarrollo/scripts/bash/recover/%csUserName%

rexecpb  %host% -l %csUserName% -p %csPassword%  %csPath%  %*
curl -o "%USERPROFILE%\Escritorio\recover.zip" "ftp://%csUserName%:%csPassword%@tauro/%csDir%/recover.zip"
rexecpb  %host% -l %csUserName% -p %csPassword%  rm -R %csDir%

goto end


:usage
echo uso:  %0  accion [copia] [version] [m scara]
echo donde
echo   * accion     l    para listar
echo                x    para extraer


:end

endlocal
