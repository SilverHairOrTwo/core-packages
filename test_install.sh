
#!/bin/bash

cd "$(dirname "$0")"
rm -rf ./test-rootfs && mkdir -p ./test-rootfs
BASED_NONINTERACTIVE=true DESTDIR=./test-rootfs ./based/.based_build/pkg/contents/usr/bin/based install **/*.based.tgz
