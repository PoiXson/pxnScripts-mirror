#!/usr/bin/bash
##===============================================================================
## Copyright (c) 2019 PoiXson, Mattsoft
## <https://poixson.com> <https://mattsoft.net>
## Released under the GPL 3.0
##
## Description: Script to build rpm's
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
# build-rpm.sh
clear



while [ $# -gt 0 ]; do
	case $1 in
	-n|--build-number)
		shift
		BUILD_NUMBER="$1"
	;;
	*)
		if [ ! -z $SPEC_NAME ]; then
			echo "Provide only one spec name to build."
			exit 1
		fi
		SPEC_NAME="$1"
	;;
	esac
	shift
done



if [ -z $SPEC_NAME ]; then
	SPEC_FILES_FOUND=$( \ls -1 *.spec )
	SPEC_FILES_COUNT=$( echo "$SPEC_FILES_FOUND" | wc -l )
	if [ $SPEC_FILES_COUNT -eq 1 ]; then
		SPEC_NAME="$SPEC_FILES_FOUND"
	fi
fi
if [ -z $SPEC_NAME ]; then
	echo "Provide the spec name to build."
	exit 1
fi
SPEC_NAME="${SPEC_NAME%%.*}"



# prepare build space
PWD=$(pwd)
if [ -d "$PWD/rpmbuild/" ]; then
	\rm -Rf --preserve-root "$PWD/rpmbuild/"  || exit 1
	echo
fi
\mkdir -p "$PWD"/rpmbuild/{BUILD,BUILDROOT,SOURCES,SPECS,RPMS,SRPMS,TMP}  || exit 1
#rpmdev-setuptree  || exit 1



\cp -fv  "$SPEC_NAME.spec"  "$PWD/rpmbuild/SPECS/"  || exit 1
echo



echo 'Building...'
\pushd "$PWD/rpmbuild/" || exit 1
	\rpmbuild \
		${BUILD_NUMBER:+ --define="build_number ${BUILD_NUMBER}"} \
		--define="_topdir $PWD" \
		--define="_tmppath $PWD/TMP" \
		-bb "SPECS/$SPEC_NAME.spec" \
			|| exit 1
\popd



echo;echo
echo "Success!"
\ls -lAsh "$PWD/rpmbuild/RPMS/" || exit 1
echo;echo
