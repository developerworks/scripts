#!/bin/bash

echo "make dir /root/runtimes"
mkdir /root/runtimes
echo "make dir /root/sources"
mkdir /root/sources

echo "downloading tengine"
wget -q http://tengine.taobao.org/download/tengine-1.5.2.tar.gz -O /root/sources/tengine-1.5.2.tar.gz
echo "change directory to /root/sources"
cd /root/sources/
echo "decompress tengine-1.5.2.tar.gz"
tar zxf tengine-1.5.2.tar.gz
echo "change directory to /root"
cd /root

echo "downloading /root/open_in_stat.sh"
wget -q https://raw.github.com/developerworks/scripts/master/open_in_stat.sh -O /root/open_in_stat.sh

echo "downloading /root/close_in_stat.sh"
wget -q https://raw.github.com/developerworks/scripts/master/close_in_stat.sh -O /root/close_in_stat.sh

echo "downloading /root/iptables.sh"
wget -q https://raw.github.com/developerworks/scripts/master/iptables.sh -O /root/iptables.sh

echo "downloading /root/watchiptables"
wget -q https://raw.github.com/developerworks/scripts/master/watchiptables -O /root/watchiptables

echo "downloading /boot/grub/menu.lst"
wget -q https://raw.github.com/developerworks/scripts/master/menu.lst -O /boot/grub/menu.lst

echo "downloading /etc/init/hvc0.conf"
wget -q https://raw.github.com/developerworks/scripts/master/hvc0.conf -O /etc/init/hvc0.conf

echo "change file mode: /root/open_in_stat.sh"
chmod +x /root/open_in_stat.sh

echo "change file mode: /root/close_in_stat.sh"
chmod +x /root/close_in_stat.sh

echo "change file mode: /root/iptables.sh"
chmod +x /root/iptables.sh

echo "change file mode: /root/watchiptables"
chmod +x /root/watchiptables
