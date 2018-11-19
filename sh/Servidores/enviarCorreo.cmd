rem %1 destinatario/s si son varios separados por coma y sin espacios
rem %2 "asunto"
rem %3 "cuerpo"

if "%1"=="escorpio" goto escorpio
if "%1"=="" goto error
if %2=="" goto error
if %3=="" goto error

set destinatario=%1
set cabecera=%2
set cuerpo=%3
goto enviar

:escorpio
set destinatario=jbernad@atcanet.com,clopez@atcanet.com
set cabecera="Error en escorpio"
set cuerpo="Error en escorpio"

goto enviar

:enviar
bmail -s tauro.atcanet -t %destinatario% -f micro@atcanet.com -h -a %cabecera% -b %cuerpo%
goto fin

:error
echo enviarCorreo destinatario1,destinatario2 "asunto" "cuerpo"

:fin
