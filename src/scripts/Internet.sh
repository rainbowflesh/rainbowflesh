#!/bin/bash
# trojan go script ipv4 only
# Author: randomcyborg
# Date: 2022-03-04

# Error
RED="\033[31m"
# Success
GREEN="\033[32m"    
# Warning
YELLOW="\033[33m"   
# Info
BLUE="\033[36m"     
# Text
PLAIN='\033[0m'     

# Get OS
OS=`hostnamectl | grep -i system | cut -d: -f2`

# Get IPv4
IP=`curl -sL -4 ip.sb`

# Disable BT
BT="false"
NGINX_CONF_PATH="/etc/nginx/conf.d/"

res=`which bt 2>/dev/null`
if [[ "$res" != "" ]]; then
    BT="true"
    NGINX_CONF_PATH="/www/server/panel/vhost/nginx/"
fi

ZIP_FILE="trojan-go"
CONFIG_FILE="/etc/trojan-go/config.json"

# Default config without websocket
WS="false"

colorEcho() {
    echo -e "${1}${@:2}${PLAIN}"
}

# Check OS 
checkSystem() {
    result=$(id | awk '{print $1}')
    if [[ $result != "uid=0(root)" ]]; then
        echo -e " ${RED}Require root${PLAIN}"
        exit 1
    fi

    res=`which yum 2>/dev/null`
    if [[ "$?" != "0" ]]; then
        res=`which apt 2>/dev/null`
        if [[ "$?" != "0" ]]; then
            echo -e " ${RED}Unsupported OS${PLAIN}"
            exit 1
        fi
        PMT="apt"
        CMD_INSTALL="apt install -y "
        CMD_REMOVE="apt remove -y "
        CMD_UPGRADE="apt update; apt upgrade -y; apt autoremove -y"
    else
        PMT="yum"
        CMD_INSTALL="yum install -y "
        CMD_REMOVE="yum remove -y "
        CMD_UPGRADE="yum update -y"
    fi
    res=`which systemctl 2>/dev/null`
    if [[ "$?" != "0" ]]; then
        echo -e " ${RED}Unsupported linux version${PLAIN}"
        exit 1
    fi
}

# Check trojan status
status() {
    trojan_cmd="$(command -v trojan-go)"
    if [[ "$trojan_cmd" = "" ]]; then
        echo 0
        return
    fi
    if [[ ! -f $CONFIG_FILE ]]; then
        echo 1
        return
    fi
    port=`grep local_port $CONFIG_FILE|cut -d: -f2| tr -d \",' '`
    res=`ss -ntlp| grep ${port} | grep trojan-go`
    if [[ -z "$res" ]]; then
        echo 2
    else
        echo 3
    fi
}

statusText() {
    res=`status`
    case $res in
        2)
            echo -e ${GREEN}Installed${PLAIN} ${RED}Stopped${PLAIN}
            ;;
        3)
            echo -e ${GREEN}Installed${PLAIN} ${GREEN}Running${PLAIN}
            ;;
        *)
            echo -e ${RED}No install${PLAIN}
            ;;
    esac
}

# Get trojan version
getVersion() {
    VERSION=`curl -fsSL ${V6_PROXY}https://api.github.com/repos/p4gefau1t/trojan-go/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/'| head -n1`
    if [[ ${VERSION:0:1} != "v" ]];then
        VERSION="v${VERSION}"
    fi
}

# Get archetecture
archAffix() {
    case "${1:-"$(uname -m)"}" in
        i686|i386)
            echo '386'
        ;;
        x86_64|amd64)
            echo 'amd64'
        ;;
        *armv7*|armv6l)
            echo 'armv7'
        ;;
        *armv8*|aarch64)
            echo 'armv8'
        ;;
        *armv6*)
            echo 'armv6'
        ;;
        *arm*)
            echo 'arm'
        ;;
        *mips64le*)
            echo 'mips64le'
        ;;
        *mips64*)
            echo 'mips64'
        ;;
        *mipsle*)
            echo 'mipsle-softfloat'
        ;;
        *mips*)
            echo 'mips-softfloat'
        ;;
        *)
            return 1
        ;;
    esac

	return 0
}

