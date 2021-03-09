#!/bin/bash
#Purpose = Backup of Important Data
#Created on 18-11-2018
#Update on 15-02-2021
#Author = frojas
#Version 1.1

#START

#Definir variables
DATE=$(date +"%F")
WWWDIR=/var/www
PUBDIR=public_html

FILEEXT=tar.gz
SCRIPT_CONFIG_FILE=run.conf
AWS_BIN=/usr/local/bin/aws

#Definir directorios
TRGDIR=~/backups/sites

#Cargar parametros
source $SCRIPT_CONFIG_FILE
BCKDIR=$TRGDIR/$DATE

#Definir nombre de los sitios
sites=(example.com example.org example.co)
HOST_NAME=site.com

# Crear directorio
finalpath=$BCKDIR
mkdir -p $finalpath

BUCKET_DIR=$HOST_NAME/$BUCKET_DIR

#Recorrer sitios
for site in "${sites[@]}"; do
	apppath=$WWWDIR/$site

	echo "Backup $apppath"
	if [ -d "$apppath" ]; then

		cd $WWWDIR

		TIME=$(date +%Y%m%d_%H%M%S)
		filename=$TIME-$site.tar.gz

		destination=$finalpath/$filename
		source=$site/$PUBDIR

		echo "Dumping $source"
		tar -Pcpzf $destination $source
		tar Ozxf $destination >/dev/null
		status=$?

		BUCKET_PATH=$BUCKET_NAME/$BUCKET_DIR/$site/$DATE

		# echo "Uploading $AWS_BIN s3 cp $destination s3://$BUCKET_PATH/"

		# Validar salida del comando anterior
		if test $status -eq 0; then
			echo "Uploading $filename"
			$AWS_BIN s3 cp $destination s3://$BUCKET_PATH/
		fi

	fi
done

# Listar archivos
ls -lh $BCKDIR

echo "Deleting old files in $TRGDIR"
find $TRGDIR/* -type d -ctime +7 -exec rm -rf {} \;

# Listar directorios
ls -lh $TRGDIR

#Descomprimir
#tar -xzvf archivo.tar.gz
#END
