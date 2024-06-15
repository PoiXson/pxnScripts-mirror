#!/usr/bin/bash
##==============================================================================
## Copyright (c) 2013-2024 Mattsoft/PoiXson
## <https://mattsoft.net> <https://poixson.com>
## Released under the AGPL 3.0
##
## Description: Pings a remote host until it's able to connect with ssh.
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
# monitorhost.sh


TRUE=1
FALSE=0

LOCK_FILE_PREFIX="/tmp/monitor_failed_"


# arguments
ALERT_EMAIL="${1}"
if [ -z $ALERT_EMAIL ]; then
	echo "Alert email argument is required" >&2
	exit 1
fi
PING_HOST="${2}"
if [ -z $PING_HOST ]; then
	echo "Remote host argument is required" >&2
	exit 1
fi


# ping remote host
ping -c1 "${PING_HOST}" >/dev/null && SUCCESS=TRUE || SUCCESS=FALSE


# ping success
if [ $SUCCESS = TRUE ]; then
	# returned online
	if [ -f "${LOCK_FILE_PREFIX}${PING_HOST}" ]; then
		echo "Host ${PING_HOST} returned online!"
		rm -f "${LOCK_FILE_PREFIX}${PING_HOST}"
		/usr/sbin/sendmail "${ALERT_EMAIL}" <<EOF
from:${ALERT_EMAIL}
subject:Host returned online - ${PING_HOST}

Monitored host returned online.

${PING_HOST}
EOF
	fi


# ping failed
else
	# host went offline
	if [ ! -f "${LOCK_FILE_PREFIX}${PING_HOST}" ]; then
		echo "Host ${PING_HOST} is down!"
		touch "${LOCK_FILE_PREFIX}${PING_HOST}"
		/usr/sbin/sendmail "${ALERT_EMAIL}" <<EOF
from:${ALERT_EMAIL}
subject:Host is down - ${PING_HOST}

Monitored host is down!

${PING_HOST}
EOF
	fi
fi
