#/bin/sh

# Copyright 2022 - 2023, macmpi
# SPDX-License-Identifier: MIT

## collection of few code snippets as sample unnatteded actions some may find usefull


## Obvious one; reminder: is run in the background
echo hello world !!
sleep 60

########################################################


## This snippet removes apkovl file on volume after initial boot
ovl="$( dmesg | grep -o 'Loading user settings from .*:' | awk '{print $5}' | sed 's/:.*$//' )"
ovlpath="$( dirname "$ovl" )"

# also works in case volume is mounted read-only
grep -q "${ovlpath}.*[[:space:]]ro[[:space:],]" /proc/mounts; RO=$?
[ "$RO" -eq "0" ] && mount -o remount,rw "${ovlpath}"
rm -f "${ovl}"
[ "$RO" -eq "0" ] && mount -o remount,ro "${ovlpath}"

########################################################


## This snippet configures Minimal diskless environment
# note: with INTERFACESOPTS=none, no networking will be setup so it won't work after reboot!
# Change it or run setup-interfaces in interractive mode afterwards (and lbu commit -d thenafter)

logger -st ${0##*/} "Setting-up minimal environment"

cat <<-EOF > /tmp/ANSWERFILE
	# base answer file for setup-alpine script

	# Do not set keyboard layout
	KEYMAPOPTS="us us-alt-intl"

	# Keep hostname
	HOSTNAMEOPTS="$(hostname)"

	# Set device manager to mdev
	DEVDOPTS=mdev

	# Contents of /etc/network/interfaces
	INTERFACESOPTS="auto lo
	iface lo inet loopback

	auto wlan0
	iface wlan0 inet dhcp
	"

	# Set Public nameserver
	# DNSOPTS=none

	# Set timezone to UTC
	TIMEZONEOPTS="Europe/Paris"

	# set http/ftp proxy
	PROXYOPTS=none

	# Add first mirror (CDN)
	APKREPOSOPTS="-1"

	# Create user 
	USEROPTS="-a -u -g adm,audio,video,netdev chris"
	USERSSHKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzj7q1asEas4B14SZxmjrNdGm4V7v40NhTKCid5WWbR christophe@symphorines.home"

	# OpenSSH
	SSHDOPTS=openssh
	ROOTSSHKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzj7q1asEas4B14SZxmjrNdGm4V7v40NhTKCid5WWbR christophe@symphorines.home"


	# Use openntpd
	NTPOPTS="chrony"

	# No disk install (diskless)
	DISKOPTS=none

	# Setup storage for diskless (find boot directory in /media/xxxx/apk/.boot_repository)
	LBUOPTS="$( find /media -maxdepth 3 -type d -path '*/.*' -prune -o -type f -name '.boot_repository' -exec dirname {} \; | head -1 | xargs dirname )"
	APKCACHEOPTS="\$LBUOPTS/cache"

	EOF

# trick setup-alpine to pretend existing SSH connection
# and therefore keep (do not reset) network interfaces while running in background
SSH_CONNECTION="FAKE" setup-alpine -ef /tmp/ANSWERFILE
lbu commit -d

########################################################


logger -st ${0##*/} "Finished unattended script"

