#!/bin/bash
#Elinv Extended Clipboard in Bash
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#Check requirements -> If there is a hidden directory
ALMACENAMIENTO=~/.clipboard
#If we do not create it
test ! -d $ALMACENAMIENTO && mkdir $ALMACENAMIENTO
#If the database type text file exists
ALMACENAMIENTO+=/clipboard
#If we do not create it.
test -f $ALMACENAMIENTO || touch $ALMACENAMIENTO

#Original capture
declare -a filecontent
#Capture without empty elements
declare -a filecontent1
#numerical variables
let i=0
let x=0
#We pick line to line of the file
while IFS=$'\n' read -r line_data; do
    filecontent[i]="${line_data}"
    ((++i))
done < $ALMACENAMIENTO
#We remove empty elements
for i in "${filecontent[@]}"
do
	if [[ "$i" != "" ]]; then
		#Error control sign "-"
		#If the first character is "-" 
		#we add a point at the beginning 
		#and avoid the loading error of the script.
    if [ ${i:0:1} = "-" ];then
			punto=".";
     	i="$punto$i";
    fi
		filecontent1[x]="$i"    
	fi
	((++x))
done
#Information on the clipboard
myvar=$( xclip -o )
#We show
TMP=$(zenity --timeout=10 --list --title="ClipBoard Elinv - actual -> $myvar" --width=640 --height=480 --column="Send Text to Clipboard"  "${filecontent1[@]}" --ok-label=Copy --cancel-label=New)

case $? in 
  0) 
	#If you pressed accept
	if [[ "$TMP" != "" ]]; then
		#We ship to the clipboard
		echo -n $TMP | xclip -selection clipboard;
		#We inform the user
		zenity --info --text=$TMP" copied to the Clipboard"
	fi
  ;; 
  1) 
	#If you pressed add or close
	if [[ "$myvar" != "" ]]; then
		#We ask what you want to do
		zenity --timeout=7 --question --title=$myvar --text="You want to add text capture or exit?" --ok-label=Agregar --cancel-label=Salir
		case $? in
			0)
			echo "$myvar" >> $ALMACENAMIENTO  		#add at the end
			zenity --info --text="$myvar  aggregate."  #Inform the user
			;;
		esac 
	fi
  ;; 
  *) echo "Timeout started!"
  ;; 
esac

<<COMMENT

    Información del equipo en que este bash fue desarrollado:
    ------------------------------------------------------------------
    Fedora 29.
    Procesador intel Core i7
    Gnome Versión 3.30.2
    Tipo de SO: 64 bits.
    g++ (GCC) 8.3.1 20190223 (Red Hat 8.3.1-2)
    gtk version 3.24.1
    glade 3.22.1
    Visual Studio Code Versión: 1.32.3
    -----------------------------------------------------------------

Requirements:
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
[Spanish]
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

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[English]
To execute it quickly I created in

Configuration -> Devices -> Keyboard
a shortcut to the bash file (clipboardElinv.sh)

To the created shortcut I have put the name "Clipboard"
the command is the relative path and the name and extension of our bash
and the letter combination has been Ctrl + Shift + 4 (from the numeric keypad)

Well I have my clipboard enlarged!

If you want to improve it with greater pleasure, get to work.
If you wish to bring the collaboration closer you can do it to:
elinv.elinv@gmail.com

Greetings brothers of the world!
COMMENT
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~