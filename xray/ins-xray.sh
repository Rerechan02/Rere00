#!/bin/bash
mkdir /etc/xray
mkdir /etc/nur
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
echo -e "
"
date
echo ""
#spam email
#spam email
iptables -A FORWARD -p tcp -m multiport --dports 25,587,26,110,995,143,993 -j DROP && iptables -A FORWARD -p udp -m multiport --dports 25,587,26,110,995,143,993 -j DROP && iptables-save > /etc/iptables.up.rules && iptables-restore -t < /etc/iptables.up.rules && netfilter-persistent save && netfilter-persistent reload
#iptables
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 80 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 443 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
domain=$(cat /etc/xray/domain)
sleep 0.5
echo -e "[ ${green}INFO${NC} ] Checking... "
apt install iptables iptables-persistent -y
sleep 0.5
echo -e "[ ${green}INFO$NC ] Setting ntpdate"
ntpdate pool.ntp.org 
timedatectl set-ntp true
sleep 0.5
echo -e "[ ${green}INFO$NC ] Enable chronyd"
systemctl enable chronyd
systemctl restart chronyd
sleep 0.5
echo -e "[ ${green}INFO$NC ] Enable chrony"
systemctl enable chrony
systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
sleep 0.5
echo -e "[ ${green}INFO$NC ] Setting chrony tracking"
chronyc sourcestats -v
chronyc tracking -v
echo -e "[ ${green}INFO$NC ] Setting dll"
apt clean all && apt update
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
apt install zip -y
apt install curl pwgen openssl netcat cron -y


# install xray
sleep 0.5
echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir
# Make Folder XRay
mkdir -p /var/log/xray
mkdir -p /etc/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log

## crt xray
systemctl stop nginx
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc

# nginx renew ssl
echo -n '#!/bin/bash
/etc/init.d/nginx stop
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /root/renew_ssl.log
/etc/init.d/nginx start
/etc/init.d/nginx status
' > /usr/local/bin/ssl_renew.sh
chmod +x /usr/local/bin/ssl_renew.sh
if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi

mkdir -p /home/vps/public_html


