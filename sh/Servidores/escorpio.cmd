rem	@echo off
plink 10.1.1.5:22 -l root -pw 00asdejen -m escorpio.bash >>log\escorpio2.log
if not errorlevel 1 goto final
enviarCorreo escorpio

:final
pause
