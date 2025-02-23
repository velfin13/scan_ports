# Script de Escaneo de Puertos con Nmap

Este script permite realizar escaneos de puertos y obtener información sobre los servicios y versiones que se están ejecutando en una dirección IP específica. Además, permite la posibilidad de cambiar la dirección MAC y realizar escaneos de vulnerabilidades en puertos específicos. Utiliza `nmap` para realizar los escaneos.

## Requisitos

- **Nmap**: El script depende de la herramienta `nmap` para realizar los escaneos de puertos y servicios.
- **Sudo**: Es necesario ejecutar algunos comandos con privilegios de `sudo` para obtener información más detallada.

## Uso

### Sintaxis

```bash
./scan_ports.sh <IP> [-p <puerto>]