#install nginx
sudo apt install gnupg2 ca-certificates lsb-release -y
fiyaku=$(lsb_release -a | sed -n 1p | cut -f 2 | tr A-Z a-z) 
echo "deb http://nginx.org/packages/mainline/$fiyaku $(lsb_release -cs) nginx" | sudo tee /etc/apt/sources.list.d/nginx.list
echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | sudo tee /etc/apt/preferences.d/99nginx
curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
# gpg --dry-run --quiet --import --import-options import-show /tmp/nginx_signing.key
sudo mv /tmp/nginx_signing.key /etc/apt/trusted.gpg.d/nginx_signing.asc
sudo apt update
apt install nginx -y
rm /etc/nginx/conf.d/*.conf
rm /etc/nginx/nginx.conf
cd /etc/nginx
wget https://raw.githubusercontent.com/nuralfiya/Autorekonek-Libernet/main/nginx.conf
cd
cat> /etc/nginx/conf.d/funnvpn.conf << END
server {
        listen 89;
        listen [::]:89;
        server_name $domain;
        # shellcheck disable=SC2154
        return 301 https://$domain;
}
server {
                listen 127.0.0.1:31300;
                server_name _;
                return 403;
}
server {
        listen 127.0.0.1:31302 http2;
        server_name $domain;
        root /usr/share/nginx/html;
        location /s/ {
                add_header Content-Type text/plain;
                alias /etc/v2ray-agent/subscribe/;
       }
        location /vless-grpc {
                client_max_body_size 0;
#               keepalive_time 1071906480m;
                keepalive_requests 4294967296;
                client_body_timeout 1071906480m;
                send_timeout 1071906480m;
                lingering_close always;
                grpc_read_timeout 1071906480m;
                grpc_send_timeout 1071906480m;
                grpc_pass grpc://127.0.0.1:31301;
        }
        location /trojan-grpc {
                client_max_body_size 0;
#                # keepalive_time 1071906480m;
                keepalive_requests 4294967296;
                client_body_timeout 1071906480m;
                send_timeout 1071906480m;
                lingering_close always;
                grpc_read_timeout 1071906480m;
                grpc_send_timeout 1071906480m;
                grpc_pass grpc://127.0.0.1:31304;
        }
        location /vmess-grpc {
                client_max_body_size 0;
                # keepalive_time 1071906480m;
                keepalive_requests 4294967296;
                client_body_timeout 1071906480m;
                send_timeout 1071906480m;
                lingering_close always;
                grpc_read_timeout 1071906480m;
                grpc_send_timeout 1071906480m;
                grpc_pass grpc://127.0.0.1:31303;
        }
}
server {
        listen 127.0.0.1:31300;
        server_name $domain;
        root /usr/share/nginx/html;
        location /s/ {
                add_header Content-Type text/plain;
                alias /etc/v2ray-agent/subscribe/;
        }
        location / {
                add_header Strict-Transport-Security "max-age=15552000; preload" always;
        }
}
END
systemctl restart nginx

#bbr
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
#install xray
wget https://github.com/xtls/xray-install/raw/main/install-release.sh
bash install-release.sh install
#create jaon
cat> /etc/xray/trojan-tcp.json << end
{
  "log": {
      "access": "/var/log/xray/trojan.log",
      "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 443,
      "protocol": "trojan",
      "tag": "trojantcp",
      "settings": {
        "clients": [
          {
            "password": "eef46d87-ae46-d801-e0d4-6c87ae46d801",
            "flow": "xtls-rprx-direct",
            "email": "trojan.ket-yt.xyz_vless_xtls/tls-direct_tcp"
#xray
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "alpn": "h2",
            "dest": 31302,
            "xver": 0
          },
          {
            "path": "/",
            "dest": 700,
            "xver": 1
          },
          {
            "dest": 143,
            "xver": 1
          },
          {
            "path": "/vmessws",
            "dest": 31298,
            "xver": 1
          },
          {
            "path": "/vlessws",
            "dest": 31297,
            "xver": 1
          },
          {
            "path": "/trojanws",
            "dest": 60002,
            "xver": 1
          }
        ]
      },
      "streamsettings": {
        "network": "tcp",
        "security": "xtls",
        "xtlssettings": {
          "minversion": "1.2",
          "certificates": [
            {
              "certificatefile": "/etc/xray/xray.crt",
              "keyfile": "/etc/xray/xray.key",
              "ocspstapling": 3600,
              "usage": "encipherment"
            }
          ]
        }
      }
    }
  ],
  "outbounds": [
      {
          "protocol": "freedom",
          "tag": "direct"
      }
  ]
}
end
#create trojan-ws
cat> /etc/xray/trojan-ws.json << end
{
   "log": {
      "access": "/var/log/xray/trojan.log",
      "loglevel": "info"
  },
 "inbounds": [
    {
      "port": 60002,
      "listen": "127.0.0.1",
      "protocol": "trojan",
      "tag": "trojanws",
      "settings": {
        "clients": [
          {
            "password": "eef46d87-ae46-d801-e0d4-6c87ae46d801"
#xray
          }
        ],
        "fallbacks": [
          {
            "dest": "81"
          }
        ]
      },
      "streamsettings": {
        "network": "ws",
        "security": "none",
        "wssettings": {
          "acceptproxyprotocol": true,
          "path": "/trojanws"
        }
      }
    }
  ],
  "outbounds": [
      {
          "protocol": "freedom",
          "tag": "direct"
      }
  ]
}
end
#create vless-ws
cat> /etc/xray/vless-ws.json << end
{
  "log": {
      "access": "/var/log/xray/vless.log",
      "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 31297,
      "listen": "127.0.0.1",
      "protocol": "vless",
      "tag": "vlessws",
      "settings": {
        "clients": [
          {
            "id": "eef46d87-ae46-d801-e0d4-6c87ae46d801"
#xray
          }
        ],
        "decryption": "none"
      },
      "streamsettings": {
        "network": "ws",
        "security": "none",
        "wssettings": {
          "acceptproxyprotocol": true,
          "path": "/vlessws"
        }
      }
    }
  ],
  "outbounds": [
      {
          "protocol": "freedom",
          "tag": "direct"
      }
  ]
}
end
#create vmess-ws
cat> /etc/xray/vmess-ws.json << end
{
  "log": {
      "access": "/var/log/xray/vmess.log",
      "loglevel": "info"
  },
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 31298,
      "protocol": "vmess",
      "tag": "vmessws",
      "settings": {
        "clients": [
          {
            "id": "eef46d87-ae46-d801-e0d4-6c87ae46d801"
#xray
          }
        ]
      },
      "streamsettings": {
        "network": "ws",
        "security": "none",
        "wssettings": {
          "acceptproxyprotocol": true,
          "path": "/vmessws"
        }
      }
    }
  ],
  "outbounds": [
      {
          "protocol": "freedom",
          "tag": "direct"
      }
  ]
}
end
#create trojan-grpc
cat> /etc/xray/trojan-grpc.json << end
{
   "log": {
      "access": "/var/log/xray/trojan.log",
      "loglevel": "info"
  },
 "inbounds": [
    {
      "port": 31304,
      "listen": "127.0.0.1",
      "protocol": "trojan",
      "tag": "trojangrpc",
      "settings": {
        "clients": [
          {
            "password": "eef46d87-ae46-d801-e0d4-6c87ae46d801"
#xray
          }
        ],
        "fallbacks": [
          {
            "dest": "81"
          }
        ]
      },
      "streamsettings": {
        "network": "grpc",
        "security": "none",
        "grpcsettings": {
          "servicename": "trojan-grpc",
          "multimode": true,
          "acceptproxyprotocol": true
        }
      }
    }
  ],
  "outbounds": [
      {
          "protocol": "freedom",
          "tag": "direct"
      }
  ]
}
end
#create ntls
cat> /etc/xray/ntls.json << end
{
  "log": {
      "access": "/var/log/xray/trojan.log",
      "loglevel": "info"
  },
  "inbounds": [
    {
      "port": 80,
      "protocol": "trojan",
      "tag": "trojantcp",
      "settings": {
        "clients": [
          {
            "password": "eef46d87-ae46-d801-e0d4-6c87ae46d801",
            "flow": "xtls-rprx-direct",
            "email": "trojan.ket-yt.xyz_vless_xtls/tls-direct_tcp"
          }
        ],
        "decryption": "none",
        "fallbacks": [
          {
            "alpn": "h2",
            "dest": 31302,
            "xver": 0
          },
          {
            "path": "/",
            "dest": 700,
            "xver": 1
          },
          {
            "dest": 143,
            "xver": 1
          },
          {
            "path": "/vmessws",
            "dest": 31298,
            "xver": 1
          },
          {
            "path": "/vlessws",
            "dest": 31297,
            "xver": 1
          },
          {
            "path": "/trojanws",
            "dest": 60002,
            "xver": 1
          }
        ]
      },
      "streamsettings": {
        "network": "tcp",
        "security": "none"
      }
    }
  ],
  "outbounds": [
      {
          "protocol": "freedom",
          "tag": "direct"
      }
  ]
}
end
#create vless-grpc
cat> /etc/xray/vless-grpc.json << end
{
   "log": {
      "access": "/var/log/xray/vless.log",
      "loglevel": "info"
  },
 "inbounds": [
    {
      "port": 31301,
      "listen": "127.0.0.1",
      "protocol": "vless",
      "tag": "vlessgrpc",
      "settings": {
        "clients": [
          {
            "id": "eef46d87-ae46-d801-e0d4-6c87ae46d801"
#xray
          }
        ],
        "decryption": "none"
      },
      "streamsettings": {
        "network": "grpc",
        "security": "none",
        "grpcsettings": {
          "servicename": "vless-grpc",
          "multimode": true,
          "acceptproxyprotocol": true
        }
      }
    }
  ],
  "outbounds": [
      {
          "protocol": "freedom",
          "tag": "direct"
      }
  ]
}
end
#create vmess-grpc
cat> /etc/xray/vmess-grpc.json << end
{
   "log": {
      "access": "/var/log/xray/vmess.log",
      "loglevel": "info"
  },
 "inbounds": [
    {
      "port": 31303,
      "listen": "127.0.0.1",
      "protocol": "vmess",
      "tag": "vmessgrpc",
      "settings": {
        "clients": [
          {
            "id": "eef46d87-ae46-d801-e0d4-6c87ae46d801"
#xray
          }
        ],
        "fallbacks": [
          {
            "dest": "81"
          }
        ]
      },
      "streamsettings": {
        "network": "grpc",
        "security": "none",
        "grpcsettings": {
          "servicename": "vmess-grpc",
          "multimode": true,
          "acceptproxyprotocol": true
        }
      }
    }
  ],
  "outbounds": [
      {
          "protocol": "freedom",
          "tag": "direct"
      }
  ]
}
end
#json trojan ws none tls

#seting jam
mv /etc/localtime /etc/localtime.bak
ln -s /usr/share/zoneinfo/asia/jakarta /etc/localtime
#create service systemd
#trojan-tcp
cat> /etc/systemd/system/trojan-tcp.service << end
[unit]
description=xray service
documentation=https://github.com/xtls
after=network.target nss-lookup.target

[service]
user=nobody
capabilityboundingset=cap_net_admin cap_net_bind_service
ambientcapabilities=cap_net_admin cap_net_bind_service
nonewprivileges=true
execstart=/usr/local/bin/xray run -config /etc/xray/trojan-tcp.json
restart=on-failure
restartpreventexitstatus=23
limitnproc=10000
limitnofile=1000000

[install]
wantedby=multi-user.target
end
#ntls
cat> /etc/systemd/system/ntls.service << end
[unit]
description=xray service
documentation=https://github.com/xtls
after=network.target nss-lookup.target

[service]
user=nobody
capabilityboundingset=cap_net_admin cap_net_bind_service
ambientcapabilities=cap_net_admin cap_net_bind_service
nonewprivileges=true
execstart=/usr/local/bin/xray run -config /etc/xray/ntls.json
restart=on-failure
restartpreventexitstatus=23
limitnproc=10000
limitnofile=1000000

[install]
wantedby=multi-user.target
end
#trojan-ws
cat> /etc/systemd/system/trojan-ws.service << end
[unit]
description=xray service
documentation=https://github.com/xtls
after=network.target nss-lookup.target

[service]
user=nobody
capabilityboundingset=cap_net_admin cap_net_bind_service
ambientcapabilities=cap_net_admin cap_net_bind_service
nonewprivileges=true
execstart=/usr/local/bin/xray run -config /etc/xray/trojan-ws.json
restart=on-failure
restartpreventexitstatus=23
limitnproc=10000
limitnofile=1000000

[install]
wantedby=multi-user.target
end
#trojan-grpc
cat> /etc/systemd/system/trojan-grpc.service << end
[unit]
description=xray service
documentation=https://github.com/xtls
after=network.target nss-lookup.target

[service]
user=nobody
capabilityboundingset=cap_net_admin cap_net_bind_service
ambientcapabilities=cap_net_admin cap_net_bind_service
nonewprivileges=true
execstart=/usr/local/bin/xray run -config /etc/xray/trojan-grpc.json
restart=on-failure
restartpreventexitstatus=23
limitnproc=10000
limitnofile=1000000

[install]
wantedby=multi-user.target
end
#vless-ws
cat> /etc/systemd/system/vless-ws.service << end
[unit]
description=xray service
documentation=https://github.com/xtls
after=network.target nss-lookup.target

[service]
user=nobody
capabilityboundingset=cap_net_admin cap_net_bind_service
ambientcapabilities=cap_net_admin cap_net_bind_service
nonewprivileges=true
execstart=/usr/local/bin/xray run -config /etc/xray/vless-ws.json
restart=on-failure
restartpreventexitstatus=23
limitnproc=10000
limitnofile=1000000

[install]
wantedby=multi-user.target
end
cat> /etc/systemd/system/vless-grpc.service << end
[unit]
description=xray service
documentation=https://github.com/xtls
after=network.target nss-lookup.target

[service]
user=nobody
capabilityboundingset=cap_net_admin cap_net_bind_service
ambientcapabilities=cap_net_admin cap_net_bind_service
nonewprivileges=true
execstart=/usr/local/bin/xray run -config /etc/xray/vless-grpc.json
restart=on-failure
restartpreventexitstatus=23
limitnproc=10000
limitnofile=1000000

[install]
wantedby=multi-user.target
end
cat> /etc/systemd/system/vmess-ws.service << end
[unit]
description=xray service
documentation=https://github.com/xtls
after=network.target nss-lookup.target

[service]
user=nobody
capabilityboundingset=cap_net_admin cap_net_bind_service
ambientcapabilities=cap_net_admin cap_net_bind_service
nonewprivileges=true
execstart=/usr/local/bin/xray run -config /etc/xray/vmess-ws.json
restart=on-failure
restartpreventexitstatus=23
limitnproc=10000
limitnofile=1000000

[install]
wantedby=multi-user.target
end
cat> /etc/systemd/system/vmess-grpc.service << end
[unit]
description=xray service
documentation=https://github.com/xtls
after=network.target nss-lookup.target

[service]
user=nobody
capabilityboundingset=cap_net_admin cap_net_bind_service
ambientcapabilities=cap_net_admin cap_net_bind_service
nonewprivileges=true
execstart=/usr/local/bin/xray run -config /etc/xray/vmess-grpc.json
restart=on-failure
restartpreventexitstatus=23
limitnproc=10000
limitnofile=1000000

[install]
wantedby=multi-user.target
end
#enable systemd
systemctl enable trojan-tcp
systemctl enable trojan-ws
systemctl enable trojan-grpc
systemctl enable vless-ws
systemctl enable vless-grpc
systemctl enable vmess-ws
systemctl enable vmess-grpc
systemctl enable ntls
systemctl enable nginx
systemctl disable xray
cd /usr/bin/
# vmess
wget -O add-ws "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/add-ws.sh" && chmod +x add-ws
wget -O trialvmess "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/trialvmess.sh" && chmod +x trialvmess
wget -O renew-ws "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/renew-ws.sh" && chmod +x renew-ws
wget -O del-ws "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/del-ws.sh" && chmod +x del-ws
wget -O cek-ws "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/cek-ws.sh" && chmod +x cek-ws

# vless
wget -O add-vless "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/add-vless.sh" && chmod +x add-vless
wget -O trialvless "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/trialvless.sh" && chmod +x trialvless
wget -O renew-vless "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/renew-vless.sh" && chmod +x renew-vless
wget -O del-vless "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/del-vless.sh" && chmod +x del-vless
wget -O cek-vless "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/cek-vless.sh" && chmod +x cek-vless

# trojan
wget -O add-tr "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/add-tr.sh" && chmod +x add-tr
wget -O trialtrojan "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/trialtrojan.sh" && chmod +x trialtrojan
wget -O del-tr "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/del-tr.sh" && chmod +x del-tr
wget -O renew-tr "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/renew-tr.sh" && chmod +x renew-tr
wget -O cek-tr "https://raw.githubusercontent.com/Rerechan02/nani/main/xray/cek-tr.sh" && chmod +x cek-tr

chmod +x /usr/bin/*

sleep 0.5
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "xray/Vmess"
yellow "xray/Vless"

mv /root/domain /etc/xray/ 
if [ -f /root/scdomain ];then
rm /root/scdomain > /dev/null 2>&1
fi
clear
rm -f ins-xray.sh  
