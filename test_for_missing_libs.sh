#!/bin/bash

for i in /usr/bin/*; do if printf '%s\n' "$(ldd "$i" 2>/dev/null)" | grep -q 'not found'; then echo "$i"; fi; done
