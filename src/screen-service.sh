#!/usr/bin/bash
##==============================================================================
## Copyright (c) 2019-2022 PoiXson, Mattsoft
## <https://poixson.com> <https://mattsoft.net>
## Released under the GPL 3.0
##
## Description: Screen as a systemd service
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
# screen-service.sh
VERSION="{{{VERSION}}}"



source /usr/bin/pxn/scripts/common.sh  || exit 1

if [[ -z $WDIR ]]; then
	echo
	failure "Failed to find current working directory"
	failure ; exit 1
fi



VERBOSE=$NO
QUIET=$NO
IS_DAEMON=$NO
IS_ATTACH=$NO
ACTIONS=""
NAMES=""



function DisplayHelp() {
	echo -e "${COLOR_BROWN}Usage:${COLOR_RESET}"
	echo    "  screen-service [options] <action>"
	echo
	echo -e "${COLOR_BROWN}Actions:${COLOR_RESET}"
	echo -e "  ${COLOR_GREEN}start, stop, save,${COLOR_RESET}"
	echo -e "  ${COLOR_GREEN}restart, reload${COLOR_RESET}"
	echo
	echo -e "${COLOR_BROWN}Options:${COLOR_RESET}"
	echo -e "  ${COLOR_GREEN}--daemon${COLOR_RESET}                  Send to the background"
	echo -e "  ${COLOR_GREEN}--nodaemon, --attach${COLOR_RESET}      Attach the screen session"
	echo
	echo -e "  ${COLOR_GREEN}--colors${COLOR_RESET}                  Enable console colors"
	echo -e "  ${COLOR_GREEN}--no-colors${COLOR_RESET}               Disable console colors"
	echo -e "  ${COLOR_GREEN}-V, --version${COLOR_RESET}             Display the version"
	echo -e "  ${COLOR_GREEN}-h, --help${COLOR_RESET}                Display this help message and exit"
	echo
	exit 1
}

function DisplayVersion() {
	echo -e "${COLOR_BROWN}screen-service${COLOR_RESET} ${COLOR_GREEN}${VERSION}${COLOR_RESET}"
	echo
}



# parse args
echo
if [[ $# -eq 0 ]]; then
	DisplayHelp
	exit 1
fi
while [ $# -gt 0 ]; do
	case "$1" in

	start)   ACTIONS="$ACTIONS start"   ;;
	stop)    ACTIONS="$ACTIONS stop"    ;;
	restart) ACTIONS="$ACTIONS restart" ;;
	reload)  ACTIONS="$ACTIONS reload"  ;;
	save)    ACTIONS="$ACTIONS save"    ;;

	--daemon|--detached)
		IS_DAEMON=$YES
		IS_ATTACH=$NO
	;;
	--nodaemon|--no-daemon|--attach|--attached)
		IS_DAEMON=$NO
		IS_ATTACH=$YES
	;;

	-v|--verbose) VERBOSE=$YES ;;
	-q|--quiet)   QUIET=$YES   ;;
	--color|--colors)       NO_COLORS=$NO  ; enable_colors  ;;
	--no-color|--no-colors) NO_COLORS=$YES ; disable_colors ;;
	-V|--version) DisplayVersion ; exit 1 ;;
	-h|--help)    DisplayHelp    ; exit 1 ;;

	*)
		NAMES="$NAMES $1"
	;;

	-*)
		failure "Unknown argument: $1"
		failure
		DisplayHelp
		exit 1
	;;
	esac
	\shift
done

# perform actions
local ATTACH=$NO
for NAME in $NAMES; do
	for ACTION in $ACTIONS; do
		# default attach mode
		if [[ $IS_DAEMON -eq $YES ]] \
		|| [[ $IS_ATTACH -eq $YES ]]; then
			ATTACH=$IS_ATTACH
		else
			case "$ACTION" in
			start)   ATTACH=$YES ;;
			stop)    ATTACH=$YES ;;
			restart) ATTACH=$YES ;;
			reload)  ATTACH=$NO  ;;
			save)    ATTACH=$NO  ;;
			*) failure "Unknown action: $ACTION" ; failure ; exit 1 ;;
			esac
		fi
		if [[ $ATTACH -eq $YES ]]; then
			local ATTACH_STR=""
		else
			local ATTACH_STR="-dm"
		fi
		# perform action
		case "$ACTION" in
		start)   do_start   "$NAME" ;;
		stop)    do_stop    "$NAME" ;;
		restart) do_restart "$NAME" ;;
		reload)  do_reload  "$NAME" ;;
		save)    do_save    "$NAME" ;;
		*) failure "Unknown action: $ACTION" ; failure ; exit 1 ;;
		esac
	done
done



exit 0
