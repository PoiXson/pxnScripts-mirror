#!/bin/bash


#\php check_tab_indent.php || exit 1


function DisplayHelp() {
	echo "Usage:"
	echo "  workspace [options] <workspace-groups>"
	echo
	echo "Options:"
	echo "  -a, --all                      Use all .dev files found"
	echo "  -c, --cleanup                  Cleanup workspace; delete generated files"
	echo "  -p, --pp, --pull-push          Run 'git pull' and 'git push'"
	echo "  -g, --gg, --git-gui            Open git-gui for each workspace repository"
	echo "  --ci, --composer-install       Run 'composer install' on each workspace repository"
	echo "  --cu, --composer-update        Run 'composer update' on each workspace repository"
	echo "  --rpm, --build-rpm             Run 'build-rpm' on each workspace repository"
	echo
	echo "  -C, --no-clear                 Don't clear the screen before doing work"
}


YES=1
NO=0
NO_CLEAR=$NO
ENABLE_C=$NO
ENABLE_PP=$NO
ENABLE_GG=$NO
ENABLE_CI=$NO
ENABLE_CU=$NO
ENABLE_RPM=$NO
while [ $# -gt 0 ]; do
	case "$1" in
	# all workspaces
	-a|--all)
		devs=($( ls -1v *.dev ))
	;;
	# cleanup
	-c|--clean|--cleanup)
		ENABLE_C=$YES
	;;
	# git pull/push
	-p|--pp|--pull-push|--push-pull)
		ENABLE_PP=$YES
	;;
	# git-gui
	-g|--gg|--git-gui)
		ENABLE_GG=$YES
	;;
	# composer install
	--ci|--composer-install)
		ENABLE_CI=$YES
	;;
	# composer update
	--cu|--composer-update)
		ENABLE_CU=$YES
	;;
	# build rpm
	--rpm|--build-rpm|--rpm-build)
		ENABLE_RPM=$YES
	;;
	# don't clear screen
	-C|--no-clear)
		NO_CLEAR=$YES
	;;
	-h|--help)
		if [ $NO_CLEAR -ne $YES ]; then
			\clear
		fi
		DisplayHelp
		exit 1
	;;
	-*)
		echo "Unknown argument: $1"
		exit 1
	;;
	*)
		devs=( "${devs[@]}" "$1" )
	;;
	esac
	shift
done


if [ $NO_CLEAR -ne $YES ]; then
	\clear
fi


if [[ -z $devs ]]; then
	echo
	echo "You must select a .dev group file"
	echo
	DisplayHelp
	exit 1
fi


# no options selected
if	[[ $ENABLE_C   -ne $YES ]] && \
	[[ $ENABLE_PP  -ne $YES ]] && \
	[[ $ENABLE_GG  -ne $YES ]] && \
	[[ $ENABLE_CI  -ne $YES ]] && \
	[[ $ENABLE_CU  -ne $YES ]] && \
	[[ $ENABLE_RPM -ne $YES ]]; then
		echo
		echo "No options selected"
		echo
		DisplayHelp
		exit 1
fi


# .gitconfig file
if [ -f "./.gitconfig" ]; then
	\cp -fv "./.gitconfig" ~/ || exit 1
fi


