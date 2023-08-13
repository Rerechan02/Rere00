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
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
#!/bin/bash
read -p "silajkan masukan username : " user
read -p "sikahkan masukan masa aktif : " masaaktif
eemail=$(echo -e "$user" | wc -w)
if [ $eemail -gt 0 ]; then
echo -e ""
else
echo -e "Maaf Masukan username yang benar!"
exit
fi
akun=$(cat /etc/xray/vmess-ws.json | grep $user | sed -n 1p | cut -d ' ' -f 2)
if [ $akun = $user ]; then
echo -e ""
else
echo -e "Maaf Tuan Username yang anda masukan tidak Valid"
exit
fi
exp=$(grep -E "^#### " "/etc/xray/vmess-ws.json" | grep $user | cut -d ' ' -f 3)
now=$(date +%Y-%m-%d)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
exp3=$(($exp2 + $masaaktif))
exp4=`date -d "$exp3 days" +"%Y-%m-%d"`
sed -i "s/#### $user $exp/#### $user $exp4/g" /etc/xray/vmess-ws.json
sed -i "s/#### $user $exp/#### $user $exp4/g" /etc/xray/vmess-grpc.json
clear
echo ""
echo " Akun Vmess berhasil diperpanjang"
echo " =========================="
echo " Service     : Vmess"
echo " Client Name : $user"
echo " Expired On  : $exp4"
echo " =========================="
echo " Terimakasih Tuan $user"
