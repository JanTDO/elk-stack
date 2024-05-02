#!/bin/bash

# Author: JanTDO

# This script takes filename as commandline arugment, and will convert
# pcap to csv, this script requires tshark, as it depends on tshark for
# reading and converting the pcap file.

# Declaration of variables - ffname = filname with extension, ext = extension
# filename = filname with extension removed.

ffname=$(basename -- "$1")
ext="${ffname##*.}"
filename="${ffname%.*}"

if [[ $ext == 'pcap' || $ext == 'cap' ]]; then
	echo "File extension verified"
	# Adding header line to the file
	echo "time,proto,ip_src,ip_dst,tcp_port,udp_port,icmp_type" > $filename.csv
# Tshark reads the pcap file, extracts time, source ip, destination ip, destination port for tcp and udp and icmp type, creating and writing to the same filename as input only with csv extention.
	tshark -r $1 -t ad -T fields -e _ws.col.Time -e ip.src -e ip.dst -e tcp.dstport -e udp.dstport -e icmp.type -Eseparator=, --log-level 'critical' >> $filename.csv
	# Counting lines in the written csv file
	lines=$(cat $filename.csv | wc -hl)
	echo "Conversion completed, $lines lines converted!"


else
	echo "Fileformat is not pcap or cap!"

fi

