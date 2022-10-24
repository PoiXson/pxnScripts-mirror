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

Requires : bash, screen, wget, curl, rsync, zip, unzip, grep
Requires : pxn-aliases
Provides : pxnscripts
Obsoletes: shellscripts



%package -n pxn-tools
Summary  : Common useful tools.
Requires : pxnscripts, pxnaliases, pingssh
Requires : trash-cli, ncdu, tldr, colordiff
Requires : htop, nmon, iotop-c, autojump, tree, htop, nmon, hexedit
Provides : pxntools

%package -n pxn-aliases
Summary  : Helpful aliases for common shell commands.
Provides : pxnaliases

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

# /usr/bin/
%{__install} -m 0644  "%{_topdir}/../src/chmodr.sh"     "%{buildroot}%{_bindir}/chmodr"     || exit 1
%{__install} -m 0644  "%{_topdir}/../src/chownr.sh"     "%{buildroot}%{_bindir}/chownr"     || exit 1
%{__install} -m 0644  "%{_topdir}/../src/ethtop.sh"     "%{buildroot}%{_bindir}/ethtop"     || exit 1
%{__install} -m 0644  "%{_topdir}/../src/mklinkrel.sh"  "%{buildroot}%{_bindir}/mklinkrel"  || exit 1
%{__install} -m 0644  "%{_topdir}/../src/monhost.sh"    "%{buildroot}%{_bindir}/monhost"    || exit 1
%{__install} -m 0644  "%{_topdir}/../src/timestamp.sh"  "%{buildroot}%{_bindir}/timestamp"  || exit 1
%{__install} -m 0644  "%{_topdir}/../src/yesno.sh"      "%{buildroot}%{_bindir}/yesno"      || exit 1
%{__install} -m 0644  "%{_topdir}/../src/pingssh.sh"    "%{buildroot}%{_bindir}/pingssh"    || exit 1
%{__install} -m 0644  "%{_topdir}/../src/sshkeygen.sh"  "%{buildroot}%{_bindir}/sshkeygen"  || exit 1
# /usr/bin/pxn/scripts/
%{__install} -m 0644  \
	"%{_topdir}/../src/common.sh"   \
	"%{_topdir}/../src/aliases.sh"  \
	"%{_topdir}/../src/colors.sh"   \
	"%{_topdir}/../src/defines.sh"  \
		"%{buildroot}%{prefix}/"  || exit 1
# /etc/profile.d/
%{__install} -m 0644  \
	"%{_topdir}/../src/etc-profile.d-pxnscripts.sh"  \
	"%{buildroot}%{_sysconfdir}/profile.d/pxnscripts.sh"  || exit 1
%{__install} -m 0644  \
	"%{_topdir}/../src/etc-profile.d-pxnaliases.sh"  \
	"%{buildroot}%{_sysconfdir}/profile.d/pxnaliases.sh"  || exit 1
%{__install} -m 0644  \
	"%{_topdir}/../src/etc-profile.d-pingssh.sh"  \
	"%{buildroot}%{_sysconfdir}/profile.d/pingssh.sh"     || exit 1



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
