MYIP=$(wget -qO- ipv4.icanhazip.com);
: '
# verificar IP registrada
wget -q -O daftarip https://raw.githubusercontent.com/witmovil/ejemplo/master/ip.txt
if ! grep -w -q $MYIP daftarip; then
	echo "Lo siento, solo las IPs registradas pueden usar este script!"
	if [[ $vps = "vps" ]]; then
		echo "Modificado por Wit"
	else
		echo "Modificado por Wit"
	fi
	rm -f /root/daftarip
	exit
fi
'
# inicializar variables
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# detalles de la empresa
country=Colombia
state=Bogota
locality=suba
organization=wit
organizationalunit=DeparmentoIT
commonname=WitHere
email=mdw39huro@mozmail.com

# ir a root
cd

# deshabilitar ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# instalar wget y curl
apt-get update;apt-get -y install wget curl;

# establecer zona horaria GMT +5
ln -fs /usr/share/zoneinfo/America/Bogota /etc/localtime

# establecer locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# configurar repositorio
sh -c 'echo "deb https://download.webmin.com/download/repository/ sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -q http://www.webmin.com/jcameron-key.asc -O- | sudo apt-key add -

# actualizar
apt-get update

# instalar servidor web
sudo apt -y install nginx php7.4-fpm php7.4-cli

# instalar paquetes esenciales
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar
apt-get install htop
apt-get install iftop

echo "clear" >> .bashrc
echo 'echo -e ":::    ::: :::     ::: " | lolcat' >> .bashrc
echo 'echo -e ":+:   :+: :+:    :+:  " | lolcat' >> .bashrc
echo 'echo -e "+:+  +:+  +:+   +:+   " | lolcat' >> .bashrc
echo 'echo -e "+#++:++   +:+  +:+    " | lolcat' >> .bashrc
echo 'echo -e "+#+  +#+  +#+ +#+     " | lolcat' >> .bashrc
echo 'echo -e "#+#   #+# #+# #+#     " | lolcat' >> .bashrc
echo 'echo -e "###    ## #### ###    " | lolcat' >> .bashrc
echo 'echo -e ""' >> .bashrc
echo 'echo -e "+ -- --=[ WIT ]=-- -- +" | lolcat'  >> .bashrc
echo 'echo -e ""' >> .bashrc
# instalar servidor web
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>Powered By: University of Immaculate Conception</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/vps.conf"
service nginx restart

# instalar openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/openvpn-debian.tar"
cd /etc/openvpn/
tar xf openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_yg_baru_dibikin.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# configurar openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

# instalar badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# configurar puerto ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 444' /etc/ssh/sshd_config
service ssh restart

# instalar dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=3128/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 143"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

# instalar squid3
cd
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# instalar webmin
cd
wget "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/webmin_1.900_all.deb"
dpkg --install webmin_1.900_all.deb;
apt-get -y -f install;
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
rm /root/webmin_1.900_all.deb
service webmin restart
#service vnstat restart
#apt-get -y --force-yes -f install libxml-parser-perl

# instalar stunnel4 From Premium Script
apt-get -y install stunnel4
wget -O /etc/stunnel/stunnel.pem "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/stunnel.pem"
wget -O /etc/stunnel/stunnel.conf "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Configuration/stunnel.conf"
sed -i $MYIP2 /etc/stunnel/stunnel.conf
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart

# instalar Ruby y lolcat
apt-get -y install ruby
gem install lolcat

# instalar
apt-get -y install fail2ban python-pyinotify
service fail2ban restart

# instalar ddos deflate
cd
apt-get -y install dnsutils dsniff
wget https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/ddos-deflate-master.zip
unzip ddos-deflate-master.zip
cd ddos-deflate-master
./install.sh
rm -rf /root/ddos-deflate-master.zip

# banner
rm /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/issues.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
service ssh restart
service dropbear restart

# xml parser
cd
apt-get -y --force-yes -f install libxml-parser-perl

# descargar scripts
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/witmovil/ejemplo/master/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/witmovil/ejemplo/master/trial.sh"
wget -O delete "https://raw.githubusercontent.com/witmovil/ejemplo/master/hapus.sh"
wget -O check "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/user-login.sh"
wget -O member "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/user-list.sh"
wget -O restart "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/resvis.sh"
wget -O speedtest "https://raw.githubusercontent.com/KleKlai/VPS-OpenVPN-Autoscript/master/Components/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/witmovil/ejemplo/master/info.sh"
wget -O about "https://raw.githubusercontent.com/witmovil/ejemplo/master/about.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

# convertir a ejecutables
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x delete
chmod +x check
chmod +x member
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about

# finalizando
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# instalar neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | tee -a /etc/apt/sources.list
curl "https://bintray.com/user/downloadSubjectPublicKey?username=bintray"| apt-key add -
apt-get update
apt-get install neofetch

echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | tee -a /etc/apt/sources.list
curl "https://bintray.com/user/downloadSubjectPublicKey?username=bintray"| apt-key add -
apt-get update
apt-get install neofetch

# información
clear
echo 'echo -e "+ -- --=[ Su Servidor Privado Virtual está ahora en funcionamiento"' >> .bashrc
echo ""
echo "--------------Detalles de Configuración del Servidor---------------"
echo "Aplicaciones y Puertos"  | tee -a log-install.txt
echo ""
echo "  OpenSSH  : 22, 444"  | tee -a log-install.txt
echo "  Dropbear : 143, 3128"  | tee -a log-install.txt
echo "  SSL      : 443"  | tee -a log-install.txt
echo "  Squid3   : 8000, 8080 (limitado a IP SSH)"  | tee -a log-install.txt
echo "  OpenVpn: TCP (1194)"  | tee -a log-install.txt
echo "  Badvpn   : badvpn-udpgw puerto (7300)"  | tee -a log-install.txt
echo "  Nginx    : 81"  | tee -a log-install.txt
echo ""
echo "Aplicaciones y Puertos"  | tee -a log-install.txt
echo ""
echo "Utilidades Linux"  | tee -a log-install.txt
echo ""
echo " htop"  | tee -a log-install.txt
echo " iftop"  | tee -a log-install.txt
echo ""
echo "Información Extendida"  | tee -a log-install.txt
echo "  Webmin   : http://$MYIP:10000/"  | tee -a log-install.txt
echo "  Zona Horaria : Asia/Manila (GMT +7)"  | tee -a log-install.txt
echo "  IPv6     : OFF"  | tee -a log-install.txt
echo "  Protección DDOS : Habilitada"  | tee -a log-install.txt
echo "  Payload Listo   : Habilitado"  | tee -a log-install.txt
echo "  Protección SSH  : Habilitada"  | tee -a log-install.txt
echo "  Registro de Instalación: /root/log-install.txt"  | tee -a log-install.txt
echo ""
echo "Gracias"
echo "-------------------------------------------------------------"
cd
rm -f /root/debian7.sh
