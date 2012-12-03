#!/bin/bash

# Autor: Nelson Hereveri San Martín <nelson@hereveri.cl>

echo ""
echo "Esta es una obra de creación libre bajo licencia Creative Commons con propiedades de Attribution y Share Alike"
echo ""
echo "Básicamente significa: El material creado por un artista puede ser distribuido, copiado y exhibido por terceros"
echo "si se muestra en los créditos. Las obras derivadas tienen que estar bajo los mismos términos de licencia que el"
echo "trabajo original."
echo "Extraído de http://www.creativecommons.cl/tipos-de-licencias/"
echo ""
read -p "¿Está de acuerdo con la licencia CC ShareAlike and Attribution (s/N): " ACUERDO
if [ "$ACUERDO" != "s" ]; then
  echo ""
  echo "Está bien... nos leemos en otro momento"
  echo ""
  unset ACUERDO
  exit -1
fi

#rm -fr .disk md5sum.txt dists public.txt README.diskdefines ubuntu

# Releases
  declare -a releases
  releases[0]="Warty Warthog:warty:4.10"
  releases[1]="Hoary Hedgehog:hoary:5.04"
  releases[2]="Breezy Badger:breezy:5.10"
  releases[3]="Dapper Drake:dapper:6.06"
  releases[4]="Edgy Eft:edgy:6.10"
  releases[5]="Feisty Fawn:feisty:7.04"
  releases[6]="Gutsy Gibbon:gutsy:7.10"
  releases[7]="Hardy Heron:hardy:8.04"
  releases[8]="Intrepid Ibex:intrepid:8.10"
  releases[9]="Jaunty Jackalope:jaunty:9.04"
  releases[10]="Karmic Koala:karmic:9.10"
  releases[11]="Lucid Lynx:lucid:10.04"
  releases[12]="Maverick Meerkat:maverick:10.10"

  RELEASE_DATA=""

  for (( i=0; i<13 ; i=i+1 ));  do
    echo ${releases[$i]} | cut -d ":" -f 2
  done

  read -p "Release: " RELEASE
  case $RELEASE in
    warty)
      RELEASE_DATA=${releases[0]}
    ;;
    hoary)
      RELEASE_DATA=${releases[1]}
    ;;
    breezy)
      RELEASE_DATA=${releases[2]}
    ;;
    dapper)
      RELEASE_DATA=${releases[3]}
    ;;
    edgy)
      RELEASE_DATA=${releases[4]}
    ;;
    feisty)
      RELEASE_DATA=${releases[5]}
    ;;
    gutsy)
      RELEASE_DATA=${releases[6]}
    ;;
    hardy)
      RELEASE_DATA=${releases[7]}
    ;;
    intrepid)
      RELEASE_DATA=${releases[8]}
    ;;
    jaunty)
      RELEASE_DATA=${releases[9]}
    ;;
    karmic)
      RELEASE_DATA=${releases[10]}
    ;;
    lucid)
      RELEASE_DATA=${releases[11]}
    ;;
    maverick)
      RELEASE_DATA=${releases[12]}
    ;;
    *)
      echo "ERROR"
      unset RELEASE_DATA ACUERDO
      exit -1
    ;;
  esac

echo ""
echo "PROCESO NO AUTOMATIZADO"
echo "Ponga cuidado con indicar fielmente la arquitectura aplicada para sus paquetes deb"
echo "powerpc y sparc ya no son soportadas oficialmente por las más recientes versiones de Ubuntu"
echo "lpia tuvo un soporte limitado para algunas versiones, favor asegúrese que es la indicada para los paquetes"
read -p "Arquitectura para su CD (i386, amd64, powerpc, sparc, lpia): " ARQUITECTURA

echo -n "$ARQUITECTURA: "
case $ARQUITECTURA in
  i386)
    echo "OK"
    ;;
  amd64)
    echo "OK"
    ;;
  powerpc)
    echo "OK"
    ;;
  sparc)
    echo "OK"
    ;;
  lpia)
    echo "OK"
    ;;
  *)
    echo "ERROR"
    unset RELEASE_DATA ACUERDO ARQUITECTURA
    exit -1
    ;;
esac

DESCRIPCION="Ubuntu `echo $RELEASE_DATA | cut -d ":" -f 3` - $ARQUITECTURA"

########################################################
if [ ! -d .disk ]; then
    mkdir .disk
fi

if [ -a ./.disk/base_components ]; then
    rm -f ./.disk/base_components
fi

########################################################
echo ""
echo "Creando componentes ..."
COMP=""
for DIR in `ls pool`; do
    mkdir -m 755 -p dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/$DIR/binary-$ARQUITECTURA
    echo -e "\t$DIR"
    apt-ftparchive packages ./pool/$DIR > dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/$DIR/binary-$ARQUITECTURA/Packages
    cat dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/$DIR/binary-$ARQUITECTURA/Packages | gzip -9 > dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/$DIR/binary-$ARQUITECTURA/Packages.gz
    echo $DIR >> .disk/base_components
  COMP="$COMP $DIR"
  echo -n " $DIR" >> components
    echo "Archive: `echo $RELEASE_DATA | cut -d ":" -f 2`" > dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/$DIR/binary-$ARQUITECTURA/Release
    echo "Version: `echo $RELEASE_DATA | cut -d ":" -f 3`" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/$DIR/binary-$ARQUITECTURA/Release
    echo "Component: $DIR" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/$DIR/binary-$ARQUITECTURA/Release
    echo "Origin: Ubuntu" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/$DIR/binary-$ARQUITECTURA/Release
    echo "Label: Ubuntu" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/$DIR/binary-$ARQUITECTURA/Release
    echo "Architecture: $ARQUITECTURA" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/$DIR/binary-$ARQUITECTURA/Release
