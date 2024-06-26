#!/usr/bin/bash
##==============================================================================
## Copyright (c) 2013-2024 Mattsoft/PoiXson
## <https://mattsoft.net> <https://poixson.com>
## Released under the AGPL 3.0
##
## Description: Changes permissions of files and directories recursively.
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
# chmodr.sh


if [ $# -lt 3 ]; then
	echo
	echo "usage: $0 <dir perm> <file perm> <path>"
	echo
	echo "e.g. $0 0755 0644 ./"
	echo
	echo "sets dir perms to 0755 and file perms to 0644 recursively"
	echo
	exit 1
fi


DIRS_PERM="$1" ; shift
FILE_PERM="$1" ; shift
if [ $# -gt 1 ]; then sStr='s' ; fi
echo
echo "Path${sStr}: $@"
echo "Setting dirs to:  $DIRS_PERM"
echo "Setting files to: $FILE_PERM"
echo


function do_chmodr() {
pushd "$1" || exit 1
	ENTRIES=(`ls -RA | awk '/:$/&&f{s=$0;f=0}/:$/&&!f{sub(/:$/,"");s=$0;f=1;next}NF&&f{ print s"/"$0 }'`)
	MAX_LEN=0
	for ENTRY in "${ENTRIES[@]}"; do
		LEN=$( echo -n "$ENTRY" | wc -m )
		if [ $LEN -gt $MAX_LEN ]; then
			MAX_LEN=$LEN
		fi
	done
	for ENTRY in "${ENTRIES[@]}"; do
		if [ ! -z $ENTRY ]; then
			ENTRY_PAD=''
			LEN=$( echo -n "$ENTRY" | wc -m )
			PAD_LEN=$(( $MAX_LEN - $LEN ))
			if [ $PAD_LEN -gt 0 ]; then
				ENTRY_PAD=$(printf "%${PAD_LEN}s")
			fi
			if [ -h "$ENTRY" ]; then
				echo "S: $ENTRY"
			elif [ -d "$ENTRY" ]; then
				echo -n "D: ${ENTRY}${ENTRY_PAD}"
				echo -n "  "
				\chmod -c "$DIRS_PERM" "$ENTRY"
				echo -ne "\r"
			elif [ -f "$ENTRY" ]; then
				echo -n "F: ${ENTRY}${ENTRY_PAD}"
				echo -n "  "
				\chmod -c "$FILE_PERM" "$ENTRY"
				echo -ne "\r"
			else
				echo "UNKNOWN: $ENTRY"
				echo "HALTING!"
				exit 1
			fi
		fi
	done
popd
}


for P in "$@"; do
	do_chmodr $P
done


echo
echo "Finished!"
echo
