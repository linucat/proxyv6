#!/bin/sh

random_name() {
	tr </dev/urandom -dc A-Za-z0-9 | head -c5
	echo
}

random_password() {
	tr </dev/urandom -dc A-Za-z0-9 | head -c16
	echo
}


array=(1 2 3 4 5 6 7 8 9 0 a b c d e f)

main_interface=$(ip route get 8.8.8.8 | awk -- '{printf $5}')
gen64() {
	ip64() {
		echo "${array[$RANDOM % 16]}${array[$RANDOM % 16]}${array[$RANDOM % 16]}${array[$RANDOM % 16]}"
	}
	echo "$1:$(ip64):$(ip64):$(ip64):$(ip64)"
}

gen_3proxy() {
    cat <<EOF
daemon
maxconn 2000
nserver 1.1.1.1
nserver 8.8.4.4
nserver 2001:4860:4860::8888
nserver 2001:4860:4860::8844
nscache 65536
timeouts 1 5 30 60 180 1800 15 60
setgid 65535
setuid 65535
stacksize 6291456
flush
auth strong
users $(awk -F "/" 'BEGIN{ORS="";} {print $1 ":CL:" $2 " "}' ${WORKDATA})
$(awk -F "/" '{print "auth strong\n" \
"allow " $1 "\n" \
"proxy -6 -n -a -p" $4 " -i" $3 " -e"$5"\n" \
"flush\n"}' ${WORKDATA})
EOF
}

gen_proxy_file_for_user() {
    cat >proxy.txt <<EOF
$(awk -F "/" '{print $3 ":" $4 ":" $1 ":" $2 }' ${WORKDATA})
EOF
}

gen_data() {
    seq $FIRST_PORT $LAST_PORT | while read port; do
        echo "aloproxy-$(random_name)/$(random_password)/$IP4/$port/$(gen64 $IP6)"
    done
}
gen_iptables() {
    cat <<EOF
    $(awk -F "/" '{print "iptables -I INPUT -p tcp --dport " $4 "  -m state --state NEW -j ACCEPT"}' ${WORKDATA})
EOF
}
gen_ifconfig() {
    cat <<EOF
$(awk -F "/" '{print "ifconfig '$main_interface' inet6 add " $5 "/64"}' ${WORKDATA})
EOF
}

WORKDIR="/home/proxy-installer"
WORKDATA=${WORKDIR}/data.txt
mkdir -p $WORKDIR && cd $WORKDIR
IP4=$(curl -4 -s icanhazip.com)
IP6=$(curl -6 -s icanhazip.com | cut -f1-4 -d':')
echo "Internal ip = ${IP4}. Exteranl sub for ip6 = ${IP6}"

echo "Which port do you want to start from?: Example 20501"
read COUNT1
echo "How many proxy do you want to add? Example 100"
read COUNT2

FIRST_PORT=$COUNT1
LAST_PORT=$(($FIRST_PORT + $COUNT2 - 1))

gen_data >>$WORKDIR/data.txt
gen_iptables >$WORKDIR/boot_iptables.sh
gen_ifconfig >$WORKDIR/boot_ifconfig.sh

gen_3proxy >/usr/local/etc/3proxy/3proxy.cfg

bash /etc/rc.local

iptables --list > /home/proxy-installer/iptables.txt

gen_proxy_file_for_user

echo "Please reboot"
