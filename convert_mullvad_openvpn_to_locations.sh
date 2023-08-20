#!/bin/bash

rm LOCATIONS.txt TEMPLATE.txt

unzip mullvad_openvpn_linux_all_all.zip

cat mullvad_config_linux/mullvad*.conf | sort | uniq -c | sort -n | grep -E -v "^\s*1\s" | sed -E -e 's/^[[:space:]]*[[:digit:]]+[[:space:]]*//g' >> TEMPLATE.txt

for i in mullvad_config_linux/mullvad_*.conf; do 
	# cc=$(echo $i | cut -d '_' -f 2); 
	cc=$(basename $i | cut -d '_' -f 2); 
	cc=${cc^^}; 
	#echo $cc; 
	cn=$(grep $cc country.csv | cut -d ',' -f 2 | sed -e 's/"//g'); 
	#echo "country name: $cn"; 
	proto=$(grep -E -o "udp|tcp" $i); 
	#echo "proto: ${proto}";
	ips=$(grep -E '^remote ' $i | cut -d ' ' -f 2 | xargs)
	ports=$(grep -E '^remote ' $i | cut -d ' ' -f 3 | xargs)
	#echo "ips:$ips"
	#echo "ports: $ports"

	echo "$cn (${proto^^}),$ips,$proto,$ports," >> LOCATIONS.txt
done;

cp mullvad_config_linux/mullvad_ca.crt ca.crt
rm -rf mullvad_config_linux/

# place LOCATIONS.txt in /storage/.kodi/userdata/addon_data/service.vpn.manager/Mullvad on Kodi server