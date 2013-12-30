#!/bin/bash
iptables -N IN_STAT
iptables -F IN_STAT
iptables -A IN_STAT -p tcp --dport 3306 -d 192.168.184.137 -m comment --comment "Mysql database incoming traffic"
iptables -A IN_STAT -i eth0 -p tcp --dport 22 -m comment --comment "Ssh incoming traffic"
iptables -A IN_STAT -i eth0 -p tcp --dport 80 -m comment --comment "Http request data accepted"
iptables -A IN_STAT -m state --state NEW -m geoip ! --source-country CN
