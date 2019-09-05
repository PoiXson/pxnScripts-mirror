Name    : shellscripts
Version : 1.5.%{!?build_number:x}
Release : 1
Summary : A collection of commonly used shell scripts
Group   : Base System/System Tools

Requires  : perl, bash, screen, wget, rsync, zip, unzip, grep, tree, dialog, net-tools, dos2unix
Conflicts : shellscripts-dev

BuildArch : noarch
Packager  : PoiXson <support@poixson.com>
License   : GPL 3.0
URL       : https://poixson.com/

Prefix: %{_bindir}/shellscripts
%define _rpmfilename  %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm



%package dev
Summary : A collection of commonly used shell scripts (development)
Conflicts: shellscripts



%description
A collection of commonly used shell scripts for CentOS and Fedora.

%description dev
A collection of commonly used shell scripts for CentOS and Fedora. (development)



### Prep ###
%prep



### Build ###
%build



### Install ###
%install
echo
echo "Install.."
# delete existing rpm's
%{__rm} -fv "%{_rpmdir}/%{name}-"*.rpm
# create directories
%{__install} -d -m 0755 \
	"%{buildroot}%{prefix}/"  \
	"%{buildroot}%{_sysconfdir}/profile.d/"  \
		|| exit 1
# copy files
\pushd "%{_topdir}/../" || exit 1
	%{__install} -m 0555  src/*.sh  "%{buildroot}%{prefix}/"  || exit 1
	%{__install} -m 0555  src/iptop.pl  "%{buildroot}%{prefix}/"  || exit 1
	%{__rm} -fv "%{buildroot}%{prefix}/install-zfs.sh"
\popd


### Check ###
%check



### Clean ###
%clean



### post install ###
%post
# create symlinks
for SCRIPT_FILE in \
	build-rpm       \
	chmodr          \
	chownr          \
	forever         \
	ethtop          \
	mklinkrel       \
	monitorhost     \
	pingssh         \
	progresspercent \
	sshkeygen       \
	timestamp       \
	yesno           \
	; do
		%{__ln_s} -f \
			"%{prefix}/$SCRIPT_FILE.sh" \
			"%{_bindir}/$SCRIPT_FILE"
done
%{__ln_s} -f \
	"%{prefix}/iptop.pl" \
	"%{_bindir}/iptop"
# create profile.d symlink
%{__ln_s} -f \
	"%{prefix}/profile.sh" \
	"%{buildroot}%{_sysconfdir}/profile.d/pxn-profile.sh"



### post uninstall ###
%postun
# remove symlinks
for SCRIPT_FILE in \
	build-rpm       \
	chmodr          \
	chownr          \
	forever         \
	iptop           \
	ethtop          \
	mklinkrel       \
	monitorhost     \
	pingssh         \
	progresspercent \
	sshkeygen       \
	timestamp       \
	yesno           \
	; do
		[ -h "%{_bindir}/$SCRIPT_FILE" ] \
			&& %__rm -f  "%{_bindir}/$SCRIPT_FILE"
done
# remove profile.d symlink
[ -h "%{_sysconfdir}/profile.d/pxn-profile.sh" ] \
	&& %__rm -f  "%{_sysconfdir}/profile.d/pxn-profile.sh"



### Files ###
%files
%defattr(-,root,root,-)
%{prefix}/aliases.sh
%{prefix}/build-rpm.sh
%{prefix}/chmodr.sh
%{prefix}/chownr.sh
%{prefix}/common.sh
%{prefix}/ethtop.sh
%{prefix}/forever.sh
%{prefix}/iptop.pl
%{prefix}/mklinkrel.sh
%{prefix}/monitorhost.sh
%{prefix}/pingssh.sh
%{prefix}/profile.sh
%{prefix}/progresspercent.sh
%{prefix}/sshkeygen.sh
%{prefix}/timestamp.sh
%{prefix}/yesno.sh

%files dev
%defattr(-,root,root,-)
