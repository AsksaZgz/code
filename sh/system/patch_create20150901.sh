#! /bin/bash
# Parche dia 01/09/2015 contiene:
#
#
#
#find admin/* -daystart -mtime -25 -ls






#tar -czvf 20150901.tar.gz lib webapps/admin webapps/axis webapps/comun webapps/saas webapps/spn webapps/spn-common webapps/webconference/* --after-date='10 days ago'
#tar -czvf 20150901.tar.gz  --after-date='20 days ago' --files-from=20150901.include

tar -czvf 20150901.tar.gz  --after-date='30 days ago' --files-from=20150901.include --exclude-from=20150901.exclude

