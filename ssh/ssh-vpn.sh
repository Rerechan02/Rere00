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
#
# ==================================================

# etc
apt dist-upgrade -y
apt install netfilter-persistent -y
apt-get remove --purge ufw firewalld -y
apt install -y screen curl jq bzip2 gzip vnstat coreutils rsyslog iftop zip unzip git apt-transport-https build-essential -y
apt install htop -y
apt install ruby -y
gem install lolcat
# initializing var
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Indonesia
locality=Jakarta
organization=none
organizationalunit=none
commonname=none
email=none

# simple password minimal
curl -sS https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/password | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/pam.d/common-password
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

#install jq
apt -y install jq
mkdir -p /etc/slowdns
mkdir -p /etc/dns

#install shc
apt -y install shc

# install wget and curl
apt -y install wget curl

#figlet
apt-get install figlet -y
apt-get install ruby -y
gem install lolcat

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config


install_ssl(){
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            else
                    apt-get install -y nginx certbot
                    apt install -y nginx certbot
                    sleep 3s
            fi
    else
        yum install -y nginx certbot
        sleep 3s
    fi

    systemctl stop nginx.service

    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            else
                    echo "A" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
                    sleep 3s
            fi
    else
        echo "Y" | certbot certonly --renew-by-default --register-unsafely-without-email --standalone -d $domain
        sleep 3s
    fi
}

# install webserver
apt -y install nginx
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/nginx.conf"
mkdir -p /home/vps/public_html
/etc/init.d/nginx restart

# install badvpn
cd
wget https://raw.githubusercontent.com/Rerechan02/nani/main/badvpn/setup1.sh && chmod +x * && ./setup1.sh && rm -fr setup1.sh
# setting port ssh
cd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 22' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 2222' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 58080' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 51443' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 40000' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 3303' /etc/ssh/sshd_config
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
/etc/init.d/ssh restart

echo "=== Install Dropbear ==="
# install dropbear
apt install dropbear
rm /etc/default/dropbear
rm /etc/issue.net
cat>  /etc/default/dropbear << END
# disabled because OpenSSH is installed
# change to NO_START=0 to enable Dropbear
NO_START=0
# the TCP port that Dropbear listens on
DROPBEAR_PORT=143
DROPBEAR_PORT=80
DROPBEAR_PORT=109
DROPBEAR_PORT=69
DROPBEAR_PORT=83
DROPBEAR_PORT=90
# any additional arguments for Dropbear
DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69"

# specify an optional banner file containing a message to be
# sent to clients before they connect, such as "/etc/issue.net"
DROPBEAR_BANNER="/etc/issue.net"

# RSA hostkey file (default: /etc/dropbear/dropbear_rsa_host_key)
#DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"

# DSS hostkey file (default: /etc/dropbear/dropbear_dss_host_key)
#DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"

# ECDSA hostkey file (default: /etc/dropbear/dropbear_ecdsa_host_key)
#DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"

# Receive window size - this is a tradeoff between memory and
# network performance
DROPBEAR_RECEIVE_WINDOW=65536
END
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
cat> /etc/issue.net << END
</strong> <p style="text-align:center"><b> <br><font color="#00FFE2">┏━━━━━━━━━━━━━━━┓<br> RERECHAN STORE<br>┗━━━━━━━━━━━━━━━┛</font><br><font color="#00FF00"></strong> <p style="text-align:center"><b> <br><font color="#00FFE2">क═══════क⊹⊱✫⊰⊹क═══════क</font><br><font color='#FFFF00'><b> ★ [ ༆Hʸᵖᵉʳ᭄W̺͆E̺͆L̺͆C̺͆O̺͆M̺͆E̺͆
T̺͆O̺͆ M̺͆Y̺͆ S̺͆E̺͆R̺͆V̺͆E̺͆R̺͆ V͇̿I͇̿P͇̿ ] ★ </b></font><br><font color="#FFF00">ℝ𝕖𝕣𝕖𝕔𝕙𝕒𝕟 𝕊𝕥𝕠𝕣𝕖</font><br> <font color="#FF00FF">❖Ƭʜᴇ No DDOS</font><br> <font color="#FF0000">❖Ƭʜᴇ No Torrent</font><br> <font color="#FFB1C2">❖Ƭʜᴇ No Bokep </font><br> <font color="#FFFFFF">❖Ƭʜᴇ No Hacking</font><br>
<font color="#00FF00">❖Ƭʜᴇ No Mining</font><br> <font color="#00FF00">➳ᴹᴿ᭄ Oder / Trial :
https://wa.me/6283120684925 </font><br>
<font color="#00FFE2">क═══════क⊹⊱✫⊰⊹क═══════क</font><br></font><br><font color="FFFF00">❖Ƭʜᴇ WHATSAPP GRUP => https://chat.whatsapp.com/LlJmbvSQ2DsHTA1EccNGoO</font><br>
END
/etc/init.d/dropbear restart
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/ssh restart
/etc/init.d/dropbear restart

