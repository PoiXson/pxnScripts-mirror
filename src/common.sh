##==============================================================================
## Copyright (c) 2013-2024 Mattsoft/PoiXson
## <https://mattsoft.net> <https://poixson.com>
## Released under the AGPL 3.0
##
## Description: Common methods and utilities for pxn shell scripts.
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
# common.sh

set -o pipefail

source /usr/bin/pxn/scripts/defines.sh  || exit 1



WDIR=$( \pwd )



# debug mode
DEBUG=$NO
if [ -e /usr/bin/pxn/scripts/.debug ]; then
	DEBUG=$YES
fi
if [ -e ~/.debug ]; then
	DEBUG=$YES
fi
if [ $DEBUG -eq $YES ]; then
	echo "[ DEBUG Mode ]" >&2
	# Print commands when executed
	set -x
	# Variables that are not set are errors
	set -u
fi



function path_append()  { path_remove "$1" ; export PATH="$PATH:$1" ; }
function path_prepend() { path_remove "$1" ; export PATH="$1:$PATH" ; }
function path_remove()  { export PATH=`echo -n $PATH | awk -v RS=: -v ORS=: '$0 != "'$1'"' | sed 's/:$//'`; }



# rust/cargo
if [[ -d "$HOME/.cargo/bin/" ]]; then
	path_append "$HOME/.cargo/bin"
fi



function error_msg() {
	echo "$*" >&2
}
function info() {
	if [[ -z $1 ]]; then
		echo >&2
	else
		echo -e "${COLOR_DARKGRAY} [INFO] ${COLOR_RESET}$*" >&2
	fi

}
function notice() {
	if [[ -z $1 ]]; then
		echo >&2
	else
		echo -e "${COLOR_LIGHTCYAN} [NOTICE] ${COLOR_RESET}$*" >&2
	fi
}
function warning() {
	if [[ -z $1 ]]; then
		echo >&2
	else
		echo -e "${COLOR_LIGHTRED} [WARNING] ${COLOR_RESET}$*" >&2
	fi
}
function failure() {
	if [[ -z $1 ]]; then
		echo >&2
	else
		echo -e "${COLOR_RED} [FAILURE] ${COLOR_RESET}$*" >&2
	fi
}



function echo_cmd() {
	local N=""
	if [[ "$1" == "-n" ]]; then
		N="-n"
		\shift
	fi
	local IS_FIRST=$YES
	for LINE in "${@}"; do
		if [[ $IS_FIRST -eq $YES ]]; then
			IS_FIRST=$NO
			echo $N -e " ${COLOR_GREEN}>${COLOR_RESET} ${COLOR_CYAN}$LINE${COLOR_RESET}"
		else
			echo $N -e "     ${COLOR_CYAN}$LINE${COLOR_RESET}"
		fi
	done
}



function title() {
	# format
	case "$1" in
	A|B|C)
		TITLE_FORMAT="$1"
		shift
	;;
	# default format
	*)
		TITLE_FORMAT="C"
	;;
	esac
	LONGEST_LEN=1
	for LINE in "$@"; do
		local LEN=${#LINE}
		if [ $LEN -gt $LONGEST_LEN ]; then
			LONGEST_LEN=$LEN
		fi
	done
	local _A=$(($LONGEST_LEN+8))
	local _B=$(($LONGEST_LEN+2))
	# ****************
	# ****************
	# **            **
	# **  Format A  **
	# **            **
	# ****************
	# ****************
	case "$TITLE_FORMAT" in
	A)
		echo
		echo -ne "$COLOR_BROWN"
		echo -n " "; eval "printf '*'%.0s {1..$_A}"; echo
		echo -n " "; eval "printf '*'%.0s {1..$_A}"; echo
		echo -n " ** "; eval "printf ' '%.0s {1..$_B}"; echo " **"
		for LINE in "${@}"; do
			local _S=$(($_B-${#LINE}))
			echo -n " **  ${LINE}"; eval "printf ' '%.0s {1..$_S}"; echo "**"
		done
		echo -n " ** "; eval "printf ' '%.0s {1..$_B}"; echo " **"
		echo -n " "; eval "printf '*'%.0s {1..$_A}"; echo
		echo -n " "; eval "printf '*'%.0s {1..$_A}"; echo
		echo -ne "$COLOR_RESET"
		echo
	;;
	# +------------+
	# |  Format B  |
	# +------------+
	B)
		echo -ne "$COLOR_BROWN"
		echo -n " +"; eval "printf %.0s'-' {5..$_A}"; echo "+ "
		for LINE in "${@}"; do
			local _S=$(($LONGEST_LEN-${#LINE}))
			echo -n " |  ${LINE}"; eval "printf ' '%.0s {0..$_S}"; echo " | "
		done
		echo -n " +"; eval "printf %.0s'-' {5..$_A}"; echo "+ "
		echo -ne "$COLOR_RESET"
	;;
	# [ Format C ]
	*)
		for LINE in "${@}"; do
			local _S=$(($_B-${#LINE}))
			echo -ne "${COLOR_BROWN} [ ${LINE}"; eval "printf ' '%.0s {2..$_S}"; echo -e "]${COLOR_RESET}"
		done
	;;
	esac
}



function sleepdot() {
	sleep 1;echo -n "."
	sleep 1;echo -n "."
	sleep 1;echo ""
}
function sleepdotdot() {
	sleep 2;echo -n " ."
	sleep 2;echo -n " ."
	sleep 2;echo -n " ."
	sleep 2;echo -n " ."
	sleep 2;echo ""
}



function progress_percent() {
	let width=25
	if [[ -z "$1" ]] || [[ -z "$2" ]]; then
		failure 'Missing required argument!'
		exit 1
	fi
	TOTAL=$1
	CURRENT=$2
	let val=$CURRENT*$width
	let val=$val/$TOTAL
	echo -n '['
	for ((i=1; $i<=$width; i++)); do
		if [ $i -le $val ]; then
			echo -n '='
		else
			echo -n ' '
		fi
	done
	echo ']'
}



function get_lock() {
	for i in {20..1} ; do
		is_locked "$@"
		LOCK_COUNT=$?
		if [ $LOCK_COUNT -le 1 ]; then
			return 0
		fi
		echo
		echo -n " [${i}] Another instance is running.";
		sleep 1; echo -n '.'; sleep 1; echo -n '.'; sleep 1
		echo
	done
	echo
	failure "Timeout waiting for other instance to complete!"
	echo
	exit 1
}
function is_locked() {
	LOCK_FILE="$1"
	if [ -z $LOCK_FILE ]; then
		LOCK_FILE=`realpath "$0"`
	fi
	if [ -z $LOCK_FILE ]; then
		failure "Failed to detect lock file!"
		exit 1
	fi
	LOCK_COUNT=`lsof -t "${LOCK_FILE}" | wc -l`
	return $LOCK_COUNT
}



function find_screen() {
	LIST=$( \screen -list | \grep -o "^\s*[0-9]*\.$1\s" )
	[[ -z $LIST ]] && return
	RESULT=""
	for ENTRY in $LIST; do
		echo ${ENTRY%%.*}
	done
}
