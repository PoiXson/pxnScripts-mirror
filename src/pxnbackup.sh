#!/usr/bin/bash
##==============================================================================
## Copyright (c) 2013-2024 Mattsoft/PoiXson
## <https://mattsoft.net> <https://poixson.com>
## Released under the AGPL 3.0
##
## Description: Perform backups with rsync.
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
# pxnBackup.sh
PXNBACKUP_VERSION="{{{VERSION}}}"



source /usr/bin/pxn/scripts/common.sh  || exit 1
echo



function DisplayHelp() {
	local FULL=$1
	echo -e "${COLOR_BROWN}Usage:${COLOR_RESET}"
	echo    "  pxnBackup [options] <group>"
	echo
	echo -e "${COLOR_BROWN}Options:${COLOR_RESET}"
	echo -e "  ${COLOR_GREEN}--a, --all${COLOR_RESET}                Perform a backup for all configured hosts"
	echo -e "  ${COLOR_GREEN}-n, --name${COLOR_RESET}                Perform a backup for this configured host"
	echo -e "  ${COLOR_GREEN}-D, --dry${COLOR_RESET}                 Perform a trial run without making any changes"
	echo
	echo -e "  ${COLOR_GREEN}-q, --quiet${COLOR_RESET}               Hide extra logs"
	echo -e "  ${COLOR_GREEN}--colors${COLOR_RESET}                  Enable console colors"
	echo -e "  ${COLOR_GREEN}--no-colors${COLOR_RESET}               Disable console colors"
	echo -e "  ${COLOR_GREEN}-V, --version${COLOR_RESET}             Display the version"
	echo -e "  ${COLOR_GREEN}-h, --help${COLOR_RESET}                Display this help message and exit"
	echo
	exit 1
	echo
	exit 1
}

function DisplayVersion() {
	echo -e "${COLOR_BROWN}pxnBackup${COLOR_RESET} ${COLOR_GREEN}$PXNBACKUP_VERSION${COLOR_RESET}"
	echo
}



# ----------------------------------------



DO_ALL=$NO
IS_DRY=$NO
BACKUP_FILTERS=""
BACKUP_FILTERS_FOUND=""
VERBOSE=$NO
QUIET=$NO

TIME_START=$( \date "+%s%N" )
let TIME_START_HOST=0
let TIME_LAST=0
let COUNT_HOSTS=0
let COUNT_ACT=0

BACKUP_NAME="<NULL>"
BACKUP_HOST=""
BACKUP_PORT=0
BACKUP_SOURCE=""
BACKUPS_FAILED=$NO
BACKUP_EXCLUDES=()



function DisplayTime() {
	local TIME_CURRENT=$( \date "+%s%N" )
	local ELAPSED=$( echo "scale=3;($TIME_CURRENT - $TIME_LAST) / 1000 / 1000 / 1000" | bc )
	[[ "$ELAPSED" == "."* ]] && \
		ELAPSED="0$ELAPSED"
	echo -e " ${COLOR_CYAN}$1 in $ELAPSED seconds${COLOR_RESET}"
	echo
	TIME_LAST=$TIME_CURRENT
}
function DisplayTimeBackup() {
	local TIME_CURRENT=$( \date "+%s%N" )
	local ELAPSED=$( echo "scale=3;($TIME_CURRENT - $TIME_START_HOST) / 1000 / 1000 / 1000" | bc )
	[[ "$ELAPSED" == "."* ]] && \
		ELAPSED="0$ELAPSED"
	echo -e " ${COLOR_CYAN}Finished host backup in $ELAPSED seconds: $BACKUP_NAME${COLOR_RESET}"
	echo -e " ${COLOR_CYAN}--------------------------------------------------${COLOR_RESET}"
	echo
}



function Host() {
	if [[ ! -z $1 ]]; then
		BACKUP_HOST="$1"
	fi
}
function Port() {
	if [[ ! -z $1 ]]; then
		BACKUP_PORT=$(($1))
	fi
}
function Source() {
	if [[ ! -z $1 ]]; then
		BACKUP_SOURCE="$1"
	fi
}
function Exclude() {
	if [[ ! -z $1 ]]; then
		BACKUP_EXCLUDES+=(" --exclude $1")
	fi
}



function Backup() {
	if [[ -z $BACKUP_NAME ]]; then
		failure "Backup name not set"
		failure ; exit 1
	fi
	# perform previous backup
	doBackup
	CleanupBackupVars
	# configure next backup
	[[ ! -z $1 ]] && BACKUP_NAME="$1"
	[[ ! -z $2 ]] && BACKUP_HOST="$2"
	[[ ! -z $3 ]] && BACKUP_PORT=$3
}



