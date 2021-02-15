#!/bin/bash
#Purpose = Backup of Important Data
#Created on 18-11-2018
#Author = frojas
#Version 1.1
#START

#Definir variables
DATE=$(date +"%F")
WWWDIR=/var/www
PUBDIR=public_html
TRGDIR=~/backups/sites
BCKDIR=$TRGDIR/$DATE
FILEEXT=tar.gz
AWS_BIN=/usr/local/bin/aws

#Definir el nombre del bucket
BUCKET_NAME=my-aws-s3-bucket-name

#Definir nombre de los sitios
sites=(example.com example.org example.co)

# Crear directorio
finalpath=$BCKDIR
mkdir -p $finalpath

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

		BUCKET_DIR=$sites/sites/$DATE
		BUCKET_PATH=$BUCKET_NAME/$BUCKET_DIR

echo "Uploading $AWS_BIN s3 cp $destination s3://$BUCKET_PATH/"

		# Validar salida del comando anterior
		if test $status -eq 0; then
			echo "Uploading $filename"
			$AWS_BIN s3 cp $destination s3://$BUCKET_PATH/
		fi

	fi
done

# ls -lh $BCKDIR

echo "Deleting old files in $TRGDIR"
find $TRGDIR/* -type d -ctime +7 -exec rm -rf {} \;

#Descomprimir
#tar -xzvf archivo.tar.gz
#END
