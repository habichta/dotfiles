#!/bin/bash
SEARCH_DOMAINS=$(ipconfig.exe /all | sed -n 's/\r//;/Search/,/^$/{/^$/q;s/.*://;p}')
CURRENT_IPCONFIG=$(echo search $SEARCH_DOMAINS)
CURRENT_RESOLVCONF=$(grep -w "search" /etc/resolv.conf)
sudo ~/.dotfiles/scripts/sedimentum_dns/clean-resolv-conf.sh
echo $CURRENT_IPCONFIG | sudo ~/.dotfiles/scripts/sedimentum_dns/append-resolv-conf.sh > /dev/null
