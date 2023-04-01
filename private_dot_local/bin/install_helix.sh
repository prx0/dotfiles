#!/usr/bin/env bash

set -eo pipefail

if rustc -v;then
  echo -e "rust is already installed"
else
  "Please install rust using rustup"
  exit 1
fi

DEV_DIR=""

if [[ -d "~/Dev" ]]; then
  DEV_DIR="~/Dev"
elif [[ -d "~/dev" ]]; then
  DEV_DIR="~/dev"
else
  DEV_DIR="~/dev"
fi

mkdir -p "${DEV_DIR}" && cd "${DEV_DIR}"
git clone https://github.com/helix-editor/helix && cd helix
cargo install --path helix-term --locked
mkdir -p "~/.config/helix"
ln -s "${PWD}/runtime" ~/.config/helix/runtime
cp contrib/Helix.desktop ~/.local/share/applications
cp contrib/helix.png ~/.local/share/icons

sed -i "s|Terminal=true|Terminal=false|g" ~/.local/share/applications/Helix.desktop
sed -i "s|Exec=hx %F|Exec=alacritty --command hx %F|g" ~/.local/share/applications/Helix.desktop
cd -

# You don’t have to use ~/.local/bin, any other path like ~/.cargo/bin or /usr/local/bin will work just as well.
#
# Alternatively, you can install it from source using the command below. You’ll need the latest stable version of the Rust toolchain.
git clone https://github.com/rust-lang/rust-analyzer.git && cd rust-analyzer
cargo xtask install --server
cd -
# If your editor can’t find the binary even though the binary is on your $PATH,
# the likely explanation is that it doesn’t see the same $PATH as the shell, 
# see this issue. On Unix, running the editor from a shell or 
# changing the .desktop file to set the environment should help.

rustup component add rust-analyzer
# However, in contrast to component add clippy or component add rustfmt,
# this does not actually place a rust-analyzer binary in ~/.cargo/bin,
# see this issue. You can find the path to the binary using:
rustup which --toolchain stable rust-analyzer