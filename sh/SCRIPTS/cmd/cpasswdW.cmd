@echo off
setlocal
set PATH=%PATH%;\programasEnRed\util
set host=192.168.2.1
set tempFile=%TEMP%\cpassw$567

echo Usuario:
cinput %tempFile%
set /P userName= < %tempFile%
del %tempFile%
echo .

if "%userName%" == "" goto error
echo Antigua contrase¤a:
cinput --noecho %tempFile%
set /P oldPassword= < %tempFile%
del %tempFile%
echo .

if "%oldPassword%" == "" goto error
echo Nueva contrase¤a:
cinput --noecho %tempFile%
set /P newPassword= < %tempFile%
del %tempFile%
echo .

if "%newPassword%" == "" goto error
echo Confirma nueva contrase¤a:
cinput --noecho %tempFile%
set /P confirmPassword= < %tempFile%
del %tempFile%
echo .

if not "%newPassword%" == "%confirmPassword%" goto errorCNC

rexecpb  %host%  -l %userName% -p %oldPassword% "(sleep 1s; echo %oldPassword%) | sudo /atcanet/desarrollo/scripts/bash/changeAllPasswords %newPassword%"
goto end

:usage
echo uso: %0 
goto end

:error
echo cpasswdW: Datos no v lidos
goto end

:errorCNC
echo cpasswdW: Las contrase¤as nuevas no coinciden
goto end


:end

endlocal
pause
