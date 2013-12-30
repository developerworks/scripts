#!/bin/bash
echo "downloading /root/open_in_stat.sh"
wget -q https://raw.github.com/developerworks/scripts/master/open_in_stat.sh -O /root/open_in_stat.sh
chmod +x /root/open_in_stat.sh
echo "downloading /root/close_in_stat.sh"
wget -q https://raw.github.com/developerworks/scripts/master/close_in_stat.sh -O /root/close_in_stat.sh
chmod +x /root/close_in_stat.sh
echo "downloading /root/iptables.sh"
wget -q https://raw.github.com/developerworks/scripts/master/iptables.sh -O /root/iptables.sh
chmod +x /root/iptables.sh
echo "downloading /boot/grub/menu.lst"
wget -q https://raw.github.com/developerworks/scripts/master/menu.lst -O /boot/grub/menu.lst