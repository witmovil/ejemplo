#!/bin/bash
#Script auto create user SSH
#User will not expire

IP=`dig +short myip.opendns.com @resolver1.opendns.com`

Login=trial`</dev/urandom tr -dc X-Z0-9 | head -c4`
Pass=`</dev/urandom tr -dc a-f0-9 | head -c9`

useradd -s /bin/false -M $Login
echo -e "$Pass\n$Pass\n" | passwd $Login &> /dev/null
echo -e ""
echo -e "====SSH Account====" | lolcat
echo -e "Host: $IP"
#echo -e "Port OpenSSH: 22,143"
#echo -e "Port Dropbear: 80,443"
#echo -e "Port Squid: 8080,3128"
echo -e "Config OpenVPN (TCP 1194): http://$IP:81/client.ovpn"
echo -e "Username: $Login"
echo -e "Password: $Pass\n"
echo -e "=========================" | lolcat
echo -e ""
