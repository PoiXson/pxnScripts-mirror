Name    : shellscripts
Version : 2.0.%{?build_number}%{!?build_number:x}
Release : 1
Summary : A collection of commonly used shell scripts

Requires  : bash, perl, screen, wget, curl, rsync, zip, unzip, grep

BuildArch : noarch
Packager  : PoiXson <support@poixson.com>
License   : GPLv3
URL       : https://poixson.com/

Prefix: %{_bindir}/pxn/scripts
%define _rpmfilename  %%{NAME}-%%{VERSION}-%%{RELEASE}.%%{ARCH}.rpm

%description
A collection of commonly used shell scripts for CentOS and Fedora.



### Install ###
%install
echo
echo "Install.."

# delete existing rpm's
%{__rm} -fv --preserve-root  "%{_rpmdir}/%{name}-"*.rpm

# create dirs
%{__install} -d -m 0755  "%{buildroot}%{prefix}/"                 || exit 1
%{__install} -d -m 0755  "%{buildroot}%{_sysconfdir}/profile.d/"  || exit 1

# copy files
%{__install} -m 0644  "%{_topdir}/../src/"*.sh  "%{buildroot}%{prefix}/"  || exit 1
%{__install} -m 0644  "%{_topdir}/../src/"*.pl  "%{buildroot}%{prefix}/"  || exit 1

# create symlinks
%{__ln_s} -f  "%{prefix}/chmodr.sh"       "%{buildroot}%{_bindir}/chmodr"       || exit 1
%{__ln_s} -f  "%{prefix}/chownr.sh"       "%{buildroot}%{_bindir}/chownr"       || exit 1
%{__ln_s} -f  "%{prefix}/ethtop.sh"       "%{buildroot}%{_bindir}/ethtop"       || exit 1
%{__ln_s} -f  "%{prefix}/iptop.pl"        "%{buildroot}%{_bindir}/iptop"        || exit 1
%{__ln_s} -f  "%{prefix}/mklinkrel.sh"    "%{buildroot}%{_bindir}/mklinkrel"    || exit 1
%{__ln_s} -f  "%{prefix}/monitorhost.sh"  "%{buildroot}%{_bindir}/monitorhost"  || exit 1
%{__ln_s} -f  "%{prefix}/pingssh.sh"      "%{buildroot}%{_bindir}/pingssh"      || exit 1
%{__ln_s} -f  "%{prefix}/sshkeygen.sh"    "%{buildroot}%{_bindir}/sshkeygen"    || exit 1
%{__ln_s} -f  "%{prefix}/timestamp.sh"    "%{buildroot}%{_bindir}/timestamp"    || exit 1
%{__ln_s} -f  "%{prefix}/yesno.sh"        "%{buildroot}%{_bindir}/yesno"        || exit 1
# create profile.d symlink
%{__ln_s} -f  "%{prefix}/profile.sh"  "%{buildroot}%{_sysconfdir}/profile.d/shellscripts.sh"  || exit 1



### Files ###
%files
%defattr(0555, root, root, 0755)
%dir %{prefix}/
%{prefix}/aliases.sh
%{prefix}/chmodr.sh
%{prefix}/chownr.sh
%{prefix}/common.sh
%{prefix}/defines.sh
%{prefix}/colors.sh
%{prefix}/ethtop.sh
%{prefix}/iptop.pl
%{prefix}/mklinkrel.sh
%{prefix}/monitorhost.sh
%{prefix}/pingssh.sh
%{prefix}/profile.sh
%{prefix}/sshkeygen.sh
%{prefix}/timestamp.sh
%{prefix}/yesno.sh
# symlinks
%{_bindir}/chmodr
%{_bindir}/chownr
%{_bindir}/ethtop
%{_bindir}/iptop
%{_bindir}/mklinkrel
%{_bindir}/monitorhost
%{_bindir}/pingssh
%{_bindir}/sshkeygen
%{_bindir}/timestamp
%{_bindir}/yesno
%{_sysconfdir}/profile.d/shellscripts.sh
