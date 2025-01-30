Name      : pxn-scripts
Summary   : A collection of commonly used shell scripts
Version   : 2.2.%{?build_number}%{!?build_number:x}
Release   : 1
BuildArch : noarch
Packager  : PoiXson <support@poixson.com>
License   : AGPLv3+ADD-PXN-V1
URL       : https://poixson.com/

Requires  : bash, wget, curl, rsync, grep
Requires  : zip, unzip, tar, gzip
Recommends: pxn-aliases, screen
Provides  : pxnscripts

Prefix: %{_bindir}/pxn/scripts
%define _rpmfilename  %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm
%global source_date_epoch_from_changelog 0
%define source_date_epoch 0

%description
A collection of commonly used shell scripts for RHEL-based distros.



### Install ###
%install
echo
echo "Install.."

# create dirs
%{__install} -d -m 0755  \
	"%{buildroot}%{_bindir}/"                \
	"%{buildroot}%{prefix}/"                 \
	"%{buildroot}%{_sysconfdir}/profile.d/"  \
		|| exit 1

# scripts
\pushd  "%{_topdir}/../src/"  >/dev/null  || exit 1
	# /usr/bin/
	%{__install} -m 0644  "chmodr.sh"     "%{buildroot}%{_bindir}/chmodr"     || exit 1
	%{__install} -m 0644  "chownr.sh"     "%{buildroot}%{_bindir}/chownr"     || exit 1
	%{__install} -m 0644  "ethtop.sh"     "%{buildroot}%{_bindir}/ethtop"     || exit 1
	%{__install} -m 0644  "mklinkrel.sh"  "%{buildroot}%{_bindir}/mklinkrel"  || exit 1
	%{__install} -m 0644  "monhost.sh"    "%{buildroot}%{_bindir}/monhost"    || exit 1
	%{__install} -m 0644  "timestamp.sh"  "%{buildroot}%{_bindir}/timestamp"  || exit 1
	%{__install} -m 0644  "yesno.sh"      "%{buildroot}%{_bindir}/yesno"      || exit 1
	%{__install} -m 0644  "pxnbackup.sh"  "%{buildroot}%{_bindir}/pxnbackup"  || exit 1
	# /usr/bin/pxn/scripts/
	%{__install} -m 0644  \
		"common.sh"   \
		"colors.sh"   \
		"defines.sh"  \
			"%{buildroot}%{prefix}/"  || exit 1
\popd  >/dev/null

# pxnbackups.conf
\pushd  "%{_topdir}/../"  >/dev/null  || exit 1
	%{__install} -m 0644  "pxnbackups.conf.example"  "%{buildroot}%{_sysconfdir}/"
\popd  >/dev/null

# /etc/profile.d/
\pushd  "%{_topdir}/../src/profile.d/"  >/dev/null  || exit 1
	%{__install} -m 0644  "pxn-scripts.sh"  "%{buildroot}%{_sysconfdir}/profile.d/pxnscripts.sh"  || exit 1
\popd  >/dev/null

# ps-mem.py
# https://github.com/pixelb/ps_mem/blob/v3.14/ps_mem.py
\wget  "https://raw.githubusercontent.com/pixelb/ps_mem/v3.14/ps_mem.py" \
	-O "%{buildroot}%{_bindir}/ps-mem"  || exit 1



%post
if [[ ! -e /usr/bin/python ]]; then
	\ln -sv  /usr/bin/python3 /usr/bin/python  || exit 1
fi
if [[ -e "/usr/lib/jvm/" ]]; then
	if [[ ! -e "/usr/lib/jvm/java-latest" ]]; then
		\pushd  "/usr/lib/jvm/"  >/dev/null  || exit 1
			\ln -svf  /etc/alternatives/jre  java-latest  || exit 1
		\popd  >/dev/null
	fi
fi



### Files ###
%files
%defattr(0555, root, root, 0755)
%dir %{prefix}/
# scripts
%{prefix}/common.sh
%{prefix}/colors.sh
%{prefix}/defines.sh
%{_bindir}/chmodr
%{_bindir}/chownr
%{_bindir}/ethtop
%{_bindir}/mklinkrel
%{_bindir}/monhost
%{_bindir}/timestamp
%{_bindir}/yesno
%{_bindir}/pxnbackup
# pxnbackups.conf
%attr(0600,-,-) %{_sysconfdir}/pxnbackups.conf.example
# profile.d
%{_sysconfdir}/profile.d/pxnscripts.sh
# ps-mem.py
%{_bindir}/ps-mem
