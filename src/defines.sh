## ================================================================================
## Copyright (c) 2013-2025 Mattsoft/PoiXson
## <https://mattsoft.net> <https://poixson.com>
## Released under the AGPL 3.0 + ADD-PXN-V1
##
## Description: Common methods and utilities for pxn shell scripts.
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
# defines.sh



export YES=0
export NO=1



function enable_colors() {
	export COLOR_BLACK='\e[0;30m'
	export COLOR_BLUE='\e[0;34m'
	export COLOR_GREEN='\e[0;32m'
	export COLOR_CYAN='\e[0;36m'
	export COLOR_RED='\e[0;31m'
	export COLOR_PURPLE='\e[0;35m'
	export COLOR_BROWN='\e[0;33m'
	export COLOR_LIGHTGRAY='\e[0;37m'
	export COLOR_DARKGRAY='\e[1;30m'
	export COLOR_LIGHTBLUE='\e[1;34m'
	export COLOR_LIGHTGREEN='\e[1;32m'
	export COLOR_LIGHTCYAN='\e[1;36m'
	export COLOR_LIGHTRED='\e[1;31m'
	export COLOR_LIGHTPURPLE='\e[1;35m'
	export COLOR_YELLOW='\e[1;33m'
	export COLOR_WHITE='\e[1;37m'
	export COLOR_RESET='\e[0m'
}
function disable_colors() {
	export COLOR_BLACK=''
	export COLOR_BLUE=''
	export COLOR_GREEN=''
	export COLOR_CYAN=''
	export COLOR_RED=''
	export COLOR_PURPLE=''
	export COLOR_BROWN=''
	export COLOR_LIGHTGRAY=''
	export COLOR_DARKGRAY=''
	export COLOR_LIGHTBLUE=''
	export COLOR_LIGHTGREEN=''
	export COLOR_LIGHTCYAN=''
	export COLOR_LIGHTRED=''
	export COLOR_LIGHTPURPLE=''
	export COLOR_YELLOW=''
	export COLOR_WHITE=''
	export COLOR_RESET=''
}



if [[ -z $NO_COLORS ]] || [[ $NO_COLORS -ne $YES ]]; then
	export NUM_COLORS=$( tput colors 2>/dev/null )
else
	export NUM_COLORS=0
fi
if [[ $NUM_COLORS == ?(-)+([0-9]) ]] \
&& [[ $NUM_COLORS -ge 8 ]]; then
	enable_colors
else
	disable_colors
fi
