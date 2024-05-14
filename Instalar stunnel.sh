#!/bin/bash
# Instalación automática de Debian
# Creado por WitMovil

# Detalles de la empresa
país=CO
estado=Bogota
localidad=Bogota
organización=witssh
unidadorganizativa=WitSSH
nombrecorporativo=WitMovil.com
correo=admin@witmovil.com

# Instalar stunnel
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-FIN
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
[dropbear]
aceptar = 443
conectar = 127.0.0.1:143
[dropbear]
aceptar = 222
conectar = 127.0.0.1:22
[dropbear]
aceptar = 444
conectar = 127.0.0.1:44
[dropbear]
aceptar = 777
conectar = 127.0.0.1:77
FIN

echo "=================  Creando Certificado OpenSSL ======================"
echo "========================================================="
# Crear certificado
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$país/ST=$estado/L=$localidad/O=$organización/OU=$unidadorganizativa/CN=$nombrecorporativo/emailAddress=$correo"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# Configuración de stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart

# Eliminar instalación automática de stunnel para Debian
rm -rf stunnel.sh
