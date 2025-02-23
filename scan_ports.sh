#!/bin/bash

# Definimos colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Comprobamos que el usuario haya introducido una IP
if [ -z "$1" ]; then
    echo -e "${RED}¡Por favor, proporciona una dirección IP!${NC}"
    exit 1
fi

IP=$1
PORT=80

# Comprobamos si se ha proporcionado un puerto usando -p, de lo contrario, usamos el puerto 80 por defecto
shift
while getopts "p:" opt; do
  case $opt in
    p)
      PORT=$OPTARG
      ;;
    *)
      echo -e "${RED}Opción inválida. Usa -p para especificar un puerto.${NC}"
      exit 1
      ;;
  esac
done

# Función para escanear servicios y versiones
scan_services() {
    echo -e "${BLUE}Escaneando servicios y versiones en ${IP}...${NC}"
    echo -e "${YELLOW}Ejecutando comando: sudo nmap -sS -sC -sV -p$PORT $IP${NC}"
    result=$(sudo nmap -sS -sC -sV -p$PORT $IP)
    
    echo -e "${GREEN}Reporte de Nmap para ${IP}:${NC}"
    echo -e "${GREEN}$result${NC}"
}

# Función para escanear con dirección MAC falsa
scan_services_spoof() {
    echo -e "${YELLOW}Escaneando servicios y versiones en ${IP} con MAC falsa...${NC}"
    echo -e "${GREEN}Ejecutando comando: sudo nmap -sS -sC -sV -p$PORT --spoof-mac 0 $IP${NC}"
    result=$(sudo nmap -sS -sC -sV -p$PORT --spoof-mac 0 $IP)
    
    echo -e "${YELLOW}Reporte de Nmap para ${IP} con MAC falsificada:${NC}"
    echo -e "${GREEN}$result${NC}"
}

# Función para escanear vulnerabilidades
scan_vulnerabilities() {
    echo -e "${BLUE}Escaneando vulnerabilidades en ${IP} en el puerto $PORT...${NC}"
    echo -e "${YELLOW}Ejecutando comando: sudo nmap --script vuln -p$PORT $IP${NC}"
    result=$(sudo nmap --script "vuln" -p$PORT $IP)
    
    echo -e "${GREEN}Reporte de vulnerabilidades para ${IP} en el puerto ${PORT}:${NC}"
    echo -e "${GREEN}$result${NC}"
}

# Función para escanear el puerto sin realizar ping
scan_port_no_ping() {
    echo -e "${BLUE}Escaneando el puerto ${PORT} en ${IP} sin realizar ping...${NC}"
    echo -e "${YELLOW}Ejecutando comando: sudo nmap -sS -sV -p $PORT -Pn $IP${NC}"
    
    result=$(sudo nmap -sS -sV -p $PORT -Pn $IP)
    
    echo -e "${GREEN}Reporte de Nmap para el puerto ${PORT} en ${IP}:${NC}"
    echo -e "${GREEN}$result${NC}"
}

# Menú interactivo
while true; do
    echo -e "${YELLOW}¿Qué quieres hacer?${NC}"
    echo -e "${GREEN}1) Reporte de servicios y versiones en el puerto ${PORT}${NC}"
    echo -e "${GREEN}2) Reporte de servicios y versiones (cambiando la MAC) en el puerto ${PORT}${NC}"
    echo -e "${GREEN}3) Escaneo de vulnerabilidades en el puerto ${PORT}${NC}"
    echo -e "${GREEN}4) Escaneo del puerto ${PORT} sin realizar ping${NC}"
    echo -e "${RED}5) Salir${NC}"
    
    read -p "Selecciona una opción (1, 2, 3, 4 o 5): " opcion

    case $opcion in
        1)
            echo -e "${GREEN}Seleccionaste reporte de servicios y versiones en el puerto ${PORT}.${NC}"
            scan_services
            break
            ;;
        2)
            echo -e "${GREEN}Seleccionaste reporte de servicios y versiones (cambiando la MAC) en el puerto ${PORT}.${NC}"
            scan_services_spoof
            break
            ;;
        3)
            echo -e "${GREEN}Seleccionaste escaneo de vulnerabilidades en el puerto ${PORT}.${NC}"
            scan_vulnerabilities
            break
            ;;
        4)
            echo -e "${GREEN}Seleccionaste escaneo del puerto ${PORT} sin realizar ping.${NC}"
            scan_port_no_ping
            break
            ;;
        5)
            echo -e "${RED}¡Hasta luego!${NC}"
            break
            ;;
        *)
            echo -e "${RED}Opción inválida, por favor selecciona 1, 2, 3, 4 o 5.${NC}"
            ;;
    esac
done
