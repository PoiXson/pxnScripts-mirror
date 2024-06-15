Name    : pxn-scripts
Summary : A collection of commonly used shell scripts
Version : 2.1.%{?build_number}%{!?build_number:x}
Release : 1
BuildArch : noarch
Prefix: %{_bindir}/pxn/scripts
%define _rpmfilename  %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm

License  : AGPLv3
Packager : PoiXson <support@poixson.com>
URL      : https://poixson.com/

Requires : bash, wget, curl, rsync, zip, unzip, grep
Recommends: pxn-aliases, screen
Provides : pxnscripts
Obsoletes: pxnscripts
Obsoletes: shellscripts



%package -n pxn-tools
Summary  : Common useful tools.
Requires : pxn-scripts, pxn-aliases, pingssh, calc
Requires : trash-cli, ncdu, tldr, colordiff, inotify-tools
Requires : htop, nmon, iotop-c, tree, htop, nmon, hexedit
Provides : pxntools

%package -n pxn-aliases
Summary  : Helpful aliases for common shell commands.
Provides : pxnaliases
Obsoletes: pxnaliases

%package -n pingssh
Summary  : Pings a remote host until it's able to connect with ssh.
Provides : ping-ssh
Provides : pssh



%description
A collection of commonly used shell scripts for CentOS and Fedora.

%description -n pxn-tools
Common useful tools.

%description -n pxn-aliases
Helpful aliases for common shell commands.

%description -n pingssh
Pings a remote host until it's able to connect with ssh.



### Install ###
%install
echo
echo "Install.."

# create dirs
%{__install} -d -m 0755  \
	"%{buildroot}%{prefix}/"                 \
	"%{buildroot}%{_sysconfdir}/profile.d/"  \
		|| exit 1

\pushd  "%{_topdir}/../src/"  >/dev/null  || exit 1
	# /usr/bin/
	%{__install} -m 0644  "chmodr.sh"     "%{buildroot}%{_bindir}/chmodr"     || exit 1
	%{__install} -m 0644  "chownr.sh"     "%{buildroot}%{_bindir}/chownr"     || exit 1
	%{__install} -m 0644  "ethtop.sh"     "%{buildroot}%{_bindir}/ethtop"     || exit 1
	%{__install} -m 0644  "mklinkrel.sh"  "%{buildroot}%{_bindir}/mklinkrel"  || exit 1
	%{__install} -m 0644  "monhost.sh"    "%{buildroot}%{_bindir}/monhost"    || exit 1
	%{__install} -m 0644  "timestamp.sh"  "%{buildroot}%{_bindir}/timestamp"  || exit 1
	%{__install} -m 0644  "yesno.sh"      "%{buildroot}%{_bindir}/yesno"      || exit 1
	%{__install} -m 0644  "pingssh.sh"    "%{buildroot}%{_bindir}/pingssh"    || exit 1
	%{__install} -m 0644  "sshkeygen.sh"  "%{buildroot}%{_bindir}/sshkeygen"  || exit 1
	# /usr/bin/pxn/scripts/
	%{__install} -m 0644  \
		"common.sh"   \
		"aliases.sh"  \
		"colors.sh"   \
		"defines.sh"  \
			"%{buildroot}%{prefix}/"  || exit 1
\popd  >/dev/null
# /etc/profile.d/
\pushd  "%{_topdir}/../src/profile.d/"  >/dev/null  || exit 1
	%{__install} -m 0644  "pxn-scripts.sh"  "%{buildroot}%{_sysconfdir}/profile.d/pxnscripts.sh"  || exit 1
	%{__install} -m 0644  "pxn-aliases.sh"  "%{buildroot}%{_sysconfdir}/profile.d/pxnaliases.sh"  || exit 1
	%{__install} -m 0644  "pingssh.sh"      "%{buildroot}%{_sysconfdir}/profile.d/pingssh.sh"     || exit 1
\popd  >/dev/null



%post
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
%{_sysconfdir}/profile.d/pxnscripts.sh

%files -n pxn-tools

%files -n pxn-aliases
%defattr(0555, root, root, 0755)
%{prefix}/aliases.sh
%{_sysconfdir}/profile.d/pxnaliases.sh

%files -n pingssh
%defattr(0555, root, root, 0755)
%{_bindir}/pingssh
%{_bindir}/sshkeygen
%{_sysconfdir}/profile.d/pingssh.sh