function doBackup() {
	if [[ -z $BACKUP_NAME ]] \
	|| [[ "$BACKUP_NAME" = "<NULL>" ]]; then
		CleanupBackupVars
		return;
	fi
	if [[ -z $PATH_BACKUPS ]]; then
		failure "PATH_BACKUPS not set in /etc/pxnbackups.conf"
		failure ; exit 1
	fi
	BACKUP_FILTERS_FOUND="$BACKUP_FILTERS_FOUND $BACKUP_NAME"
	if [[ ! -z $BACKUP_FILTERS ]]; then
		if [[ " $BACKUP_FILTERS " != *" $BACKUP_NAME "* ]]; then
			[[ $VERBOSE -eq $YES ]] && notice "Skipping filtered: $BACKUP_NAME"
			CleanupBackupVars
			return
		fi
	fi
	echo
	title B "Backup: $BACKUP_NAME"
	echo
	# perform backup
	COUNT_ACT=$((COUNT_ACT+1))
	local RSYNC_ARGS=()
	if [[ $IS_DRY -eq $YES ]]; then
		RSYNC_ARGS+=("--dry-run")
	fi
	if [[ $VERBOSE -eq $YES ]]; then
		RSYNC_ARGS+=("--verbose")
	elif [[ $QUIET -eq $YES ]]; then
		RSYNC_ARGS+=("--quiet")
	fi
	BACKUP_PORT=$((BACKUP_PORT))
	if [[ $BACKUP_PORT -eq 0 ]]; then
		BACKUP_PORT=22
	fi
	if [[ -z $BACKUP_SOURCE ]]; then
		BACKUP_SOURCE="/"
	fi
	if [[ -z $BACKUP_HOST ]]; then
		RSYNC_ARGS+=("$BACKUP_SOURCE")
	else
		RSYNC_ARGS+=("${BACKUP_HOST}:${BACKUP_SOURCE}")
	fi
	echo_cmd "rsync -Fyth --progress --partial --archive --delete-delay --delete-excluded"
	echo_cmd "  --rsh \"ssh -p$((BACKUP_PORT))\""
	for EXCLUDE in "${BACKUP_EXCLUDES[@]}"; do
		echo_cmd " $EXCLUDE"
	done
	echo_cmd "  --exclude ..."
	echo_cmd "  --exclude \"$PATH_BACKUPS\""
	for LINE in "${RSYNC_ARGS[@]}"; do
		echo_cmd "  $LINE"
	done
	echo_cmd "  $PATH_BACKUPS/$BACKUP_NAME/"
	echo
	\rsync -Fyth --progress --partial --archive --delete-delay --delete-excluded  \
		--rsh "ssh -p$((BACKUP_PORT))"  \
		${BACKUP_EXCLUDES[@]}           \
		--exclude "/bin"                \
		--exclude "/boot"               \
		--exclude "/dev"                \
		--exclude "/lib"                \
		--exclude "/lib64"              \
		--exclude "/media"              \
		--exclude "/mnt"                \
		--exclude "/opt"                \
		--exclude "/proc"               \
		--exclude "/run"                \
		--exclude "/sbin"               \
		--exclude "/srv"                \
		--exclude "/sys"                \
		--exclude "/tmp"                \
		--exclude "/usr"                \
		--exclude "/var/tmp"            \
		--exclude "/var/cache"          \
		--exclude "/var/lib/dnf"        \
		--exclude "/var/log/journal"    \
		--exclude "/var/spool/abrt"     \
		--exclude "/var/spool/postfix"  \
		--exclude "/backup"             \
		--exclude "/backups"            \
		--exclude "*/.composer"         \
		--exclude "*/.m2"               \
		--exclude "*.swap"              \
		--exclude "*.cache"             \
		--exclude "*/Trash/"            \
		--exclude "*/.Trash*/"          \
		--exclude "*/lost+found"        \
		--exclude "*/.cargo"            \
		--exclude "*/.rustup"           \
		--exclude "*/.gradle"           \
		--exclude "/home/*/Downloads"   \
		--exclude "$PATH_BACKUPS"       \
		"${RSYNC_ARGS[@]}"  "$PATH_BACKUPS/$BACKUP_NAME/"  || exit 1
	echo
	# backup finished
	DisplayTimeBackup "$BACKUP_NAME"
	CleanupBackupVars
}



function CleanupBackupVars() {
	BACKUP_NAME="<NULL>"
	BACKUP_HOST=""
	BACKUP_PORT=0
	BACKUP_SOURCE=""
	BACKUP_EXCLUDES=()
	TIME_START_HOST=$( \date "+%s%N" )
	TIME_LAST=$TIME_START_HOST
}



