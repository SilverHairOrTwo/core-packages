# core-packages

This repository contains the packaging for all of the core utilities shipped in Project Based.

## Usage

To build all of the packages in this repository and generate a rootfs, you may run the command below:

```bash
./test_install.sh --build
```

This command will build a rootfs under the directory `./test_rootfs/`, in addition to building each package (any built packages can be found within their corresponding directories).

Since this is quite a time-consuming process, it is recommended that once you've built all of the packages in this repository at least once, you manually rebuild any package that has received updates and then call `./test_install.sh` (without the `--build` option), instead of rebuilding all of the packages every single time.

To build `xz` (and generate a rootfs with it) for instance, you would run (this command requires you to have run `./test_install.sh --build` at least once):

```bash
cd xz && ../based/.based_build/pkg/contents/usr/bin/based build && cd ..; ./test_install.sh
```

## Testing the built rootfs

You can run `./test_install.sh` with the `--chroot` flag; for instance, if you've already run `./test_install.sh --build` at least once, you could run:

```bash
./test_install.sh --chroot
```

You can also test the installation of a package with `based`. As an example, you could build the `hello` package (on the host system) and copy it to `./test_rootfs/`, following which you can attempt to install it with `based install` (within the chroot environment, which you can enter by running the command above).
