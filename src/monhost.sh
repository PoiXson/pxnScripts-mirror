#!/usr/bin/bash
## ================================================================================
## Copyright (c) 2013-2025 Mattsoft/PoiXson
## <https://mattsoft.net> <https://poixson.com>
## Released under the AGPL 3.0 + ADD-PXN-V1
##
## Description: Pings a remote host until it's able to connect with ssh.
##
## ================================================================================
##
## This program is free software: you can redistribute it and/or modify it under
## the terms of the GNU Affero General Public License + ADD-PXN-V1 as published by
## the Free Software Foundation, either version 3 of the License, or (at your
## option) any later version, with the addition of ADD-PXN-V1.
##
## This program is distributed in the hope that it will be useful, but WITHOUT ANY
## WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
## PARTICULAR PURPOSE.
##
## See the GNU Affero General Public License for more details
## <http://www.gnu.org/licenses/agpl-3.0.en.html> and Addendum ADD-PXN-V1
## <https://dl.poixson.com/ADD-PXN-V1.txt>
##
## **ADD-PXN-V1 - Addendum to the GNU Affero General Public License (AGPL)**
## This Addendum is an integral part of the GNU Affero General Public License
## (AGPL) under which this software is licensed. By using, modifying, or
## distributing this software, you agree to the following additional terms:
##
## 1. **Source Code Availability:** Any distribution of the software, including
##    modified versions, must include the complete corresponding source code. This
##    includes all modifications made to the original source code.
## 2. **Free of Charge and Accessible:** The source code and any modifications to
##    the source code must be made available to all with reasonable access to the
##    internet, free of charge. No fees may be charged for access to the source
##    code or for the distribution of the software, whether in its original or
##    modified form. The source code must be accessible in a manner that allows
##    users to easily obtain, view, and modify it. This can be achieved by
##    providing a link to a publicly accessible repository (e.g., GitHub, GitLab)
##    or by including the source code directly with the distributed software.
## 3. **Documentation of Changes:** When distributing modified versions of the
##    software, you must provide clear documentation of the changes made to the
##    original source code. This documentation should be included with the source
##    code, and should be easily accessible to users.
## 4. **No Additional Restrictions:** You may not impose any additional
##    restrictions on the rights granted by the AGPL or this Addendum. All
##    recipients of the software must have the same rights to use, modify, and
##    distribute the software as granted under the AGPL and this Addendum.
## 5. **Acceptance of Terms:** By using, modifying, or distributing this software,
##    you acknowledge that you have read, understood, and agree to comply with the
##    terms of the AGPL and this Addendum.
## ================================================================================
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
