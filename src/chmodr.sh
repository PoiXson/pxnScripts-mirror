#!/usr/bin/bash
## ================================================================================
## Copyright (c) 2013-2025 Mattsoft/PoiXson
## <https://mattsoft.net> <https://poixson.com>
## Released under the AGPL 3.0 + ADD-PXN-V1
##
## Description: Changes permissions of files and directories recursively.
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
