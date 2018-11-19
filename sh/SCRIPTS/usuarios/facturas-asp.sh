#!/bin/bash

ENTIDAD=reteri
COMUNICADO=TENARIA
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt

ENTIDAD=retena
COMUNICADO=TENARIA
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt

ENTIDAD=EMABESA
COMUNICADO=FACEMABESA
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt

ENTIDAD=EMABESA
COMUNICADO=Bienvenida
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt

ENTIDAD=CASSA
COMUNICADO=CASSA3
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt

ENTIDAD=CAID
COMUNICADO=CASSA3
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt

ENTIDAD=AUNA
COMUNICADO=FACTURA
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt
ENTIDAD=AUNA
COMUNICADO=DUPLI
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt
ENTIDAD=AUNA
COMUNICADO=PRUEB
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt
ENTIDAD=AUNA
COMUNICADO=MAILI
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt

ENTIDAD=IAUNA
COMUNICADO=informa-ono
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt

ENTIDAD=atca
COMUNICADO=NOMINA
echo "Generando facturas $1-$ENTIDAD-$COMUNICADO ..."
mkdir -p /root/logs/facturas/$ENTIDAD
cd /root/logs/facturas/$ENTIDAD
cat /tallerlocal/atcanet/postal/data/statistic/$ENTIDAD/postalEst_$1* | grep $COMUNICADO > $1-$ENTIDAD-$COMUNICADO.txt

cd /root/logs/facturas
find . -name $1* -exec wc -l {} \; > $1.txt
