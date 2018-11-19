
echo "GENERANDO CABECERA ..."
cat index.cabecera > index.html
echo "GENERANDO WIKIS OBSOLETOS ..."
echo "<tr><td valign=\"top\"><table border=\"1\">" >> index.html
echo "<tr><th>Wacko-Wiki (Obsoleto)</th></tr>" >> index.html
for i in wikis/*; do
    if [ -d $i ]; then
	nombre=`cat $i/NOMBRE.txt 2>/dev/null`
	if [ $? != 0 ]; then nombre=$i; fi
	if [ "$nombre" == "" ]; then nombre=$i; fi
	if [ "$nombre" != "OCULTAR" ]; then
	    echo "\
		<tr><td>\
		<a href=\"$i\">$nombre</a>\
		</td></tr>\
		" >> index.html
	fi
    fi
done
echo "GENERANDO WIKIS ..."
echo "</table></td><td valign=\"top\"><table border=\"1\" cellpadding=\"1\">" >> index.html
echo "<tr><th>Wiki-Media</th></tr>" >> index.html
for i in wikimedia/*; do
    if [ -d $i ]; then
	nombre=`cat $i/NOMBRE.txt 2>/dev/null`
	if [ $? != 0 ]; then nombre=$i; fi
	if [ "$nombre" == "" ]; then nombre=$i; fi
	if [ "$nombre" != "OCULTAR" ]; then
	    echo "\
		<tr><td nowrap>\
		<a href=\"$i\">$nombre</a>\
		</td></tr>\
		" >> index.html
	fi
    fi
done
echo "GENERANDO DOCUMENTACION ..."
echo "</table></td><td valign=\"top\"><table border=\"1\">" >> index.html
echo "<tr><th>Documentación</th></tr>" >> index.html
for i in documentacion/*; do
    if [ -d $i ]; then
	nombre=`cat $i/NOMBRE.txt 2>/dev/null`
	if [ $? != 0 ]; then nombre=$i; fi
	if [ "$nombre" == "" ]; then nombre=$i; fi
	if [ "$nombre" != "OCULTAR" ]; then
	    echo "\
		<tr><td>\
		<a href=\"$i\">$nombre</a>\
		</td></tr>\
		" >> index.html
	fi
    fi
done
echo "GENERANDO SOFTWARE ..."
echo "</table></td><td valign=\"top\"><table border=\"1\">" >> index.html
echo "<tr><th>Software</th></tr>" >> index.html
for i in bazar/*; do
    if [ -d $i ]; then
	nombre=`cat $i/NOMBRE.txt 2>/dev/null`
	if [ $? != 0 ]; then nombre=$i; fi
	if [ "$nombre" == "" ]; then nombre=$i; fi
	if [ "$nombre" != "OCULTAR" ]; then
	    echo "\
		<tr><td>\
		<a href=\"$i\">$nombre</a>\
		</td></tr>\
		" >> index.html
	fi
    fi
done
echo "GENERANDO PIE ..."
echo "</table></td></tr>" >> index.html
cat index.pie >> index.html
echo "GENERANDO VERSIONES PRODUCTOS ..."
svn ls svn://toro/gema/postal/tags > documentacion/productos/gema/GemaPostal.versiones
svn log -v --stop-on-copy svn://toro/gema/postal/tags/ > documentacion/productos/gema/GemaPostal.versiones.log
svn ls svn://toro/gema/postal/branches/ > documentacion/productos/gema/GemaPostal.ramas
svn log -v --stop-on-copy svn://toro/gema/postal/branches/ > documentacion/productos/gema/GemaPostal.ramas.log
svn ls svn://toro/gema/visualWebService/tags/ > documentacion/productos/gema/GemaVisualWebService.versiones
svn log -v --stop-on-copy svn://toro/gema/visualWebService/tags/ > documentacion/productos/gema/GemaVisualWebService.versiones.log

