# Mezcla todos los mensajes de webmail de todas las carpetas en un unico
# fichero del tipo mailbox que pueda tratar mozilla

header=../header
dstFile=../msgs

echo "From - Wed Oct 15 09:21:05 2003" >$header

find . -name "*.msg" -exec cat $header {} >> $dstFile \;
