#!/usr/bin/env sh

npm i wavedrom-cli nexe
npx nexe --target linux-x64-10.16.0 -i ./node_modules/wavedrom-cli/wavedrom-cli.js -o /root/linux/wavedrom-cli
npx nexe --target windows-x64-10.16.0 -i ./node_modules/wavedrom-cli/wavedrom-cli.js -o /root/windows/wavedrom-cli
npx nexe --target mac-x64-10.16.0 -i ./node_modules/wavedrom-cli/wavedrom-cli.js -o /root/mac/wavedrom-cli
