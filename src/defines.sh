##==============================================================================
## Copyright (c) 2013-2022 PoiXson, Mattsoft
## <https://poixson.com> <https://mattsoft.net>
## Released under the GPL 3.0
##
## Description: Common methods and utilities for pxn shell scripts.
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
# defines.sh



export YES=0
export NO=1



function enable_colors() {
	COLOR_BLACK='\e[0;30m'
	COLOR_BLUE='\e[0;34m'
	COLOR_GREEN='\e[0;32m'
	COLOR_CYAN='\e[0;36m'
	COLOR_RED='\e[0;31m'
	COLOR_PURPLE='\e[0;35m'
	COLOR_BROWN='\e[0;33m'
	COLOR_LIGHTGRAY='\e[0;37m'
	COLOR_DARKGRAY='\e[1;30m'
	COLOR_LIGHTBLUE='\e[1;34m'
	COLOR_LIGHTGREEN='\e[1;32m'
	COLOR_LIGHTCYAN='\e[1;36m'
	COLOR_LIGHTRED='\e[1;31m'
	COLOR_LIGHTPURPLE='\e[1;35m'
	COLOR_YELLOW='\e[1;33m'
	COLOR_WHITE='\e[1;37m'
	COLOR_RESET='\e[0m'
}
function disable_colors() {
	COLOR_BLACK=''
	COLOR_BLUE=''
	COLOR_GREEN=''
	COLOR_CYAN=''
	COLOR_RED=''
	COLOR_PURPLE=''
	COLOR_BROWN=''
	COLOR_LIGHTGRAY=''
	COLOR_DARKGRAY=''
	COLOR_LIGHTBLUE=''
	COLOR_LIGHTGREEN=''
	COLOR_LIGHTCYAN=''
	COLOR_LIGHTRED=''
	COLOR_LIGHTPURPLE=''
	COLOR_YELLOW=''
	COLOR_WHITE=''
	COLOR_RESET=''
}



if [[ -z $NO_COLORS ]] || [[ $NO_COLORS -ne $YES ]]; then
	NUM_COLORS=$( tput colors 2>/dev/null )
else
	NUM_COLORS=0
fi
if [[ $NUM_COLORS == ?(-)+([0-9]) ]] \
&& [[ $NUM_COLORS -ge 8 ]]; then
	enable_colors
else
	disable_colors
fi
