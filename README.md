# Websites Backup Linux Script

## Crear directorios
```
cd ~
mkdir -p scripts/backups
mkdir -p backups/sites
```

## Obtener script
```
cd ~/scripts/backups
git clone https://github.com/gfourmis/websites-backup.git
cd websites-backup
```
## Editar configuración
```
cp run-example.conf run.conf
```
```
nano run.conf
```

## Asignar permisos al script
```
chmod +x run.sh
```

## Ejecutar script
```
./run.sh
```

## Listar archivos
```
ls -lh ~/backups/
```

## Configurar destino
Previamente **se debe configurar _AWS cli_** para poder subir los archivos a *AWS S3* en lo posible no almacenar los archivos en ~~local~~.

## Configurar tareas programadas
```
crontab -e
```
El primer día de cada mes a las 03:00
> 0 3 1 * * /bin/bash /home/ubuntu/scripts/backups/websites-backup/run.sh