done

########################################################
echo ""
echo "Creando Release ..."
echo "Origin: Ubuntu" > dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/Release
echo "Label: Ubuntu" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/Release
echo "Suite: `echo $RELEASE_DATA | cut -d ":" -f 2`" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/Release
echo "Version: `echo $RELEASE_DATA | cut -d ":" -f 3`" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/Release
echo "Codename: `echo $RELEASE_DATA | cut -d ":" -f 2`" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/Release
echo "Date: `date`" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/Release
echo "Architectures: $ARQUITECTURA" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/Release
echo "Components:`cat components`" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/Release
echo "Description: $DESCRIPCION" >> dists/`echo $RELEASE_DATA | cut -d ":" -f 2`/Release
rm -f components
cd dists/`echo $RELEASE_DATA | cut -d ":" -f 2` # Buscar forma más elegante
echo "MD5Sum:" >> Release
for FILE in `find . -type f | grep -v Release | sed 's/\.\///g'`; do
    printf " %s %8s %s\n" `md5sum $FILE | awk '{print $1}'` `du -bs $FILE | awk '{print $1}'` `echo -n $FILE` >> Release
done
echo "SHA1:" >> Release
for FILE in `find . -type f | grep -v Release | sed 's/\.\///g'`; do
    printf " %s %8s %s\n" `sha1sum $FILE | awk '{print $1}'` `du -bs $FILE | awk '{print $1}'` `echo -n $FILE` >> Release
done

echo ""
echo "Ahora ud. puede firmar su CD y luego compartir su clave pública para que otros usuarios puedan utilizar este CD."
echo "Debe tener instalado el paquete gnupg y crear una llave para ud. 'gpg --gen-key'"
echo "Puede hacer esto en otra terminal, luego volver y continuar con este script."
echo ""
read -p "¿Desea firmar su archivo Release? (s/N): " FIRMA
if [ "$FIRMA" == "s" ]; then
  echo "Firmando su CD..."
  gpg -abs -o Release.gpg Release
  echo "No olvide presentar su clave pública."
else
  echo "NO HA FIRMADO SU CD. Al actualizar o instalar paquetes se le advertirá que el contenido es no seguro."
fi
cd ../..
if [ "$FIRMA" == "s" ]; then
  echo "Exportando clave pública al directorio base..."
  gpg --export -a -o public.txt
fi

########################################################
echo ""
echo "Creando info ..."
echo "$DESCRIPCION - Release $ARQUITECTURA (`date +%G%m%d`)" > .disk/info

########################################################
echo "Creando disk defines ..."
echo "#define DISKNAME $DESCRIPCION - Release $ARQUITECTURA" > README.diskdefines
echo "#define TYPE binary" >> README.diskdefines
echo "#define TYPEbinary 1" >> README.diskdefines
echo "#define ARCH $ARQUITECTURA" >> README.diskdefines
echo "#define ARCH$ARQUITECTURA 1" >> README.diskdefines
echo "#define DISKNUM 1" >> README.diskdefines
echo "#define DISKNUM1 1" >> README.diskdefines
echo "#define TOTALNUM 1" >> README.diskdefines
echo "#define TOTALNUM1 1" >> README.diskdefines

########################################################
echo "Creando archivo md5sum.txt ..."
for FILE in `find . -type f | grep -v .sh$`; do
    if [ ! -d $FILE ]; then
        md5sum $FILE >> md5sum.txt
    fi
done

########################################################
echo "Creando links ..."
ln -s . ubuntu
cd dists # Buscar una forma más elegante
ln -s `echo $RELEASE_DATA | cut -d ":" -f 2` stable
ln -s `echo $RELEASE_DATA | cut -d ":" -f 2` unstable
cd ..

########################################################
echo ""
echo "Directorio actual listo para quemar :)"
echo ""
echo "Imagen ISO con:"
echo -e "\t$ mkisofs -J -joliet-long -jcharset UTF-8 -R -V \"$DESCRIPCION\" -o ../imagen.iso ."
echo ""
echo "Ruta al /etc/apt/sources.list:"
echo -e "\tdeb file:`pwd` `echo $RELEASE_DATA | cut -d ":" -f 2`$COMP"
echo ""
echo "BORRE LOS ARCHIVOS CON LOS SCRIPTS ANTES DE QUEMAR O CREAR ISO"
echo ""

unset ARQUITECTURA DESCRIPCION FIRMA RELEASE_DATA releases FILE COMP ACUERDO

########################################################
exit 0