cd

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# blokir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# download script
cd /usr/bin
# menu
wget -O switch "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/switch.sh"
wget -O funny "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/menu.sh"
wget -O limit-speed "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/limitspeed.sh"
wget -O m-vmess "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/m-vmess.sh"
wget -O m-vless "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/m-vless.sh"
wget -O running "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/running.sh"
wget -O m-trojan "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/m-trojan.sh"

# menu ssh ovpn
wget -O m-sshovpn "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/m-sshovpn.sh"
wget -O usernew "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/trial.sh"
wget -O autokill "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/autokill.sh"
wget -O renew "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/renew.sh"
wget -O hapus "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/hapus.sh"
wget -O cek "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/cek.sh"
wget -O member "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/member.sh"
wget -O ceklim "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/tendang.sh"
wget -O delete "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/delete.sh"

# menu system
wget -O m-system "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/m-system.sh"
wget -O m-domain "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/m-domain.sh"
wget -O add-host "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/add-host.sh"
wget -O certv2ray "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/certv2ray.sh"
wget -O speedtest "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/speedtest_cli.py"
wget -O restart "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/restart.sh"
wget -O xp "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/xp.sh"
wget -O switch "https://raw.githubusercontent.com/Rerechan02/nani/main/ssh/switch.sh"
wget -O load "https://raw.githubusercontent.com/Rerechan02/nani/main/menu/load.sh"
chmod +x *
cd


cat > /etc/cron.d/re_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 0 * * * root /sbin/reboot
END

cat > /etc/cron.d/xp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 0 * * * root /usr/bin/xp
END

cat > /home/re_otm <<-END
7
END

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

# remove unnecessary files
sleep 0.5
echo -e "[ ${green}INFO$NC ] Clearing trash"
apt autoclean -y >/dev/null 2>&1

if dpkg -s unscd >/dev/null 2>&1; then
apt -y remove --purge unscd >/dev/null 2>&1
fi

apt-get -y --purge remove samba* >/dev/null 2>&1
apt-get -y --purge remove apache2* >/dev/null 2>&1
apt-get -y --purge remove bind9* >/dev/null 2>&1
apt-get -y remove sendmail* >/dev/null 2>&1
apt autoremove -y >/dev/null 2>&1
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
sleep 0.5
echo -e "$yell[SERVICE]$NC Restart All service SSH & OVPN"
/etc/init.d/nginx restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting nginx"
/etc/init.d/openvpn restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting cron "
/etc/init.d/ssh restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting ssh "
/etc/init.d/dropbear restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting dropbear "
/etc/init.d/fail2ban restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting fail2ban "
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting stunnel4 "
/etc/init.d/vnstat restart >/dev/null 2>&1
sleep 0.5
echo -e "[ ${green}ok${NC} ] Restarting vnstat "
history -c
echo "unset HISTFILE" >> /etc/profile


rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh
rm -f /root/bbr.sh

# finihsing
clear
