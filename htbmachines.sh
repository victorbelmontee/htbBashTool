#!/bin/bash

# Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
orangeColour="\e[0;33m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
    echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
    tput cnorm && exit 1
}

# Ctrl+C trap
trap ctrl_c INT

# Variables globales
main_url="https://htbmachines.github.io/bundle.js"

function helpPanel(){
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
    echo -e "\t${purpleColour}u)${endColour}${grayColour} Descargar o actualizar archivos necesarios${endColour}"
    echo -e "\t${purpleColour}m)${endColour}${grayColour} Buscar por un nombre de máquina${endColour}"
    echo -e "\t${purpleColour}i)${endColour}${grayColour} Buscar por dirección IP${endColour}"
    echo -e "\t${purpleColour}d)${endColour}${grayColour} Buscar por dificultad de una máquina${endColour}"
    echo -e "\t${purpleColour}o)${endColour}${grayColour} Buscar por el sistema operativo${endColour}"
    echo -e "\t${purpleColour}s)${endColour}${grayColour} Buscar por el Skill${endColour}"
    echo -e "\t${purpleColour}y)${endColour}${grayColour} Obtener link de la resolución de la máquina en Youtube${endColour}"
    echo -e "\t${purpleColour}h)${endColour}${grayColour} Mostrar este panel de ayuda${endColour}\n"
}

function updateFiles(){
    if [ ! -f bundle.js ]; then
        tput civis
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios...${endColour}"
        curl -s $main_url > bundle.js
        js-beautify bundle.js | sponge bundle.js
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Todos los archivos han sido descargados...${endColour}"
        tput cnorm
    else
        tput civis
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando si hay actualizaciones pendientes...${endColour}"
        sleep 2
        curl -s $main_url > bundle_temp.js
        js-beautify bundle_temp.js | sponge bundle_temp.js
        md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
        md5_original_value=$(md5sum bundle.js | awk '{print $1}')
        if [ "$md5_temp_value" == "$md5_original_value" ]; then
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} No se han detectado actualizaciones, lo tienes todo al día ;)${endColour}"
            rm bundle_temp.js
        else
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Se han encontrado actualizaciones disponibles${endColour}"
            sleep 1
            rm bundle.js && mv bundle_temp.js bundle.js
            echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los archivos han sido actualizados${endColour}"
        fi
        tput cnorm
    fi
}

function searchMachine(){
    machineName="$1"
    machineName_checker="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//')"

    if [ "$machineName_checker" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las propiedades de la máquina ${endColour}${blueColour}$machineName${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//'
    else
        echo -e "\n${redColour}[!] La máquina proporcionada no existe${endColour}\n"
    fi
}

function searchIP(){
    ipAddress="$1"
    machineName="$(cat bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"

    if [ "$machineName" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} La máquina correspondiente para la IP${endColour} ${blueColour}$ipAddress${endColour}${grayColour} es${endColour}${purpleColour} $machineName${endColour}\n"
    else
        echo -e "\n${redColour}[!] La dirección IP proporcionada no existe${endColour}\n"
    fi
}

function getYoutubeLink(){
    machineName="$1"
    youtubeLink="$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube | awk 'NF{print $NF}')"
    echo "$youtubeLink"
     if [ $youtubeLink ]; then
         echo -e "\n${yellowColour}[+]${endColour}${grayColour} El tutorial para esta máquina está en el siguiente enlace:${endColour}${blueColour} $youtubeLink${endColour}\n"
     else
         echo -e "\n${yellowColour}[+]${endColour}${grayColour} El tutorial para esta máquina está en el siguiente enlace:${endColour}${blueColour} $youtubeLink${endColour}\n"
     fi
}

function getMachinesDifficulty(){
  difficulty="$1"
  case $difficulty in
        "Fácil")
            colour=$greenColour
            ;;
        "Media")
            colour=$orangeColour
            ;;
        "Difícil")
            colour=$redColour
            ;;
        "Insane")
            colour=$purpleColour
            ;;
        *)
            echo -e "\n${redColour}[!] La dificultad indicada no existe${endColour}\n"
            return
            ;;
    esac

    results="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d ',' | tr -d '"' | column)"

    if [ "$results" ]; then
        echo -e "\n${yellowColour}[+]${endColour}${grayColour} Representando las máquinas que poseen un nivel de dificultad${endColour}${colour} $difficulty${endColour}${grayColour}:${endColour}\n"
        cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d ',' | tr -d '"' | column
    else
        echo -e "\n${redColour}[!] No se encontraron máquinas con la dificultad indicada${endColour}\n"
    fi
 
 function getOSMachines(){
  os="$1"
  case $os in
        "Linux")
            colour=$orangeColour
            ;;
        "Windows")
            colour=$blueColour
            ;;
        *)
            echo -e "\n${redColour}[!] El sistema operativo indicado no existe${endColour}\n"
            return
            ;;
    esac

  os_results="$(cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d ',' | tr -d '"' | column)"

  if [ "$os_results" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Mostrando las máquinas cuyo sistema operativo es ${endColour}${colour}$os${endColour}${grayColour}:${endColour}\n"
    cat bundle.js | grep "so: \"$os\"" -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d ',' | tr -d '"' | column
  else
    echo -e "\n${redColour}[!] El sistema operativo indicado no existe${endColour}\n"
  fi
}

function getOSDifficultyMachines(){
difficulty="$1"
os="$2"
  case $difficulty in
        "Fácil")
            colour=$greenColour
            ;;
        "Media")
            colour=$orangeColour
            ;;
        "Difícil")
            colour=$redColour
            ;;
        "Insane")
            colour=$purpleColour
            ;;
        *)
            echo -e "\n${redColour}[!] La dificultad indicada no existe${endColour}\n"
            return
            ;;
    esac

    case $os in
        "Linux")
            colour=$orangeColour
            ;;
        "Windows")
            colour=$blueColour
            ;;
        *)
            echo -e "\n${redColour}[!] El sistema operativo indicado no existe${endColour}\n"
            return
            ;;
    esac
    check_results="$(cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [ $check_results ];then
    echo -e echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las máquinas que poseen un nivel de dificultad${endColour}${difficultyColour} $difficulty${endColour}${grayColour} que tengan sistema operativo${endColour}${osColour} $os${endColour}${grayColour}:${endColour}\n"
    cat bundle.js | grep "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n ${redColour}[!] Se ha indicado una dificultad o sistema operativo incorrectos${endColour}"
  fi

}


# Indicadores
declare -i parameter_counter=0

# Chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0

while getopts "m:ui:y:d:o:s:h" arg; do
    case $arg in
        m) machineName="$OPTARG"; let parameter_counter+=1;;
        u) let parameter_counter+=2;;
        i) ipAddress="$OPTARG"; let parameter_counter+=3;;
        y) machineName="$OPTARG"; let parameter_counter+=4;;
        d) difficulty="$OPTARG"; chivato_difficulty=1; let parameter_counter+=5;;
        o) os="$OPTARG"; chivato_os=1; let parameter_counter+=6;;
        s) skill="$OPTARG" ;;
        h) ;;
    esac done

if [ $parameter_counter -eq 1 ]; then
    searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
    updateFiles
elif [ $parameter_counter -eq 3 ]; then
    searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]; then
    getYoutubeLink $machineName
elif [ $parameter_counter -eq 5 ];then
  getMachinesDifficulty $difficulty
elif [ $parameter_counter -eq 6 ];then
  getOSMachines $os
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ];then 
  getOSDifficultyMachines $difficulty $os
else
    helpPanel
fi