# ----------------------------------------
# parse args



if [[ $# -eq 0 ]]; then
	DisplayHelp $NO
	exit 1
fi
SELF="$0"
while [ $# -gt 0 ]; do
	case "$1" in

	-a|--all)  DO_ALL=$YES; ;;

	-n|--name)
		if [[ -z $2 ]] || [[ "$2" == "-"* ]]; then
			failure "--name flag requires a value"
			failure ; DisplayHelp $NO ; exit 1
		fi
		\shift
		if [[ "1" = *" "* ]]; then
			failure "--name flag cannot contain any spaces"
			failure ; exit 1
		fi
		BACKUP_FILTERS="$BACKUP_FILTERS $1"
	;;
	--name=*)
		NAME="${1#*=}"
		if [[ -z $NAME ]]; then
			failure "--name flag requires a value"
			failure ; DisplayHelp $NO ; exit 1
		fi
		BACKUP_FILTERS="$BACKUP_FILTERS $NAME"
	;;

	--dry|--dry-run)
		IS_DRY=$YES
	;;

	-v|--verbose) VERBOSE=$YES ;;
	-q|--quiet)   QUIET=$YES   ;;
	--color|--colors)       NO_COLORS=$NO  ; enable_colors  ;;
	--no-color|--no-colors) NO_COLORS=$YES ; disable_colors ;;
	-V|--version) DisplayVersion   ; exit 1 ;;
	-h|--help)    DisplayHelp $YES ; exit 1 ;;

	-*)
		failure "Unknown flag: $1"
		failure ; DisplayHelp $NO ; exit 1
	;;
	*)
		failure "Unknown argument: $1"
		failure ; DisplayHelp $NO ; exit 1
	;;

	esac
	\shift
done



# count hosts
let COUNT_FOUND=0
if [[ $DO_ALL -eq $YES ]]; then
	echo " Performing all backups.."
else
	for NAME in $BACKUP_FILTERS; do
		if [[ ! -z $NAME ]]; then
			COUNT_FOUND=$((COUNT_FOUND+1))
		fi
	done
	if [[ $COUNT_FOUND -eq 0 ]]; then
		failure "No backup hosts selected"
		failure ; exit 1
	fi
	# list found
	echo -e " Found ${COLOR_GREEN}[${COUNT_FOUND}]${COLOR_RESET} backups:"
	for NAME in $BACKUP_FILTERS; do
		if [[ ! -z $NAME ]]; then
			echo -e "   ${COLOR_BLUE}$NAME${COLOR_RESET}"
		fi
	done
fi



# ----------------------------------------
# perform backups



CleanupBackupVars
# /etc/pxnbackups.conf
if [[ -e "/etc/pxnbackups.conf" ]]; then
	source  "/etc/pxnbackups.conf"  || exit 1
fi
# /etc/pxnbackups.d/
if [[ -e "/etc/pxnbackups.d/" ]]; then
	source  "/etc/pxnbackups.d/*.conf"  || exit 1
fi
doBackup



# ----------------------------------------
# finished



if [[ $QUIET -eq $NO ]]; then
	echo -e " ${COLOR_GREEN}===============================================${COLOR_RESET}"
fi
BACKUPS_FAILED=$NO
# unknown filter
FILTERED_NOT_FOUND=$NO
for FILTER in $BACKUP_FILTERS; do
	if [[ " $BACKUP_FILTERS_FOUND " != *" $FILTER "* ]]; then
		FILTERED_NOT_FOUND=$YES
		BACKUPS_FAILED=$YES
		warning "Backup not found: $FILTER"
	fi
done
# did nothing
if [[ $QUIET -eq $NO ]]; then
	if [[ $COUNT_ACT -le 0 ]]; then
		BACKUPS_FAILED=$YES
		warning "No actions performed"
	fi
fi
if [[ $BACKUPS_FAILED -eq $YES ]]; then
	warning
fi



echo -ne " ${COLOR_GREEN}Performed $COUNT_ACT backups"
[[ $COUNT_ACT -gt 1 ]] && echo -n "s"
[[ $COUNT_PRJ -gt 1 ]] && echo -ne " on $COUNT_PRJ backups"
echo -e "${COLOR_RESET}"

TIME_END=$(date +%s%N)
ELAPSED=$( echo "scale=3;($TIME_END - $TIME_START) / 1000 / 1000 / 1000" | \bc )
[[ "$ELAPSED" == "."* ]] && ELAPSED="0$ELAPSED"
echo -e " ${COLOR_GREEN}Finished in $ELAPSED seconds${COLOR_RESET}"
echo

if [[ $BACKUPS_FAILED -eq $YES ]]; then
	exit 1
fi
exit 0
