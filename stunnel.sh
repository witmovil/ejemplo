#!/bin/bash
# Instalación automática de Debian
# Creado por Idtunnel

# Detalles de la empresa
country=CO
state=Bogota
locality=Bogota
organization=witmovil
organizationalunit=WitMovil
commonname=witmovil.com
email=admin@witmovil.com

# Instalar stunnel
apt-get install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1
[dropbear]
accept = 443
connect = 127.0.0.1:143
[dropbear]
accept = 222
connect = 127.0.0.1:22
[dropbear]
accept = 444
connect = 127.0.0.1:44
[dropbear]
accept = 777
connect = 127.0.0.1:77
END

echo "=================  Creando Certificado OpenSSL ======================"
echo "========================================================="
# Creando certificado
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# Configuración de stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart

# Eliminar instalación automática de stunnel para Debian
rm -rf stunnel.sh
