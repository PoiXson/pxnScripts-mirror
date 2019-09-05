#!/bin/bash
##===============================================================================
## Copyright (c) 2013-2019 PoiXson, Mattsoft
## <https://poixson.com> <https://mattsoft.net>
## Released under the GPL 3.0
##
## Description: Changes owner/group ownership of files and directories recursively.
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
## =============================================================================
# chownr.sh


if [ $# -ne 3 ]; then
	echo
	echo "usage: $0 <dir o:g> <file o:g> <path>"
	echo
	echo "e.g. $0 user:wheel user:wheel ./"
	echo
	echo "sets dir owner/group to user:wheel as well as for files, recursively"
	echo
	exit 1
fi
echo
echo "Path: $3"
echo "Setting dirs to:  $1"
echo "Setting files to: $2"
echo
pushd "$3" || exit 1
	ENTRIES=(`ls -RA | awk '/:$/&&f{s=$0;f=0}/:$/&&!f{sub(/:$/,"");s=$0;f=1;next}NF&&f{ print s"/"$0 }'`)
	for ENTRY in "${ENTRIES[@]}"; do
		if [ ! -z $ENTRY ]; then
			if [ -h "$ENTRY" ]; then
				echo "S: $ENTRY"
			elif [ -d "$ENTRY" ]; then
				echo "D: $ENTRY"
				echo -n "  "
				chown -c "$1" "$ENTRY"
				echo -ne "\r"
			elif [ -f "$ENTRY" ]; then
				echo "F: $ENTRY"
				echo -n "  "
				chown -c "$2" "$ENTRY"
				echo -ne "\r"
			else
				echo "UNKNOWN: $ENTRY"
				echo "HALTING!"
				exit 1
			fi
		fi
	done
popd
echo
echo "Finished!"
echo
