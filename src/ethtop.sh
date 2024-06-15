#!/usr/bin/bash
##==============================================================================
## Copyright (c) 2013-2024 Mattsoft/PoiXson
## <https://mattsoft.net> <https://poixson.com>
## Released under the AGPL 3.0
##
## Description: Displays bandwidth and packets per second stats for interfaces.
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU Affero General Public License as
## published by the Free Software Foundation, either version 3 of the
## License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Affero General Public License for more details.
##
## You should have received a copy of the GNU Affero General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.
##==============================================================================
# ethtop.sh
clear



display_help() {
	echo
	echo "usage: $0 [network-interface]"
	echo
	echo "e.g. $0 eth0"
	echo
	exit 1
}



INTERVAL="1"  # update interval in seconds
INTERFACES=
while [ $# -gt 0 ]; do
	case $1 in
	-i|--interval)
		shift
		INTERVAL="$1"
		;;
	-h|--help)
		display_help
		exit 0
		;;
	*)
		INTERFACES+=("$1")
	esac
	shift
done



if [ ${#INTERFACES[@]} -eq 0 ]; then
	display_help
	exit 0
fi
echo
echo " Interfaces: ${INTERFACES[@]}"
echo



display_stats() {
	INDEX="$1"
	IF="$2"
	# calculate bw
	BW_RX=$( expr "${NOW_BW_RX[$INDEX]}" - "${LAST_BW_RX[$INDEX]}" )
	BW_TX=$( expr "${NOW_BW_TX[$INDEX]}" - "${LAST_BW_TX[$INDEX]}" )
	BW_RX=$( expr $BW_RX / $INTERVAL )
	BW_TX=$( expr $BW_TX / $INTERVAL )
	if [ $BW_RX -lt 1024 ]; then
		BW_RX="$BW_RX B/s"
	elif [ $BW_RX -lt 1048576 ]; then
		BW_RX=`expr $BW_RX / 1024`
		BW_RX="$BW_RX KB/s"
	elif [ $BW_RX -lt 1073741824 ]; then
		BW_RX=`expr $BW_RX / 1048576`
		BW_RX="$BW_RX MB/s"
	elif [ $BW_RX -lt 1099511627776 ]; then
		BW_RX=`expr $BW_RX / 1073741824`
		BW_RX="$BW_RX GB/s"
	fi
	if [ $BW_TX -lt 1024 ]; then
		BW_TX="$BW_TX B/s"
	elif [ $BW_TX -lt 1048576 ]; then
		BW_TX=`expr $BW_TX / 1024`
		BW_TX="$BW_TX KB/s"
	elif [ $BW_TX -lt 1073741824 ]; then
		BW_TX=`expr $BW_TX / 1048576`
		BW_TX="$BW_TX MB/s"
	elif [ $BW_TX -lt 1099511627776 ]; then
		BW_TX=`expr $BW_TX / 1073741824`
		BW_TX="$BW_TX GB/s"
	fi
	# calculate pps
	PPS_RX=$( expr "${NOW_PPS_RX[$INDEX]}" - "${LAST_PPS_RX[$INDEX]}" )
	PPS_TX=$( expr "${NOW_PPS_TX[$INDEX]}" - "${LAST_PPS_TX[$INDEX]}" )
	PPS_RX=$( expr $PPS_RX / $INTERVAL )
	PPS_TX=$( expr $PPS_TX / $INTERVAL )

	# display bw/pps
	echo " $IF - RX/TX: $BW_RX / $BW_TX   [ $PPS_RX / $PPS_RX pps ]"

}



echo
# find longest string
#MAX_LEN=0
for IF in ${INTERFACES[@]}; do
#	LEN=$( echo -n "$IF" | wc -m )
#	if [ $LEN -gt $MAX_LEN ]; then
#		MAX_LEN=$LEN
#	fi
	LAST_BW_RX+=$( cat /sys/class/net/"$IF"/statistics/rx_bytes )
	LAST_BW_TX+=$( cat /sys/class/net/"$IF"/statistics/tx_bytes )
	LAST_PPS_RX+=$( cat /sys/class/net/"$IF"/statistics/rx_packets )
	LAST_PPS_TX+=$( cat /sys/class/net/"$IF"/statistics/tx_packets )
done

while true; do
	sleep $INTERVAL
	NOW_BW_RX=
	NOW_BW_TX=
	NOW_PPS_RX=
	NOW_PPS_TX=
	# get latest stats
	for IF in ${INTERFACES[@]}; do
		# collect bw/pps
		NOW_BW_RX+=$( cat /sys/class/net/"$IF"/statistics/rx_bytes )
		NOW_BW_TX+=$( cat /sys/class/net/"$IF"/statistics/tx_bytes )
		NOW_PPS_RX+=$( cat /sys/class/net/"$IF"/statistics/rx_packets )
		NOW_PPS_TX+=$( cat /sys/class/net/"$IF"/statistics/tx_packets )
	done
	# display
	INDEX=0
	for IF in ${INTERFACES[@]}; do
#		LEN=$( echo -n "$IF" | wc -m )
#		PAD_LEN=$(( $MAX_LEN - $LEN ))
#		PAD=$(printf "%${PAD_LEN}s")
#		echo -n " $IF $PAD- "
		display_stats $INDEX $IF
		INDEX=$(( $INDEX + 1 ))
	done
	echo
	# store value for later
	INDEX=0
	LAST_BW_RX=("${NOW_BW_RX[@]}")
	LAST_BW_TX=("${NOW_BW_TX[@]}")
	LAST_PPS_RX=("${NOW_PPS_RX[@]}")
	LAST_PPS_TX=("${NOW_PPS_TX[@]}")
done
