@echo off
rem	Comprueba si esta conectado

@echo ******************************************************
@echo	 	      %1
@echo ******************************************************
@ping -n 1 %2 

rem 	Marca en el log

set marcaTiempo=%date%    %time%  ***************************

rem 	Prepara el archivo
set logPath=log\
set logExt=.log

set log=%logPath%%1%logExt%

rem	Escribe en el archivo

echo. >>%log%
echo %marcaTiempo% >>%log%

@ping -n 1 %2 >>%log%