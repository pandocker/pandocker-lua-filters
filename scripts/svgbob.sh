#!/usr/bin/env sh

apt update
apt -y install gcc-mingw-w64
rustup update

rustup target add x86_64-unknown-linux-musl
cargo install --force svgbob_cli --root=build/linux --target=x86_64-unknown-linux-musl
mv build/linux/bin/svgbob build/svgbob

rustup target add x86_64-pc-windows-gnu
cargo install --force svgbob_cli --root=build/windows --target=x86_64-pc-windows-gnu
mv build/windows/bin/svgbob build/svgbob.exe

rustup target add x86_64-apple-darwin
cargo install --force svgbob_cli --root=build/osx --target=x86_64-apple-darwin
mv build/osx/bin/svgbob build/svgbob.bin

ls build