# Text user interface
getData() {
    echo ""
    can_change=$1
    if [[ "$can_change" != "yes" ]]; then
        echo " trojan-go script before run you need check: "
        echo -e "  ${RED}1. Require a domain${PLAIN}"
        echo -e "  ${RED}2. Require correct DNS (${IP}) ${PLAIN}"
        echo -e "  3. If /root have ${GREEN}trojan-go.pem${PLAIN} and ${GREEN}trojan-go.key${PLAIN} CA file, keep countinue"
        echo " "
        read -p " Type y to execute: " answer
        if [[ "${answer,,}" != "y" ]]; then
            exit 0
        fi

        echo ""
        while true
        do
            read -p " Input domain " DOMAIN
            if [[ -z "${DOMAIN}" ]]; then
                echo -e " ${RED} Unsupported format ${PLAIN}"
            else
                break
            fi
        done
        colorEcho $BLUE " Your domain: $DOMAIN"

        echo ""
        DOMAIN=${DOMAIN,,}
        if [[ -f ~/trojan-go.pem && -f ~/trojan-go.key ]]; then
            echo -e "${GREEN} Already have CA ${PLAIN}"
            CERT_FILE="/etc/trojan-go/${DOMAIN}.pem"
            KEY_FILE="/etc/trojan-go/${DOMAIN}.key"
        fi
    else
        DOMAIN=`grep sni $CONFIG_FILE | cut -d\" -f4`
        CERT_FILE=`grep cert $CONFIG_FILE | cut -d\" -f4`
        KEY_FILE=`grep key $CONFIG_FILE | cut -d\" -f4`
        read -p " Convert to CDN? [y/n]" answer
        if [[ "${answer,,}" = "y" ]]; then
            WS="true"
        fi
    fi

    echo ""
    read -p " Input password, ignore to create random password: " PASSWORD
    [[ -z "$PASSWORD" ]] && PASSWORD=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1`
    colorEcho $BLUE " trojan-go password: $PASSWORD"
    echo ""
    while true
    do
        read -p " Create another password? [y/n]" answer
        if [[ ${answer,,} = "n" ]]; then
            break
        fi
        read -p " Input password, ignore to create random password: " pass
        [[ -z "$pass" ]] && pass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1`
        echo ""
        colorEcho $BLUE " trojan-go password: $pass"
        PASSWORD="${PASSWORD}\",\"$pass"
    done

    echo ""
    read -p " Set trojan-go port [default 443]: " PORT
    [[ -z "${PORT}" ]] && PORT=443
    if [[ "${PORT:0:1}" = "0" ]]; then
        echo -e "${RED}Unsupported format${PLAIN}"
        exit 1
    fi
    colorEcho $BLUE " trojan-go port: $PORT"

    if [[ ${WS} = "true" ]]; then
        echo ""
        while true
        do
            read -p " Input ws path start in /: " WSPATH
            if [[ -z "${WSPATH}" ]]; then
                len=`shuf -i5-12 -n1`
                ws=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $len | head -n 1`
                WSPATH="/$ws"
                break
            elif [[ "${WSPATH:0:1}" != "/" ]]; then
                echo " Unsupported format, need start in /"
            elif [[ "${WSPATH}" = "/" ]]; then
                echo  " Cannot use root "
            else
                break
            fi
        done
        echo ""
        colorEcho $BLUE " ws path: $WSPATH"
    fi

    echo ""
    colorEcho $BLUE " Choose fake site"
    echo "   1) 静态网站(位于/usr/share/nginx/html)"
    echo "   2) copymanga.org"
    echo "   3) zxzj.com"
    echo "   4) anime1.me"
    echo "   5) Custom site"
    read -p "  Choose fake site [default use blogger]" answer
    if [[ -z "$answer" ]]; then
        PROXY_URL="https://cyberpsychiatricasylum.blogspot.com/"
    else
        case $answer in
        1)
            PROXY_URL=""
            ;;
        2)
            PROXY_URL="https://www.copymanga.org/"
            ;;
        3)
            PROXY_URL="https://zxzj.com/"
            ;;
        4)
            PROXY_URL="https://anime1.me/"
            ;;
        5)
            read -p " Input custom web site domain (start inn http or https): " PROXY_URL
            if [[ -z "$PROXY_URL" ]]; then
                colorEcho $RED " Need input domain!"
                exit 1
            elif [[ "${PROXY_URL:0:4}" != "http" ]]; then
                colorEcho $RED " Need start with http or https!"
                exit 1
            fi
            ;;
        *)
            colorEcho $RED " Need a choose! "
            exit 1
        esac
    fi
    REMOTE_HOST=`echo ${PROXY_URL} | cut -d/ -f3`
    echo ""
    colorEcho $BLUE " Your domain: $PROXY_URL"

    echo ""
    colorEcho $BLUE " Allow spider? [default n]"
    read -p "  Type: [y/n]" answer
    if [[ -z "$answer" ]]; then
        ALLOW_SPIDER="n"
    elif [[ "${answer,,}" = "y" ]]; then
        ALLOW_SPIDER="y"
    else
        ALLOW_SPIDER="n"
    fi
    echo ""
    colorEcho $BLUE " Allow spider: $ALLOW_SPIDER"

    echo ""
    read -p " Install BBR (default y)?[y/n]:" NEED_BBR
    [[ -z "$NEED_BBR" ]] && NEED_BBR=y
    [[ "$NEED_BBR" = "Y" ]] && NEED_BBR=y
    colorEcho $BLUE " Install BBR: $NEED_BBR"
}

# Install nginx
installNginx() {
    echo ""
    colorEcho $BLUE " Install nginx..."
    if [[ "$BT" = "false" ]]; then
        if [[ "$PMT" = "yum" ]]; then
            $CMD_INSTALL epel-release
            if [[ "$?" != "0" ]]; then
                echo '[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true' > /etc/yum.repos.d/nginx.repo
            fi
        fi
        $CMD_INSTALL nginx
        if [[ "$?" != "0" ]]; then
            colorEcho $RED " Failed to install nginx!"
            exit 1
        fi
        systemctl enable nginx
    else
        res=`which nginx 2>/dev/null`
        if [[ "$?" != "0" ]]; then
            colorEcho $RED "Try install nginx via 宝塔"
            exit 1
        fi
    fi
}

startNginx() {
    if [[ "$BT" = "false" ]]; then
        systemctl start nginx
    else
        nginx -c /www/server/nginx/conf/nginx.conf
    fi
}

stopNginx() {
    if [[ "$BT" = "false" ]]; then
        systemctl stop nginx
    else
        res=`ps aux | grep -i nginx`
        if [[ "$res" != "" ]]; then
            nginx -s stop
        fi
    fi
}

# Get CA
getCert() {
    mkdir -p /etc/trojan-go
    if [[ -z ${CERT_FILE+x} ]]; then
        stopNginx
        systemctl stop trojan-go
        sleep 2
        res=`ss -ntlp| grep -E ':80 |:443 '`
        if [[ "${res}" != "" ]]; then
            echo -e "${RED} Port 80/443 in use, try rerun script${PLAIN}"
            echo " Info: "
            echo ${res}
            exit 1
        fi

        $CMD_INSTALL socat openssl
        if [[ "$PMT" = "yum" ]]; then
            $CMD_INSTALL cronie
            systemctl start crond
            systemctl enable crond
        else
            $CMD_INSTALL cron
            systemctl start cron
            systemctl enable cron
        fi
        curl -sL https://get.acme.sh | sh -s email=hijk.pw@protonmail.ch
        source ~/.bashrc
        ~/.acme.sh/acme.sh  --upgrade  --auto-upgrade
        ~/.acme.sh/acme.sh --set-default-ca --server letsencrypt
        if [[ "$BT" = "false" ]]; then
            ~/.acme.sh/acme.sh   --issue -d $DOMAIN --keylength ec-256 --pre-hook "systemctl stop nginx" --post-hook "systemctl restart nginx"  --standalone
        else
            ~/.acme.sh/acme.sh   --issue -d $DOMAIN --keylength ec-256 --pre-hook "nginx -s stop || { echo -n ''; }" --post-hook "nginx -c /www/server/nginx/conf/nginx.conf || { echo -n ''; }"  --standalone
        fi
        [[ -f ~/.acme.sh/${DOMAIN}_ecc/ca.cer ]] || {
            colorEcho $RED "Failed to vertical CA!"
            exit 1
        }
        CERT_FILE="/etc/trojan-go/${DOMAIN}.pem"
        KEY_FILE="/etc/trojan-go/${DOMAIN}.key"
        ~/.acme.sh/acme.sh  --install-cert -d $DOMAIN --ecc \
            --key-file       $KEY_FILE  \
            --fullchain-file $CERT_FILE \
            --reloadcmd     "service nginx force-reload"
        [[ -f $CERT_FILE && -f $KEY_FILE ]] || {
            colorEcho $RED "Failed to vertical CA!"
            exit 1
        }
    else
        cp ~/trojan-go.pem /etc/trojan-go/${DOMAIN}.pem
        cp ~/trojan-go.key /etc/trojan-go/${DOMAIN}.key
    fi
}


configNginx() {
    mkdir -p /usr/share/nginx/html
    if [[ "$ALLOW_SPIDER" = "n" ]]; then
        echo 'User-Agent: *' > /usr/share/nginx/html/robots.txt
        echo 'Disallow: /' >> /usr/share/nginx/html/robots.txt
        ROBOT_CONFIG="    location = /robots.txt {}"
    else
        ROBOT_CONFIG=""
    fi
    if [[ "$BT" = "false" ]]; then
        if [[ ! -f /etc/nginx/nginx.conf.bak ]]; then
            mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
        fi
        res=`id nginx 2>/dev/null`
        if [[ "$?" != "0" ]]; then
            user="www-data"
        else
            user="nginx"
        fi
        cat > /etc/nginx/nginx.conf<<-EOF
user $user;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;
    server_tokens off;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;
    gzip                on;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;
}
EOF
    fi

    mkdir -p $NGINX_CONF_PATH
    if [[ "$PROXY_URL" = "" ]]; then
        cat > $NGINX_CONF_PATH${DOMAIN}.conf<<-EOF
server {
    listen 80;
    listen [::]:80;
    server_name ${DOMAIN};
    root /usr/share/nginx/html;

    $ROBOT_CONFIG
}
EOF
    else
        cat > $NGINX_CONF_PATH${DOMAIN}.conf<<-EOF
server {
    listen 80;
    listen [::]:80;
    server_name ${DOMAIN};
    root /usr/share/nginx/html;
    location / {
        proxy_ssl_server_name on;
        proxy_pass $PROXY_URL;
        proxy_set_header Accept-Encoding '';
        sub_filter "$REMOTE_HOST" "$DOMAIN";
        sub_filter_once off;
    }
    
    $ROBOT_CONFIG
}
EOF
    fi
}

downloadFile() {
    SUFFIX=`archAffix`
    DOWNLOAD_URL="${V6_PROXY}https://github.com/p4gefau1t/trojan-go/releases/download/${VERSION}/trojan-go-linux-${SUFFIX}.zip"
    wget -O /tmp/${ZIP_FILE}.zip $DOWNLOAD_URL
    if [[ ! -f /tmp/${ZIP_FILE}.zip ]]; then
        echo -e "{$RED} Failed to install trojan-go ${PLAIN}"
        exit 1
    fi
}

installTrojan() {
    rm -rf /tmp/${ZIP_FILE}
    unzip /tmp/${ZIP_FILE}.zip  -d /tmp/${ZIP_FILE}
    cp /tmp/${ZIP_FILE}/trojan-go /usr/bin
    cp /tmp/${ZIP_FILE}/example/trojan-go.service /etc/systemd/system/
    sed -i '/User=nobody/d' /etc/systemd/system/trojan-go.service
    systemctl daemon-reload

    systemctl enable trojan-go
    rm -rf /tmp/${ZIP_FILE}

    colorEcho $BLUE "Install trojan-go success! "
}

configTrojan() {
    mkdir -p /etc/trojan-go
    cat > $CONFIG_FILE <<-EOF
{
    "run_type": "server",
    "local_addr": "::",
    "local_port": ${PORT},
    "remote_addr": "127.0.0.1",
    "remote_port": 80,
    "password": [
        "$PASSWORD"
    ],
    "ssl": {
        "cert": "${CERT_FILE}",
        "key": "${KEY_FILE}",
        "sni": "${DOMAIN}",
        "alpn": [
            "http/1.1"
        ],
        "session_ticket": true,
        "reuse_session": true,
        "fallback_addr": "127.0.0.1",
        "fallback_port": 80
    },
    "tcp": {
        "no_delay": true,
        "keep_alive": true,
        "prefer_ipv4": false
    },
    "mux": {
        "enabled": false,
        "concurrency": 8,
        "idle_timeout": 60
    },
    "websocket": {
        "enabled": ${WS},
        "path": "${WSPATH}",
        "host": "${DOMAIN}"
    },
    "mysql": {
      "enabled": false,
      "server_addr": "localhost",
      "server_port": 3306,
      "database": "",
      "username": "",
      "password": "",
      "check_rate": 60
    }
}
EOF
}

setSelinux() {
    if [[ -s /etc/selinux/config ]] && grep 'SELINUX=enforcing' /etc/selinux/config; then
        sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config
        setenforce 0
    fi
}

setFirewall() {
    res=`which firewall-cmd 2>/dev/null`
    if [[ $? -eq 0 ]]; then
        systemctl status firewalld > /dev/null 2>&1
        if [[ $? -eq 0 ]];then
            firewall-cmd --permanent --add-service=http
            firewall-cmd --permanent --add-service=https
            if [[ "$PORT" != "443" ]]; then
                firewall-cmd --permanent --add-port=${PORT}/tcp
            fi
            firewall-cmd --reload
        else
            nl=`iptables -nL | nl | grep FORWARD | awk '{print $1}'`
            if [[ "$nl" != "3" ]]; then
                iptables -I INPUT -p tcp --dport 80 -j ACCEPT
                iptables -I INPUT -p tcp --dport 443 -j ACCEPT
                if [[ "$PORT" != "443" ]]; then
                    iptables -I INPUT -p tcp --dport ${PORT} -j ACCEPT
                fi
            fi
        fi
    else
        res=`which iptables 2>/dev/null`
        if [[ $? -eq 0 ]]; then
            nl=`iptables -nL | nl | grep FORWARD | awk '{print $1}'`
            if [[ "$nl" != "3" ]]; then
                iptables -I INPUT -p tcp --dport 80 -j ACCEPT
                iptables -I INPUT -p tcp --dport 443 -j ACCEPT
                if [[ "$PORT" != "443" ]]; then
                    iptables -I INPUT -p tcp --dport ${PORT} -j ACCEPT
                fi
            fi
        else
            res=`which ufw 2>/dev/null`
            if [[ $? -eq 0 ]]; then
                res=`ufw status | grep -i inactive`
                if [[ "$res" = "" ]]; then
                    ufw allow http/tcp
                    ufw allow https/tcp
                    if [[ "$PORT" != "443" ]]; then
                        ufw allow ${PORT}/tcp
                    fi
                fi
            fi
        fi
    fi
}

installBBR() {
    if [[ "$NEED_BBR" != "y" ]]; then
        INSTALL_BBR=false
        return
    fi
    result=$(lsmod | grep bbr)
    if [[ "$result" != "" ]]; then
        echo " BBR Installed"
        INSTALL_BBR=false
        return
    fi
    res=`hostnamectl | grep -i openvz`
    if [[ "$res" != "" ]]; then
        echo  " openvz system, skip bbr"
        INSTALL_BBR=false
        return
    fi
    
    echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
    sysctl -p
    result=$(lsmod | grep bbr)
    if [[ "$result" != "" ]]; then
        echo " BBR enabled"
        INSTALL_BBR=false
        return
    fi

    colorEcho $BLUE " Install bbr..."
    if [[ "$PMT" = "yum" ]]; then
        if [[ "$V6_PROXY" = "" ]]; then
            rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
            rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
            $CMD_INSTALL --enablerepo=elrepo-kernel kernel-ml
            $CMD_REMOVE kernel-3.*
            grub2-set-default 0
            echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
            INSTALL_BBR=true
        fi
    else
        $CMD_INSTALL --install-recommends linux-generic-hwe-16.04
        grub-set-default 0
        echo "tcp_bbr" >> /etc/modules-load.d/modules.conf
        INSTALL_BBR=true
    fi
}

install() {
    getData

    $PMT clean all
    [[ "$PMT" = "apt" ]] && $PMT update
    #echo $CMD_UPGRADE | bash
    $CMD_INSTALL wget vim unzip tar gcc openssl
    $CMD_INSTALL net-tools
    if [[ "$PMT" = "apt" ]]; then
        $CMD_INSTALL libssl-dev g++
    fi
    res=`which unzip 2>/dev/null`
    if [[ $? -ne 0 ]]; then
        echo -e " ${RED}Failed to install unzip ${PLAIN}"
        exit 1
    fi

    installNginx
    setFirewall
    getCert
    configNginx

    echo " Install trojan-go..."
    getVersion
    downloadFile
    installTrojan
    configTrojan

    setSelinux
    installBBR

    start
    showInfo

    bbrReboot
}

bbrReboot() {
    if [[ "${INSTALL_BBR}" == "true" ]]; then
        echo  
        echo " Automatic reboot in 30 seconds..."
        echo  
        echo -e " Use ctrl + c cancel reboot"
        sleep 30
        reboot
    fi
}

update() {
    res=`status`
    if [[ $res -lt 2 ]]; then
        echo -e " ${RED}trojan-go not installed! ${PLAIN}"
        return
    fi

    echo " Install trojan-go"
    getVersion
    downloadFile
    installTrojan

    stop
    start
}

uninstall() {
    res=`status`
    if [[ $res -lt 2 ]]; then
        echo -e " ${RED}trojan-go not installed, install first! ${PLAIN}"
        return
    fi

    echo ""
    read -p " Uninstall trojan-go? [y/n]: " answer
    if [[ "${answer,,}" = "y" ]]; then
        domain=`grep sni $CONFIG_FILE | cut -d\" -f4`
        
        stop
        rm -rf /etc/trojan-go
        rm -rf /usr/bin/trojan-go
        systemctl disable trojan-go
        rm -rf /etc/systemd/system/trojan-go.service

        if [[ "$BT" = "false" ]]; then
            systemctl disable nginx
            $CMD_REMOVE nginx
            if [[ "$PMT" = "apt" ]]; then
                $CMD_REMOVE nginx-common
            fi
            rm -rf /etc/nginx/nginx.conf
            if [[ -f /etc/nginx/nginx.conf.bak ]]; then
                mv /etc/nginx/nginx.conf.bak /etc/nginx/nginx.conf
            fi
        fi

        rm -rf $NGINX_CONF_PATH${domain}.conf
        ~/.acme.sh/acme.sh --uninstall
        echo -e " ${GREEN}Uninstall trojan-go successed${PLAIN}"
    fi
}

