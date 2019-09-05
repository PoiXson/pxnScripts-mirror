#!/bin/bash
##===============================================================================
## Copyright (c) 2013-2019 PoiXson, Mattsoft
## <https://poixson.com> <https://mattsoft.net>
## Released under the GPL 3.0
##
## Description: Shell command aliases and shortcuts.
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
# aliases.sh


export PS1='\u@${HOSTNAME%%.*} [\w]\$ '


# cd aliases
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'


# exit/kill aliases
alias e='exit'
alias killall='\killall -v'
alias k='killall'
alias c='clear'
alias kk='konsole && exit $?'
#alias kon='konsole -e su &'


# file aliases
alias rm='\rm -v -i --preserve-root'
alias cp='\cp -v -i'
alias mv='\mv -v -i'
alias cwd='pwd'
alias ccat='clear;cat'
alias untar='\tar -zxvf'
alias scp='scp -C'


# list file aliases
alias ls='\ls -A --color=auto'
alias ll='ls -lhs'

alias ls.='ls -d .*'
alias ll.='ll -d .*'
alias ld='ll -d */'
alias l.='ll.'

alias cls='clear;pwd;ls'
alias cll='clear;pwd;ll'
alias cld='clear;pwd;ld'

alias wll='watch -d -n2 "ls -lshA"'
alias Wll='watch -d -n0.2 "ls -lshA"'

# sort by extension
alias lx='ls -lXB'
# sort by size
alias lk='ls -lSr'


# ch-permission aliases
alias chmod='\chmod -c --preserve-root'
alias chown='\chown -c --preserve-root'
alias chgrp='\chgrp -c --preserve-root'


# parse aliases
alias grep='grep --color=auto'
alias diff='colordiff'


# date/time aliases
alias timenow='\date +"%T"'
alias datenow='\date +"%Y-%m-%d"'
alias datetime='\date +"%Y-%m-%d %T"'
alias dayofyear='\date +"%j"'


# watch aliases
alias W='watch'
alias wfast='watch -n0.2'
alias ww='watch w'
alias memtop='watch -d "free -m;echo;ps aux --sort -rss | head -11"'
alias vtop='virt-top -d 1'
alias httpw='watch -d -n1 /usr/bin/lynx -dump -width 500 http://127.0.0.1/whm-server-status'
alias wdd="watch -n1 killall -v -USR1 dd"
alias wtime='watch -n0.2 date'


# disk space aliases
alias df='\df -h'
alias dfi='\df -i'
alias wdf='watch -d -n1 "df -h;echo;df -i"'
alias cdu='clear;du -sch *'
alias du='\du -h'
alias du1='\du -h --max-depth=1'
alias du2='\du -h --max-depth=2'
alias du3='\du -h --max-depth=3'


# screen aliases
alias screena='screen -x'
alias screenc='screen -mS'


# yum aliases
alias yumy='yum -y'
alias yumup='yum clean all && clear && yum update'
alias yumupy='yumup -y'

#alias kernels='rpm -qav | grep kernel-[2-4] ; echo -ne "Current:\nkernel-" ; uname -r'
alias kernels='CURRENT_KERNEL=`uname -r` ; rpm -qav | grep kernel-[2-4] | sort -V | while read -r LINE ; do if [ "$LINE" == "kernel-$CURRENT_KERNEL" ]; then echo "$LINE <active>" ; else echo "$LINE" ; fi done'


# more tools
alias s='sudo su'
alias S='sudo su -'
alias bmdisk='time dd if=/dev/zero of=$PWD/test.file bs=1M count=10000;ll $PWD/test.file;rm $PWD/test.file'
alias syncmem='\sudo -s -- sh -c "sync && echo 3 > /proc/sys/vm/drop_caches"'
alias synctop='syncmem & htop'
alias hist='clear;history | grep $1'
alias psaux='ps auxf'
alias header='curl -I'
# alias ports='netstat -tulanp'
alias ports='\netstat -nape --inet'


# ping/mtr
alias ping='clear;\ping'
alias pinga='clear;\ping -A -D'
alias ping8='clear;\ping -A -D 8.8.8.8'
if [ -e /usr/sbin/mtr ]; then
	alias mtr='\mtr -4 -b'
	alias mtr8='\mtr -4 -b 8.8.8.8'
fi
alias pssh='pingssh'


# iptables aliases
if [ -e /usr/sbin/iptables ]; then
	alias fwl='\iptables -L -v'
	alias fwf='\iptables -F;iptables -P INPUT ACCEPT;iptables -P OUTPUT ACCEPT;iptables -P FORWARD ACCEPT'
fi


# development
alias countlines='\find . -name "*.java" | xargs wc -l'
if [ -e /usr/bin/mvn ]; then
	alias mvnv='mvn versions:display-dependency-updates'
fi
if [ -e /usr/bin/gem ]; then
	alias gem='gem -V'
fi


# git aliases
if [ -e /usr/bin/git ]; then
	alias gg='/usr/libexec/git-core/git-gui'
	alias gge='gg && exit $?'
	alias gits='clear;git status'
	alias gitm='git mergetool'
fi


# gradle aliases
if [ -e /usr/bin/gradle ]; then
	alias g='clear;gradle --daemon'
	alias ge='clear;gradle --daemon cleanEclipse eclipse'
fi


# iscsi tools
#http://www.server-world.info/en/note?os=Fedora_20&p=iscsi
if [ -e /usr/sbin/tgtadm ]; then
	alias lstgt='clear;tgtadm --mode target --op show'
fi


# zfs aliases
if [ -e /usr/sbin/zpool ]; then
	alias z='zpool iostat -v 2>&1 | sed "/^\s*$/d" ; zpool status 2>&1 | sed "/^\s*$/d" | grep -v errors\:\ No\ known\ data\ errors ; echo ; df -h ; zfs get compressratio 2>&1 | grep --invert-match --color=none 1.00'
	alias wz='watch "zpool iostat -v 2>&1 | sed \"/^\s*$/d\" ; zpool status 2>&1 | sed \"/^\\s*$/d\" | grep -v \"errors: No known data errors\" ; echo ; df -h ; zfs get compressratio 2>&1 | grep --invert-match --color=none 1.00"'
	alias zfree='watch -n0.5 zpool get freeing'
	alias zfrag='zpool get fragmentation'
	# snapshot aliases
	alias snapshots='clear;zfs list -t snapshot'
	alias snaps='snapshots'
	alias wsnaps='watch -d -n10 "snapshots;echo;df -h"'
	alias wsnap='wsnaps'
fi
#alias zstatus='zpool status -x'


# shutdown/reboot
alias reboot='echo ; hostname ; ip addr show | grep --color=never "inet " | grep -v "127.0.0.1" | awk '"'"'{print $2}'"'"' ; yesno.sh "Reboot?"   --timeout 10 --default y && shutdown -r now'
alias stop='echo ; hostname ; ip addr show | grep --color=never "inet " | grep -v "127.0.0.1" | awk '"'"'{print $2}'"'"' ; yesno.sh "Shutdown?" --timeout 10 --default y && shutdown -h now'
