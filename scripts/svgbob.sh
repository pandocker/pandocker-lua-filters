#!/usr/bin/env sh

sudo apt update
sudo apt -y install gcc-mingw-w64
rustup update

rustup target add x86_64-unknown-linux-musl
cargo install svgbob_cli --root=build/linux --target=x86_64-unknown-linux-musl
mv build/linux/bin/svgbob_cli build/svgbob

rustup target add x86_64-pc-windows-gnu
cargo install svgbob_cli --root=build/windows --target=x86_64-pc-windows-gnu
mv build/windows/bin/svgbob_cli.exe build/svgbob.exe

rustup target add x86_64-apple-darwin
cargo install svgbob_cli --root=build/osx --target=x86_64-apple-darwin
mv build/osx/bin/svgbob_cli build/svgbob.bin

ls build
