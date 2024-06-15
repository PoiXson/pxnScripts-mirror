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
