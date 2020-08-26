#!/usr/bin/env sh

mkdir build
cd build
npm i wavedrom-cli nexe
npx nexe --target linux-x64-10.16.0 -i ./node_modules/wavedrom-cli/wavedrom-cli.js -o /root/build/wavedrom-cli
npx nexe --target windows-x64-10.16.0 -i ./node_modules/wavedrom-cli/wavedrom-cli.js -o /root/build/wavedrom-cli.exe
npx nexe --target mac-x64-10.16.0 -i ./node_modules/wavedrom-cli/wavedrom-cli.js -o /root/build/wavedrom-cli.bin