function title() {
	MAX_SIZE=1
	for ARG in "$@"; do
		local _S=${#ARG}
		if [ $_S -gt $MAX_SIZE ]; then
			MAX_SIZE=$_S
		fi
	done
	local _A=$(($MAX_SIZE+4))
	echo
	echo -n " +"; eval "printf %.0s'-' {1..$_A}"; echo "+ "
	for LINE in "${@}"; do
		local _S=$(($MAX_SIZE-${#LINE}))
		echo -n " |  ${LINE}"; eval "printf ' '%.0s {0..$_S}"; echo " | "
	done
	echo -n " +"; eval "printf %.0s'-' {1..$_A}"; echo "+ "
}


function Workspace() {
	if [ ! -z $WS_NAME ]; then
		doWorkspace
	fi
	if [ ! -z $1 ]; then
		WS_NAME="$1"
	fi
}
function doWorkspace() {
	if [ -z $WS_NAME ]; then
		return
	fi
	title "$WS_NAME"
	# cleanup
	if [ $ENABLE_C -eq $YES ]; then
		if [ -d "$WS_NAME/" ]; then
			pushd "$WS_NAME/" || exit 1
				if [ -d "vendor/" ]; then
					rm -Rvf --preserve-root "vendor"    || exit 1
					sleep 0.2
					echo
				fi
				if [ -d "rpmbuild/" ]; then
					rm -Rvf --preserve-root "rpmbuild"  || exit 1
					sleep 0.2
					echo
				fi
				if [ -d "coverage/" ]; then
					rm -Rvf --preserve-root "coverage"  || exit 1
					sleep 0.2
					echo
				fi
			popd
			sleep 0.2
		else
			echo " > bypass - workspace not found"
		fi
	fi
	# git pull/push
	if [ $ENABLE_PP -eq $YES ]; then
		if [ -d "$WS_NAME" ]; then
			pushd "$WS_NAME/" || exit 1
				echo
				echo " > Pulling repo.."
				git pull || exit 1
				echo
				echo " > Pushing repo.."
				git push || exit 1
				echo
			popd
		elif [ ! -z $WS_VCS ]; then
			echo
			echo " > Cloning repo.."
			git clone "$WS_VCS" "$WS_NAME" || exit 1
			echo
		else
			echo " > bypass - git not found"
		fi
	fi
	# update static files
	if [[ -f "./.gitignore" ]]; then
		cp "./.gitignore" "$WS_NAME/" || exit 1
		if [ -f "./.gitattributes" ]; then
			cp "./.gitattributes" "$WS_NAME/" || exit 1
		fi
	fi
	if [ -f "./phpunit.xml" ]; then
		if [ -f "$WS_NAME/phpunit.xml" ]; then
			cp "./phpunit.xml" "$WS_NAME/" || exit 1
		fi
	fi
	# composer
	if [[ $ENABLE_CI -eq $YES ]] || [[ $ENABLE_CU -eq $YES ]]; then
		if [ -f "$WS_NAME/composer.json" ]; then
			# composer install
			if [ $ENABLE_CI -eq $YES ]; then
				pushd "$WS_NAME/" || exit 1
					echo
					composer install || exit 1
					echo
				popd
			fi
			# composer update
			if [ $ENABLE_CU -eq $YES ]; then
				pushd "$WS_NAME/" || exit 1
					echo
					composer update || exit 1
					echo
				popd
			fi
		else
			echo " > bypass - composer not found"
		fi
	fi
	# build-rpm
	if [ $ENABLE_RPM -eq $YES ];then
		if [ -f "$WS_NAME/"*.spec ]; then
			pushd "$WS_NAME/" || exit 1
				echo
				build-rpm || exit 1
				echo
			popd
			if [ ! -d rpms/ ]; then
				mkdir -pv rpms/ || exit 1
			fi
			cp "$WS_NAME/rpmbuild/RPMS/"*.rpm rpms/ || exit 1
		else
			echo " > bypass - .spec not found"
		fi
	fi
	# git-gui
	if [ $ENABLE_GG -eq $YES ]; then
		if [ -d "$WS_NAME/.git/" ]; then
			pushd "$WS_NAME" || exit 1
				/usr/libexec/git-core/git-gui &
				sleep 0.2
			popd
		fi
	fi
	# cleanup vars
	WorkspaceCleanup
}
function WorkspaceCleanup() {
	# reset workspace vars
	WS_NAME=""
	WS_VCS=""
	sleep 0.4
	echo
}


function devSource() {
	WorkspaceCleanup
	dev="$1"
	if [[ ! -f "$dev" ]]; then
		echo "File not found: $dev"
		exit 1
	fi
	source "./$dev" || exit 1
	Workspace
}
for dev in ${devs[@]}; do
	if [ -f "$dev" ]; then
		devSource "$dev"
	elif [ -f "${dev}.dev" ]; then
		devSource "${dev}.dev"
	elif [ -f *"${dev}.dev" ]; then
		dev=$( ls -1v *"${dev}.dev" | head -n1 )
		devSource "$dev"
	else
		echo "Dev file not found: $dev"
		exit 1
	fi
done


echo
echo -e "\nFinished!\n"
exit 0
