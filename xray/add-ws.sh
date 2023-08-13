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
source /var/lib/ipvps.conf
if [[ "$IP" = "" ]]; then
domain=$(cat /etc/xray/domain)
else
domain=$IP
sldomain=`cat /etc/xray/dns`
slkey=`cat /etc/slowdns/server.pub`
fi
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${CLIENT_EXISTS} == '0' ]]; do
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\\E[40;1;37m      Add Xray/Vmess Account      \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"

		read -rp "User: " -e user
		CLIENT_EXISTS=$(grep -w $user /etc/xray/config.json | wc -l)

		if [[ ${CLIENT_EXISTS} == '1' ]]; then
clear
            echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
            echo -e "\\E[40;1;37m      Add Xray/Vmess Account      \E[0m"
            echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
			echo ""
			echo "A client with the specified name was already created, please choose another name."
			echo ""
			echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
			read -n 1 -s -r -p "Press any key to back on menu"
v2ray-menu
		fi
	done

uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (days): " masaaktif
now=`date -d "0 days" +"%Y-%m-%d"`
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#xray$/a\#### '"$user$sec $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user$sec""'"' /etc/xray/vmess-ws-none.json
sed -i '/#xray$/a\#### '"$user$sec $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user$sec""'"' /etc/xray/vmess-ws.json
sed -i '/#xray$/a\#### '"$user$sec $exp"'\
},{"id": "'""$uuid""'","alterId": '"0"',"email": "'""$user$sec""'"' /etc/xray/vmess-grpc.json
sleep 5 && systemctl restart vmess-ws &
sleep 5 && systemctl restart vmess-grpc &
sleep 5 && systemctl restart vmess-ws-none &
cat>/etc/xray/vmess-${user}ws-tls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmessws",
      "type": "none",
      "host": "$domain",
      "tls": "tls"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
ws="vmess://$(base64 -w 0 /etc/xray/vmess-${user}ws-tls.json)"
cat>/etc/xray/vmess-${user}grpc-tls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "443",
      "id": "${uuid}",
      "aid": "0",
      "net": "grpc",
      "path": "vmess-grpc",
      "type": "none",
      "host": "$domain",
      "tls": "tls"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
grpc="vmess://$(base64 -w 0 /etc/xray/vmess-${user}grpc-tls.json)"
cat>/etc/xray/vmess-$user-none.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${domain}",
      "port": "80",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/vmessws",
      "type": "none",
      "host": "$domain",
      "tls": "none"
}
EOF
vmess_base641=$( base64 -w 0 <<< $vmess_json1)
none="vmess://$(base64 -w 0 /etc/xray/vmess-$user-none.json)"
clear
echo -e "══════════════════════════"
echo -e "    <=  VMESS ACCOUNT =>"
echo -e "══════════════════════════"
echo -e ""
echo -e "Username     : $user"
echo -e "CITY         : $(cat /root/.mycity)"
echo -e "ISP          : $(cat /root/.myisp)"
echo -e "Host/IP      : $(cat /etc/xray/domain)"
echo -e "NSDOMAIN     : $(cat /etc/xray/dns)"
echo -e "PUBKEY       : $(cat /etc/slowdns/server.pub)"
echo -e "Slowdns      : 443, 80, 53, 5300, 222"
echo -e "Port ssl/tls : 441, 442, 443, 444, 2096"
echo -e "Port non tls : 80, 8000, 8080, 109, 69, 143"   
echo -e "Key          : $uuid"
echo -e "Network      : ws, grpc"
echo -e "Path         : /vmessws"
echo -e "serviceName  : vmess-grpc"
echo -e ""
echo -e "══════════════════════════"
echo -e "Link Tls  => ${ws}"
echo -e "══════════════════════════"
echo -e "Link None => ${none}"
echo -e "══════════════════════════"
echo -e "Link Grpc => ${grpc}"
echo -e "══════════════════════════"
echo -e "   Expired => $exp"
echo -e "══════════════════════════"
read -n 1 -s -r -p "Press any key to back on menu"
menu
