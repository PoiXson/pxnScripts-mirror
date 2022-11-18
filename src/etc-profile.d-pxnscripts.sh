#!/usr/bin/bash
# /etc/profile.d/pxnscripts.sh


# common
if [ -e /usr/bin/pxn/scripts/common.sh ]; then
	source /usr/bin/pxn/scripts/common.sh
fi


# screen
if [[ ! -e "/home/$USER/.local/" ]]; then
	\install  -m 0755  -d "/home/$USER/.local/"  || exit 1
fi
if [[ ! -e "/home/$USER/.local/screen/" ]]; then
	\install  -m 0700  -d "/home/$USER/.local/screen/"  || exit 1
fi
export SCREENDIR=/home/$USER/.local/screen
