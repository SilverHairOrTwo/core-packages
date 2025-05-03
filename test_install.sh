#!/bin/bash

cd "$(dirname "$0")"

for arg in "$@"; do
  if [[ "$arg" == "--build" ]]; then
    build_packages="true"
  elif [[ "$arg" == "--chroot" ]]; then
    change_root="true"
  elif [[ "$arg" == "--no-gen-rootfs" ]]; then
    no_gen_rootfs="true"
  fi
done

if [[ "$no_gen_rootfs" != "true" ]]; then
  rm -rf ./test-rootfs || {
    echo "e: unable to delete old rootfs"
    echo "   try running as root."
    exit 1
  }
  mkdir -p ./test-rootfs
fi

if [[ "$build_packages" == "true" ]]; then
  if [[ "$EUID" -eq 0 ]] && [[ ! -z "$SUDO_USER" ]]; then
    SUDO_COMMAND="sudo -u ${SUDO_USER}"
  fi

  rm -rf ./.based_build && $SUDO_COMMAND mkdir -p ./.based_build
  $SUDO_COMMAND wget -O ./.based_build/based-build https://github.com/SilverHairOrTwo/based/raw/refs/heads/main/based-build
  $SUDO_COMMAND chmod 755 ./.based_build/based-build

  for pkg in ./*/; do
    pushd "$pkg"
    $SUDO_COMMAND ../.based_build/based-build || {
      echo "e: failed to build package ${pkg}"
      exit 1
    }
    popd
  done
fi

if [[ "$no_gen_rootfs" != "true" ]]; then
  BASED_NONINTERACTIVE=true DESTDIR=./test-rootfs ./based/.based_build/pkg/contents/usr/bin/based install **/*.based.tgz
fi

if [[ "$change_root" == "true" ]]; then
  if which systemd-nspawn &>/dev/null; then
    COMMAND_PREFIX='systemd-nspawn -D ./test-rootfs'
  elif which arch-chroot &>/dev/null; then
    COMMAND_PREFIX='arch-chroot ./test-rootfs'
  else
    COMMAND_PREFIX='chroot ./test-rootfs'
  fi

  if [[ ! "$EUID" -eq 0 ]]; then
    COMMAND_PREFIX='unshare -UrR ./test-rootfs --'
  fi

  $COMMAND_PREFIX /usr/bin/bash
fi
