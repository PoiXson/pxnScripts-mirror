Name    : shellscripts
Version : 1.5.%{?build_number}%{!?build_number:x}
Release : 1
Summary : A collection of commonly used shell scripts
Group   : Base System/System Tools

Requires  : bash, perl, screen, wget, curl, rsync, zip, unzip, grep
#dialog
Requires  : devscripts, aliasscripts, pingssh
Conflicts : shellscripts-dev

BuildArch : noarch
Packager  : PoiXson <support@poixson.com>
License   : GPL 3.0
URL       : https://poixson.com/

Prefix: %{_bindir}/shellscripts
%define _rpmfilename  %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm



%package -n devscripts
Summary  : A collection of commonly used shell scripts (for development)
Requires : shellscripts

%package -n aliasscripts
Summary  : A collection of shell command aliases.

%package -n pingssh
Summary  : Pings a remote host until it's able to connect with ssh.



%description
A collection of commonly used shell scripts for CentOS and Fedora.

%description -n devscripts
A collection of commonly used shell scripts for CentOS and Fedora. (for development)

%description -n aliasscripts
A collection of shell command aliases.

%description -n pingssh
Pings a remote host until it's able to connect with ssh.



### Install ###
%install
echo
echo "Install.."
# delete existing rpm's
%{__rm} -fv "%{_rpmdir}/%{name}-"*.rpm
# create directories
%{__install} -d \
	"%{buildroot}%{prefix}/"  \
	"%{buildroot}%{_sysconfdir}/profile.d/"  \
		|| exit 1
# copy files
\pushd "%{_topdir}/../" || exit 1
	%{__install}  src/*.sh  "%{buildroot}%{prefix}/"  || exit 1
	%{__install}  src/*.pl  "%{buildroot}%{prefix}/"  || exit 1
	# TODO: remove this file?
	%{__rm} -fv "%{buildroot}%{prefix}/install-zfs.sh"
\popd
# create symlinks
%{__ln_s} -f  "%{prefix}/build-rpm.sh"        "%{buildroot}%{_bindir}/build-rpm"
%{__ln_s} -f  "%{prefix}/chmodr.sh"           "%{buildroot}%{_bindir}/chmodr"
%{__ln_s} -f  "%{prefix}/chownr.sh"           "%{buildroot}%{_bindir}/chownr"
%{__ln_s} -f  "%{prefix}/ethtop.sh"           "%{buildroot}%{_bindir}/ethtop"
%{__ln_s} -f  "%{prefix}/forever.sh"          "%{buildroot}%{_bindir}/forever"
%{__ln_s} -f  "%{prefix}/iptop.pl"            "%{buildroot}%{_bindir}/iptop"
%{__ln_s} -f  "%{prefix}/mklinkrel.sh"        "%{buildroot}%{_bindir}/mklinkrel"
%{__ln_s} -f  "%{prefix}/monitorhost.sh"      "%{buildroot}%{_bindir}/monitorhost"
%{__ln_s} -f  "%{prefix}/pingssh.sh"          "%{buildroot}%{_bindir}/pingssh"
%{__ln_s} -f  "%{prefix}/progresspercent.sh"  "%{buildroot}%{_bindir}/progresspercent"
%{__ln_s} -f  "%{prefix}/sshkeygen.sh"        "%{buildroot}%{_bindir}/sshkeygen"
%{__ln_s} -f  "%{prefix}/timestamp.sh"        "%{buildroot}%{_bindir}/timestamp"
%{__ln_s} -f  "%{prefix}/workspace.sh"        "%{buildroot}%{_bindir}/workspace"
%{__ln_s} -f  "%{prefix}/yesno.sh"            "%{buildroot}%{_bindir}/yesno"
# create profile.d symlink
%{__ln_s} -f  "%{prefix}/profile.sh"  "%{buildroot}%{_sysconfdir}/profile.d/shellscripts.sh"



### Files ###
%files
%defattr(0555, root, root, 0755)
%dir %{prefix}/
%{prefix}/chmodr.sh
%{prefix}/chownr.sh
%{prefix}/common.sh
%{prefix}/ethtop.sh
%{prefix}/forever.sh
%{prefix}/iptop.pl
%{prefix}/mklinkrel.sh
%{prefix}/monitorhost.sh
%{prefix}/progresspercent.sh
%{prefix}/sshkeygen.sh
%{prefix}/timestamp.sh
%{prefix}/yesno.sh
# symlinks
%{_bindir}/chmodr
%{_bindir}/chownr
%{_bindir}/ethtop
%{_bindir}/forever
%{_bindir}/iptop
%{_bindir}/mklinkrel
%{_bindir}/monitorhost
%{_bindir}/progresspercent
%{_bindir}/sshkeygen
%{_bindir}/timestamp
%{_bindir}/yesno



%files -n devscripts
%defattr(-,root,root,-)
%{prefix}/build-rpm.sh
%{prefix}/workspace.sh
%{_bindir}/build-rpm
%{_bindir}/workspace

%files -n aliasscripts
%defattr(-,root,root,-)
%{prefix}/aliases.sh
%{prefix}/profile.sh
%{_sysconfdir}/profile.d/shellscripts.sh

%files -n pingssh
%defattr(-,root,root,-)
%{prefix}/pingssh.sh
%{_bindir}/pingssh
