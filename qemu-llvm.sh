#!/bin/bash

cd /afl-2.33b/llvm_mode
LLVM_CONFIG=llvm-config-3.8 make
cd ../
make install

#build qemu

#cd /afl-2.33b/qemu_mode/ && ./build_qemu_support.sh

