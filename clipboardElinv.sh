#!/bin/bash
#Portapapeles ampliado Elinv en Bash
#Comprobar requisitos -> Si existe directorio oculto
ALMACENAMIENTO=~/.clipboard
#Si no lo creamos
test ! -d $ALMACENAMIENTO && mkdir $ALMACENAMIENTO
#Si existe el archivo de texto tipo base de datos
ALMACENAMIENTO+=/clipboard
#Sino lo creamos.
test -f $ALMACENAMIENTO || touch $ALMACENAMIENTO

#Captura original
declare -a filecontent
#Captura sin elementos vacios
declare -a filecontent1
#variables numericas
let i=0
let x=0
#archivo de datos
#ALMACENAMIENTO="/home/elinv/Programacion/htdocs/Localhost/clipboard"
#Recogemos linea a linea del fichero
while IFS=$'\n' read -r line_data; do
    filecontent[i]="${line_data}"
    ((++i))
done < $ALMACENAMIENTO
#Quitamos elementos vacios
for i in "${filecontent[@]}"
do
	if [[ "$i" != "" ]]; then
		filecontent1[x]="$i"    
	fi
	((++x))
done
#Información en el portapapeles
myvar=$( xclip -o )
#Mostramos
TMP=$(zenity --timeout=10 --list --title="ClipBoard Elinv - actual -> $myvar" --width=640 --height=480 --column="Enviar Texto al Clipboard"  "${filecontent1[@]}" --ok-label=Enviar --cancel-label=Agregar)

case $? in 
  0) 
	#Si presionó aceptar
	if [[ "$TMP" != "" ]]; then
		#Enviamos al portapapeles
		echo -n $TMP | xclip -selection clipboard;
		#Informamos al usuario
		zenity --info --text=$TMP" copiado al Clipboard"
	fi
  ;; 
  1) 
	#Si presionó agregar o cerrar
	if [[ "$myvar" != "" ]]; then
		#Preguntamos que desea hacer
		zenity --timeout=7 --question --title=$myvar --text="Desea agregar la captura de texto o salir?" --ok-label=Agregar --cancel-label=Salir
		case $? in
			0)
			echo "$myvar" >> $ALMACENAMIENTO  		#agregar al final
			zenity --info --text="$myvar  agregado."  #Informe al usuario
			;;
		esac 
	fi
  ;; 
  *) echo "Timeout"
  ;; 
esac

<<COMMENT

Bash ejecutado en  -> Fedora 29
-------------------------------

Requisitos:
Instalar 													xclip

Installing Xclip on Ubuntu 				
	sudo apt-get install xclip

Installing Xclip on CentOS 7 / RHEL 7 / Fedora
  sudo yum install xclip
	dnf install xclip

Installing Xclip on Arch Linux
	sudo pacman install xclip
	whereis xclip

------------------------------

Para ejecutarlo rapidamente he creado en

Configuración -> Dispositivos -> Teclado
un acceso directo al archivo bash (clipboardElinv.sh)

Al atajo creado le he puesto el nombre "Clipboard"
el comando es el path relativo y el nombre y extensión de nuestro bash
y la combinación de letras ha sido Ctrl+Shift+4 (del teclado numérico)

Bueno ya tengo mi portapapeles ampliado!

Si quieren mejorarlo con mayor gusto, manos a la obra.
Si desean acercar la colaboración pueden hacerlo a:
elinv.elinv@gmail.com

Saludos hermanos del mundo!
COMMENT
