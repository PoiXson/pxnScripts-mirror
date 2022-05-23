#!/usr/bin/bash
# /etc/profile.d/pxnscripts.sh


# common
if [ -e /usr/bin/pxn/scripts/common.sh ]; then
	source /usr/bin/pxn/scripts/common.sh
fi

# aliases
if [ -e /usr/bin/pxn/scripts/aliases.sh ]; then
	source /usr/bin/pxn/scripts/aliases.sh
fi
