##===============================================================================
## Copyright (c) 2013-2014 PoiXson, Mattsoft
## <http://poixson.com> <http://mattsoft.net>
##
## Description: Common methods and utilities for git workspace scripts.
##
## Install to location: /usr/local/bin/pxn
##
## Download the original from:
##   http://dl.poixson.com/scripts/
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
##===============================================================================
# workspace_utils.sh



# load common utils script
if [ -e common.sh ]; then
	source ./pxn_common.sh
elif [ -e /usr/local/bin/pxn/common.sh ]; then
	source /usr/local/bin/pxn/common.sh
else
	wget https://raw.githubusercontent.com/PoiXson/shellscripts/master/pxn/common.sh \
		|| exit 1
	source ./common.sh
fi
# download mklinkrel.sh
if [ ! -e mklinkrel.sh ] && [ ! -f /usr/local/bin/pxn/mklinkrel.sh ]; then
	wget https://raw.githubusercontent.com/PoiXson/shellscripts/master/pxn/mklinkrel.sh \
		|| exit 1
fi
# load yesno.sh
if [ -e yesno.sh ]; then
	source ./yesno.sh
elif [ -e /usr/local/bin/pxn/yesno.sh ]; then
	source /usr/local/bin/pxn/yesno.sh
else
	wget https://raw.githubusercontent.com/PoiXson/shellscripts/master/pxn/yesno.sh \
		|| exit 1
	source ./yesno.sh
fi






# parse arguments
for i in "$@"; do
	case $i in
	--https)
		answerHttpsSsh="h"
	;;
	--ssh)
		answerHttpsSsh="s"
	;;
	--user=*)
		GITHUB_USER="${i#*=}"
	;;
	--user)
		GITHUB_USER="PoiXson"
	;;
	*)
		echo "Unknown argument: ${i}"
		exit 1
	;;
	esac
done



GIT_PREFIX_HTTPS='https://github.com/'
GIT_PREFIX_SSH='git@github.com:'

# ask use https/ssh for cloning
while true; do
	if [ ! -z "${answerHttpsSsh}" ]; then
		case $answerHttpsSsh in
			[Hh]* ) REPO_PREFIX="${GIT_PREFIX_HTTPS}"; break;;
			[Ss]* ) REPO_PREFIX="${GIT_PREFIX_SSH}";   break;;
			* ) echo "Please answer H or S";;
		esac
	fi
	newline
	echo "https: read only access"
	echo "ssh:   read/write access (permission required)"
	read -p "Would you like to clone with [h]ttps or [s]sh ? " answerHttpsSsh
	newline
done
echo "Using repo prefix: ${REPO_PREFIX}"
newline



# ask github user
if [ -z "${GITHUB_USER}" ]; then
	newline
	read -p "Which github account should be used? [default: PoiXson] " answer
	newline
	if [ -z "${answer}" ]; then
		GITHUB_USER="PoiXson"
	else
		GITHUB_USER="${answer}"
	fi
fi
echo "Using github user: ${GITHUB_USER}"
newline

REPO_PREFIX="${REPO_PREFIX}${GITHUB_USER}"



# CheckoutRepo <dir_name> <repo_url>
function CheckoutRepo() {
	if [ ! -d ".git" ]; then
		mkdir -v .git
	fi
	if [ -d "$1" ] || [ -h "$1" ]; then
		echo "${1} repo already exists in workspace."
		(cd "${1}" && git pull origin master) \
			|| return 1
		newline
		return 0
	fi
	newline
	echo "Cloning ${1} repo.."
	git clone "${2}" "${1}" \
		|| return 1
	git config core.filemode false --git-dir="${1}"
	git config core.symlinks false --git-dir="${1}"
	newline
	return 0
}



function AskResources() {
	if [ "$1" == "--https" ] || [ "$1" == "--ssh" ] ||
			yesno "Would you like to download the required resources? [y/N] " --default no ; then
		if [ ! -d resources ]; then
			newline
			mkdir -v resources
		fi
		return $YES
	fi
	return $NO
}
function getResource() {
	title=$1
	filename=$2
	url=$3
	if [ -f "${filename}" ]; then
		return 0
	fi
	echo "Downloading ${title}.."
	wget -O "${filename}" "${url}"
	if [ ! -f "$filename" ]; then
		echoerr "Failed to download resource ${url}"
		return 1
	fi
	return 0
}
function unzipResource() {
	dir=$1
	filename=$2
	currentdir=`pwd`
	path="${currentdir}/${dir}${filename}"
	if ls "${path}" &> /dev/null; then
#	if [ ! -f "${path}" ]; then
		echoerr "Cannot unzip, missing file ${path}"
		return 1
	fi
	cd $dir
	unzip -o "${path}"
	cd "${currentdir}"
	return 0
}