start() {
    res=`status`
    if [[ $res -lt 2 ]]; then
        echo -e "${RED}trojan-go not installed! ${PLAIN}"
        return
    fi

    stopNginx
    startNginx
    systemctl restart trojan-go
    sleep 2
    port=`grep local_port $CONFIG_FILE|cut -d: -f2| tr -d \",' '`
    res=`ss -ntlp| grep ${port} | grep trojan-go`
    if [[ "$res" = "" ]]; then
        colorEcho $RED "Unable to start trojan-go"
    else
        colorEcho $BLUE " trojan-go started"
    fi
}

stop() {
    stopNginx
    systemctl stop trojan-go
    colorEcho $BLUE " trojan-go stopped"
}


restart() {
    res=`status`
    if [[ $res -lt 2 ]]; then
        echo -e " ${RED}trojan-go not installed! ${PLAIN}"
        return
    fi

    stop
    start
}

reconfig() {
    res=`status`
    if [[ $res -lt 2 ]]; then
        echo -e " ${RED}trojan-go not installed! ${PLAIN}"
        return
    fi

    line1=`grep -n 'websocket' $CONFIG_FILE  | head -n1 | cut -d: -f1`
    line11=`expr $line1 + 1`
    WS=`sed -n "${line11}p" $CONFIG_FILE | cut -d: -f2 | tr -d \",' '`
    getData true
    configTrojan
    setFirewall
    getCert
    configNginx
    stop
    start
    showInfo

    bbrReboot
}


