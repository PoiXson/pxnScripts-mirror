Name    : pxn-scripts
Summary : A collection of commonly used shell scripts
Version : 2.1.%{?build_number}%{!?build_number:x}
Release : 1

Requires   : bash, wget, curl, rsync, grep
Requires   : zip, unzip, tar, gzip
Recommends : pxn-aliases, screen
Provides   : pxnscripts

BuildArch : noarch
Packager  : PoiXson <support@poixson.com>
License   : AGPLv3
URL       : https://poixson.com/

Prefix: %{_bindir}/pxn/scripts
%define _rpmfilename  %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm



%package -n pxn-tools
Summary  : Common useful tools.
Requires : pxn-scripts, pxn-aliases, pingssh
Provides : pxntools

%package -n pxn-aliases
Summary  : Helpful aliases for common shell commands.
Provides : pxnaliases

%package -n pingssh
Summary  : Pings a remote host until it's able to connect with ssh.
Provides : ping-ssh
Provides : pssh, pingssh



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
	%{__install} -m 0644  "pingssh.sh"    "%{buildroot}%{_bindir}/pingssh"    || exit 1
	%{__install} -m 0644  "sshkeygen.sh"  "%{buildroot}%{_bindir}/sshkeygen"  || exit 1
	%{__install} -m 0644  "pxnbackup.sh"  "%{buildroot}%{_bindir}/pxnbackup"  || exit 1
	# /usr/bin/pxn/scripts/
	%{__install} -m 0644  \
		"common.sh"   \
		"aliases.sh"  \
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
	%{__install} -m 0644  "pxn-aliases.sh"  "%{buildroot}%{_sysconfdir}/profile.d/pxnaliases.sh"  || exit 1
	%{__install} -m 0644  "pingssh.sh"      "%{buildroot}%{_sysconfdir}/profile.d/pingssh.sh"     || exit 1
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

%post -n pxn-tools
[ -e /usr/bin/htop         ] || \dnf install -y  htop
[ -e /usr/bin/nmon         ] || \dnf install -y  nmon
[ -e /usr/sbin/iotop-c     ] || \dnf install -y  iotop-c
[ -e /usr/bin/tree         ] || \dnf install -y  tree
[ -e /usr/bin/colordiff    ] || \dnf install -y  colordiff
[ -e /usr/bin/hexedit      ] || \dnf install -y  hexedit
[ -e /usr/bin/inotifywatch ] || \dnf install -y  inotify-tools
[ -e /usr/bin/calc         ] || \dnf install -y  calc
[ -e /usr/bin/trash        ] || \dnf install -y  trash-cli
[ -e /usr/bin/ncdu         ] || \dnf install -y  ncdu
[ -e /usr/bin/tldr         ] || \dnf install -y  tldr



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
