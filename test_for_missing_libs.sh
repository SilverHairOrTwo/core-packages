#!/bin/bash

cd "$(dirname "$0")"

COMMAND_PREFIX='chroot ./test-rootfs'

if [[ ! "$EUID" -eq 0 ]]; then
  COMMAND_PREFIX='unshare -UrR ./test-rootfs --'
fi

$COMMAND_PREFIX bash -c 'for i in /usr/bin/*; do if printf "%s\n" "$(ldd "$i" 2>/dev/null)" | grep -q "not found"; then echo "$i"; fi; done'
