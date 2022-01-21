#!/usr/bin/bash
##==============================================================================
## Copyright (c) 2013-2021 PoiXson, Mattsoft
## <https://poixson.com> <https://mattsoft.net>
## Released under the GPL 3.0
##
## Description: Pings a remote host until it's able to connect with ssh.
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.
##==============================================================================
# pingssh.sh
clear


# find host in ~/.ssh/config file
function find_in_ssh_config() {
	# file ~/.ssh/config not found
	if [ ! -e ~/.ssh/config ]; then
		echo "File ~/.ssh/config not found" >&2
		return 0
	fi
	SEARCH=${1}
	FOUND_HOST=""
	FOUND_PORT=""
	FOUND_USER=""
	while read LINE; do
		if [ -z "$LINE" ]; then
			continue
		fi
		# host
		if [[ $LINE == "Host:"* ]] || [[ $LINE == "Host "* ]] || [[ $LINE == "Host\t"* ]] ; then
			# already found host
			if [ ! -z "$FOUND_HOST" ]; then
				break
			fi
			# parse line
			IFS=' ' read -ra ARRAY <<< "$LINE"
			# found correct host
			if [ ${ARRAY[1]} == $SEARCH ]; then
				FOUND_HOST=${ARRAY[1]}
			fi
		fi
		# params for found host
		if [ ! -z $FOUND_HOST ]; then
			# hostname
			if [[ $LINE == "Hostname:"* ]] || [[ $LINE == "Hostname "* ]] || [[ $LINE == "Hostname\t"* ]] ; then
				# parse line
				IFS=' ' read -ra ARRAY <<< "$LINE"
				FOUND_HOST=${ARRAY[1]}
			fi
			# port
			if [[ $LINE == "Port:"* ]] || [[ $LINE == "Port "* ]] || [[ $LINE == "Port\t"* ]] ; then
				# parse line
				IFS=' ' read -ra ARRAY <<< "$LINE"
				FOUND_PORT=${ARRAY[1]}
			fi
			# user
			if [[ $LINE == "User:"* ]] || [[ $LINE == "User "* ]] || [[ $LINE == "User\t"* ]] ; then
				# parse line
				IFS=' ' read -ra ARRAY <<< "$LINE"
				FOUND_USER=${ARRAY[1]}
			fi
		fi
	done < ~/.ssh/config
	if [ -z "$FOUND_HOST" ]; then
		return 1
	else
		return 0
	fi
}


REMOTE_HOST="${1}"
# host not set
if [ -z $REMOTE_HOST ]; then
	echo "Remote host argument is required" >&2
	exit 1
fi

# parse user@host
if [[ $REMOTE_HOST == *"@"* ]]; then
	IFS='@' read -ra ARRAY <<< "$REMOTE_HOST"
	REMOTE_USER="${ARRAY[0]}"
	REMOTE_HOST="${ARRAY[1]}"
# find in ~/.ssh/config
else
	if find_in_ssh_config $REMOTE_HOST ; then
		echo "Found host in .ssh/config"
		REMOTE_HOST=$FOUND_HOST
		REMOTE_PORT=$FOUND_PORT
		REMOTE_USER=$FOUND_USER
	fi
fi
# parse host:port
if [[ $REMOTE_HOST == *":"* ]]; then
	IFS=':' read -ra ARRAY <<< "$REMOTE_HOST"
	REMOTE_HOST=${ARRAY[0]}
	REMOTE_PORT=${ARRAY[1]}
fi
# default port
if [ -z $REMOTE_PORT ]; then
	REMOTE_PORT=22
fi
# default user
if [ -z $REMOTE_USER ]; then
	REMOTE_USER=`whoami`
fi


# wait for host to come online
STEP=0
LOOP_COUNT=2
while true; do
	clear
	echo

	((STEP++))
	case $STEP in
		1) echo -ne " [*    ] ";;
		2) echo -ne " [**   ] ";;
		3) echo -ne " [***  ] ";;
		4) echo -ne " [ *** ] ";;
		5) echo -ne " [  ***] ";;
		6) echo -ne " [   **] ";;
		7) echo -ne " [    *] ";;
		8) echo -ne " [.    ] ";;
		9) echo -ne " [ .   ] ";;
		10)echo -ne " [  .  ] ";;
		11)echo -ne " [   . ] ";;
		12)echo -ne " [    .] ";
			STEP=0
			((LOOP_COUNT++))
		;;
	esac
	echo -n " Waiting for ${REMOTE_USER}@${REMOTE_HOST} "
	if [[ $LOOP_COUNT -gt 10 ]]; then
		echo "...[$LOOP_COUNT]..."
	else
		for (( i=0; $i<$LOOP_COUNT; i++ )); do
			echo -n "."
		done
		echo
	fi

	# ping remote host
	PING_RESULT=`/usr/bin/ping -w1 -c1 ${REMOTE_HOST} 1>/dev/null 2>/dev/null && echo 0 || echo 1`
	if [[ $PING_RESULT -eq 0 ]]; then
		echo
		echo
		if ssh "${1}" ; then
			echo
			break
		fi
		echo
		sleep 1
	fi
	sleep 0.1

done
