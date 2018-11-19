
'Julio 2007
'Este script controla que el servicio de Escorpio funciona
'Sino funciona envia un mensaje 
'Para comprobar si funciona el servidor necesiata el ejecutable plink.exe


Set WshShell = WScript.CreateObject("WScript.Shell")

set run = wshShell.Exec("plink 10.1.1.5:22 -l root -pw 00asdejeno cat /tallerlocal/atcanet/postalasp/bin/runpostal-bg.sh.pid ")


pid=run.StdOut.ReadAll

If pid="" Then
	'Enviar mensaje de error
	Set cdoMail=CreateObject("CDO.Message")
	with cdoMail
	.Subject="Error en Escorpio"
	.From="escorpio@atcanet.com"
	.To="jbernad@atcanet.com"
	.TextBody="Error en Escorpio"
	.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/sendusing")=2
	'Name or IP of remote SMTP server
	.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/smtpserver") _
	="10.1.1.101"
	'Server port
	.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/smtpserverport") _
	=25 
	.Configuration.Fields.Update
	.Send
	end With
	
	set myMail=Nothing

End If

Set WshShell = Nothing
Set run = Nothing


