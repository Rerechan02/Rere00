#!/bin/bash
clear
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
clear
#Pewarna Hidupmu
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33;1m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
cyan='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
NC='\e[0m'
ori='\e[32;1m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
#waduh cek" nih
clear
vlx=$(grep -c -E "^#& " "/etc/xray/config.json")
let vla=$vlx/2
vmc=$(grep -c -E "^### " "/etc/xray/config.json")
let vma=$vmc/2
ssh1="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"

trx=$(grep -c -E "^#! " "/etc/xray/config.json")
let tra=$trx/2
ssx=$(grep -c -E "^## " "/etc/xray/config.json")
let ssa=$ssx/2
cek=$(service ssh status | grep active | cut -d ' ' -f5)
if [ "$cek" = "active" ]; then
stat=-f5
else
stat=-f7
fi
ssh=$(service ssh status | grep active | cut -d ' ' $stat)
if [ "$ssh" = "active" ]; then
ressh="${green}ON${NC}"
else
ressh="${red}OFF${NC}"
fi
sshstunel=$(service stunnel5 status | grep active | cut -d ' ' $stat)
if [ "$sshstunel" = "active" ]; then
resst="${green}ON${NC}"
else
resst="${red}OFF${NC}"
fi
sshws=$(service ws-stunnel status | grep active | cut -d ' ' $stat)
if [ "$sshws" = "active" ]; then
ressshws="${green}ON${NC}"
else
ressshws="${red}OFF${NC}"
fi
ngx=$(service nginx status | grep active | cut -d ' ' $stat)
if [ "$ngx" = "active" ]; then
resngx="${green}ON${NC}"
else
resngx="${red}OFF${NC}"
fi
dbr=$(service dropbear status | grep active | cut -d ' ' $stat)
if [ "$dbr" = "active" ]; then
resdbr="${green}ON${NC}"
else
resdbr="${red}OFF${NC}"
fi
v2r=$(service xray status | grep active | cut -d ' ' $stat)
if [ "$v2r" = "active" ]; then
resv2r="${green}ON${NC}"
else
resv2r="${red}OFF${NC}"
fi
sslh=$(service sslh status | grep active | cut -d ' ' $stat)
if [ "$v2r" = "active" ]; then
resslh="${green}ON${NC}"
else
resslh="${red}OFF${NC}"
fi
gope=$(service goproxy status | grep active | cut -d ' ' $stat)
if [ "$gope" = "active" ]; then
regope="${green}ON${NC}"
else
regope="${red}OFF${NC}"
fi
gopek=$(service haproxy status | grep active | cut -d ' ' $stat)
if [ "$gopek" = "active" ]; then
regopek="${green}ON${NC}"
else
regopek="${red}OFF${NC}"
fi
clear
uptime="$(uptime -p | cut -d " " -f 2-10)"
DATE2=$(date -R | cut -d " " -f -5)
tram=$(free -m | awk 'NR==2 {print $2}')
uram=$(free -m | awk 'NR==2 {print $3}')
fram=$(free -m | awk 'NR==2 {print $4}')
#Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | lolcat
echo -e " \e[0;100;33m        • AutoScript by Rerechan02 •            \e[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | lolcat
# Define color codes
NC='\033[0m'
BICyan='\033[1;96m'
red='\033[0;31m'
# Get RAM and CPU usage
top -bn1 | grep load | awk '{printf "%.2f%% CPU usage\n", $(NF-2)*100/4}' 
free -m | awk 'NR==2{printf "%.2f%% RAM usage\n", $3*100/$2}'
# Get upload and download speed
iftop -t -s 2 | grep "Total send and receive rate" | awk '{printf "%.2f Kbps upload, %.2f Kbps download\n", $(NF-3)/1024, $(NF-1)/1024}'
# Get bandwidth usage statistics
dmon="$(vnstat -i eth0 -m | grep "$(date +"%b '%y")" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "$(date +"%b '%y")" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "$(date +"%b '%y")" | awk '{print $9" "substr ($10, 1, 1)}')"
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
# Print bandwidth usage statistics
echo -e "${BICyan}$NC ${BICyan}HARI ini${NC}: ${red}$ttoday$NC ${BICyan}BULAN${NC}: ${red}$tmon$NC $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | lolcat
echo "   >>> Detail Order Script"
echo "    -------------------------"
echo "   - Client Name    : $nama"
echo "   - IPv4 VPS       : $ip_vps"
echo "   - Domain VPS     : $(cat /etc/xray/domain)"
echo "   - Script Version : 9.0"
echo "   - Script Expired : $tanggal"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | lolcat
echo -e "                 • Rerechan Store •                 "
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | lolcat
echo -e "\033[0;33m ┌──────────────────────────────────────────┐\033[0m"
echo -e "\033[0;33m │\033[0m \033[0;32m SIMPLE SCRIPT PORT SERVICE INFO\033[0;33m         |\033[0m"
echo -e "\033[0;33m └──────────────────────────────────────────┘\033[0m"
echo -e "\033[0;33m┌──────────────────────────────────────────────────────┐"
echo -e "\033[0;33m│       >>> Service & Port                             │"
echo -e "\033[0;33m│   - Open SSH                : 22, 2222               │"
echo -e "\033[0;33m│   - Dropbear                : 109, 143, 109          │"
echo -e "\033[0;33m│   - Apache2 Websocket       : HTTP 80 HTTPS 443      │"
echo -e "\033[0;33m│   - Nginx Webserver         : 81, 89                 │"
echo -e "\033[0;33m│   - Haproxy OVER TCP        : 443                    │"
echo -e "\033[0;33m│   - SLOWDNS VPN             : 53, 5300, 88, 3139     │"
echo -e "\033[0;33m│   - XRAY TLS                : 443                    │"
echo -e "\033[0;33m│   - XRAY gRPC               : 443                    │"
echo -e "\033[0;33m│   - XRAY None TLS           : 80                     │"
echo -e "\033[0;33m│   - BadVPN                  : 7200, 7300             │"
echo -e "\033[0;33m│   - Goproxy OVER TCP        : 443                    │"
echo -e "\033[0;33m└──────────────────────────────────────────────────────┘"
echo -e "\033[0;33m ┌──────────────────────────────────┐\033[0m"
echo -e "\033[0;33m │\033[0m \033[0;32m STATUS ALL SERVICE INFO\033[0;33m         |\033[0m"
echo -e "\033[0;33m └──────────────────────────────────┘\033[0m"
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | lolcat
echo -e "${BICyan} NGINX ${NC}: $resngx"" ${BICyan}  XRAY ${NC}: $resv2r"" ${BICyan} WS-SSL ${NC}: $ressshws"" ${BICyan}  SSLH ${NC}: $resslh"
echo -e "${BICyan} GOPROXY ${NC}: $regope"" ${BICyan}HAPROXY ${NC}: $regopek"
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | lolcat
echo -e "${BICyan}\033[0m ${BOLD}${GREEN}FN${BIYellow} SSH${GREEN}  FN  ${BIYellow}VMESS  ${GREEN}FN  ${BIYellow}VLESS  ${GREEN}FN  ${BIYellow}TROJAN${GREEN} FN $NC "
echo -e "${BICyan}\033[0m ${Blue}    $ssh1         $vma          $vla           $tra              $NC"
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | lolcat
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
menu
