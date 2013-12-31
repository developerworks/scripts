#!/bin/bash
iptables -N IN_STAT
iptables -F IN_STAT
iptables -A IN_STAT -p tcp --dport 3306 -d 127.0.0.1 -m comment --comment "Mysql database incoming traffic"
iptables -A IN_STAT -p tcp --dport 9000 -d 127.0.0.1 -m comment --comment "Php backend incoming traffic"

iptables -A IN_STAT -i eth0 -p tcp --dport 22 -m comment --comment "Ssh incoming traffic"
iptables -A IN_STAT -i eth0 -p tcp --dport 80 -m comment --comment "Http request data accepted"
iptables -A IN_STAT -m state --state NEW -m geoip ! --source-country CN

iptables -N OUT_STAT
iptables -F OUT_STAT
iptables -A OUT_STAT -p tcp --sport 3306 -s 127.0.0.1 -m comment --comment "Mysql database outgoing traffic"
iptables -A OUT_STAT -p tcp --sport 9000 -s 127.0.0.1 -m comment --comment "Php backend outgoing traffic"

iptables -A OUT_STAT -o eth0 -p tcp --sport 22 -m comment --comment "Ssh outgoing traffic"
iptables -A OUT_STAT -o eth0 -p tcp --sport 80 -m comment --comment "Http response data sent"

iptables -F INPUT
iptables -P INPUT ACCEPT
iptables -A INPUT -j IN_STAT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -d 127.0.0.0/8 -j REJECT
iptables -A INPUT -i eth0 -p icmp --icmp-type echo-request -m length --length 128 -m recent --set --name SSHOPEN --rsource -j ACCEPT
iptables -A INPUT -i eth0 -p icmp --icmp-type echo-request -m limit --limit 2/s --limit-burst 2 -j ACCEPT
iptables -A INPUT -i eth0 -p icmp --icmp-type echo-request -j DROP
iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW -m recent --rcheck --seconds 30 --name SSHOPEN --rsource -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 22 -j DROP
iptables -A INPUT -s 23.239.4.63 -j ACCEPT
iptables -A INPUT -s 106.186.25.76 -j ACCEPT
iptables -A INPUT -s 60.144.220.155 -j ACCEPT
iptables -A INPUT -s 61.64.61.59 -j ACCEPT
iptables -A INPUT -s 61.38.186.253 -j ACCEPT
iptables -A INPUT -s 101.1.5.112 -j ACCEPT
iptables -A INPUT -s 101.1.5.196 -j ACCEPT
iptables -A INPUT -s 192.253.224.220 -j ACCEPT
iptables -A INPUT -s 192.253.224.220 -j ACCEPT
iptables -A INPUT -s 142.4.115.17 -j ACCEPT
iptables -A INPUT -s 122.226.102.203 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 80 -m iprange --src-range 66.249.64.0-66.249.95.255 -j ACCEPT
iptables -A INPUT -m state --state NEW -m geoip ! --source-country CN -j DROP
iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW -m recent --name HTTP_CLIENTS --set
iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW -m recent --update --name HTTP_CLIENTS --seconds 60 --hitcount 20 -m comment --comment "Every http client only 20 connections allowed" -j DROP
iptables -A INPUT -i eth0 -p tcp --dport 80 -m connlimit --connlimit-above 20 -m comment --comment "Limit every client ony 20 connections" -j DROP
iptables -A INPUT -i eth0 -p tcp --dport 80 -m hashlimit --hashlimit-name IN_TRAFFIC --hashlimit 40/sec --hashlimit-burst 80 --hashlimit-mode srcip --hashlimit-htable-expire 90000 -m comment --comment "Limit to 21 packets per seconds" -j ACCEPT  
iptables -A INPUT -i eth0 -p tcp --dport 80 -m comment --comment "If incoming packets speed > 40, drop it " -j DROP 
iptables -A INPUT -i eth0 -p tcp --dport 80 -m limit --limit 100/s --limit-burst 2000 -m comment --comment "Limit total incoming traffic" -j ACCEPT
iptables -A INPUT -i eth0 -m state --state INVALID -j DROP
iptables -A INPUT -i eth0 -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
iptables -A INPUT -i eth0 -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -i eth0 -p tcp --tcp-flags SYN,ACK SYN,ACK -m state --state NEW -j DROP

iptables -F OUTPUT
iptables -A OUTPUT -j OUT_STAT
iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m hashlimit --hashlimit-name OUT_TRAFFIC --hashlimit 100/sec --hashlimit-burst 100 --hashlimit-mode srcip --hashlimit-htable-expire 90000 -j ACCEPT   
iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m limit --limit 100/s --limit-burst 100 -m comment --comment "Limit total outgong traffic" -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m comment --comment "If outgoing packets speed > N, drop it " -j DROP
iptables -A OUTPUT -o eth0 -m state --state INVALID -j DROP