showInfo() {
    res=`status`
    if [[ $res -lt 2 ]]; then
        echo -e " ${RED}trojan-go not installed! ${PLAIN}"
        return
    fi

    domain=`grep sni $CONFIG_FILE | cut -d\" -f4`
    port=`grep local_port $CONFIG_FILE | cut -d: -f2 | tr -d \",' '`
    line1=`grep -n 'password' $CONFIG_FILE  | head -n1 | cut -d: -f1`
    line11=`expr $line1 + 1`
    password=`sed -n "${line11}p" $CONFIG_FILE | tr -d \"' '`
    line1=`grep -n 'websocket' $CONFIG_FILE  | head -n1 | cut -d: -f1`
    line11=`expr $line1 + 1`
    ws=`sed -n "${line11}p" $CONFIG_FILE | cut -d: -f2 | tr -d \",' '`
    echo ""
    echo -n " trojan-go status: "
    statusText
    echo ""
    echo -e " ${BLUE}trojan-go config file: ${PLAIN} ${RED}${CONFIG_FILE}${PLAIN}"
    echo -e " ${BLUE}trojan-go config: ${PLAIN}"
    echo -e "   IP: ${RED}$IP${PLAIN}"
    echo -e "   domain/host/SNI/peer: ${RED}$domain${PLAIN}"
    echo -e "   port: ${RED}$port${PLAIN}"
    echo -e "   password: ${RED}$password${PLAIN}"
    if [[ $ws = "true" ]]; then
        echo -e "   websocket: ${RED}true${PLAIN}"
        wspath=`grep path $CONFIG_FILE | cut -d: -f2 | tr -d \",' '`
        echo -e "   ws path: ${RED}${wspath}${PLAIN}"
    fi
    echo ""
}

