#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);
echo "Checking VPS"
#link izin ip vps
url_izin='https://raw.githubusercontent.com/Rerechan02/iziznscript/main/ip'

# Mendapatkan IP VPS saat ini
ip_vps=$(curl -s ifconfig.me)

# Mendapatkan isi file izin.txt dari URL
izin=$(curl -s "$url_izin")

# Memeriksa apakah konten izin.txt berhasil didapatkan
if [[ -n "$izin" ]]; then
  while IFS= read -r line; do
    # Memisahkan nama VPS, IP VPS, dan tanggal kadaluwarsa
    nama=$(echo "$line" | awk '{print $1}')
    ipvps=$(echo "$line" | awk '{print $2}')
    tanggal=$(echo "$line" | awk '{print $3}')

    # Memeriksa apakah IP VPS saat ini cocok dengan IP VPS yang ada di izin.txt
    if [[ "$ipvps" == "$ip_vps" ]]; then
      echo "Nama VPS: $nama"
      echo "IP VPS: $ipvps"
      echo "Tanggal Kadaluwarsa: $tanggal"
      break
    fi
  done <<< "$izin"

  # Memeriksa apakah IP VPS ditemukan dalam izin.txt
  if [[ "$ipvps" != "$ip_vps" ]]; then
    echo "IP VPS tidak ditemukan dalam izin.txt"
    exit 0
  fi
else
  echo "Konten izin.txt tidak berhasil didapatkan dari URL"
  exit 0
fi
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BGreen='\e[1;32m'
BYellow='\e[1;33m'
BBlue='\e[1;34m'
BPurple='\e[1;35m'
NC='\033[0m'
yl='\e[32;1m'
bl='\e[36;1m'
gl='\e[32;1m'
rd='\e[31;1m'
mg='\e[0;95m'
blu='\e[34m'
op='\e[35m'
or='\033[1;33m'
bd='\e[1m'
color1='\e[031;1m'
color2='\e[34;1m'
color3='\e[0m'
# COLOR VALIDATION
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
# ==========================================
# Getting
clear
dns1=$(systemctl status haproxy | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
# STATUS SERVICE HAPROXY
if [[ $dns1 == "running" ]]; then
   dns="${GREEN}[ ON ]${NC}${NC}"
else
   dns="${RED}[ OFF ]${NC}"
fi
udpc=$(systemctl status goproxy | grep Active | awk '{print $3}' | cut -d "(" -f2 | cut -d ")" -f1)
# STATUS SERVICE GOPROXY
if [[ $udpc == "running" ]]; then
   udp2="${GREEN}[ ON ]${NC}${NC}"
else
   udp2="${RED}[ OFF ]${NC}"
fi
clear
function goproxy1 () {
cd /lib/systemd/system
systemctl stop haproxy
mv haproxy.service goproxy.service
rm -fr haproxy.service
systemctl daemon-reload
systemctl enable goproxy.service
systemctl restart goproxy.service
cd
clear
}
function haproxy1 () {
cd /lib/systemd/system
systemctl stop goproxy
mv goproxy.service haproxy.service
rm -fr goproxy.service
systemctl daemon-reload
systemctl enable haproxy.service
systemctl restart haproxy.service
cd
clear
}
if [[ "$cek" = "start" ]]; then
sts="${Info}"
else
sts="${Error}"
fi
clear
echo -e "=============================================="
echo -e "    SWITCH SSH SSL PORT 443"
echo -e "=============================================="
echo -e "SYSTEM STATUS OF HAPROXY & GOPROXY"
echo -e ""
echo -e "HAPROXY OVER TCP             :$dns"
echo -e "GOPROXY OVER TCP             :$udp2"
echo -e "=============================================="
echo -e "[1]. Switch Haproxy Tcp To Goproxy Tcp"
echo -e "[2]. Switch Goproxy Tcp To Haproxy Tcp"
echo -e "=============================================="
read -rp "Please Enter The Correct Number : " -e num
if [[ "$num" = "1" ]]; then
goproxy1
elif [[ "$num" = "2" ]]; then
haproxy1
else
clear
echo " You Entered The Wrong Number"
menu
fi

