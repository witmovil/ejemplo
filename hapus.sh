#!/bin/bash
# Script para eliminar usuarios de SSH y OpenVPN
clear
read -p "Ingrese el nombre de usuario a terminar: " Users

if getent passwd $Users > /dev/null 2>&1; then
        userdel $Users
        echo -e "$Users la conexión ha sido terminada exitosamente."
else
        echo -e "Oops algo salió mal, $Users no existe."
        echo -e "Puede usar el comando 'member' para ver la lista de miembros"
fi
