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
#!/bin/bash
NUMBER_OF_CLIENTS=$(grep -c -E "^#### " "/etc/xray/vmess-ws.json")
	if [[ ${NUMBER_OF_CLIENTS} == '0' ]]; then
		echo ""
		echo "Anda tidak mempunyai pelanggan di service ini!"
		exit 1
	fi

	clear
	echo ""
	echo " silahkan masukan nomor urutt client yang akan di hapus"
	echo " Press CTRL+C to return"
	echo " ==============================="
	echo "     No  Expired   User"
	grep -E "^#### " "/etc/xray/vmess-ws.json" | cut -d ' ' -f 2-3 | nl -s ') '
	until [[ ${CLIENT_NUMBER} -ge 1 && ${CLIENT_NUMBER} -le ${NUMBER_OF_CLIENTS} ]]; do
		if [[ ${CLIENT_NUMBER} == '1' ]]; then
			read -rp "Select one client [1]: " CLIENT_NUMBER
		else
			read -rp "Select one client [1-${NUMBER_OF_CLIENTS}]: " CLIENT_NUMBER
		fi
	done
user=$(grep -E "^#### " "/etc/xray/vmess-ws.json" | cut -d ' ' -f 2 | sed -n "${CLIENT_NUMBER}"p)
exp=$(grep -E "^#### " "/etc/xray/vmess-ws.json" | cut -d ' ' -f 3 | sed -n "${CLIENT_NUMBER}"p)
sed -i "/^#### $user $exp/,/^},{/d" /etc/xray/vmess-ws-none.json
sed -i "/^#### $user $exp/,/^},{/d" /etc/xray/vmess-ws.json
sed -i "/^#### $user $exp/,/^},{/d" /etc/xray/vmess-grpc.json
#systemctl restart trojan-tcp
systemctl restart vmess-grpc
systemctl restart vmess-ws
systemctl restart vmess-ws-none
clear
echo " Vmess Akun berhasil dihapus"
echo " =========================="
echo " Servive     : Vmess"
echo " Client Name : $user"
echo " Expired On  : $exp"
echo " =========================="