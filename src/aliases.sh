#!/usr/bin/bash
##==============================================================================
## Copyright (c) 2013-2022 Mattsoft/PoiXson
## <https://mattsoft.net> <https://poixson.com>
## Released under the AGPL 3.0
##
## Description: Shell command aliases and shortcuts.
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU Affero General Public License as
## published by the Free Software Foundation, either version 3 of the
## License, or (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Affero General Public License for more details.
##
## You should have received a copy of the GNU Affero General Public License
## along with this program.  If not, see <https://www.gnu.org/licenses/>.
##==============================================================================
# aliases.sh


export PS1='\u@${HOSTNAME%%.*} [\w]\$ '


alias c='clear'
alias e='exit'
alias w='w -f'

# compression enabled
alias scp='scp -C'


# cd aliases
alias ~='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias .6='cd ../../../../../..'


# file handling
alias rm='\rm -v -i --preserve-root'
alias cp='\cp -v -i'
alias mv='\mv -v -i'
alias cwd='pwd'
alias ccat='clear;cat'
alias untar='\tar -zxvf'


# list files
alias ls='\ls -A --color=auto'
alias ll='ls -lhs'

alias ll.='ll -d .*'
alias ld='ll -d */'
alias l.='ll.'

alias cls='clear;pwd;ls'
alias cll='clear;pwd;ll'
alias cld='clear;pwd;ld'

# sort by extension
alias lx='ls -lXB'
# sort by size
alias lk='ls -lSr'


# ch-permission aliases
alias chmod='\chmod -c --preserve-root'
alias chown='\chown -c --preserve-root'
alias chgrp='\chgrp -c --preserve-root'


# parse
alias grep='grep --color=auto'
alias diff='colordiff'


# date/time aliases
alias timenow='\date +"%T"'
alias datenow='\date +"%Y-%m-%d"'
alias datetime='\date +"%Y-%m-%d %T"'
alias dayofyear='\date +"%j"'


# watch aliases
alias W='watch -n 0.2'
alias ww='watch -d w'
alias wll='watch -d -n 2   "ls -lshA"'
alias Wll='watch -d -n 0.2 "ls -lshA"'
alias wtime='watch -n0.2 date'
alias wip='watch "ip addr | grep inet | sort"'


# iotop
if [[ -e /usr/sbin/iotop-c ]]; then
	alias iotop='iotop-c'
fi


# memory
alias memtop='watch -d "free -m;echo;ps aux --sort -rss | head -11"'
alias syncmem='\sudo -s -- sh -c "sync && echo 3 > /proc/sys/vm/drop_caches"'
alias synctop='syncmem & htop'


# disk space aliases
alias df='\df -h'
alias dfi='\df -i'
alias wdf='\watch -d -n5 "df -h;echo;df -i"'
alias cdu='clear;du -sch *'
alias du='\du -h'
alias du1='\du -h --max-depth=1'
alias du2='\du -h --max-depth=2'
alias du3='\du -h --max-depth=3'
alias mnt='\mount | column -t'


# list paths
alias paths='echo -e ${PATH//:/\\n}'


# screen aliases
alias screena='screen -x'
alias screenc='screen -mS'


# yum aliases
alias yumrepo='yum --disablerepo="*" --enablerepo='
alias yumy='yum -y'
alias yumup='yum clean all && clear && yum update'
alias yumupy='yumup -y'


#alias kernels='rpm -qav | grep kernel-[2-4] ; echo -ne "Current:\nkernel-" ; uname -r'
alias kernels='CURRENT_KERNEL=`uname -r` ; rpm -qav | grep kernel-[2-6] | sort -V | while read -r LINE ; do if [ "$LINE" == "kernel-$CURRENT_KERNEL" ]; then echo "$LINE <active>" ; else echo "$LINE" ; fi done'


# more tools
alias dd='dd status=progress'
alias bmdisk='WDIR=$(\pwd);time dd if=/dev/zero of=$WDIR/test.file bs=1M count=10000;ll $WDIR/test.file;rm $WDIR/test.file'
alias vtop='virt-top -d 2'
alias hist='clear;\history | grep $1'
alias psaux='ps auxf'
alias header='curl -I'
# alias ports='\netstat -tulanp'
alias ports='\netstat -nape --inet'
alias nmon='echo -n "cd" | nmon'
alias wttr='clear;\curl wttr.in'
alias calce='clear ; calc ; exit'
#alias httpw='watch -d -n1 /usr/bin/lynx -dump -width 500 http://127.0.0.1/whm-server-status'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# ffmpeg
alias ffmpeg_extract_audio='\ffmpeg -i "$1" -vn -ar 44100 -ac 2 -ab 192k -f mp3 "$1".mp3'
alias ffmpeg_replace_audio='\ffmpeg -i "$1" -i "$1".wav -c:v copy -map 0:v:0 -map 1:a:0 "$1"-new.mp4'


# ping/mtr
alias ping='clear;ping'
alias pinga='clear;\ping -A -D'
alias ping8='clear;\ping -A -D 8.8.8.8'
if [ -e /usr/sbin/mtr ]; then
	alias mtr='\mtr -4 -b'
	alias mtr8='\mtr -4 -b 8.8.8.8'
fi


# iptables aliases
if [ -e /usr/sbin/iptables ]; then
	alias fwl='/usr/sbin/iptables -L -v'
	alias fwf='/usr/sbin/iptables -F; /usr/sbin/iptables -P INPUT ACCEPT; /usr/sbin/iptables -P OUTPUT ACCEPT; /usr/sbin/iptables -P FORWARD ACCEPT'
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


alias valg='valgrind --leak-check=yes'


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
	# snapshots
	alias snapshots='clear;zfs list -t snapshot'
	alias snaps='snapshots'
	alias wsnaps='watch -d -n10 "snapshots;echo;df -h"'
	alias wsnap='wsnaps'
fi
#alias zstatus='zpool status -x'


alias killall='\killall -v'

# shutdown/reboot
if [[ -e /usr/bin/yesno ]]; then
	alias reboot='echo ; hostname ; ip addr show | grep --color=never "inet " | grep -v "127.0.0.1" | awk '"'"'{print $2}'"'"' ; echo ; w ; yesno "Reboot?"   --timeout 10 --default n && shutdown -r now'
	alias stop='echo ; hostname ; ip addr show | grep --color=never "inet " | grep -v "127.0.0.1" | awk '"'"'{print $2}'"'"' ; echo ; w ; yesno "Shutdown?" --timeout 10 --default n && shutdown -h now'
fi