showLog() {
    res=`status`
    if [[ $res -lt 2 ]]; then
        echo -e "${RED}trojan-go not installed! ${PLAIN}"
        return
    fi

    journalctl -xen -u trojan-go --no-pager
}

menu() {
    clear
    echo "#############################################################"
    echo -e "#                    ${BLUE}trojan-go script${PLAIN}                  #"
    echo "#############################################################"
    echo ""

    echo -e "  ${GREEN}1.${PLAIN}  Install trojan-go"
    echo -e "  ${GREEN}2.${PLAIN}  Install trojan-go+WS"
    echo -e "  ${GREEN}3.${PLAIN}  Update trojan-go"
    echo -e "  ${GREEN}4.  ${RED}Uninstall trojan-go${PLAIN}"
    echo " -------------"
    echo -e "  ${GREEN}5.${PLAIN}  Start trojan-go"
    echo -e "  ${GREEN}6.${PLAIN}  Restart trojan-go"
    echo -e "  ${GREEN}7.${PLAIN}  Stop trojan-go"
    echo " -------------"
    echo -e "  ${GREEN}8.${PLAIN}  View trojan-go config"
    echo -e "  ${GREEN}9.  ${RED}Modify trojan-go config${PLAIN}"
    echo -e "  ${GREEN}10.${PLAIN} View trojan-go log"
    echo " -------------"
    echo -e "  ${GREEN}0.${PLAIN} exit"
    echo 
    echo -n " status: "
    statusText
    echo 

    read -p " Type action [0-10]: " answer
    case $answer in
        0)
            exit 0
            ;;
        1)
            install
            ;;
        2)
            WS="true"
            install
            ;;
        3)
            update
            ;;
        4)
            uninstall
            ;;
        5)
            start
            ;;
        6)
            restart
            ;;
        7)
            stop
            ;;
        8)
            showInfo
            ;;
        9)
            reconfig
            ;;
        10)
            showLog
            ;;
        *)
            echo -e "$RED Not a acton! ${PLAIN}"
            exit 1
            ;;
    esac
}

checkSystem

action=$1
[[ -z $1 ]] && action=menu
case "$action" in
    menu|update|uninstall|start|restart|stop|showInfo|showLog)
        ${action}
        ;;
    *)
        echo " Parameter error"
        echo " Usage: `basename $0` [menu|update|uninstall|start|restart|stop|showInfo|showLog]"
        ;;
esac
