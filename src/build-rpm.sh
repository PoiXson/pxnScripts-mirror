#!/bin/sh
clear


SPEC_NAME="$1"
if [ -z $SPEC_NAME ]; then
	echo "Provide the spec name to build."
	exit 1
fi
build_number="$2"



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
		${build_number:+ --define="build_number ${build_number}"} \
		--define="_topdir $PWD" \
		--define="_tmppath $PWD/TMP" \
		-bb "SPECS/$SPEC_NAME.spec" \
			|| exit 1
\popd



echo;echo
echo "Success!"
\ls -lAsh "$PWD/rpmbuild/RPMS/" || exit 1
echo;echo
