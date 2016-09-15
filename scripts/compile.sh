#!/bin/bash
#################################################
# COMPILAR LOS ZIPS DEL ADDON GAMESTARTER
#################################################


#################################################
# crear los tar.gz de las carpetas de packages
#################################################

read -p "Do you want to make tar/zip packages (y/n)? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	# hacer un pack de carpeta para cada package y resources/data: 
	# emulationstation.tar.gz | libretro-extra-cores.tar.gz | uae4arm.tar.gz
	cd packages && tar -zcvf emulationstation.tar.gz emulationstation/ && cd ..
	cd packages && tar -zcvf uae4arm.tar.gz uae4arm/ && cd ..
	
	# advancedemulatorlauncher.tar.gz | advancedlauncher.tar.gz | emulators.tar.gz | libretro-part1.tar.gz | libretro-part2.tar.gz | retroarch.tar.gz
	# subir cada package actualizando el existente
	cd packages && tar -zcvf ../script.gamestarter/resources/data/emulators.tar.gz emulators/ && cd ..
	cd packages && tar -zcvf ../script.gamestarter/resources/data/advancedemulatorlauncher.tar.gz advancedemulatorlauncher/ && cd ..
	cd packages && tar -zcvf ../script.gamestarter/resources/data/advancedlauncher.tar.gz advancedlauncher/ && cd ..
	cd packages && tar -zcvf ../script.gamestarter/resources/data/retroarch.tar.gz retroarch/ && cd ..
	
fi










#################################################
# crear los zips de las versiones del addon
#################################################

# ADDON_VERSION="OLE"
# ADDON_VERSION="LE8alpha"
ADDON_VERSION=$1

mkdir -p exports/script.gamestarter
cp -R script.gamestarter exports/

if [ "$ADDON_VERSION" = "OLE" ]; then

	# OLE
	# install.sh ADDON_VERSION
	sed -i '/#versionstart/,/#versionend/s/ADDON_VERSION="XXX"/ADDON_VERSION="OLE"/' exports/script.gamestarter/resources/bin/install.sh

	# retroarch_1.3.6(OLE)
	mv exports/script.gamestarter/resources/bin/retroarch_1.3.6 exports/script.gamestarter/resources/bin/retroarch
	rm exports/script.gamestarter/resources/bin/retroarch_1.3.6_libreelec8

	# seleccionar advanced launcher
	rm exports/script.gamestarter/resources/data/advancedemulatorlauncher.tar.gz

	# dejar las libs necesarias: /lib/libbrcmEGL.so y /lib/libbrcmGLESv2.so para glupen64

else

	# LE8alpha:
	# install.sh ADDON_VERSION
	sed -i '/#versionstart/,/#versionend/s/ADDON_VERSION="XXX"/ADDON_VERSION="LE8alpha"/' exports/script.gamestarter/resources/bin/install.sh

	# retroarch_1.3.6_libreelec8
	mv exports/script.gamestarter/resources/bin/retroarch_1.3.6_libreelec8 exports/script.gamestarter/resources/bin/retroarch
	rm exports/script.gamestarter/resources/bin/retroarch_1.3.6

	# seleccionar advanced emulator launcher
	rm exports/script.gamestarter/resources/data/advancedlauncher.tar.gz

	# quitar las libs
	rm -rf exports/script.gamestarter/lib

fi


# crear el zip
cd exports && zip -r script.gamestarter-$ADDON_VERSION.zip exports/script.gamestarter/ && cd ..
rm -rf exports/script.gamestarter/


echo "done!"